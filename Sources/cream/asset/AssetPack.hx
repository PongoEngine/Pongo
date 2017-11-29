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

package cream.asset;

import kha.Image;
import kha.Blob;
import kha.Font;
import kha.Video;
import cream.sound.Sound;

import cream.util.Disposable;

@:allow(cream.asset.Manifest)
class AssetPack implements Disposable
{
    public function new() : Void
    {
        _images = new Map<String, Image>();
        _sounds = new Map<String, Sound>();
        _blobs = new Map<String, Blob>();
        _fonts = new Map<String, Font>();
        _videos = new Map<String, Video>();
    }

    public function getImage(name :String) :Image
    {
        return _images.get(name);
    }

    public function getSound(name :String) :Sound
    {
        return _sounds.get(name);
    }

    public function getBlob(name :String) :Blob
    {
        return _blobs.get(name);
    }

    public function getFont(name :String) :Font
    {
        return _fonts.get(name);
    }

    public function getVideo(name :String) :Video
    {
        return _videos.get(name);
    }

    public function dispose() : Void
    {
        for(image in _images)
            image.unload();

        for(sound in _sounds)
            sound.dispose();

        for(blob in _blobs)
            blob.unload();

        for(font in _fonts)
            font.unload();

        for(video in _videos)
            video.unload();
    }


    private var _images :Map<String, Image>;
    private var _sounds :Map<String, Sound>;
    private var _blobs :Map<String, Blob>;
    private var _fonts :Map<String, Font>;
    private var _videos :Map<String, Video>;
}
