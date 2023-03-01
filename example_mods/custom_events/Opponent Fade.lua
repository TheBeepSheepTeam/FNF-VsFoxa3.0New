-- Event notes hooks
function onEvent(name, value1, value2)
	if name == 'Opponent Fade' then
		duration = tonumber(value1);
		if duration < 0 then
			duration = 0;
		end

		targetAlpha = tonumber(value2);
		if duration == 0 then
			setProperty('trash.alpha', targetAlpha);
			setProperty('trashgf.alpha', targetAlpha);
			setProperty('trashsea.alpha', targetAlpha);
		else
			doTweenAlpha('trashFadeEventTween', 'trash', targetAlpha, duration, 'linear');
			doTweenAlpha('trashgfFadeEventTween', 'trashgf', targetAlpha, duration, 'linear');
			doTweenAlpha('trashseaFadeEventTween', 'trashsea', targetAlpha, duration, 'linear');
		end
		--debugPrint('Event triggered: ', name, duration, targetAlpha);
	end
end