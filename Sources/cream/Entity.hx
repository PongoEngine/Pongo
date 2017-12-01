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

package cream;

import cream.Component;
import cream.util.Disposable;

class Entity implements Disposable
{
    public var parent (default, null):Entity = null;
    public var firstChild (default, null):Entity = null;
    public var next (default, null):Entity = null;
    public var kind (default, null):EntityType = CORE;

    public function new() : Void
    {
        _components = new Map<String, Component>();
    }

    /**
     *  [Description]
     *  @param component - 
     *  @return Entity
     */
    public function addComponent(component :Component) : Entity
    {
        _components.set(component.componentName, component);
        return this;
    }

    /**
     *  [Description]
     *  @param componentName - 
     *  @return Entity
     */
    public function removeComponent(componentName :String) : Entity
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
     *  @return Entity
     */
    @:final public function addEntity(child :Entity) : Entity
    {
        if (child.parent != null)
            child.parent.removeEntity(child);
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
    @:final public function removeEntity(child :Entity) : Void
    {
        var prev :Entity = null, p = firstChild;
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
     */
    public function dispose() : Void
    {
        if(this.parent != null) {
            this.parent.removeEntity(this);
        }
        var p = this.firstChild;
        while(p != null) {
            var next = p.next;
            p.dispose();
            p = next;
        }
    }

    private var _components (default, null): Map<String, Component>;
}