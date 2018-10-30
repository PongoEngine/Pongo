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

package pongo.ecs.group;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
using haxe.macro.ExprTools;
#end

class SourceGroup implements Group
{
    public var rules (default, null):Rules;
    public var changed (get, null) :ReactiveGroup;
    public var length (get, null):Int;

    public function new(rules :Rules) : Void
    {
        this.rules = rules;
        _list = new EntityList();
        _reactiveGroups = [];
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

    public inline function iterate(fn :Entity -> Void) : Void
    {
        var p = _list.head;
        while(p != null) {
            fn(p.entity);
            p = p.next;
        }
    }

    public function iterateWithEscape(fn :Entity -> Bool) : Void
    {
        var p = _list.head;
        while(p != null) {
            if(fn(p.entity)) {
                return;
            }
            p = p.next;
        }
    }

    public function createReactiveGroup(rule :Entity -> Bool) : ReactiveGroup
    {
        var subGroup = new ReactiveGroup(new Rules(rule));
        _reactiveGroups.push(subGroup);
        return subGroup;
    }

    private function get_changed() : ReactiveGroup
    {
        if(_changed == null) {
            _changed = createReactiveGroup(function(e) return true);
        }
        return _changed;
    }

    @:allow(pongo.ecs.Manager)
    private function queueChanged(entity :Entity) : Void
    {
        if(entity.isDisposed) {
            return;
        }
        for(group in _reactiveGroups) {
            group.queueChanged(entity);
        }
    }

    @:allow(pongo.ecs.Manager)
    private function swapQueue() : Void
    {
        for(group in _reactiveGroups) {
            group.swapQueue();
        }
    }

    @:allow(pongo.ecs.Manager)
    private function add(entity :Entity) : Bool
    {
        return _list.add(entity);
    }

    @:allow(pongo.ecs.Manager)
    private function remove(entity :Entity) : Bool
    {
        for(group in _reactiveGroups) {
            group.remove(entity);
        }
        return _list.remove(entity);
    }

    private function get_length() : Int
    {
        return _list.size;
    }

    private var _list :EntityList;
    private var _reactiveGroups :Array<ReactiveGroup>;
    private var _changed :ReactiveGroup = null;
}