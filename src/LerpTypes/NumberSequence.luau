local ReplicatedStorage = game:GetService("ReplicatedStorage")

local evalNumberSequence = require(ReplicatedStorage.RbxTween.Utils.evalNumberSequence)
local Number = require(script.Parent.Number)

local function lerp(a: NumberSequence, b: NumberSequence, t: number): NumberSequence
	local numSet = {}
	for _, keypoint: NumberSequenceKeypoint in a.Keypoints do
		table.insert(numSet, keypoint.Time)
	end
	for _, keypoint: NumberSequenceKeypoint in b.Keypoints do
		if table.find(numSet, keypoint.Time) then
			continue
		end

		table.insert(numSet, keypoint.Time)
	end

	local keypoints: { NumberSequenceKeypoint } = {}
	for _, alpha in numSet do
		local a_val = evalNumberSequence(a, alpha)
		local b_val = evalNumberSequence(b, alpha)

		table.insert(keypoints, NumberSequenceKeypoint.new(alpha, Number(a_val, b_val, alpha)))
	end

	return NumberSequence.new(keypoints)
end

require(script.Parent).register("NumberSequence", lerp)

return lerp
