--[[
# Element: Health Prediction Bars

Handles the visibility and updating of incoming heals.

## Widget

HealPrediction - A `table` containing references to sub-widgets and options.

## Sub-Widgets

myBar		  - A `StatusBar` used to represent incoming heals from the player.
otherBar	   - A `StatusBar` used to represent incoming heals from others.

## Notes

A default texture will be applied to the StatusBar widgets if they don't have a texture set.
A default texture will be applied to the Texture widgets if they don't have a texture or a color set.

## Options

.maxOverflow	 - The maximum amount of overflow past the end of the health bar. Set this to 1 to disable the overflow.
				   Defaults to 1.05 (number)
.frequentUpdates - Indicates whether to use UNIT_HEALTH_FREQUENT instead of UNIT_HEALTH. Use this if .frequentUpdates is
				   also set on the Health element (boolean)
.lookAhead		 - Classic only, the duration in seconds into the future to look for incoming healing.
				   Defaults to 5 (number)

## Examples

	-- Position and size
	local myBar = CreateFrame('StatusBar', nil, self.Health)
	myBar:SetPoint('TOP')
	myBar:SetPoint('BOTTOM')
	myBar:SetPoint('LEFT', self.Health:GetStatusBarTexture(), 'RIGHT')
	myBar:SetWidth(200)

	local otherBar = CreateFrame('StatusBar', nil, self.Health)
	otherBar:SetPoint('TOP')
	otherBar:SetPoint('BOTTOM')
	otherBar:SetPoint('LEFT', myBar:GetStatusBarTexture(), 'RIGHT')
	otherBar:SetWidth(200)

	-- Register with oUF
	self.HealPrediction = {
		myBar = myBar,
		otherBar = otherBar,
		maxOverflow = 1.05,
		frequentUpdates = true,
	}
--]]
local _, ns = ...
local oUF = ns.oUF

local HealComm = LibStub("LibHealComm-4.0")

local function Update(self, event, unit)
	if (self.unit ~= unit) then return end
	local element = self.HealPrediction

	--[[ Callback: HealPrediction:PreUpdate(unit)
	Called before the element has been updated.

	* self - the HealPrediction element
	* unit - the unit for which the update has been triggered (string)
	--]]
	if (element.PreUpdate) then
		element:PreUpdate(unit)
	end

	local myIncomingHeal, allIncomingHeal, health, maxHealth, otherIncomingHeal
	local unitGUID = UnitGUID(unit)
	local lookAhead = element.lookAhead or 5
	myIncomingHeal = (HealComm:GetHealAmount(unitGUID, HealComm.ALL_HEALS, GetTime() + lookAhead, UnitGUID("player")) or 0) * (HealComm:GetHealModifier(unitGUID) or 1) or 0
	otherIncomingHeal = (HealComm:GetOthersHealAmount(unitGUID, HealComm.ALL_HEALS, GetTime() + lookAhead) or 0) * (HealComm:GetHealModifier(unitGUID) or 1) or 0
	health, maxHealth = UnitHealth(unit), UnitHealthMax(unit)
	allIncomingHeal = myIncomingHeal + otherIncomingHeal

	local overflow = maxHealth * element.maxOverflow
	if health + allIncomingHeal > overflow then
		local healTime, healFrom, healAmount = HealComm:GetNextHealAmount(unitGUID, HealComm.ALL_HEALS, GetTime() + lookAhead)
		local toClip = health + allIncomingHeal - overflow
		local primary, secondary
		if healTime then
			if healFrom ~= UnitGUID("player") then
				primary = otherIncomingHeal
				secondary = myIncomingHeal
			else
				primary = myIncomingHeal
				secondary = otherIncomingHeal
			end
			if toClip > allIncomingHeal then
				myIncomingHeal = 0
				otherIncomingHeal = 0
				toClip = 0
			end
			if toClip > secondary then
				toClip = toClip - secondary
				secondary = 0
				primary = primary - toClip
			else
				secondary = secondary - toClip
			end
			if healFrom ~= UnitGUID("player") then
				myIncomingHeal = secondary
				otherIncomingHeal = primary
			else
				myIncomingHeal = primary
				otherIncomingHeal = secondary
			end
		end
	end

	if (element.myBar) then
		if not element.myBar.Enabled then
			element.myBar:SetValue(0)
		else
			element.myBar:SetMinMaxValues(0, maxHealth)
			element.myBar:SetValue(myIncomingHeal)
			if myIncomingHeal > 0 then
				element.myBar:SetAlpha(1)
			end
			element.myBar:Show()
		end
	end

	if (element.otherBar) then
		if not element.otherBar.Enabled then
			element.otherBar:SetValue(0)
		else
			element.otherBar:SetMinMaxValues(0, maxHealth)
			element.otherBar:SetValue(otherIncomingHeal)
			if myIncomingHeal > 0 then
				element.otherBar:SetAlpha(1)
			end
			element.otherBar:Show()
		end
	end

	if (element.PostUpdate) then
		return element:PostUpdate(unit, myIncomingHeal, otherIncomingHeal)
	end
