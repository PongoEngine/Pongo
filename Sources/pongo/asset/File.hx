package pongo.asset;

import pongo.util.Disposable;

class File implements Disposable
{
    public var data (default, null) : String;

    public function new(data :String) : Void
    {
        this.data = data;
    }

    public function dispose() : Void
    {

    }
}