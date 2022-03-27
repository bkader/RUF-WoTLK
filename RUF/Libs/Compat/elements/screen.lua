local parent, ns = ...
local Compat = ns.Compat

local GetScreenResolutions = GetScreenResolutions
local GetCurrentResolution = GetCurrentResolution
local strmatch = string.match
local tonumber = tostring

function Compat.GetPhysicalScreenSize()
	local width, height = strmatch(({GetScreenResolutions()})[GetCurrentResolution()], "(%d+)x(%d+)")
	return tonumber(width), tonumber(height)
end