local Number = require(script.Parent.Number)

local function evalNumberSequence(sequence: NumberSequence, time: number): number
	-- If time is 0 or 1, return the first or last value respectively
	if time == 0 then
		return sequence.Keypoints[1].Value
	elseif time == 1 then
		return sequence.Keypoints[#sequence.Keypoints].Value
	end

	-- Otherwise, step through each sequential pair of keypoints
	for i = 1, #sequence.Keypoints - 1 do
		local currKeypoint = sequence.Keypoints[i]
		local nextKeypoint = sequence.Keypoints[i + 1]
		if time >= currKeypoint.Time and time < nextKeypoint.Time then
			-- Calculate how far alpha lies between the points
			local alpha = (time - currKeypoint.Time) / (nextKeypoint.Time - currKeypoint.Time)
			-- Return the value between the points using alpha
			return currKeypoint.Value + (nextKeypoint.Value - currKeypoint.Value) * alpha
		end
	end

	return 0
end

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
