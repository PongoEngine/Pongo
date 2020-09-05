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
        var newComp = ENew({name: "Component", pack: ["pongo","ecs"]}, [expr, name]).toExpr();
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