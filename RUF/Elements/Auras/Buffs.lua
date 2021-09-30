assert(RUF, "RUF not found!")
local RUF = RUF
local LSM = LibStub('LibSharedMedia-3.0')
local _, ns = ...
local oUF = ns.oUF
local _, PlayerClass

local IsInGroup, IsInRaid = RUF.IsInGroup, RUF.IsInRaid
local GetSpecialization = RUF.GetSpecialization

local BuffDispel = {-- PURGES
	['DEATHKNIGHT'] = {
		[1] = {'None'},
		[2] = {'None'},
		[3] = {'None'},
		[10] = {'None'},
	},
	['DEMONHUNTER'] = {
		[1] = {'Magic'},
		[2] = {'Magic'},
		[10] = {'None'},
	},
	['DRUID'] = {
		[1] = {'Enrage'},
		[2] = {'Enrage'},
		[3] = {'Enrage'},
		[4] = {'Enrage'},
		[10] = {'None'},
	},
	['HUNTER'] = {
		[1] = {'Enrage'},
		[2] = {'Enrage'},
		[3] = {'Enrage'},
		[10] = {'Enrage'},
	},
	['MAGE'] = {
		[1] = {'Magic'},
		[2] = {'Magic'},
		[3] = {'Magic'},
		[10] = {'None'},
	},
	['MONK'] = {
		[1] = {'None'},
		[2] = {'None'},
		[3] = {'None'},
		[10] = {'None'},
	},
	['PALADIN'] = {
		[1] = {'None'},
		[2] = {'None'},
		[3] = {'None'},
		[10] = {'None'},
	},
	['PRIEST'] = {
		[1] = {'Magic'},
		[2] = {'Magic'},
		[3] = {'Magic'},
		[10] = {'Magic'},
	},
	['ROGUE'] = {
		[1] = {'None'},
		[2] = {'None'},
		[3] = {'None'},
		[10] = {'None'},
	},
	['SHAMAN'] = {
		[1] = {'Magic'},
		[2] = {'Magic'},
		[3] = {'Magic'},
		[10] = {'Magic'},
	},
	['WARLOCK'] = {
		[1] = {'Magic'},
		[2] = {'Magic'},
		[3] = {'Magic'},
		[10] = {'Magic'},
	},
	['WARRIOR'] = {
		[1] = {'None'},
		[2] = {'None'},
		[3] = {'None'},
		[10] = {'None'},
	},
}

local function CustomBuffFilter(element, unit, button, ...)
	-- If the unit is in a vehicle etc.
	local frame = element:GetParent()
	if frame.realUnit then
		unit = frame.realUnit
	end

	-- If unit is party1, boss2, arena3 etc. we the group's profile.
	local profileUnit = string.gsub(frame.frame, '%d+', '')

	local name, icon, count, debuffType, duration, expirationTime, source, isStealable,
	nameplateShowPersonal, spellId, canApplyAura, isBossDebuff, nameplateShowAll, timeMod, value1, value2, value3 = ...

	local BuffTypes
	if UnitIsFriend('player', unit) then
		BuffTypes = 'None' -- Cannot dispel friendly buffs
	else
		BuffTypes = BuffDispel[PlayerClass][RUF.Specialization]
	end
	local removable = false
	if BuffTypes == 'None' then
		removable = false
	else
		for k, v in pairs(BuffTypes) do
			if v == debuffType then
				removable = true
			end
		end
	end
	if not source or source == nil then source = unit end
	local affiliation
	if source == 'player' then affiliation = 'player'
	elseif source == unit then affiliation = 'unit'
	elseif IsInGroup() and UnitPlayerOrPetInParty(source) then affiliation = 'group'
	elseif IsInRaid() and UnitInRaid(source) then affiliation = 'group'
	else affiliation = 'other'
	end

	if duration == 0 and RUF.db.profile.unit[profileUnit].Buffs.Icons.Filter.Time.Unlimited == false then
		-- Unlimited
		button.shoudShow = false
		return false
	elseif tonumber(duration) and duration < RUF.db.profile.unit[profileUnit].Buffs.Icons.Filter.Time.Min and RUF.db.profile.unit[profileUnit].Buffs.Icons.Filter.Time.Min > 0 then
		-- Shorter than Minimum duration.
		button.shoudShow = false
		return false
	elseif (tonumber(duration) or 0) > RUF.db.profile.unit[profileUnit].Buffs.Icons.Filter.Time.Max and RUF.db.profile.unit[profileUnit].Buffs.Icons.Filter.Time.Max > 0 then
		-- Longer than Max duration.
		button.shoudShow = false
		return false
	end

	if (RUF.db.profile.unit[profileUnit].Buffs.Icons.Filter.Dispellable == true and removable == true) or RUF.db.profile.unit[profileUnit].Buffs.Icons.Filter.Dispellable == false then
		if RUF.db.profile.unit[profileUnit].Buffs.Icons.Filter.Caster.Player == true then
			if affiliation == 'player' then
				button.shoudShow = true
				return true
			end
		end
		if RUF.db.profile.unit[profileUnit].Buffs.Icons.Filter.Caster.Unit == true then
			if affiliation == 'unit' then
				button.shoudShow = true
				return true
			end
		end
		if RUF.db.profile.unit[profileUnit].Buffs.Icons.Filter.Caster.Group == true then
			if affiliation == 'group' then
				button.shoudShow = true
				return true
			end
		end
		if RUF.db.profile.unit[profileUnit].Buffs.Icons.Filter.Caster.Other == true then
			if affiliation == 'other' then
				button.shoudShow = true
				return true
			end
		end
	else
		button.shoudShow = false
		return false
	end

	button.shoudShow = false
	return false
