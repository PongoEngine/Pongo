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

package pongo.ecs;

#if macro
import haxe.macro.Expr;
#end

import pongo.ecs.Component;
import pongo.ecs.group.Manager;
import pongo.util.Disposable;

class Entity implements Disposable
{
    public var parent (default, null) :Entity = null;
    public var firstChild (default, null) :Entity = null;
    public var next (default, null) :Entity = null;
    public var index (default, null):Int;

    @:allow(pongo.platform.Pongo)
    private function new(manager :Manager) : Void
    {
        this.index = ++Entity.ENTITY_INDEX;
        _components = new Map<String, Component>();
        _manager = manager;
    }

    public function addComponent(component :Component) : Entity
    {
        if(_components.exists(component.componentName)) {
            this.removeComponentByClassName(component.componentName);
        }
        component.owner = this;
        _components.set(component.componentName, component);
        _manager.add(this);
        return this;
    }

    macro public function removeComponent<T:Component>(self:Expr, componentClass :ExprOf<Class<T>>) : ExprOf<Bool>
    {
        return macro $self.removeComponentByClassName($componentClass.COMPONENT_NAME);
    }

    macro public function getComponent<T:Component>(self:Expr, componentClass :ExprOf<Class<T>>) :ExprOf<T>
    {
        var name = macro $componentClass.COMPONENT_NAME;
        return macro $self._internal_unsafeCast($self.getComponentFromName($name), $componentClass);
    }

    @:extern // Inline even in debug builds
    inline public function _internal_unsafeCast<T:Component> (component :Component, cl :Class<T>) :T
    {
        return cast component;
    }

    macro public function hasComponent<T:Component>(self:Expr, componentClass :ExprOf<Class<T>>) : ExprOf<Bool>
    {
        return macro $self.getComponent($componentClass) != null;
    }

    public function createChild(append :Bool=true) : Entity
    {
        var e = new Entity(_manager);
        this.addEntity(e, append);
        return e;
    }

    //
    // Flambe - Rapid game development
    // https://github.com/aduros/flambe/blob/master/LICENSE.txt
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
        _manager.add(entity);

        return this;
    }

    //
    // Flambe - Rapid game development
    // https://github.com/aduros/flambe/blob/master/LICENSE.txt
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
                _manager.removeEntity(entity);
                return;
            }
            prev = p;
            p = next;
        }
        
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
    }

    public function notifyChange() : Void
    {
        _manager.changed(this);
    }

    public function getComponentFromName(name :String) : Component
    {
        return _components.get(name);
    }

    public function removeComponentByClassName(name :String) : Bool
    {
        if(_components.exists(name)) {
            _manager.removeComponent(this, name);
            _components.remove(name);
            return true;
        }
        return false;
    }

    private var _manager :Manager;
    @:allow(pongo.ecs.group.Rules)
    private var _components :Map<String, Component>;
    private static var ENTITY_INDEX :Int = -1;
}