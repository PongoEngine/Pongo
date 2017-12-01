/*
 * Copyright (c) 2017 Jeremy Meltingtallow
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

package cream.util;

import haxe.macro.Context;
import haxe.macro.Expr;

class Macro 
{
    public static function build() :Array<Field> 
    {
        var fields = Context.getBuildFields();
        
        var args = [];
        var states = [];
        for (f in fields) {
            switch (f.kind) {
                case FVar(t,_):
                    args.push({name:f.name, type:t, opt:false, value:null});
                    states.push(macro $p{["this", f.name]} = $i{f.name});
                    f.access.push(APublic);
                default:
            }
        }
        fields.push({
            name: "new",
            access: [APublic],
            pos: Context.currentPos(),
            kind: FFun({
                args: args,
                expr: macro $b{states},
                params: [],
                ret: null
            })
        });
        return addComponentNames(fields);
    }

    public static function addComponentNames(fields :Array<Field>):Array<Field> 
    {
        fields.push({
            name:  "COMPONENT_NAME",
            access:  [Access.APublic, Access.AStatic, Access.AInline],
            kind: FieldType.FVar(macro:String, macro $v{Context.getLocalClass().toString()}), 
            pos: Context.currentPos(),
        });

        fields.push({
            name:  "componentName",
            access:  [Access.APublic],
            kind: FieldType.FProp("default", "null", macro $v{Context.getLocalClass().toString()}), 
            pos: Context.currentPos(),
        });

        return fields;
    }
}