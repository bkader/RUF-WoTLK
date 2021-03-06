local RUF = RUF
local _, ns = ...
local oUF = ns.oUF
local L = LibStub("AceLocale-3.0"):GetLocale("RUF")

local tags = oUF.Tags.Methods or oUF.Tags
local events = oUF.TagEvents or oUF.Tags.Events

local format = string.format
local upper = string.upper
local lower = string.lower
local random = math.random

local UnitName = UnitName
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local UnitIsDead = UnitIsDead
local UnitIsGhost = UnitIsGhost
local UnitIsConnected = UnitIsConnected

---------------------------------------------------------------------------------
-- Current Health and Percent if below 100%.
tags["RUF:CurHPPerc"] = function(unit, realunit)
	if not UnitName(unit) then return end
	local cur, max = UnitHealth(unit), UnitHealthMax(unit)
	local r, g, b = RUF:ReturnTextColors(unit, "CurHPPerc", cur, max)
	if RUF.db.global.TestMode == true then
		cur = random(max / 4, max - (max / 4))
	end
	if realunit then
		r, g, b = RUF:ReturnTextColors(realunit, "CurHPPerc", cur, max)
	end
	if UnitIsDead(unit) then
		if RUF.db.profile.Appearance.Text.CurHPPerc.Case == 1 then
			return format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, upper(L["Dead"]))
		elseif RUF.db.profile.Appearance.Text.CurHPPerc.Case == 2 then
			return format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, lower(L["Dead"]))
		else
			return format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, L["Dead"])
		end
	elseif UnitIsGhost(unit) then
		if RUF.db.profile.Appearance.Text.CurHPPerc.Case == 1 then
			return format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, upper(L["Ghost"]))
		elseif RUF.db.profile.Appearance.Text.CurHPPerc.Case == 2 then
			return format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, lower(L["Ghost"]))
		else
			return format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, L["Ghost"])
		end
	elseif not UnitIsConnected(unit) then
		if RUF.db.profile.Appearance.Text.CurHPPerc.Case == 1 then
			return format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, upper(L["Offline"]))
		elseif RUF.db.profile.Appearance.Text.CurHPPerc.Case == 2 then
			return format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, lower(L["Offline"]))
		else
			return format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, L["Offline"])
		end
	elseif cur == max then -- if we're at full health
		if RUF.db.profile.Appearance.Text.CurHPPerc.ShowPercAtMax == true then
			return format("|cff%02x%02x%02x%s - %s%%|r", r * 255, g * 255, b * 255, RUF:Short(cur, true), RUF:Percent(cur, max))
		else
			return format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, RUF:Short(cur, true))
		end
	else
		return format("|cff%02x%02x%02x%s - %s%%|r", r * 255, g * 255, b * 255, RUF:Short(cur, true), RUF:Percent(cur, max))
	end
end
events["RUF:CurHPPerc"] = "UNIT_HEALTH UNIT_CONNECTION"

---------------------------------------------------------------------------------
-- Current Health Percent.
tags["RUF:HPPerc"] = function(unit, realunit)
	if not UnitName(unit) then return end
	local cur, max = UnitHealth(unit), UnitHealthMax(unit)
	local r, g, b = RUF:ReturnTextColors(unit, "HPPerc", cur, max)
	if RUF.db.global.TestMode == true then
		cur = random(max / 4, max - (max / 4))
	end
	if realunit then
		r, g, b = RUF:ReturnTextColors(realunit, "HPPerc", cur, max)
	end
	return format("|cff%02x%02x%02x%s%%|r", r * 255, g * 255, b * 255, RUF:Percent(cur, max))
end
events["RUF:HPPerc"] = "UNIT_HEALTH UNIT_CONNECTION"

