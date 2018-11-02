package pongo.platform;

import pongo.util.Signal2;

class Window implements pongo.Window
{
	public var x(get, set): Int;
	public var y(get, set): Int;
	public var width(get, set): Int;
	public var height(get, set): Int;
    public var onResize(default, null): Signal2<Int, Int>;

    public function new(nativeWindow :kha.Window) : Void
    {
        _nativeWindow = nativeWindow;
        onResize = new Signal2<Int, Int>();
        _nativeWindow.notifyOnResize(function(width :Int, height :Int) {
            onResize.emit(width, height);
        });
    }

    public inline function resize(width: Int, height: Int): Void
    {
        _nativeWindow.resize(width, height);
    }

	public inline function move(x: Int, y: Int): Void
    {
        _nativeWindow.move(x, y);
    }

    public inline function attemptWindow() : Void
    {
        _nativeWindow.mode = kha.WindowMode.Windowed;
    }

	public inline function attemptFullScreen() : Void
    {
        _nativeWindow.mode = kha.WindowMode.Fullscreen;
    }

    private inline function get_width() : Int
    {
        return _nativeWindow.width;
    }

    private inline function set_width(width :Int) : Int
    {
        return _nativeWindow.width = width;
    }

    private inline function get_height() : Int
    {
        return _nativeWindow.height;
    }

    private inline function set_height(height :Int) : Int
    {
        return _nativeWindow.height = height;
    }

    private inline function get_x() : Int
    {
        return _nativeWindow.x;
    }

    private inline function set_x(x :Int) : Int
    {
        return _nativeWindow.x = x;
    }

    private inline function get_y() : Int
    {
        return _nativeWindow.y;
    }

    private inline function set_y(y :Int) : Int
    {
        return _nativeWindow.y = y;
    }

    private var _nativeWindow :kha.Window;
}