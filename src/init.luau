
export type EasingFunction = (t: number) -> number
export type DirectionFunction = (ease: EasingFunction) -> (t: number) -> number

-- Importing necessary services
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local RbxTween = {}

local isClient = RunService:IsClient()

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

-- Example usage of RbxTween.to function:
--
-- RbxTween.to(workspace.Part, 2, {
--     Position = Vector3.new(10, 10, 10),
--     ease = "sine",
--     direction = "inOut",
--     onStart = function() print("Animation started!") end,
--     onComplete = function() print("Animation completed!") end
-- })

RbxTween.to = function(target: Instance, duration: number, properties: { [string]: any })
	local ease: string = properties.ease or "linear"
	local direction: string = properties.direction or "in"
	local customEase: EasingFunction = easingRegistry.directions[direction](easingRegistry.styles[ease])

	local startValues: { [string]: any } = {}
	local endValues: { [string]: any } = {}

	for property, value in properties do
		if not (property == "ease" or property == "direction" or property == "onStart" or property == "onComplete") then
			startValues[property] = target[property]
			endValues[property] = value
		end
	end

	if properties.onStart then properties.onStart() end

	local startTime: number = tick()

	local connection
	local updateSignal = isClient and RunService.RenderStepped or RunService.Heartbeat

	connection = updateSignal:Connect(function()
		local elapsed: number = tick() - startTime
		local t: number = math.clamp(elapsed / duration, 0, 1)
		local easedT: number = customEase(t)

		for property, startValue in startValues do
			target[property] = universalInterpolate(startValue, endValues[property], easedT)
		end

		if t >= 1 then
			connection:Disconnect()
			
			if properties.onComplete then 
				properties.onComplete() 
			end
		end
	end)
end

RbxTween.timeline = function(): { add: (target: Instance, duration: number, properties: { [string]: any }) -> any, play: () -> any }
	local timeline = {
		animations = {},
		onComplete = nil
	}

	-- Example usage of adding animations to a timeline:
	--
	-- local timeline = RbxTween.timeline()
	--
	-- timeline:add(workspace.Part, 2, {
	--     Position = Vector3.new(10, 10, 10),
	--     ease = "quad",
	--     direction = "in"
	-- })
	--
	-- timeline:add(workspace.Part, 3, {
	--     Position = Vector3.new(20, 10, 10),
	--     ease = "elastic",
	--     direction = "out"
	-- })
	--
	-- timeline.onComplete = function() print("Timeline completed!") end
	-- timeline:play()

	function timeline:add(target: Instance, duration: number, properties: { [string]: any })
		table.insert(self.animations, { target = target, duration = duration, properties = properties })
		
		return self
	end

	function timeline:play()
		local _delay: number = 0
		local totalDuration: number = 0
		
		for _, anim in self.animations do
			totalDuration += anim.duration
			task.delay(_delay, function()
				RbxTween.to(anim.target, anim.duration, anim.properties)
			end)
			_delay += anim.duration
		end
		
		if self.onComplete then task.delay(totalDuration, self.onComplete) end
	end

	return timeline
end

RbxTween.registerEaseStyle("linear", function(t: number): number return t end)

RbxTween.registerEaseStyle("quad", function(t: number): number return t ^ 2 end)

RbxTween.registerEaseStyle("cubic", function(t: number): number return t ^ 3 end)

RbxTween.registerEaseStyle("sine", function(t: number): number return 1 - math.cos(t * math.pi / 2) end)

RbxTween.registerEaseStyle("elastic", function(t: number): number
	if t == 0 or t == 1 then return t end
	
	local p, a = 0.3, 1
	
	return -a * math.pow(2, 10 * (t - 1)) * math.sin((t - 1) * (2 * math.pi) / p)
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

return RbxTween
