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

import pongo.ecs.Entity;
using pongo.util.Strings;

#if macro
import haxe.macro.Expr;
#end

class Manager
{
    public function new() : Void
    {
        _sourceKeys = new Array<Int>();
        _sourceGroups = new Map<Int, SourceGroup>();
    }

    public function add(entity :Entity) : Void
    {
        for(key in _sourceKeys) {
            _sourceGroups.get(key).add(entity);
        }
    }

    public function removeEntity(entity :Entity) : Void
    {
        for(key in _sourceKeys) {
            _sourceGroups.get(key).remove(entity, "");
        }
    }

    public function removeComponent(entity :Entity, componentName :String) : Void
    {
        for(key in _sourceKeys) {
            _sourceGroups.get(key).remove(entity, componentName);
        }
    }

    public function changed(entity :Entity) : Void
    {
        for(key in _sourceKeys) {
            _sourceGroups.get(key).changed(entity);
        }
    }

    public macro function registerGroup(self:Expr, classes :ExprOf<Array<Class<Component>>>) :ExprOf<SourceGroup>
    {
        return switch (classes.expr) {
            case EArrayDecl(vals): {
                macro $self.createGroupFromClassNames(cast $a{vals.map(function(v) {
                    return macro $v.COMPONENT_NAME;
                })});
            }
            case _: macro throw "err";
        }
    }

    public function createGroupFromClassNames(classNames :Array<String>) : SourceGroup
    {
        var key = classNames.keyFromStrings();
        if(!_sourceGroups.exists(key)) {
            _sourceGroups.set(key, new SourceGroup(Rules.fromStrings(classNames)));
            _sourceKeys.push(key);
        }
        return _sourceGroups.get(key);
    }

    private var _sourceKeys :Array<Int>;
    private var _sourceGroups :Map<Int, SourceGroup>;
}