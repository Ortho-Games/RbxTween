--!strict

local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local EaseDirections = require(script.EaseDirections)
local EaseStyles = require(script.EaseStyles)
local Timeline = require(script.Timeline)
local Tween = require(script.Tween)
local Types = require(script.Types)
local evalNumberSequence = require(script.Utils.evalNumberSequence)

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

function RbxTween.tweenFromNumberSequence(numberSequence: NumberSequence): (x: number) -> number
	return function(x: number): number
		return evalNumberSequence(numberSequence, x)
	end
end

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

return RbxTween
