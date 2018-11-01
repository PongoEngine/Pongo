package pongo.ecs.group;

class ReactiveGroup implements Group
{
    public var rules (default, null):Rules;
    public var length (get, null):Int;

    public function new(rules :Rules) : Void
    {
        this.rules = rules;
        _swapList = new SwapEntityList();
    }

    public function first() : Entity
    {
        if(_swapList.active().head == null) return null;
        return _swapList.active().head.entity;
    }

    public inline function iterate(fn :Entity -> Void) : Void
    {
        var p = _swapList.active().head;
        while(p != null) {
            fn(p.entity);
            p = p.next;
        }
    }

    public function iterateWithEscape(fn :Entity -> Bool) : Void
    {
        var p = _swapList.active().head;
        while(p != null) {
            if(fn(p.entity)) {
                return;
            }
            p = p.next;
        }
    }

    @:allow(pongo.ecs.group.SourceGroup)
    private function queueChanged(entity :Entity) : Bool
    {
        if(this.rules.satisfy(entity)) {
            return _swapList.addToQueue(entity);
        }
        return false;
    }

    @:allow(pongo.ecs.group.SourceGroup)
    private function swapQueue() : Void
    {
        _swapList.clearActive();
        _swapList.swap();
    }

    @:allow(pongo.ecs.group.SourceGroup)
    private function remove(entity :Entity) : Void
    {
        _swapList.active().remove(entity);
        _swapList.queued().remove(entity);
    }


    private function get_length() : Int
    {
        return _swapList.active().size;
    }

    private var _swapList :SwapEntityList;
}