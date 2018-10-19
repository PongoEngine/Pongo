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

import pongo.util.Signal1;
import pongo.ecs.ds.RuleSet;
import pongo.ecs.ds.EntityList;

@:final class Group
{
    public var rules (default, null):RuleSet;
    public var changed (default, null) :Signal1<Entity>;

    public function new(rules :RuleSet) : Void
    {
        this.rules = rules;
        _list = new EntityList();
        _listChanged = new EntityList();
        changed = new Signal1<Entity>();
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
    private function addChanged(entity :Entity) : Bool
    {
        return _listChanged.add(entity);
    }

    @:allow(pongo.ecs.Manager)
    private function add(entity :Entity) : Bool
    {
        return _list.add(entity);
    }

    @:allow(pongo.ecs.Manager)
    private function remove(entity :Entity) : Bool
    {
        return _list.remove(entity);
    }

    @:allow(pongo.ecs.Manager)
    private function updateChanged() : Void
    {
        var p = _listChanged.head;
        while(p != null) {
            changed.emit(p.entity);
            p = p.next;
        }
        _listChanged.clear();
    }

    private var _list :EntityList;
    private var _listChanged :EntityList;
}