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

import pongo.asset.Manifest;
import pongo.platform.asset.AssetPack;
import pongo.platform.input.Keyboard;
import pongo.platform.input.Mouse;
import pongo.platform.display.Graphics;
import pongo.Window;
import pongo.ecs.Apollo;
import pongo.display.Sprite;

@:final class Pongo<T> implements pongo.Pongo<T>
{
    public var keyboard (default, null) :Keyboard;
    public var mouse (default, null) :Mouse;
    public var window (default, null):Window;
    public var ecs (default, null):Apollo<T>;
    public var root (default, null):Sprite;

    public static function create<T>
        (title :String, width :Int, height :Int, data :T, cb :Pongo<T> -> Void) : Void
    {
        kha.System.start({title: title, width: width, height: height}, function(window :kha.Window) {
            cb(new Pongo(width, height, new pongo.platform.Window(window, width, height), data));
        });
    }

    private function new(width :Int, height :Int, window :Window, data :T)  :Void
    {
        this.ecs = new Apollo(data);
        this.root = new Sprite();
        
        kha.System.notifyOnFrames(function(buffers) {
            if(_graphics == null) {
                _graphics = new Graphics(buffers[0], width, height);
            }

            _graphics.begin();
            Pongo.render(this.root, _graphics);
            _graphics.end();
        });

        this.window = window;
        this.keyboard = new Keyboard();
        this.mouse = new Mouse();
        _schedulerID = kha.Scheduler.addTimeTask(update, 0, 1/60);
    }

    public function isWeb() : Bool
    {
        return kha.System.systemId == "HTML5";
    }

    public inline function loadManifest(manifest :Manifest, cb :pongo.asset.AssetPack -> Void) : Void
    {
        AssetPack.loadManifest(manifest, cb);
    }

    private function update() : Void
    {
        var dt :Float = 0;
        var time = kha.System.time;
        if(_lastTime != -1) {
            dt = time - _lastTime;
        }
        _lastTime = time;

        this.ecs.update(dt);
    }

    private static function render(sprite :Sprite, g :Graphics) : Void
    {
        if (!sprite.visible || sprite.opacity <= 0) {
            return; // Prune traversal, this sprite and all children are invisible
        }

        g.save();
        g.transform(sprite.matrix);
        g.setBlendMode(sprite.blendMode);
        if(sprite.opacity < 1) {
            g.multiplyOpacity(sprite.opacity);
        }

        if(sprite != null) {
            sprite.draw(g);
        }

        var p = sprite.firstChild;
        while (p != null) {
            var next = p.next;
            render(p, g);
            p = next;
        }

        g.restore();
    }

    private var _graphics :Graphics;
    private var _schedulerID :Int;
    private var _lastTime :Float = -1;
}