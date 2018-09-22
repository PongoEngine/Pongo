package pongo.pecs;

import pongo.pecs.Entity;
import pongo.util.Disposable;

class Component implements Disposable
{
    public var name (default, null) : String;
    public var owner (default, null) : Entity;

    public function new(name :String) : Void
    {
        this.name = name;
    }

    public function dispose() : Void
    {
        owner.removeComponent(this.name);
    }
}