---------------------------------------------------------------------------------
-- Current Health.
tags["RUF:CurHP"] = function(unit, realunit)
	if not UnitName(unit) then return end
	local cur, max = UnitHealth(unit), UnitHealthMax(unit)
	local r, g, b = RUF:ReturnTextColors(unit, "CurHP", cur, max)
	if RUF.db.global.TestMode == true then
		cur = random(max / 4, max - (max / 4))
	end
	if realunit then
		r, g, b = RUF:ReturnTextColors(realunit, "CurHP", cur, max)
	end
	if cur == max then -- if we're at full health
		if RUF.db.profile.Appearance.Text.CurHP.Case == 1 then
			return format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, RUF:Short(cur, true))
		elseif RUF.db.profile.Appearance.Text.CurHP.Case == 2 then
			return format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, RUF:Short(cur, true))
		else
			return format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, RUF:Short(cur, true))
		end
	else
		if RUF.db.profile.Appearance.Text.CurHP.Case == 1 then
			return format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, RUF:Short(cur, true))
		elseif RUF.db.profile.Appearance.Text.CurHP.Case == 2 then
			return format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, RUF:Short(cur, true))
		else
			return format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, RUF:Short(cur, true))
		end
	end
end
events["RUF:CurHP"] = "UNIT_HEALTH UNIT_CONNECTION"

---------------------------------------------------------------------------------
-- Current Health / Max Health and Percent if below 100%.
tags["RUF:CurMaxHPPerc"] = function(unit, realunit)
	if not UnitName(unit) then return end
	local cur, max = UnitHealth(unit), UnitHealthMax(unit)
	local r, g, b = RUF:ReturnTextColors(unit, "CurMaxHPPerc", cur, max)
	if RUF.db.global.TestMode == true then
		cur = random(max / 4, max - (max / 4))
	end
	if realunit then
		r, g, b = RUF:ReturnTextColors(realunit, "CurMaxHPPerc", cur, max)
	end
	if UnitIsDead(unit) then
		if RUF.db.profile.Appearance.Text.CurMaxHPPerc.Case == 1 then
			return format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, upper(L["Dead"]))
		elseif RUF.db.profile.Appearance.Text.CurMaxHPPerc.Case == 2 then
			return format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, lower(L["Dead"]))
		else
			return format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, L["Dead"])
		end
	elseif UnitIsGhost(unit) then
		if RUF.db.profile.Appearance.Text.CurMaxHPPerc.Case == 1 then
			return format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, upper(L["Ghost"]))
		elseif RUF.db.profile.Appearance.Text.CurMaxHPPerc.Case == 2 then
			return format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, lower(L["Ghost"]))
		else
			return format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, L["Ghost"])
		end
	elseif not UnitIsConnected(unit) then
		if RUF.db.profile.Appearance.Text.CurMaxHPPerc.Case == 1 then
			return format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, upper(L["Offline"]))
		elseif RUF.db.profile.Appearance.Text.CurMaxHPPerc.Case == 2 then
			return format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, lower(L["Offline"]))
		else
			return format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, L["Offline"])
		end
	elseif cur == max then -- if we're at full health
		if RUF.db.profile.Appearance.Text.CurMaxHPPerc.ShowMaxAtMax == true then
			if RUF.db.profile.Appearance.Text.CurMaxHPPerc.ShowPercAtMax == true then
				return format("|cff%02x%02x%02x%s/%s - %s%%|r", r * 255, g * 255, b * 255, RUF:Short(cur, true), RUF:Short(max, true), RUF:Percent(cur, max))
			else
				return format("|cff%02x%02x%02x%s/%s|r", r * 255, g * 255, b * 255, RUF:Short(cur, true), RUF:Short(max, true))
			end
		elseif RUF.db.profile.Appearance.Text.CurMaxHPPerc.ShowPercAtMax == true then
			return format("|cff%02x%02x%02x%s - %s%%|r", r * 255, g * 255, b * 255, RUF:Short(cur, true), RUF:Percent(cur, max))
		else
			return format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, RUF:Short(cur, true))
		end
	else
		return format("|cff%02x%02x%02x%s/%s - %s%%|r", r * 255, g * 255, b * 255, RUF:Short(cur, true), RUF:Short(max, true), RUF:Percent(cur, max))
	end
