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

import kha.math.FastMatrix3;
import pongo.display.BlendMode;
using pongo.math.CMath;

class Sprite
{
    public var x (default, set):Float = 0;
    public var y (default, set):Float = 0;
    public var anchorX (default, set):Float = 0;
    public var anchorY (default, set):Float = 0;
    public var scaleX (default, set):Float = 1;
    public var scaleY (default, set):Float = 1;
    public var rotation (default, set):Float = 0;
    public var opacity :Float = 1;
    public var visible :Bool = true;
    public var blendMode :BlendMode = BlendMode.NORMAL;
    public var matrix :FastMatrix3 = FastMatrix3.identity();

    /** This sprite's parent. */
    public var parent (default, null) :Sprite = null;

    /** This sprite's first child. */
    public var firstChild (default, null) :Sprite = null;

    /** This sprite's next sibling, for iteration. */
    public var next (default, null) :Sprite = null;

    public function new() : Void
    {
    }

    public function draw(graphics :Graphics) : Void
    {
        
    }

    public function centerAnchor() :Sprite
    {
        this.anchorX = this.getNaturalWidth()/2;
        this.anchorY = this.getNaturalHeight()/2;
        updateMatrix();
        return this;
    }

    public function setOpacity(opacity :Float) :Sprite
    {
        this.opacity = opacity;
        updateMatrix();
        return this;
    }

    public function setAnchor(x :Float, y :Float) :Sprite
    {
        this.anchorX = x;
        this.anchorY = y;
        updateMatrix();
        return this;
    }

    public function setRotation(rotation :Float, fromDegrees :Bool = false) :Sprite
    {
        this.rotation = fromDegrees ? rotation.toRadians() : rotation;
        updateMatrix();
        return this;
    }

    public function setScale(scale :Float) :Sprite
    {
        this.scaleX = scale;
        this.scaleY = scale;
        updateMatrix();
        return this;
    }

    public function setScaleXY(scaleX :Float, scaleY :Float) :Sprite
    {
        this.scaleX = scaleX;
        this.scaleY = scaleY;
        updateMatrix();
        return this;
    }

    public function setXY(x :Float, y :Float) :Sprite
    {
        this.x = x;
        this.y = y;
        updateMatrix();
        return this;
    }

    public function getNaturalWidth() : Float
    {
        return 0;
    }

    public function getNaturalHeight() : Float
    {
        return 0;
    }

    /**
     * Adds a child to this sprite.
     * @param append Whether to add the sprite to the end or beginning of the child list.
     * @returns This instance, for chaining.
     */
    public function addChild (sprite :Sprite, append :Bool=true) :Sprite
    {
        if (sprite.parent != null) {
            sprite.parent.removeChild(sprite);
        }
        sprite.parent = this;

        if (append) {
            // Append it to the child list
            var tail = null, p = firstChild;
            while (p != null) {
                tail = p;
                p = p.next;
            }
            if (tail != null) {
                tail.next = sprite;
            } else {
                firstChild = sprite;
            }

        } else {
            // Prepend it to the child list
            sprite.next = firstChild;
            firstChild = sprite;
        }

        return this;
    }
    
    public function removeChild (sprite :Sprite)
    {
        var prev :Sprite = null, p = firstChild;
        while (p != null) {
            var next = p.next;
            if (p == sprite) {
                // Splice out the sprite
                if (prev == null) {
                    firstChild = next;
                } else {
                    prev.next = next;
                }
                p.parent = null;
                p.next = null;
                return;
            }
            prev = p;
            p = next;
        }
    }

    /**
     * Dispose all of this sprite's children, without touching its own components or removing itself
     * from its parent.
     */
    public function disposeChildren ()
    {
        while (firstChild != null) {
            firstChild.dispose();
        }
    }
    
    /**
     * Removes this sprite from its parent, and disposes all its components and children.
     */
    public function dispose ()
    {
        if (parent != null) {
            parent.removeChild(this);
        }

        disposeChildren();
    }

    public function updateMatrix() : Void
    {
        this.matrix
            .setFrom(FastMatrix3.identity()
            .multmat(FastMatrix3.translation(this.x,this.y))
            .multmat(FastMatrix3.rotation(this.rotation))
            .multmat(FastMatrix3.scale(this.scaleX, this.scaleY))
            .multmat(FastMatrix3.translation(-this.anchorX, -this.anchorY)));
    }

    private function set_x(x :Float) : Float
    {
        this.x = x;
        updateMatrix();
        return x;
    }

    private function set_y(y :Float) : Float
    {
        this.y = y;
        updateMatrix();
        return y;
    }

    private function set_rotation(rotation :Float) : Float
    {
        this.rotation = rotation;
        updateMatrix();
        return rotation;
    }

    private function set_scaleX(scaleX :Float) : Float
    {
        this.scaleX = scaleX;
        updateMatrix();
        return scaleX;
    }

    private function set_scaleY(scaleY :Float) : Float
    {
        this.scaleY = scaleY;
        updateMatrix();
        return scaleY;
    }

    private function set_anchorX(anchorX :Float) : Float
    {
        this.anchorX = anchorX;
        updateMatrix();
        return anchorX;
    }

    private function set_anchorY(anchorY :Float) : Float
    {
        this.anchorY = anchorY;
        updateMatrix();
        return anchorY;
    }
}

class TransformUtil
{
    public function centerAnchor(transform :Sprite) :Sprite
    {
        transform.anchorX = transform.getNaturalWidth()/2;
        transform.anchorY = transform.getNaturalHeight()/2;
        return transform;
    }

    public function setOpacity(transform :Sprite, opacity :Float) :Sprite
    {
        transform.opacity = opacity;
        return transform;
    }

    public function setAnchor(transform :Sprite, x :Float, y :Float) :Sprite
    {
        transform.anchorX = x;
        transform.anchorY = y;
        return transform;
    }

    public function setRotation(transform :Sprite, rotation :Float, fromDegrees :Bool = false) :Sprite
    {
        transform.rotation = fromDegrees ? rotation.toRadians() : rotation;
        return transform;
    }

    public function setScale(transform :Sprite, scale :Float) :Sprite
    {
        transform.scaleX = scale;
        transform.scaleY = scale;
        return transform;
    }

    public function setScaleXY(transform :Sprite, scaleX :Float, scaleY :Float) :Sprite
    {
        transform.scaleX = scaleX;
        transform.scaleY = scaleY;
        return transform;
    }

    public function setXY(transform :Sprite, x :Float, y :Float) :Sprite
    {
        transform.x = x;
        transform.y = y;
        return transform;
    }
}