/*
 * Copyright (c) 2020 Jeremy Meltingtallow
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

class ComponentStore
{
    public function new() : Void
    {
        _entityMap = new Map<Entity, Component<Dynamic>>();
        _filters = [];
    }

    public function addFilter(filter :Filter) : Void
    {
        _filters.push(filter);
    }

    public function existsEntity(entity :Entity) : Bool
    {
        return _entityMap.exists(entity);
    }

    public function getComponent(entity :Entity) : Component<Dynamic>
    {
        return _entityMap.get(entity);
    }

    public function addEntity(entity :Entity, component :Component<Dynamic>) : Null<Array<Filter>>
    {
        var isNew = !_entityMap.exists(entity);
        _entityMap.set(entity, component);
        if(isNew) {
            return _filters;
        }
        return null;
    }

    public function removeEntity(entity :Entity) : Bool
    {
        if(_entityMap.exists(entity)) {
            for(filter in _filters) {
                filter.clearGroups();
            }
        }
        return _entityMap.remove(entity);
    }

    private var _entityMap :Map<Entity, Component<Dynamic>>;
    private var _filters :Array<Filter>;
}

