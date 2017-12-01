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

package cream.display;

import kha.Font;
import kha.Color;

class TextSprite extends Sprite
{
    public var text :String;
    public var font :Font;
    public var color :Color;
    public var fontSize :Int;

    public function new(text :String, font :Font, color :Color, fontSize :Int) : Void
    {
        super();
        this.text = text;
        this.font = font;
        this.color = color;
        this.fontSize = fontSize;
    }

    override public function draw(graphics :Graphics) : Void
    {
        graphics.drawString(text, font, color, fontSize, 0, 0);
    }

    override public function getNaturalWidth() : Float
    {
        return font.width(this.fontSize, this.text);
    }

    override public function getNaturalHeight() : Float
    {
        return font.height(this.fontSize);
    }
}