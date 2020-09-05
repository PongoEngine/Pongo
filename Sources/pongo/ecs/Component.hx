package pongo.ecs;

class Component<T>
{
    public var parent :Entity;
    public var name (default, null) :String;
    public var value :T;

    public function new(value :T, name :String) : Void
    {
        this.value = value;
        this.name = name;
    }

    public function dispose() : Void
    {
        this.parent.removeComponent(this);
    }
}