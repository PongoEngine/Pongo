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

package pongo.platform.display;

import kha.math.FastMatrix3;
import kha.Color;

class Graphics implements pongo.display.Graphics
{
    public function new(framebuffer :kha.Framebuffer) : Void
    {
        _framebuffer = framebuffer;
    }

    public function begin() : Void
    {
#if graphics1
        _framebuffer.g1.begin();
#else
        _framebuffer.g2.begin();
#end
    }

    public function end() : Void
    {
#if graphics1
        _framebuffer.g1.end();
#else
        _framebuffer.g2.end();
#end
    }

#if !graphics1
    public function fillRect(color :Int, x :Float, y :Float, width :Float, height :Float) : Void 
    {
        setColor(color);
        prepareGraphics2D();
        _framebuffer.g2.fillRect(x, y, width, height);
    }

    public function fillCircle(color :Int, cx: Float, cy: Float, radius: Float, segments: Int = 0) : Void
    {
        setColor(color);
        prepareGraphics2D();
        #if !macro
        kha.graphics2.GraphicsExtension.fillCircle(_framebuffer.g2, cx, cy, radius, segments);
        #end
    }

    public function drawRect(color :Int, x: Float, y: Float, width: Float, height: Float, strength: Float = 1.0) : Void 
    {
        setColor(color);
        prepareGraphics2D();
        _framebuffer.g2.drawRect(x, y, width, height, strength);
    }

    public function drawLine(color :Int, x1: Float, y1: Float, x2: Float, y2: Float, strength: Float = 1.0) : Void 
    {
        setColor(color);
        prepareGraphics2D();
        _framebuffer.g2.drawLine(x1, y1, x2, y2, strength);
    }

    public function drawCircle(color :Int, cx: Float, cy: Float, radius: Float, strength: Float = 1, segments: Int = 0) : Void
    {
        setColor(color);
        prepareGraphics2D();
        #if !macro
        kha.graphics2.GraphicsExtension.drawCircle(_framebuffer.g2, cx, cy, radius, strength, segments);
        #end
    }

    public function drawCubicBezierPath(color :Int, x :Array<Float>, y :Array<Float>, strength:Float = 1.0):Void
    {
        setColor(color);
        prepareGraphics2D();
        #if !macro
        kha.graphics2.GraphicsExtension.drawCubicBezierPath(_framebuffer.g2, x, y, 20, strength);
        #end
    }

    public function drawPolygon(color :Int, x: Float, y: Float, vertices: Array<kha.math.Vector2>, strength: Float = 1) : Void
    {
        setColor(color);
        prepareGraphics2D();
        #if !macro
        kha.graphics2.GraphicsExtension.drawPolygon(_framebuffer.g2, x, y, vertices, strength);
        #end
    }

    public function drawString(text :String, font :kha.Font, color :Color, fontSize :Int, x :Float, y :Float) : Void
    {
        setColor(color);

        prepareGraphics2D();

        _framebuffer.g2.font = font;
        _framebuffer.g2.fontSize = fontSize;

        _framebuffer.g2.drawString(text, x, y);
    }

    public function drawImage(img: kha.Image, x: Float, y: Float) : Void
    {
        setColor(0xffffffff);
        prepareGraphics2D();
        _framebuffer.g2.drawImage(img, x, y);
    }

    public function drawSubImage(img: kha.Image, x: Float, y: Float, sx: Float, sy: Float, sw: Float, sh: Float) : Void
    {
        setColor(0xffffffff);
        prepareGraphics2D();
        _framebuffer.g2.drawSubImage(img, x, y, sx, sy, sw, sh);
    }
#else
    public function setPixel(color :Int, x :Int, y :Int) : Void
    {
        _framebuffer.g1.setPixel(x, y, color);
    }
#end

#if !graphics1
    public inline function translate(x :Float, y :Float) : Void
    {
        _stateList.matrix.setFrom(_stateList.matrix.multmat(FastMatrix3.translation(x,y)));
    }

    public inline function scale(x :Float, y :Float) : Void
    {
        _stateList.matrix.setFrom(_stateList.matrix.multmat(FastMatrix3.scale(x,y)));
    }

    public inline function rotate(rotation :Float) : Void
    {
        _stateList.matrix.setFrom(_stateList.matrix.multmat(FastMatrix3.rotation(rotation)));
    }

    public inline function transform(matrix :FastMatrix3) : Void
    {
        _stateList.matrix.setFrom(_stateList.matrix.multmat(matrix));
    }

    public function save() : Void
    {
        var current = _stateList;
        var state = _stateList.next;

        if (state == null) {
            state = new DrawingState();
            state.prev = current;
            current.next = state;
        }

        state.matrix.setFrom(current.matrix);
        state.opacity = current.opacity;
        state.color = current.color;
        _stateList = state;
    }

    public function restore() : Void
    {
        _stateList = _stateList.prev;
    }

    public function prepareGraphics2D() : Void
    {
        _framebuffer.g2.transformation.setFrom(_stateList.matrix);
        _framebuffer.g2.opacity = _stateList.opacity;

        if(_framebuffer.g2.color != _stateList.color) {
            _framebuffer.g2.color = _stateList.color;
        }
    }

    public function multiplyOpacity(factor :Float) : Void
    {
        _stateList.opacity *= factor;
    }

    public function setOpacity(opacity :Float) : Void
    {
        _stateList.opacity = opacity;
    }

    public function setColor(color :Color) : Void
    {
        _stateList.color = color;
    }

    private var _stateList :DrawingState = new DrawingState();
#end

    private var _framebuffer :kha.Framebuffer;
}

private class DrawingState
{
    public var matrix :FastMatrix3;
    public var opacity :Float;
#if !graphics1
    public var color :kha.Color;
#end

    public var prev :DrawingState = null;
    public var next :DrawingState = null;

    public function new() : Void
    {
        matrix = FastMatrix3.identity();
        opacity = 1;
#if !graphics1
        color = Color.Black;
#end
    }
}