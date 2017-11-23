/*
 * Copyright (c) 2017 Cream Engine
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

/**
 *  Code lifted from
 *  https://code.haxe.org/category/macros/assert-with-values.html
 */

package cream.util;

import haxe.macro.Expr;
using haxe.macro.Tools;

class Assert 
{
    static public macro function assert(e:Expr) 
    {
        var s = e.toString();
        var p = e.pos;
        var el = [];
        var descs = [];

        function add(e:Expr, s:String) {
            var v = "_tmp" + el.length;
            el.push(macro var $v = $e);
            descs.push(s);
            return v;
        }

        function map(e:Expr) {
            return switch (e.expr) {
                case EConst((CInt(_) | CFloat(_) | CString(_) | CRegexp(_) | CIdent("true" | "false" | "null"))): {
                    e;
                }
                case _: {
                    var s = e.toString();
                    e = e.map(map);
                    macro $i{add(e, s)};
                }
            }
        }

        var e = map(e);
        var a = [for (i in 0...el.length) macro { expr: $v{descs[i]}, value: $i{"_tmp" + i} }];
        el.push(macro if (!$e) @:pos(p) throw new cream.util.Assert.AssertionFailure($v{s}, $a{a}));

        return macro $b{el};
    }
}

private typedef AssertionPart = 
{
    expr: String,
    value: Dynamic
}

class AssertionFailure {
    public var message(default, null):String;
    public var parts(default, null):Array<AssertionPart>;
    public function new(message:String, parts:Array<AssertionPart>) {
        this.message = message;
        this.parts = parts;
    }

    public function toString() {
        var buf = new StringBuf();
        buf.add("Assertion failure: " + message);
        for (part in parts) {
            buf.add("\n\t" + part.expr + ": " + part.value);
        }
        return buf.toString();
    }
}