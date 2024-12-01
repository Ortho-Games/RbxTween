export type EasingFunction = (t: number) -> number
export type DirectionFunction = (ease: EasingFunction) -> (t: number) -> number

local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local RbxTween = {}

RbxTween.Tweens = {}
RbxTween.Timelines = {}

local easingRegistry = {
	styles = {},
	directions = {},
}

local function createEase(points: { {number} }): EasingFunction
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

local function recursiveMultiply(value, multiplier, accumulator)
	accumulator = accumulator or value
	if multiplier == 0 then
		return typeof(value) == "number" and 0 or value - value 
	elseif multiplier == 1 then
		return value
	else
		return recursiveMultiply(accumulator + value, multiplier - 1, accumulator)
	end
end

local function universalInterpolate(startValue: any, endValue: any, alpha: number): any
	local interpolatable = TweenService:Create(Instance.new("NumberValue"), TweenInfo.new(0), { Value = alpha })

	if interpolatable then
		return startValue:Lerp(endValue, alpha)
	else
		error("Unsupported value type for interpolation: " .. typeof(startValue))
	end
end

RbxTween.registerEaseStyle = function(name: string, easeFunction: EasingFunction)
	if type(easeFunction) == "table" then
		easeFunction = createEase(easeFunction)
	end

	easingRegistry.styles[name] = easeFunction
end

RbxTween.registerEaseDirection = function(name: string, directionFunction: DirectionFunction)
	easingRegistry.directions[name] = directionFunction
end

RbxTween.registerEaseStyle("linear", function(t: number): number return t end)

RbxTween.registerEaseStyle("quad", function(t: number): number return t ^ 2 end)

RbxTween.registerEaseStyle("cubic", function(t: number): number return t ^ 3 end)

RbxTween.registerEaseStyle("sine", function(t: number): number return 1 - math.cos(t * math.pi / 2) end)

RbxTween.registerEaseStyle("elastic", function(t: number): number
	if t == 0 or t == 1 then 
		return t 
	end

	return -1 * math.pow(2, 10 * (t - 1)) * math.sin((t - 1) * (2 * math.pi) / .3)
end)

RbxTween.registerEaseStyle("bounce", function(t: number): number
	if t < 1 / 2.75 then
		return 7.5625 * t * t
	elseif t < 2 / 2.75 then
		t = t - 1.5 / 2.75
		return 7.5625 * t * t + 0.75
	elseif t < 2.5 / 2.75 then
		t = t - 2.25 / 2.75
		return 7.5625 * t * t + 0.9375
	else
		t = t - 2.625 / 2.75
		return 7.5625 * t * t + 0.984375
	end
end)

RbxTween.registerEaseDirection("in", function(ease: EasingFunction): EasingFunction
	return ease
end)

RbxTween.registerEaseDirection("out", function(ease: EasingFunction): EasingFunction
	return function(t: number): number
		return 1 - ease(1 - t)
	end
end)

RbxTween.registerEaseDirection("inOut", function(ease: EasingFunction): EasingFunction
	return function(t: number): number
		if t < 0.5 then
			return ease(t * 2) / 2
		else
			return 1 - ease((1 - t) * 2) / 2
		end
	end
end)

RbxTween.registerEaseStyle("reverse", function(t: number): number
	return 1 - t
end)

RbxTween.staggerTargets = function(targets: { Instance }, stagger: { offset: any, each: number, axis: any }?, properties: { [string]: any })
	if not stagger then
		return {}
	end

	if type(stagger) == "function" then
		local staggeredProperties = {}

		for i, target in targets do
			local staggerDelay = stagger(i, target, targets) or 0

			staggeredProperties[target] = {
				delay = staggerDelay
			}
		end

		return staggeredProperties
	end

	if typeof(stagger) == "number" then
		stagger = { each = stagger }
	end

	local offset = stagger.offset or 0
	local each = stagger.each or 0
	local axis = stagger.axis or Vector3.new(1, 1, 1)
	local totalTargets = #targets

	local staggeredProperties = {}
	for i, target in targets do
		local staggeredValues = {}

		for propertyName, baseValue in properties do
			if typeof(baseValue) == typeof(axis) then
				local stepOffset = recursiveMultiply(axis, (i - 1) * offset)
				staggeredValues[propertyName] = baseValue + stepOffset
			else
				staggeredValues[propertyName] = baseValue
			end
		end

		local staggerDelay = (i - 1) * each

		staggeredProperties[target] = {
			properties = staggeredValues,
			delay = staggerDelay
		}
	end

	return staggeredProperties
end

