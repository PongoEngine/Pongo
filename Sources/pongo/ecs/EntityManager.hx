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

