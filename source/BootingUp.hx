package;

import flixel.ui.FlxBar;
#if sys
import sys.io.File;
#end
import flixel.text.*;
import openfl.display.BitmapData;
import openfl.utils.AssetCache;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.math.FlxRect;
import flixel.math.FlxPoint;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.FlxGraphic;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.*;
import openfl.utils.Assets;
import openfl.utils.AssetType;
import haxe.Json;
import haxe.format.JsonParser;
import openfl.Assets;
import openfl.utils.ByteArray;
// import Achievements.MedalSaves;
import haxe.io.Bytes;
import flixel.addons.api.FlxGameJolt;
import flixel.input.gamepad.FlxGamepad;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.addons.ui.FlxUIInputText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
#if sys
import sys.FileSystem;
#end
import lime.app.Application;
#if cpp
import sys.thread.Thread;
#end
#if desktop
import Discord.DiscordClient;
#end

using StringTools;

class BootingUp extends MusicBeatState
{
	public var logoAnim:FlxSprite;
	public var loadingMush:FlxSprite;
	public var loadedTxt:FlxText;
	public var loadedImages:Int = 0;
	public var loadBar:FlxBar;
	public var loadBarSpr:FlxSprite;

	var boolOne:Bool = false;
	var boolTwo:Bool = false;
	var iscompleted:Bool = false;
	var fuck:Bool = false;

	override function create()
	{
		#if LUA_ALLOWED
		Paths.pushGlobalMods();
		#end

		FlxG.save.bind('funkin', CoolUtil.getSavePath());
		// PlayerSettings.init();

		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		FlxG.game.focusLostFramerate = 60;
		// FlxG.sound.muteKeys = muteKeys;
		// FlxG.sound.volumeDownKeys = volumeDownKeys;
		// FlxG.sound.volumeUpKeys = volumeUpKeys;
		#if desktop
		FlxG.keys.preventDefaultKeys = [TAB];
		#end

		PlayerSettings.init();
		ClientPrefs.loadPrefs();

		Highscore.load();

		loadingMush = new FlxSprite().loadGraphic(Paths.image("foxaCacheBG"));
		loadingMush.scale.set(0.4, 0.4);
		loadingMush.screenCenter();
		add(loadingMush);

		loadingMush = new FlxSprite().loadGraphic(Paths.image("foxaEngineLogo"));
		logoAnim.scale.set(0.4, 0.4);
		logoAnim.screenCenter();
		logoAnim.y += 500;
		logoAnim.x += 500;
		add(logoAnim);

		loadedTxt = new FlxText(400, 250, FlxG.width - 600, "PRELOADING MENU MUSIC", 32);
		loadedTxt.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		loadedTxt.scrollFactor.set();
		loadedTxt.borderSize = 1.25;
		loadedTxt.screenCenter();
		loadedTxt.y -= 100;
		add(loadedTxt);

		loadBar = new FlxBar(0, 0, LEFT_TO_RIGHT, Std.int(1110 / 2), 15, this, 'loadedImages', 0, 247, true);
		// loadBar.createGradientBar([FlxColor.BLACK, FlxColor.GRAY], [FlxColor.ORANGE, FlxColor.YELLOW],1,180,true,FlxColor.BLACK);
		loadBar.createFilledBar(FlxColor.BLACK, FlxColor.WHITE, true, FlxColor.BLACK);
		loadBar.antialiasing = true;
		loadBar.numDivisions = 10000;
		loadBar.screenCenter();
		add(loadBar);

		// FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);//genius momento. agree

		loadedTxt.text = "PRELOADED ASSETS: 0";
		fuck = true;
		#if cpp
		Thread.create(cacheStuff);
		#else
		cacheStuff();
		#end

		trace('caching images and sound...');

		super.create();
	}

	override public function update(h:Float)
	{
		super.update(h);

		if (iscompleted)
		{ //  && boolOne && boolTwo
			loadedTxt.text = "Assets loaded!\nPress ENTER to continue.\n";
			if (FlxG.keys.justPressed.ENTER)
			{
				MusicBeatState.switchState(new TitleState());
				trace(loadedImages);
			}
		}
		if (loadedTxt != null && fuck && !iscompleted)
		{
			loadedTxt.text = "LOADED ASSETS: " + loadedImages;
		}
	}

	// own made caching :P -zackk
	function cacheStuff()
	{ // very hard goin, keep preloading assets only to big asf shit like ui and dialogue.
		#if sys
		loadfolder("assets/secrets/images");
		loadfolder("assets/week7/images");
		loadfolder("assets/week6/images");
		loadfolder("assets/week5/images");
		loadfolder("assets/week4/images");
		loadfolder("assets/week3/images");
		loadfolder("assets/week2/images");
		loadfolder("assets/shared/images/weeb");
		loadfolder("assets/shared/images/pixelUI");
		loadfolder("assets/images/menudifficulties");
		loadfolder("assets/images");
		loadfolder("assets/images/storymenu");
		loadfolder("assets/images/mainmenu");
		loadfolder("assets/images/icons");
		loadfolder("assets/images/credits");
		loadfolder("assets/shared/images");
		loadfolder("assets/shared/images/characters");
		loadfolder("assets/shared/images/dialogue");
		FlxG.sound.cacheAll();
		#end
		trace('cache is done looks like we are readuy');
		iscompleted = true;
	}

	function loadfolder(folder:String)
	{
		var charpaths = FileSystem.readDirectory(Sys.getCwd() + '/' + folder);

		for (path in charpaths)
		{
			var fullpath = '$folder/$path';
			// trace(fullpath);

			if (!path.contains('.png') || !FileSystem.exists(Sys.getCwd() + '/' + fullpath))
				continue;

			var bitmap = BitmapData.fromFile(Sys.getCwd() + '/' + fullpath);

			FlxG.bitmap.add(bitmap).persist = true;

			Paths.cache.setBitmapData(fullpath, bitmap);
			// Paths.excludeAsset(fullpath); // bullshit so it wont dump the ui assets
			var stupi:FlxGraphic = FlxGraphic.fromBitmapData(bitmap);
			stupi.persist = true;

			Paths.cachedAsses.set(fullpath, stupi);
			Paths.cachedShit.push(fullpath);
			// stupi.destroy();
			// since its all in cached, we dont need cache anymore?? idfk.
			Paths.cache.clear(fullpath);
			if (Paths.cache.hasBitmapData(fullpath))
				Paths.cache.removeBitmapData(fullpath);

			loadedImages++;
		}
		trace("Cache Total: " + loadedImages);
	}
}
