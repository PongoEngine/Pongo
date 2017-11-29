package cream.sound;

import cream.util.Disposable;


class Sound implements Disposable
{
    public function new(s :kha.Sound) : Void
    {
        _nativeSound = s;
    }

    public function play(volume :Float = 1.0) : Void
    {
        kha.audio1.Audio.play(_nativeSound);
    }

    public function loop(volume :Float = 1.0) : Void
    {
        kha.audio1.Audio.play(_nativeSound, true);
    }

    public function dispose() : Void
    {
        _nativeSound.unload();
    }

    private var _nativeSound :kha.Sound;
}