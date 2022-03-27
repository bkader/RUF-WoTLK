local RUF = RUF
local _, ns = ...
local oUF = ns.oUF

local UnitAffectingCombat = UnitAffectingCombat

local elementName = "InCombat"
local elementString = RUF.IndicatorGlyphs["InCombat"]

local function Update(self, event)
	local element = self.InCombatIndicator
	element.Enabled = RUF.db.profile.unit[self.frame].Frame.Indicators[elementName].Enabled

	if (element.PreUpdate) then
		element:PreUpdate()
	end

	if element.Enabled == true then
		self:EnableElement(elementName .. "Indicator")
		local inCombat = UnitAffectingCombat(self.unit)
		if (inCombat) then
			element:SetText(elementString)
			element:SetWidth(element:GetStringWidth() + 2)
			element:Show()
		else
			element:SetText(" ")
			element:SetWidth(1)
			element:Hide()
		end
		if RUF.db.global.TestMode == true then
			if element:IsObjectType("Texture") then
				element:Show()
			elseif element:IsObjectType("FontString") then
				element:SetText(elementString)
				element:SetWidth(element:GetStringWidth() + 2)
				element:Show()
			end
		end
	else
		self:DisableElement("InCombatIndicator")
		element:Hide()
	end

	if (element.PostUpdate) then
		return element:PostUpdate()
	end
end

local function Path(self, ...)
	return (self.InCombatIndicator.Override or Update)(self, ...)
end

local function ForceUpdate(element)
	if (not element.__owner.unit) then return end
	return Path(element.__owner, "ForceUpdate")
end

local function Enable(self, unit)
	local element = self.InCombatIndicator
	if (element and unit == "player") then
		element.__owner = self
		element.ForceUpdate = ForceUpdate
		self:RegisterEvent("PLAYER_REGEN_DISABLED", Path, true)
		self:RegisterEvent("PLAYER_REGEN_ENABLED", Path, true)

		local profileReference = RUF.db.profile.unit[self.frame].Frame.Indicators[elementName]
		element:SetFont([[Interface\AddOns\RUF\Media\RUF.ttf]], profileReference.Size, "OUTLINE")
		element:SetText(" ")
		element:SetJustifyH("CENTER")
		element:SetTextColor(0.765, 0.820, 0.898) -- Blue Silver
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
	local element = self.InCombatIndicator
	if (element) then
		element:Hide()

		self:UnregisterEvent("PLAYER_REGEN_DISABLED", Path)
		self:UnregisterEvent("PLAYER_REGEN_ENABLED", Path)
	end
end

oUF:AddElement("InCombatIndicator", Path, Enable, Disable)

function RUF.Indicators.InCombat(self, unit)
	if unit ~= "player" then return end

	local element = self.Indicators:CreateFontString(self:GetName() .. ".InCombatIndicator", "OVERLAY")
	element:SetPoint(
		RUF.db.profile.unit[unit].Frame.Indicators[elementName].Position.AnchorFrom,
		RUF.GetIndicatorAnchorFrame(self, unit, elementName),
		RUF.db.profile.unit[unit].Frame.Indicators[elementName].Position.AnchorTo,
		RUF.db.profile.unit[unit].Frame.Indicators[elementName].Position.x,
		RUF.db.profile.unit[unit].Frame.Indicators[elementName].Position.y
	)

	element:SetFont([[Interface\AddOns\RUF\Media\RUF.ttf]], RUF.db.profile.unit[unit].Frame.Indicators[elementName].Size, "OUTLINE")

	self.InCombatIndicator = element
end