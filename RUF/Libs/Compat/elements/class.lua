local parent, ns = ...

local Compat = ns.Compat
local tLength = Compat.tLength

local pairs = pairs
local RAID_CLASS_COLORS = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS

local classInfoTable

local function __fillClassInfoTable()
	if not classInfoTable then
		classInfoTable = {
			WARRIOR = {classFile = "WARRIOR", classID = 1},
			PALADIN = {classFile = "PALADIN", classID = 2},
			HUNTER = {classFile = "HUNTER", classID = 3},
			ROGUE = {classFile = "ROGUE", classID = 4},
			PRIEST = {classFile = "PRIEST", classID = 5},
			DEATHKNIGHT = {classFile = "DEATHKNIGHT", classID = 6},
			SHAMAN = {classFile = "SHAMAN", classID = 7},
			MAGE = {classFile = "MAGE", classID = 8},
			WARLOCK = {classFile = "WARLOCK", classID = 9},
			DRUID = {classFile = "DRUID", classID = 10}
		}

		-- fill names
		for k, v in pairs(LOCALIZED_CLASS_NAMES_MALE) do
			if classInfoTable[k] then
				classInfoTable[k].className = v
			end
		end
	end
end

function Compat.GetClassInfo(classIndex)
	if classInfoTable == nil then
		__fillClassInfoTable()
	end

	local className, classFile, classID
	if classIndex then
		for _, class in pairs(classInfoTable) do
			if class.classID == classIndex then
				className = class.className or class.classFile
				classFile = class.classFile
				classID = class.classID
				break
			end
		end
	end
	return className, classFile, classID
end