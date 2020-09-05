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

package pongo.platform.display;

class Font implements pongo.display.Font
{
    public var nativeFont(default, null) : kha.Font;

    public function new(font :kha.Font) : Void
    {
        this.nativeFont = font;
    }

    public function dispose() : Void
    {
        this.nativeFont.unload();
    }

    public inline function width(fontSize :Int, text :String) : Float
    {
        return this.nativeFont.width(fontSize, text);
    }

    public inline function height(fontSize :Int) : Float
    {
        return this.nativeFont.height(fontSize);
    }

    public inline function baseline(fontSize: Int): Float
    {
        return this.nativeFont.baseline(fontSize);
    }
}