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

class Root extends FlxSprite
{
	public function new(x : Float, y : Float)
	{
		super(x, y);

		this.makeGraphic(Config.DIRT_SIZE_W, Config.DIRT_SIZE_H, FlxColor.IVORY);
	}
	public override function update()
	{
		super.update();
	}
	public function enlarge(ratio : Float)
	{
		this.makeGraphic(Std.int(Config.DIRT_SIZE_W*ratio), Std.int(Config.DIRT_SIZE_H*ratio), FlxColor.BROWN);
	}
}
