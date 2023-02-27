-- Event notes hooks
function onEvent(name, value1, value2)
	if name == 'Bg change' then
		thing = tostring(value1..'.visible')
		inorvis = tonumber(value2)

		if inorvis == 0 then
			setProperty(thing, false)
		end
		if inorvis == 1 then
			setProperty(thing, true)
		end
	end
end