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

package pongo.util;

import haxe.ds.Option;

@:forward(push, concat, length, iterator)
abstract ComponentArray<T>(Array<T>) from Array<T>
{

    /**
     *  [Description]
     *  @return Option<T>
     */
    public inline function first() : Option<T>
    {
        return get(0);
    }

    /**
     *  [Description]
     *  @return Option<T>
     */
    public inline function last() : Option<T>
    {
        return get(this.length-1);
    }

    /**
     *  [Description]
     *  @param index - 
     *  @return Option<T>
     */
    public function get(index :Int) : Option<T>
    {
        var val = this[index];
        return (val == null) ? None : Some(val);
    }

    /**
     *  [Description]
     *  @param index - 
     *  @param val - 
     *  @return Bool
     */
    public function set(index :Int, val :T) : Bool
    {
        if(index < 0 || index >= this.length)
            return false
        else {
            this[index] = val;
            return true;
        }
    }

    /**
     *  [Description]
     *  @return Bool
     */
    public inline function empty() : Bool
    {
        return this.length == 0;
    }
}