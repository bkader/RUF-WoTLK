local RUF = RUF
local _, ns = ...
local oUF = ns.oUF

local UnitInParty = UnitInParty
local UnitInRaid = UnitInRaid

local Compat = ns.Compat
local UnitIsGroupLeader = Compat.UnitIsGroupLeader

local elementName = "Lead"
local elementString = RUF.IndicatorGlyphs["Lead"]

local function Update(self, event)
	local element = self.LeadIndicator
	element.Enabled = RUF.db.profile.unit[self.frame].Frame.Indicators[elementName].Enabled

	if (element.PreUpdate) then
		element:PreUpdate()
	end
	if element.Enabled == true then
		self:EnableElement(elementName .. "Indicator")
		local isLeader = (UnitInParty(self.unit) or UnitInRaid(self.unit)) and UnitIsGroupLeader(self.unit)
		if (isLeader) then
			element:SetText(elementString)
			element:SetWidth(element:GetStringWidth() + 2)
			element:Show()
		else
			element:SetText(" ")
			element:SetWidth(1)
			element:Hide()
		end
		if RUF.db.global.TestMode == true then
			element:SetText(elementString)
			element:SetWidth(element:GetStringWidth() + 2)
			element:Show()
		end
	else
		self:DisableElement("LeadIndicator")
		element:Hide()
	end

	if (element.PostUpdate) then
		return element:PostUpdate()
	end
end

local function Path(self, ...)
	return (self.LeadIndicator.Override or Update)(self, ...)
end

local function ForceUpdate(element)
	if (not element.__owner.unit) then return end
	return Path(element.__owner, "ForceUpdate")
end

local function Enable(self)
	local element = self.LeadIndicator
	if (element) then
		element.__owner = self
		element.ForceUpdate = ForceUpdate
		self:RegisterEvent("PARTY_LEADER_CHANGED", Path, true)
		self:RegisterEvent("PARTY_MEMBERS_CHANGED", Path, true)
		self:RegisterEvent("RAID_ROSTER_UPDATE", Path, true)

		local profileReference = RUF.db.profile.unit[self.frame].Frame.Indicators[elementName]
		element:SetFont([[Interface\AddOns\RUF\Media\RUF.ttf]], profileReference.Size, "OUTLINE")
		element:SetText(" ")
		element:SetJustifyH("CENTER")
		element:SetTextColor(1, 0.745, 0.098)
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
	local element = self.LeadIndicator
	if (element) then
		element:Hide()

		self:UnregisterEvent("PARTY_LEADER_CHANGED", Path)
		self:UnregisterEvent("RAID_ROSTER_UPDATE", Path)
	end
end

oUF:AddElement("LeadIndicator", Path, Enable, Disable)

function RUF.Indicators.Lead(self, unit)
	if unit == "pet" or unit == "boss" or unit == "arena" or unit == "partypet" then return end

	local element = self.Indicators:CreateFontString(self:GetName() .. ".LeadIndicator", "OVERLAY")
	element:SetPoint(
		RUF.db.profile.unit[unit].Frame.Indicators[elementName].Position.AnchorFrom,
		RUF.GetIndicatorAnchorFrame(self, unit, elementName),
		RUF.db.profile.unit[unit].Frame.Indicators[elementName].Position.AnchorTo,
		RUF.db.profile.unit[unit].Frame.Indicators[elementName].Position.x,
		RUF.db.profile.unit[unit].Frame.Indicators[elementName].Position.y
	)

	element:SetFont([[Interface\AddOns\RUF\Media\RUF.ttf]], RUF.db.profile.unit[unit].Frame.Indicators[elementName].Size, "OUTLINE")

	self.LeadIndicator = element
end