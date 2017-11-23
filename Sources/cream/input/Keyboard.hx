/*
 * Copyright (c) 2017 Cream Engine
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

package cream.input;

import cream.util.Disposable;
import cream.util.RefVal;
import kha.input.KeyCode;

class Keyboard implements Disposable
{

    public var down (null, set) : KeyCode -> Void;
    public var up (null, set) : KeyCode -> Void;

    public function new() : Void
    {
        kha.input.Keyboard.get().notify(keyDown, keyUp);
        _downListener = {val:null};
        _upListener = {val:null};
    }

    public function dispose() : Void
    {
        kha.input.Keyboard.get().remove(keyDown, keyUp, null);
    }

    private function keyDown(key: KeyCode): Void
    {
        if(_downListener.val != null) {
            _downListener.val(key);
        }
    }

    private function keyUp(key: KeyCode): Void 
    {
        if(_upListener.val != null) {
            _upListener.val(key);
        }
    }

    private function set_down(down :KeyCode -> Void) : KeyCode -> Void
    {
        _downListener.val = down;
        return down;
    }

    private function set_up(up :KeyCode -> Void) : KeyCode -> Void
    {
        _upListener.val = up;
        return up;
    }

    private var _downListener :RefVal<KeyCode -> Void>;
    private var _upListener :RefVal<KeyCode -> Void>;
}