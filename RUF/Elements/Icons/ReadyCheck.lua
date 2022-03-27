local RUF = RUF
local _, ns = ...
local oUF = ns.oUF

local UnitExists = UnitExists
local GetReadyCheckStatus = GetReadyCheckStatus

local elementName = "Ready"
local elementStringNo = RUF.IndicatorGlyphs["Ready-No"]
local elementStringMaybe = RUF.IndicatorGlyphs["Ready-Question"]
local elementStringYes = RUF.IndicatorGlyphs["Ready-Yes"]

local function OnFinished(self)
	local element = self:GetParent()
	element:Hide()

	if (element.PostUpdateFadeOut) then
		element:PostUpdateFadeOut()
	end
end

local function Update(self, event)
	local element = self.ReadyIndicator
	element.Enabled = RUF.db.profile.unit[self.frame].Frame.Indicators[elementName].Enabled

	if (element.PreUpdate) then
		element:PreUpdate()
	end

	if element.Enabled == true then
		self:EnableElement(elementName .. "Indicator")
		local status = GetReadyCheckStatus(self.unit)
		if UnitExists(self.unit) and status then
			if (status == "ready") then
				element:SetText(elementStringYes)
				element:SetWidth(element:GetStringWidth() + 2)
				element:SetTextColor(0.180, 1.000, 0)
			elseif (status == "notready") then
				element:SetText(elementStringNo)
				element:SetWidth(element:GetStringWidth() + 2)
				element:SetTextColor(1, 0, 0.216)
			else
				element:SetText(elementStringMaybe)
				element:SetWidth(element:GetStringWidth() + 2)
				element:SetTextColor(1, 0.847, 0)
			end
			element.status = status
			element:Show()
		elseif event ~= "READY_CHECK_FINISHED" then
			element.status = nil
			element:SetText(" ")
			element:SetWidth(1)
			element:Hide()
		end
		if event == "READY_CHECK_FINISHED" then
			if element.status == "waiting" then
				element:SetText(elementStringNo)
				element:SetWidth(element:GetStringWidth() + 2)
				element:SetTextColor(1, 0, 0.216)
			end
		end
		if RUF.db.global.TestMode == true then
			element:SetText(elementStringYes)
			element:SetWidth(element:GetStringWidth() + 2)
			element:SetTextColor(0.180, 1.000, 0)
			element:Show()
		end
	else
		self:DisableElement("ReadyIndicator")
		element:Hide()
	end

	if (element.PostUpdate) then
		return element:PostUpdate()
	end
end

local function Path(self, ...)
	return (self.ReadyIndicator.Override or Update)(self, ...)
end

local function ForceUpdate(element)
	if (not element.__owner.unit) then return end
	return Path(element.__owner, "ForceUpdate")
end

local function Enable(self, unit)
	local element = self.ReadyIndicator
	if (element) then
		element.__owner = self
		element.ForceUpdate = ForceUpdate

		self:RegisterEvent("READY_CHECK", Path, true)
		self:RegisterEvent("READY_CHECK_CONFIRM", Path, true)
		self:RegisterEvent("READY_CHECK_FINISHED", Path, true)

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
	local element = self.ReadyIndicator
	if (element) then
		element:Hide()

		self:UnregisterEvent("READY_CHECK", Path)
		self:UnregisterEvent("READY_CHECK_CONFIRM", Path)
		self:UnregisterEvent("READY_CHECK_FINISHED", Path)
	end
end

oUF:AddElement("ReadyIndicator", Path, Enable, Disable)

function RUF.Indicators.Ready(self, unit)
	if unit == "pet" or unit == "partypet" or unit == "boss" or unit == "arena" then return end

	local element = self.Indicators:CreateFontString(self:GetName() .. ".ReadyIndicator", "OVERLAY")
	element:SetPoint(
		RUF.db.profile.unit[unit].Frame.Indicators[elementName].Position.AnchorFrom,
		RUF.GetIndicatorAnchorFrame(self, unit, elementName),
		RUF.db.profile.unit[unit].Frame.Indicators[elementName].Position.AnchorTo,
		RUF.db.profile.unit[unit].Frame.Indicators[elementName].Position.x,
		RUF.db.profile.unit[unit].Frame.Indicators[elementName].Position.y
	)

	element:SetFont([[Interface\AddOns\RUF\Media\RUF.ttf]], RUF.db.profile.unit[unit].Frame.Indicators[elementName].Size, "OUTLINE")

	self.ReadyIndicator = element
end