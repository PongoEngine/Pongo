package pongo.display;

import kha.math.FastMatrix3;

interface Renderable
{
    var x :Float;
    var y :Float;
    var anchorX :Float;
    var anchorY :Float;
    var scaleX :Float;
    var scaleY :Float;
    var rotation :Float;
    var opacity :Float;
    var visible :Bool;
    function draw(graphics: Graphics) : Void;
    function getMatrix() : FastMatrix3;
}