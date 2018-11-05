/*
 * Copyright (c) 2018 Jeremy Meltingtallow
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
import kha.Scaler;
import kha.System;

class Graphics implements pongo.display.Graphics
{
    public var framebuffer (default, null): kha.Framebuffer;
    public var width (default, null): Int;
    public var height (default, null): Int;

    public function new(framebuffer :kha.Framebuffer, width :Int, height :Int) : Void
    {
        this.framebuffer = framebuffer;
        this.width = width;
        this.height = height;
    }

    public function begin() : Void
    {
        framebuffer.g2.begin();
        var transform = Scaler.getScaledTransformation(this.width, this.height, System.windowWidth(), System.windowHeight(), System.screenRotation);
        _stateList.matrix.setFrom(transform);
    }

    public function end() : Void
    {
        framebuffer.g2.end();
    }

    public function fillRect(color :Int, x :Float, y :Float, width :Float, height :Float) : Void 
    {
        setColor(color);
        prepareGraphics2D();
        framebuffer.g2.fillRect(x, y, width, height);
    }

    public function fillCircle(color :Int, cx: Float, cy: Float, radius: Float, segments: Int = 0) : Void
    {
        setColor(color);
        prepareGraphics2D();
        #if !macro
        kha.graphics2.GraphicsExtension.fillCircle(framebuffer.g2, cx, cy, radius, segments);
        #end
    }

    public function drawRect(color :Int, x: Float, y: Float, width: Float, height: Float, strength: Float = 1.0) : Void 
    {
        setColor(color);
        prepareGraphics2D();
        framebuffer.g2.drawRect(x, y, width, height, strength);
    }

    public function drawLine(color :Int, x1: Float, y1: Float, x2: Float, y2: Float, strength: Float = 1.0) : Void 
    {
        setColor(color);
        prepareGraphics2D();
        framebuffer.g2.drawLine(x1, y1, x2, y2, strength);
    }

    public function drawCircle(color :Int, cx: Float, cy: Float, radius: Float, strength: Float = 1, segments: Int = 0) : Void
    {
        setColor(color);
        prepareGraphics2D();
        #if !macro
        kha.graphics2.GraphicsExtension.drawCircle(framebuffer.g2, cx, cy, radius, strength, segments);
        #end
    }

    public function drawCubicBezierPath(color :Int, x :Array<Float>, y :Array<Float>, strength:Float = 1.0):Void
    {
        setColor(color);
        prepareGraphics2D();
        #if !macro
        kha.graphics2.GraphicsExtension.drawCubicBezierPath(framebuffer.g2, x, y, 20, strength);
        #end
    }

    public function drawPolygon(color :Int, x: Float, y: Float, vertices: Array<kha.math.Vector2>, strength: Float = 1) : Void
    {
        setColor(color);
        prepareGraphics2D();
        #if !macro
        kha.graphics2.GraphicsExtension.drawPolygon(framebuffer.g2, x, y, vertices, strength);
        #end
    }

    public function drawString(text :String, font :pongo.display.Font, color :Int, fontSize :Int, x :Float, y :Float) : Void
    {
        setColor(color);
        prepareGraphics2D();

        var nativeFont = cast(font, Font).nativeFont;
        if(framebuffer.g2.font != nativeFont) {
            framebuffer.g2.font = nativeFont;
        }

        if(framebuffer.g2.fontSize != fontSize) {
            framebuffer.g2.fontSize = fontSize;
        }

        framebuffer.g2.drawString(text, x, y);
    }

    public function drawImage(texture: pongo.display.Texture, x: Float, y: Float) : Void
    {
        setColor(0xffffffff);
        prepareGraphics2D();

        framebuffer.g2.drawImage(cast(texture, Texture).nativeTexture, x, y);
    }

    public function drawSubImage(texture: pongo.display.Texture, x: Float, y: Float, sx: Float, sy: Float, sw: Float, sh: Float) : Void
    {
        setColor(0xffffffff);
        prepareGraphics2D();
        framebuffer.g2.drawSubImage(cast(texture, Texture).nativeTexture, x, y, sx, sy, sw, sh);
    }

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
        framebuffer.g2.transformation.setFrom(_stateList.matrix);
        framebuffer.g2.opacity = _stateList.opacity;

        if(framebuffer.g2.color != _stateList.color) {
            framebuffer.g2.color = _stateList.color;
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

}

private class DrawingState
{
    public var matrix :FastMatrix3;
    public var opacity :Float;
    public var color :kha.Color;

    public var prev :DrawingState = null;
    public var next :DrawingState = null;

    public function new() : Void
    {
        matrix = FastMatrix3.identity();
        opacity = 1;
        color = Color.Black;
    }
}