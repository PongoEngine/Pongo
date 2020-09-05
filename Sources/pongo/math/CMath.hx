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

package pongo.math;

class CMath
{

    public static inline var E = 2.718281828459045;
    public static inline var LN2 = 0.6931471805599453;
    public static inline var LN10 = 2.302585092994046;
    public static inline var LOG2E = 1.4426950408889634;
    public static inline var LOG10E = 0.43429448190325176;
    public static inline var PI = 3.141592653589793;
    public static inline var SQRT1_2 = 0.7071067811865476;
    public static inline var SQRT2 = 1.4142135623730951;
    
    /** The lowest integer value in Flash and JS. */
    public static inline var INT_MIN :Int = -2147483648;

    /** The highest integer value in Flash and JS. */
    public static inline var INT_MAX :Int = 2147483647;

    /** The lowest float value in Flash and JS. */
    public static inline var FLOAT_MIN = -1.79769313486231e+308;

    /** The highest float value in Flash and JS. */
    public static inline var FLOAT_MAX = 1.79769313486231e+308;

    public static inline function toRadians(degrees :Float) : Float
    {
        return degrees * (Math.PI/180);
    }

    public static inline function toDegrees(radians :Float) : Float
    {
        return radians * (180/Math.PI);
    }

    public static inline function angle(x1 :Float, y1 :Float, x2 :Float, y2 :Float) : Float
    {
        return Math.atan2(y2 - y1, x2 - x1);
    }

    public static inline function distance(x1 :Float, y1 :Float, x2 :Float, y2 :Float) : Float
    {
        var a = x1 - x2;
        var b = y1 - y2;
        return Math.sqrt( a*a + b*b );
    }

    public static inline function clamp<T:Float> (value :T, min :T, max :T) :T
    {
        return if (value < min) min
            else if (value > max) max
            else value;
    }

    public static inline function min<T:Float> (a :T, b :T) :T
    {
        return (a < b) ? a : b;
    }

    public static inline function max<T:Float> (a :T, b :T) :T
    {
        return (a > b) ? a : b;
    }
}