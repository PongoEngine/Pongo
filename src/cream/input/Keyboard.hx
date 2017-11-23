package cream.input;

import cream.util.Disposable;
import cream.util.RefVal;
import kha.input.KeyCode;

class Keyboard implements Disposable
{

    public var down (null, set) : KeyCode -> Void;
    public var up (null, set) : KeyCode -> Void;

    public function new() : Void
    {
        kha.input.Keyboard.get().notify(keyDown, keyUp);
        _downListener = {val:null};
        _upListener = {val:null};
    }

    public function dispose() : Void
    {
        kha.input.Keyboard.get().remove(keyDown, keyUp, null);
    }

    private function keyDown(key: KeyCode): Void
    {
        if(_downListener.val != null) {
            _downListener.val(key);
        }
    }

    private function keyUp(key: KeyCode): Void 
    {
        if(_upListener.val != null) {
            _upListener.val(key);
        }
    }

    private function set_down(down :KeyCode -> Void) : KeyCode -> Void
    {
        _downListener.val = down;
        return down;
    }

    private function set_up(up :KeyCode -> Void) : KeyCode -> Void
    {
        _upListener.val = up;
        return up;
    }

    private var _downListener :RefVal<KeyCode -> Void>;
    private var _upListener :RefVal<KeyCode -> Void>;
}