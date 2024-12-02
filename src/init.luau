--!strict

local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local EaseDirections = require(script.EaseDirections)
local EaseStyles = require(script.EaseStyles)
local Timeline = require(script.Timeline)
local Tween = require(script.Tween)
local Types = require(script.Types)

for _, v in script:GetDescendants() do
	if v:IsA("ModuleScript") then
		require(v)
	end
end

--- @class RbxTween
local RbxTween = {}

RbxTween.Tweens = {}
RbxTween.Timelines = {}

--- @within RbxTween
--- @function registerStyle
--- @param name string
--- @param func (t: number ) -> number
RbxTween.registerStyle = EaseStyles.register

--- @within RbxTween
--- @function registerDirection
--- @param name string
--- @param func (t: number ) -> number
RbxTween.registerDirection = EaseDirections.register

--- @within RbxTween
--- @function to
RbxTween.to = Tween.to

--- @within RbxTween
--- @function from
RbxTween.from = Tween.from

--- @within RbxTween
--- @function fromTo
RbxTween.fromTo = Tween.fromTo

--- @within RbxTween
--- @function timeline
--- @return Timeline
RbxTween.timeline = Timeline.timeline

-- local function recursiveMultiply(value, multiplier, accumulator): number
-- 	accumulator = accumulator or value
-- 	if multiplier == 0 then
-- 		return typeof(value) == "number" and 0 or value - value
-- 	elseif multiplier == 1 then
-- 		return value
-- 	else
-- 		return recursiveMultiply(accumulator + value, multiplier - 1, accumulator)
-- 	end
-- end

-- local function universalInterpolate(startValue: any, endValue: any, alpha: number): any
-- 	local interpolatable = TweenService:Create(Instance.new("NumberValue"), TweenInfo.new(0), { Value = alpha })

-- 	if interpolatable then
-- 		return startValue:Lerp(endValue, alpha)
-- 	else
-- 		error("Unsupported value type for interpolation: " .. typeof(startValue))
-- 	end
-- end

-- RbxTween.registerEaseStyle("reverse", function(t: number): number
-- 	return 1 - t
-- end)

-- RbxTween.staggerTargets = function(
-- 	targets: { Instance },
-- 	stagger: { offset: any, each: number, axis: any }?,
-- 	properties: { [string]: any }
-- )
-- 	if not stagger then
-- 		return {}
-- 	end

-- 	if type(stagger) == "function" then
-- 		local staggeredProperties = {}

-- 		for i, target in targets do
-- 			local staggerDelay = stagger(i, target, targets) or 0

-- 			staggeredProperties[target] = {
-- 				delay = staggerDelay,
-- 			}
-- 		end

-- 		return staggeredProperties
-- 	end

-- 	if typeof(stagger) == "number" then
-- 		stagger = { each = stagger }
-- 	end

-- 	local offset = stagger.offset or 0
-- 	local each = stagger.each or 0
-- 	local axis = stagger.axis or Vector3.new(1, 1, 1)
-- 	local totalTargets = #targets

-- 	local staggeredProperties = {}
-- 	for i, target in targets do
-- 		local staggeredValues = {}

-- 		for propertyName, baseValue in properties do
-- 			if typeof(baseValue) == typeof(axis) then
-- 				local stepOffset = recursiveMultiply(axis, (i - 1) * offset)
-- 				staggeredValues[propertyName] = baseValue + stepOffset
-- 			else
-- 				staggeredValues[propertyName] = baseValue
-- 			end
-- 		end

-- 		local staggerDelay = (i - 1) * each

-- 		staggeredProperties[target] = {
-- 			properties = staggeredValues,
-- 			delay = staggerDelay,
-- 		}
-- 	end

-- 	return staggeredProperties
-- end

-- RbxTween.stopTween = function(tweenId)
-- 	local tweenCache = RbxTween.Tweens[tweenId]
-- 	if tweenCache then
-- 		print("Stopping tween with ID:", tweenId)
-- 		RbxTween.Tweens[tweenId].connection:Disconnect()
-- 		RbxTween.Tweens[tweenId] = nil
-- 	else
-- 		print("No tween found with ID:", tweenId)
-- 	end
-- end

-- RbxTween.getTween = function(tweenId)
-- 	return RbxTween.Tweens[tweenId]
-- end

-- RbxTween.timeline = function(): {
-- 	add: (target: Instance, duration: number, properties: { [string]: any }) -> any,
-- 	play: () -> any,
-- }
-- 	local timeline = {
-- 		animations = {},
-- 		tweens = {},
-- 		onComplete = nil,
-- 	}

-- 	local timelineId = tostring(os.clock()) .. "_" .. tostring(math.random())

-- 	function timeline.add(target: Instance, duration: number, properties: { [string]: any })
-- 		table.insert(timeline.animations, { target = target, duration = duration, properties = properties })

-- 		RbxTween.Timelines[timelineId] = timeline
-- 		return timeline
-- 	end

-- 	function timeline:play()
-- 		local function playNextAnimation(index)
-- 			if index > #self.animations then
-- 				if self.onComplete then
-- 					self.onComplete()
-- 				end
-- 				return
-- 			end

-- 			local animation = self.animations[index]
-- 			local tweenId = RbxTween.to(animation.target, animation.duration, animation.properties)
-- 			RbxTween.Tweens[tweenId].onComplete = function()
-- 				playNextAnimation(index + 1)
-- 			end
-- 		end

-- 		playNextAnimation(1)
-- 	end

-- 	return timeline
-- end

return RbxTween
