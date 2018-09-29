package pongo.pecs;

import pongo.pecs.Entity;
import pongo.util.Disposable;

@:final class Manager implements Disposable
{
    @:allow(pongo.pecs.Engine)
    private function new() : Void
    {
        _keys = new Array();
        _groupEntities = new Map<String, EntityGroup>();
    }

    public function createEntity() : Entity
    {
        return new Entity(this);
    }

    @:allow(pongo.pecs.Entity)
    private function notifyAddComponent(entity :Entity) : Void
    {
        for(key in _keys) {
            var rules = _groupEntities.get(key)._rules;
            var group = _groupEntities.get(key);
            if(!group.exists(entity) && hasRules(entity, rules)) {
                group.addEntity(entity);
            }
        }
    }

    @:allow(pongo.pecs.Entity)
    private function notifyRemoveComponent(entity :Entity) : Void
    {
        for(key in _keys) {
            var rules = _groupEntities.get(key)._rules;
            var group = _groupEntities.get(key);
            if(group.exists(entity) && hasRules(entity, rules)) {
                group.removeEntity(entity);
            }
        }
    }

    @:allow(pongo.pecs.Entity)
    private function notifyAddEntity(entity :Entity) : Void
    {
        this.notifyAddComponent(entity);
    }

    @:allow(pongo.pecs.Entity)
    private function notifyRemoveEntity(entity :Entity) : Void
    {
        this.notifyRemoveComponent(entity);
    }

    @:allow(pongo.pecs.Engine)
    private function createGroup(name :String, classNames :Array<String>) : EntityGroup
    {
        if(!_groupEntities.exists(name)) {
            _groupEntities.set(name, new EntityGroup(classNames));
            _keys.push(name);
        }
        return _groupEntities.get(name);
    }

    @:allow(pongo.pecs.Engine)
    private function destroyGroup(name :String) : Void
    {
        if(_groupEntities.exists(name)) {
            var entities = _groupEntities.get(name);
            entities.dispose();
            _groupEntities.remove(name);
            _keys.remove(name);
        }
    }

    private function hasRules(entity :Entity, rules :Array<String>) : Bool
    {
        for(rule in rules) {
            if(!entity.hasComponent(rule)) {
                return false;
            }
        }
        return true;
    }

    public function dispose() : Void
    {
        for(key in _keys) {
            destroyGroup(key);
        }
    }

    private var _keys :Array<String>;
    private var _groupEntities :Map<String, EntityGroup>;
}