function onPause()
    if getPropertyFromClass('PlayState', 'chartingMode') then return end
    openCustomSubstate('FakePauseSubstate', true)
    return Function_Stop
end
function onCustomSubstateCreate(name)
    if name == 'FakePauseSubstate' then
        addHaxeLibrary('FlxText', 'flixel.text')
        addHaxeLibrary('FlxSound', 'flixel.system')
        addHaxeLibrary('Std')
        addHaxeLibrary('CoolUtil')
        runHaxeCode([[
            menuItems = [];
            menuItemsOG = ['Resume', 'Restart Song', 'Change Difficulty', 'Exit to Menu', 'Explode'];
            textCoordinates = [20, 20]; // x, y

            curSelected = 0;
            difficultyChoices = [];
            grpMenuShit = [];

            if(CoolUtil.difficulties.length < 2) menuItemsOG.remove('Change Difficulty'); //No need to change difficulty if there is only one!

            //later

            if(PlayState.chartingMode)
            {
                menuItemsOG.insert(2, 'Leave Charting Mode');
                
                var num:Int = 0;
                if(!PlayState.instance.startingSong)
                {
                    num = 1;
                    menuItemsOG.insert(3, 'Skip Time');
                }
                menuItemsOG.insert(3 + num, 'End Song');
                menuItemsOG.insert(4 + num, 'Toggle Practice Mode');
                menuItemsOG.insert(5 + num, 'Toggle Botplay');
            }
            menuItems = menuItemsOG;

            for (i in 0...CoolUtil.difficulties.length) { difficultyChoices.push('' + CoolUtil.difficulties[i]); }
            difficultyChoices.push('BACK');

            changeSelection = function(?change = 0)
            {
                curSelected += change;
                FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
                if (curSelected < 0) curSelected = menuItems.length - 1;
                if (curSelected >= menuItems.length) curSelected = 0;

                game.setOnLuas('curSelectedPauseItem', menuItems[curSelected]);
                game.setOnLuas('curSelectedItem', curSelected);

                for (i in 0...menuItems.length)
                {
                    var item = grpMenuShit[i];
                    item.targetY = (i - curSelected);
                    item.alpha = 0.6;
                    if (item.targetY == 0) item.alpha = 1;
                }
            }
            regenMenu = function() {
                for (i in 0...grpMenuShit.length) {
                    grpMenuShit[i].kill();
                    grpMenuShit[i].destroy();
                }
                grpMenuShit = [];

                for (j in 0...menuItems.length) {
                    textThingy = new Alphabet(90, 320, menuItems[j], true);
                    textThingy.isMenuItem = true;
                    textThingy.targetY = j;
                    grpMenuShit.push(textThingy);
                    CustomSubstate.instance.add(textThingy);
                }

                curSelected = 0;
                changeSelection(0);
            }

            pauseMusic = new FlxSound().loadEmbedded(Paths.music(Paths.formatToSongPath(ClientPrefs.pauseMusic)), true, true);
            pauseMusic.volume = 0;
            pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));
            FlxG.sound.list.add(pauseMusic);

            bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFFffffff);
            bg.color = 0xFF000000;
            bg.alpha = 0;
            bg.scrollFactor.set();
            CustomSubstate.instance.add(bg);
    
            levelInfo = new FlxText(0, textCoordinates[1], 0, PlayState.SONG.song, 32);
            levelInfo.scrollFactor.set();
            levelInfo.setFormat(Paths.font("vcr.ttf"), 32);
            levelInfo.updateHitbox();
            CustomSubstate.instance.add(levelInfo);
    
            levelDifficulty = new FlxText(0, textCoordinates[1] + 32, 0, CoolUtil.difficultyString(), 32);
            levelDifficulty.scrollFactor.set();
            levelDifficulty.setFormat(Paths.font('vcr.ttf'), 32);
            levelDifficulty.updateHitbox();
            CustomSubstate.instance.add(levelDifficulty);
    
            blueballedTxt = new FlxText(0, textCoordinates[1] + 64, 0, 'Blueballed: ' + PlayState.deathCounter, 32);
            blueballedTxt.scrollFactor.set();
            blueballedTxt.setFormat(Paths.font('vcr.ttf'), 32);
            blueballedTxt.updateHitbox();
            CustomSubstate.instance.add(blueballedTxt);
    
            practiceText = new FlxText(0, textCoordinates[1] + 101, 0, "PRACTICE MDOE", 32);
            practiceText.scrollFactor.set();
            practiceText.setFormat(Paths.font('vcr.ttf'), 32);
            practiceText.x = FlxG.width - (practiceText.width + textCoordinates[0]);
            practiceText.updateHitbox();
            practiceText.visible = game.practiceMode;
            CustomSubstate.instance.add(practiceText);
    
            chartingText = new FlxText(0, textCoordinates[1] + 101, 0, "CHARTING MODE", 32);
            chartingText.scrollFactor.set();
            chartingText.setFormat(Paths.font('vcr.ttf'), 32);
            chartingText.x = FlxG.width - (chartingText.width + textCoordinates[0]);
            chartingText.y = FlxG.height - (chartingText.height + textCoordinates[0]);
            chartingText.updateHitbox();
            chartingText.visible = PlayState.chartingMode;
            CustomSubstate.instance.add(chartingText);
    
            blueballedTxt.alpha = 0;
            levelDifficulty.alpha = 0;
            levelInfo.alpha = 0;

            blueballedTxt.y -= 5;
            levelDifficulty.y -= 5;
            levelInfo.y -= 5;
    
            levelInfo.x = FlxG.width - (levelInfo.width + textCoordinates[0]);
            levelDifficulty.x = FlxG.width - (levelDifficulty.width + textCoordinates[0]);
            blueballedTxt.x = FlxG.width - (blueballedTxt.width + textCoordinates[0]);
    
            FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
            FlxTween.tween(levelInfo, {alpha: 1, y: textCoordinates[1]}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
            FlxTween.tween(levelDifficulty, {alpha: 1, y: levelDifficulty.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.5});
            FlxTween.tween(blueballedTxt, {alpha: 1, y: blueballedTxt.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.7});

            regenMenu();
        ]])
    end
