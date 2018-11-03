
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

import pongo.platform.display.Font;
import pongo.platform.display.Texture;
import pongo.platform.sound.Sound;
import pongo.asset.Manifest;

class AssetPack implements pongo.asset.AssetPack
{
    public var images :Map<String, Texture>;
    public var sounds :Map<String, Sound>;
    public var fonts :Map<String, Font>;

    public function new() : Void
    {
        images = new Map<String, Texture>();
        sounds = new Map<String, Sound>();
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

        for(font in fonts)
            font.dispose();
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
                case IMAGE(name): kha.Assets.loadImageFromPath(name, true, function(image :kha.Image) {
                    loadedCount++;
                    checkLoadCount(loadedCount, targetCount, assetPack.images, name, new Texture(image), assetPack, cb);
                });

                case SOUND(name): kha.Assets.loadSoundFromPath(name, function(nativeSound :kha.Sound) {
                    nativeSound.uncompress(function() {
                        loadedCount++;
                        checkLoadCount(loadedCount, targetCount, assetPack.sounds, name, new Sound(nativeSound), assetPack, cb);
                    });
                });

                case FONT(name): kha.Assets.loadFontFromPath(name, function(font :kha.Font) {
                    loadedCount++;
                    checkLoadCount(loadedCount, targetCount, assetPack.fonts, name, new Font(font), assetPack, cb);
                });
            }
        }
    }

    static function checkLoadCount<T>(loadedCount :Int, targetCount :Int, map :Map<String, T>, name :String, asset :T, assetPack :pongo.asset.AssetPack, cb :pongo.asset.AssetPack -> Void) : Void
    {
        map.set(name, asset);
        if(loadedCount == targetCount) {
            cb(assetPack);
        }
    }
}