end

local function Path(self, ...)
	--[[ Override: HealPrediction.Override(self, event, unit)
	Used to completely override the internal update function.

	* self	- the parent object
	* event - the event triggering the update (string)
	* unit	- the unit accompanying the event
	--]]
	return (self.HealPrediction.Override or Update)(self, ...)
end

local function HealCommUpdate(self, event, casterGUID, spellID, type, endTime, ...)
	for i = 1, select("#", ...) do
		if select(i, ...) == UnitGUID(self.unit) then
			Path(self, event, self.unit)
		end
	end
end

local function ForceUpdate(element)
	return Path(element.__owner, "ForceUpdate", element.__owner.unit)
end

local function Enable(self)
	local element = self.HealPrediction
	if (element) then
		element.__owner = self
		element.ForceUpdate = ForceUpdate

		if element.frequentUpdates then
			self:RegisterEvent("UNIT_HEALTH_FREQUENT", Path)
		else
			self:RegisterEvent("UNIT_HEALTH", Path)
		end

		self:RegisterEvent("UNIT_MAXHEALTH", Path)

		HealComm = HealComm or LibStub("LibHealComm-4.0")
		self.HealCommUpdate = HealCommUpdate
		HealComm.RegisterCallback(self, "HealComm_HealStarted", "HealCommUpdate")
		HealComm.RegisterCallback(self, "HealComm_HealUpdated", "HealCommUpdate")
		HealComm.RegisterCallback(self, "HealComm_HealDelayed", "HealCommUpdate")
		HealComm.RegisterCallback(self, "HealComm_HealStopped", "HealCommUpdate")

		if (not element.maxOverflow) then
			element.maxOverflow = 1.05
		end

		if (not element.lookAhead) then
			element.lookAhead = 5
		end

		if (element.myBar and element.myBar:IsObjectType("StatusBar") and not element.myBar:GetStatusBarTexture()) then
			element.myBar:SetStatusBarTexture([[Interface\TargetingFrame\UI-StatusBar]])
		end

		if (element.otherBar and element.otherBar:IsObjectType("StatusBar") and not element.otherBar:GetStatusBarTexture()) then
			element.otherBar:SetStatusBarTexture([[Interface\TargetingFrame\UI-StatusBar]])
		end

		return true
	end
end

local function Disable(self)
	local element = self.HealPrediction
	if (element) then
		if (element.myBar) then
			element.myBar:Hide()
		end

		if (element.otherBar) then
			element.otherBar:Hide()
		end

		self:UnregisterEvent("UNIT_HEALTH", Path)
		self:UnregisterEvent("UNIT_MAXHEALTH", Path)

		HealComm = HealComm or LibStub("LibHealComm-4.0")
		HealComm.UnregisterCallback(self, "HealComm_HealStarted")
		HealComm.UnregisterCallback(self, "HealComm_HealUpdated")
		HealComm.UnregisterCallback(self, "HealComm_HealDelayed")
		HealComm.UnregisterCallback(self, "HealComm_HealStopped")
	end
end

oUF:AddElement("HealPrediction", Path, Enable, Disable)