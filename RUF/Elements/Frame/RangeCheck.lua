assert(RUF, "RUF not found!")
local RUF = RUF
local _, ns = ...
local oUF = ns.oUF

function RUF:RangeCheckPostUpdate(frame, unit)
	if not frame.RangeCheck.enabled then return end
	if InCombatLockdown() then
		frame:SetAlpha(frame.Alpha.range)
		return
	end
	if not frame.Animator then
		frame:SetAlpha(frame.Alpha.range)
		return
	end
	if frame.Animator:IsPlaying() then
		if frame.Alpha.inRange == false then
			frame.Animator:Stop()
			frame:SetAlpha(frame.Alpha.range)
			frame.Alpha.current = frame.Alpha.range
		end
	else
		frame:SetAlpha(frame.Alpha.range)
	end
end

function RUF.RangeCheckUpdate(self, isInRange, event)
	local element = self.RangeCheck
	local unit = self.unit
	if not self.Alpha then
		self.Alpha = {}
	end
	local currentAlpha = self.Alpha.target or 1 -- Work with combat fader
	local insideAlpha = currentAlpha * element.insideAlpha
	local outsideAlpha = currentAlpha * element.outsideAlpha

	if(element.PreUpdate) then
		element:PreUpdate()
	end

	if element.enabled == true then
		if isInRange then
			--self:SetAlpha(insideAlpha)
			self.Alpha.range = insideAlpha
			self.Alpha.inRange = true
		else
			--self:SetAlpha(outsideAlpha)
			self.Alpha.range = outsideAlpha
			self.Alpha.inRange = false
		end
		if(element.PostUpdate) then
			return element:PostUpdate(self, unit)
		end
	else
		--self:SetAlpha(1)
		self.Alpha.range = 1
		self.Alpha.inRange = true
		self:DisableElement('RangeCheck')
	end
end