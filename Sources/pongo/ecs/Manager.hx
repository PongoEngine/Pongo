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
import pongo.ecs.Group;
import pongo.util.Disposable;
import pongo.ecs.ds.RuleSet;
using pongo.util.StringUtil;

@:final class Manager
{
    /**
     * [Description]
     */
    @:allow(pongo.ecs.Engine)
    private function new() : Void
    {
        _keys = new Array<Int>();
        _groups = new Map<Int, Group>();
    }

    /**
     * [Description]
     * @return Entity
     */
    public function createEntity() : Entity
    {
        return new Entity(this);
    }

    @:allow(pongo.ecs.Entity)
    private function notifyChange(entity :Entity) : Void
    {
        // trace("change happened: " +  entity.index);
    }

    @:allow(pongo.ecs.Entity)
    private function notifyAddComponent(entity :Entity, component :Component) : Void
    {
        for(key in _keys) {
            var rules = _groups.get(key).rules;
            var group = _groups.get(key);
            if(entity.hasAllRules(rules)) {
                group.add(entity);
            }
        }
    }

    @:allow(pongo.ecs.Entity)
    private function notifyRemoveComponent(entity :Entity, name :String) : Void
    {
        for(key in _keys) {
            var rules = _groups.get(key).rules;
            var group = _groups.get(key);
            if(entity.hasAllRules(rules)) {
                group.remove(entity);
            }
        }
    }

    @:allow(pongo.ecs.Entity)
    private function notifyAddEntity(entity :Entity) : Void
    {
        for(key in _keys) {
            var rules = _groups.get(key).rules;
            var group = _groups.get(key);
            if(entity.hasAllRules(rules)) {
                group.add(entity);
            }
        }
    }

    @:allow(pongo.ecs.Entity)
    private function notifyRemoveEntity(entity :Entity) : Void
    {
        for(key in _keys) {
            var rules = _groups.get(key).rules;
            var group = _groups.get(key);
            if(entity.hasAllRules(rules)) {
                group.remove(entity);
            }
        }
    }

    @:allow(pongo.ecs.Engine)
    private function createGroup(classNames :Array<String>) : Group
    {
        var key = classNames.keyFromStrings();
        if(!_groups.exists(key)) {
            _groups.set(key, new Group(RuleSet.fromArray(classNames)));
            _keys.push(key);
        }
        return _groups.get(key);
    }

    private var _keys :Array<Int>;
    private var _groups :Map<Int, Group>;
}