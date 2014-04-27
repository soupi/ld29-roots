package entities;

import Std;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.util.FlxColor;

class Tree extends FlxSprite
{
	var w : Int;
	var h : Int;
	var ws : Int;
	var hs : Int;
	var c : Int;
	var s : Float = 5;

	public function new(x : Float, y : Float, w, h, c)
	{
		super(x, y);

		this.w = w;
		this.h = h;
		this.ws = w;
		this.hs = h;
		this.c = c;

		this.makeGraphic(w, h, c, true);
	}
	public override function update()
	{
		s -= FlxG.elapsed;
		if (s <= 0)
		{
			s = 5;
			ws += w;
			hs += h;
			this.makeGraphic(ws, hs, c);
			this.x -= w/2;
			this.y -= h;
		}
		
		super.update();
	}
	public function enlarge(ratio : Float)
	{
		if (Std.int(ratio) + 0.1 > ratio)
		this.makeGraphic(Std.int(w+ratio), Std.int(h+(ratio+20)), c);
	}
}
