package pongo.sound;

interface Playback
{
    var length(get, null): Float;
	var position(get, null): Float;
	var volume(get, set): Float;
	var finished(get, null): Bool;
    var paused (get, set) :Bool;
    function stop() : Void;
}