package pongo.display;

import pongo.util.Disposable;

interface Texture extends Disposable
{
    var width(get, null) : Int;
    var height(get, null) : Int;
}