end
events["RUF:CurMaxHPPerc"] = "UNIT_HEALTH UNIT_CONNECTION"

---------------------------------------------------------------------------------
-- Current Health / Max Health
tags["RUF:CurMaxHP"] = function(unit, realunit)
	if not UnitName(unit) then return end
	local cur, max = UnitHealth(unit), UnitHealthMax(unit)
	local r, g, b = RUF:ReturnTextColors(unit, "CurMaxHP", cur, max)
	if RUF.db.global.TestMode == true then
		cur = random(max / 4, max - (max / 4))
	end
	if realunit then
		r, g, b = RUF:ReturnTextColors(realunit, "CurMaxHP", cur, max)
	end
	if UnitIsDead(unit) then
		if RUF.db.profile.Appearance.Text.CurMaxHP.Case == 1 then
			return format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, upper(L["Dead"]))
		elseif RUF.db.profile.Appearance.Text.CurMaxHP.Case == 2 then
			return format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, lower(L["Dead"]))
		else
			return format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, L["Dead"])
		end
	elseif UnitIsGhost(unit) then
		if RUF.db.profile.Appearance.Text.CurMaxHP.Case == 1 then
			return format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, upper(L["Ghost"]))
		elseif RUF.db.profile.Appearance.Text.CurMaxHP.Case == 2 then
			return format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, lower(L["Ghost"]))
		else
			return format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, L["Ghost"])
		end
	elseif not UnitIsConnected(unit) then
		if RUF.db.profile.Appearance.Text.CurMaxHP.Case == 1 then
			return format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, upper(L["Offline"]))
		elseif RUF.db.profile.Appearance.Text.CurMaxHP.Case == 2 then
			return format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, lower(L["Offline"]))
		else
			return format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, L["Offline"])
		end
	elseif cur == max then -- if we're at full health
		if RUF.db.profile.Appearance.Text.CurMaxHP.ShowMaxAtMax == true then
			return format("|cff%02x%02x%02x%s/%s|r", r * 255, g * 255, b * 255, RUF:Short(cur, true), RUF:Short(max, true))
		else
			return format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, RUF:Short(cur, true))
		end
	else
		return format("|cff%02x%02x%02x%s/%s|r", r * 255, g * 255, b * 255, RUF:Short(cur, true), RUF:Short(max, true))
	end
end
events["RUF:CurMaxHP"] = "UNIT_HEALTH UNIT_CONNECTION"

---------------------------------------------------------------------------------
-- Max HP
tags["RUF:MaxHP"] = function(unit, realunit)
	if not UnitName(unit) then return end
	local cur, max = UnitHealth(unit), UnitHealthMax(unit)
	local r, g, b = RUF:ReturnTextColors(unit, "CurMaxHPPerc", cur, max)
	if RUF.db.global.TestMode == true then
		cur = random(max / 4, max - (max / 4))
	end
	if realunit then
		r, g, b = RUF:ReturnTextColors(realunit, "CurMaxHPPerc", cur, max)
	end
	if cur == max then -- if we're at full health
		if RUF.db.profile.Appearance.Text.CurMaxHPPerc.Case == 1 then
			return format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, RUF:Short(max, true))
		elseif RUF.db.profile.Appearance.Text.CurMaxHPPerc.Case == 2 then
			return format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, lower(RUF:Short(max, true)))
		else
			return format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, RUF:Short(max, true))
		end
	else
		if RUF.db.profile.Appearance.Text.CurMaxHPPerc.Case == 1 then
			return format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, RUF:Short(max, true))
		elseif RUF.db.profile.Appearance.Text.CurMaxHPPerc.Case == 2 then
			return format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, lower(RUF:Short(max, true)))
		else
			return format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, RUF:Short(max, true))
		end
	end
end
events["RUF:MaxHP"] = "UNIT_HEALTH UNIT_CONNECTION"