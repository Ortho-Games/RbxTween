local Types = require(script.Parent.Types)

local function createEase(points: { { number } }): Types.EasingFunction
	return function(t: number): number
		for i = 1, #points - 1 do
			local p1, p2 = points[i], points[i + 1]

			if t >= p1[1] and t <= p2[1] then
				local alpha = (t - p1[1]) / (p2[1] - p1[1])

				return p1[2] + (p2[2] - p1[2]) * alpha
			end
		end

		return t
	end
end

local registry = {}

return {
	register = function(name: string, easeFunction: Types.EasingFunction)
		if type(easeFunction) == "table" then
			easeFunction = createEase(easeFunction)
		end

		registry[name] = easeFunction
	end,
	registry = registry,
}
