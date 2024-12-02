local Tween = require(script.Parent.Tween)

--- @class Timeline
local Timeline = {}

export type Timeline = {
	to: (targets: { Instance } | Instance, props: { [string]: any }) -> (),
	from: (targets: { Instance } | Instance, props: { [string]: any }) -> (),
	fromTo: (targets: { Instance } | Instance, props: { [string]: any }) -> (),
	pause: () -> (),
	play: () -> (),
	seek: (t: number) -> (),
	reverse: () -> (),
}

function Timeline.timeline(props: { [string]: any }): Timeline
	local self = {
		sequence = {},
	}

	--- @within Timeline
	function self.to(targets: { Instance } | Instance, props: { [string]: any })
		table.insert(self.sequence, Tween.to(targets, props))
	end

	--- @within Timeline
	function self.from(targets: { Instance } | Instance, props: { [string]: any })
		table.insert(self.sequence, Tween.from(targets, props))
	end

	--- @within Timeline
	function self.fromTo(targets: { Instance } | Instance, props: { [string]: any })
		table.insert(self.sequence, Tween.fromTo(targets, props))
	end

	--- @within Timeline
	function self.pause()
		---@TODO: Write this
	end

	--- @within Timeline
	function self.play()
		---@TODO: Write this
	end

	--- @within Timeline
	function self.seek(t: number)
		---@TODO: Write this
	end

	--- @within Timeline
	function self.reverse()
		---@TODO: Write this
	end

	return self
end

return Timeline
