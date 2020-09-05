package pongo.ecs.macro;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
using haxe.macro.ExprTools;
using pongo.ecs.macro.ExprUtils;
using haxe.macro.TypeTools;
using haxe.macro.ComplexTypeTools;

class SystemTools
{
    public static function transformArgType(type :ComplexType, pos :Position) : ComplexType
    {
        return switch type {
            case TPath(p):
                if(p.name == "Component") {
                    type;
                }
                else if(p.name == "Data") {
                    switch p.params[0] {
                        case TPType(t): 
                            t;
                        case _:
                            Context.error("Invalid Data type", pos);
                    }
                }
                else {
                    Context.error("Invalid Data type", pos);
                }
            case _:
                Context.error("Invalid Data type", pos);
        }
    }

    public static function exprName(expr :Expr) : String
    {
        return Context.typeof(expr).toString();
    }

    public static function typeName(type :ComplexType) : String
    {
        return switch type {
            case TPath(p):
                if(p.name == "Component") {
                    switch p.params[0] {
                        case TPType(t):
                            t.toType().toString();
                        case TPExpr(e):
                            throw "Not Supported Yet";
                    }
                }
                else {
                    type.toType().toString();
                }
            case _:
                type.toType().toString();
        }
    }
}

#end