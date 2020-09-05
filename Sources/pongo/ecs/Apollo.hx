package pongo.ecs;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import pongo.ecs.macro.SystemTools;
using haxe.macro.ExprTools;
using pongo.ecs.macro.ExprUtils;
#end

class Apollo<T>
{
    public function new(data :T) : Void
    {
        _data = data;
    }

    public function addEntity(fn :Entity -> Void) : Apollo<T>
    {
        fn(EntityManager.instance.createEntity());
        return this;
    }

    public inline function update() : Void
    {
        EntityManager.instance.update();
    }

    macro public function addSystem(self :Expr, fn :Expr) : ExprOf<Apollo<T>>
    {
        #if macro
        return switch fn.expr {
            case EFunction(kind, f): switch kind {
                case FArrow | FAnonymous:
                    for(arg in f.args) {
                        if(arg.type == null) {
                            Context.error("Argument must have a type", fn.pos);
                        }
                        else {
                            arg.type = SystemTools.transformArgType(arg.type, fn.pos);
                        }
                    }

                    var components = f.args.map(a -> {
                        SystemTools.typeName(a.type).createDefString().toExpr();
                    }).createDefArrayDecl().toExpr();

                    [components, fn].createDefCallField(self, "__addSystem__").toExpr();
                case _: 
                    throw "not supported yet";
            }
            case _: 
                throw "not supported yet";
        }
        #end
    }

    public function __addSystem__(components :Array<String>, fn :Dynamic) : Apollo<T>
    {
        EntityManager.instance.registerFilter(cast components,fn);
        return this;
    }

    private var _data :T;
}