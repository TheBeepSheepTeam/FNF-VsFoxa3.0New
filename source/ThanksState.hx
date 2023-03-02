package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;

// taken from the old foxa-dev repo, just modified it a little bit
class ThanksState extends MusicBeatState
{
	public static var leftState:Bool = false;

	public static var needVer:String = "IDFK LOL";
	public static var currChanges:String = "dk";

	private var bgColors:Array<String> = ['#314d7f', '#4e7093', '#70526e', '#594465'];
	private var colorRotation:Int = 1;

	override function create()
	{
		super.create();
		/*var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('week54prototype', 'shared'));
			bg.scale.x *= 1.55;
			bg.scale.y *= 1.55;
			bg.screenCenter();
			bg.antialiasing = ClientPrefs.antialiasing;
			add(bg); */

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.10;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.antialiasing;
		add(bg);

		var foxaLogo:FlxSprite = new FlxSprite(FlxG.width, 0).loadGraphic(Paths.image('foxaEngineLogo'));
		foxaLogo.scale.y = 0.3;
		foxaLogo.scale.x = 0.3;
		foxaLogo.x -= foxaLogo.frameHeight;
		foxaLogo.y -= 180;
		foxaLogo.alpha = 0.8;
		foxaLogo.antialiasing = ClientPrefs.antialiasing;
		add(foxaLogo);

		/*var txt:FlxText = new FlxText(0, 0, FlxG.width,
			"Thanks for playing the Foxa Mod Beta!\nThis took months to make and we hope you enjoy it.\nThis is a Dev "
			+ "\n\nPress Space to continue.",
			32); */

		var txt:FlxText = new FlxText(0, 0, FlxG.width,
			"Thanks for playing Vs. Foxa 3.0 ALPHA!\nThis build is unfinished, so you might experience a lot of bugs.\nDo not leak this build,\nor else the devs will find your body!\nAnyway, enjoy this unfinished\nbuild of the update!" +
			"\n\nPress Enter to continue.",
			32);

		txt.setFormat("VCR OSD Mono", 32, FlxColor.fromRGB(200, 200, 200), CENTER);
		txt.borderColor = FlxColor.BLACK;
		txt.borderSize = 3;
		txt.borderStyle = FlxTextBorderStyle.OUTLINE;
		txt.screenCenter();
		add(txt);

		FlxTween.color(bg, 2, bg.color, FlxColor.fromString(bgColors[colorRotation]));
		FlxTween.angle(foxaLogo, foxaLogo.angle, -10, 2, {ease: FlxEase.quartInOut});

		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			FlxTween.color(bg, 2, bg.color, FlxColor.fromString(bgColors[colorRotation]));
			if (colorRotation < (bgColors.length - 1))
				colorRotation++;
			else
				colorRotation = 0;
		}, 0);

		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			if (foxaLogo.angle == -10)
				FlxTween.angle(foxaLogo, foxaLogo.angle, 10, 2, {ease: FlxEase.quartInOut});
			else
				FlxTween.angle(foxaLogo, foxaLogo.angle, -10, 2, {ease: FlxEase.quartInOut});
		}, 0);

		new FlxTimer().start(0.8, function(tmr:FlxTimer)
		{
			if (foxaLogo.alpha == 0.8)
				FlxTween.tween(foxaLogo, {alpha: 1}, 0.8, {ease: FlxEase.quartInOut});
			else
				FlxTween.tween(foxaLogo, {alpha: 0.8}, 0.8, {ease: FlxEase.quartInOut});
		}, 0);
	}

	override function update(elapsed:Float)
	{
	else if (controls.ACCEPT)
	{
		leftState = true;
		FlxG.switchState(new MainMenuState());
	}
		if (controls.BACK)
		{
			leftState = true;
			FlxG.switchState(new MainMenuState());
		}
		super.update(elapsed);
	}
}
