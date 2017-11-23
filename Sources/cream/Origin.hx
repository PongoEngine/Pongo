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

package cream;

import cream.display.Sprite;
import cream.display.Graphics;
import cream.util.Disposable;
import cream.input.Mouse;
import cream.input.Keyboard;
import cream.util.Set;
import cream.util.ComponentArray;

class Origin<Msg:EnumValue, Model> implements Disposable
{
    public var root (default, null):Sprite;
    public var mouse (default, null):Mouse;
    public var keyboard (default, null):Keyboard;

    public function new(model :Model, fnUpdate : Msg -> Origin<Msg, Model> -> Model -> Void)  :Void
    {
        _fnUpdate = fnUpdate;
        _model = model;
        _runningMsgs = new Set();

        root = new Sprite();
        mouse = new Mouse();
        keyboard = new Keyboard();
        
        kha.System.notifyOnRender(renderSprites);
        _schedulerID = kha.Scheduler.addTimeTask(runScheduledMsgs, 0, 1/60);
    }

    public function getGroup(componentNameGroup :Array<String>) : ComponentArray<Sprite>
    {
        var group = [];
        impl_getGroup(componentNameGroup, root, group);
        return group;
    }

    public function message(msg :Msg) : Void
    {
        _fnUpdate(msg, this, _model);
    }

    public function addScheduledMsg(msg :Msg) : Bool
    {
        return _runningMsgs.set(msg);
    }

    public function removeScheduledMsg(msg :Msg) : Bool
    {
        return _runningMsgs.unset(msg);
    }

    public function hasScheduledMsg(msg :Msg) : Bool
    {
        return _runningMsgs.has(msg);
    }

    public function dispose() : Void
    {
        root.dispose();
        mouse.dispose();
        keyboard.dispose();
        kha.Scheduler.removeTimeTask(_schedulerID);

        _graphics = null;
        _model = null;
        _fnUpdate = null;
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

    private function runScheduledMsgs() : Void
    {
        for(msg in _runningMsgs) {
            _fnUpdate(msg, this, _model);
        }
    }

    private function renderSprites(framebuffer: kha.Framebuffer) : Void 
    {
        if(_graphics == null) {
            _graphics = new Graphics(framebuffer);
        }

        _graphics.begin();
        root._render(_graphics);
        _graphics.end();
    }

    private var _graphics :Graphics;
    private var _model :Model;
    private var _fnUpdate :Msg -> Origin<Msg, Model> -> Model -> Void;
    private var _runningMsgs :Set<Msg>;
    private var _schedulerID :Int;
}