local RUF = RUF
local _, ns = ...
local oUF = ns.oUF

local Compat = ns.Compat
local UnitIsGroupAssistant = Compat.UnitIsGroupAssistant
local UnitIsGroupLeader = Compat.UnitIsGroupLeader

local elementName = "Assist"
local elementString = RUF.IndicatorGlyphs["Assist"]

local function Update(self, event)
	local element = self.AssistIndicator
	element.Enabled = RUF.db.profile.unit[self.frame].Frame.Indicators[elementName].Enabled

	if (element.PreUpdate) then
		element:PreUpdate()
	end

	if element.Enabled == true then
		self:EnableElement(elementName .. "Indicator")
		local isAssistant = UnitInRaid(self.unit) and UnitIsGroupAssistant(self.unit) and not UnitIsGroupLeader(self.unit)
		if element:IsObjectType("FontString") then
			if isAssistant then
				element:SetText(elementString)
				element:SetWidth(element:GetStringWidth() + 2)
				element:Show()
			else
				element:Hide()
				element:SetText(" ")
				element:SetWidth(1)
			end
		end
		if RUF.db.global.TestMode == true then
			element:SetText(elementString)
			element:SetWidth(element:GetStringWidth() + 2)
			element:Show()
		end
	else
		self:DisableElement("AssistIndicator")
		element:Hide()
	end

	if (element.PostUpdate) then
		return element:PostUpdate()
	end
end

local function Path(self, ...)
	return (self.AssistIndicator.Override or Update)(self, ...)
end

local function ForceUpdate(element)
	if (not element.__owner.unit) then return end
	return Path(element.__owner, "ForceUpdate")
end

local function Enable(self)
	local element = self.AssistIndicator
	if (element) then
		element.__owner = self
		element.ForceUpdate = ForceUpdate
		self:RegisterEvent("PARTY_MEMBERS_CHANGED", Path, true)
		self:RegisterEvent("RAID_ROSTER_UPDATE", Path, true)

		local profileReference = RUF.db.profile.unit[self.frame].Frame.Indicators[elementName]
		element:SetFont([[Interface\AddOns\RUF\Media\RUF.ttf]], profileReference.Size, "OUTLINE")
		element:SetText(" ")
		element:SetJustifyH("CENTER")
		element:SetTextColor(0.749, 0.698, 0.561)
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
	local element = self.AssistIndicator
	if (element) then
		element:Hide()

		self:UnregisterEvent("PARTY_MEMBERS_CHANGED", Path)
		self:UnregisterEvent("RAID_ROSTER_UPDATE", Path)
	end
end

oUF:AddElement("AssistIndicator", Path, Enable, Disable)

function RUF.Indicators.Assist(self, unit)
	if unit == "boss" or unit == "arena" or unit == "partypet" or unit == "pet" then
		return
	end

	local element = self.Indicators:CreateFontString(self:GetName() .. ".AssistIndicator", "OVERLAY")
	element:SetPoint(
		RUF.db.profile.unit[unit].Frame.Indicators[elementName].Position.AnchorFrom,
		RUF.GetIndicatorAnchorFrame(self, unit, elementName),
		RUF.db.profile.unit[unit].Frame.Indicators[elementName].Position.AnchorTo,
		RUF.db.profile.unit[unit].Frame.Indicators[elementName].Position.x,
		RUF.db.profile.unit[unit].Frame.Indicators[elementName].Position.y
	)

	element:SetFont([[Interface\AddOns\RUF\Media\RUF.ttf]], RUF.db.profile.unit[unit].Frame.Indicators[elementName].Size, "OUTLINE")

	self.AssistIndicator = element
end