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