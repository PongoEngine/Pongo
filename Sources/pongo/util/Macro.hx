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

package pongo.util;

import haxe.macro.Context;
import haxe.macro.Expr;
using haxe.macro.ComplexTypeTools;
using haxe.macro.TypeTools;

class Macro 
{
#if macro
    macro public static function build() :Array<Field> 
    {
        var fields = Context.getBuildFields();
        var pos = Context.currentPos();
        var things = Context.getLocalType();

        var args = [];
        var states = [];
        var i :Int = 0;
        var length = fields.length;
        while (i < length) {
            var field = fields[i];
            switch (field.kind) {
                case FVar(type,expr): {
                    if(isReactive(field.meta)) {
                        field.kind = FieldType.FProp("get", "set", type);
                        var getter:Function = { 
                            expr: macro {
                                return $i{("_" + field.name)};
                            },
                            ret: type,
                            args:[]
                        }
                                    
                        var setter:Function = { 
                            expr: macro {
                                if($i{"_" + field.name} != $i{field.name}) {
                                    $i{"_" + field.name} = $i{field.name};
                                    this.hasChanged = true;
                                    if(this.owner != null) {
                                        this.owner.notifyChange();
                                    }
                                }
                                return $i{("_" + field.name)};
                            },
                            ret: type,
                            args:[{name:field.name, type: type, opt:false, value:null}]
                        }

                        var fieldValue = {
                            name: "_" + field.name,
                            access: [Access.APrivate],
                            kind: FieldType.FVar(type, expr), 
                            pos: Context.currentPos(),
                        };
                        fields.push(fieldValue);

                        fields.push({
                            name: "set_" + field.name,
                            access: [Access.APrivate],
                            kind: FieldType.FFun(setter),
                            pos: Context.currentPos(),
                        });

                        fields.push({
                            name: "get_" + field.name,
                            access: [Access.APrivate, Access.AInline],
                            kind: FieldType.FFun(getter),
                            pos: Context.currentPos(),
                        });
                    }

                    if(expr == null) {
                        args.push({name:field.name, type:type, opt:false, value:null});
                        if(isReactive(field.meta)) {
                            states.push(macro $i{"_" + field.name} = $i{field.name});
                        }
                        else {
                            states.push(macro $p{["this", field.name]} = $i{field.name});
                        }
                    }
                    if(isReactive(field.meta) && isNotifiable(type)) {
                        states.push(macro $i{"_" + field.name}.initialize(this));
                    }

                    field.access = [APublic];
                }
                default: throw new haxe.macro.Error("Components can only contain data!", field.pos);
            }
            i++;
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

        fields.push({
            name: "COMPONENT_NAME",
            access: [Access.APublic, Access.AStatic, Access.AInline],
            kind: FieldType.FVar(macro:String, macro $v{Context.getLocalClass().toString()}), 
            pos: Context.currentPos(),
        });

        fields.push({
            name: "componentName",
            access: [Access.APublic],
            kind: FieldType.FProp("default", "null", macro $v{Context.getLocalClass().toString()}), 
            pos: Context.currentPos(),
        });

        fields.push({
            name: "hasChanged",
            access: [Access.APublic],
            kind: FieldType.FProp("default", "null", macro $v{false}), 
            pos: Context.currentPos(),
        });

        fields.push({
            name: "owner",
            access: [Access.APublic],
            kind: FieldType.FVar(macro:pongo.ecs.Entity, macro $v{null}), 
            pos: Context.currentPos(),
        });

        return fields;
    }

    static function isReactive(meta :Null<Metadata>) : Bool
    {
        if(meta == null || meta.length == 0) return true;
        for(m in meta) {
            if(m.name == ":notReactive") return false;
        }
        return true;
    }

    static function isNotifiable(ct :ComplexType) : Bool
    {
        var type = ct.toType();
        switch type {
            case TInst(t,params): {
                var superClass = t.get().superClass;
                if(superClass != null) {
                    return superClass.t.toString() == "pongo.ecs.Notify";
                }
            }
            case _:
        }

        return false;
    }
#end
}