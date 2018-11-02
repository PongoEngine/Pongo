package pongo;

import pongo.util.Signal2;

interface Window
{
	function attemptWindow() : Void;
	function attemptFullScreen() : Void;
	function resize(width: Int, height: Int): Void;
	function move(x: Int, y: Int): Void;
	var x(get, set): Int;
	var y(get, set): Int;
	var width(get, set): Int;
	var height(get, set): Int;
	var onResize(default, null):Signal2<Int, Int>;
}