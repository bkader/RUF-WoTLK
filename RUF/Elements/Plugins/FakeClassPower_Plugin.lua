local _, ns = ...
local oUF = ns.oUF

local _, PlayerClass = UnitClass('player')

local ClassPowerID, ClassPowerType
local FakeClassPowerEnable, FakeClassPowerDisable
local RequireSpec, RequirePower
local RequireSpell = false

local function UpdateColor(element, powerType)
	local color = element.__owner.colors.power[powerType]
	local r, g, b = color[1], color[2], color[3]
	element:SetStatusBarColor(r, g, b)
end

local function Update(self, event, unit, powerType)
	if(not (unit and (UnitIsUnit(unit, 'player') and powerType == ClassPowerType))) then
		return
	end


	local element = self.FakeClassPower
	if(element.PreUpdate) then
		element:PreUpdate()
	end

	local cur, max = UnitPower(unit,ClassPowerID), UnitPowerMax(unit,ClassPowerID)

	element:SetMinMaxValues(0, max)
	element:SetValue(cur)

	if(element.PostUpdate) then
		return element:PostUpdate(cur, max, false, powerType)
	end
end

local function Path(self, ...)
	return (self.FakeClassPower.Override or Update) (self, ...)
end

local function Visibility(self, event, unit)
	local element = self.FakeClassPower
	local shouldEnable

	if(UnitHasVehicleUI('player')) then
		shouldEnable = PlayerVehicleHasComboPoints()
		unit = 'vehicle'
	elseif(ClassPowerID) then
		if(not RequireSpec or RequireSpec == GetSpecialization()) then
			-- use 'player' instead of unit because 'SPELLS_CHANGED' is a unitless event
			if(not RequirePower or RequirePower == UnitPowerType('player')) then
				if(not RequireSpell or IsPlayerSpell(RequireSpell)) then
					self:UnregisterEvent('SPELLS_CHANGED', Visibility)
					shouldEnable = true
					unit = 'player'
				else
					self:RegisterEvent('SPELLS_CHANGED', Visibility, true)
				end
			end
		end
	end

	local isEnabled = element.isEnabled
	local powerType = ClassPowerType

	if(shouldEnable) then
		(element.UpdateColor or UpdateColor) (element, powerType)
	end

	if(shouldEnable and not isEnabled) then
		FakeClassPowerEnable(self)
	elseif(not shouldEnable and (isEnabled or isEnabled == nil)) then
		FakeClassPowerDisable(self)
	elseif(shouldEnable and isEnabled) then
		Path(self, event, unit, powerType)
	end
end

local function VisibilityPath(self, ...)
	return (self.FakeClassPower.OverrideVisibility or Visibility) (self, ...)
end

local function ForceUpdate(element)
	return VisibilityPath(element.__owner, 'ForceUpdate', element.__owner.unit)
end

do
	function FakeClassPowerEnable(self)
		self:RegisterEvent('UNIT_MAXPOWER', Path)

		self.FakeClassPower.isEnabled = true
		local element = self.FakeClassPower
		element:Show()

		Path(self, 'FakeClassPowerEnable', 'player', ClassPowerType)
	end

	function FakeClassPowerDisable(self)
		self:UnregisterEvent('UNIT_MAXPOWER', Path)

		local element = self.FakeClassPower
		element:Hide()

		self.FakeClassPower.isEnabled = false
		Path(self, 'FakeClassPowerDisable', 'player', ClassPowerType)
	end

	if(PlayerClass == 'DRUID') then
		ClassPowerID = 8
		ClassPowerType = 'LUNAR_POWER'
		RequirePower = Enum.PowerType.LunarPower
	elseif(PlayerClass == 'PRIEST') then
		ClassPowerID = 13
		ClassPowerType = 'INSANITY'
		RequireSpec = 3
	elseif(PlayerClass == 'SHAMAN') then
		ClassPowerID = 11
		ClassPowerType = 'MAELSTROM'
		RequirePower = Enum.PowerType.Maelstrom
	end
end

local function SetFrequentUpdates(element, state)
	if(element.frequentUpdates ~= state) then
		element.frequentUpdates = state
		if(element.frequentUpdates) then
			element.__owner:UnregisterEvent('UNIT_POWER_UPDATE', Path)
			element.__owner:RegisterEvent('UNIT_POWER_FREQUENT', Path)
		else
			element.__owner:UnregisterEvent('UNIT_POWER_FREQUENT', Path)
			element.__owner:RegisterEvent('UNIT_POWER_UPDATE', Path)
		end
	end
end

local function Enable(self, unit)
	local element = self.FakeClassPower
	if(element and UnitIsUnit(unit, 'player')) then
		element.__owner = self
		element.ForceUpdate = ForceUpdate
		element.SetFrequentUpdates = SetFrequentUpdates

		if(element.frequentUpdates) then
			self:RegisterEvent('UNIT_POWER_FREQUENT', Path)
		else
			self:RegisterEvent('UNIT_POWER_UPDATE', Path)
		end

		if(RequireSpec) then
			self:RegisterEvent('PLAYER_TALENT_UPDATE', VisibilityPath, true)
		end

		if(RequirePower) then
			self:RegisterEvent('UNIT_DISPLAYPOWER', VisibilityPath)
		end

		element.FakeClassPowerEnable = FakeClassPowerEnable
		element.FakeClassPowerDisable = FakeClassPowerDisable

		if(element:IsObjectType('StatusBar')) then
			element.texture = element:GetStatusBarTexture() and element:GetStatusBarTexture():GetTexture() or [[Interface\TargetingFrame\UI-StatusBar]]
			element:SetStatusBarTexture(element.texture)
		end

		if(not element.UpdateColor) then
			element.UpdateColor = UpdateColor
		end

		element:Show()
		return true
	end
end

local function Disable(self)
	if(self.FakeClassPower) then
		FakeClassPowerDisable(self)

		self:UnregisterEvent('PLAYER_TALENT_UPDATE', VisibilityPath)
		self:UnregisterEvent('UNIT_DISPLAYPOWER', VisibilityPath)
		self:UnregisterEvent('SPELLS_CHANGED', Visibility)
		self:UnregisterEvent('UNIT_POWER_FREQUENT', Path)
		self:UnregisterEvent('UNIT_POWER_UPDATE', Path)

	end
end

oUF:AddElement('FakeClassPower', VisibilityPath, Enable, Disable)
