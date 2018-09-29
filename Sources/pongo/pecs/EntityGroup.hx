package pongo.pecs;

import pongo.pecs.util.SafeArray;
import pongo.pecs.util.EntitySet;
import pongo.util.Disposable;

@:final class EntityGroup implements Disposable
{
    public var entities (default, null):EntitySet;
    public var rules (default, null):SafeArray<String>;

    public function new(rules :SafeArray<String>) : Void
    {
        this.entities = new EntitySet();
        this.rules = rules;
    }

    @:allow(pongo.pecs.Manager)
    private function addEntity(entity :Entity) : Void
    {
        entities.add(entity);
    }

    @:allow(pongo.pecs.Manager)
    private function removeEntity(entity :Entity) : Void
    {
        entities.remove(entity);
    }

    public function dispose() : Void
    {
        entities.clear();
    }
}