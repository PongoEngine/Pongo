package pongo.pecs;

import pongo.pecs.Entity;

class Component
{
    public var name (default, null) : String;

    public function new(name :String) : Void
    {
        this.name = name;
    }
}