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

package pongo.ecs.transform;

import kha.math.FastMatrix3;
import pongo.ecs.Component;
import pongo.display.Sprite;

class Transform implements Component
{
    var x :Float = 0;
    var y :Float = 0;
    var anchorX :Float = 0;
    var anchorY :Float = 0;
    var scaleX :Float = 1;
    var scaleY :Float = 1;
    var rotation :Float = 0;
    var opacity :Float = 1;
    var visible :Bool = true;
    @:notReactive var matrix :FastMatrix3 = FastMatrix3.identity();
    @:notReactive var sprite :Sprite;
}