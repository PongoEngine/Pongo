
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

package pongo.platform.asset;

import kha.Image;
import kha.Blob;
import kha.Font;
import pongo.platform.display.Texture;
import pongo.sound.Sound;
import pongo.asset.Manifest;

class AssetPack implements pongo.asset.AssetPack
{
    public var images :Map<String, Texture>;
    public var sounds :Map<String, Sound>;
    public var blobs :Map<String, Blob>;
    public var fonts :Map<String, Font>;

    public function new() : Void
    {
        images = new Map<String, Texture>();
        sounds = new Map<String, Sound>();
        blobs = new Map<String, Blob>();
        fonts = new Map<String, Font>();
    }

    public function getImage(name :String) :Texture
    {
        return images.get(name);
    }

    public function getSound(name :String) :Sound
    {
        return sounds.get(name);
    }

    public function getBlob(name :String) :Blob
    {
        return blobs.get(name);
    }

    public function getFont(name :String) :Font
    {
        return fonts.get(name);
    }

    public function dispose() : Void
    {
        for(image in images)
            image.dispose();

        for(sound in sounds)
            sound.dispose();

        for(blob in blobs)
            blob.unload();

        for(font in fonts)
            font.unload();
    }

    public static function loadManifest(manifest :Manifest, cb :pongo.asset.AssetPack -> Void) : Void
    {
        var loadedCount :Int = 0;
        var targetCount :Int = manifest.assets.length;
        var assetPack = new AssetPack();
        if(manifest.assets.length == 0) {
            cb(assetPack);
            return;
        }

        for(asset in manifest.assets) {
            switch asset {
                case IMAGE(name): kha.Assets.loadImageFromPath(name, false, function(image :kha.Image) {
                    loadedCount++;
                    assetPack.images.set(name, new Texture(image));
                    if(loadedCount == targetCount) {
                        cb(assetPack);
                    }
                });

                case SOUND(name): kha.Assets.loadSound(name, function(nativeSound :kha.Sound) {
                    nativeSound.uncompress(function() {
                        loadedCount++;
                        assetPack.sounds.set(name, new Sound(nativeSound));
                        if(loadedCount == targetCount) {
                            cb(assetPack);
                        }
                    });
                });

                case BLOB(name): kha.Assets.loadBlob(name, function(blob :kha.Blob) {
                    loadedCount++;
                    assetPack.blobs.set(name, blob);
                    if(loadedCount == targetCount) {
                        cb(assetPack);
                    }
                });

                case FONT(name): kha.Assets.loadFont(name, function(font :kha.Font) {
                    loadedCount++;
                    assetPack.fonts.set(name, font);
                    if(loadedCount == targetCount) {
                        cb(assetPack);
                    }
                });
            }
        }
    }
}
