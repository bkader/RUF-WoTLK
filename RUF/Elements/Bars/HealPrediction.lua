assert(RUF, "RUF not found!")
local RUF = RUF
local LSM = LibStub("LibSharedMedia-3.0")
local _, ns = ...
local oUF = ns.oUF

local HealComm = LibStub("LibHealComm-4.0")

function RUF.HealPredictionUpdateColor(element, unit, myIncomingHeal, otherIncomingHeal, absorb, healAbsorb, hasOverAbsorb, hasOverHealAbsorb)
	local cur = UnitHealth(unit)
	if element.myBar then
		local r, g, b = RUF:GetBarColor(element, unit, "HealPrediction", "Player", cur)
		local a = RUF.db.profile.Appearance.Bars.HealPrediction.Player.Color.Alpha
		element.myBar:SetStatusBarColor(r, g, b, a)
	end
	if element.otherBar then
		local r, g, b = RUF:GetBarColor(element, unit, "HealPrediction", "Others", cur)
		local a = RUF.db.profile.Appearance.Bars.HealPrediction.Others.Color.Alpha
		element.otherBar:SetStatusBarColor(r, g, b, a)
	end

	local HealComm = LibStub("LibHealComm-4.0", true)
	local unitGUID = UnitGUID(unit)
	local lookAhead = element.lookAhead or 5
	local healTime, healFrom, healAmount =
		HealComm:GetNextHealAmount(unitGUID, HealComm.CASTED_HEALS, GetTime() + lookAhead)
	if not healTime then
		return
	end
	local nextHealer
	local anchorFrom, anchorTo, anchorTexture
	if element.__owner.Health.FillStyle == "REVERSE" then -- Right
		anchorFrom = "RIGHT"
		anchorTo = "LEFT"
	elseif element.__owner.Health.FillStyle == "CENTER" then
		anchorFrom = "CENTER"
		anchorTo = "CENTER"
	else -- Left
		anchorFrom = "LEFT"
		anchorTo = "RIGHT"
	end

	element.myBar:ClearAllPoints()
	element.otherBar:ClearAllPoints()
	element.myBar:SetPoint("TOP")
	element.myBar:SetPoint("BOTTOM")
	element.otherBar:SetPoint("TOP")
	element.otherBar:SetPoint("BOTTOM")

	element.myBar:SetFillStyle(element.myBar.FillStyle)
	element.otherBar:SetFillStyle(element.otherBar.FillStyle)

	if healFrom ~= UnitGUID("player") then
		element.otherBar:SetPoint(anchorFrom, element.__owner.Health:GetStatusBarTexture(), anchorTo)
		if element.otherBar.Enabled then
			anchorTexture = element.otherBar:GetStatusBarTexture()
		else
			anchorTexture = element.__owner.Health:GetStatusBarTexture()
		end
		element.myBar:SetPoint(anchorFrom, anchorTexture, anchorTo)
	else
		element.myBar:SetPoint(anchorFrom, element.__owner.Health:GetStatusBarTexture(), anchorTo)
		if element.myBar.Enabled then
			anchorTexture = element.myBar:GetStatusBarTexture()
		else
			anchorTexture = element.__owner.Health:GetStatusBarTexture()
		end
		element.otherBar:SetPoint(anchorFrom, anchorTexture, anchorTo)
	end
end

