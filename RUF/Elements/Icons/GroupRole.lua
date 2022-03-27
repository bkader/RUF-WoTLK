local RUF = RUF
local _, ns = ...
local oUF = ns.oUF

local LGT = LibStub("LibGroupTalents-1.0")

local Compat = ns.Compat
local UnitGroupRolesAssigned = Compat.UnitGroupRolesAssigned
local C_Timer = Compat.C_Timer

local elementName = "Role"
local elementStringDAMAGER = RUF.IndicatorGlyphs["Role-DPS"]
local elementStringHEALER = RUF.IndicatorGlyphs["Role-Heal"]
local elementStringTANK = RUF.IndicatorGlyphs["Role-Tank"]

local function Update(self, event, unit, role)
	if (unit and unit ~= self.unit) then return end
	unit = unit or self.unit

	local element = self.RoleIndicator
	element.Enabled = RUF.db.profile.unit[self.frame].Frame.Indicators[elementName].Enabled

	if (element.PreUpdate) then
		element:PreUpdate()
	end

	if element.Enabled == true then
		self:EnableElement(elementName .. "Indicator")
		role = role or UnitGroupRolesAssigned(unit)
		if role == "TANK" then
			element:SetText(elementStringTANK)
			element:SetWidth(element:GetStringWidth() + 2)
			element:SetTextColor(0.451,0.557,0.600)
			element:Show()
		elseif role == "HEALER" then
			element:SetText(elementStringHEALER)
			element:SetWidth(element:GetStringWidth() + 2)
			element:SetTextColor(0.149,0.745,0.255)
			element:Show()
		elseif role == "DAMAGER" then
			element:SetText(elementStringDAMAGER)
			element:SetWidth(element:GetStringWidth() + 2)
			element:SetTextColor(0.812,0.216,0.302)
			element:Show()
		else
			element:SetText(" ")
			element:SetWidth(1)
			element:Hide()
		end
		if RUF.db.global.TestMode == true then
			element:SetText(elementStringHEALER)
			element:SetWidth(element:GetStringWidth() + 2)
			element:SetTextColor(0.149,0.745,0.255)
			element:Show()
		end
	else
		self:DisableElement("RoleIndicator")
		element:Hide()
	end

	if (element.PostUpdate) then
		return element:PostUpdate()
	end
end

local function Path(self, ...)
	return (self.RoleIndicator.Override or Update)(self, ...)
end

local function ForceUpdate(element)
	if (not element.__owner.unit) then return end
	return Path(element.__owner, "ForceUpdate")
end

local function UpdateLGT(self, event, _, unit)
	if (unit == self.unit) then
		C_Timer.After(0.25, function() Path(self, event, unit, UnitGroupRolesAssigned(unit)) end)
	end
end

local function Enable(self)
	local element = self.RoleIndicator
	if (element) then
		element.__owner = self
		element.ForceUpdate = ForceUpdate
		if (self.unit == "player") then
			self:RegisterEvent("PLAYER_ROLES_ASSIGNED", Path, true)
		else
			self:RegisterEvent("PARTY_MEMBERS_CHANGED", Path, true)
			self:RegisterEvent("RAID_ROSTER_UPDATE", Path, true)
		end

		self.UpdateLGT = UpdateLGT
		LGT.RegisterCallback(self, "LibGroupTalents_Update", "UpdateLGT")

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
	local element = self.RoleIndicator
	if (element) then
		element:Hide()

		self:UnregisterEvent("PLAYER_ROLES_ASSIGNED", Path)
		self:UnregisterEvent("PARTY_MEMBERS_CHANGED", Path)
		self:UnregisterEvent("RAID_ROSTER_UPDATE", Path)

		-- unregister LGT
		self.UpdateLGT = nil
		LGT.UnregisterAllCallbacks(self)
	end
end

oUF:AddElement("RoleIndicator", Path, Enable, Disable)

function RUF.Indicators.Role(self, unit)
	if unit == "boss" or unit == "partypet" or unit == "pet" then return end

	local element = self.Indicators:CreateFontString(self:GetName() .. ".RoleIndicator", "OVERLAY")
	element:SetPoint(
		RUF.db.profile.unit[unit].Frame.Indicators[elementName].Position.AnchorFrom,
		RUF.GetIndicatorAnchorFrame(self, unit, elementName),
		RUF.db.profile.unit[unit].Frame.Indicators[elementName].Position.AnchorTo,
		RUF.db.profile.unit[unit].Frame.Indicators[elementName].Position.x,
		RUF.db.profile.unit[unit].Frame.Indicators[elementName].Position.y
	)

	element:SetFont([[Interface\AddOns\RUF\Media\RUF.ttf]], RUF.db.profile.unit[unit].Frame.Indicators[elementName].Size, "OUTLINE")

	self.RoleIndicator = element
end