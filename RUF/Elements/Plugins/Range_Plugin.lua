local _, ns = ...
local oUF = ns.oUF
local SpellRange = LibStub("LibSpellRange-1.0")
local updateFrequency = 0.25 -- TODO Add Option somewhere
local _FRAMES = {}
local OnRangeFrame

local FriendSpells = {
	PRIEST = {
		527, -- Purify (40 yards)
		17, -- Power Word: Shield (40 yards)
		5019 -- Shoot (30 yards)
	},
	DRUID = {
		774, -- Rejuvenation (40 yards)
		2782 -- Remove Corruption (40 yards)
	},
	PALADIN = {
		19750 -- Flash of Light (40 yards)
	},
	SHAMAN = {
		546, -- Water Walking (30 yards)
		8004, -- Healing Surge (40 yards)
		331 -- Healing Wave (40 yards)
	},
	WARLOCK = {
		5697, -- Unending Breath (30 yards)
		755 -- Health Funnel (45 yards)
	},
	MAGE = {
		475 -- Remove Curse (40 yards)
	},
	HUNTER = {
		136 -- Mend Pet (45 yards)
	},
	DEATHKNIGHT = {
		47541 -- Death Coil (40 yards)
	},
	ROGUE = {
		57934 -- Tricks of the Trade (20 yards)
	},
	WARRIOR = {
		3411 -- Intervene (25 yards)
	}
}

local ResurrectSpells = {
	PRIEST = {
		2006 -- Resurrection (40 yards)
	},
	DRUID = {
		50769, -- Revive (30 yards)
		20484 -- Rebirth (30 yards)
	},
	PALADIN = {
		7328 -- Redemption (30 yards)
	},
	SHAMAN = {
		2008 -- Ancestral Spirit (30 yards)
	},
	DEATHKNIGHT = {
		61999 -- Raise Ally (30 yards)
	}
}

local HarmSpells = {
	PRIEST = {
		585, -- Smite (30 yars)
		589 -- Shadow Word: Pain (40 yards)
	},
	DRUID = {
		5176, -- Wrath (40 yards)
		339, -- Entangling Roots (35 yards)
		6795, -- Growl (30 yards)
		33786, -- Cyclone (20 yards)
		22568 -- Ferocious Bite (5 yards)
	},
	PALADIN = {
		35395, -- Crusader Strike (5 yards)
		853, -- Hammer of Justice (10 yards)
		20271, -- Judgement (10 yards)
		62124 -- Reckoning (30 yards)
	},
	SHAMAN = {
		51514, -- Hex (20 yards)
		8042, -- Earth Shock (25 yards)
		370, -- Purge (30 yards)
		403, -- Lightning Bolt (30 yards)
		403 -- Lightning Bolt (40 yards)
	},
	WARLOCK = {
		5782, -- Fear (20 yards)
		686, -- Shadow Bolt (30 yards)
		5019 -- Shoot (30 yards)
	},
	MAGE = {
		2136, -- Fire Blast (20 yards)
		5019, -- Shoot (30 yards)
		12826, -- Polymorph (30 yards)
		133, -- Fireball (35 yards)
		44614 -- Frostfire Bolt (40 yards)
	},
	HUNTER = {
		75 -- Auto Shot (35 yards)
	},
	DEATHKNIGHT = {
		49576 -- Death Grip (30 yards)
	},
	ROGUE = {
		2094, -- Blind (10 yards)
		26679, -- Deadly Throw (30 yards)
		2764 -- Throw (30 yards)
	},
	WARRIOR = {
		5246, -- Intimidating Shout (8 yards)
		100, -- Charge (25 yards)
		355 -- Taunt (30 yards)
	}
}

local function IsUnitInRange(unit)
	if not unit then return end
	if (not UnitIsUnit(unit, "Player")) and (UnitInParty(unit) or UnitInRaid(unit)) then
		for uId in RUF.UnitIterator() do
			if UnitIsUnit(unit, uId) then
				unit = uId
				break
			end
		end
	end

	local inRange, checkedRange = UnitInRange(unit)
	if checkedRange and not inRange then
		return false
	end

	if CheckInteractDistance(unit, 1) then
		return true
	end

	-- dead friend
	if ResurrectSpells[RUF.playerClass] and UnitIsDeadOrGhost(unit) then
		for _, spellid in ipairs(ResurrectSpells[RUF.playerClass]) do
			if SpellRange.IsSpellInRange(spellid, unit) == 1 then
				return true
			end
		end
	end

	-- friendly unit
	if
		FriendSpells[RUF.playerClass] and (UnitCanAssist("player", unit) or UnitIsFriend("player", unit)) and
			UnitIsVisible(unit)
	 then
		for _, spellid in ipairs(FriendSpells[RUF.playerClass]) do
			if SpellRange.IsSpellInRange(spellid, unit) == 1 then
				return true
			end
		end
	end

	-- enemy unit
	if HarmSpells[RUF.playerClass] and UnitCanAttack("player", unit) and UnitIsVisible(unit) then
		for _, spellid in ipairs(HarmSpells[RUF.playerClass]) do
			if SpellRange.IsSpellInRange(spellid, unit) == 1 then
				return true
			end
		end
	end

	return false
end

local function Update(self, isInRange, event)
	local element = self.RangeCheck
	local unit = self.unit

	local insideAlpha = element.insideAlpha or 1
	local outsideAlpha = element.outsideAlpha or 0.55

	if (element.PreUpdate) then
		element:PreUpdate()
	end

	if element.enabled == true then
		if isInRange then
			self:SetAlpha(insideAlpha)
		else
			self:SetAlpha(outsideAlpha)
		end
		if (element.PostUpdate) then
			return element:PostUpdate(self, unit)
		end
	else
		self:SetAlpha(1)
		self:DisableElement("RangeCheck")
	end
end

local function Path(self, ...)
	return (self.RangeCheck.Override or Update)(self, IsUnitInRange(self.unit), ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, "ForceUpdate")
end

-- Internal updating method
local timer = 0
local function OnRangeUpdate(_, elapsed)
	timer = timer + elapsed

	if (timer >= updateFrequency) then
		for _, object in next, _FRAMES do
			if (object:IsShown()) then
				Path(object, "OnUpdate")
			end
		end

		timer = 0
	end
end

local function Enable(self)
	local element = self.RangeCheck
	if (element) then
		element.__owner = self
		element.ForceUpdate = ForceUpdate
		element.insideAlpha = element.insideAlpha or 1
		element.outsideAlpha = element.outsideAlpha or 0.55

		if (not OnRangeFrame) then
			OnRangeFrame = CreateFrame("Frame")
			OnRangeFrame:SetScript("OnUpdate", OnRangeUpdate)
		end

		table.insert(_FRAMES, self)
		OnRangeFrame:Show()

		return true
	end
end

local function Disable(self)
	local element = self.RangeCheck
	if (element) then
		for index, frame in next, _FRAMES do
			if (frame == self) then
				table.remove(_FRAMES, index)
				break
			end
		end
		self:SetAlpha(element.insideAlpha)

		if (#_FRAMES == 0) then
			OnRangeFrame:Hide()
		end
	end
end

oUF:AddElement("RangeCheck", Path, Enable, Disable)