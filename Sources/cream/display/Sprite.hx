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

import kha.math.FastMatrix3;
import kha.math.FastVector2;
import cream.Component;
import cream.util.Disposable;

using cream.math.CMath;

class Sprite implements Disposable
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
    public var active :Bool = true;

    public var name :String = "";

    public var parent (default, null):Sprite = null;
    public var firstChild (default, null):Sprite = null;
    public var next (default, null):Sprite = null;

    public function new() : Void
    {
        _components = new Map<String, Component>();
    }

    /**
     *  [Description]
     *  @param component - 
     *  @return Sprite
     */
    public function addComponent(component :Component) : Sprite
    {
        _components.set(component.componentName, component);
        return this;
    }

    /**
     *  [Description]
     *  @param componentName - 
     *  @return Sprite
     */
    public function removeComponent(componentName :String) : Sprite
    {
        _components.remove(componentName);
        return this;
    }

    /**
     *  [Description]
     *  @param className - 
     *  @param componentName - 
     *  @return T
     */
    public function get<T:Component>(className :Class<T>, componentName :String) :T
    {
        return cast _components.get(componentName);
    }

    /**
     *  [Description]
     *  @param graphics - 
     */
    public function draw(graphics: Graphics) : Void
    {
    }

    /**
     *  [Description]
     *  @param componentName - 
     *  @return Bool
     */
    public function has(componentName :String) :Bool
    {
        return _components.exists(componentName);
    }

    /**
     *  [Description]
     *  @param componentNameGroup - 
     *  @return Bool
     */
    public function hasGroup(componentNameGroup :Array<String>) :Bool
    {
        for(name in componentNameGroup) {
            if(!_components.exists(name)) {
                return false;
            }
        }
        return true;
    }

    /**
     *  [Description]
     *  @param child - 
     *  @return Sprite
     */
    @:final public function addSprite(child :Sprite) : Sprite
    {
        if (child.parent != null)
            child.parent.removeSprite(child);
        child.parent = this;

        var tail = null, p = firstChild;
        while (p != null) {
            tail = p;
            p = p.next;
        }
        if (tail != null)
            tail.next = child;
        else
            firstChild = child;

        return this;
    }	

    /**
     *  [Description]
     *  @param child - 
     */
    @:final public function removeSprite(child :Sprite) : Void
    {
        var prev :Sprite = null, p = firstChild;
        while (p != null) {
            var next = p.next;
            if (p == child) {
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
     *  [Description]
     *  @return Float
     */
    public function getNaturalWidth() : Float
    {
        return 0;
    }

    /**
     *  [Description]
     *  @return Float
     */
    public function getNaturalHeight() : Float
    {
        return 0;
    }

    /**
     *  [Description]
     */
    public function dispose() : Void
    {
        if(this.parent != null) {
            this.parent.removeSprite(this);
        }
        var p = this.firstChild;
        while(p != null) {
            var next = p.next;
            p.dispose();
            p = next;
        }
        
        for(comp in _components) {
            comp.dispose();
        }
    }

    /**
     *  [Description]
     *  @param viewX - 
     *  @param viewY - 
     *  @return Bool
     */
    public function contains(viewX :Float, viewY :Float) :Bool
    {
        var matrix = getMatrix();
        var p = this.parent;
        while(p != null) {
            matrix.setFrom(p.getMatrix().multmat(matrix));
            p = p.parent;
        }
        var nFVec = matrix.inverse().multvec(new FastVector2(viewX,viewY));
        return containsLocal(nFVec.x, nFVec.y);
    }

    /**
     *  [Description]
     *  @param localX - 
     *  @param localY - 
     *  @return Bool
     */
    public function containsLocal (localX :Float, localY :Float) :Bool
    {
        return localX >= 0 && localX < getNaturalWidth()
            && localY >= 0 && localY < getNaturalHeight();
    }

    /**
     *  [Description]
     *  @return FastMatrix3
     */
    @:extern private inline function getMatrix() : FastMatrix3
    {
        var sin = Math.sin(rotation.toRadians());
        var cos = Math.cos(rotation.toRadians());

        return new FastMatrix3(
            cos*scaleX, -sin*scaleY, x,
            sin*scaleX, cos*scaleY, y,
            0, 0, 1
        ).multmat(FastMatrix3.translation(-anchorX, -anchorY));
    }

    /**
     *  [Description]
     *  @param graphics - 
     */
    @:allow(cream.Origin)
    @:allow(cream.scene.Scene)
    @:final private function _render(graphics: Graphics): Void 
    {
        graphics.save();

        graphics.transform(getMatrix());
        if(opacity < 1)
            graphics.multiplyOpacity(this.opacity);

        if(visible && opacity > 0) {
            draw(graphics);
            var p = firstChild;
            while(p != null) {
                p._render(graphics);
                p = p.next;
            }
        }

        graphics.restore();
    }

    private var _components (default, null): Map<String, Component>;
}