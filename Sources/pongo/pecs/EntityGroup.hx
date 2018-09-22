package pongo.pecs;

import pongo.pecs.util.SafeArray;
import pongo.util.Disposable;

@:final class EntityGroup implements Disposable
{
    public var justRemoved (default, null):SafeArray<Entity>;
    public var justAdded (default, null):SafeArray<Entity>;
    public var entities (default, null):SafeArray<Entity>;

    public function new() : Void
    {
        this.justRemoved = new SafeArray();
        this.justAdded = new SafeArray();
        this.entities = new SafeArray();
    }

    @:allow(pongo.pecs.Manager)
    private function addEntity(entity :Entity) : Void
    {
        justAdded.push(entity);
    }

    @:allow(pongo.pecs.Manager)
    private function removeEntity(entity :Entity) : Void
    {
        if(entities.remove(entity)) {
            justRemoved.push(entity);
        }
        else if(justAdded.remove(entity)) {
            justRemoved.push(entity);
        }
    }

    @:allow(pongo.pecs.Manager)
    private function update() : Void
    {
        while (justAdded.length > 0) {
            var e = justAdded.pop();
            entities.push(e);
        }
        while (justRemoved.length > 0) justRemoved.pop();
    }

    public function dispose() : Void
    {
        while (justRemoved.length > 0) justRemoved.pop();
        while (justAdded.length > 0) justAdded.pop();
        while (entities.length > 0) entities.pop();
    }


}