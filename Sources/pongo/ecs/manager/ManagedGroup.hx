package pongo.ecs.manager;

import pongo.ecs.Entity;
import pongo.ecs.group.SourceGroup;
import pongo.ecs.group.Rules;
using pongo.util.StringUtil;

class ManagedGroup
{
    public function new() : Void
    {
        _classKeys = new Array<Int>();
        _classGroups = new Map<Int, SourceGroup>();
    }

    public inline function handle(entity :Entity, fn :SourceGroup -> Void) : Void
    {
        for(key in _classKeys) {
            var group = _classGroups.get(key);
            if(group.rules.satisfy(entity)) {
                fn(group);
            }
        }
    }

    public function createGroupFromClassNames(classNames :Array<String>) : SourceGroup
    {
        var key = classNames.keyFromStrings();
        if(!_classGroups.exists(key)) {
            _classGroups.set(key, new SourceGroup(Rules.fromStrings(classNames)));
            _classKeys.push(key);
        }
        return _classGroups.get(key);
    }

    public function update() : Void
    {
        var i = 0;
        while(i < _classKeys.length) {
            _classGroups.get(_classKeys[i]).swapQueue();
            i++;
        }
    }

    private var _classKeys :Array<Int>;
    private var _classGroups :Map<Int, SourceGroup>;
}