package pongo.display;

@:enum
abstract BlendMode(Int) to Int
{
    var NORMAL = 0;
    var ADD = 1;
    var MULTIPLY = 2;
    var SCREEN = 3;
    var MASK = 4;
    var COPY = 5;
}