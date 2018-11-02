/*
 * Copyright (c) 2017 Jeremy Meltingtallow
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

//
// Flambe - Rapid game development
// https://github.com/aduros/flambe/blob/master/LICENSE.txt

package pongo.display.graphics1;

import pongo.Pongo;
import pongo.display.Graphics;

class Sprite1
{
    public var x :Int = 0;
    public var y :Int = 0;
    public var opacity :Float = 1;
    public var visible :Bool = true;

    public function new() : Void
    {
    }

    public inline function setXY(x :Int, y :Int) : Sprite1
    {
        this.x = x;
        this.y = y;
        return this;
    }


    public inline function setOpacity(opacity :Float) : Sprite1
    {
        this.opacity = opacity;
        return this;
    }

    /**
     *  [Description]
     *  @return Float
     */
    public function getNaturalWidth() : Float
    {
        return 0;
    }

    /**
     *  [Description]
     *  @return Float
     */
    public function getNaturalHeight() : Float
    {
        return 0;
    }

    /**
     *  [Description]
     *  @param graphics - 
     */
    public function draw(pongo :Pongo, graphics: Graphics) : Void
    {
    }
}