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

//
// Flambe - Rapid game development
// https://github.com/aduros/flambe/blob/master/LICENSE.txt

package pongo.platform.display;

import kha.math.FastMatrix3;
import kha.Color;
import kha.Scaler;
import kha.System;
import kha.Shaders;
import kha.graphics4.PipelineState;
import kha.graphics4.VertexData;
import kha.graphics4.VertexStructure;
import kha.graphics4.BlendingFactor;
import pongo.display.BlendMode;
import pongo.display.Pipeline;
import kha.graphics4.Graphics2;

class Graphics implements pongo.display.Graphics
{
    public var framebuffer (default, null): kha.Framebuffer;
    public var width (default, null): Int;
    public var height (default, null): Int;

    public function new(framebuffer :kha.Framebuffer, width :Int, height :Int) : Void
    {
        this.framebuffer = framebuffer;
        this.width = width;
        this.height = height;
        _graphics = new Graphics2(this.framebuffer);
        initPipelines();
    }

    public function begin() : Void
    {
        _graphics.begin();
        var transform = Scaler.getScaledTransformation(this.width, this.height, System.windowWidth(), System.windowHeight(), System.screenRotation);
        _stateList.matrix.setFrom(transform);
    }

    public function end() : Void
    {
        _graphics.end();
    }

    public function fillRect(color :Int, x :Float, y :Float, width :Float, height :Float) : Void 
    {
        prepare(color, COLORED);
        _graphics.fillRect(x, y, width, height);
    }

    public function fillCircle(color :Int, cx: Float, cy: Float, radius: Float, segments: Int = 0) : Void
    {
        prepare(color, COLORED);
        #if !macro
        kha.graphics2.GraphicsExtension.fillCircle(_graphics, cx, cy, radius, segments);
        #end
    }

    public function drawRect(color :Int, x: Float, y: Float, width: Float, height: Float, strength: Float = 1.0) : Void 
    {
        prepare(color, COLORED);
        _graphics.drawRect(x, y, width, height, strength);
    }

    public function drawLine(color :Int, x1: Float, y1: Float, x2: Float, y2: Float, strength: Float = 1.0) : Void 
    {
        prepare(color, COLORED);
        _graphics.drawLine(x1, y1, x2, y2, strength);
    }

    public function drawCircle(color :Int, cx: Float, cy: Float, radius: Float, strength: Float = 1, segments: Int = 0) : Void
    {
        prepare(color, COLORED);
        #if !macro
        kha.graphics2.GraphicsExtension.drawCircle(_graphics, cx, cy, radius, strength, segments);
        #end
    }

    public function drawCubicBezierPath(color :Int, x :Array<Float>, y :Array<Float>, strength:Float = 1.0):Void
    {
        prepare(color, COLORED);
        #if !macro
        kha.graphics2.GraphicsExtension.drawCubicBezierPath(_graphics, x, y, 20, strength);
        #end
    }

    public function drawPolygon(color :Int, x: Float, y: Float, vertices: Array<kha.math.Vector2>, strength: Float = 1) : Void
    {
        prepare(color, COLORED);
        #if !macro
        kha.graphics2.GraphicsExtension.drawPolygon(_graphics, x, y, vertices, strength);
        #end
    }

    public function drawString(text :String, font :pongo.display.Font, color :Int, fontSize :Int, x :Float, y :Float) : Void
    {
        prepare(color, TEXT);

        var nativeFont = cast(font, Font).nativeFont;
        if(_graphics.font != nativeFont) {
            _graphics.font = nativeFont;
        }

        if(_graphics.fontSize != fontSize) {
            _graphics.fontSize = fontSize;
        }

        _graphics.drawString(text, x, y);
    }

    public function drawImage(texture: pongo.display.Texture, x: Float, y: Float) : Void
    {
        prepare(0xffffffff, IMAGE);
        _graphics.drawImage(cast(texture, Texture).nativeTexture, x, y);
    }

    public function drawSubImage(texture: pongo.display.Texture, x: Float, y: Float, sx: Float, sy: Float, sw: Float, sh: Float) : Void
    {
        prepare(0xffffffff, IMAGE);
        _graphics.drawSubImage(cast(texture, Texture).nativeTexture, x, y, sx, sy, sw, sh);
    }

    public inline function translate(x :Float, y :Float) : Void
    {
        _stateList.matrix.setFrom(_stateList.matrix.multmat(FastMatrix3.translation(x,y)));
    }

    public inline function scale(x :Float, y :Float) : Void
    {
        _stateList.matrix.setFrom(_stateList.matrix.multmat(FastMatrix3.scale(x,y)));
    }

    public inline function rotate(rotation :Float) : Void
    {
        _stateList.matrix.setFrom(_stateList.matrix.multmat(FastMatrix3.rotation(rotation)));
    }

    public inline function transform(matrix :FastMatrix3) : Void
    {
        _stateList.matrix.setFrom(_stateList.matrix.multmat(matrix));
    }

