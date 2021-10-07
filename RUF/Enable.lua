assert(RUF, "RUF not found!")
local RUF = RUF
local _, ns = ...
local oUF = ns.oUF
local L = LibStub("AceLocale-3.0"):GetLocale("RUF")

local IsInGroup = RUF.IsInGroup
local GetNumSubgroupMembers = RUF.GetNumSubgroupMembers

local function SetClassColors()
	local function customClassColors()
		if (CUSTOM_CLASS_COLORS) and RUF.db.profile.Appearance.Colors.UseClassColors then
			local function updateColors()
				for classToken, color in next, CUSTOM_CLASS_COLORS do
					RUF.db.profile.Appearance.Colors.ClassColors[classToken] = {(color.r), (color.g), (color.b)}
				end
				for _, obj in next, oUF.objects do
					obj:UpdateAllElements("CUSTOM_CLASS_COLORS")
				end
			end
			updateColors()
			CUSTOM_CLASS_COLORS:RegisterCallback(updateColors)
			return true
		end
	end
	if (not customClassColors()) then
		local eventHandler = CreateFrame("Frame")
		eventHandler:RegisterEvent("ADDON_LOADED")
		eventHandler:SetScript("OnEvent", function(self)
			if (customClassColors()) then
				self:UnregisterEvent("ADDON_LOADED")
				self:SetScript("OnEvent", nil)
			end
		end)
	end
end

local function SetupFrames(self, unit)
	self:SetParent(RUF.UIParent or UIParent)
	unit = unit:gsub("%d+", "") or unit

	self.frame = unit
	local profileReference = RUF.db.profile.unit[unit]

	self:SetFrameLevel(5)
	SetClassColors()

	self:RegisterForClicks("AnyUp")
	self:SetScript("OnEnter", UnitFrame_OnEnter)
	self:SetScript("OnLeave", UnitFrame_OnLeave)

	-- Frame Size
	self:SetHeight(profileReference.Frame.Size.Height)
	self:SetWidth(profileReference.Frame.Size.Width)
	self:SetClampedToScreen(true)

	-- Frame Border
	RUF.SetFrameBorder(self, unit)

	-- Aura Highlight Border
	if not unit:match("%w+target") then
		RUF.SetGlowBorder(self, unit)
	end

	-- Toggle Party Targets in raid
	if unit:match("partytarget") or unit:match("partypet") then
		if not RUF.PartyTargetMonitor then
			RUF.PartyTargetMonitor = CreateFrame("Frame")
			RUF.PartyTargetMonitor:RegisterEvent("PARTY_MEMBERS_CHANGED")
			RUF.PartyTargetMonitor:RegisterEvent("RAID_ROSTER_UPDATE")
			RUF.PartyTargetMonitor:RegisterEvent("PLAYER_ENTERING_WORLD")
			RUF.PartyTargetMonitor:SetScript("OnEvent", RUF.TogglePartyChildrenGroupStatus)
		end
	end

	-- Frame Background
	RUF.SetFrameBackground(self, unit)

	-- Setup Bars
	RUF.SetHealthBar(self, unit)
	self.Health.Override = RUF.HealthUpdate
	self.Health.UpdateColor = RUF.HealthUpdateColor

	RUF.SetHealPrediction(self, unit)
	self.HealPrediction.PostUpdate = RUF.HealPredictionUpdateColor

	RUF.SetPowerBar(self, unit)
	self.Power.Override = RUF.PowerUpdate

	RUF.SetAbsorbBar(self, unit)
	self.Absorb.Override = RUF.AbsorbUpdate

	if unit == "player" then
		self:SetAttribute("toggleForVehicle", profileReference.toggleForVehicle or false) -- TODO Implement option for this
		RUF.SetClassBar(self, unit)
		RUF.SetRunes(self, unit)
	end
	if unit == "pet" then
		self:SetAttribute("toggleForVehicle", RUF.db.profile.unit["player"].toggleForVehicle or false)
	end

	-- Frame Portrait
	RUF.SetFramePortrait(self, unit)

	if unit == "player" or unit == "target" or unit == "focus" then
		RUF.SetCastBar(self, unit)
	end

	RUF.SetTextParent(self, unit)
	local texts = {}
	for k, v in pairs(profileReference.Frame.Text) do
		if type(v) == "table" then
			table.insert(texts, k)
		elseif type(v) == "string" then
			if v ~= "" then
				RUF.db.profile.unit[unit].Frame.Text[k] = ""
			end
		end
	end
	for i = 1, #texts do
		RUF.CreateTextArea(self, unit, texts[i])
		if profileReference.Frame.Text[texts[i]].Enabled == false then
			self.Text[texts[i]].String:UpdateTag()
			self:Untag(self.Text[texts[i]].String)
			self.Text[texts[i]].String:Hide()
		end
	end
	for i = 1, #texts do
		RUF.SetTextPoints(self, unit, texts[i])
	end

	-- Setup Auras
	RUF.SetBuffs(self, unit)
	RUF.SetDebuffs(self, unit)
	if RUF.db.profile.unit[self.frame].Buffs.Icons.Enabled == false then
		self.Buff.Enabled = false
		self:DisableElement("Aura_Plugin")
	end
	if RUF.db.profile.unit[self.frame].Debuffs.Icons.Enabled == false then
		self.Debuff.Enabled = false
		self:DisableElement("Aura_Plugin")
	end

	-- Indicators
	RUF.SetIndicators(self, unit)

	self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED", RUF.SetBarLocation, true)
	self:RegisterEvent("PLAYER_ENTERING_WORLD", RUF.SetBarLocation, true)

	RUF.SetBarLocation(self, unit)

	if unit ~= "player" then
		self.RangeCheck = self.RangeCheck or {}
		self.RangeCheck.enabled = profileReference.Frame.RangeFading.Enabled
		self.RangeCheck.insideAlpha = 1
		self.RangeCheck.outsideAlpha = profileReference.Frame.RangeFading.Alpha or 0.55
		self.RangeCheck.PostUpdate = RUF.RangeCheckPostUpdate
		self.RangeCheck.Override = RUF.RangeCheckUpdate
	end

	self.Alpha = {}
	self.Alpha.current = 1
