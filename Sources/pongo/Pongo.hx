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

package pongo;

import pongo.display.Graphics;
import pongo.util.Disposable;
import pongo.ecs.Engine;
import pongo.input.Keyboard;

@:final class Pongo
{
    public var width (get, null) :Int;
    public var height (get, null) :Int;
    public var engine (default, null) :Engine;
    public var keyboard (default, null) :Keyboard;

    public function new()  :Void
    {
        kha.System.notifyOnFrames(renderSprites);
        this.engine = new Engine();
        this.keyboard = new Keyboard();
        _schedulerID = kha.Scheduler.addTimeTask(update, 0, 1/60);
        _systems = new Map<String, Pongo -> Float -> Void>();
    }

    public function addSystem(name :String, fn :Pongo -> Float -> Void) : Void
    {
        _systems.set(name, fn);
    }

    public function removeSystem(name :String) : Void
    {
        _systems.remove(name);
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
            system(this, dt);
        }
        engine.update();
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
    private var _systems :Map<String, Pongo -> Float -> Void>;
    private var _lastTime :Float = -1;
}