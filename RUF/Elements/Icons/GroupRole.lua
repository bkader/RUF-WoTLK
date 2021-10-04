assert(RUF, "RUF not found!")
local RUF = RUF
local _, ns = ...
local oUF = ns.oUF

local elementName = 'Role'
local elementStringDAMAGER = RUF.IndicatorGlyphs['Role-DPS']
local elementStringHEALER = RUF.IndicatorGlyphs['Role-Heal']
local elementStringTANK = RUF.IndicatorGlyphs['Role-Tank']

local function Update(self, event)
	local element = self.RoleIndicator
	element.Enabled = RUF.db.profile.unit[self.frame].Frame.Indicators[elementName].Enabled

	if(element.PreUpdate) then
		element:PreUpdate()
	end

	if element.Enabled == true then
		self:EnableElement(elementName..'Indicator')
		local role = UnitGroupRolesAssigned(self.unit)
		if role == 'TANK' then
			element:SetText(elementStringTANK)
			element:SetWidth(element:GetStringWidth()+2)
			element:SetTextColor(115/255,142/255,153/255)
			element:Show()
		elseif role == 'HEALER' then
			element:SetText(elementStringHEALER)
			element:SetWidth(element:GetStringWidth()+2)
			element:SetTextColor(38/255,190/255,65/255)
			element:Show()
		elseif role == 'DAMAGER' then
			element:SetText(elementStringDAMAGER)
			element:SetWidth(element:GetStringWidth()+2)
			element:SetTextColor(207/255,55/255,77/255)
			element:Show()
		else
			element:SetText(' ')
			element:SetWidth(1)
			element:Hide()
		end
		if RUF.db.global.TestMode == true then
			element:SetText(elementStringHEALER)
			element:SetWidth(element:GetStringWidth()+2)
			element:SetTextColor(38/255,190/255,65/255)
			element:Show()
		end
	else
		self:DisableElement('RoleIndicator')
		element:Hide()
	end

	if(element.PostUpdate) then
		return element:PostUpdate()
	end
end

local function Path(self, ...)
	return (self.RoleIndicator.Override or Update) (self, ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, 'ForceUpdate')
end

local function Enable(self)
	local element = self.RoleIndicator
	if(element) then
		element.__owner = self
		element.ForceUpdate = ForceUpdate
		if(self.unit == 'player') then
			self:RegisterEvent('PLAYER_ROLES_ASSIGNED', Path, true)
		else
			self:RegisterEvent('PARTY_MEMBERS_CHANGED', Path, true)
			self:RegisterEvent('RAID_ROSTER_UPDATE', Path, true)
		end

		local profileReference = RUF.db.profile.unit[self.frame].Frame.Indicators[elementName]
		element:SetFont([[Interface\Addons\RUF\Media\RUF.ttf]], profileReference.Size, 'OUTLINE')
		element:SetText(' ')
		element:SetJustifyH('CENTER')
		element:ClearAllPoints()
		element:SetPoint(
			profileReference.Position.AnchorFrom,
			RUF.GetIndicatorAnchorFrame(self,self.frame,elementName),
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
	if(element) then
		element:Hide()

		self:UnregisterEvent('PLAYER_ROLES_ASSIGNED', Path)
		self:UnregisterEvent('PARTY_MEMBERS_CHANGED', Path)
		self:UnregisterEvent('RAID_ROSTER_UPDATE', Path)
	end
end

oUF:AddElement('RoleIndicator', Path, Enable, Disable)

function RUF.Indicators.Role(self, unit)
	if unit == 'boss' or unit == 'partypet' or unit == 'pet' then return end

	local element = self.Indicators:CreateFontString(self:GetName()..'.RoleIndicator', 'OVERLAY')
	element:SetPoint(
		RUF.db.profile.unit[unit].Frame.Indicators[elementName].Position.AnchorFrom,
		RUF.GetIndicatorAnchorFrame(self,unit,elementName),
		RUF.db.profile.unit[unit].Frame.Indicators[elementName].Position.AnchorTo,
		RUF.db.profile.unit[unit].Frame.Indicators[elementName].Position.x,
		RUF.db.profile.unit[unit].Frame.Indicators[elementName].Position.y
	)

	element:SetFont([[Interface\Addons\RUF\Media\RUF.ttf]], RUF.db.profile.unit[unit].Frame.Indicators[elementName].Size, 'OUTLINE')

	self.RoleIndicator = element
end