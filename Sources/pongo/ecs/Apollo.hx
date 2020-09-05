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