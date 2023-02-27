-- Event notes hooks
function onEvent(name, value1, value2)
	if name == 'Black screen' then
        makeLuaSprite("black","",0,0)
        makeGraphic("black",1280,720,'000000')
        setScrollFactor("black",0,0)
        setObjectCamera("black","hud")

        addLuaSprite("black",true)
	end
    if value1 == "off" then
        removeLuaSprite("black")
    end
end