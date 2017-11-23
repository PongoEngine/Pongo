/*
 * Copyright (c) 2017 Cream Engine
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

package cream.display;


class SpriteUtil
{
    public static inline function setXY(sprite :Sprite, x :Float, y :Float) : Sprite
    {
        sprite.x = x;
        sprite.y = y;
        return sprite;
    }

    public static inline function setAnchorXY(sprite :Sprite, x :Float, y :Float) : Sprite
    {
        sprite.anchorX = x;
        sprite.anchorY = y;
        return sprite;
    }

    public static inline function setRotation(sprite :Sprite, degrees :Float) : Sprite
    {
        sprite.rotation = degrees;
        return sprite;
    }

    public static inline function setOpacity(sprite :Sprite, opacity :Float) : Sprite
    {
        sprite.opacity = opacity;
        return sprite;
    }

    public static inline function setScaleXY(sprite :Sprite, scaleX :Float, scaleY :Float) : Sprite
    {
        sprite.scaleX = scaleX;
        sprite.scaleY = scaleY;
        return sprite;
    }

    public static inline function centerAnchor(sprite :Sprite) : Sprite
    {
        sprite.anchorX = sprite.getNaturalWidth() / 2;
        sprite.anchorY = sprite.getNaturalHeight() / 2;
        return sprite;
    }
}