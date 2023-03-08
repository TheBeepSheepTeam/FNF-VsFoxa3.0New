package;

import flixel.FlxG;
import flixel.util.FlxTimer;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.text.FlxText;
import flixel.util.FlxColor;
#if desktop
import Discord.DiscordClient;
#end

/*
	Hey, i know your coming here because you want to use the system for your own mod.
	I honestly could care less, just credit me for it.

	- Cuzsie
 */
class KookersForestGame extends MusicBeatState
{
	public static var player:MinigamePlayer;
	public static var kooker:KookerEnemy;

	var showHitboxes:Bool = false;
	var dead:Bool = false;

	private var camHUD:FlxCamera;
	private var camGame:FlxCamera;

	var cherries:Array<KookerCherry> = [];

	var maxCherry:Int = 10;
	var cherryCount:Int;

	var scoreTxt:FlxText;

	// iNTROOO
	var introText:FlxText;
	var curText:Int = 0;
	var inIntro:Bool = false;
	var texts:Array<String> = [
		"Welcome to Kooker's Forest Game!",
		"Your objective is to get all the cherries before Kooker catches you!",
		"If you get all the cherries before he finds you, you win!",
		"Good luck!"
	];

	// W 25.6
	// H 14.4
	// 0 Air
	// 1 Bush
	// 2 Tree
	var mapGrid:Array<Array<Int>> = [];

	override function create()
	{
		#if desktop
		DiscordClient.changePresence("Playing Kooker's Forest Game ", "");
		#end

		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);

		FlxCamera.defaultCameras = [camGame];

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image("minigame/kooker/grass", 'shared'));
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		add(bg);

		for (i in 0...maxCherry)
		{
			var cherry:KookerCherry = new KookerCherry(FlxG.random.int(50, camGame.width - 50), FlxG.random.int(50, camGame.height - 50));
			add(cherry);
			cherries.push(cherry);
		}

		super.create();

		createMap();
		intro();
	}

	function createMap()
	{
		// Start the target at 0,0 (Top Left Corner)
		var targY:Float = 0;
		var targX:Float = 0;

		for (l in 0...mapGrid.length)
		{
			// Up the target Y
			if (l != 0)
				targY + 72;

			for (s in 0...mapGrid[l].length)
			{
				// Create our new block
				var block:Block = new Block(targX, targY, mapGrid[l][s]);
				add(block);

				// Add to the target Y
				targX + 128;
			}

			// Make sure to reset the target X at the end of the statement.
			targX = 0;
		}
	}

	function intro()
	{
		inIntro = true;
		FlxG.sound.playMusic(Paths.music('forestIntro', 'shared'));

		introText = new FlxText(0, 0, FlxG.width, texts[0] + "\n\n\n\n\nCONTINUE - ENTER", 32);
		introText.setFormat(Paths.font("pixel.otf"), 32, FlxColor.WHITE, CENTER);
		introText.screenCenter();
		introText.antialiasing = true;
		add(introText);
	}

	override function update(elapsed:Float)
	{
		if (kooker != null && player != null)
		{
			kooker.playerPosition = player.getGraphicMidpoint();

			FlxG.overlap(player, kooker, function(player, kooker)
			{
				trace("Insert working death code here");
			});
		}

		if (FlxG.keys.justPressed.SEVEN)
		{
			FlxG.switchState(new KookerGameEditor());
		}

		if (FlxG.keys.justPressed.SPACE)
		{
			for (cherry in cherries)
			{
				FlxG.overlap(player, cherry, function(player, cherry)
				{
					trace("cherrrry");
					remove(cherry);
					cherryCount++;

					if (cherryCount == maxCherry)
						trace("WIN!");
				});
			}
		}

		if (FlxG.keys.justPressed.H)
			showHitboxes = !showHitboxes;

		FlxG.debugger.drawDebug = showHitboxes;

		// just keeping this for testing!
		if (FlxG.keys.justPressed.ESCAPE)
			FlxG.switchState(new MainMenuState());

		if (dead)
		{
			if (FlxG.keys.justPressed.ENTER)
				FlxG.switchState(new KookersForestGame()); // PLEASE SHUT UP IM TIRED AND LAZY
			else if (FlxG.keys.justPressed.ESCAPE)
				FlxG.switchState(new MainMenuState());
		}

		if (FlxG.keys.justPressed.ENTER && inIntro)
		{
			// Once the intro is complete
			if (curText == texts.length - 1)
			{
				FlxG.sound.music.stop();
				trace("Closing");
				FlxG.sound.playMusic(Paths.music("forestGame", "shared"));

				player = new MinigamePlayer(20, 20);
				player.screenCenter();
				add(player);

				kooker = new KookerEnemy(500, 500);
				kooker.chase(elapsed);
				add(kooker);

				remove(introText);

				var tipText:FlxText = new FlxText(0, FlxG.height * 0.9, 0, "Space - Collect Cherry", 50);
				tipText.setFormat(Paths.font("pixel.otf"), FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				tipText.scrollFactor.set();
				tipText.screenCenter(X);
				tipText.borderSize = 1;
				tipText.cameras = [camHUD];
				add(tipText);

				scoreTxt = new FlxText(0, 50, 0, "", 50);
				scoreTxt.setFormat(Paths.font("pixel.otf"), FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				scoreTxt.scrollFactor.set();
				scoreTxt.screenCenter(X);
				scoreTxt.cameras = [camHUD];
				scoreTxt.borderSize = 1;
				add(scoreTxt);

				inIntro = false;
			}
			else
			{
				curText++;
				introText.text = texts[curText] + "\n\n\n\n\nCONTINUE - ENTER";
			}
		}

		if (scoreTxt != null)
			scoreTxt.text = '${cherryCount}/${maxCherry}';

		super.update(elapsed);
	}

	function lose()
	{
		kooker.lockMovement = false;
		player.lockMovement = false;
		kooker.idle(0);

		FlxG.sound.music.stop();

		var txt:FlxText = new FlxText(0, 0, FlxG.width, "You Lose!\nYou kinda suck ngl bro...\n\n\nENTER - Try Again\nESCAPE - Back to Menu", 32);
		txt.setFormat(Paths.font("pixel.otf"), 32, FlxColor.WHITE, CENTER);
		txt.screenCenter();
		txt.antialiasing = true;
		txt.cameras = [camHUD];
		add(txt);

		FlxG.sound.play(Paths.sound('forestLose', 'shared'));

		dead = true;
	}
}
