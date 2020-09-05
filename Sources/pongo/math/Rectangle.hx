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

package pongo.math;

class Rectangle
{
    public var x :Float;
    public var y :Float;
    public var width :Float;
    public var height :Float;

    public inline function new(x :Float, y :Float, width :Float, height :Float) : Void
    {
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
    }

    @:extern public inline function setFrom(rec: Rectangle): Void 
    {
        this.x = rec.x;
        this.y = rec.y;
        this.width = rec.width;
        this.height = rec.height;
    }

    @:extern public inline function clone(): Rectangle 
    {
        return new Rectangle(this.x, this.y, this.width, this.height);
    }

    @:extern public inline function left() :Float
    {
        return this.x;
    }

    @:extern public inline function top() :Float
    {
        return this.y;
    }

    @:extern public inline function right() :Float
    {
        return this.x + this.width;
    }

    @:extern public inline function bottom() :Float
    {
        return this.y + this.height;
    }

    @:extern public inline function centerX() :Float
    {
        return this.x + this.width/2;
    }

    @:extern public inline function centerY() :Float
    {
        return this.y + this.height/2;
    }
}