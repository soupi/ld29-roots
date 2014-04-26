package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;

import haxe.ds.GenericStack;
/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	override public function create():Void
	{
		FlxG.camera.fade(0xFFFFFF, 2, true, afterFadeIn);
		super.create();
	}
	
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
	}

	}
	function afterFadeIn() : Void
	{
	}
}
