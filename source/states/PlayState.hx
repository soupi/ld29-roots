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



	var boy : FlxSprite;
	var seed : FlxSprite;

	var firstBoySeed = true;
	var firstGroundSeed = true;

	public function new(?x = 400)
	{
		var r = Math.random();
		x = Std.int(r * 400 + 300) - (Std.int(r * 400 + 300) % Config.DIRT_SIZE_W);
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

		FlxG.camera.fade(0x000000, 2, true, function() { init(start_x); });

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

	function init(x)
	{
		boy = new FlxSprite(-200, 210);
		boy.loadGraphic("assets/images/man.png", 200, 200, true);
		boy.animation.add("walk", [0,1], 6);
		boy.animation.play("walk");
		boy.velocity.x = 200;

		this.add(boy);


	}


	private function initDirt()
	{
		var z = FlxG.camera.zoom;
		var w : Int = Std.int((FlxG.width/z) / Config.DIRT_SIZE_W) + 1;
		var h : Int = Std.int(((FlxG.height/z) - (200/z)) / Config.DIRT_SIZE_H) + 1;

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
			var hhw = hw + Std.int(i/5);
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
		player = new entities.Player(start_x+8, 200/FlxG.camera.zoom+3);
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
		FlxG.overlap(dirt, seed, function(a, sed) {
			if (!firstGroundSeed) return;
			this.remove(seed);
			seed.destroy();
			firstGroundSeed = true;
			initRoot(start_x);
		});
		
		if (boy != null && boy.x > start_x-50 && firstBoySeed)
		{
			firstBoySeed = false;
			seed = new FlxSprite(start_x, 250);
			this.add(seed);
			seed.loadGraphic("assets/images/nevet25.png");
			seed.acceleration.y = 300;
		}
		if (boy != null && boy.x > 1200)
		{
			this.remove(boy);
			boy.destroy();
		}
		updateTimers();
		super.update();
	}
	function updateTimers()
	{
		if (!isFadeDone) return;
		FlxG.overlap(player, dirt, collPlayerDirt);
		FlxG.collide(dirt, player);

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
		var res = waterBar.addWater(-15);
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
