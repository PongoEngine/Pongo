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

package pongo.platform.input;

import pongo.util.Signal1;
import pongo.util.Signal3;
import pongo.util.Signal4;

class Mouse implements pongo.input.Mouse
{

    public var wheel (default, null) : Signal1<Float>;
    public var down (default, null) : Signal3<Int, Int, Int>;
    public var up (default, null) : Signal3<Int, Int, Int>;
    public var move (default, null) : Signal4<Int, Int, Int, Int>;

    public function new() : Void
    {
        _mouse = kha.input.Mouse.get(0);
        _mouse.notify(downListener, upListener, moveListener, wheelListener);

        wheel = new Signal1<Float>();
        down = new Signal3<Int, Int, Int>();
        up = new Signal3<Int, Int, Int>();
        move = new Signal4<Int, Int, Int, Int>();
    }

    public function dispose() : Void
    {
        _mouse.remove(downListener, upListener, moveListener, wheelListener);
        _mouse = null;
    }

    private function downListener(button :Int, x :Int, y :Int) : Void
    {
        down.emit(button,x, y);
    }
    
    private function upListener(button :Int, x :Int, y :Int) : Void
    {
        down.emit(button,x, y);
    }
    
    private function moveListener(a :Int, b :Int, c :Int, d :Int) : Void
    {
        move.emit(a,b,c,d);
    }
    
    private function wheelListener(val :Float) : Void
    {
        wheel.emit(val);
    }

    private var _mouse :kha.input.Mouse;
}