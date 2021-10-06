local _, ns = ...
local oUF = ns.oUF

local smoothing = {}
local function Smooth(self, value)
	local _, max = self:GetMinMaxValues()
	if value == self:GetValue() or (self._max and self._max ~= max) then
		smoothing[self] = nil
		self:SetValue_(value)
	else
		smoothing[self] = value
	end
	self._max = max
end

local function UnSmoothBar(self, bar)
	smoothing[bar] = nil
	if bar.SetValue_ then
		bar.SetValue = bar.SetValue_
		bar.SetValue_ = nil
	end
	bar.Smooth = nil
end

local function SmoothBar(self, bar)
	if not bar.SetValue_ then
		bar.SetValue_ = bar.SetValue
		bar.SetValue = Smooth
	end
end

local function hook(frame)
	frame.SmoothBar = SmoothBar
	frame.UnSmoothBar = UnSmoothBar
	if frame.Health and frame.Health.Smooth then
		frame:SmoothBar(frame.Health)
	end
	if frame.Absorb and frame.Absorb.Smooth then
		frame:SmoothBar(frame.Absorb)
	end
	if frame.Power and frame.Power.Smooth then
		frame:SmoothBar(frame.Power)
	end
end

for i, frame in ipairs(oUF.objects) do
	hook(frame)
end
oUF:RegisterInitCallback(hook)

local f, min, max, abs = CreateFrame("Frame"), math.min, math.max, math.abs
f:SetScript("OnUpdate", function()
	local limit = 30 / GetFramerate()
	for bar, value in pairs(smoothing) do
		local minVal, maxVal = bar:GetMinMaxValues()
		local curVal = bar:GetValue()
		local new = curVal + min((value - curVal) / 5, max(value - curVal, limit))
		if new ~= new then
			new = value
		end
		bar:SetValue_(new)
		if curVal == value or abs(new - value) < 2 then
			bar:SetValue_(value)
			smoothing[bar] = nil
		end
	end
end)