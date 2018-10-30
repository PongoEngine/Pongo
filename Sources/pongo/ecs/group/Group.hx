package pongo.ecs.group;

import pongo.ecs.group.Rules;
import pongo.ecs.group.Rules;

interface Group
{
    public var rules (default, null):Rules;
    public var length (get, null):Int;

    public function first() : Entity;

    public function last() : Entity;

    public function iterate(fn :Entity -> Void) : Void;
    public function iterateWithEscape(fn :Entity -> Bool) : Void;
}