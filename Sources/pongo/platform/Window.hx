/*
 * Copyright (c) 2020 Jeremy Meltingtallow
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

package pongo.platform;

import pongo.util.Signal2;

class Window implements pongo.Window
{
	public var x(get, set): Int;
	public var y(get, set): Int;
	public var width(default, set): Int;
	public var height(default, set): Int;
    public var onResize(default, null): Signal2<Int, Int>;

    public function new(nativeWindow :kha.Window, width :Int, height :Int) : Void
    {
        _nativeWindow = nativeWindow;
        _nativeWindow.width = this.width = width;
        _nativeWindow.height = this.height = height;
        onResize = new Signal2<Int, Int>();
        _nativeWindow.notifyOnResize(function(width :Int, height :Int) {
            onResize.emit(width, height);
        });
    }

    public inline function resize(width: Int, height: Int): Void
    {
        this.width = width;
        this.height = height;
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

    private inline function set_width(width :Int) : Int
    {
        return _nativeWindow.width = this.width = width;
    }

    private inline function set_height(height :Int) : Int
    {
        return _nativeWindow.height = this.height = height;
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