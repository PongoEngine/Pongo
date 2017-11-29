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

import kha.Assets;
import kha.Image;
import kha.Blob;
import kha.Font;
import kha.Video;
import cream.sound.Sound;

class Manifest
{
    public function new() : Void
    {
        _assets = [];
    }

    public function addImage(name :String) : Void
    {
        _assets.push(IMAGE(name));
    }

    public function addSound(name :String) : Void
    {
        _assets.push(SOUND(name));
    }

    public function addBlob(name :String) : Void
    {
        _assets.push(BLOB(name));
    }

    public function addFont(name :String) : Void
    {
        _assets.push(FONT(name));
    }

    public function addVideo(name :String) : Void
    {
        _assets.push(VIDEO(name));
    }

    public function createAssetPack(cb :AssetPack -> Void) : Void
    {
        var loadedCount :Int = 0;
        var targetCount :Int = _assets.length;
        var assetPack = new AssetPack();

        for(asset in _assets) {
            switch asset {
                case IMAGE(name): Assets.loadImage(name, function(image :Image) {
                    loadedCount++;
                    assetPack._images.set(name, image);
                    if(loadedCount == targetCount) {
                        cb(assetPack);
                    }
                });

                case SOUND(name): Assets.loadSound(name, function(nativeSound :kha.Sound) {
                    nativeSound.uncompress(function() {
                        loadedCount++;
                        assetPack._sounds.set(name, new Sound(nativeSound));
                        if(loadedCount == targetCount) {
                            cb(assetPack);
                        }
                    });
                });

                case BLOB(name): Assets.loadBlob(name, function(blob :Blob) {
                    loadedCount++;
                    assetPack._blobs.set(name, blob);
                    if(loadedCount == targetCount) {
                        cb(assetPack);
                    }
                });

                case FONT(name): Assets.loadFont(name, function(font :Font) {
                    loadedCount++;
                    assetPack._fonts.set(name, font);
                    if(loadedCount == targetCount) {
                        cb(assetPack);
                    }
                });

                case VIDEO(name): Assets.loadVideo(name, function(video :Video) {
                    loadedCount++;
                    assetPack._videos.set(name, video);
                    if(loadedCount == targetCount) {
                        cb(assetPack);
                    }
                });
            }
        }
    }

    private var _assets :Array<AssetType>;
}

enum AssetType
{
    IMAGE(name :String);
    SOUND(name :String);
    BLOB(name :String);
    FONT(name :String);
    VIDEO(name :String);
}