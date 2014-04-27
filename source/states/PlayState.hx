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
var test = false;


	var dirt : FlxTypedGroup<entities.Dirt>;
	var drops : FlxTypedGroup<entities.Drop>;
	var roots : FlxTypedGroup<entities.Root>;
	var player : entities.Player;
	var grass : FlxSprite;
	var skyline : FlxSprite;
	var tree : FlxTypedGroup<FlxSprite>;
	var bounds : FlxTypedGroup<FlxSprite>;
	var bound1 : FlxSprite;
	var bound2 : FlxSprite;
	var bound3 : FlxSprite;

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

	var isEnd = false;

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
		tree = new FlxTypedGroup();
		bounds = new FlxTypedGroup();

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
		initBounds();
		this.add(bounds);

		this.add(dirt);
		this.add(roots);
		this.add(drops);
		var z = 0.5;
		grass = new FlxSprite(0, Std.int(200/z)-Config.DIRT_SIZE_H);
		grass.solid = grass.immovable = true;
		grass.makeGraphic(Std.int(FlxG.width/z), Config.DIRT_SIZE_H,FlxColor.FOREST_GREEN, true);
		this.add(grass);

		skyline = new FlxSprite(0, Std.int(-Config.DIRT_SIZE_H));
		skyline.solid = skyline.immovable = true;
		skyline.makeGraphic(Std.int(FlxG.width/z), Config.DIRT_SIZE_H,FlxColor.BLUE, true);
		this.add(skyline);
	}
	function initBounds()
	{
		var z = 0.5;
		bound1 = new FlxSprite(-10, 0);
		bound1.solid = bound1.immovable = true;
		bound1.makeGraphic(10, Std.int(FlxG.height/z),FlxColor.TRANSPARENT);
		bounds.add(bound1);

		bound2 = new FlxSprite(0, FlxG.height/z);
		bound2.solid = bound2.immovable = true;
		bound2.makeGraphic(Std.int(FlxG.width/z), 10,FlxColor.TRANSPARENT);
		bounds.add(bound2);

		bound3 = new FlxSprite(Std.int(FlxG.width/z), 0);
		bound3.solid = bound3.immovable = true;
		bound3.makeGraphic(10, Std.int(FlxG.height/z),FlxColor.TRANSPARENT);
		bounds.add(bound1);
	}

	function init(x)
	{
		boy = new FlxSprite(-200, 210);
		boy.loadGraphic("assets/images/man.png", true, 200, 200, true);
		boy.animation.add("walk", [0,1], 6);
		boy.animation.play("walk");
		boy.velocity.x = 200;

		this.add(boy);


	}


	private function initDirt()
	{
		var z = 0.5;
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
		var z = 0.5;
		var w : Int = Std.int(FlxG.width/z / Config.DROP_SIZE_W);
		var h : Int = Std.int((FlxG.height/z - 200/z) / Config.DROP_SIZE_H);
		var hh = Std.int(h/5);
		var hw = Std.int(w/4);

		// drops random
		for (i in 0...hh)
		{
			var hhw = hw + Std.int(5 - i/5);
			for (j in 0...hhw)
			{
				var d = new entities.Drop(Math.random() * w * Config.DROP_SIZE_W,
						200/z + (Config.DROP_SIZE_H * Math.random() * h ));

				drops.add(d);
			}
		}
		
	}

	private function initRoot(x : Int)
	{
		var z = 0.5;
		var root1 = new entities.Root(x, 200/z);
		roots.add(root1);

		FlxSpriteUtil.fadeIn(root1, 0.5, true, hatch);

	}	

	private function hatch(e)
	{
		var z = 0.5;
		player = new entities.Player(start_x+8, 200/z+3);
		FlxSpriteUtil.fadeIn(player, 0.5, true, function(e) {
			
			waterBar = new entities.WaterBar(onEmptyBar, function(){}, 10,10);
			this.add(waterBar);

			FlxG.camera.zoom = 1;
			FlxG.camera.setSize(Std.int(FlxG.width), Std.int(FlxG.height));
			FlxG.camera.follow(player, FlxCamera.STYLE_TOPDOWN, new FlxPoint(0,0), 1);
			FlxG.camera.update();
			FlxG.worldBounds.set(0, -Config.DIRT_SIZE_H, FlxG.width*2, FlxG.height*2 + Config.DIRT_SIZE_H);

			initTree();

			isFadeDone = true;
		});
		this.add(player);
	}

	function initTree()
	{
		var base = new entities.Tree(start_x+14, 350, 10, 42, FlxColor.BROWN);
		var head = new entities.Tree(start_x, 310, 42, 42, FlxColor.GREEN);
		tree.add(base);
		tree.add(head);
		add(tree);


	}

	private function onEmptyBar()
	{
		FlxG.camera.fade(0x000000, 3, false, function() { FlxG.switchState(new states.GameOver("GAME OVER")); });

	}
	private function onFullBar(e)
	{
		FlxG.camera.fade(0x000000, 4, false, function() {
			FlxG.switchState(new states.GameOver("GAME OVER :)")); });

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
		handleInput();

		root_drop_timer -= FlxG.elapsed;

		if (root_drop_timer < 0)
		{
			FlxG.overlap(tree, skyline, ending);
			FlxG.overlap(roots, drops, collRootDrop);
			root_drop_timer = 0.5;
		}
		FlxG.collide(grass, player);
		FlxG.collide(bound1, player);
		FlxG.collide(bound2, player);
		FlxG.collide(bound3, player);
	}
	function ending(a : FlxSprite, b : FlxSprite)
	{
		if (isEnd) return;
		isEnd = true;
		var posx = a.x;
		var width = a.width - 80;
		var height = a.height - 80;
		FlxG.camera.follow(a);
		for (i in 0...15)
		{
			var r1 =Math.random();
			var r2 =Math.random();
			var x = Std.int(r1 * width + posx);
			var y = Std.int(r2 * height);
			var d = new FlxSprite(x, y);
			d.makeGraphic(Std.int(Config.DROP_SIZE_W/2), Std.int(Config.DROP_SIZE_H/2), FlxColor.RED);
			this.add(d);
			FlxSpriteUtil.fadeIn(d, 3, true, onFullBar);

		}

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
    function handleInput()
    {
        var vel = new FlxPoint(player.velocity.x, player.velocity.y);
        if (FlxG.keys.anyPressed(["A", "LEFT"])) vel.x = -entities.Player.speed;
        if (FlxG.keys.anyPressed(["D", "RIGHT"])) vel.x = entities.Player.speed;
        if (FlxG.keys.anyPressed(["W", "UP"])) vel.y = -entities.Player.speed;
        if (FlxG.keys.anyPressed(["s", "DOWN"])) vel.y = entities.Player.speed;
		player.handleInput(vel);
	}
															
}
