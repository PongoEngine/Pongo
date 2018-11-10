package pongo.asset;

import pongo.util.Disposable;
import haxe.io.Bytes;

interface File extends Disposable
{
    function toString(): String;
    function toBytes(): Bytes;
}