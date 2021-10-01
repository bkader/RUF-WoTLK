assert(RUF, "RUF not found!")
local RUF = RUF
local LSM = LibStub('LibSharedMedia-3.0')
local _, ns = ...
local oUF = ns.oUF
local elementName = 'Objective'
local elementString = RUF.IndicatorGlyphs['Objective']

local function UnitIsQuestBoss(unit) return false end

local function Update(self, event, unit)
	if(unit ~= self.unit) then return end
	local element = self.ObjectiveIndicator
	element.Enabled = RUF.db.profile.unit[self.frame].Frame.Indicators[elementName].Enabled

	if(element.PreUpdate) then
		element:PreUpdate()
	end
	if element.Enabled == true then
		self:EnableElement(elementName..'Indicator')
		local isQuestBoss = UnitIsQuestBoss(unit)
		if element:IsObjectType('FontString') then
			if(isQuestBoss) then
				element:SetText(elementString)
				element:SetWidth(element:GetStringWidth()+2)
				element:Show()
			else
				element:SetText(' ')
				element:SetWidth(1)
				element:Hide()
			end
		else
			if(isQuestBoss) then
				element:Show()
			else
				element:Hide()
			end
		end
		if RUF.db.global.TestMode == true then
			if element:IsObjectType('Texture') then
				element:Show()
			elseif element:IsObjectType('FontString') then
				element:SetText(elementString)
				element:SetWidth(element:GetStringWidth()+2)
				element:Show()
			end
		end
	else
		self:DisableElement('ObjectiveIndicator')
		element:Hide()
	end

	if(element.PostUpdate) then
		return element:PostUpdate()
	end
end

local function Path(self, ...)
	return (self.ObjectiveIndicator.Override or Update) (self, ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, 'ForceUpdate', element.__owner.unit)
end

local function Enable(self)
	local element = self.ObjectiveIndicator
	if(element) then
		element.__owner = self
		element.ForceUpdate = ForceUpdate
		self:RegisterEvent('UNIT_CLASSIFICATION_CHANGED', Path)

		local profileReference = RUF.db.profile.unit[self.frame].Frame.Indicators[elementName]
		element:SetFont([[Interface\Addons\RUF\Media\RUF.ttf]], profileReference.Size, 'OUTLINE')
		element:SetText(' ')
		element:SetJustifyH('CENTER')
		element:SetTextColor(1,190/255,25/255)
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
	local element = self.ObjectiveIndicator
	if(element) then
		element:Hide()

		self:UnregisterEvent('UNIT_CLASSIFICATION_CHANGED', Path)
	end
end

oUF:AddElement('ObjectiveIndicator', Path, Enable, Disable)


function RUF.Indicators.Objective(self, unit)
	if unit == 'player' or unit == 'pet' or unit == 'party' or unit == 'partypet' or unit == 'arena' then return end

	local element = self.Indicators:CreateFontString(self:GetName()..'.ObjectiveIndicator', 'OVERLAY')
	element:SetPoint(
		RUF.db.profile.unit[unit].Frame.Indicators[elementName].Position.AnchorFrom,
		RUF.GetIndicatorAnchorFrame(self,unit,elementName),
		RUF.db.profile.unit[unit].Frame.Indicators[elementName].Position.AnchorTo,
		RUF.db.profile.unit[unit].Frame.Indicators[elementName].Position.x,
		RUF.db.profile.unit[unit].Frame.Indicators[elementName].Position.y
	)

	element:SetFont([[Interface\Addons\RUF\Media\RUF.ttf]], RUF.db.profile.unit[unit].Frame.Indicators[elementName].Size, 'OUTLINE')

	self.ObjectiveIndicator = element
end