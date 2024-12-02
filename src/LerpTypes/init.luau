local registry = {}

return {
	register = function<T>(property: string, lerpFunc: (a: T, b: T, t: number) -> T)
		registry[property] = lerpFunc
	end,
	registry = registry,
}
