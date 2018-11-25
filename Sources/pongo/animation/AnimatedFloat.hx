package pongo.animation;

import pongo.animation.Ease;

class AnimatedFloat
{
    public var value (default, null) : Float;

    public function new(value :Float) : Void
    {
        this.value = value;
        _tween = new Tween(value, value, 0);
    }

    public function update (dt :Float)
    {
        var val = _tween.update(dt);
        if(val != this.value) {
            this.value = val;
        }
    }

    public function animateTo(to :Float, seconds :Float, ?easing :EaseFunction) : Void
    {
        _tween.reset(this.value, to, seconds, easing);
    }

    public function animateBy(by :Float, seconds :Float, ?easing :EaseFunction) : Void
    {
        _tween.reset(this.value, this.value + by, seconds, easing);
    }

    private var _tween :Tween = null;
}