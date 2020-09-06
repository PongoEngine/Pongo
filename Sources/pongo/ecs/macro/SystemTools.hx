/*
 * Copyright (c) 2020 Jeremy Meltingtallow
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

    public static function isDelta(type :ComplexType) : Bool
    {
        return switch type {
            case TPath(p): p.name == "Float";
            case _: false;
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