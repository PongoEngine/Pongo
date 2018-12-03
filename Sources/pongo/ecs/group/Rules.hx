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

abstract Rules(Entity -> String -> Bool) from Entity -> String -> Bool
{
    inline public function new(fn :Entity -> Bool) : Void
    {
        this = function(e, _) {
            return fn(e);
        };
    }

    inline public function satisfy(e :Entity, str :String) : Bool
    {
        return this(e, str);
    }

    inline public static function fromStrings(arra :Array<String>) : Rules
    {
        var hasComponentName = false;
        return function(e :Entity, componentName :String) {
            hasComponentName = componentName == "";
            
            for(str in arra) {
                if(!hasComponentName) {
                    hasComponentName = str == componentName;
                }
                if(!e._components.exists(str)) {
                    return false;
                }
            }
            return true && hasComponentName;
        };
    }
}