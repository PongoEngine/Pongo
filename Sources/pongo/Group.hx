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

import pongo.util.ecs.ds.RuleSet;

@:final class Group
{
    public var rules (default, null):RuleSet;

    public function new(rules :RuleSet) : Void
    {
        this.rules = rules;
        _entityMap = new Map<Int,EntityNode>();
        _list = new EntityList();
    }

    public function exists(entity :Entity) : Bool
    {
        return _entityMap.exists(entity.index);
    }

    public function first() : Entity
    {
        if(_list.head == null) return null;
        return _list.head.entity;
    }

    public function last() : Entity
    {
        if(_list.tail == null) return null;
        return _list.tail.entity;
    }

    public function manipulateAll(fn :Entity -> Void) : Void
    {
        var p = _list.head;
        while(p != null) {
            fn(p.entity);
            p = p.next;
        }
    }

    @:allow(pongo.util.ecs.Manager)
    private function addEntity(entity :Entity) : Void
    {
        var node = new EntityNode(entity);
        _list.add(node);
        _entityMap.set(entity.index, node);
    }

    @:allow(pongo.util.ecs.Manager)
    private function removeEntity(entity :Entity) : Void
    {
        var node = _entityMap.get(entity.index);
        if(node != null) {
            _list.remove(node);
            _entityMap.remove(entity.index);
        }
    }

    private function dispose() : Void
    {
        _entityMap = new Map<Int,EntityNode>();
        _list.head = null;
        _list.tail = null;
    }

    private var _entityMap:Map<Int,EntityNode>;
    private var _list :EntityList;
}

private class EntityList
{
    @:allow(pongo) public var head (default ,null) :EntityNode = null;
    @:allow(pongo) public var tail (default ,null) :EntityNode = null;
    public var size (default, null) :Int = 0;

    public function new() : Void
    {
    }

    public inline function add(newNode :EntityNode) : Void
    {
        if(this.head == null) {
            this.head = newNode;
            this.tail = newNode;
        }
        else {
            insertAfter(this.tail, newNode);
        }
        this.size++;
    }

    public function remove(node :EntityNode) : Void
    {
        if(node.prev == null) {
            this.head = node.next;
        }
        else {
            node.prev.next = node.next;
        }
        if(node.next == null) {
            this.tail = node.prev;
        }
        else {
            node.next.prev = node.prev;
        }
        this.size--;
    }

    private function insertAfter(node :EntityNode, newNode :EntityNode) : Void
    {
        newNode.prev = node;
        if(node.next == null) {
            this.tail = newNode;
        }
        else {
            newNode.next = node.next;
            node.next.prev = newNode;
        }
        node.next = newNode;
    }
}

@:allow(pongo)
private class EntityNode
{
    public var next (default, null) :EntityNode = null;
    public var prev (default, null) :EntityNode = null;
    public var entity (default, null) :Entity = null;

    public function new(entity :Entity) : Void
    {
        this.entity = entity;
    }
}