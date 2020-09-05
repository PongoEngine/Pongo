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

