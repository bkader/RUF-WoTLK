local RUF = LibStub("AceAddon-3.0"):NewAddon("RUF", "AceConsole-3.0", "AceEvent-3.0")
_G.RUF = RUF
local _, ns = ...
local oUF = ns.oUF
local ACD = LibStub("AceConfigDialog-3.0")
local LSM = LibStub("LibSharedMedia-3.0")
local LGT = LibStub("LibGroupTalents-1.0")
local L = LibStub("AceLocale-3.0"):GetLocale("RUF")

RUF.UIParent = CreateFrame("Frame", "RUFParent", UIParent)
RUF.UIParent:SetFrameLevel(UIParent:GetFrameLevel())
RUF.UIParent:SetSize(UIParent:GetSize())
RUF.UIParent:SetPoint("CENTER", UIParent, "CENTER")

-- player class
RUF.uClass = RUF.uClass or select(2, UnitClass("player"))

local frames = {"Player", "Pet", "PetTarget", "Focus", "FocusTarget", "Target", "TargetTarget", "TargetTargetTarget"}
local groupFrames = {"Boss", "BossTarget", "Arena", "ArenaTarget", "PartyTarget", "PartyPet"}
local headers = {"Party"}

RUF.frameList = {}
RUF.frameList.frames = frames
RUF.frameList.groupFrames = groupFrames
RUF.frameList.headers = headers

function RUF:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("RUFDB", RUF.Layout.cfg, true) -- Setup Saved Variables

	local LibDualSpec = LibStub("LibDualSpec-1.0", true)
	if LibDualSpec then
		LibDualSpec:EnhanceDatabase(self.db, "RUF")
	end

	-- Register /RUF command
	self:RegisterChatCommand("RUF", "ChatCommand")

	-- Profile Management
	self.db.RegisterCallback(self, "OnProfileChanged", "RefreshConfig")
	self.db.RegisterCallback(self, "OnProfileCopied", "RefreshConfig")
	self.db.RegisterCallback(self, "OnProfileReset", "ResetProfile")

	-- Register Media
	LSM:Register("font", "RUF", [[Interface\AddOns\RUF\Media\TGL.ttf]], LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western)
	LSM:Register("statusbar", "RUF 1", [[Interface\AddOns\RUF\Media\Raeli 1.tga]])
	LSM:Register("statusbar", "RUF 2", [[Interface\AddOns\RUF\Media\Raeli 2.tga]])
	LSM:Register("statusbar", "RUF 3", [[Interface\AddOns\RUF\Media\Raeli 3.tga]])
	LSM:Register("statusbar", "RUF 4", [[Interface\AddOns\RUF\Media\Raeli 4.tga]])
	LSM:Register("statusbar", "RUF 5", [[Interface\AddOns\RUF\Media\Raeli 5.tga]])
	LSM:Register("statusbar", "RUF 6", [[Interface\AddOns\RUF\Media\Raeli 6.tga]])
	LSM:Register("statusbar", "Armory", [[Interface\AddOns\RUF\Media\Extra\Armory.tga]])
	LSM:Register("statusbar", "Cabaret 2", [[Interface\AddOns\RUF\Media\Extra\Cabaret 2.tga]])
	LSM:Register("border", "RUF Pixel", [[Interface\ChatFrame\ChatFrameBackground]])
	LSM:Register("border", "RUF Glow", [[Interface\AddOns\RUF\Media\InternalGlow.tga]])
	LSM:Register("border", "RUF Glow Small", [[Interface\AddOns\RUF\Media\InternalGlowSmall.tga]])
	LSM:Register("font", "Overwatch Oblique", [[Interface\AddOns\RUF\Media\Extra\BigNoodleTooOblique.ttf]])
	LSM:Register("font", "Overwatch", [[Interface\AddOns\RUF\Media\Extra\BigNoodleToo.ttf]])
	LSM:Register("font", "Futura", [[Interface\AddOns\RUF\Media\Extra\Futura.ttf]])
	LSM:Register("font", "Semplicita Light", [[Interface\AddOns\RUF\Media\Extra\semplicita.light.otf]])
	LSM:Register("font", "Semplicita Light Italic", [[Interface\AddOns\RUF\Media\Extra\semplicita.light-italic.otf]])
	LSM:Register("font", "Semplicita Medium", [[Interface\AddOns\RUF\Media\Extra\semplicita.medium.otf]])
	LSM:Register("font", "Semplicita Medium Italic", [[Interface\AddOns\RUF\Media\Extra\semplicita.medium-italic.otf]])

	RUF.db.global.TestMode = false
	RUF.db.global.frameLock = true

	--project-revision
	RUF.db.global.Version = string.match(GetAddOnMetadata("RUF", "Version"), "%d+")
	RUF.db.profiles = RUF.db.profiles or {}

	-- remove buggy SetFocus
	for k, v in pairs(UnitPopupMenus) do
		for x, y in pairs(v) do
			if y == "SET_FOCUS" or y == "CLEAR_FOCUS" or y == "LOCK_FOCUS_FRAME" or y == "UNLOCK_FOCUS_FRAME" or (RUF.uClass == "HUNTER" and y == "PET_DISMISS") then
				table.remove(UnitPopupMenus[k], x)
			end
		end
	end

	LGT.RegisterCallback(RUF, "LibGroupTalents_UpdateComplete", "UpdateAllUnitSettings")
end

function RUF:ChatCommand(input)
	if not InCombatLockdown() then
		self:EnableModule("Options")
		if ACD.OpenFrames["RUF"] then
			ACD:Close("RUF")
		else
			ACD:Open("RUF")
		end
	else
		RUF:Print_Self(L["Cannot configure while in combat."])
	end
end

function RUF:ResetProfile()
	local currentProfile = self.db:GetCurrentProfile()
	RUF:RefreshConfig()
	RUF:GetModule("Options"):RefreshConfig()
end

function RUF:RefreshConfig()
	if RUF.db.global.TestMode == true then
		RUF:TestMode()
	end
	RUF.db.profile = self.db.profile
	RUF:UpdateAllUnitSettings()
end

function RUF:MediaFetch(mediatype, key, default)
	return (key and LSM:Fetch(mediatype, key)) or (default and LSM:Fetch(mediatype, default)) or default
end

function RUF:MediaList(mediatype)
	return LSM:HashTable(mediatype)
end