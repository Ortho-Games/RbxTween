local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RbxTween = require(ReplicatedStorage.RbxTween)

local function makePart()
	local p = Instance.new("Part")
	p.Anchored = true
	p.CFrame = CFrame.new(5, 5, 0)
	p.Parent = workspace
	return p
end

local testPart = makePart()

task.wait(5)
print("[RbxTween] initializing test")

-- local t = os.clock()
-- local tw = RbxTween.to(testPart, {
-- 	CFrame = CFrame.new(5, 5, 10),
-- 	duration = 5,
-- 	onComplete = function()
-- 		print(os.clock() - t, "time elapsed")
-- 	end,
-- })
-- tw.play()

local p = makePart()
local particleEmitter = Instance.new("ParticleEmitter")
particleEmitter.Parent = p

local n1 = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 0),
	NumberSequenceKeypoint.new(0.25, 0.75),
	NumberSequenceKeypoint.new(1, 1),
})

RbxTween.to(particleEmitter, {
	Transparency = n1,
	duration = 10,
}).play()
