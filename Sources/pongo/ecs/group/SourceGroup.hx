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

@:allow(pongo.ecs.Manager)
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

    private function changed(entity :Entity, remove :Bool) : Void
    {
        for(group in _subGroups) {
            if(remove) group.remove(entity);
            else group.add(entity);
        }
    }

    override private function add(entity :Entity) : Bool
    {
        for(group in _subGroups) {
            group.add(entity);
        }
        return super.add(entity);
    }

    override private function remove(entity :Entity) : Bool
    {
        for(group in _subGroups) {
            group.remove(entity);
        }
        return super.remove(entity);
    }

    private var _subGroups :Array<Group>;
}