/*
 * Copyright (c) 2017 Jeremy Meltingtallow
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

package pongo.input;

import pongo.util.Disposable;
import pongo.util.RefVal;

class Mouse implements Disposable
{
    public var down (null, set) : Int -> Int -> Int -> Void;
    public var up (null, set) : Int -> Int -> Int -> Void;
    public var move (null, set) : Int -> Int -> Int -> Int -> Void;
    public var wheel (null, set) : Float -> Void;

    public function new() : Void
    {
        kha.input.Mouse.get().notify(downListener, upListener, moveListener, wheelListener);
        _downListener = {val:null};
        _upListener = {val:null};
        _moveListener = {val:null};
        _wheelListener = {val:null};
    }

    public function dispose() : Void
    {
        kha.input.Mouse.get().remove(downListener, upListener, moveListener, wheelListener);
        _downListener = null;
        _upListener = null;
        _moveListener = null;
        _wheelListener = null;
    }

    private function downListener(button :Int, x :Int, y :Int) : Void
    {
        if(_downListener.val != null) {
            _downListener.val(button,x,y);
        }
    }
    
    private function upListener(button :Int, x :Int, y :Int) : Void
    {
        if(_upListener.val != null) {
            _upListener.val(button,x,y);
        }
    }
    
    private function moveListener(a :Int, b :Int, c :Int, d :Int) : Void
    {
        if(_moveListener.val != null) {
            _moveListener.val(a,b,c,d);
        }
    }
    
    private function wheelListener(val :Float) : Void
    {
        if(_wheelListener.val != null) {
            _wheelListener.val(val);
        }
    }

    private function set_down(down :Int -> Int -> Int -> Void) : Int -> Int -> Int -> Void
    {
        _downListener.val = down;
        return down;
    }

    private function set_up(up :Int -> Int -> Int -> Void) : Int -> Int -> Int -> Void
    {
        _upListener.val = up;
        return up;
    }

    private function set_move(move :Int -> Int -> Int -> Int -> Void) : Int -> Int -> Int -> Int -> Void
    {
        _moveListener.val = move;
        return move;
    }

    private function set_wheel(wheel :Float -> Void) : Float -> Void
    {
        _wheelListener.val = wheel;
        return wheel;
    }

    private var _downListener :RefVal<Int -> Int -> Int -> Void>;
    private var _upListener :RefVal<Int -> Int -> Int -> Void>;
    private var _moveListener :RefVal<Int -> Int -> Int -> Int -> Void>;
    private var _wheelListener :RefVal<Float -> Void>;
}