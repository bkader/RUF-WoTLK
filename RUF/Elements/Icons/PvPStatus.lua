assert(RUF, "RUF not found!")
local RUF = RUF
local _, ns = ...
local oUF = ns.oUF

local UnitIsPVP = UnitIsPVP
local UnitFactionGroup = UnitFactionGroup
local UnitIsPVPFreeForAll = UnitIsPVPFreeForAll

local elementName = "PvPCombat"
local elementStringAlliance = RUF.IndicatorGlyphs["PvP-Alliance"]
local elementStringHorde = RUF.IndicatorGlyphs["PvP-Horde"]

local function Update(self, event, unit)
	if (unit ~= self.unit) then
		return
	end
	local element = self.PvPCombatIndicator
	element.Enabled = RUF.db.profile.unit[self.frame].Frame.Indicators[elementName].Enabled

	if (element.PreUpdate) then
		element:PreUpdate(unit)
	end

	if element.Enabled == true then
		self:EnableElement(elementName .. "Indicator")
		local status
		local factionGroup = UnitFactionGroup(unit)
		if (UnitIsPVPFreeForAll(unit)) then
			status = "FFA"
		elseif (factionGroup and factionGroup ~= "Neutral" and UnitIsPVP(unit)) then
			status = factionGroup
		end
		if element:IsObjectType("FontString") then
			if status == "FFA" then
				if factionGroup == "Horde" then
					element:SetText(elementStringHorde)
				elseif factionGroup == "Alliance" then
					element:SetText(elementStringAlliance)
				end
				element:Show()
				element:SetWidth(element:GetStringWidth() + 2)
				element:SetTextColor(1, 0.745, 0.098)
			elseif status == "Horde" then
				element:Show()
				element:SetText(elementStringHorde)
				element:SetWidth(element:GetStringWidth() + 2)
				element:SetTextColor(1, 0.000, 0.098)
			elseif status == "Alliance" then
				element:Show()
				element:SetText(elementStringAlliance)
				element:SetWidth(element:GetStringWidth() + 2)
				element:SetTextColor(0, 0.620, 1)
			else
				element:SetText(" ")
				element:SetWidth(1)
				element:Hide()
			end
		end
		if RUF.db.global.TestMode == true then
			if factionGroup == "Horde" then
				element:Show()
				element:SetText(elementStringHorde)
				element:SetWidth(element:GetStringWidth() + 2)
				element:SetTextColor(1, 0.00, 0.10)
			elseif factionGroup == "Alliance" then
				element:Show()
				element:SetText(elementStringAlliance)
				element:SetWidth(element:GetStringWidth() + 2)
				element:SetTextColor(0, 0.62, 1)
			end
			element:Show()
		end
	else
		self:DisableElement("PvPCombatIndicator")
		element:Hide()
	end

	if (element.PostUpdate) then
		return element:PostUpdate()
	end
end

local function Path(self, ...)
	return (self.PvPCombatIndicator.Override or Update)(self, ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, "ForceUpdate", element.__owner.unit)
end

local function Enable(self)
	local element = self.PvPCombatIndicator
	if (element) then
		element.__owner = self
		element.ForceUpdate = ForceUpdate
		self:RegisterEvent("UNIT_FACTION", Path)

		local profileReference = RUF.db.profile.unit[self.frame].Frame.Indicators[elementName]
		element:SetFont([[Interface\AddOns\RUF\Media\RUF.ttf]], profileReference.Size, "OUTLINE")
		element:SetText(" ")
		element:SetJustifyH("CENTER")
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
	local element = self.PvPCombatIndicator
	if (element) then
		element:Hide()

		self:UnregisterEvent("UNIT_FACTION", Path)
	end
end

oUF:AddElement("PvPCombatIndicator", Path, Enable, Disable)

function RUF.Indicators.PvPCombat(self, unit)
	if unit == "boss" then return end

	local element = self.Indicators:CreateFontString(self:GetName() .. ".PvPCombatIndicator", "OVERLAY")
	element:SetPoint(
		RUF.db.profile.unit[unit].Frame.Indicators[elementName].Position.AnchorFrom,
		RUF.GetIndicatorAnchorFrame(self, unit, elementName),
		RUF.db.profile.unit[unit].Frame.Indicators[elementName].Position.AnchorTo,
		RUF.db.profile.unit[unit].Frame.Indicators[elementName].Position.x,
		RUF.db.profile.unit[unit].Frame.Indicators[elementName].Position.y
	)

	element:SetFont([[Interface\AddOns\RUF\Media\RUF.ttf]], RUF.db.profile.unit[unit].Frame.Indicators[elementName].Size, "OUTLINE")

	self.PvPCombatIndicator = element
end