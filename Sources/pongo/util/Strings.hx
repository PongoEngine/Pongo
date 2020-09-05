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

package pongo.util;

class Strings
{
    public static function keyFromStrings(strs :Array<String>) : Int
    {
        strs.sort(function(a,b) {
            a = a.toLowerCase();
            b = b.toLowerCase();
            if (a < b) return -1;
            if (a > b) return 1;
            return 0;
        });

        var hash :Int = 0;
        for(str in strs) {
            var i = 0;
            while(i < str.length) {
                var chr = str.charCodeAt(i);
                hash = ((hash << 5) - hash) + chr;
                hash |= 0;
                i++;
            }
        }

        return hash;
    }

    public static function getFileExtension (fileName :String) :String
    {
        var dot = fileName.lastIndexOf(".");
        return (dot > 0) ? fileName.substr(dot+1) : null;
    }

    public static function getUrlExtension (url :String) :String
    {
        var question = url.lastIndexOf("?");
        if (question >= 0) {
            url = url.substr(0, question);
        }
        var slash = url.lastIndexOf("/");
        if (slash >= 0) {
            url = url.substr(slash+1);
        }
        return getFileExtension(url);
    }

    public static function removeFileExtension (fileName :String) :String
    {
        var dot = fileName.lastIndexOf(".");
        return (dot > 0) ? fileName.substr(0, dot) : fileName;
    }
}