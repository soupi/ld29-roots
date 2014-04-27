package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxSpriteUtil;

/**
 * A FlxState which can be used for the game's menu.
 */
class Splash extends FlxState
{
	/**
	 * Function that is called up when to state is created to set it up.
	 */

	static inline var initialTime : Float = 0.05;
	var cloud1 : FlxSprite;
	var cloud2 : FlxSprite;
	var cloud3 : FlxSprite;
	var key_pressed = false;

	override public function create() : Void
	{
		var sky = new FlxSprite();	
		sky.loadGraphic("assets/images/sky.png", false, FlxG.width, FlxG.height);
		var grass = new FlxSprite();	
		grass.loadGraphic("assets/images/grassandtree.png", false, FlxG.width, FlxG.height);
		cloud1 = new FlxSprite(-800,0);	
		cloud1.loadGraphic("assets/images/cloud1.png", true, FlxG.width, FlxG.height);
		cloud2 = new FlxSprite(-800,0);	
		cloud2.loadGraphic("assets/images/cloud2.png", true, FlxG.width, FlxG.height);
		cloud3 = new FlxSprite(-800,0);	
		cloud3.loadGraphic("assets/images/cloud3.png", true, FlxG.width, FlxG.height);
		var logo = new FlxSprite(200,100);	
		logo.loadGraphic("assets/images/logo.png");

		var comment = new FlxText(FlxG.width / 2 - 500 / 2, FlxG.height - 150, 500, "PRESS 'SPACE' TO START", 20);
		comment.alignment = "center";
		comment.color = 0xFF000000;



		this.add(sky);
		this.add(grass);
		this.add(cloud1);
		this.add(cloud2);
		this.add(cloud3);

		cloud1.velocity.x = 100;
		cloud2.velocity.x = 80;
		cloud3.velocity.x = 85;


		FlxG.camera.fade(0xFFFFFF, 1.5, true,
			function() {
				FlxSpriteUtil.fadeIn(logo, 2.5, true, function (e) {
					FlxSpriteUtil.fadeIn(comment, 1);
					this.add(comment);
				});
				this.add(logo);
			});
		super.create();
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
		updateClouds();

		if (FlxG.keys.anyPressed(["SPACE", "ENTER"]))
		{
			key_pressed = true;
			if (key_pressed)
			{
				FlxG.camera.fade(0x000000, 1, false, function () {
					FlxG.switchState(new PlayState());					
				});
			}
		}

		super.update();
	}
	function updateClouds()
	{

		if (cloud1.x > 800)
			cloud1.x = -500;
		if (cloud2.x > 600)
			cloud2.x = -600;
		if (cloud3.x > 500)
			cloud3.x = -800;
	}
}
