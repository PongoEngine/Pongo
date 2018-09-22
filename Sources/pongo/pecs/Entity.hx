package pongo.pecs;

import pongo.pecs.Component;
import pongo.pecs.Manager;
import pongo.util.Disposable;
import pongo.display.Sprite;

@:final class Entity implements Disposable
{
    public var sprite :Sprite;

    @:allow(pongo.pecs.Manager)
    private function new(manager :Manager) : Void
    {
        this.sprite = null;
        _manager = manager;
        _parent = null;
        _children = [];
        _components = new Map<String, Component>();
    }

    public function addComponent(component :Component) : Entity
    {
        if(_components.exists(component.name)) {
            this.removeComponent(component.name);
        }
        _components.set(component.name, component);
        _manager.notifyAddComponent(this);
        return this;
    }

    public function removeComponent(name :String) : Void
    {
        var comp = _components.get(name);
        _manager.notifyRemoveComponent(this);
        _components.remove(name);
    }

    public function getComponent(name :String) : Component
    {
        return _components.get(name);
    }

    public function hasComponent(name :String) : Bool
    {
        return _components.get(name) != null;
    }

    public function addEntity(e :Entity) : Entity
    {
        if(e._parent != null) {
            e._parent.removeEntity(e);
        }
        e._parent = this;
        _children.push(e);

        _manager.notifyAddEntity(this);

        return this;
    }

    public function removeEntity(e :Entity) : Void
    {
        _children.remove(e);
        e._parent = null;
        _manager.notifyRemoveEntity(this);
    }

    public function createChild() : Entity
    {
        var e = _manager.createEntity();
        this.addEntity(e);
        return e;
    }

    public function dispose() : Void
    {
        for(child in _children) {
            child.dispose();
        }
        _parent.removeEntity(this);
        _manager = null;
        _parent = null;
        for(c in _components) {
            _components.remove(c.name);
        }
        _manager.returnEntity(this);
    }

    private var _manager :Manager;
    private var _parent :Entity;
    public var _children :Array<Entity>;
    private var _components :Map<String, Component>;
}