package cream.util;

import haxe.macro.Expr;

class EasyAccess
{
    macro public static function getComponent<T:Component>(e:Expr, componentClass :ExprOf<Class<T>>) 
    {
        var componentName = macro $componentClass.COMPONENT_NAME;
        return macro $e.get($componentClass, $componentName);
    }

    macro public static function getGroupEasy(e:Expr, componentClass :ExprOf<Array<Class<Dynamic>>>)
    {
        var cNames = [];
        switch (componentClass.expr) {
            case EArrayDecl(vals): {
                for(val in vals) {
                    cNames.push(macro $val.COMPONENT_NAME);
                }
            }
            case _:
        }

        var xNames = macro $a{cNames};
        var x = macro $e.getGroup($xNames);

        return macro $x;
    }
}