RbxTween.to = function(targets: { Instance } | Instance, duration: number, properties: { [string]: any })
	local tweenId = tostring(os.clock()) .. "_" .. tostring(math.random())

	if typeof(targets) ~= "table" then
		targets = { targets }
	end

	local stagger = properties.stagger
	local ease: string = properties.ease or "linear"
	local direction: string = properties.direction or "in"
	local customEase: EasingFunction = easingRegistry.directions[direction](easingRegistry.styles[ease])
	local startValues: { [Instance]: { [string]: any } } = {}
	local endValues: { [Instance]: { [string]: any } } = {}
	local delays = {}

	local staggeredProperties = RbxTween.staggerTargets(targets, stagger, properties)
	
	for _, target in targets do
		startValues[target] = {}
		endValues[target] = {}

		for property, value in properties do
			if not (property == "ease" or property == "repeat" or property == "direction" or property == "onStart" or property == "onComplete" or property == "stagger" or property == "centerGoal" or property == "axis" or property == "randomSeed") then
				startValues[target][property] = target[property]
				endValues[target][property] = value
			end
		end

		if staggeredProperties[target] and staggeredProperties[target].properties then
			for staggeredProperty, staggeredValue in staggeredProperties[target].properties do
				endValues[target][staggeredProperty] = staggeredValue
			end
		end
	end

	local totalTargets = #targets
	local repeatCount = 0
	local repeatMode = properties["repeat"] or 0
	local shouldRepeat = true

	local function shouldContinueRepeat()
		if typeof(repeatMode) == "function" then
			shouldRepeat = repeatMode(properties, repeatCount)
		elseif typeof(repeatMode) == "number" then
			if repeatCount >= repeatMode then
				shouldRepeat = false
			end
		end
		return shouldRepeat
	end

	local tweenCache = {
		tweenId = tweenId,
		targets = targets,
		duration = duration,
		properties = properties,
		startValues = startValues,
		endValues = endValues,
		delays = delays,
		repeatCount = repeatCount,
		repeatMode = repeatMode,
		shouldRepeat = shouldRepeat,
		onComplete = properties.onComplete
	}

	RbxTween.Tweens[tweenId] = tweenCache

	local completedTargets = 0
	if properties.onStart then properties.onStart() end
	
	local test = {}
	
	local function startTween(target, _delay)
		task.delay(_delay, function()
			local startTime: number = os.clock()
			local connection
			local updateSignal = RunService:IsClient() and RunService.RenderStepped or RunService.Heartbeat

			connection = updateSignal:Connect(function()
				local elapsed: number = os.clock() - startTime
				local t: number = math.clamp(elapsed / duration, 0, 1)
				local easedT: number = customEase(t)
				
				for property, startValue in startValues[target] do
					if not table.find(test, target) then 
						print(`Property: {property}`)
						print(`Start: {startValue}`)
						print(`End: {endValues[target][property]}`)
					end
					
					target[property] = universalInterpolate(startValue, endValues[target][property], easedT)
				end
				
				table.insert(test, target)
				
				if t >= 1 then
					connection:Disconnect()
					completedTargets += 1

					if completedTargets >= totalTargets then
						if shouldContinueRepeat() then
							repeatCount = repeatCount + 1
							startTween(target, 0)
						elseif properties.onComplete then
							properties.onComplete()
						end
					end
				end
			end)

			RbxTween.Tweens[tweenId].connection = connection
		end)
	end

	for i, target in targets do
		local staggerDelay = staggeredProperties[target] and staggeredProperties[target].delay or 0
		startTween(target, staggerDelay)
	end

	return tweenId
end

RbxTween.stopTween = function(tweenId)
	local tweenCache = RbxTween.Tweens[tweenId]
	if tweenCache then
		print("Stopping tween with ID:", tweenId)
		RbxTween.Tweens[tweenId].connection:Disconnect()
		RbxTween.Tweens[tweenId] = nil
	else
		print("No tween found with ID:", tweenId)
	end
end

RbxTween.getTween = function(tweenId)
	return RbxTween.Tweens[tweenId]
end

RbxTween.timeline = function(): { add: (target: Instance, duration: number, properties: { [string]: any }) -> any, play: () -> any }
	local timeline = {
		animations = {},
		tweens = {},
		onComplete = nil
	}

	local timelineId = tostring(os.clock()) .. "_" .. tostring(math.random())

	function timeline:add(target: Instance, duration: number, properties: { [string]: any })
		table.insert(self.animations, { target = target, duration = duration, properties = properties })

		RbxTween.Timelines[timelineId] = self
		return self
	end

	function timeline:play()
		local function playNextAnimation(index)
			if index > #self.animations then
				if self.onComplete then self.onComplete() end
				return
			end

			local animation = self.animations[index]
			local tweenId = RbxTween.to(animation.target, animation.duration, animation.properties)
			RbxTween.Tweens[tweenId].onComplete = function()
				playNextAnimation(index + 1)
			end
		end

		playNextAnimation(1)
	end

	return timeline
end

return RbxTween
