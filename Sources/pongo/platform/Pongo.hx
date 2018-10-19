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

package pongo.platform;

import pongo.ecs.Engine;
import pongo.ecs.System;
import pongo.platform.input.Keyboard;
import pongo.platform.input.Mouse;
import pongo.platform.display.Graphics;

@:final class Pongo implements pongo.Pongo
{
    public var width (get, null) :Int;
    public var height (get, null) :Int;
    public var engine (default, null) :Engine;
    public var keyboard (default, null) :Keyboard;
    public var mouse (default, null) :Mouse;

    public function new()  :Void
    {
        kha.System.notifyOnFrames(renderSprites);
        this.engine = new Engine();
        this.keyboard = new Keyboard();
        this.mouse = new Mouse();
        _schedulerID = kha.Scheduler.addTimeTask(update, 0, 1/60);
        _systems = new Map<System, System>();
    }

    public function create() : pongo.Pongo
    {
        return new Pongo();
    }

    public function addSystem(system :System) : Void
    {
        _systems.set(system, system);
    }

    public function removeSystem(system :System) : Void
    {
        _systems.remove(system);
    }

    private function update() : Void
    {
        var dt :Float = 0;
        var time = kha.Scheduler.time();
        if(_lastTime != -1) {
            dt = time - _lastTime;
        }
        _lastTime = time;

        for(system in _systems) {
            system.update(this, dt);
        }
    }

    private function renderSprites(framebuffer: Array<kha.Framebuffer>) : Void 
    {
        if(_graphics == null) {
            _graphics = new Graphics(framebuffer[0]);
        }

        _graphics.begin();
        this.engine.render(_graphics);
        _graphics.end();
    }

    private function get_width() : Int
    {
        return kha.System.windowWidth();
    }

    private function get_height() : Int
    {
        return kha.System.windowHeight();
    }

    private var _graphics :Graphics;
    private var _schedulerID :Int;
    private var _systems :Map<System, System>;
    private var _lastTime :Float = -1;
}