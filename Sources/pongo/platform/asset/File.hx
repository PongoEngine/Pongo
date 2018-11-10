package pongo.platform.asset;

import haxe.io.Bytes;

class File implements pongo.asset.File
{
    public var blob (default, null) : kha.Blob;

    public inline function new(blob :kha.Blob) : Void
    {
        this.blob = blob;
    }

    public inline function toString(): String
    {
        return this.blob.toString();
    }

    public inline function toBytes(): Bytes
    {
        return this.blob.toBytes();
    }

    public inline function dispose() : Void
    {
        this.blob.unload();
    }
}