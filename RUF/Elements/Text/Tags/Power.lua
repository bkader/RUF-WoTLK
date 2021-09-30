assert(RUF, "RUF not found!")
local RUF = RUF
local LSM = LibStub('LibSharedMedia-3.0')
local L = LibStub('AceLocale-3.0'):GetLocale('RUF')
local _, ns = ...
local oUF = ns.oUF
local tags = oUF.Tags.Methods or oUF.Tags
local events = oUF.TagEvents or oUF.Tags.Events


----------------------------------------------------------------------------------- POWER
tags['RUF:CurPowerPerc'] = function(unit,realunit)
	if not UnitName(unit) then return end
	local pType,pToken,altr,altg,altb = UnitPowerType(unit)
	local cur, max = UnitPower(unit), UnitPowerMax(unit)
	local r,g,b = RUF:ReturnTextColors(unit, 'CurPowerPerc', cur, max)
	if RUF.db.global.TestMode == true then
		cur = math.random(75000)
		max = math.random(75000,100000)
	end
	if realunit and unit ~= string.match(unit, 'vehicle') then
		r,g,b = RUF:ReturnTextColors(realunit, 'CurPowerPerc', cur, max)
	end
	if RUF.db.profile.Appearance.Text.CurPowerPerc.Enabled == 1 and cur == 0 then
		return ''
	end
	if max == 100 then
		return string.format('|cff%02x%02x%02x%s|r',r*255,g*255,b*255,RUF:Short(cur,true))
	end
	if cur == max and cur > 0 then
		if RUF.db.profile.Appearance.Text.CurPowerPerc.Case == 2 then
			return string.format('|cff%02x%02x%02x%s|r',r*255,g*255,b*255,string.lower(RUF:Short(cur,true)))
		else
			return string.format('|cff%02x%02x%02x%s|r',r*255,g*255,b*255,RUF:Short(cur,true))
		end
	elseif cur < max and cur > 0 then
		if RUF.db.profile.Appearance.Text.CurPowerPerc.Case == 2 then
			return string.format('|cff%02x%02x%02x%s%s%s%%|r',r*255,g*255,b*255,string.lower(RUF:Short(cur,true)), ' - ',RUF:Percent(cur,max))
		else
			return string.format('|cff%02x%02x%02x%s%s%s%%|r',r*255,g*255,b*255,RUF:Short(cur,true), ' - ',RUF:Percent(cur,max))
		end
	else
		if RUF.db.profile.Appearance.Text.CurPowerPerc.Case == 2 then
			return string.format('|cff%02x%02x%02x%s|r',r*255,g*255,b*255,'0')
		else
			return string.format('|cff%02x%02x%02x%s|r',r*255,g*255,b*255,'0')
		end
	end
end
events['RUF:CurPowerPerc'] = 'UNIT_POWER'

tags['RUF:PowerPerc'] = function(unit,realunit)
	if not UnitName(unit) then return end
	local pType,pToken,altr,altg,altb = UnitPowerType(unit)
	local cur, max = UnitPower(unit), UnitPowerMax(unit)
	local r,g,b = RUF:ReturnTextColors(unit, 'PowerPerc', cur, max)
	if RUF.db.global.TestMode == true then
		cur = math.random(75000)
		max = math.random(75000,100000)
	end
	if realunit and unit ~= string.match(unit, 'vehicle') then
		r,g,b = RUF:ReturnTextColors(realunit, 'PowerPerc', cur, max)
	end
	if RUF.db.profile.Appearance.Text.PowerPerc.Enabled == 1 and cur == 0 then
		return ''
	end
	return string.format('|cff%02x%02x%02x%s%%|r',r*255,g*255,b*255,RUF:Percent(cur,max))
end
events['RUF:PowerPerc'] = 'UNIT_POWER'

tags['RUF:CurPower'] = function(unit,realunit)
	if not UnitName(unit) then return end
	local pType,pToken,altr,altg,altb = UnitPowerType(unit)
	local cur, max = UnitPower(unit), UnitPowerMax(unit)
	local r,g,b = RUF:ReturnTextColors(unit, 'CurPower', cur, max)
	if RUF.db.global.TestMode == true then
		cur = math.random(75000)
		max = math.random(75000,100000)
	end
	if realunit and unit ~= string.match(unit, 'vehicle') then
		r,g,b = RUF:ReturnTextColors(realunit, 'CurPower', cur, max)
	end
	if RUF.db.profile.Appearance.Text.CurPower.Enabled == 1 and cur == 0 then
		return ''
	end
	if cur == max and cur > 0 then -- if we're at full health
		if RUF.db.profile.Appearance.Text.CurPower.Case == 1 then
			return string.format('|cff%02x%02x%02x%s|r',r*255,g*255,b*255,RUF:Short(cur,true))
		elseif RUF.db.profile.Appearance.Text.CurPower.Case == 2 then
			return string.format('|cff%02x%02x%02x%s|r',r*255,g*255,b*255,string.lower(RUF:Short(cur,true)))
		else
			return string.format('|cff%02x%02x%02x%s|r',r*255,g*255,b*255,RUF:Short(cur,true))
		end
	else
		if RUF.db.profile.Appearance.Text.CurPower.Case == 1 then
			return string.format('|cff%02x%02x%02x%s|r',r*255,g*255,b*255,RUF:Short(cur,true))
		elseif RUF.db.profile.Appearance.Text.CurPower.Case == 2 then
			return string.format('|cff%02x%02x%02x%s|r',r*255,g*255,b*255,string.lower(RUF:Short(cur,true)))
		else
			return string.format('|cff%02x%02x%02x%s|r',r*255,g*255,b*255,RUF:Short(cur,true))
		end
	end
