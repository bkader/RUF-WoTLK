assert(RUF, "RUF not found!")
local RUF = RUF
local _, ns = ...
local oUF = ns.oUF

local GetPetHappiness = GetPetHappiness

local elementName = "PetHappiness"
local elementString1 = RUF.IndicatorGlyphs["PetHappiness1"]
local elementString2 = RUF.IndicatorGlyphs["PetHappiness2"]
local elementString3 = RUF.IndicatorGlyphs["PetHappiness3"]
local elementStringAlternative = RUF.IndicatorGlyphs["PetHappiness-Alternative"]

local function Update(self, event)
	local element = self.PetHappinessIndicator
	element.Enabled = RUF.db.profile.unit[self.frame].Frame.Indicators[elementName].Enabled

	if (element.PreUpdate) then
		element:PreUpdate()
	end

	if element.Enabled == true then
		self:EnableElement(elementName .. "Indicator")
		local happiness = GetPetHappiness()
		if happiness then
			if happiness == 1 then
				element:SetText(elementString1)
				element:SetTextColor(0.851, 0.314, 0.086)
			elseif happiness == 2 then
				element:SetText(elementString2)
				element:SetTextColor(1, 0.745, 0.098)
			elseif happiness == 3 then
				element:SetText(elementString3)
				element:SetTextColor(0.086, 0.851, 0.251)
			end
			element:SetWidth(element:GetStringWidth() + 2)
			element:Show()
		else
			element:SetText(" ")
			element:SetWidth(1)
			element:Hide()
		end
		if RUF.db.global.TestMode == true then
			element:SetText(elementString2)
			element:SetWidth(element:GetStringWidth() + 2)
			element:Show()
		end
	else
		self:DisableElement("PetHappinessIndicator")
		element:Hide()
	end

	if (element.PostUpdate) then
		return element:PostUpdate()
	end
end

local function Path(self, ...)
	return (self.PetHappinessIndicator.Override or Update)(self, ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, "ForceUpdate")
end

local function Enable(self, unit)
	local element = self.PetHappinessIndicator
	if element and (self.frame == "player" or self.frame == "pet") then
		element.__owner = self
		element.ForceUpdate = ForceUpdate
		self:RegisterEvent("UNIT_HAPPINESS", Path, true)

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
	local element = self.PetHappinessIndicator
	if (element) then
		element:Hide()

		self:UnregisterEvent("UNIT_HAPPINESS", Path)
	end
end

oUF:AddElement("PetHappinessIndicator", Path, Enable, Disable)

function RUF.Indicators.PetHappiness(self, unit)
	if (unit == "player" or unit == "pet") then
		local element = self.Indicators:CreateFontString(self:GetName() .. ".PetHappinessIndicator", "OVERLAY")
		element:SetPoint(
			RUF.db.profile.unit[unit].Frame.Indicators[elementName].Position.AnchorFrom,
			RUF.GetIndicatorAnchorFrame(self, unit, elementName),
			RUF.db.profile.unit[unit].Frame.Indicators[elementName].Position.AnchorTo,
			RUF.db.profile.unit[unit].Frame.Indicators[elementName].Position.x,
			RUF.db.profile.unit[unit].Frame.Indicators[elementName].Position.y
		)

		element:SetFont([[Interface\AddOns\RUF\Media\RUF.ttf]], RUF.db.profile.unit[unit].Frame.Indicators[elementName].Size, "OUTLINE")

		self.PetHappinessIndicator = element
	end
end