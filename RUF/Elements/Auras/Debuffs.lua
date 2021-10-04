assert(RUF, "RUF not found!")
local RUF = RUF
local uClass = RUF.uClass

local IsInGroup, IsInRaid = RUF.IsInGroup, RUF.IsInRaid
local GetSpecialization = RUF.GetSpecialization

local DebuffDispel = {
	DEATHKNIGHT = {
		[1] = {"None"},
		[2] = {"None"},
		[3] = {"None"}
	},
	DRUID = {
		[1] = {"Curse", "Poison"},
		[2] = {"Curse", "Poison"},
		[3] = {"Curse", "Poison"},
		[4] = {"Curse", "Magic", "Poison"}
	},
	HUNTER = {
		[1] = {"None"},
		[2] = {"None"},
		[3] = {"None"}
	},
	MAGE = {
		[1] = {"Curse"},
		[2] = {"Curse"},
		[3] = {"Curse"}
	},
	PALADIN = {
		[1] = {"Disease", "Magic", "Poison"},
		[2] = {"Disease", "Poison"},
		[3] = {"Disease", "Poison"}
	},
	PRIEST = {
		[1] = {"Disease", "Magic"},
		[2] = {"Disease", "Magic"},
		[3] = {"Disease"}
	},
	ROGUE = {
		[1] = {"None"},
		[2] = {"None"},
		[3] = {"None"}
	},
	SHAMAN = {
		[1] = {"Curse"},
		[2] = {"Curse"},
		[3] = {"Curse", "Magic"}
	},
	WARLOCK = {
		[1] = {"Magic"},
		[2] = {"Magic"},
		[3] = {"Magic"}
	},
	WARRIOR = {
		[1] = {"None"},
		[2] = {"None"},
		[3] = {"None"}
	}
}

local function CustomDebuffFilter(element, unit, button, ...)
	-- If the unit is in a vehicle etc.
	local frame = element:GetParent()
	if frame.realUnit then
		unit = frame.realUnit
	end

	-- If unit is party1, boss2, arena3 etc. we the group's profile.
	local profileUnit = frame.frame:gsub("%d+", "")

	local name, icon, count, debuffType, duration, expirationTime, source, isStealable, nameplateShowPersonal, spellId, canApplyAura, isBossDebuff, nameplateShowAll, timeMod, value1, value2, value3 = ...

	local BuffTypes
	if UnitIsFriend("player", unit) then
		BuffTypes = DebuffDispel[uClass][RUF.Specialization]
	else
		BuffTypes = "None" -- Can't dispel a debuff from an enemy.
	end
	local removable = false
	if BuffTypes == "None" then
		removable = false
	else
		for k, v in pairs(BuffTypes) do
			if v == debuffType then
				removable = true
			end
		end
	end

	if not source or source == nil then
		source = unit
	end
	local affiliation
	if source == "player" then
		affiliation = "player"
	elseif UnitName(source) == UnitName(unit) then
		affiliation = "unit"
	elseif IsInGroup() and UnitPlayerOrPetInParty(source) then
		affiliation = "group"
	elseif IsInRaid() and UnitInRaid(source) then
		affiliation = "group"
	else
		affiliation = "other"
	end

	-- Unlimited
	if duration == 0 and RUF.db.profile.unit[profileUnit].Debuffs.Icons.Filter.Time.Unlimited == false then
		button.shoudShow = false
		return false
	-- Shorter than Minimum duration.
	elseif (tonumber(duration) or 0) ~= 0 and duration < RUF.db.profile.unit[profileUnit].Debuffs.Icons.Filter.Time.Min and RUF.db.profile.unit[profileUnit].Debuffs.Icons.Filter.Time.Min > 0 then
		button.shoudShow = false
		return false
	-- Longer than Max duration.
	elseif duration > RUF.db.profile.unit[profileUnit].Debuffs.Icons.Filter.Time.Max and RUF.db.profile.unit[profileUnit].Debuffs.Icons.Filter.Time.Max > 0 then
		button.shoudShow = false
		return false
	end

	if (RUF.db.profile.unit[profileUnit].Debuffs.Icons.Filter.Dispellable == true and removable == true) or RUF.db.profile.unit[profileUnit].Debuffs.Icons.Filter.Dispellable == false then
		if RUF.db.profile.unit[profileUnit].Debuffs.Icons.Filter.Caster.Player == true then
			if affiliation == "player" then
				button.shoudShow = true
				return true
			end
		end
		if RUF.db.profile.unit[profileUnit].Debuffs.Icons.Filter.Caster.Unit == true then
			if affiliation == "unit" then
				button.shoudShow = true
				return true
			end
		end
		if RUF.db.profile.unit[profileUnit].Debuffs.Icons.Filter.Caster.Group == true then
			if affiliation == "group" then
				button.shoudShow = true
				return true
			end
		end
		if RUF.db.profile.unit[profileUnit].Debuffs.Icons.Filter.Caster.Other == true then
			if affiliation == "other" then
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

