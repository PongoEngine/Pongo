/*
 * Copyright (c) 2018 Jeremy Meltingtallow
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
 * Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN
 * AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
 * THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

package pongo.ecs.group;

@:allow(pongo.ecs.group.Manager)
class SourceGroup extends Group
{
    private function new(rules :Rules) : Void
    {
        super(rules);
        _subGroups = [];
    }

    public function createSubGroup(rule :Entity -> Bool) : Group
    {
        var subGroup = new Group(new Rules(rule));
        _subGroups.push(subGroup);
        return subGroup;
    }

    override private function add(entity :Entity) : Bool
    {
        var hasAdded = super.add(entity);
        if(hasAdded) {
            for(sub in _subGroups) {
                sub.add(entity);
            }
        }
        return hasAdded;
    }

    override private function remove(entity :Entity, str :String, force :Bool = false) : Bool
    {
        var hasRemoved = super.remove(entity, str);
        if(hasRemoved) {
            for(sub in _subGroups) {
                sub.remove(entity, str, hasRemoved);
            }
        }
        return hasRemoved;
    }

    override private function changed(entity :Entity) : Void
    {
        super.changed(entity);
        if(_rules.satisfy(entity, "")) {
            for(sub in _subGroups) {
                sub.changed(entity);
            }
        }
    }

    private var _subGroups :Array<Group>;
}