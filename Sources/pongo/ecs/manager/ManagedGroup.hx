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

package pongo.ecs.manager;

import pongo.ecs.Entity;
import pongo.ecs.group.SourceGroup;
import pongo.ecs.group.Rules;
using pongo.util.Strings;

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