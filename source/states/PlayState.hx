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
	var grass : FlxSprite;

	var waterBar : entities.WaterBar;
	var hudCam : FlxCamera;

	var isFadeDone = false;

	var start_x : Int;

	var root_dirt_timer : Float = 0.7;
	var root_drop_timer : Float = 0.2;

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

		FlxG.camera.zoom = 0.5;
		FlxG.camera.setSize(Std.int(FlxG.width / 0.5), Std.int(FlxG.height / 0.5));

		FlxG.camera.fade(0x000000, 2, true, function() { initRoot(start_x); });

		initMap();
	}
	private function initMap()
	{
		var sky = new FlxSprite();
		sky.loadGraphic("assets/images/sky1600.png", false);//, FlxG.width/FlxG.camera.zoom, FlxG.height/FlxG.camera.zoom);
		this.add(sky);
				
		initDirt();
		initDrops();

		this.add(dirt);
		this.add(roots);
		this.add(drops);
		grass = new FlxSprite(0, Std.int(200/FlxG.camera.zoom)-Config.DIRT_SIZE_H);
		grass.solid = grass.immovable = true;
		grass.makeGraphic(Std.int(FlxG.width/FlxG.camera.zoom), Config.DIRT_SIZE_H,FlxColor.FOREST_GREEN, true);
		this.add(grass);

	}
	private function initDirt()
	{
		var z = FlxG.camera.zoom;
		var w : Int = Std.int((FlxG.width/z) / Config.DIRT_SIZE_W);
		var h : Int = Std.int(((FlxG.height/z) - (200/z)) / Config.DIRT_SIZE_H);

		// 200 -> 600 of dirt
		for (y in 0...h)
		{
			for (x in 0...w)
			{
				var d = new entities.Dirt(x * Config.DIRT_SIZE_W, 200/z + (Config.DIRT_SIZE_H * y));
				dirt.add(d);
			}
		}
	}
	
	private function initDrops()
	{
		var z = FlxG.camera.zoom;
		var w : Int = Std.int(FlxG.width/z / Config.DROP_SIZE_W);
		var h : Int = Std.int((FlxG.height/z - 200/z) / Config.DROP_SIZE_H);
		var hh = Std.int(h/8);
		var hw = Std.int(w/4);

		// drops random
		for (i in 0...hh)
		{
			for (j in 0...hw)
			{
				var d = new entities.Drop(Math.random() * w * Config.DROP_SIZE_W,
						200/z + (Config.DROP_SIZE_H * Math.random() * h ));

				drops.add(d);
			}
		}
		
	}

	private function initRoot(x : Int)
	{
		var root1 = new entities.Root(x, 200/FlxG.camera.zoom);
		roots.add(root1);

		FlxSpriteUtil.fadeIn(root1, 0.5, true, hatch);

	}	

	private function hatch(e)
	{
		player = new entities.Player(start_x, 200/FlxG.camera.zoom);
		FlxSpriteUtil.fadeIn(player, 0.5, true, function(e) {
			
			waterBar = new entities.WaterBar(onEmptyBar, 10,10);
			this.add(waterBar);

			FlxG.camera.zoom = 1;
			FlxG.camera.setSize(Std.int(FlxG.width), Std.int(FlxG.height));
			FlxG.camera.follow(player, FlxCamera.STYLE_TOPDOWN, new FlxPoint(0,0), 1);
			FlxG.camera.update();

			isFadeDone = true;
		});
		this.add(player);
	}

	private function onEmptyBar()
	{
		FlxG.camera.fade(0x000000, 3, false, function() { FlxG.switchState(new states.GameOver()); });

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
		FlxG.overlap(player, dirt, collPlayerDirt);

		root_drop_timer -= FlxG.elapsed;

		if (root_drop_timer < 0)
		{
			FlxG.overlap(roots, drops, collRootDrop);
			root_drop_timer = 0.5;
		}
		FlxG.collide(grass, player);
	}

	function collPlayerDirt(playerRef : entities.Player, d : entities.Dirt)
	{
		var res = waterBar.addWater(-20);
		if (!res)
		{
			playerRef.x = playerRef.last.x;
			playerRef.y = playerRef.last.y;
		}
		else
		{
			roots.add(new entities.Root(d.x, d.y));
			dirt.remove(d);
			d.destroy();
		}

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
