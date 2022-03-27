local RUF = RUF
local _, ns = ...
local oUF = ns.oUF

local UnitInRaid = UnitInRaid
local UnitHasVehicleUI = UnitHasVehicleUI
local GetPartyAssignment = GetPartyAssignment

local elementName = "MainTankAssist"
local elementStringMAINASSIST = RUF.IndicatorGlyphs["MainAssist"]
local elementStringMAINTANK = RUF.IndicatorGlyphs["MainTank"]

local function Update(self, event)
	local element = self.MainTankAssistIndicator
	element.Enabled = RUF.db.profile.unit[self.frame].Frame.Indicators[elementName].Enabled

	if (element.PreUpdate) then
		element:PreUpdate()
	end

	if element.Enabled == true then
		self:EnableElement(elementName .. "Indicator")
		local unitVehicleUI = UnitHasVehicleUI(self.unit)
		if UnitInRaid(self.unit) and not unitVehicleUI then
			if GetPartyAssignment("MAINTANK", self.unit) then
				element:SetText(elementStringMAINTANK)
				element:SetWidth(element:GetStringWidth() + 2)
				element:SetTextColor(1, 0.745, 0.098)
			elseif GetPartyAssignment("MAINASSIST", self.unit) then
				element:SetText(elementStringMAINASSIST)
				element:SetWidth(element:GetStringWidth() + 2)
				element:SetTextColor(1, 0.745, 0.098)
			else
				element:SetText(" ")
				element:SetWidth(1)
			end
		else
			element:SetText(" ")
			element:SetWidth(1)
		end
		if RUF.db.global.TestMode == true then
			element:SetText(elementStringMAINASSIST)
			element:SetWidth(element:GetStringWidth() + 2)
			element:Show()
		end
	else
		self:DisableElement("MainTankAssistIndicator")
		element:Hide()
	end

	if (element.PostUpdate) then
		return element:PostUpdate()
	end
end

local function Path(self, ...)
	return (self.MainTankAssistIndicator.Override or Update)(self, ...)
end

local function ForceUpdate(element)
	if (not element.__owner.unit) then return end
	return Path(element.__owner, "ForceUpdate")
end

local function Enable(self)
	local element = self.MainTankAssistIndicator
	if (element) then
		element.__owner = self
		element.ForceUpdate = ForceUpdate
		self:RegisterEvent("PARTY_MEMBERS_CHANGED", Path, true)
		self:RegisterEvent("RAID_ROSTER_UPDATE", Path, true)
		self:RegisterEvent("PLAYER_ROLES_ASSIGNED", Path, true)

		local profileReference = RUF.db.profile.unit[self.frame].Frame.Indicators[elementName]
		element:SetFont([[Interface\AddOns\RUF\Media\RUF.ttf]], profileReference.Size, "OUTLINE")
		element:SetText(" ")
		element:SetJustifyH("CENTER")
		element:SetTextColor(1, 0.75, 0.10)
		element:ClearAllPoints()
		element:SetPoint(
			profileReference.Position.AnchorFrom,
			RUF.GetIndicatorAnchorFrame(self, self.frame, elementName),
			profileReference.Position.AnchorTo,
			profileReference.Position.x,
			profileReference.Position.y
		)

		element:Show()
		return true
	end
end

local function Disable(self)
	local element = self.MainTankAssistIndicator
	if (element) then
		element:Hide()
		self:UnregisterEvent("PARTY_MEMBERS_CHANGED", Path)
		self:UnregisterEvent("RAID_ROSTER_UPDATE", Path)
		self:UnregisterEvent("PLAYER_ROLES_ASSIGNED", Path)
	end
end

oUF:AddElement("MainTankAssistIndicator", Path, Enable, Disable)

function RUF.Indicators.MainTankAssist(self, unit)
	if unit == "pet" or unit == "partypet" or unit == "boss" or unit == "arena" then return end

	local element = self.Indicators:CreateFontString(self:GetName() .. ".MainTankAssistIndicator", "OVERLAY")
	element:SetPoint(
		RUF.db.profile.unit[unit].Frame.Indicators[elementName].Position.AnchorFrom,
		RUF.GetIndicatorAnchorFrame(self, unit, elementName),
		RUF.db.profile.unit[unit].Frame.Indicators[elementName].Position.AnchorTo,
		RUF.db.profile.unit[unit].Frame.Indicators[elementName].Position.x,
		RUF.db.profile.unit[unit].Frame.Indicators[elementName].Position.y
	)

	element:SetFont([[Interface\AddOns\RUF\Media\RUF.ttf]], RUF.db.profile.unit[unit].Frame.Indicators[elementName].Size, "OUTLINE")

	self.MainTankAssistIndicator = element
end