assert(RUF, "RUF not found!")
local RUF = RUF
local _, ns = ...
local oUF = ns.oUF

local tags = oUF.Tags.Methods or oUF.Tags
local events = oUF.TagEvents or oUF.Tags.Events

local format = string.format
local random = math.random

local UnitLevel = UnitLevel
local UnitIsAFK = UnitIsAFK
local UnitIsDND = UnitIsDND
local UnitClassification = UnitClassification

----------------------------------------------------------------------------------- STATUS
tags["RUF:Level"] = function(unit)
	local profileReference = RUF.db.profile.Appearance.Text.Level
	local level = UnitLevel(unit)
	local elite = UnitClassification(unit) -- worldboss, rareelite, elite, rare, normal, trivial, or minus
	if elite == "rareelite" then
		elite = "++"
	elseif elite == "elite" or elite == "rare" then
		elite = "+"
	elseif elite == "minus" then
		elite = "-"
	else
		elite = ""
	end
	if RUF.db.global.TestMode == true then
		level = random(120)
	end
	local r, g, b = RUF:ReturnTextColors(unit, "Level")
	if level <= 0 then
		level = ""
		elite = "??"
	end
	if profileReference.HideSameLevel == true and level == UnitLevel("player") then
		level = ""
	end
	if profileReference.ShowLevel == false then
		level = ""
	end
	if profileReference.ShowClassification == false then
		elite = ""
	end
	if profileReference.ClassificationBeforeLevel == true then
		return format("|cff%02x%02x%02x%s%s|r", r * 255, g * 255, b * 255, elite, level)
	else
		return format("|cff%02x%02x%02x%s%s|r", r * 255, g * 255, b * 255, level, elite)
	end
end
events["RUF:Level"] = "UNIT_LEVEL PLAYER_LEVEL_UP UNIT_CLASSIFICATION_CHANGED"

tags["RUF:AFKDND"] = function(unit)
	local r, g, b = RUF:ReturnTextColors(unit, "AFKDND")
	if RUF.db.global.TestMode == true then
		return format("|cff%02x%02x%02x[%s]|r", r * 255, g * 255, b * 255, AFK)
	end
	if UnitIsAFK(unit) then
		return format("|cff%02x%02x%02x[%s]|r", r * 255, g * 255, b * 255, AFK)
	end
	if UnitIsDND(unit) then
		return format("|cff%02x%02x%02x[%s]|r", r * 255, g * 255, b * 255, DND)
	end
end
events["RUF:AFKDND"] = "PLAYER_FLAGS_CHANGED"
oUF.Tags.SharedEvents.PLAYER_FLAGS_CHANGED = true