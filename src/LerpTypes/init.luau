local registry = {}

return {
	register = function(property: string, lerpFunc: (a: any, b: any, t: number) -> number)
		registry[property] = lerpFunc
	end,
	registry = registry,
}
