require(script.Parent).register("out", function(ease: EasingFunction): EasingFunction
	return function(t: number): number
		return 1 - ease(1 - t)
	end
end)