end

local function PostUpdateBuffIcon(self, unit, button, index, position, duration, expiration, debuffType, isStealable)
	if button.shoudShow and button.shoudShow == false then return end

	local BuffTypes
	if UnitIsFriend('player', unit) then
		BuffTypes = 'None' -- Cannot dispel friendly buffs
	else
		BuffTypes = BuffDispel[PlayerClass][RUF.Specialization]
	end
	local removable = false
	if BuffTypes == 'None' then
		removable = false
	else
		for k, v in pairs(BuffTypes) do
			if v == debuffType then
				removable = true
			end
		end
	end

	local r, g, b, a = unpack(RUF.db.profile.Appearance.Colors.Aura.DefaultBuff)
	if ((RUF.db.profile.Appearance.Aura.OnlyDispellable == true and removable == true) or RUF.db.profile.Appearance.Aura.OnlyDispellable == false) and debuffType then
		if RUF.db.profile.Appearance.Aura.Buff == true then
			r, g, b, a = unpack(RUF.db.profile.Appearance.Colors.Aura[debuffType])
		end
	end

	if self[position] then
		local icon = self[position].icon
		local profileReference = RUF.db.profile.unit[self.__owner.frame].Buffs.Icons
		local left, right, top, bottom = RUF:IconTextureTrim(true, profileReference.Width, profileReference.Height)
		icon:SetTexCoord(left, right, top, bottom)
		local border = self[position].border
		border:SetBackdrop({edgeFile = LSM:Fetch('border', RUF.db.profile.Appearance.Aura.Border.Style.edgeFile), edgeSize = RUF.db.profile.Appearance.Aura.Border.Style.edgeSize})
		border:SetBackdropBorderColor(r, g, b, a)
		local borderOffset = RUF.db.profile.Appearance.Aura.Border.Offset
		if borderOffset == 0 then
			border:SetPoint('TOPLEFT', button, 'TOPLEFT', 0, 0)
			border:SetPoint('BOTTOMRIGHT', button, 'BOTTOMRIGHT', 0, 0)
		else
			border:SetPoint('TOPLEFT', button, 'TOPLEFT', -borderOffset, borderOffset)
			border:SetPoint('BOTTOMRIGHT', button, 'BOTTOMRIGHT', borderOffset, -borderOffset)
		end
		local pixel = self[position].pixel
		pixel:SetBackdrop({edgeFile = LSM:Fetch('border', RUF.db.profile.Appearance.Aura.Pixel.Style.edgeFile), edgeSize = RUF.db.profile.Appearance.Aura.Pixel.Style.edgeSize})
		local pixelr, pixelg, pixelb, pixela = unpack(RUF.db.profile.Appearance.Colors.Aura.Pixel)
		pixel:SetBackdropBorderColor(pixelr, pixelg, pixelb, pixela)
		if RUF.db.profile.Appearance.Aura.Pixel.Enabled == true then
			pixel:Show()
		else
			pixel:Hide()
		end
		local PixelOffset = RUF.db.profile.Appearance.Aura.Pixel.Offset
		if PixelOffset == 0 then
			pixel:SetPoint('TOPLEFT', button, 'TOPLEFT', 0, 0)
			pixel:SetPoint('BOTTOMRIGHT', button, 'BOTTOMRIGHT', 0, 0)
		else
			pixel:SetPoint('TOPLEFT', button, 'TOPLEFT', -PixelOffset, PixelOffset)
			pixel:SetPoint('BOTTOMRIGHT', button, 'BOTTOMRIGHT', PixelOffset, -PixelOffset)
		end
		local spiral = RUF.db.profile.Appearance.Aura.spiral
		if spiral.enabled ~= true then
			if self[position].cd then
				self[position].cd:Hide()
				self[position].cd = nil
			end
		else
			local cd
			if not self[position].cd then
				cd = CreateFrame('Cooldown', '$parentCooldown', button, 'CooldownFrameTemplate')
				cd:SetAllPoints(button.border)
				button.cd = cd
			end
			cd = self[position].cd
			cd:SetReverse(spiral.reverse)
		end
	end

