package states;

import Std;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxObject;
import flixel.FlxCamera;
import flixel.group.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxRect;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxPoint;

class PlayState extends FlxState
{
	var dirt : FlxTypedGroup<entities.Dirt>;
	var drops : FlxTypedGroup<entities.Drop>;
	var roots : FlxTypedGroup<entities.Root>;
	var player : entities.Player;

	var waterBar : entities.WaterBar;
	var hudCam : FlxCamera;

	var isFadeDone = false;

	var start_x : Int;


	var root_dirt_timer : Float = 0.7;
	var root_drop_timer : Float = 0.2;
	var player_dirt_timer : Float = 0.1;

	public function new(?x = 400)
	{
		start_x = x;
		super();
	}
	override public function create():Void
	{
		super.create();

		dirt = new FlxTypedGroup();
		drops = new FlxTypedGroup();
		roots = new FlxTypedGroup();


		FlxG.camera.fade(0x000000, 2, true, function() { initRoot(start_x); });

		initMap();
	}
	private function initMap()
	{
		var sky = new FlxSprite();
		sky.loadGraphic("assets/images/sky.png", false, FlxG.width, FlxG.height);
		this.add(sky);
				
		initDirt();
		initDrops();

		this.add(dirt);
		this.add(roots);
		this.add(drops);

	}
	private function initDirt()
	{
		var w : Int = Std.int(FlxG.width / Config.DIRT_SIZE_W);
		var h : Int = Std.int((FlxG.height - 200) / Config.DIRT_SIZE_H);
		// 200 -> 600 of dirt
		for (y in 0...h)
		{
			for (x in 0...w)
			{
				var d = new entities.Dirt(x * Config.DIRT_SIZE_W, 200 + (Config.DIRT_SIZE_H * y));
				dirt.add(d);
			}
		}
	}
	
	private function initDrops()
	{
		var w : Int = Std.int(FlxG.width / Config.DROP_SIZE_W);
		var h : Int = Std.int((FlxG.height - 200) / Config.DROP_SIZE_H);
		var hh = Std.int(h/8);
		var hw = Std.int(w/4);

		// drops random
		for (i in 0...hh)
		{
			for (j in 0...hw)
			{
				var d = new entities.Drop(Math.random() * w * Config.DROP_SIZE_W,
						200 + (Config.DROP_SIZE_H * Math.random() * h ));

				drops.add(d);
			}
		}
		
	}

	private function initRoot(x : Int)
	{
		var root1 = new entities.Root(x, 200);
		roots.add(root1);

		FlxSpriteUtil.fadeIn(root1, 0.5, true, hatch);

	}	

	private function hatch(e)
	{
		player = new entities.Player(start_x, 200);
		FlxSpriteUtil.fadeIn(player, 0.5, true, function(e) {
			
			waterBar = new entities.WaterBar(10,10);
			this.add(waterBar);

			FlxG.camera.zoom = 2;
			FlxG.camera.setSize(Std.int(FlxG.width / 2), Std.int(FlxG.height / 2));
			FlxG.camera.follow(player, FlxCamera.STYLE_TOPDOWN, new FlxPoint(0,0), 1);
			FlxG.camera.update();

			isFadeDone = true;
		});
		this.add(player);
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
		if (!isFadeDone) return;
		updateTimers();
		super.update();
	}
	function updateTimers()
	{

		root_dirt_timer -= FlxG.elapsed;
		root_drop_timer -= FlxG.elapsed;
		player_dirt_timer -= FlxG.elapsed;

		if (root_dirt_timer < 0)
		{
			FlxG.overlap(roots, dirt, collRootDirt);
			root_dirt_timer = 0.1;
		}
		if (root_drop_timer < 0)
		{
			FlxG.overlap(roots, drops, collRootDrop);
			root_drop_timer = 0.5;
		}
		if (player_dirt_timer < 0)
		{
			FlxG.overlap(player, dirt, collPlayerDirt);
			player_dirt_timer = 0.1;
		}
	}

	function collPlayerDirt(playerRef : entities.Player, d : entities.Dirt)
	{
		if (!waterBar.addWater(-5))
		{
			playerRef.x = playerRef.last.x;
			playerRef.y = playerRef.last.y;
		}
		else roots.add(new entities.Root(d.x, d.y));


	}
	function collRootDirt(root : entities.Root, d : entities.Dirt)
	{
		dirt.remove(d);
		d.destroy();

	}
	function collRootDrop(root : entities.Root, drop : entities.Drop)
	{
		var wat = drop.getWater();
		if (wat < 0)
		{
			drops.remove(drop);
			drop.destroy();
		}
		else waterBar.addWater(wat);

	}
}