end
events['RUF:CurPower'] = 'UNIT_POWER'



----------------------------------------------------------------------------------- MANA
tags['RUF:CurManaPerc'] = function(unit)
	if not UnitName(unit) then return end
	local pType,pToken,altr,altg,altb = UnitPowerType(unit)
	local cur, max = UnitPower(unit,0), UnitPowerMax(unit,0)
	local r,g,b = RUF:ReturnTextColors(unit, 'CurManaPerc', cur, max)
	if RUF.db.global.TestMode == true then
		cur = math.random(75000)
		max = math.random(75000,100000)
	end
	if RUF.db.profile.Appearance.Text.CurManaPerc.HideWhenPrimaryIsMana == true then
		local _,PlayerClass = UnitClass(unit)
		if pToken == 'MANA' or PlayerClass == 'MONK' then
			return ''
		end
	end

	if RUF.db.profile.Appearance.Text.CurManaPerc.Enabled == 1 and cur == 0 then
		return ''
	end
	if max == 100 then
		return string.format('|cff%02x%02x%02x%s|r',r*255,g*255,b*255,RUF:Short(cur,true))
	end
	if cur == max and cur > 0 then
		if RUF.db.profile.Appearance.Text.CurManaPerc.Case == 2 then
			return string.format('|cff%02x%02x%02x%s|r',r*255,g*255,b*255,string.lower(RUF:Short(cur,true)))
		else
			return string.format('|cff%02x%02x%02x%s|r',r*255,g*255,b*255,RUF:Short(cur,true))
		end
	elseif cur < max and cur > 0 then
		if RUF.db.profile.Appearance.Text.CurManaPerc.Case == 2 then
			return string.format('|cff%02x%02x%02x%s%s%s%%|r',r*255,g*255,b*255,string.lower(RUF:Short(cur,true)), ' - ',RUF:Percent(cur,max))
		else
			return string.format('|cff%02x%02x%02x%s%s%s%%|r',r*255,g*255,b*255,RUF:Short(cur,true), ' - ',RUF:Percent(cur,max))
		end
	else
		if RUF.db.profile.Appearance.Text.CurManaPerc.Case == 2 then
			return string.format('|cff%02x%02x%02x%s|r',r*255,g*255,b*255,'0')
		else
			return string.format('|cff%02x%02x%02x%s|r',r*255,g*255,b*255,'0')
		end
	end
end
events['RUF:CurManaPerc'] = 'UNIT_POWER'

tags['RUF:ManaPerc'] = function(unit)
	if not UnitName(unit) then return end
	local pType,pToken,altr,altg,altb = UnitPowerType(unit)
	local cur, max = UnitPower(unit,0), UnitPowerMax(unit,0)
	local r,g,b = RUF:ReturnTextColors(unit, 'ManaPerc', cur, max)
	if RUF.db.global.TestMode == true then
		cur = math.random(75000)
		max = math.random(75000,100000)
	end
	if RUF.db.profile.Appearance.Text.ManaPerc.HideWhenPrimaryIsMana == true then
		local _,PlayerClass = UnitClass(unit)
		if pToken == 'MANA' or PlayerClass == 'MONK' then
			return ''
		end
	end
	if RUF.db.profile.Appearance.Text.ManaPerc.Enabled == 1 and cur == 0 then
		return ''
	end
	return string.format('|cff%02x%02x%02x%s%%|r',r*255,g*255,b*255,RUF:Percent(cur,max))
end
events['RUF:ManaPerc'] = 'UNIT_POWER'

tags['RUF:CurMana'] = function(unit)
	if not UnitName(unit) then return end
	local pType,pToken,altr,altg,altb = UnitPowerType(unit)
	local cur, max = UnitPower(unit,0), UnitPowerMax(unit,0)
	local r,g,b = RUF:ReturnTextColors(unit, 'CurMana', cur, max)
	if RUF.db.global.TestMode == true then
		cur = math.random(75000)
		max = math.random(75000,100000)
	end
	if RUF.db.profile.Appearance.Text.CurMana.HideWhenPrimaryIsMana == true then
		local _,PlayerClass = UnitClass(unit)
		if pToken == 'MANA' or PlayerClass == 'MONK' then
			return ''
		end
	end
	if RUF.db.profile.Appearance.Text.CurMana.Enabled == 1 and cur == 0 then
		return ''
	end
	if cur == max  and cur > 0 then
		if RUF.db.profile.Appearance.Text.CurMana.Case == 1 then
			return string.format('|cff%02x%02x%02x%s|r',r*255,g*255,b*255,RUF:Short(cur,true))
		elseif RUF.db.profile.Appearance.Text.CurMana.Case == 2 then
			return string.format('|cff%02x%02x%02x%s|r',r*255,g*255,b*255,string.lower(RUF:Short(cur,true)))
		else
			return string.format('|cff%02x%02x%02x%s|r',r*255,g*255,b*255,RUF:Short(cur,true))
		end
	else
		if RUF.db.profile.Appearance.Text.CurMana.Case == 1 then
			return string.format('|cff%02x%02x%02x%s|r',r*255,g*255,b*255,RUF:Short(cur,true))
		elseif RUF.db.profile.Appearance.Text.CurMana.Case == 2 then
			return string.format('|cff%02x%02x%02x%s|r',r*255,g*255,b*255,string.lower(RUF:Short(cur,true)))
		else
			return string.format('|cff%02x%02x%02x%s|r',r*255,g*255,b*255,RUF:Short(cur,true))
		end
	end
end
events['RUF:CurMana'] = 'UNIT_POWER'