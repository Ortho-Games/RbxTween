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

local t = os.clock()
local tw = RbxTween.to(testPart, {
	CFrame = CFrame.new(5, 5, 10),
	duration = 5,
	onComplete = function()
		print(os.clock() - t, "time elapsed")
	end,
})
tw.play()
