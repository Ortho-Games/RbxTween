local Types = require(script.Parent.Types)
local registry = {}

return {
	register = function(name: string, directionFunction: Types.DirectionFunction)
		registry[name] = directionFunction
	end,
	registry = registry,
}
