local _, ns = ...
local oUF = ns.oUF
local libRangeCheck = LibStub("LibRangeCheck-2.0")
local updateFrequency = 0.25 -- TODO Add Option somewhere
local _FRAMES = {}
local OnRangeFrame
local _,uClass = UnitClass('player')

local FriendSpells = {}
local HarmSpells = {}

FriendSpells["DEATHKNIGHT"] = {
}
HarmSpells["DEATHKNIGHT"] = {
	49576, -- ["Death Grip"], -- 30
}

FriendSpells["DEMONHUNTER"] = {
}
HarmSpells["DEMONHUNTER"] = {
	185123, -- ["Throw Glaive"], -- 30
}

FriendSpells["DRUID"] = {
	774, -- ["Rejuvenation"], -- 40
	2782, -- ["Remove Corruption"], -- 40
}
HarmSpells["DRUID"] = {
	5176, -- ["Wrath"], -- 40
	339, -- ["Entangling Roots"], -- 35
	6795, -- ["Growl"], -- 30
	33786, -- ["Cyclone"], -- 20
	22568, -- ["Ferocious Bite"], -- 5
}

FriendSpells["HUNTER"] = {}
HarmSpells["HUNTER"] = {
	75, -- ["Auto Shot"], -- 40
}

FriendSpells["MAGE"] = {
}
HarmSpells["MAGE"] = {
	44614, --["Frostfire Bolt"], -- 40
	5019, -- ["Shoot"], -- 30
}

FriendSpells["MONK"] = {
	115450, -- ["Detox"], -- 40
	115546, -- ["Provoke"], -- 30
}
HarmSpells["MONK"] = {
	115546, -- ["Provoke"], -- 30
	115078, -- ["Paralysis"], -- 20
	100780, -- ["Tiger Palm"], -- 5
}

FriendSpells["PALADIN"] = {
	19750, -- ["Flash of Light"], -- 40
}
HarmSpells["PALADIN"] = {
	62124, -- ["Reckoning"], -- 30
	20271, -- ["Judgement"], -- 30
	853, -- ["Hammer of Justice"], -- 10
	35395, -- ["Crusader Strike"], -- 5
}

FriendSpells["PRIEST"] = {
	527, -- ["Purify"], -- 40
	17, -- ["Power Word: Shield"], -- 40
}
HarmSpells["PRIEST"] = {
	589, -- ["Shadow Word: Pain"], -- 40
	5019, -- ["Shoot"], -- 30
}

FriendSpells["ROGUE"] = {}
HarmSpells["ROGUE"] = {
	2764, -- ["Throw"], -- 30
	2094, -- ["Blind"], -- 15
}

FriendSpells["SHAMAN"] = {
	8004, -- ["Healing Surge"], -- 40
	546, -- ["Water Walking"], -- 30
}
HarmSpells["SHAMAN"] = {
	403, -- ["Lightning Bolt"], -- 40
	370, -- ["Purge"], -- 30
	73899, -- ["Primal Strike"],. -- 5
}

FriendSpells["WARRIOR"] = {}
HarmSpells["WARRIOR"] = {
	355, -- ["Taunt"], -- 30
	100, -- ["Charge"], -- 8-25
	5246, -- ["Intimidating Shout"], -- 8
}

FriendSpells["WARLOCK"] = {
	5697, -- ["Unending Breath"], -- 30
}
HarmSpells["WARLOCK"] = {
	686, -- ["Shadow Bolt"], -- 40
	5019, -- ["Shoot"], -- 30
}


local function IsUnitInRange(unit)
	if not unit then return end
	local canAttack = UnitCanAttack('player', unit)
	local canHelp = UnitCanAssist('player', unit)
	local isFriend = UnitIsFriend('player', unit)
	local isVisible = UnitIsVisible(unit)
	local rangeSpells, minRange, maxRange
	local connected = UnitIsConnected(unit)
	if not connected then return true end

	if isVisible then
		if canAttack then
			rangeSpells = HarmSpells[uClass]
		elseif canHelp then
			rangeSpells = FriendSpells[uClass]
		end
		if canHelp or canAttack then
			for i = 1,#rangeSpells do
				if IsSpellKnown(rangeSpells[i]) then
					if IsSpellInRange(GetSpellInfo(rangeSpells[i]),unit) == 1 then
						return true
					end
				end
			end
		end
		if canAttack then
			minRange, maxRange = libRangeCheck:GetRange(unit,true)
			if not maxRange then maxRange = minRange end
			if maxRange < 30 then
				return true
			end
		end
		if canHelp then
			minRange, maxRange = libRangeCheck:GetRange(unit,true)
			if not maxRange then maxRange = minRange end
			if maxRange < 40 then
				return true
			end
		end
		if not canHelp and not canAttack and isFriend then return true end -- We can't reliably get range on units we cannot interact with so don't fade the frame out.
	end

	return false
end

local function Update(self, isInRange, event)
	local element = self.RangeCheck
	local unit = self.unit

	local insideAlpha = element.insideAlpha or 1
	local outsideAlpha = element.outsideAlpha or 0.55

	if(element.PreUpdate) then
		element:PreUpdate()
	end

	if element.enabled == true then
		if isInRange then
			self:SetAlpha(insideAlpha)
		else
			self:SetAlpha(outsideAlpha)
		end
		if(element.PostUpdate) then
			return element:PostUpdate(self, unit)
		end
	else
		self:SetAlpha(1)
		self:DisableElement('RangeCheck')
	end
end

local function Path(self, ...)
	return (self.RangeCheck.Override or Update) (self, IsUnitInRange(self.unit), ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, 'ForceUpdate')
end

-- Internal updating method
local timer = 0
local function OnRangeUpdate(_, elapsed)
	timer = timer + elapsed

	if(timer >= updateFrequency) then
		for _, object in next, _FRAMES do
			if(object:IsShown()) then
				Path(object, 'OnUpdate')
			end
		end

		timer = 0
	end
end

local function Enable(self)
	local element = self.RangeCheck
	if(element) then
		element.__owner = self
		element.ForceUpdate = ForceUpdate
		element.insideAlpha = element.insideAlpha or 1
		element.outsideAlpha = element.outsideAlpha or 0.55

		if(not OnRangeFrame) then
			OnRangeFrame = CreateFrame('Frame')
			OnRangeFrame:SetScript('OnUpdate', OnRangeUpdate)
		end

		table.insert(_FRAMES, self)
		OnRangeFrame:Show()

		return true
	end
end

local function Disable(self)
	local element = self.RangeCheck
	if(element) then
		for index, frame in next, _FRAMES do
			if(frame == self) then
				table.remove(_FRAMES, index)
				break
			end
		end
		self:SetAlpha(element.insideAlpha)

		if(#_FRAMES == 0) then
			OnRangeFrame:Hide()
		end
	end
end

oUF:AddElement('RangeCheck', Path, Enable, Disable)