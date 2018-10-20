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

package pongo.ecs.group;

class EntityList
{
    public var head (default ,null) :EntityNode = null;
    public var tail (default ,null) :EntityNode = null;
    public var size (default, null) :Int = 0;

    @:allow(pongo.ecs.group.SwapEntityList)
    @:allow(pongo.ecs.group.SourceGroup)
    private function new() : Void
    {
        _entityMap = new Map<Int,EntityNode>();
    }

    public inline function exists(entity :Entity) : Bool
    {
        return _entityMap.exists(entity.index);
    }

    public inline function add(entity :Entity) : Bool
    {
        if(!_entityMap.exists(entity.index)) {
            var newNode = new EntityNode(entity);
            if(this.head == null) {
                this.head = newNode;
                this.tail = newNode;
            }
            else {
                insertAfter(this.tail, newNode);
            }
            _entityMap.set(entity.index, newNode);
            this.size++;
            return true;
        }
        return false;
    }

    public function remove(entity :Entity) : Bool
    {
        if(_entityMap.exists(entity.index)) {
            var node = _entityMap.get(entity.index);
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
            _entityMap.remove(entity.index);
            this.size--;
            return true;
        }
        return false;
    }

    public function clear() : Void
    {
        if(size > 0) {
            var p = head;
            while(p != null) {
                this._entityMap.remove(p.entity.index);
                p = p.next;
            }
            this.head = null;
            this.tail = null;
            this.size = 0;
        }
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

    private var _entityMap:Map<Int,EntityNode>;
}

@:allow(pongo)
class EntityNode
{
    public var next (default, null) :EntityNode = null;
    public var prev (default, null) :EntityNode = null;
    public var entity (default, null) :Entity = null;

    public function new(entity :Entity) : Void
    {
        this.entity = entity;
    }
}