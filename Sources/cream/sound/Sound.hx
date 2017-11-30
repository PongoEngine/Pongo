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
        kha.audio2.Audio1.play(_nativeSound, false);
    }

    public function dispose() : Void
    {
        _nativeSound.unload();
    }

    private var _nativeSound :kha.Sound;
}