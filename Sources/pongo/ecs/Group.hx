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

import pongo.ecs.ds.RuleSet;
import pongo.ecs.ds.EntityList;
import pongo.ecs.ds.EntityList.EntityNode;

@:final class Group
{
    public var rules (default, null):RuleSet;

    public function new(rules :RuleSet) : Void
    {
        this.rules = rules;
        _entityMap = new Map<Int,EntityNode>();
        _list = new EntityList();
    }

    public function first() : Entity
    {
        if(_list.head == null) return null;
        return _list.head.entity;
    }

    public function last() : Entity
    {
        if(_list.tail == null) return null;
        return _list.tail.entity;
    }

    public function manipulateAll(fn :Entity -> Void) : Void
    {
        var p = _list.head;
        while(p != null) {
            fn(p.entity);
            p = p.next;
        }
    }

    @:allow(pongo.ecs.Manager)
    private function add(entity :Entity) : Void
    {
        if(!_entityMap.exists(entity.index)) {
            var node = new EntityNode(entity);
            _list.add(node);
            _entityMap.set(entity.index, node);
        }
    }

    @:allow(pongo.ecs.Manager)
    private function remove(entity :Entity) : Bool
    {
        if(!_entityMap.exists(entity.index)) {
            var node = _entityMap.get(entity.index);
            _list.remove(node);
            _entityMap.remove(entity.index);
            return true;
        }
        return false;
    }

    private var _entityMap:Map<Int,EntityNode>;
    private var _list :EntityList;
}