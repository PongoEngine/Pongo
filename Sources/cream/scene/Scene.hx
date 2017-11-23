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

package cream.scene;

import cream.display.Sprite;
import cream.util.Disposable;
import cream.input.Mouse;
import cream.input.Keyboard;
import cream.util.Set;
import cream.util.ComponentArray;
import cream.display.Graphics;

@:final class Scene<Msg:EnumValue, Model> implements Disposable
{
    public var root (default, null):Sprite;
    public var mouse (get, null):Mouse;
    public var keyboard (get, null):Keyboard;
    public var isActive (get, null):Bool;

    public function new(model :Model, initialMsg :Msg, fnUpdate : Msg -> Scene<Msg, Model> -> Model -> Void)  :Void
    {
        _fnUpdate = fnUpdate;
        _model = model;
        _runningMsgs = new Set();
        _isActive = false;

        root = new Sprite();
        
        fireMsg(initialMsg);
    }

    public function getGroup(componentNameGroup :Array<String>) : ComponentArray<Sprite>
    {
        var group = [];
        impl_getGroup(componentNameGroup, root, group);
        return group;
    }

    public function fireMsg(msg :Msg) : Void
    {
        _fnUpdate(msg, this, _model);
    }

    public function addMsg(msg :Msg) : Bool
    {
        return _runningMsgs.set(msg);
    }

    public function removeMsg(msg :Msg) : Bool
    {
        return _runningMsgs.unset(msg);
    }

    public function hasMsg(msg :Msg) : Bool
    {
        return _runningMsgs.has(msg);
    }

    public function dispose() : Void
    {
        root.dispose();
        if(mouse != null) mouse.dispose();
        if(keyboard != null) keyboard.dispose();
    }

    public function render(graphics: Graphics) : Void
    {
        root._render(graphics);
    }

    private function impl_getGroup(componentNameGroup :Array<String>, sprite :Sprite, group :Array<Sprite>): Void 
    {
        var p = sprite.firstChild;
        while (p != null) {
            var next = p.next;
            if(p.hasGroup(componentNameGroup)) {
                group.push(p);
            }
            impl_getGroup(componentNameGroup, p, group);
            p = next;
        }
    }

    private function get_mouse() : Mouse
    {
        if(_mouse == null) {
            _mouse = new Mouse();
        }
        return _mouse;
    }

    private function get_keyboard() : Keyboard
    {
        if(_keyboard == null) {
            _keyboard = new Keyboard();
        }
        return _keyboard;
    }

    private function get_isActive() : Bool
    {
        return _isActive;
    }

    private var _model :Model;
    private var _fnUpdate :Msg -> Scene<Msg, Model> -> Model -> Void;
    @:allow(cream.Origin)
    private var _runningMsgs :Set<Msg>;

    private var _mouse :Mouse;
    private var _keyboard :Keyboard;

    private var _isActive :Bool;
}