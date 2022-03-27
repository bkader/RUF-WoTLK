local parent, ns = ...
local Compat = ns.Compat
local Epsilon = 0.000001

local min, max, abs, floor, ceil = math.min, math.max, math.abs, math.floor, math.ceil

function Compat.Round(value)
	return (value < 0) and ceil(value - 0.5) or floor(value + 0.5)
end

function Compat.WithinRange(value, minValue, maxValue)
	return (value >= minValue and value <= maxValue)
end