end

function RUF:OnEnable()
	-- Register Combat Fader
	RUF.CombatFaderRegister()

	oUF:RegisterStyle("RUF_", SetupFrames)
	oUF:Factory(function(self)
		self:SetActiveStyle("RUF_")

		-- Spawn single unit frames
		local frames = RUF.frameList.frames
		for i = 1, #RUF.frameList.frames do
			local frameName = RUF.frameList.frames[i]
			local unit = frameName:lower()
			if _G["oUF_RUF_" .. frameName] then
				if _G["oUF_RUF_" .. frameName]:GetObjectType() ~= "Button" then
					_G["oUF_RUF_" .. frameName] = nil
				end
			end
			local anchorFrame = RUF.db.profile.unit[unit].Frame.Position.AnchorFrame
			if not _G[RUF.db.profile.unit[unit].Frame.Position.AnchorFrame] then
				anchorFrame = "UIParent"
			end
			self:Spawn(unit):SetPoint(
				RUF.db.profile.unit[unit].Frame.Position.AnchorFrom,
				anchorFrame,
				RUF.db.profile.unit[unit].Frame.Position.AnchorTo,
				RUF.db.profile.unit[unit].Frame.Position.x,
				RUF.db.profile.unit[unit].Frame.Position.y
			)
			if RUF.db.profile.unit[unit].Enabled == false and _G["oUF_RUF_" .. frameName] then
				_G["oUF_RUF_" .. frameName]:Disable()
			end
		end

		-- Spawn Headers
		for i = 1, #RUF.frameList.headers do
			local name = RUF.frameList.headers[i]
			if name then
				for j = 5, 1, -1 do
					if _G["oUF_RUF_" .. name .. "UnitButton" .. j] then
						if _G["oUF_RUF_" .. name .. "UnitButton" .. j]:GetObjectType() ~= "Button" then
							_G["oUF_RUF_" .. name .. "UnitButton" .. j] = nil
						end
					end
				end
				local profile = RUF.db.profile.unit[string.lower(name)]
				local template = (name == "PartyPet") and "SecureGroupPetHeaderTemplate" or "SecureGroupHeaderTemplate"
				local anchorFrom
				if profile.Frame.Position.growth == "BOTTOM" then
					anchorFrom = "TOP"
				elseif profile.Frame.Position.growth == "TOP" then
					anchorFrom = "BOTTOM"
				end

				local growthDirection
				if profile.Frame.Position.growthDirection then
					if profile.Frame.Position.growthDirection == "VERTICAL" then
						growthDirection = 5
					elseif profile.Frame.Position.growthDirection == "HORIZONTAL" then
						growthDirection = 1
					end
				end

				local showIn = "party"
				if profile.showRaid then
					showIn = "party, raid"
				end
				if profile.showArena then
					showIn = "[@arena1,exists]show;[@arena2,exists]show;[@arena3,exists]show;" .. showIn
				end

				local header = self:SpawnHeader("oUF_RUF_" .. name, template, showIn,
					"showSolo", false,
					"showParty", true,
					"showRaid", false,
					"showPlayer", profile.showPlayer,
					"yOffset", profile.Frame.Position.offsety,
					"unitsPerColumn", growthDirection,
					"maxColumns", 5,
					"columnSpacing", profile.Frame.Position.offsetx,
					"columnAnchorPoint", profile.Frame.Position.growthHoriz,
					"point", anchorFrom,
					"startingIndex", 1
				)
				header:SetPoint(profile.Frame.Position.AnchorFrom, profile.Frame.Position.AnchorFrame, profile.Frame.Position.AnchorTo, profile.Frame.Position.x, profile.Frame.Position.y)
				RegisterStateDriver(header, "visibility", header.visibility)

				header.Enabled = profile.Enabled
				header:Show()

				header:SetClampedToScreen(true)
				if profile.Enabled == false then
					for j = 1, 5 do
						local disableFrame = _G["oUF_RUF_" .. name .. "UnitButton" .. j]
						if disableFrame then
							_G["oUF_RUF_" .. name .. "UnitButton" .. j]:Disable()
						end
					end
				end

				-- Create Party Holder for dragging.
				local Mover = CreateFrame("Frame", "oUF_RUF_" .. name .. "Mover", header)
				Mover:SetAllPoints(header)
				local Background = Mover:CreateTexture("$parentBG", "BACKGROUND")
				Background:SetTexture(RUF:MediaFetch("background", "Solid"))
				Background:SetAllPoints(Mover)
				Background:SetVertexColor(0, 0, 0, 0)
				Mover:SetFrameStrata("HIGH")
				Mover:Hide()
				header.Mover = Mover

				RUF.After(0.5, RUF.ResetPartyFrames)
			end
		end

		-- Spawn single frames for Boss, Arena, and Party Targets
		for i = 1, #RUF.frameList.groupFrames do
			local group = RUF.frameList.groupFrames[i]
			if group then
				local frameName = "oUF_RUF_" .. group
				local profile = string.lower(group)
				local AnchorFrom
				if RUF.db.profile.unit[profile].Frame.Position.growth == "BOTTOM" then
					AnchorFrom = "TOP"
				elseif RUF.db.profile.unit[profile].Frame.Position.growth == "TOP" then
					AnchorFrom = "BOTTOM"
				end
				for u = 1, 5 do
					local unitName = group .. u
					if group:match("Target") then
						unitName = group:gsub("Target", "") .. u .. "Target"
					end
					local frame = self:Spawn(unitName)
					local unitFrame = _G["oUF_RUF_" .. unitName]
					if unitFrame then
						if unitFrame:GetObjectType() ~= "Button" then
							unitFrame = nil
						end
					end
					if u == 1 then
						frame:SetPoint(
							RUF.db.profile.unit[profile].Frame.Position.AnchorFrom,
							RUF.db.profile.unit[profile].Frame.Position.AnchorFrame,
							RUF.db.profile.unit[profile].Frame.Position.AnchorTo,
							RUF.db.profile.unit[profile].Frame.Position.x,
							RUF.db.profile.unit[profile].Frame.Position.y
						)
					else
						local previousUnit = _G[frameName .. u - 1]
						if group:match("Target") then
							previousUnit = _G["oUF_RUF_" .. group:gsub("Target", "") .. u - 1 .. "Target"]
						end
						frame:SetPoint(
							AnchorFrom,
							previousUnit,
							RUF.db.profile.unit[profile].Frame.Position.growth,
							RUF.db.profile.unit[profile].Frame.Position.offsetx,
							RUF.db.profile.unit[profile].Frame.Position.offsety
						)
					end
					if RUF.db.profile.unit[profile].Enabled == false and unitFrame then
						unitFrame:Disable()
						unitFrame:SetAttribute("oUF-enableArenaPrep", false)
					end

					if profile == "partypet" or profile == "partytarget" then
						local unitType = string.gsub(profile, "party", "")
						if RUF.db.profile.unit.party.showPlayer and unitFrame then
							if u == 1 then
								unitFrame:SetAttribute("unit", unitType)
								unitFrame.unit = unitType
							else
								if unitType == "pet" then
									unitFrame:SetAttribute("unit", "partypet" .. u - 1)
									unitFrame.unit = "partypet" .. u - 1
								elseif unitType == "target" then
									unitFrame:SetAttribute("unit", "party" .. u - 1 .. "target")
									unitFrame.unit = "party" .. u - 1 .. "target"
								end
							end
						end
					end

					if profile == "partypet" or profile == "partytarget" then
						local unitType = string.gsub(profile, "party", "")
						local prefix, suffix
						if profile == "partypet" then
							prefix = "pet"
							suffix = ""
						elseif profile == "partytarget" then
							prefix = ""
							suffix = "target"
						end
						if RUF.db.profile.unit.party.showPlayer and unitFrame then
							if u == 1 then
								unitFrame:SetAttribute("unit", unitType)
								unitFrame.unit = unitType
							else
								unitFrame:SetAttribute("unit", "party" .. prefix .. u - 1 .. suffix)
								unitFrame.unit = "party" .. prefix .. u - 1 .. suffix
							end
						end
					end
				end
			end
		end
	end	)

	RUF.PixelScale()

	if RUF.uClass == "DEATHKNIGHT" then
		-- Cannot disable elements before the unit is actually spawned?
		-- TODO Check other elements and make sure we do this properly for them too.
		if RUF.db.profile.unit["player"].Frame.Bars.Class.Enabled == false then
			oUF_RUF_Player:DisableElement("Runes")
		end
	end

	if not RUF.db.profile.unit.party.showPlayer then
		if _G["oUF_RUF_Party5Target"] then
			_G["oUF_RUF_Party5Target"]:Disable()
		end
	end

	-- it sadly has to be delayed!
	RUF:UpdateAllUnitSettings()
end