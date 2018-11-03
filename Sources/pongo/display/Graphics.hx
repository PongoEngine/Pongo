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
    public function begin() : Void;

    public function end() : Void;

    public function fillRect(color :Int, x :Float, y :Float, width :Float, height :Float) : Void;

    public function fillCircle(color :Int, cx: Float, cy: Float, radius: Float, segments: Int = 0) : Void;

    public function drawRect(color :Int, x: Float, y: Float, width: Float, height: Float, strength: Float = 1.0) : Void;

    public function drawLine(color :Int, x1: Float, y1: Float, x2: Float, y2: Float, strength: Float = 1.0) : Void;

    public function drawCircle(color :Int, cx: Float, cy: Float, radius: Float, strength: Float = 1, segments: Int = 0) : Void;

    public function drawPolygon(color :Int, x: Float, y: Float, vertices: Array<kha.math.Vector2>, strength: Float = 1) : Void;

    public function drawCubicBezierPath(color :Int, x :Array<Float>, y :Array<Float>, strength:Float = 1.0):Void;

    // public function drawString(text :String, font :SafeFont, color :Color, fontSize :Int, x :Float, y :Float) : Void;

    public function drawImage(texture: Texture, x: Float, y: Float) : Void;

    public function drawSubImage(texture: Texture, x: Float, y: Float, sx: Float, sy: Float, sw: Float, sh: Float) : Void;

    public function translate(x :Float, y :Float) : Void;

    public function scale(x :Float, y :Float) : Void;

    public function rotate(rotation :Float) : Void;

    public function transform(matrix :FastMatrix3) : Void;

    public function save() : Void;

    public function restore() : Void;

    public function multiplyOpacity(factor :Float) : Void;

    public function setOpacity(opacity :Float) : Void;

    public function setColor(color :Int) : Void;
}