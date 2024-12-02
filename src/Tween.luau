local RunService = game:GetService("RunService")

local EaseDirections = require(script.Parent.EaseDirections)
local EaseStyles = require(script.Parent.EaseStyles)
local LerpTypes = require(script.Parent.LerpTypes)

--- @class Tween
local Tween = {}

export type Tween = {
	play: () -> (),
	progress: () -> (),
	stop: () -> (),
}

local tweenProps = {
	"ease",
	"repeat",
	"direction",
	"onStart",
	"onComplete",
	"stagger",
	"centerGoal",
	"axis",
	"randomSeed",
}

local function evaluateEndState(propName, value, startValue) end

function Tween.to<T>(targets: { T } | T, props: { [string]: any }): Tween
	local self = {}

	local _targets: { T } = if typeof(targets) ~= "table" then { targets } else targets

	local updateEvent = if RunService:IsServer() then RunService.Heartbeat else RunService.RenderStepped

	local easeStyle = props.ease or "linear"
	assert(EaseStyles.registry[easeStyle], `No easing style found called {easeStyle} found in EasingStyles registry.`)
	local direction = props.direction or "in"
	assert(
		EaseDirections.registry[direction],
		`No easing direction found called {direction} found in EasingDirections registry.`
	)

	local _progress = 0
	local _elapsed = 0

	self.duration = props.duration or 1
	self.event = nil

	local startValues = {}
	local endValues = {}

	local targetType = typeof(_targets[1])

	local originalTargetProps = {}
	-- get and cache all start and end values
	for _, target in _targets :: { T } do
		originalTargetProps[target] = {}

		if typeof(target) ~= targetType then
			error(`Tween targets not all the same type, please consider making multiple tweens or separate arrays.`, 1)
		end

		for propName, propValue in props do
			local success = pcall(function()
				return target[propName]
			end)
			if not success then
				continue
			end
			local propType = typeof(target[propName])
			if not LerpTypes.registry[propType] then
				continue
			end

			originalTargetProps[target][propName] = target[propName]
		end
	end

	function self.draw()
		for _, v in _targets do
			for propName in startValues[v] do
				local typeOf = typeof(startValues[v][propName])
				local lerper = LerpTypes.registry[typeOf]
				if not lerper then
					warn("no lerper for", propName)
					continue
				end

				v[propName] = lerper(startValues[v][propName], endValues[v][propName], _progress)
			end
		end
	end

	--- @within Tween
	function self.play()
		-- get and cache all start and end values
		for _, target in _targets :: { T } do
			startValues[target] = {}
			endValues[target] = {}

			if typeof(target) ~= targetType then
				error(
					`Tween targets not all the same type, please consider making multiple tweens or separate arrays.`,
					1
				)
			end

			for propName, propValue in props do
				local success = pcall(function()
					return target[propName]
				end)
				if not success then
					continue
				end
				local propType = typeof(target[propName])
				if not LerpTypes.registry[propType] then
					continue
				end

				--- @TODO: Evaluate start state in relation to the end of the previous state
				local startState = target[propName]
				-- local endState = evaluateEndState(propName, propValue, startState)

				startValues[target][propName] = startState
				endValues[target][propName] = propValue
			end
		end

		self.event = updateEvent:Connect(function(dt)
			_elapsed += dt
			_progress = _elapsed / self.duration

			self.draw()

			if _progress >= 1 then
				self.stop()
				if props.onComplete then
					props.onComplete()
				end
			end
		end)
	end

	--- @within Tween
	function self.progress(): number
		return math.clamp(_progress, 0, 1)
	end

	--- @within Tween
	function self.stop()
		if self.event then
			self.event:Disconnect()
		end
	end

	--- @within Tween
	function self.reset() end

	return self

	-- local tweenId = tostring(os.clock()) .. "_" .. tostring(math.random())

	-- if typeof(targets) ~= "table" then
	-- 	targets = { targets }
	-- end

	-- local stagger = properties.stagger
	-- local ease: string = properties.ease or "linear"
	-- local direction: string = properties.direction or "in"
	-- local customEase: Types.EasingFunction = EaseDirections.registry[direction](EaseStyles.registry[ease])
	-- local startValues: { [Instance]: { [string]: any } } = {}
	-- local endValues: { [Instance]: { [string]: any } } = {}
	-- local delays = {}

	-- local staggeredProperties = RbxTween.staggerTargets(targets, stagger, properties)

	-- for _, target in targets do
	-- 	startValues[target] = {}
	-- 	endValues[target] = {}

	-- 	for property, value in properties do
	-- 		if
	-- 			not (
	-- 				property == "ease"
	-- 				or property == "repeat"
	-- 				or property == "direction"
	-- 				or property == "onStart"
	-- 				or property == "onComplete"
	-- 				or property == "stagger"
	-- 				or property == "centerGoal"
	-- 				or property == "axis"
	-- 				or property == "randomSeed"
	-- 			)
	-- 		then
	-- 			startValues[target][property] = target[property]
	-- 			endValues[target][property] = value
	-- 		end
	-- 	end

	-- 	if staggeredProperties[target] and staggeredProperties[target].properties then
	-- 		for staggeredProperty, staggeredValue in staggeredProperties[target].properties do
	-- 			endValues[target][staggeredProperty] = staggeredValue
	-- 		end
	-- 	end
	-- end

	-- local totalTargets = #targets
	-- local repeatCount = 0
	-- local repeatMode = properties["repeat"] or 0
	-- local shouldRepeat = true

	-- local function shouldContinueRepeat()
	-- 	if typeof(repeatMode) == "function" then
	-- 		shouldRepeat = repeatMode(properties, repeatCount)
	-- 	elseif typeof(repeatMode) == "number" then
	-- 		if repeatCount >= repeatMode then
	-- 			shouldRepeat = false
	-- 		end
	-- 	end
	-- 	return shouldRepeat
	-- end

	-- local tweenCache = {
	-- 	tweenId = tweenId,
	-- 	targets = targets,
	-- 	duration = duration,
	-- 	properties = properties,
	-- 	startValues = startValues,
	-- 	endValues = endValues,
	-- 	delays = delays,
	-- 	repeatCount = repeatCount,
	-- 	repeatMode = repeatMode,
	-- 	shouldRepeat = shouldRepeat,
	-- 	onComplete = properties.onComplete,
	-- }

	-- RbxTween.Tweens[tweenId] = tweenCache

	-- local completedTargets = 0
	-- if properties.onStart then
	-- 	properties.onStart()
	-- end

	-- local test = {}

	-- local function startTween(target, _delay)
	-- 	task.delay(_delay, function()
	-- 		local startTime: number = os.clock()
	-- 		local connection
	-- 		local updateSignal = RunService:IsClient() and RunService.RenderStepped or RunService.Heartbeat

	-- 		connection = updateSignal:Connect(function()
	-- 			local elapsed: number = os.clock() - startTime
	-- 			local t: number = math.clamp(elapsed / duration, 0, 1)
	-- 			local easedT: number = customEase(t)

	-- 			for property, startValue in startValues[target] do
	-- 				if not table.find(test, target) then
	-- 					print(`Property: {property}`)
	-- 					print(`Start: {startValue}`)
	-- 					print(`End: {endValues[target][property]}`)
	-- 				end

	-- 				target[property] = universalInterpolate(startValue, endValues[target][property], easedT)
	-- 			end

	-- 			table.insert(test, target)

	-- 			if t >= 1 then
	-- 				connection:Disconnect()
	-- 				completedTargets += 1

	-- 				if completedTargets >= totalTargets then
	-- 					if shouldContinueRepeat() then
	-- 						repeatCount = repeatCount + 1
	-- 						startTween(target, 0)
	-- 					elseif properties.onComplete then
	-- 						properties.onComplete()
	-- 					end
	-- 				end
	-- 			end
	-- 		end)

	-- 		RbxTween.Tweens[tweenId].connection = connection
	-- 	end)
	-- end

	-- for i, target in targets do
	-- 	local staggerDelay = staggeredProperties[target] and staggeredProperties[target].delay or 0
	-- 	startTween(target, staggerDelay)
	-- end

	-- return tweenId
end

--- @within RbxTween
--- @return Tween
function Tween.from(targets: { Instance } | Instance, props: { [string]: any }) end

--- @within RbxTween
--- @return Tween
function Tween.fromTo(targets: { Instance } | Instance, props: { [string]: any }) end

return Tween
