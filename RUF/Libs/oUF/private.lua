local parent, ns = ...
local Private = ns.oUF.Private

-- some values we may need
Private.epsilon = 0.0001
Private.defaultFont = {GameFontNormal:GetFont()}

local assert, type, select = assert, type, select
local format = string.format
local pcall, xpcall = pcall, xpcall
local UnitExists = UnitExists

function Private.argcheck(value, num, ...)
	assert(type(num) == "number", "Bad argument #2 to 'argcheck' (number expected, got " .. type(num) .. ")")

	for i = 1, select("#", ...) do
		if (type(value) == select(i, ...)) then
			return
		end
	end

	local types = strjoin(", ", ...)
	local name = debugstack(2, 2, 0):match(": in function [`<](.-)['>]")
	error(format("Bad argument #%d to '%s' (%s expected, got %s)", num, name, types, type(value)), 3)
end

function Private.print(...)
	print("|cff33ff99oUF:|r", ...)
end

function Private.error(...)
	Private.print("|cffff0000Error:|r " .. format(...))
end

function Private.unitExists(unit)
	return unit and (UnitExists(unit) ~= nil)
end

local validator = CreateFrame("Frame")

function Private.validateUnit(unit)
	local isOK, _ = pcall(validator.RegisterUnitEvent, validator, "UNIT_HEALTH", unit)
	if (isOK) then
		_, unit = validator:IsEventRegistered("UNIT_HEALTH")
		validator:UnregisterEvent("UNIT_HEALTH")

		return not (not unit)
	end
end

local function errorHandler(...)
	return geterrorhandler()(...)
end

function Private.xpcall(func, ...)
	return xpcall(func, errorHandler, ...)
end

function Private.validateEvent(event)
	local isOK = xpcall(validator.RegisterEvent, errorHandler, validator, event)
	if (isOK) then
		validator:UnregisterEvent(event)
	end

	return isOK
end

function Private.setFont(fs)
	if fs.GetFont and fs:GetFont() == nil then
		fs:SetFont(unpack(Private.defaultFont))
	end
end