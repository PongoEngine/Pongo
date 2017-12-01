/*
 * Copyright (c) 2017 Jeremy Meltingtallow
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
 * Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN
 * AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
 * THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

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