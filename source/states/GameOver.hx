package states;

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
import flixel.util.FlxSpriteUtil;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class GameOver extends FlxState
{
	var isFadeDone = false;

	var text : String = "Game Over";
	var textGui : FlxText;
	public function new(t : String){ text = t; super();}
	override public function create():Void
	{
		super.create();

		FlxG.camera.fade(0x000000, 1, true, function() {
		        textGui = new FlxText(FlxG.width / 2 - 200 / 2, FlxG.height / 2 - 20, 400, text, 40);
			    textGui.alignment = "center";

			    add(textGui);
				FlxSpriteUtil.fadeIn(textGui, 1, true);

		});
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
