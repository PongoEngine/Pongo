package pongo.display.graphics1;

class PixelSprite extends Sprite
{
    public function new(values :Array<Array<Int>>) : Void
    {
        super();
        _width = getWidth(values);
        _height = getHeight(values);
        _values = values;
    }

    override public function draw(pongo :Pongo, graphics :Graphics) : Void
    {
        var y = 0;
        while(y < _values.length) {
            var x = 0;
            var pixels = _values[y];
            while(x < pixels.length) {
                var color = pixels[x];
                graphics.setPixel(color, x + this.x, y + this.y);
                x++;
            }
            y++;
        }
    }

    override public function getNaturalWidth() : Float
    {
        return _width;
    }

    override public function getNaturalHeight() : Float
    {
        return _height;
    }

    private inline function getWidth(values :Array<Array<Int>>) : Int
    {
        var largestWidth :Int = 0;
        for(value in values) {
            if(value.length > largestWidth) {
                largestWidth = value.length;
            }
        }
        return largestWidth;
    }

    private inline function getHeight(values :Array<Array<Int>>) : Int
    {
        return values.length;
    }

    private var _width :Int;
    private var _height :Int;
    private var _values :Array<Array<Int>>;
}