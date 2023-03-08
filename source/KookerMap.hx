package;

import haxe.Json;
import haxe.format.JsonParser;
import lime.utils.Assets;

using StringTools;

/*
    This entire script is for simplicity sake
    The original system was god awful, and a JSON based map system works better anyway.
    It also opens up the door for fanmade maps so thats cool.

    If your wondering, yes, this was heavily based off of Song.hx.

    - Cuzsie
*/

typedef KookerMap =
{
	var objects:Array<Block>;
}

class ForestMap
{
	public var objects:Array<Block>;
	
	public function new(){}

	public static function loadFromJson(jsonInput:String, ?folder:String):KookerMap
	{
		var rawJson = Assets.getText(Paths.json(folder.toLowerCase() + '/' + jsonInput.toLowerCase())).trim();

		while (!rawJson.endsWith("}"))
		{
			rawJson = rawJson.substr(0, rawJson.length - 1);
		}

		return parseJSONshit(rawJson);
	}

	public static function parseJSONshit(rawJson:String):KookerMap
	{
		var swagShit:KookerMap = cast Json.parse(rawJson).map;
		return swagShit;
	}
}
