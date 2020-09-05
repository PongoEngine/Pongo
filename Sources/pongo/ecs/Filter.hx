package pongo.ecs;

class Filter
{
    public var deps (default, null):Array<String>;
    public var fn (default, null):Dynamic;
    public var entities :Map<Entity, Array<Component<Dynamic>>>;

    public function new(deps :Array<String>, fn :Dynamic) : Void
    {
        this.deps = deps;
        this.fn = fn;
        this.entities = [];
    }

    public function clearGroups() : Void
    {
        entities.clear();
    }
}