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

import pongo.ecs.System;
import pongo.ecs.Entity;
import pongo.ecs.manager.Manager;
import pongo.platform.input.Keyboard;
import pongo.platform.input.Mouse;
import pongo.platform.display.Graphics;
import pongo.Window;

@:final class Pongo implements pongo.Pongo
{
    public var keyboard (default, null) :Keyboard;
    public var mouse (default, null) :Mouse;
    public var root (default, null):Entity;
    public var manager (default, null):Manager;
    public var window (default, null):Window;

    public static function create(title :String, width :Int, height :Int, cb :Pongo -> Void) : Void
    {
        kha.System.start({title: title, width: width, height: height}, function(window :kha.Window) {
            cb(new Pongo(new pongo.platform.Window(window)));
        });
    }

    private function new(window :Window)  :Void
    {
        kha.System.notifyOnFrames(renderSprites);
        this.window = window;
        this.keyboard = new Keyboard();
        this.mouse = new Mouse();
        this.manager = new Manager();
        _schedulerID = kha.Scheduler.addTimeTask(update, 0, 1/60);
        _systems = new Map<System, System>();
        this.root = this.createEntity();
    }

    public inline function createEntity() : Entity
    {
        return new Entity(manager);
    }

    public function addSystem(system :System) : Pongo
    {
        _systems.set(system, system);
        return this;
    }

    public function removeSystem(system :System) : Pongo
    {
        _systems.remove(system);
        return this;
    }

    public function isMobile() : Bool
    {
        return kha.System.systemId == "HTML5";
    }

    private function update() : Void
    {
        var dt :Float = 0;
        var time = kha.System.time;
        if(_lastTime != -1) {
            dt = time - _lastTime;
        }
        _lastTime = time;

        manager.update();
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
        _render(this, this.root, _graphics);
        _graphics.end();
    }

    private static function _render(pongo :Pongo, entity :Entity, g :Graphics) : Void
    {
        if (entity.visual != null) {
#if !graphics1
            g.save();
            g.transform(entity.visual.getMatrix());
            if(entity.visual.opacity < 1)
                g.multiplyOpacity(entity.visual.opacity);
#end

            if(entity.visual.visible && entity.visual.opacity > 0) {
                entity.visual.draw(pongo, g);
            }
        }

        var p = entity.firstChild;
        while (p != null) {
            var next = p.next;
            _render(pongo, p, g);
            p = next;
        }

#if !graphics1
        // If save() was called, unwind it
        if (entity.visual != null) {
            g.restore();
        }
#end
    }

    private var _graphics :Graphics;
    private var _schedulerID :Int;
    private var _systems :Map<System, System>;
    private var _lastTime :Float = -1;
}