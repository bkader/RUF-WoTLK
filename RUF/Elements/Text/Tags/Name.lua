local RUF = RUF
local _, ns = ...
local oUF = ns.oUF

local tags = oUF.Tags.Methods or oUF.Tags
local events = oUF.TagEvents or oUF.Tags.Events

local upper = string.upper
local lower = string.lower
local format = string.format
local random = math.random

local UnitName = UnitName
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local UnitIsPlayer = UnitIsPlayer

---------------------------------------------------------------------------------
-- Name
tags["RUF:Name"] = function(unit, realUnit)
	if not UnitName(unit) then return end
	local name = UnitName(unit)
	if RUF.db.profile.Appearance.Text.Name.Case == 1 then
		name = upper(name)
	elseif RUF.db.profile.Appearance.Text.Name.Case == 2 then
		name = lower(name)
	end

	local cur, max = UnitHealth(unit), UnitHealthMax(unit)
	local r, g, b = RUF:ReturnTextColors(unit, "Name", cur, max)
	if RUF.db.global.TestMode == true then
		cur = random(75)
		max = random(75, 100)
		r, g, b = RUF:ReturnTextColors(unit, "Name", cur, max)
	end
	local charLimit = RUF.db.profile.Appearance.Text.Name.CharLimit
	if charLimit == 0 then
		charLimit = 5000
	end

	if charLimit > 0 and name:len() > charLimit then
		local style = RUF.db.profile.Appearance.Text.Name.CharLimitStyle or 0
		if style == 1 then -- Elipsis
			name = name:sub(1, charLimit)
			name = name .. "..."
		elseif style == 2 then -- Abbreviate words that should be trimmed
			if UnitIsPlayer(unit) then
				name = name:sub(1, charLimit)
			else
				local words = {}
				local chars = {}
				local spaces = {}
				for space in name:gmatch("%W+") do
					spaces[#spaces + 1] = space
				end
				spaces[#spaces + 1] = ""
				for word in name:gmatch("%w+") do
					local firstChar = word:sub(1, 1)
					words[#words + 1] = word
					chars[#chars + 1] = firstChar
					name = name:gsub(word, firstChar, 1):gsub("%s", "")
				end
				name = table.concat(chars)
				if name:len() >= charLimit then
					name = name:sub(1, charLimit)
				else
					for i = 1, #words do
						if name:len() < charLimit then
							chars[i] = words[i] .. spaces[i]
							local string = table.concat(chars)
							if string:len() < charLimit then
								name = string
							end
						end
					end
				end
			end
		elseif style == 3 then -- Initialism everything
			if name:len() >= charLimit then
				if UnitIsPlayer(unit) then
					name = name:sub(1, 1)
				else
					for word in name:gmatch("%w+") do
						name = name:gsub(word, word:sub(1, 1), 1):gsub("%s", ""):gsub("%W+", "")
					end
					name = name:sub(1, charLimit)
				end
			end
		else -- Trim
			name = name:sub(1, charLimit)
		end
	end

	-- Return Text String
	if UnitIsPlayer(unit) then
		return format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, name)
	else
		return format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, name)
	end
end
events["RUF:Name"] = "UNIT_NAME_UPDATE"