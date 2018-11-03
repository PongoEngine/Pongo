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

class ReactiveGroup implements Group
{
    public var rules (default, null):Rules;
    public var length (get, null):Int;

    public function new(rules :Rules) : Void
    {
        this.rules = rules;
        _swapList = new SwapEntityList();
    }

    public function first() : Entity
    {
        if(_swapList.active().head == null) return null;
        return _swapList.active().head.entity;
    }

    public inline function iterate(fn :Entity -> Void) : Void
    {
        var p = _swapList.active().head;
        while(p != null) {
            fn(p.entity);
            p = p.next;
        }
    }

    public function iterateWithEscape(fn :Entity -> Bool) : Void
    {
        var p = _swapList.active().head;
        while(p != null) {
            if(fn(p.entity)) {
                return;
            }
            p = p.next;
        }
    }

    @:allow(pongo.ecs.group.SourceGroup)
    private function queueChanged(entity :Entity) : Bool
    {
        if(this.rules.satisfy(entity)) {
            return _swapList.addToQueue(entity);
        }
        return false;
    }

    @:allow(pongo.ecs.group.SourceGroup)
    private function swapQueue() : Void
    {
        _swapList.clearActive();
        _swapList.swap();
    }

    @:allow(pongo.ecs.group.SourceGroup)
    private function remove(entity :Entity) : Void
    {
        _swapList.active().remove(entity);
        _swapList.queued().remove(entity);
    }


    private function get_length() : Int
    {
        return _swapList.active().size;
    }

    private var _swapList :SwapEntityList;
}