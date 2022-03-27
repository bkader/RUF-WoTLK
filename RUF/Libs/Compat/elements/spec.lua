local parent, ns = ...

local LGT = LibStub and LibStub("LibGroupTalents-1.0", true)
if not LGT then return end

local Compat = ns.Compat
local unitExists = Compat.Private.UnitExists

local UnitGroupRolesAssigned = UnitGroupRolesAssigned
local MAX_TALENT_TABS = MAX_TALENT_TABS or 3
local GetActiveTalentGroup = GetActiveTalentGroup
local GetTalentTabInfo = GetTalentTabInfo
local UnitClass = UnitClass

local LGTRoleTable = {melee = "DAMAGER", caster = "DAMAGER", healer = "HEALER", tank = "TANK"}

function Compat.GetSpecialization(isInspect, isPet, specGroup)
	local currentSpecGroup = GetActiveTalentGroup(isInspect, isPet) or (specGroup or 1)
	local points, specname, specid = 0, nil, nil

	for i = 1, MAX_TALENT_TABS do
		local name, _, pointsSpent = GetTalentTabInfo(i, isInspect, isPet, currentSpecGroup)
		if points <= pointsSpent then
			points = pointsSpent
			specname = name
			specid = i
		end
	end
	return specid, specname, points
end

function Compat.UnitGroupRolesAssigned(unit, class)
	unit = unit or "player" -- always fallback to player

	-- For LFG using "UnitGroupRolesAssigned" is enough.
	local isTank, isHealer, isDamager = UnitGroupRolesAssigned(unit)
	if isTank then
		return "TANK"
	elseif isHealer then
		return "HEALER"
	elseif isDamager then
		return "DAMAGER"
	end

	-- speedup things using classes.
	class = class or select(2, UnitClass(unit))
	if class == "HUNTER" or class == "MAGE" or class == "ROGUE" or class == "WARLOCK" then
		return "DAMAGER"
	end
	return LGTRoleTable[LGT:GetUnitRole(unit)] or "NONE"
end