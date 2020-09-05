package pongo.ecs;

#if macro
import haxe.macro.Expr;
import pongo.ecs.macro.SystemTools;
using haxe.macro.ExprTools;
using pongo.ecs.macro.ExprUtils;
#end

abstract Entity(Int) 
{
    @:allow(pongo.ecs.EntityManager)
    private inline function new(id :Int) : Void
    {
        this = id;
    }

    macro public function addComponent(self :Expr, expr :Expr) : Expr
    {
        #if macro
        var name = SystemTools.exprName(expr).createDefString().toExpr();
        var newComp = ENew({name: "Component", pack: ["apollo"]}, [expr, name]).toExpr();
        return [newComp].createDefCallField(self, "__addComponent__").toExpr();
        #end
    }

    public function removeComponent<T>(component :Component<T>) : Void
    {
        EntityManager.instance.removeComponent(cast this, component);
        component.parent = cast -1;
    }

    public function __addComponent__<T>(component :Component<T>) : Void
    {
        EntityManager.instance.addComponent(cast this, component);
        component.parent = cast this;
    }
}