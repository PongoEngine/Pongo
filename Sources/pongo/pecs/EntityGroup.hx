package pongo.pecs;

import pongo.util.Disposable;

@:final class EntityGroup implements Disposable
{
    public var entities (get, null):Iterator<Entity>;

    public function new(rules :Array<String>) : Void
    {
        _rules = rules;
        _set = new Map<Int,Entity>();
    }

    @:allow(pongo.pecs.Manager)
    private function addEntity(entity :Entity) : Void
    {
        _set.set(entity._index, entity);
    }

    @:allow(pongo.pecs.Manager)
    private function removeEntity(entity :Entity) : Void
    {
        _set.remove(entity._index);
    }

    public function dispose() : Void
    {
        var keys = _set.keys();
        for(key in keys) {
            _set.remove(key);
        }
        while(_rules.length > 0) _rules.pop();
    }

    public function exists(entity :Entity) : Bool
    {
        return _set.exists(entity._index);
    }

    private function get_entities() : Iterator<Entity>
    {
        return _set.iterator();
    }

    @:allow(pongo.pecs.Manager)
    private var _rules:Array<String>;
    private var _set:Map<Int,Entity>;
}