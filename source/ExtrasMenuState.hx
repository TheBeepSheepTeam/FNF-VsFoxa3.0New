package;

import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.addons.display.FlxBackdrop;
import flixel.tweens.FlxEase;
import lime.utils.Assets;
import Discord.DiscordClient;

class ExtrasMenuState extends MusicBeatState
{
	var selector:FlxText;
	var curSelected:Int = 0;

	var bgBackdrop:FlxBackdrop;

	var timeElapsed:Float = 0;

	var controlsStrings:Array<String> = [
		'Thanks Note',
		'Kookers Forest',
		#if desktop
		'Editors',
		#end
		'GitHub Repo'
	];

	private var grpControls:FlxTypedGroup<Alphabet>;

	// var everySongEver:Array<String> = [];

	override function create()
	{
		DiscordClient.changePresence("In the Menus", null);

		// if (FlxG.save.data.skipCrash == null) FlxG.save.data.skipCrash = false;

		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		menuBG.color = 0xffe286b9;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		bgBackdrop = new FlxBackdrop(Paths.image('checkeredBG', 'preload'), #if (flixel_addons < "3.0.0") 1, 1, true, true, #else XY, #end 1, 1);
		bgBackdrop.alpha = 0;
		bgBackdrop.antialiasing = true;
		bgBackdrop.scrollFactor.set();
		add(bgBackdrop);

		grpControls = new FlxTypedGroup<Alphabet>();
		add(grpControls);

		for (i in 0...controlsStrings.length)
		{
			var optionText:Alphabet = new Alphabet(290, 260, controlsStrings[i], true);
			optionText.isMenuItem = true;
			optionText.scaleX = 0.8;
			optionText.scaleY = 0.8;
			optionText.targetY = i;
			grpControls.add(optionText);
		}

		/* for (i in 0...StoryMenuState.weekData.length)
				{
				var dreamsBallsAreOnFire:Array<String> = StoryMenuState.weekData[i];
				for (i in dreamsBallsAreOnFire)
					{
					everySongEver.push(i);
				}
			}

			for (i in 0...WeekendMenuState.weekendData.length)
				{
				var dreamsBallsAreOnFire:Array<String> = WeekendMenuState.weekendData[i];
				for (i in dreamsBallsAreOnFire)
					{
					everySongEver.push(i);
				}
		}*/

		changeSelection();

		super.create();
	}

	override function update(elapsed:Float)
	{
		var scrollSpeed:Float = 50;
		bgBackdrop.x -= scrollSpeed * elapsed;
		bgBackdrop.y -= scrollSpeed * elapsed;

		timeElapsed += elapsed;

		super.update(elapsed);
		if (controls.ACCEPT)
		{
			switch (curSelected)
			{
				case 0:
					FlxG.switchState(new ThanksState());
				case 1:
					FlxG.switchState(new KookersForestGame());
				case 2:
					FlxG.switchState(new editors.MasterEditorMenu());
				case 3:
					FlxG.openURL("https://github.com/TheBeepSheepTeam/FNF-VsFoxa3.0New");
					/* case 4:
						FlxG.switchState(new CharacterMenu());
						case 5:
						FlxG.switchState(new TestState()); */
			}
			//	var funnystring = Std.string(curSelected);
			//	FlxG.openURL(funnystring);
		}

		if (controls.BACK)
			FlxG.switchState(new MainMenuState());
		if (controls.UI_UP_P)
		{
			changeSelection(-1);
		}
		if (controls.UI_DOWN_P)
		{
			changeSelection(1);
		}
	}

	/* function randomThing():Void
		{
			PlayState.initModes();
			PlayState.randomLevel = true;
			var daSong:String = everySongEver[FlxG.random.int(0, everySongEver.length - 1)];
			var isStoryLevel:Bool = false;
			for (juk in 0...StoryMenuState.weekData.length)
			{
				if (StoryMenuState.weekData[juk].contains(daSong)){trace('yeah, $daSong');
				isStoryLevel = true;}
			}
			daSong = daSong.toLowerCase();
			trace(daSong);
			if (isStoryLevel)
				PlayState.SONG = Song.loadFromJson('$daSong-hard', daSong);
			else
				PlayState.SONG = Song.loadFromJson(daSong, daSong);
			FlxG.switchState(new PlayState());
	}*/
	function changeSelection(change:Int = 0)
	{
     	FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = grpControls.length - 1;
		if (curSelected >= grpControls.length)
			curSelected = 0;

		// selector.y = (70 * curSelected) + 30;

		var bullShit:Int = 0;

		for (item in grpControls.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}
