package pongo.ecs.ds;

@:allow(pongo)
class EntityList
{
    public var head (default ,null) :EntityNode = null;
    public var tail (default ,null) :EntityNode = null;
    public var size (default, null) :Int = 0;

    private function new() : Void
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