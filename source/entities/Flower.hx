package entities;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.util.FlxColor;

class Flower extends FlxSprite
{
	static inline var sPRITESIZE : Int = 32;
	public function new(x : Float, y : Float)
	{
		super(x, y);

		this.loadGraphic("assets/images/animals.png", true, SPRITESIZE, SPRITESIZE);
		this.animation.add("idle", [0, 1, 2, 1], 122);
		this.animation.play("idle");
		//this.makeGraphic(sPRITESIZE, sPRITESIZE, FlxColor.RED);
	}
	public override function update()
	{
		super.update();
	}
	public function enlarge()
	{
		this.makeGraphic(SPRITESIZE*2, SPRITESIZE*2, FlxColor.RED);
	}
}
