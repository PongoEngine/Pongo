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

class EntityManager
{
    public static var instance (get, null) : EntityManager;

    private static function get_instance() : EntityManager
    {
        if(instance == null) {
            instance = new EntityManager();
        }
        return instance;
    }

    private function new() : Void
    {
        _componentStores = new Map<String, ComponentStore>();
        _systems = [];
    }

    public function createEntity() : Entity
    {
        return new Entity(_entityId++);
    }

    public function update() : Void
    {
        for(system in _systems) {
            for(components in system.entities) {
                Reflect.callMethod(system, system.fn, components);
            }
        }
    }

    public function addComponent(entity :Entity, component :Component<Dynamic>) : Void
    {
        var store = _componentStores.get(component.name);
        if(store == null) {
            store = new ComponentStore();
            _componentStores.set(component.name, store);
        }
        var filters = store.addEntity(entity, component);
        if(filters != null) {
            for(filter in filters) {
                blah(entity, filter);
            }
        }
    }

    private function blah(entity :Entity, filter :Filter) : Void
    {
        if(!filter.entities.exists(entity)) {
            var components = [];
            for(dep in filter.deps) {
                var component = _componentStores.get(dep).getComponent(entity);
                if(component == null) {
                    return;
                }
                else {
                    components.push(component);
                }
            }
            filter.entities.set(entity, components);
        }
    }

    public function removeComponent(entity :Entity, component :Component<Dynamic>) : Void
    {
        var store = _componentStores.get(component.name);
        if(store != null) {
            store.removeEntity(entity);
        } 
    }

    public function registerFilter(components :Array<String>, fn :Dynamic) : Void
    {
        var filter = new Filter(components, fn);
        _systems.push(filter);
        for(component in components) {
            var store = _componentStores.get(component);
            if(store == null) {
                store = new ComponentStore();
                _componentStores.set(component, store);
            }
            store.addFilter(filter);
        }
    }

    private var _componentStores :Map<String, ComponentStore>;
    private var _systems :Array<Filter>;
    private var _entityId = 0;
}

