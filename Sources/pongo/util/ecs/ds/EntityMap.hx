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

package pongo.util.ecs.ds;

import pongo.Entity;
import pongo.Component;

abstract EntityMap(Map<Int, Map<String, Component>>)
{
    @:extern inline public function new() : Void
    {
        this = new Map<Int, Map<String, Component>>();
    }

    @:extern inline public function getComponent(entity :Entity, name :String) : Component
    {
        if(this.exists(entity.index)) {
            return this.get(entity.index).get(name);
        }
        else {
            return null;
        }
    }

    @:extern inline public function exists(entity :Entity, name :String) : Bool
    {
        return this.exists(entity.index) && this.get(entity.index).exists(name);
    }

    @:extern inline public function removeEntity(entity :Entity) : Bool
    {
        if(this.exists(entity.index)) {
            return this.remove(entity.index);
        }
        return false;
    }

    @:extern inline public function hasComponent(entity :Entity, name :String) : Bool
    {
        return getComponent(entity, name) != null;
    }

    @:extern inline public function addComponent(entity :Entity, component :Component) : Void
    {
        if(!this.exists(entity.index)) {
            this.set(entity.index, new Map<String, Component>());
        }
        this.get(entity.index).set(component.componentName, component);
    }

    @:extern inline public function removeComponent(entity :Entity, name :String) : Bool
    {
        if(this.exists(entity.index)) {
            return this.get(entity.index).remove(name);
        }
        else {
            return false;
        }
    }
    
}