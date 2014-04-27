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

class Drop extends FlxSprite
{
	var water : Float = 50;
	public function new(x : Float, y : Float)
	{
		super(x, y);

		this.makeGraphic(Config.DROP_SIZE_W, Config.DROP_SIZE_H, FlxColor.BLUE, true);
	}
	public override function update()
	{
		super.update();
	}
	public function enlarge(ratio : Float)
	{
		this.makeGraphic(Std.int(Config.DROP_SIZE_W*ratio), Std.int(Config.DROP_SIZE_H*ratio), FlxColor.BLUE);
	}
	public function getWater() : Float
	{
		water -= 2;
		enlarge(water/100);
		if (water < 0)
			return -1;
		return 2;
	}
}
