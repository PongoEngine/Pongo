package pongo.platform.display;

class Font implements pongo.display.Font
{
    public var nativeFont(default, null) : kha.Font;

    public function new(font :kha.Font) : Void
    {
        this.nativeFont = font;
    }

    public function dispose() : Void
    {
        this.nativeFont.unload();
    }

    public inline function width(fontSize :Int, text :String) : Float
    {
        return this.nativeFont.width(fontSize, text);
    }

    public inline function height(fontSize :Int) : Float
    {
        return this.nativeFont.height(fontSize);
    }

    // private inline function get_width() : Float
    // {
    //     return 0;
    // }

    // private inline function get_height() : Float
    // {
    //     return nativeFont.height;
    // }
}