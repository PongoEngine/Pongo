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

package pongo.display;

import pongo.ecs.transform.Transform;

class TextSprite implements Sprite
{
    public var font :Font;
    public var fontSize :Int;
    public var color :Int;
    public var text :String;

    public function new(font :Font, fontSize :Int, color :Int, text :String) : Void
    {
        this.font = font;
        this.fontSize = fontSize;
        this.color = color;
        this.text = text;
    }

    public function draw(dt :Float, transform :Transform, graphics :Graphics) : Void
    {
        graphics.drawString(text, font, color, fontSize, 0, 0);
    }

    public function getNaturalWidth() : Float
    {
        return this.font.width(this.fontSize, this.text);
    }

    public function getNaturalHeight() : Float
    {
        return this.font.height(this.fontSize);
    }
}