function RUF.SetHealPrediction(self, unit)
	local PlayerHeals, OtherHeals
	local Health = self.Health

	PlayerHeals = RUF.StatusBarPrototype(nil, Health)
	OtherHeals = RUF.StatusBarPrototype(nil, Health)
	local anchorFrom, anchorTo
	if Health.FillStyle == "REVERSE" then -- Right
		anchorFrom = "RIGHT"
		anchorTo = "LEFT"
	elseif Health.FillStyle == "CENTER" then
		-- TODO: Create a bar on either side of the health bar and split value in two to make it grow outwards.
		anchorFrom = "CENTER"
		anchorTo = "CENTER"
	else -- Left
		anchorFrom = "LEFT"
		anchorTo = "RIGHT"
	end

	local profileReference = RUF.db.profile.Appearance.Bars.HealPrediction
	local texture = LSM:Fetch("statusbar", profileReference.Player.Texture)
	PlayerHeals:SetPoint("TOP")
	PlayerHeals:SetPoint("BOTTOM")
	PlayerHeals:SetPoint(anchorFrom, self.Health:GetStatusBarTexture(), anchorTo)
	PlayerHeals:SetStatusBarTexture(texture)
	PlayerHeals:SetStatusBarColor(0, 1, 0, 1)
	PlayerHeals:SetWidth(self:GetWidth())
	PlayerHeals:SetFrameLevel(11)
	PlayerHeals:Hide()
	PlayerHeals.FillStyle = RUF.db.profile.unit[unit].Frame.Bars.Health.Fill
	PlayerHeals.Enabled = profileReference.Player.Enabled

	texture = LSM:Fetch("statusbar", profileReference.Others.Texture)
	OtherHeals:SetPoint("TOP")
	OtherHeals:SetPoint("BOTTOM")
	OtherHeals:SetPoint(anchorFrom, PlayerHeals:GetStatusBarTexture(), anchorTo)
	OtherHeals:SetStatusBarTexture(texture)
	OtherHeals:SetStatusBarColor(0, 1, 1, 1)
	OtherHeals:SetWidth(self:GetWidth())
	OtherHeals:SetFrameLevel(11)
	OtherHeals:Hide()
	OtherHeals.FillStyle = RUF.db.profile.unit[unit].Frame.Bars.Health.Fill
	OtherHeals.Enabled = profileReference.Others.Enabled

	-- Register with oUF
	self.HealPrediction = {
		myBar = PlayerHeals,
		otherBar = OtherHeals,
		maxOverflow = 1 + profileReference.Overflow or 0,
		frequentUpdates = true --RUF.Client == 2 -- UNIT_HEALTH_FREQUENT removed from 9.0, use it for Classic though.
	}
	self.HealPrediction.UpdateOptions = RUF.HealPredictionUpdateOptions
end

function RUF.HealPredictionUpdateOptions(self)
	local unit = self.__owner.frame
	local profileReference = RUF.db.profile.Appearance.Bars.HealPrediction
	self.frequentUpdates = true --RUF.Client == 2 -- UNIT_HEALTH_FREQUENT removed from 9.0, use it for Classic though.
	self.maxOverflow = 1 + profileReference.Overflow or 0

	local PlayerHeals = self.myBar
	local OtherHeals = self.otherBar

	local anchorFrom, anchorTo, anchorTexture
	if self.__owner.Health.FillStyle == "REVERSE" then -- Right
		anchorFrom = "RIGHT"
		anchorTo = "LEFT"
	elseif self.__owner.Health.FillStyle == "CENTER" then
		-- TODO: Create a bar on either side of the health bar and split value in two to make it grow outwards.
		anchorFrom = "CENTER"
		anchorTo = "CENTER"
	else -- Left
		anchorFrom = "LEFT"
		anchorTo = "RIGHT"
	end

	local texture = LSM:Fetch("statusbar", profileReference.Player.Texture)
	PlayerHeals:ClearAllPoints()
	PlayerHeals:SetPoint("TOP")
	PlayerHeals:SetPoint("BOTTOM")
	PlayerHeals:SetPoint(anchorFrom, self.__owner.Health:GetStatusBarTexture(), anchorTo)
	PlayerHeals:SetStatusBarTexture(texture)
	PlayerHeals:SetWidth(self.__owner:GetWidth())
	PlayerHeals:SetFrameLevel(11)
	PlayerHeals.Enabled = profileReference.Player.Enabled
	PlayerHeals.FillStyle = RUF.db.profile.unit[unit].Frame.Bars.Health.Fill

	if PlayerHeals.Enabled then
		anchorTexture = PlayerHeals:GetStatusBarTexture()
	else
		anchorTexture = self.__owner.Health:GetStatusBarTexture()
	end
	texture = LSM:Fetch("statusbar", profileReference.Others.Texture)

	OtherHeals:ClearAllPoints()
	OtherHeals:SetPoint("TOP")
	OtherHeals:SetPoint("BOTTOM")
	OtherHeals:SetPoint(anchorFrom, anchorTexture, anchorTo)
	OtherHeals:SetStatusBarTexture(texture)
	OtherHeals:SetWidth(self.__owner:GetWidth())
	OtherHeals:SetFrameLevel(11)
	OtherHeals.FillStyle = RUF.db.profile.unit[unit].Frame.Bars.Health.Fill
	OtherHeals.Enabled = profileReference.Others.Enabled

	self:ForceUpdate()
end