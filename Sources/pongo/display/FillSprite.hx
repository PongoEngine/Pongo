/*
 * Copyright (c) 2020 Jeremy Meltingtallow
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
 * Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN
 * AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
 * THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

// Flambe - Rapid game development
// https://github.com/aduros/flambe/blob/master/LICENSE.txt

package pongo.display;

import pongo.ecs.transform.Transform;

class FillSprite implements Sprite
{
    public var color :Int;
    public var width :Float;
    public var height :Float;

    public function new(color :Int, width :Float, height :Float) : Void
    {
        this.color = color;
        this.width = width;
        this.height = height;
    }

    public function draw(dt :Float, transform :Transform, graphics :Graphics) : Void
    {
        graphics.save();
        graphics.setColor(this.color);
        graphics.fillRect(0, 0, width, height);
        graphics.restore();
    }

    public function getNaturalWidth() : Float
    {
        return this.width;
    }

    public function getNaturalHeight() : Float
    {
        return this.height;
    }
}