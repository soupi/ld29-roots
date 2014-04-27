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

class WaterBar extends FlxSprite
{
	var water : Float = Config.BAR_SIZE_W;
	public function new(?x = 0, ?y = 0)
	{
		super(x, y);
		this.makeGraphic(Std.int(water), Config.BAR_SIZE_H, FlxColor.BLUE);
	}
	public override function update()
	{
		reduceWater();
		super.update();
	}
	public function enlarge(ratio : Float)
	{
		this.makeGraphic(Std.int(Config.BAR_SIZE_W*ratio), Std.int(Config.BAR_SIZE_H*ratio), FlxColor.BLUE);
	}
	function reduceWater()
	{
		water -= FlxG.elapsed;

		if (water < 0)
			water = 0;
		this.makeGraphic(Std.int(water), Std.int(Config.BAR_SIZE_H), FlxColor.FOREST_GREEN);
	}
	public function addWater(w : Float) : Bool
	{
		if (water + w < 0) return false;
		water += w;
		return true;
	}
}
