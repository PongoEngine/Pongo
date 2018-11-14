package pongo.math;

class Rectangle
{
    public var x :Float;
    public var y :Float;
    public var width :Float;
    public var height :Float;

    public inline function new(x :Float, y :Float, width :Float, height :Float) : Void
    {
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
    }

    @:extern public inline function setFrom(rec: Rectangle): Void 
    {
        this.x = rec.x;
        this.y = rec.y;
        this.width = rec.width;
        this.height = rec.height;
    }

    @:extern public inline function clone(): Rectangle 
    {
        return new Rectangle(this.x, this.y, this.width, this.height);
    }

    @:extern public inline function left() :Float
    {
        return this.x;
    }

    @:extern public inline function top() :Float
    {
        return this.y;
    }

    @:extern public inline function right() :Float
    {
        return this.x + this.width;
    }

    @:extern public inline function bottom() :Float
    {
        return this.y + this.height;
    }

    @:extern public inline function centerX() :Float
    {
        return this.x + this.width/2;
    }

    @:extern public inline function centerY() :Float
    {
        return this.y + this.height/2;
    }
}