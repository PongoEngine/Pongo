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

package pongo.ecs;

import pongo.ecs.Entity;
import pongo.ecs.Group;
import pongo.ecs.util.RuleSet;
using pongo.util.StringUtil;

#if macro
using haxe.macro.ExprTools;
import haxe.macro.TypeTools;
import haxe.macro.Expr;
import haxe.macro.Context;
#end

@:allow(pongo) class Manager
{
    public function new() : Void
    {
        _keys = new Array<Int>();
        _groups = new Map<Int, Group>();
    }

    public function notifyAdd(entity :Entity) : Void
    {
        for(key in _keys) {
            var rules = _groups.get(key).rules;
            var group = _groups.get(key);
            if(entity.hasAllRules(rules)) {
                group.add(entity);
            }
        }
    }

    public function notifyRemove(entity :Entity) : Void
    {
        for(key in _keys) {
            var rules = _groups.get(key).rules;
            var group = _groups.get(key);
            if(entity.hasAllRules(rules)) {
                group.remove(entity);
            }
        }
    }

    public function notifyAddChanged(entity :Entity) : Void
    {
        for(key in _keys) {
            var rules = _groups.get(key).rules;
            var group = _groups.get(key);
            if(entity.hasAllRules(rules)) {
                group.queueChanged(entity);
            }
        }
    }

    macro public function registerGroup(self:Expr, componentClass :ExprOf<Array<Class<Component>>>) :ExprOf<Group>
    {
        return switch (componentClass.expr) {
            case EArrayDecl(vals): {
                macro $self.createGroup(cast $a{vals.map(function(v) {
                    return macro $v.COMPONENT_NAME;
                })});
            }
            case _: macro throw "err";
        }
    }

    public function createGroup(classNames :Array<String>) : Group
    {
        var key = classNames.keyFromStrings();
        if(!_groups.exists(key)) {
            _groups.set(key, new Group(RuleSet.fromArray(classNames)));
            _keys.push(key);
        }
        return _groups.get(key);
    }

    private function updateChanged() : Void
    {
        var i = 0;
        while(i < _keys.length) {
            _groups.get(_keys[i]).swapQueue();
            i++;
        }
    }

    private var _keys :Array<Int>;
    private var _groups :Map<Int, Group>;
}