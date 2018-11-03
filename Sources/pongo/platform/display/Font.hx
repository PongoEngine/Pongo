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
}