assert(RUF, "RUF not found!")
local RUF = RUF

RUF.groupPrototype = {}
RUF.headerPrototype = {}

function RUF.groupPrototype:GetAttribute(name)
	return self.groups[1]:GetAttribute(name)
end

function RUF.groupPrototype:Configure(name)
	local unit = name:lower()
	local db = RUF.db.profile.unit[unit]

	local point
	local width, height, newCols, newRows = 0, 0, 0, 0
	local direction = db.growthDirection
	print("here", unit, db, direction)
end


function RUF.headerPrototype:ClearChildPoints()
	for i = 1, self:GetNumChildren() do
		local child = select(1, self:GetChildren())
		child:ClearAllPoints()
	end
end

function RUF.headerPrototype:Update()
	local unit = self.unit
	print("here", unit)
	-- local db = RUF.db.profile.unit[unit]
end