curentVersion = 0;

local Quotes = {
    "Thanks to Heli Pro Gamer for the fix!",
    "hi my name is carmen winstead im 17 years old",
    "No HScript?",
    "No Lua?",
    "No HaxeFlixel?",
    "No Ghost Tapping?",
    "No OpenFL?",
    "MOM GET THE CAMERA",
    "damn bro you got the whole squad laughing.",
    "the misses are plentiful",
    "Do you really expect me to type something clever in this script?",
    "what a loser, getting his mod cancelled",
    "This is YOUR Daily Does of Internet",
    "I've over dosed on ketamine and I'm going to die",
    "*casually lifts down his mask* Hi. - Dream, October 2022",
    "watch yo tone mf",
    "wtf is with these d&b fans"
}

function onCreate()
   bit = string.gsub(version,"%.","")

   curentVersion = tonumber(bit)
end


function onCreatePost()
    makeLuaText('songText', songName .. ' - ' .. getProperty('storyDifficultyText') .. ' | ' .. Quotes[getRandomInt(1, 20)], 0, 2, 552);
    setTextAlignment('songText', 'left');
    setTextSize('songText', 15);
    setTextBorder('songText', 1, '000000');
    setObjectCamera('songText', 'camHUD');
    addLuaText('songText');
end
