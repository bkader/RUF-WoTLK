assert(RUF, "RUF not found!")
local RUF = RUF
local LSM = LibStub("LibSharedMedia-3.0")
local _, ns = ...
local oUF = ns.oUF

local GetSpecialization = RUF.GetSpecialization

do
	local TalenMonitor = CreateFrame("Frame")
	TalenMonitor:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	TalenMonitor:SetScript("OnEvent", function() RUF.Specialization = GetSpecialization() end)
end

local function UpdateTooltip(self)
	GameTooltip:SetUnitAura(self:GetParent().__owner.unit, self:GetID(), self.filter)
end

local function onEnter(self)
	if not self:IsVisible() then return end
	GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
	self:UpdateTooltip()
end

local function onLeave()
	GameTooltip:Hide()
end

function RUF.CreateAuraIcon(element, index)
	local elementName = element:GetName() or "RUFAuraIcon"
	local button = CreateFrame("Button", elementName .. "Button" .. index, element)
	button:RegisterForClicks("RightButtonUp")

	local icon = button:CreateTexture(nil, "BORDER")
	icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
	icon:SetAllPoints(button)

	local pixel = CreateFrame("Frame", nil, button)
	pixel:SetAllPoints(button)
	pixel:SetFrameLevel(17)
	pixel:SetBackdrop({
		edgeFile = LSM:Fetch("border", RUF.db.profile.Appearance.Aura.Pixel.Style.edgeFile),
		edgeSize = RUF.db.profile.Appearance.Aura.Pixel.Style.edgeSize
	})
	local pixelr, pixelg, pixelb, pixela = unpack(RUF.db.profile.Appearance.Colors.Aura.Pixel)
	pixel:SetBackdropBorderColor(pixelr, pixelg, pixelb, pixela)
	if RUF.db.profile.Appearance.Aura.Pixel.Enabled == true then
		pixel:Show()
	else
		pixel:Hide()
	end
	local PixelOffset = RUF.db.profile.Appearance.Aura.Pixel.Offset
	if PixelOffset == 0 then
		pixel:SetPoint("TOPLEFT", button, "TOPLEFT", 0, 0)
		pixel:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 0, 0)
	elseif PixelOffset > 0 then
		pixel:SetPoint("TOPLEFT", button, "TOPLEFT", -PixelOffset, PixelOffset)
		pixel:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", PixelOffset, -PixelOffset)
	elseif PixelOffset < 0 then
		pixel:SetPoint("TOPLEFT", button, "TOPLEFT", -PixelOffset, PixelOffset)
		pixel:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", PixelOffset, -PixelOffset)
	end
	button.pixel = pixel

	local border = CreateFrame("Frame", nil, button)
	border:SetAllPoints(button)
	border:SetFrameLevel(18)
	border:SetBackdrop({
		edgeFile = LSM:Fetch("border", RUF.db.profile.Appearance.Aura.Border.Style.edgeFile),
		edgeSize = RUF.db.profile.Appearance.Aura.Border.Style.edgeSize
	})
	local borderr, borderg, borderb, bordera = unpack(RUF.db.profile.Appearance.Colors.Aura.DefaultBuff)
	border:SetBackdropBorderColor(borderr, borderg, borderb, bordera)

	local borderOffset = RUF.db.profile.Appearance.Aura.Border.Offset
	if borderOffset == 0 then
		border:SetPoint("TOPLEFT", button, "TOPLEFT", 0, 0)
		border:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 0, 0)
	else
		border:SetPoint("TOPLEFT", button, "TOPLEFT", -borderOffset, borderOffset)
		border:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", borderOffset, -borderOffset)
	end
	button.border = border

	if RUF.db.profile.Appearance.Aura.spiral.enabled then
		local cd = CreateFrame("Cooldown", "$parentCooldown", button, "CooldownFrameTemplate")
		cd:SetReverse(RUF.db.profile.Appearance.Aura.spiral.reverse)
		cd:SetAllPoints(button.border)
		button.cd = cd
	end

	local count = button:CreateFontString(nil, "OVERLAY", "NumberFontNormal")
	count:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -1, 0)

	local stealable = button:CreateTexture(nil, "OVERLAY")
	stealable:SetTexture([[Interface\TargetingFrame\UI-TargetingFrame-Stealable]])
	stealable:SetPoint("TOPLEFT", -3, 3)
	stealable:SetPoint("BOTTOMRIGHT", 3, -3)
	stealable:SetBlendMode("ADD")
	button.stealable = stealable

	button.UpdateTooltip = UpdateTooltip
	button:SetScript("OnEnter", onEnter)
	button:SetScript("OnLeave", onLeave)

	button.icon = icon
	button.count = count

	if element.PostCreateIcon then
		element:PostCreateIcon(button)
	end

	return button
end