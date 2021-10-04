local RUF = RUF or LibStub("AceAddon-3.0"):GetAddon("RUF")
local _, ns = ...
local oUF = ns.oUF

local elementName = 'TargetMark'

local stringIconCircle = RUF.IndicatorGlyphs['Target-Circle']
local stringIconCross = RUF.IndicatorGlyphs['Target-Cross']
local stringIconDiamond = RUF.IndicatorGlyphs['Target-Diamond']
local stringIconMoon = RUF.IndicatorGlyphs['Target-Moon']
local stringIconSkull = RUF.IndicatorGlyphs['Target-Skull']
local stringIconSquare = RUF.IndicatorGlyphs['Target-Square']
local stringIconStar = RUF.IndicatorGlyphs['Target-Star']
local stringIconTriangle = RUF.IndicatorGlyphs['Target-Triangle']

local GetRaidTargetIndex = GetRaidTargetIndex
local SetRaidTargetIconTexture = SetRaidTargetIconTexture

local function Update(self, event)
	local element = self.TargetMarkIndicator
	element.Enabled = RUF.db.profile.unit[self.frame].Frame.Indicators[elementName].Enabled

	if(element.PreUpdate) then
		element:PreUpdate()
	end
	if element.Enabled == true then
		self:EnableElement(elementName..'Indicator')
		local index = GetRaidTargetIndex(self.unit)
		if(index) then
			element:Show()
			if index == 1 then -- Star
				element:SetText(stringIconStar)
				element:SetWidth(element:GetStringWidth()+2)
				element:SetTextColor(1,0.92,0.00)
			elseif index == 2 then -- Circle
				element:SetText(stringIconCircle)
				element:SetWidth(element:GetStringWidth()+2)
				element:SetTextColor(1,0.61,0.00)
			elseif index == 3 then -- Diamond
				element:SetText(stringIconDiamond)
				element:SetWidth(element:GetStringWidth()+2)
				element:SetTextColor(0.94,0.00,1.00)
			elseif index == 4 then -- Triangle
				element:SetText(stringIconTriangle)
				element:SetWidth(element:GetStringWidth()+2)
				element:SetTextColor(0.18,0.81,0.00)
			elseif index == 5 then -- Moon
				element:SetText(stringIconMoon)
				element:SetWidth(element:GetStringWidth()+2)
				element:SetTextColor(0.64,0.85,1.00)
			elseif index == 6 then -- Square
				element:SetText(stringIconSquare)
				element:SetWidth(element:GetStringWidth()+2)
				element:SetTextColor(0.24,0.71,1.00)
			elseif index == 7 then -- Cross
				element:SetText(stringIconCross)
				element:SetWidth(element:GetStringWidth()+2)
				element:SetTextColor(1,0.20,0.20)
			elseif index == 8 then -- Skull
				element:SetText(stringIconSkull)
				element:SetWidth(element:GetStringWidth()+2)
				element:SetTextColor(1,0.99,0.90)
			else
				element:SetText(" ")
				element:SetWidth(1)
				element:Hide()
			end
		else
			element:SetText(" ")
			element:SetWidth(1)
			element:Hide()
		end

		if RUF.db.global.TestMode == true then
			element:SetText(stringIconStar) -- Star
			element:SetTextColor(1,0.92,0.00)
			element:SetWidth(element:GetStringWidth()+2)
			element:Show()
		end
	else
		self:DisableElement('TargetMarkIndicator')
		element:Hide()
	end

	if(element.PostUpdate) then
		return element:PostUpdate()
	end
end

local function Path(self, ...)
	return (self.TargetMarkIndicator.Override or Update) (self, ...)
end

local function ForceUpdate(element)
	if(not element.__owner.unit) then return end
	return Path(element.__owner, 'ForceUpdate')
end

local function Enable(self)
	local element = self.TargetMarkIndicator
	if(element) then
		element.__owner = self
		element.ForceUpdate = ForceUpdate
		self:RegisterEvent('RAID_TARGET_UPDATE', Path, true)

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
	local element = self.TargetMarkIndicator
	if(element) then
		element:Hide()

		self:UnregisterEvent('RAID_TARGET_UPDATE', Path)
	end
end

oUF:AddElement('TargetMarkIndicator', Path, Enable, Disable)


function RUF.Indicators.TargetMark(self, unit)
	local element = self.Indicators:CreateFontString(self:GetName()..".TargetMarkIndicator", "OVERLAY")
	element:SetPoint(
		RUF.db.profile.unit[unit].Frame.Indicators[elementName].Position.AnchorFrom,
		RUF.GetIndicatorAnchorFrame(self,unit,elementName),
		RUF.db.profile.unit[unit].Frame.Indicators[elementName].Position.AnchorTo,
		RUF.db.profile.unit[unit].Frame.Indicators[elementName].Position.x,
		RUF.db.profile.unit[unit].Frame.Indicators[elementName].Position.y
	)

	element:SetFont([[Interface\Addons\RUF\Media\RUF.ttf]], RUF.db.profile.unit[unit].Frame.Indicators[elementName].Size, "OUTLINE")

	self.TargetMarkIndicator = element
end