    public function save() : Void
    {
        var current = _stateList;
        var state = _stateList.next;

        if (state == null) {
            state = new DrawingState();
            state.prev = current;
            current.next = state;
        }

        state.matrix.setFrom(current.matrix);
        state.opacity = current.opacity;
        state.color = current.color;
        _stateList = state;
    }

    public function restore() : Void
    {
        _stateList = _stateList.prev;
    }

    public function prepare(color :Int, gPipeline :GPipeline) : Void
    {
        setColor(color);
        _graphics.transformation.setFrom(_stateList.matrix);

        switch [_stateList.pipeline, gPipeline] {
            case [DEFAULT, COLORED]: handPipeline(_coloredPipeline);
            case [DEFAULT, TEXT]: handPipeline(_textPipeline);
            case [DEFAULT, IMAGE]: handPipeline(_imagePipeline);
            case [CUSTOM(pipelineState, fn), _]: {
                handPipeline(pipelineState);
                if(fn != null) {
                    fn(framebuffer.g4);
                }
            }
        }

        if(_lastBlendMode != _stateList.blendMode) {
            handBlendMode(_stateList.blendMode);
            _lastBlendMode = _stateList.blendMode;
        }

        if(_graphics.opacity != _stateList.opacity) {
            _graphics.opacity = _stateList.opacity;
        }

        if(_graphics.color != _stateList.color) {
            _graphics.color = _stateList.color;
        }
    }

    public function multiplyOpacity(factor :Float) : Void
    {
        _stateList.opacity *= factor;
    }

    public function setOpacity(opacity :Float) : Void
    {
        _stateList.opacity = opacity;
    }

    public function setColor(color :Color) : Void
    {
        _stateList.color = color;
    }

    public function setBlendMode(blendMode :BlendMode) : Void
    {
        _stateList.blendMode = blendMode;
    }

    public function setPipeline(pipeline :Pipeline) : Void
    {
        _stateList.pipeline = pipeline;
    }

    private function initPipelines() : Void
    {
        _textPipeline = Graphics2.createTextPipeline(Graphics2.createTextVertexStructure());
        _textPipeline.compile();
        _imagePipeline = Graphics2.createImagePipeline(Graphics2.createImageVertexStructure());
        _imagePipeline.compile();
        _coloredPipeline = Graphics2.createColoredPipeline(Graphics2.createColoredVertexStructure());
        _coloredPipeline.compile();
    }

    private inline function handBlendMode(blendMode :BlendMode) : Void
    {
        switch blendMode {
            case NORMAL: {
                _graphics.pipeline.blendSource = BlendingFactor.BlendOne;
                _graphics.pipeline.blendDestination = BlendingFactor.InverseSourceAlpha;
            }
            case ADD: {
                _graphics.pipeline.blendSource = BlendingFactor.BlendOne;
                _graphics.pipeline.blendDestination = BlendingFactor.BlendOne;
            }
            case MULTIPLY: {
                _graphics.pipeline.blendSource = BlendingFactor.DestinationColor;
                _graphics.pipeline.blendDestination = BlendingFactor.InverseSourceAlpha;
            }
            case SCREEN: {
                _graphics.pipeline.blendSource = BlendingFactor.BlendOne;
                _graphics.pipeline.blendDestination = BlendingFactor.InverseSourceColor;
            }
            case MASK: {
                _graphics.pipeline.blendSource = BlendingFactor.BlendZero;
                _graphics.pipeline.blendDestination = BlendingFactor.SourceAlpha;
            }
            case COPY: {
                _graphics.pipeline.blendSource = BlendingFactor.BlendOne;
                _graphics.pipeline.blendDestination = BlendingFactor.BlendZero;
            }
        }
    }

    private inline function handPipeline(pipelineState :PipelineState) : Void
    {
        if(_graphics.pipeline != pipelineState) {
            _graphics.pipeline = pipelineState;
        }
    }

    private var _stateList :DrawingState = new DrawingState();
    private var _lastBlendMode :BlendMode = BlendMode.NORMAL;
    private var _lastTexture :pongo.display.Texture = null;
    private var _graphics :Graphics2;

    private var _imagePipeline :PipelineState;
    private var _coloredPipeline :PipelineState;
    private var _textPipeline :PipelineState;
}

private class DrawingState
{
    public var matrix :FastMatrix3;
    public var opacity :Float;
    public var color :kha.Color;
    public var blendMode :BlendMode;
    public var pipeline :Pipeline = Pipeline.DEFAULT;

    public var prev :DrawingState = null;
    public var next :DrawingState = null;

    public function new() : Void
    {
        matrix = FastMatrix3.identity();
        opacity = 1;
        color = Color.Black;
        blendMode = BlendMode.NORMAL;
    }
}

@:enum
abstract GPipeline(Int)
{
    var COLORED = 0;
    var IMAGE = 1;
    var TEXT = 2;
}