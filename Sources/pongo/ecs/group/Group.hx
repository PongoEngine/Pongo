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

import pongo.util.Signal1;

@:allow(pongo.ecs.group.SourceGroup)
class Group
{
    public var length (get, null):Int;
    public var onAdded (default, null) : Signal1<Entity>;
    public var onRemoved (default, null) : Signal1<Entity>;
    public var onUpdated (default, null) : Signal1<Entity>;

    private function new(rules :Rules) : Void
    {
        _rules = rules;
        _list = new EntityList();
        onAdded = new Signal1();
        onRemoved = new Signal1();
        onUpdated = new Signal1();
    }

    public function first() : Entity
    {
        if(_list.head == null) return null;
        return _list.head.entity;
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

    private function add(entity :Entity) : Bool
    {
        if(_rules.satisfy(entity)) {
            if(_list.add(entity)) {
                onAdded.emit(entity);
                return true;
            }
        }
        return false;
    }

    private function remove(entity :Entity, force :Bool = false) : Bool
    {
        if(force || _rules.satisfy(entity)) {
            if(_list.remove(entity)) {
                onRemoved.emit(entity);
                return true;
            }
        }
        return false;
    }

    private function changed(entity :Entity) : Void
    {
        if(_rules.satisfy(entity)) {
            if(_list.add(entity)) {
                onAdded.emit(entity);
            }
            else {
                onUpdated.emit(entity);
            }
        }
        else {
            if(_list.remove(entity)) {
                onRemoved.emit(entity);
            }
        }
    }

    private function get_length() : Int
    {
        return _list.size;
    }

    private var _list :EntityList;
    private var _rules :Rules;
}