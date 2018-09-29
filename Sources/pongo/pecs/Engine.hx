package pongo.pecs;

import pongo.pecs.Manager;
import pongo.pecs.Entity;
import pongo.util.Disposable;
import pongo.pecs.EntityGroup;
import pongo.display.Sprite;
import pongo.display.Graphics;

@:final class Engine implements Disposable
{
    public var root (default, null):Entity;

    public function new() : Void
    {
        _manager = new Manager();
        this.root = this.createEntity();
    }

    public function registerGroup(name :String, classNames :Array<String>) : EntityGroup
    {
        return _manager.createGroup(name, classNames);
    }

    public function unregisterGroup(name :String) : Void
    {
        _manager.destroyGroup(name);
    }

    public function dispose() : Void
    {
        _manager.dispose();
    }

    public function render(graphics: Graphics) : Void
    {
        Sprite.render(this.root, graphics);
    }

    public inline function createEntity() : Entity
    {
        return _manager.createEntity();
    }

    private var _manager :Manager;
}