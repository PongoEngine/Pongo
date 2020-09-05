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

package pongo.asset;

import haxe.rtti.Meta;
using pongo.util.Strings;

class Manifest
{
    public var assets (default, null):Array<AssetType>;

    public function new() : Void
    {
        assets = [];
    }

    public function add(name :String, url :String) :Void
    {
        assets.push(createAssetType(name, url));
    }

    public static function fromAssets (packName :String) :Manifest
    {
        var packData :Array<Dynamic> = Reflect.field(Meta.getType(Manifest).assets[0], packName);
        var manifest = new Manifest();

        if (packData == null) {
            return manifest;
        }

        for (asset in packData) {
            var name = asset.name;
            var path = packName + "/" + name + "?v=" + asset.md5;
            manifest.assets.push(createAssetType(name, path));
        }

        return manifest;
    }

    private static function createAssetType(name :String, url :String) :AssetType
    {
        var extension = url.getUrlExtension();
        if (extension != null) {
            return switch (extension.toLowerCase()) {
                case "gif", "jpg", "jpeg", "png": IMAGE(name, url);
                case "m4a", "mp3", "ogg", "wav": 
                    var audioName = (extension=="wav") ? name.removeFileExtension() + ".ogg" : name;
                    SOUND(audioName, url);
                case "ttf": FONT(name, url);
                case _: DATA(name, url);
            }
        }
        return DATA(name, url);
    }
}

enum AssetType
{
    IMAGE(name :String, url :String);
    SOUND(name :String, url :String);
    FONT(name :String, url :String);
    DATA(name :String, url :String);
}