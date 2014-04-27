package entities;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.util.FlxColor;

class Player extends FlxSprite
{
	static inline var speed = 30;
	static inline var dragSpeed = 200;
	public function new(x : Float, y : Float)
	{
		super(x,y);

		//this.loadGraphic("assets/images/animals.png", true, SPRITESIZE, SPRITESIZE);
		this.makeGraphic(Config.DROP_SIZE_W, Config.DROP_SIZE_H, FlxColor.INDIGO);

		/*
		this.animation.add("idle", [0]);
		this.animation.add("walkleft", [12,13,14,13], 6);
		this.animation.add("walkright", [24,25,26,25], 6);
		this.animation.add("walkup", [36, 37, 38, 37], 6);
		this.animation.add("walkdown", [0, 1, 2, 1], 6);
		this.animation.play("idle");
		*/

		this.drag.y = dragSpeed;
		this.drag.x = dragSpeed;
	}
	public override function update()
	{
		handleInput();
//		setAnimation();
		super.update();
	}
	function handleInput()
	{
		var vel = new FlxPoint(velocity.x, velocity.y);
		if (FlxG.keys.anyPressed(["A", "LEFT"])) vel.x = -speed;
		if (FlxG.keys.anyPressed(["D", "RIGHT"])) vel.x = speed;
		if (FlxG.keys.anyPressed(["W", "UP"])) vel.y = -speed;
		if (FlxG.keys.anyPressed(["s", "DOWN"])) vel.y = speed;

		if (!(vel.x != 0 || vel.y != 0))
		{
			//this.velocity.x = vel.x;
			//this.velocity.y = vel.y;
		}
		else
		{
			this.velocity.x = vel.x;
			this.velocity.y = vel.y;
		}
	}/*
	function setAnimation() : Void
	{
		if (!(velocity.x != 0 || velocity.y != 0))
			animation.play("idle");

		if (velocity.y > 0) this.animation.play("walkdown");
		else if (velocity.y < 0) this.animation.play("walkup");
		if (velocity.x > 0) this.animation.play("walkright");
		else if (velocity.x < 0) this.animation.play("walkleft");
	}*/
}
