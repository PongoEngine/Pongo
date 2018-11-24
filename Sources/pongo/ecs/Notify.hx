package pongo.ecs;

class Notify
{
    public function notify() : Void
    {
        _component.owner.notifyChange();
    }
    
    public function initialize(component :Component) : Void
    {
        _component = component;
    }

    private var _component :Component;
}