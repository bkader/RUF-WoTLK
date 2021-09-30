local _, ns = ...
local oUF = ns.oUF
local LSA = LibStub("SpecializedAbsorbs-1.0", true)

local UnitGetTotalAbsorbs = function(unit)
	return LSA and LSA.UnitTotal(UnitGUID(unit)) or 0
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
	return Path(element.__owner, "ForceUpdate", element.__owner.unit)
end

local function Enable(self)
	local element = self.Absorb
	if (element) then
		element.__owner = self
		element.ForceUpdate = ForceUpdate

		self:RegisterEvent("UNIT_HEALTH", Path)
		self:RegisterEvent("UNIT_MAXHEALTH", Path)
		self:RegisterEvent("UNIT_ABSORB_AMOUNT_CHANGED", Path)
		self:RegisterEvent("UNIT_HEAL_ABSORB_AMOUNT_CHANGED", Path)

		if (element:IsObjectType("StatusBar")) then
			element.texture = element:GetStatusBarTexture() and element:GetStatusBarTexture():GetTexture() or [[Interface\TargetingFrame\UI-StatusBar]]
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
		self:UnregisterEvent("UNIT_ABSORB_AMOUNT_CHANGED", Path)
		self:UnregisterEvent("UNIT_HEAL_ABSORB_AMOUNT_CHANGED", Path)
	end
end

oUF:AddElement("Absorb", Path, Enable, Disable)