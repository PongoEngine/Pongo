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

package pongo.display;

import kha.math.FastMatrix3;

interface Graphics
{
    function setPipeline(pipeline :Pipeline) : Void;

    function begin() : Void;

    function end() : Void;

    function fillRect(color :Int, x :Float, y :Float, width :Float, height :Float) : Void;

    function fillCircle(color :Int, cx: Float, cy: Float, radius: Float, segments: Int = 0) : Void;

    function drawRect(color :Int, x: Float, y: Float, width: Float, height: Float, strength: Float = 1.0) : Void;

    function drawLine(color :Int, x1: Float, y1: Float, x2: Float, y2: Float, strength: Float = 1.0) : Void;

    function drawCircle(color :Int, cx: Float, cy: Float, radius: Float, strength: Float = 1, segments: Int = 0) : Void;

    function drawPolygon(color :Int, x: Float, y: Float, vertices: Array<kha.math.Vector2>, strength: Float = 1) : Void;

    function drawCubicBezierPath(color :Int, x :Array<Float>, y :Array<Float>, strength:Float = 1.0):Void;

    function drawString(text :String, font :Font, color :Int, fontSize :Int, x :Float, y :Float) : Void;

    function drawImage(texture: Texture, x: Float, y: Float) : Void;

    function drawSubImage(texture: Texture, x: Float, y: Float, sx: Float, sy: Float, sw: Float, sh: Float) : Void;

    function translate(x :Float, y :Float) : Void;

    function scale(x :Float, y :Float) : Void;

    function rotate(rotation :Float) : Void;

    function transform(matrix :FastMatrix3) : Void;

    function save() : Void;

    function restore() : Void;

    function multiplyOpacity(factor :Float) : Void;

    function setOpacity(opacity :Float) : Void;

    function setColor(color :Int) : Void;

    function setBlendMode(blendMode :BlendMode) : Void;

    function applyScissor (x :Float, y :Float, width :Float, height :Float) :Void;
}