local _, ns = ...
local oUF = ns.oUF
local SA = LibStub("SpecializedAbsorbs-1.0")

local UnitGUID = UnitGUID

local UnitGetTotalAbsorbs = function(unit)
	return (SA and unit) and SA.UnitTotal(UnitGUID(unit)) or 0
end

local function UNIT_ABSORB_AMOUNT_CHANGED(self, event, guid, absorb)
	if not (self.unit and guid and UnitGUID(self.unit) == guid) then return end

	local element = self.Absorb

	if element.PreUpdate then
		element:PreUpdate(self.unit)
	end

	local maxHealth = UnitHealthMax(self.unit)

	element:SetMinMaxValues(0, maxHealth)
	element:SetValue(absorb or 0)
	element:Show()

	if element.PostUpdate then
		return element:PostUpdate(self.unit, absorb or 0)
	end
end

local function Update(self, event, unit)
	if self.unit ~= unit then return end

	local element = self.Absorb

	if element.PreUpdate then
		element:PreUpdate(unit)
	end

	local absorb = UnitGetTotalAbsorbs(unit) or 0
	local health, maxHealth = UnitHealth(unit), UnitHealthMax(unit)

	element:SetMinMaxValues(0, maxHealth)
	element:SetValue(absorb)
	element:Show()

	if element.PostUpdate then
		return element:PostUpdate(unit, absorb)
	end
end

local function Path(self, ...)
	return (self.Absorb.Override or Update)(self, ...)
end

local function ForceUpdate(element)
	if (not element.__owner.unit) then return end
	return Path(element.__owner, "ForceUpdate", element.__owner.unit)
end

local function Enable(self)
	local element = self.Absorb
	if (element) then
		element.__owner = self
		element.ForceUpdate = ForceUpdate

		self:RegisterEvent("UNIT_HEALTH", Path)
		self:RegisterEvent("UNIT_MAXHEALTH", Path)
		self.UNIT_ABSORB_AMOUNT_CHANGED = UNIT_ABSORB_AMOUNT_CHANGED
		SA.RegisterUnitCallbacks(self, "UNIT_ABSORB_AMOUNT_CHANGED")

		if (element:IsObjectType("StatusBar")) then
			element.texture =
				element:GetStatusBarTexture() and element:GetStatusBarTexture():GetTexture() or
				[[Interface\TargetingFrame\UI-StatusBar]]
			element:SetStatusBarTexture(element.texture)
		end

		element:Show()
		return true
	end
end

local function Disable(self)
	local element = self.Absorb
	if element then
		element:Hide()

		self:UnregisterEvent("UNIT_HEALTH", Path)
		self:UnregisterEvent("UNIT_MAXHEALTH", Path)
		self.UNIT_ABSORB_AMOUNT_CHANGED = nil
		SA.UnregisterAllCallbacks(self)
	end
end

oUF:AddElement("Absorb", Path, Enable, Disable)