local parent, ns = ...
local oUF = ns.oUF
local Private = oUF.Private

local enableTargetUpdate = Private.enableTargetUpdate

-- Handles unit specific actions.
function oUF:HandleUnit(object, unit)
	local uId = object.unit or unit
	if (uId == "target") then
		object:RegisterEvent("PLAYER_TARGET_CHANGED", object.UpdateAllElements, true)
	elseif (uId == "mouseover") then
		object:RegisterEvent("UPDATE_MOUSEOVER_UNIT", object.UpdateAllElements, true)
	elseif (uId == "focus") then
		object:RegisterEvent("PLAYER_FOCUS_CHANGED", object.UpdateAllElements, true)
	elseif(uId:match('%w+target') or uId:match('boss%d?$')) then
		enableTargetUpdate(object)
	end
end