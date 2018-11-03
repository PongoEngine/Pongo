package pongo.platform.display;

import kha.Image;

class Texture implements pongo.display.Texture
{
    public var width(get, null):Int;
    public var height(get, null):Int;
    public var nativeTexture (default, null):Image;

    public function new(image :Image) : Void
    {
        nativeTexture = image;
    }

    private inline function get_width() : Int
    {
        return nativeTexture.width;
    }

    private inline function get_height() : Int
    {
        return nativeTexture.height;
    }

    public function dispose() : Void
    {
        nativeTexture.unload();
    }

}