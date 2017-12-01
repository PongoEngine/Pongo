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

import kha.Image;

class SheetSprite extends Sprite
{
    public var image :Image;
    public var xFrames :Int; 
    public var yFrames :Int; 
    public var frameDuration :Float; 

    public function new(image :Image, xFrames :Int, yFrames :Int, frameDuration :Float) : Void
    {
        super();
        this.image = image;
        this.xFrames = xFrames;
        this.yFrames = yFrames;
        this.frameDuration = frameDuration;

        _frame = 0;
        _elapsed = 0;
    }

    override public function draw(graphics :Graphics) : Void
    {
        var width = image.width / xFrames;
        var height = image.height / yFrames;

        var x :Int = _frame % xFrames;
        var y :Int = Math.floor(_frame/xFrames);
        

        graphics.drawSubImage(image, 0, 0, x * width, y * height, width, height);

        _elapsed += 0.016666667;
        if(_elapsed >= frameDuration) {
            _elapsed = 0;
            _frame += 1;
            _frame %= xFrames*yFrames;
        }
    }

    override public function getNaturalWidth() : Float
    {
        return this.image.width / xFrames;
    }

    override public function getNaturalHeight() : Float
    {
        return this.image.height / yFrames;
    }

    private var _frame :Int;
    private var _elapsed :Float;
}