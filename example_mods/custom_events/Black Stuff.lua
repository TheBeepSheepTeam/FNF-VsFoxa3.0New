function onEvent(name,value1,value2)
	if name == 'Black Stuff' then
		doTweenAlpha('blackalpha', 'theblack', tonumber(value1), tonumber(value2), 'linear');
		--debugPrint('Event triggered: ', name, duration, targetAlpha);
	end
end