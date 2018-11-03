package pongo.display;

import pongo.ecs.transform.Transform;

interface Sprite
{
    function draw(transform :Transform, graphics :Graphics) : Void;
    function getNaturalWidth() : Float;
    function getNaturalHeight() : Float;
}