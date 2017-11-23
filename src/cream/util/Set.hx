package cream.util;

import haxe.ds.EnumValueMap;

@:forward(iterator)
abstract Set<K:EnumValue>(EnumValueMap<K, K> )
{
    public function new() : Void
    {
        this = new EnumValueMap();
    }

    public function has(val:K) :Bool 
    {
        return this.exists(val);
    }

    public function set(val:K) :Bool 
    {
        if(this.exists(val)) return false;

        this.set(val, val);
        return true;
    }

    public function unset(val:K) :Bool 
    {
        return this.remove(val);
    }
}