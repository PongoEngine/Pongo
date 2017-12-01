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

package cream.logic;

/**
 *  
 */
typedef Func<T> = T -> Void;

/**
 *  
 */
class Logic
{
    /**
     *  [Description]
     *  @param fnCondition - 
     *  @param fnTrue - 
     *  @param fnFalse - 
     *  @param data - 
     */
    public static function ifElse<T>(fnCondition : T -> Bool, fnTrue :Func<T>, fnFalse :Func<T>, data :T) : Void
    {
        fnCondition(data) ? fnTrue(data) : fnFalse(data);
    }

    /**
     *  [Description]
     *  @param fnCondition - 
     *  @param fnNext - 
     *  @param data - 
     */
    public static function onlyIf<T>(fnCondition : T -> Bool, fnNext :Func<T>, data :T) : Void
    {
        if(fnCondition(data)) {
            fnNext(data);
        }
    }

    /**
     *  [Description]
     *  @param functions - 
     *  @param fnNext - 
     *  @param data - 
     */
    public static function firstOf<T>(functions :Array<T -> Bool>, fnNext :Func<T>, data :T) : Void
    {
        for(fn in functions) {
            var isComplete = fn(data);
            if(isComplete) {
                fnNext(data);
            }
        }
    }

    /**
     *  [Description]
     *  @param functions - 
     *  @param fnNext - 
     *  @param data - 
     */
    public static function parallel<T>(functions :Array<T -> Bool>, fnNext :Func<T>, data :T) : Void
    {
        var isAllComplete = true;
        for(fn in functions) {
            if(!fn(data)) {
                isAllComplete = false;
            }
        }

        if(isAllComplete) {
            fnNext(data);
        }
    }
}