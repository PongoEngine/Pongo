package pongo.pecs;

import pongo.pecs.Entity;
import pongo.util.Disposable;
import pongo.pecs.util.SafeArray;

@:final class Manager implements Disposable
{
    @:allow(pongo.pecs.Engine)
    private function new() : Void
    {
        _keys = new SafeArray();
        _groupRules = new Map<String, SafeArray<String>>();
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
            var rules = _groupRules.get(key);
            var entities = _groupEntities.get(key);
            if(hasRules(entity, rules)) {
                entities.addEntity(entity);
            }
        }
    }

    @:allow(pongo.pecs.Entity)
    private function notifyRemoveComponent(entity :Entity) : Void
    {
        for(key in _keys) {
            var rules = _groupRules.get(key);
            var entities = _groupEntities.get(key);
            if(hasRules(entity, rules)) {
                entities.removeEntity(entity);
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

    @:allow(pongo.pecs.Entity)
    private function returnEntity(entity :Entity) : Void
    {

    }

    @:allow(pongo.pecs.Engine)
    private function createGroup(name :String, classNames :SafeArray<String>) : EntityGroup
    {
        if(!_groupRules.exists(name)) {
            _groupRules.set(name, classNames);
            _groupEntities.set(name, new EntityGroup());
            _keys.push(name);
        }
        return _groupEntities.get(name);
    }

    @:allow(pongo.pecs.Engine)
    private function destroyGroup(name :String) : Void
    {
        if(_groupRules.exists(name)) {
            _groupRules.remove(name);
            var entities = _groupEntities.get(name);
            entities.dispose();
            _groupEntities.remove(name);
            _keys.remove(name);
        }
    }

    @:allow(pongo.pecs.Engine)
    private function update() : Void
    {
        for(key in _keys) {
            _groupEntities.get(key).update();
        }
    }

    private function hasRules(entity :Entity, rules :SafeArray<String>) : Bool
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

    private var _keys :SafeArray<String>;
    private var _groupRules :Map<String, SafeArray<String>>;
    private var _groupEntities :Map<String, EntityGroup>;
}