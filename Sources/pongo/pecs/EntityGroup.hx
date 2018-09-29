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

package pongo.pecs;

import pongo.util.Disposable;

@:final class EntityGroup implements Disposable
{
    public var entities (get, null):Iterator<Entity>;

    public function new(rules :Array<String>) : Void
    {
        _rules = rules;
        _set = new Map<Int,Entity>();
    }

    public function dispose() : Void
    {
        _set = new Map<Int,Entity>();
    }

    public function exists(entity :Entity) : Bool
    {
        return _set.exists(entity._index);
    }

    @:allow(pongo.pecs.Manager)
    private function addEntity(entity :Entity) : Void
    {
        _set.set(entity._index, entity);
    }

    @:allow(pongo.pecs.Manager)
    private function removeEntity(entity :Entity) : Void
    {
        _set.remove(entity._index);
    }

    private function get_entities() : Iterator<Entity>
    {
        return _set.iterator();
    }

    @:allow(pongo.pecs.Manager)
    private var _rules:Array<String>;
    private var _set:Map<Int,Entity>;
}