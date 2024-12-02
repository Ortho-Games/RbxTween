local function lerp(a, b, t)
	return (1 - t) * a + t * b
end

require(script.Parent).register("Number", lerp)

return lerp
