require(script.Parent).register("out", function(ease)
	return function(t: number): number
		return 1 - ease(1 - t)
	end
end)

return 0
