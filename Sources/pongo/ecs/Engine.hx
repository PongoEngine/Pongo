/*
 * Copyright (c) 2018 Jeremy Meltingtallow
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

import pongo.Pongo;
import pongo.ecs.Manager;
import pongo.ecs.Entity;
import pongo.ecs.Group;
import pongo.display.Graphics;

#if macro
using haxe.macro.ExprTools;
import haxe.macro.TypeTools;
import haxe.macro.Expr;
import haxe.macro.Context;
#end

@:final class Engine
{
    public var root (default, null):Entity;

    public function new() : Void
    {
        _manager = new Manager();
        this.root = this.createEntity();
    }

#if macro
    macro static inline public function getCOMPONENT_NAME<T:Component>(componentClass :ExprOf<Class<T>>) :ExprOf<String>
    {
        return macro $componentClass.COMPONENT_NAME;
    }
#end

    macro public function registerGroup(self:Expr, componentClass :ExprOf<Array<Class<Component>>>) :ExprOf<Group>
    {
        return switch (componentClass.expr) {
            case EArrayDecl(vals): {
                macro $self.registerGroupWithClassNames(cast $a{vals.map(function(v) {
                    return macro $v.COMPONENT_NAME;
                })});
            }
            case _: macro throw "err";
        }
    }

    public function render(graphics: Graphics) : Void
    {
        Engine._render(this.root, graphics);
    }

    public inline function createEntity() : Entity
    {
        return _manager.createEntity();
    }

    public inline function registerGroupWithClassNames(classNames :Array<String>) : Group
    {
        return _manager.createGroup(classNames);
    }

    private static function _render(entity :Entity, g :Graphics) : Void
    {
        if (entity.visual != null) {
            g.save();
            g.transform(entity.visual.getMatrix());
            if(entity.visual.opacity < 1)
                g.multiplyOpacity(entity.visual.opacity);

            if(entity.visual.visible && entity.visual.opacity > 0) {
                entity.visual.draw(g);
            }
        }

        var p = entity.firstChild;
        while (p != null) {
            var next = p.next;
            _render(p, g);
            p = next;
        }

        // If save() was called, unwind it
        if (entity.visual != null) {
            g.restore();
        }
    }

    private var _manager :Manager;
}