local function PostUpdateDebuffIcon(self, unit, button, index, position, duration, expiration, debuffType, isStealable)
	if button.shoudShow and button.shoudShow == false then return end

	local BuffTypes
	if UnitIsFriend("player", unit) then
		BuffTypes = DebuffDispel[uClass][RUF.Specialization]
	else
		BuffTypes = "None" -- Can't dispel a debuff from an enemy.
	end
	local removable = false
	if BuffTypes == "None" then
		removable = false
	else
		for k, v in pairs(BuffTypes) do
			if v == debuffType then
				removable = true
			end
		end
	end

	local r, g, b, a = unpack(RUF.db.profile.Appearance.Colors.Aura.DefaultDebuff)
	if ((RUF.db.profile.Appearance.Aura.OnlyDispellable == true and removable == true) or RUF.db.profile.Appearance.Aura.OnlyDispellable == false) and debuffType then
		if RUF.db.profile.Appearance.Aura.Debuff == true then
			r, g, b, a = unpack(RUF.db.profile.Appearance.Colors.Aura[debuffType])
		end
	end

	if self[position] then
		local icon = self[position].icon
		local profileReference = RUF.db.profile.unit[self.__owner.frame].Debuffs.Icons
		local left, right, top, bottom = RUF:IconTextureTrim(true, profileReference.Width, profileReference.Height)
		icon:SetTexCoord(left, right, top, bottom)
		local border = self[position].border
		border:SetBackdrop({
			edgeFile = RUF:MediaFetch("border", RUF.db.profile.Appearance.Aura.Border.Style.edgeFile),
			edgeSize = RUF.db.profile.Appearance.Aura.Border.Style.edgeSize
		})
		border:SetBackdropBorderColor(r, g, b, a)
		local borderOffset = RUF.db.profile.Appearance.Aura.Border.Offset
		if borderOffset == 0 then
			border:SetPoint("TOPLEFT", button, "TOPLEFT", 0, 0)
			border:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 0, 0)
		else
			border:SetPoint("TOPLEFT", button, "TOPLEFT", -borderOffset, borderOffset)
			border:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", borderOffset, -borderOffset)
		end
		local pixel = self[position].pixel
		pixel:SetBackdrop({
			edgeFile = RUF:MediaFetch("border", RUF.db.profile.Appearance.Aura.Pixel.Style.edgeFile),
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
		else
			pixel:SetPoint("TOPLEFT", button, "TOPLEFT", -PixelOffset, PixelOffset)
			pixel:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", PixelOffset, -PixelOffset)
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
				cd = CreateFrame("Cooldown", "$parentCooldown", button, "CooldownFrameTemplate")
				cd:SetAllPoints(button.border)
				button.cd = cd
			end
			cd = self[position].cd
			cd:SetReverse(spiral.reverse)
		end
	end
end

function RUF.SetDebuffs(self, unit)
	uClass = uClass or RUF.uClass or select(2, UnitClass("player"))
	RUF.Specialization = GetSpecialization()
	local Debuffs = CreateFrame("Frame", nil, self)
	Debuffs:SetPoint(
		RUF.db.profile.unit[unit].Debuffs.Icons.Position.AnchorFrom,
		self,
		RUF.db.profile.unit[unit].Debuffs.Icons.Position.AnchorTo,
		RUF.db.profile.unit[unit].Debuffs.Icons.Position.x,
		RUF.db.profile.unit[unit].Debuffs.Icons.Position.y
	)

	Debuffs:SetSize(
		(RUF.db.profile.unit[unit].Debuffs.Icons.Width * RUF.db.profile.unit[unit].Debuffs.Icons.Columns),
		(RUF.db.profile.unit[unit].Debuffs.Icons.Height * RUF.db.profile.unit[unit].Debuffs.Icons.Rows) + 2
	)
	Debuffs.size = RUF.db.profile.unit[unit].Debuffs.Icons.Width
	Debuffs.width = RUF.db.profile.unit[unit].Debuffs.Icons.Width
	Debuffs.height = RUF.db.profile.unit[unit].Debuffs.Icons.Height
	Debuffs["growth-x"] = RUF.db.profile.unit[unit].Debuffs.Icons.Growth.x
	Debuffs["growth-y"] = RUF.db.profile.unit[unit].Debuffs.Icons.Growth.y
	Debuffs.initialAnchor = RUF.db.profile.unit[unit].Debuffs.Icons.Position.AnchorFrom -- Where icons spawn from in the buff frame
	Debuffs["spacing-x"] = RUF.db.profile.unit[unit].Debuffs.Icons.Spacing.x
	Debuffs["spacing-y"] = RUF.db.profile.unit[unit].Debuffs.Icons.Spacing.y
	if RUF.db.profile.unit[unit].Debuffs.Icons.ClickThrough == true then
		Debuffs.disableMouse = true
	else
		Debuffs.disableMouse = false
	end

	if RUF.db.profile.unit[unit].Debuffs.Icons.CooldownSpiral == true then
		Debuffs.disableCooldown = false
	else
		Debuffs.disableCooldown = true
	end

	Debuffs.num = RUF.db.profile.unit[unit].Debuffs.Icons.Max
	Debuffs.CustomFilter = CustomDebuffFilter
	Debuffs.CreateIcon = RUF.CreateAuraIcon
	Debuffs.PostUpdateIcon = PostUpdateDebuffIcon
	Debuffs.Enabled = true

	self.Debuff = Debuffs
end