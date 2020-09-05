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

import kha.math.FastMatrix3;
import pongo.display.BlendMode;
using pongo.math.CMath;

class Sprite
{
    public var x :Float = 0;
    public var y :Float = 0;
    public var anchorX :Float = 0;
    public var anchorY :Float = 0;
    public var scaleX :Float = 1;
    public var scaleY :Float = 1;
    public var rotation :Float = 0;
    public var opacity :Float = 1;
    public var visible :Bool = true;
    public var blendMode :BlendMode = BlendMode.NORMAL;
    public var matrix :FastMatrix3 = FastMatrix3.identity();

    public function draw(graphics :Graphics) : Void
    {
        
    }

    public function getNaturalWidth() : Float
    {
        return 0;
    }

    public function getNaturalHeight() : Float
    {
        return 0;
    }
}

class TransformUtil
{
    public static function centerAnchor(transform :Sprite) :Sprite
    {
        transform.anchorX = transform.getNaturalWidth()/2;
        transform.anchorY = transform.getNaturalHeight()/2;
        return transform;
    }

    public static function setOpacity(transform :Sprite, opacity :Float) :Sprite
    {
        transform.opacity = opacity;
        return transform;
    }

    public static function setAnchor(transform :Sprite, x :Float, y :Float) :Sprite
    {
        transform.anchorX = x;
        transform.anchorY = y;
        return transform;
    }

    public static function setRotation(transform :Sprite, rotation :Float, fromDegrees :Bool = false) :Sprite
    {
        transform.rotation = fromDegrees ? rotation.toRadians() : rotation;
        return transform;
    }

    public static function setScale(transform :Sprite, scale :Float) :Sprite
    {
        transform.scaleX = scale;
        transform.scaleY = scale;
        return transform;
    }

    public static function setScaleXY(transform :Sprite, scaleX :Float, scaleY :Float) :Sprite
    {
        transform.scaleX = scaleX;
        transform.scaleY = scaleY;
        return transform;
    }

    public static function setXY(transform :Sprite, x :Float, y :Float) :Sprite
    {
        transform.x = x;
        transform.y = y;
        return transform;
    }
}