end

function RUF.SetBuffs(self, unit)
	_, PlayerClass = UnitClass('player')
	if RUF.Client == 1 then
		-- GetSpecialization doesn't exist for Classic. All 'specs' can dispel the same types, so set to 10 to follow those values where appropriate.
		RUF.Specialization = GetSpecialization()
	else
		RUF.Specialization = 10
	end
	local Buffs = CreateFrame('Frame', nil, self)
	Buffs:SetPoint(
		RUF.db.profile.unit[unit].Buffs.Icons.Position.AnchorFrom,
		self,
		RUF.db.profile.unit[unit].Buffs.Icons.Position.AnchorTo,
		RUF.db.profile.unit[unit].Buffs.Icons.Position.x,
		RUF.db.profile.unit[unit].Buffs.Icons.Position.y)

	Buffs:SetSize((RUF.db.profile.unit[unit].Buffs.Icons.Width*RUF.db.profile.unit[unit].Buffs.Icons.Columns), (RUF.db.profile.unit[unit].Buffs.Icons.Height*RUF.db.profile.unit[unit].Buffs.Icons.Rows) + 2)
	Buffs.size = RUF.db.profile.unit[unit].Buffs.Icons.Width
	Buffs.width = RUF.db.profile.unit[unit].Buffs.Icons.Width
	Buffs.height = RUF.db.profile.unit[unit].Buffs.Icons.Height
	Buffs['growth-x'] = RUF.db.profile.unit[unit].Buffs.Icons.Growth.x
	Buffs['growth-y'] = RUF.db.profile.unit[unit].Buffs.Icons.Growth.y
	Buffs.initialAnchor = RUF.db.profile.unit[unit].Buffs.Icons.Position.AnchorFrom -- Where icons spawn from in the buff frame
	Buffs['spacing-x'] = RUF.db.profile.unit[unit].Buffs.Icons.Spacing.x
	Buffs['spacing-y'] = RUF.db.profile.unit[unit].Buffs.Icons.Spacing.y

	if RUF.db.profile.unit[unit].Buffs.Icons.ClickThrough == true then
		Buffs.disableMouse = true
	else
		Buffs.disableMouse = false
	end

	if RUF.db.profile.unit[unit].Buffs.Icons.CooldownSpiral == true then
		Buffs.disableCooldown = false
	else
		Buffs.disableCooldown = true
	end

	Buffs.num = RUF.db.profile.unit[unit].Buffs.Icons.Max

	Buffs.CustomFilter = CustomBuffFilter
	Buffs.CreateIcon = RUF.CreateAuraIcon
	Buffs.PostUpdateIcon = PostUpdateBuffIcon
	Buffs.Enabled = true

	self.Buff = Buffs
end