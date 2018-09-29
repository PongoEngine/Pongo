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

package pongo.pecs;

import pongo.pecs.Component;
import pongo.pecs.Manager;
import pongo.util.Disposable;
import pongo.display.Sprite;

@:final class Entity implements Disposable
{
    public var sprite (default, null):Sprite = null;
    public var parent (default, null) :Entity = null;
    public var firstChild (default, null) :Entity = null;
    public var next (default, null) :Entity = null;

    @:allow(pongo.pecs.Manager)
    private function new(manager :Manager) : Void
    {
        _index = ++Entity.ENTITY_INDEX;
        _manager = manager;
        _components = new Map<String, Component>();
    }

    public function addComponent(component :Component) : Entity
    {
        if(_components.exists(component.name)) {
            this.removeComponent(component.name);
        }
        _components.set(component.name, component);
        _manager.notifyAddComponent(this);
        return this;
    }

    public function removeComponent(name :String) : Void
    {
        var comp = _components.get(name);
        _manager.notifyRemoveComponent(this);
        _components.remove(name);
    }

    public function getComponent(name :String) : Component
    {
        return _components.get(name);
    }

    public function hasComponent(name :String) : Bool
    {
        return _components.get(name) != null;
    }

    public function addEntity(entity :Entity, append :Bool=true) : Entity
    {
        if (entity.parent != null) {
            entity.parent.removeEntity(entity);
        }
        entity.parent = this;

        if (append) {
            // Append it to the child list
            var tail = null, p = firstChild;
            while (p != null) {
                tail = p;
                p = p.next;
            }
            if (tail != null) {
                tail.next = entity;
            } else {
                firstChild = entity;
            }

        } else {
            // Prepend it to the child list
            entity.next = firstChild;
            firstChild = entity;
        }
        _manager.notifyAddEntity(entity);

        return this;
    }

    public function removeEntity(entity :Entity) : Void
    {
        var prev :Entity = null, p = firstChild;
        while (p != null) {
            var next = p.next;
            if (p == entity) {
                // Splice out the entity
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
        _manager.notifyRemoveEntity(entity);
    }

    public function setSprite(sprite :Sprite) : Entity
    {
        this.sprite = sprite;
        return this;
    }

    public function disposeChildren ()
    {
        while (firstChild != null) {
            firstChild.dispose();
        }
    }

    public function dispose ()
    {
        if (parent != null) {
            parent.removeEntity(this);
        }
        disposeChildren();
        _manager = null;
        for(c in _components) {
            _components.remove(c.name);
        }
    }

    private var _manager :Manager;
    private var _parent :Entity;
    private var _components :Map<String, Component>;
    @:allow(pongo.pecs.EntityGroup)
    private var _index :Int;
    
    private static var ENTITY_INDEX :Int = -1;
}