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

package pongo.ecs.manager;

import pongo.ecs.Entity;
import pongo.ecs.group.SourceGroup;
import pongo.ecs.group.Rules;
using pongo.util.StringUtil;

#if macro
import haxe.macro.Expr;
#end

class Manager
{
    public function new() : Void
    {
        managedGroup = new ManagedGroup();
    }

    public function notifyAdd(entity :Entity) : Void
    {
        managedGroup.handle(entity, function(group) {
            group.add(entity);
            group.queueChanged(entity);
        });
    }

    public function notifyRemove(entity :Entity) : Void
    {
        managedGroup.handle(entity, function(group) {
            group.remove(entity);
        });
    }

    public function notifyChanged(entity :Entity) : Void
    {
        managedGroup.handle(entity, function(group) {
            group.queueChanged(entity);
        });
    }

    macro public function registerGroup(self:Expr, classes :ExprOf<Array<Class<Component>>>) :ExprOf<SourceGroup>
    {
        return switch (classes.expr) {
            case EArrayDecl(vals): {
                macro $self.managedGroup.createGroupFromClassNames(cast $a{vals.map(function(v) {
                    return macro $v.COMPONENT_NAME;
                })});
            }
            case _: macro throw "err";
        }
    }

    public inline function update() : Void
    {
        managedGroup.update();
    }

    public var managedGroup (default, null) : ManagedGroup;
}