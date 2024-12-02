require(script.Parent).register("inOut", function(ease: EasingFunction): EasingFunction
	return function(t: number): number
		if t < 0.5 then
			return ease(t * 2) / 2
		else
			return 1 - ease((1 - t) * 2) / 2
		end
	end
end)
