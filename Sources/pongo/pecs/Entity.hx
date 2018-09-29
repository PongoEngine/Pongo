package pongo.pecs;

import pongo.pecs.Component;
import pongo.pecs.Manager;
import pongo.util.Disposable;
import pongo.display.Sprite;

@:final class Entity implements Disposable
{
    public var sprite (default, null):Sprite;
    public var index (default, null):Int;

    @:allow(pongo.pecs.Manager)
    private function new(manager :Manager) : Void
    {
        this.sprite = null;
        this.index = ++Entity.ENTITY_INDEX;
        
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
        _manager.notifyAddEntity(e);

        return this;
    }

    public function removeEntity(e :Entity) : Void
    {
        _children.remove(e);
        e._parent = null;
        _manager.notifyRemoveEntity(e);
    }

    public function setSprite(sprite :Sprite) : Entity
    {
        this.sprite = sprite;
        return this;
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
    }

    private var _manager :Manager;
    private var _parent :Entity;
    public var _children :Array<Entity>;
    private var _components :Map<String, Component>;
    
    private static var ENTITY_INDEX :Int = -1;
}