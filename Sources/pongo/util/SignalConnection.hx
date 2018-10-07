//
// Flambe - Rapid game development
// https://github.com/aduros/flambe/blob/master/LICENSE.txt

package pongo.util;

/**
 * Represents a connected signal listener.
 */
class SignalConnection implements Disposable
{
    /**
     * True if the listener will remain connected after being used.
     */
    public var stayInList (default, null) :Bool;

    @:allow(pongo) function new (signal :SignalBase, listener :Dynamic)
    {
        _signal = signal;
        _listener = listener;
        stayInList = true;
    }

    /**
     * Tells the connection to dispose itself after being used once.
     * @returns This instance, for chaining.
     */
    public function once ()
    {
        stayInList = false;
        return this;
    }

    /**
     * Disconnects the listener from the signal.
     */
    public function dispose ()
    {
        if (_signal != null) {
            _signal.disconnect(this);
            _signal = null;
        }
    }

    @:allow(pongo) var _next :SignalConnection = null;

    @:allow(pongo) var _listener :Dynamic;
    private var _signal :SignalBase;
}
