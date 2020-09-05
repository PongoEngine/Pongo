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

package pongo.platform.sound;

class Playback implements pongo.sound.Playback
{
    public var nativeChannel (default, null):kha.audio1.AudioChannel;

    public var length(get, null): Float;
	public var position(get, null): Float;
	public var volume(get, set): Float;
	public var finished(get, null): Bool;
    public var paused (get, set) :Bool;

    public function new(channel :kha.audio1.AudioChannel) : Void
    {
        this.nativeChannel = channel;  
        _paused = false; 
    }

    public inline function stop() : Void
    {
        this.nativeChannel.stop();
    }

    private inline function get_length() : Float
    {
        return this.nativeChannel.length;
    }

    private inline function get_position() : Float
    {
        return this.nativeChannel.position;
    }

    private inline function get_volume() : Float
    {
        return this.nativeChannel.volume;
    }

    private inline function set_volume(volume :Float) : Float
    {
        return this.nativeChannel.volume = volume;
    }

    private inline function get_finished() : Bool
    {
        return this.nativeChannel.finished;
    }

    private inline function get_paused() : Bool
    {
        return _paused;
    }

    private function set_paused(paused :Bool) : Bool
    {
        _paused = paused;
        if(_paused) {
            this.nativeChannel.pause();
        }
        else {
            this.nativeChannel.play();
        }
        return _paused;
    }

    private var _paused :Bool;
}