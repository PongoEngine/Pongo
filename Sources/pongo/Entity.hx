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

package pongo;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
using haxe.macro.ExprTools;
#end

import pongo.Component;
import pongo.util.ecs.Manager;
import pongo.util.Disposable;

@:final class Entity implements Disposable
{
    public var parent (default, null) :Entity = null;
    public var firstChild (default, null) :Entity = null;
    public var next (default, null) :Entity = null;
    public var index (default, null):Int;
    public var isDisposed (default, null):Bool;

    @:allow(pongo.util.ecs.Manager)
    private function new(manager :Manager) : Void
    {
        this.index = ++Entity.ENTITY_INDEX;
        _manager = manager;
        isDisposed = false;
    }

    /**
     * [Description]
     * @param component 
     * @return Entity
     */
    public inline function addComponent(component :Component) : Entity
    {
        if(_manager._entityMap.exists(this, component.componentName)) {
            this.removeComponentByClassName(component.componentName);
        }
        _manager.notifyAddComponent(this, component);
        return this;
    }

    /**
     * [Description]
     * @param component 
     */
    macro public function removeComponent<T:Component>(self:Expr, componentClass :ExprOf<Class<T>>) : ExprOf<Bool>
    {
        return macro $self.removeComponentByClassName($componentClass.COMPONENT_NAME);
    }

    /**
     * [Description]
     * @param self 
     * @param componentClass 
     * @return ExprOf<T>
     */
    macro public function getComponent<T:Component>(self:Expr, componentClass :ExprOf<Class<T>>) :ExprOf<T>
    {
        return macro cast $self.getComponentFromName($componentClass.COMPONENT_NAME);
    }

    /**
     * [Description]
     * @param name 
     * @return Bool
     */
    macro public function hasComponent<T:Component>(self:Expr, componentClass :ExprOf<Class<T>>) : ExprOf<Bool>
    {
        return macro $self.getComponent($componentClass) != null;
    }

    //
    // Flambe - Rapid game development
    // https://github.com/aduros/flambe/blob/master/LICENSE.txt
    /**
     * [Description]
     * @param entity 
     * @param append 
     * @return Entity
     */
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

    //
    // Flambe - Rapid game development
    // https://github.com/aduros/flambe/blob/master/LICENSE.txt
    /**
     * [Description]
     * @param entity 
     */
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
                _manager.notifyRemoveEntity(entity);
                return;
            }
            prev = p;
            p = next;
        }
        
    }

    /**
     * [Description]
     * @param sprite 
     * @return Entity
     */
    public function setSprite(sprite :pongo.display.Sprite) : Entity
    {
        this.sprite = sprite;
        return this;
    }

    /**
     * [Description]
     */
    public function disposeChildren ()
    {
        while (firstChild != null) {
            firstChild.dispose();
        }
    }

    /**
     * [Description]
     */
    public function dispose ()
    {
        this.isDisposed = true;
        if (parent != null) {
            parent.removeEntity(this);
        }
        disposeChildren();
        _manager._entityMap.removeEntity(this);
        // _manager = null; //FIX
    }

    public inline function getComponentFromName(name :String) : Component
    {
        return _manager._entityMap.getComponent(this, name);
    }

    public inline function removeComponentByClassName(name :String) : Bool
    {
        if(_manager._entityMap.exists(this, name)) {
            _manager.notifyRemoveComponent(this, name);
            return true;
        }
        return false;
    }

    public var sprite (default, null):pongo.display.Sprite = null;
    private var _manager :Manager;
    private static var ENTITY_INDEX :Int = -1;
}