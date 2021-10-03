assert(RUF, "RUF not found!")
local RUF = RUF
local SA = LibStub("SpecializedAbsorbs-1.0", true)
local LSM = LibStub("LibSharedMedia-3.0")
local _, ns = ...
local oUF = ns.oUF

local UnitGetTotalAbsorbs = function(unit)
	return (SA and unit) and SA.UnitTotal(UnitGUID(unit)) or 0
end

function RUF.SetAbsorbBar(self, unit)
	local Texture = LSM:Fetch("statusbar", RUF.db.profile.Appearance.Bars.Absorb.Texture)
	local Bar = RUF.StatusBarPrototype(nil, self)
	local Border = CreateFrame("Frame", nil, Bar)
	local Background = Bar.bg

	-- Bar
	Bar.colorClass = RUF.db.profile.Appearance.Bars.Absorb.Color.Class
	Bar.colorDisconnected = RUF.db.profile.Appearance.Bars.Absorb.Color.Disconnected
	Bar.colorSmooth = RUF.db.profile.Appearance.Bars.Absorb.Color.Percentage
	Bar.smoothGradient = RUF.db.profile.Appearance.Bars.Absorb.Color.PercentageGradient
	Bar.colorReaction = RUF.db.profile.Appearance.Bars.Absorb.Color.Reaction
	Bar.colorTapping = RUF.db.profile.Appearance.Bars.Absorb.Color.Tapped
	Bar.colorHealth = true -- BaseColor, always enabled, so if none of the other colors match, it falls back to this.
	Bar.Smooth = RUF.db.profile.unit[unit].Frame.Bars.Absorb.Animate
	Bar.hideAtZero = RUF.db.profile.unit[unit].Frame.Bars.Absorb.Enabled == 1
	Bar:SetStatusBarTexture(Texture)
	Bar:SetFrameLevel(12)

	if RUF.db.profile.Appearance.Bars.Absorb.Type == 1 then
		local a = RUF.db.profile.Appearance.Bars.Absorb.Color.Alpha
		Bar:SetAlpha(a)
		Bar:SetAllPoints(self)
		Border:Hide()
		Background:Hide()
	end

	-- Register with oUF
	self.Absorb = Bar
	self.Absorb.Border = Border
	self.Absorb.Background = Background

	self.Absorb.UpdateOptions = RUF.AbsorbUpdateOptions
end

function RUF.AbsorbUpdate(self, event, unit)
	if self.unit ~= unit then return end
	if RUF.db.profile.Appearance.Bars.Absorb.Type == 0 or RUF.db.profile.unit[self.frame].Frame.Bars.Absorb.Enabled == 0 then
		self:DisableElement("Absorb")
		return
	end

	local element = self.Absorb

	if element.PreUpdate then
		element:PreUpdate(unit)
	end

	local absorb = UnitGetTotalAbsorbs(unit) or 0
	local health, maxHealth = UnitHealth(unit), UnitHealthMax(unit)

	if RUF.db.global.TestMode == true then
		absorb = math.random(25, 75)
		maxHealth = 100
	end

	element:SetMinMaxValues(0, maxHealth)
	element:SetValue(absorb)
	local r, g, b = RUF:GetBarColor(element, unit, "Absorb")
	local a = RUF.db.profile.Appearance.Bars.Absorb.Color.Alpha
	local barMult = RUF.db.profile.Appearance.Bars.Absorb.Color.Multiplier
	if RUF.db.profile.Appearance.Bars.Absorb.Type == 1 then
		element:SetAlpha(a)
	end
	element:SetStatusBarColor(r * barMult, g * barMult, b * barMult)

	if element.hideAtZero == true then
		if absorb < 1 then
			if element:IsVisible() then
				element:Hide()
			end
		else
			if not element:IsVisible() then
				element:Show()
			end
		end
	end

	if element.PostUpdate then
		return element:PostUpdate(unit, absorb)
	end
end

function RUF.AbsorbUpdateOptions(self)
	local unit = self.__owner.frame
	local Bar = self

	local Texture = LSM:Fetch("statusbar", RUF.db.profile.Appearance.Bars.Absorb.Texture)
	Bar.colorClass = RUF.db.profile.Appearance.Bars.Absorb.Color.Class
	Bar.colorDisconnected = RUF.db.profile.Appearance.Bars.Absorb.Color.Disconnected
	Bar.colorSmooth = RUF.db.profile.Appearance.Bars.Absorb.Color.Percentage
	Bar.smoothGradient = RUF.db.profile.Appearance.Bars.Absorb.Color.PercentageGradient
	Bar.colorReaction = RUF.db.profile.Appearance.Bars.Absorb.Color.Reaction
	Bar.colorTapping = RUF.db.profile.Appearance.Bars.Absorb.Color.Tapped
	Bar.colorHealth = true -- BaseColor, always enabled, so if none of the other colors match, it falls back to this.
	Bar.Smooth = RUF.db.profile.unit[unit].Frame.Bars.Absorb.Animate
	Bar.hideAtZero = RUF.db.profile.unit[unit].Frame.Bars.Absorb.Enabled == 1
	Bar:SetStatusBarTexture(Texture)
	Bar:SetFrameLevel(12)
	Bar:SetFillStyle(RUF.db.profile.unit[unit].Frame.Bars.Absorb.Fill)

	if Bar.Smooth == true then
		self.__owner:SmoothBar(Bar)
	else
		self.__owner:UnSmoothBar(Bar)
	end

	self:ForceUpdate()
	if RUF.db.profile.Appearance.Bars.Absorb.Type == 0 or RUF.db.profile.unit[unit].Frame.Bars.Absorb.Enabled == 0 then
		self:Hide()
	else
		self.__owner:EnableElement("Absorb")
	end
end