/*
 * Copyright (c) 2020 Jeremy Meltingtallow
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

package pongo.ecs.macro;

#if macro
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Printer;
using pongo.ecs.macro.ExprUtils;

class ExprUtils
{
    public static function print(e :Expr) : String
    {
        var p = new Printer("  ");
        return '\n${p.printExpr(e)}';
    }

    public static function createDefVar(e :Expr, name :String) : ExprDef
    {
        return EVars([{name:name, type: null, expr: e}]);
    }

    public static function createDefString(str :String) : ExprDef
    {
        return EConst(CString(str));
    }

    public static function createDefIdent(ident :String) : ExprDef
    {
        return EConst(CIdent(ident));
    }

    public static function createDefCall(args :Array<Expr>, fnName :String) : ExprDef
    {
        return ECall({
            expr: EConst(CIdent(fnName)),
            pos: Context.currentPos()
        }, args);
    }

    public static function createDefCallField(args :Array<Expr>, obj :Expr, method :String) : ExprDef
    {
        var field = EField(obj, method).toExpr();
        return ECall(field, args);
    }

    public static function createDefBlock(exprs :Array<Expr>) : ExprDef
    {
        return EBlock(exprs);
    }

    public static function createDefArrayDecl(exprs :Array<Expr>) : ExprDef
    {
        return EArrayDecl(exprs);
    }

    public static function createDefBinop(binop :Binop, e1 :Expr, e2 :Expr) : ExprDef
    {
        return EBinop(OpAssign, e1, e2);
    }

    public static function createDefFunc(body :Expr, name :String, args :Array<String>) : ExprDef
    {
        return EFunction(FunctionKind.FNamed(name), {
            args: args.map(a -> {
                name: a,
                opt: false,
                type: null,
                value: null,
                meta: null
            }),
            ret: null,
            expr: body
        });
    }

    public static function createDefFuncAnon(body :Expr, args :Array<String>) : ExprDef
    {
        return EFunction(FunctionKind.FAnonymous, {
            args: args.map(a -> {
                name: a,
                opt: false,
                type: null,
                value: null,
                meta: null
            }),
            ret: null,
            expr: body
        });
    }

    public static function createDefReturn(expr :Expr) : ExprDef
    {
        return EReturn(expr);
    }

    public static function toExpr(e :ExprDef) : Expr
    {
        return {
            pos: Context.currentPos(),
            expr: e
        }
    }

    public static function insertBeforeReturn(block :Array<Expr>, expr :Expr) : Void
    {
        if(block.length == 0) {
            block.push(expr);
        }
        else {
            var lastIndex = block.length -1;
            switch block[lastIndex].expr {
                case EReturn(_):
                    var return_ = block[lastIndex];
                    block[lastIndex] = expr;
                    block.push(return_);
                case _:
                    block.push(expr);
            }
        }
    }
}
#end