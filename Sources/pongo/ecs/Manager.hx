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
        _classKeys = new Array<Int>();
        _classGroups = new Map<Int, SourceGroup>();
    }

    public function notifyAdd(entity :Entity) : Void
    {
        handleGroups(entity, _classKeys, _classGroups, function(group) {
            group.add(entity);
            group.queueChanged(entity);
        });
    }

    public function notifyRemove(entity :Entity) : Void
    {
        handleGroups(entity, _classKeys, _classGroups, function(group) {
            group.remove(entity);
        });
    }

    public function notifyChanged(entity :Entity) : Void
    {
        handleGroups(entity, _classKeys, _classGroups, function(group) {
            group.queueChanged(entity);
        });
    }

    private inline function handleGroups<T>(entity :Entity, keys :Array<T>, groups :Map<T, SourceGroup>, fn :SourceGroup -> Void) : Void
    {
        for(key in keys) {
            var group = groups.get(key);
            if(group.rules.satisfy(entity)) {
                fn(group);
            }
        }
    }

    macro public function registerGroup(self:Expr, classes :ExprOf<Array<Class<Component>>>) :ExprOf<SourceGroup>
    {
        return switch (classes.expr) {
            case EArrayDecl(vals): {
                macro $self.createGroup(cast $a{vals.map(function(v) {
                    return macro $v.COMPONENT_NAME;
                })});
            }
            case _: macro throw "err";
        }
    }

    public function createGroup(classNames :Array<String>) : SourceGroup
    {
        var key = classNames.keyFromStrings();
        if(!_classGroups.exists(key)) {
            _classGroups.set(key, new SourceGroup(Rules.fromStrings(classNames)));
            _classKeys.push(key);
        }
        return _classGroups.get(key);
    }

    @:allow(pongo.platform.Pongo) private function update() : Void
    {
        var i = 0;
        while(i < _classKeys.length) {
            _classGroups.get(_classKeys[i]).swapQueue();
            i++;
        }
    }

    private var _classKeys :Array<Int>;
    private var _classGroups :Map<Int, SourceGroup>;
}