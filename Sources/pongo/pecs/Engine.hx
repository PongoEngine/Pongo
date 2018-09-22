package pongo.pecs;

import pongo.pecs.Manager;
import pongo.pecs.Entity;
import pongo.util.Disposable;
import pongo.pecs.EntityGroup;
import pongo.pecs.util.SafeArray;
import pongo.display.Sprite;
import pongo.display.Graphics;

@:final class Engine implements Disposable
{
    public var root (default, null):Entity;

    public function new() : Void
    {
        _manager = new Manager();
        this.root = _manager.createEntity();
    }

    public function registerGroup(name :String, classNames :Array<String>) : EntityGroup
    {
        var arra = SafeArray.fromArray(classNames);
        return _manager.createGroup(name, arra);
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

    public function update() : Void
    {
        _manager.update();
    }

    private var _manager :Manager;
}