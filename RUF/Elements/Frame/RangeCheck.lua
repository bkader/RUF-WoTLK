local RUF = RUF

function RUF:RangeCheckPostUpdate(frame, unit)
	if not frame.RangeCheck.enabled then return end
	frame:SetAlpha(frame.Alpha.range)
end

function RUF.RangeCheckUpdate(self, isInRange, event)
	local element = self.RangeCheck
	local unit = self.unit
	self.Alpha = self.Alpha or {}
	local currentAlpha = self.Alpha.target or 1 -- Work with combat fader
	local insideAlpha = currentAlpha * element.insideAlpha
	local outsideAlpha = currentAlpha * element.outsideAlpha

	if (element.PreUpdate) then
		element:PreUpdate()
	end

	if element.enabled == true then
		if isInRange then
			self.Alpha.range = insideAlpha
			self.Alpha.inRange = true
		else
			self.Alpha.range = outsideAlpha
			self.Alpha.inRange = false
		end
		if (element.PostUpdate) then
			return element:PostUpdate(self, unit)
		end
	else
		self.Alpha.range = 1
		self.Alpha.inRange = true
		self:DisableElement("RangeCheck")
	end
end