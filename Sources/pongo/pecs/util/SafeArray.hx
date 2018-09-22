package pongo.pecs.util;

@:forward(iterator, length)
abstract SafeArray<T>(Array<T>)
{
    inline public function new() : Void
    {
        this = [];
    }

    inline public static function fromArray<T>(array :Array<T>) : SafeArray<T>
    {
        return cast array;
    }

    @:allow(pongo.pecs.Manager)
    @:allow(pongo.pecs.EntityGroup)
    inline private function push<T>(obj :T) :Int
    {
        return this.push(obj);
    }

    @:allow(pongo.pecs.Manager)
    @:allow(pongo.pecs.EntityGroup)
    inline private function remove<T>(obj :T) :Bool
    {
        return this.remove(obj);
    }

    @:allow(pongo.pecs.Manager)
    @:allow(pongo.pecs.EntityGroup)
    inline private function pop<T>() :T
    {
        return this.pop();
    }
}