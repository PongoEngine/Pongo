package pongo.display;

import pongo.util.Disposable;

interface Font extends Disposable
{
    function width(fontSize :Int, text :String) : Float;
    function height(fontSize :Int) : Float;
}