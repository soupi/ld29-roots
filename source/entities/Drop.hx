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
import flixel.util.FlxPoint;


class Drop extends FlxSprite
{
	static var initS = 40;
	var water : Int = initS;
	public function new(x : Float, y : Float)
	{
		super(x, y);

		this.loadGraphic("assets/images/drops25.png", true, Config.DROP_SIZE_W, Config.DROP_SIZE_H);
		this.animation.add("40", [0]);
		this.animation.add("30", [1]);
		this.animation.add("20", [2]);
		this.animation.add("10", [3]);
	}
	public override function update()
	{
		super.update();
	}
	public function enlarge(ratio : Float)
	{
	//	this.scale = new FlxPoint(ratio, ratio);
	}
	public function getWater() : Float
	{
		water -= 2;
		if (water % 10 == 0) this.animation.play("" + water);  //enlarge(water/initS);
		if (water < 0)
			return -1;
		return 2;
	}
}
