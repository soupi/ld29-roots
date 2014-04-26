package states;

import Sys;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxObject;
import flixel.group.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxRect;
import flixel.util.FlxColor;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	/**
	 * Function that is called up when to state is created to set it up.
	 */
//	var flower_layer : FlxTypedGroup<entities.Flower>;
//	var touched_flower_layer : FlxTypedGroup<entities.Flower>;
//	var player : entities.Player;
	var isFadeDone = false;
	override public function create():Void
	{
		super.create();

		//flower_layer = new FlxTypedGroup();
		//touched_flower_layer = new FlxTypedGroup();

		FlxG.camera.fade(0x000000, 2, true, function() { isFadeDone = true; });
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		if (!isFadeDone) return;

		super.update();
	}	
}
