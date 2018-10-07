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

import pongo.util.Disposable;
import pongo.ecs.ds.RuleSet;

@:final class GroupedEntity implements Disposable
{
    public var entities (get, null):Iterator<Entity>;
    public var rules (default, null):RuleSet;

    /**
     * [Description]
     * @param rules 
     */
    public function new(rules :RuleSet) : Void
    {
        this.rules = rules;
        _entityMap = new Map<Int,Entity>();
    }

    /**
     * [Description]
     */
    public function dispose() : Void
    {
        _entityMap = new Map<Int,Entity>();
    }

    /**
     * [Description]
     * @param entity 
     * @return Bool
     */
    public function exists(entity :Entity) : Bool
    {
        return _entityMap.exists(entity.index);
    }

    @:allow(pongo.ecs.Manager)
    private function addEntity(entity :Entity) : Void
    {
        _entityMap.set(entity.index, entity);
    }

    @:allow(pongo.ecs.Manager)
    private function removeEntity(entity :Entity) : Void
    {
        _entityMap.remove(entity.index);
    }

    private function get_entities() : Iterator<Entity>
    {
        return _entityMap.iterator();
    }

    private var _entityMap:Map<Int,Entity>;
}