end
function onCustomSubstateUpdatePost(name, elapsed)
    if name == 'FakePauseSubstate' then
        runHaxeCode([[
            if (CustomSubstate.instance.controls.UI_DOWN_P) changeSelection(1);
            if (CustomSubstate.instance.controls.UI_UP_P) changeSelection(-1);
            if (pauseMusic.volume < 0.5) pauseMusic.volume += 0.01 * ]]..tostring(elapsed)..[[;
        ]])
        if getProperty('controls.ACCEPT') then
            if runHaxeCode("return menuItems == difficultyChoices;") then
                runHaxeCode([[
                    var daSelected:String = menuItems[curSelected];
                    if(menuItems.length - 1 != curSelected && difficultyChoices.contains(daSelected)) {
                        game.callOnLuas('loadSong', [Paths.formatToSongPath(PlayState.SONG.song), curSelected]);
                        PlayState.changedDifficulty = true;
                        PlayState.chartingMode = false;
                        return;
                    }
    
                    menuItems = menuItemsOG;
                    regenMenu();
                ]])
            else
                if curSelectedPauseItem:lower() == 'resume' then
                    closeCustomSubstate()
                elseif curSelectedPauseItem:lower() == 'restart song' then
                    restartSong()
                elseif curSelectedPauseItem:lower() == 'change difficulty' then
                    runHaxeCode("menuItems = difficultyChoices; regenMenu();")
                elseif curSelectedPauseItem:lower() == 'exit to menu' then
                    exitSong()
                elseif curSelectedPauseItem:lower() == 'explode' then
                    runHaxeCode([[
                        for (i in grpMenuShit) {
                            for (letter in i) {
                                letter.acceleration.y = FlxG.random.float(300, 500);
                                letter.velocity.y = FlxG.random.float(-200, -300);
                                letter.velocity.x = FlxG.random.float(-100, 100);
                                letter.angularVelocity = FlxG.random.float(-1000, 1000);
                            }
                        }
                        FlxG.cameras.list[FlxG.cameras.list.length - 1].shake(0.015, 5);
                    ]])
                end
            end
        end
    end
end
function onCustomSubstateDestroy(name)
    if name == 'FakePauseSubstate' then
        runHaxeCode("pauseMusic.destroy();")
    end
end