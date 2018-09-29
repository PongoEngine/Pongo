package pongo.pecs.util;

import pongo.pecs.Entity;

@:forward(iterator)
abstract EntitySet(Map<Int,Entity>)
{
    inline public function new() : Void
    {
        this = new Map<Int, Entity>();
    }

    inline public function exists(entity :Entity) : Bool
    {
        return this.exists(entity.index);
    }

    @:allow(pongo.pecs.Manager)
    @:allow(pongo.pecs.EntityGroup)
    inline private function add(entity :Entity) :Void
    {
        return this.set(entity.index, entity);
    }

    @:allow(pongo.pecs.Manager)
    @:allow(pongo.pecs.EntityGroup)
    inline private function remove(entity :Entity) :Bool
    {
        return this.remove(entity.index);
    }

    @:allow(pongo.pecs.Manager)
    @:allow(pongo.pecs.EntityGroup)
    inline private function clear() : Void
    {
        var keys = this.keys();
        for(key in keys) {
            this.remove(key);
        }
    }
}