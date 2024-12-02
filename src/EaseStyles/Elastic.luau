require(script.Parent).register("elastic", function(t: number): number
	if t == 0 or t == 1 then
		return t
	end

	return -1 * math.pow(2, 10 * (t - 1)) * math.sin((t - 1) * (2 * math.pi) / 0.3)
end)

return 0
