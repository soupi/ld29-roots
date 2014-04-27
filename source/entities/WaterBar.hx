package entities;

import Std;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.ui.FlxBar;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.util.FlxColor;

class WaterBar extends FlxBar
{
	var water : Float = Config.BAR_SIZE_W;
	public function	new(onEmpty : Void -> Void, x : Float, y : Float, ?parentRef : Dynamic, ?variable : String, ?min : Float, ?max : Float, ?border : Bool)
	{
		super(x, y, null, Std.int((FlxG.width-20)/2),  Config.BAR_SIZE_H, parentRef, variable, 0, 300, border);
		this.createFilledBar(0x00000000, FlxColor.BLUE, false);
		this.currentValue = water;
		this.scrollFactor = new FlxPoint(0,0);

		this.setCallbacks(onEmpty, function() {});

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

		currentValue = water;
	}
	public function addWater(w : Float) : Bool
	{
		if (water + w < 0) return false;
		water += w;
		currentValue = water;
		return true;
	}
}
