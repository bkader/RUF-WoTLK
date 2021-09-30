assert(RUF, "RUF not found!")
local RUF = RUF
local L = LibStub('AceLocale-3.0'):GetLocale('RUF')
local LSM = LibStub('LibSharedMedia-3.0')
local _, ns = ...
local oUF = ns.oUF
local PlayerClass = select(2, UnitClass('player'))

local IsInGroup, GetNumSubgroupMembers = RUF.IsInGroup, RUF.GetNumSubgroupMembers

local function SetClassColors()
	local function customClassColors()
		if(CUSTOM_CLASS_COLORS) and RUF.db.profile.Appearance.Colors.UseClassColors then
			local function updateColors()
				for classToken, color in next, CUSTOM_CLASS_COLORS do
					RUF.db.profile.Appearance.Colors.ClassColors[classToken] = {(color.r), (color.g), (color.b)}
				end
				for _, obj in next, oUF.objects do
					obj:UpdateAllElements('CUSTOM_CLASS_COLORS')
				end
			end
			updateColors()
			CUSTOM_CLASS_COLORS:RegisterCallback(updateColors)
			return true
		end
	end
	if(not customClassColors()) then
		local eventHandler = CreateFrame('Frame')
		eventHandler:RegisterEvent('ADDON_LOADED')
		eventHandler:SetScript('OnEvent', function(self)
			if(customClassColors()) then
				self:UnregisterEvent('ADDON_LOADED')
				self:SetScript('OnEvent', nil)
			end
		end)
	end
end

local function SetupFrames(self, unit)
	unit = unit:gsub('%d+', '') or unit

	self.frame = unit
	local profileReference = RUF.db.profile.unit[unit]

	self:SetFrameLevel(5)

	-- Set Colors
	if RUF.Client == 1 then
		SetClassColors()
	end

	self:RegisterForClicks('AnyUp')
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)

	-- Frame Size
	self:SetHeight(profileReference.Frame.Size.Height)
	self:SetWidth(profileReference.Frame.Size.Width)
	self:SetClampedToScreen(true)

	-- Frame Border
	RUF.SetFrameBorder(self, unit)

	-- Aura Highlight Border
	if not unit:match('%w+target') then
		RUF.SetGlowBorder(self, unit)
	end

	-- Toggle Party Targets in raid
	if unit:match('partytarget') or unit:match('partypet') then
		if not RUF.PartyTargetMonitor then
			RUF.PartyTargetMonitor = CreateFrame('Frame')
			RUF.PartyTargetMonitor:RegisterEvent('PARTY_MEMBERS_CHANGED')
			RUF.PartyTargetMonitor:RegisterEvent('RAID_ROSTER_UPDATE')
			RUF.PartyTargetMonitor:RegisterEvent('PLAYER_ENTERING_WORLD')
			RUF.PartyTargetMonitor:SetScript('OnEvent',RUF.TogglePartyChildrenGroupStatus)
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

	if RUF.Client == 1 then
		-- Prevents trying to load these elements for Classic since they don't exist in Classic.
		RUF.SetAbsorbBar(self, unit)
		self.Absorb.Override = RUF.AbsorbUpdate

		if unit == 'player' then
			self:SetAttribute('toggleForVehicle', profileReference.toggleForVehicle or false) -- TODO Implement option for this
			RUF.SetClassBar(self, unit) -- Normal Class Power bar
			RUF.SetFakeClassBar(self, unit) -- Fake Clone Bar for Insanity/Maelstrom/Lunar Power
			RUF.SetRunes(self, unit)
			RUF.SetStagger(self, unit)
		end
		if unit == 'pet' then
			self:SetAttribute('toggleForVehicle', RUF.db.profile.unit['player'].toggleForVehicle or false)
		end

	else
		if unit == 'player' then
			RUF.SetClassicClassBar(self, unit)
		end
	end

	-- Frame Portrait
	RUF.SetFramePortrait(self, unit)


	if unit == 'player' or unit == 'target' then
		RUF.SetCastBar(self, unit)
	end
	if RUF.Client == 1 and unit == 'focus' then
		RUF.SetCastBar(self, unit)
	end

	RUF.SetTextParent(self, unit)
	local texts = {}
	for k, v in pairs(profileReference.Frame.Text) do
		if type(v) == 'table' then
			table.insert(texts, k)
		elseif type(v) == 'string' then
			 if v ~= '' then
				RUF.db.profile.unit[unit].Frame.Text[k] = ''
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
		self:DisableElement('Aura_Plugin')
	end
	if RUF.db.profile.unit[self.frame].Debuffs.Icons.Enabled == false then
		self.Debuff.Enabled = false
		self:DisableElement('Aura_Plugin')
	end

	-- Indicators
	RUF.SetIndicators(self, unit)

	if RUF.Client == 1 then
		self:RegisterEvent('ACTIVE_TALENT_GROUP_CHANGED', RUF.SetBarLocation, true)
		self:RegisterEvent('PLAYER_ENTERING_WORLD', RUF.SetBarLocation, true)
	end

	RUF.SetBarLocation(self, unit)

	if unit ~= 'player' then
		if not self.RangeCheck then
			self.RangeCheck = {}
		end
		self.RangeCheck.enabled = profileReference.Frame.RangeFading.Enabled
		self.RangeCheck.insideAlpha = 1
		self.RangeCheck.outsideAlpha = profileReference.Frame.RangeFading.Alpha or 0.55
		self.RangeCheck.PostUpdate = RUF.RangeCheckPostUpdate
		self.RangeCheck.Override = RUF.RangeCheckUpdate
	end

	self.Alpha = {}
	self.Alpha.current = 1

end

local function VariantWarning()
	local variantString, clientString
	if RUF.variant == WOW_PROJECT_CLASSIC then
		variantString = L["Classic"]
	else
		variantString = L["Retail"]
	end
	if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
		clientString = L["Classic"]
	else
		clientString = L["Retail"]
	end

	local message = L["You have the %s version of RUF installed, but you are playing %s. Please install a compatible version."]:format(variantString, clientString)
	local messagePrefix = "|c5500DBBDRaeli's Unit Frames|r: "

	RUF.After(10, function() ChatFrame1:AddMessage(messagePrefix .. message) end)

	local window = CreateFrame('Frame', 'RUF_VariantWarning', UIParent)
	window:SetWidth(500)
	window:SetHeight(250)
	window:SetPoint('CENTER')

	local text = window:CreateFontString(nil, 'OVERLAY', 'Raeli')
	local font = LSM:Fetch('font', 'RUF')
	text:SetFont('Interface\\Addons\\RUF\\Media\\TGL.ttf', 28, 'OUTLINE')
	text:SetText(messagePrefix .. message)
	text:SetAllPoints(window)

	-- local windowAnimation = window:CreateAnimationGroup()
	-- local alphaAnimation = windowAnimation:CreateAnimation("Alpha")
	-- alphaAnimation:SetFromAlpha(1)
	-- alphaAnimation:SetToAlpha(0)
	-- alphaAnimation:SetDuration(3)
	-- alphaAnimation:SetStartDelay(20)
	-- alphaAnimation:SetSmoothing("OUT")

	-- window.windowAnimation = windowAnimation
	-- window.alphaAnimation = alphaAnimation
	window:RegisterEvent('PLAYER_ENTERING_WORLD')
	-- window:SetScript("OnEvent", function() window.windowAnimation:Play() end)
	-- windowAnimation:SetScript("OnFinished", function() window:Hide() end)
end

function RUF:OnEnable()
	-- if RUF.Variant ~= WOW_PROJECT_ID then -- Since the Twitch client seems to so frequently download the wrong version.
	-- 	VariantWarning()
	-- 	return
	-- end

	if RUF.FirstRun then
		local function FirstRunReload()
			ReloadUI()
		end
		RUF:PopUp('RUFFirstRun', L["RUF [|c5500DBBDRaeli's Unit Frames|r] needs to reload your UI to properly finish installing on first use. Please do this now."], L["Accept"], nil, FirstRunReload)
		StaticPopup_Show('RUFFirstRun')
	end

	-- Set RUF stored nickname to one from NickTag so we can have the options menu display correctly (displaying blank if a nickname is not set)
	RUF:NickTagSetCache(RUF.db.char.NickCache) -- We have to store per char because NickTag looks for character saved variables.
	local nickName = RUF:GetNickname(UnitName('player'), false, true) or UnitName('player')
	if RUF.db.char.Nickname ~= '' then
		if nickName ~= UnitName('player') then
			RUF.db.char.Nickname = nickName
		else
			RUF.db.char.Nickname = ""
		end
	end

	-- Register Combat Fader
	RUF.CombatFaderRegister()

	oUF:RegisterStyle('RUF_', SetupFrames)
	oUF:Factory(function(self)
		self:SetActiveStyle('RUF_')

		-- Spawn single unit frames
		local frames = RUF.frameList.frames
		local groupFrames = RUF.frameList.groupFrames
		local headers = RUF.frameList.headers

		for i = 1, #frames do
			local profile = string.lower(frames[i])
			if _G['oUF_RUF_' .. frames[i]] then
				if _G['oUF_RUF_' .. frames[i]]:GetObjectType() ~= 'Button' then
					_G['oUF_RUF_' .. frames[i]] = nil
				end
			end
			local anchorFrame = RUF.db.profile.unit[profile].Frame.Position.AnchorFrame
			if not _G[RUF.db.profile.unit[profile].Frame.Position.AnchorFrame] then
				anchorFrame = 'UIParent'
			end
			self:Spawn(profile):SetPoint(
				RUF.db.profile.unit[profile].Frame.Position.AnchorFrom,
				anchorFrame,
				RUF.db.profile.unit[profile].Frame.Position.AnchorTo,
				RUF.db.profile.unit[profile].Frame.Position.x,
				RUF.db.profile.unit[profile].Frame.Position.y)
			if RUF.db.profile.unit[profile].Enabled == false and _G['oUF_RUF_' .. frames[i]] then
				_G['oUF_RUF_' .. frames[i]]:Disable()
			else

			end
		end

		-- Spawn Headers
		for i = 1, #headers do
			for j = 4, 1 do
				if _G['oUF_RUF_' .. headers[i] .. 'UnitButton' .. j] then
					if _G['oUF_RUF_' .. headers[i] .. 'UnitButton' .. j]:GetObjectType() ~= 'Button' then
						_G['oUF_RUF_' .. headers[i] .. 'UnitButton' .. j] = nil
					end
				end
			end
			local profile = RUF.db.profile.unit[string.lower(headers[i])]
			local template = 'SecureGroupHeaderTemplate'
			if headers[i] == 'PartyPet' then template = 'SecureGroupPetHeaderTemplate' end
			local anchorFrom
			if profile.Frame.Position.growth == 'BOTTOM' then
				anchorFrom = 'TOP'
			elseif profile.Frame.Position.growth == 'TOP' then
				anchorFrom = 'BOTTOM'
			end

			local growthDirection
			if profile.Frame.Position.growthDirection then
				if profile.Frame.Position.growthDirection == 'VERTICAL' then
					growthDirection = 5
				elseif profile.Frame.Position.growthDirection == 'HORIZONTAL' then
					growthDirection = 1
				end
			end

			local showIn = 'party'
			if profile.showRaid then
				showIn = 'party, raid'
			end
			if profile.showArena then
				showIn = '[@arena1,exists]show;[@arena2,exists]show;[@arena3,exists]show;' .. showIn
			end

			local startingIndex = -3

			self:SpawnHeader(
				'oUF_RUF_' .. headers[i], template, showIn,
				'showSolo', false,
				'showParty', true,
				'showRaid', false,
				'showPlayer', profile.showPlayer,
				'yOffset', profile.Frame.Position.offsety,
				'unitsPerColumn', growthDirection,
				'maxColumns', 5,
				'columnSpacing', profile.Frame.Position.offsetx,
				'columnAnchorPoint', profile.Frame.Position.growthHoriz,
				'Point', anchorFrom
			):SetPoint(
				profile.Frame.Position.AnchorFrom,
				profile.Frame.Position.AnchorFrame,
				profile.Frame.Position.AnchorTo,
				profile.Frame.Position.x,
				profile.Frame.Position.y)

			local partyNum = 0
			if IsInGroup() then
				partyNum = GetNumSubgroupMembers()
			end
			local currentHeader = _G['oUF_RUF_' .. headers[i]]
			currentHeader.Enabled = profile.Enabled
			currentHeader:SetAttribute('startingIndex', startingIndex + partyNum)
			currentHeader:Show()
			currentHeader:SetAttribute('startingIndex', 1)
			currentHeader:SetClampedToScreen(true)
			currentHeader:SetAttribute('state-visibility', currentHeader.visibility)
			if profile.Enabled == false then
				for j = 1, 5 do
					local disableFrame = _G['oUF_RUF_' .. headers[i] .. 'UnitButton' .. j]
					if disableFrame then
						_G['oUF_RUF_' .. headers[i] .. 'UnitButton' .. j]:Disable()
					end
				end
			end

			-- Create Party Holder for dragging.
			local MoveBG = CreateFrame('Frame', currentHeader:GetName() .. '.MoveBG', currentHeader)
			MoveBG:SetAllPoints(currentHeader)
			local Background = MoveBG:CreateTexture(currentHeader:GetName() .. '.MoveBG.BG', 'BACKGROUND')
			Background:SetTexture(LSM:Fetch('background', 'Solid'))
			Background:SetAllPoints(MoveBG)
			Background:SetVertexColor(0, 0, 0, 0)
			MoveBG:SetFrameStrata('HIGH')
			MoveBG:Hide()
			currentHeader.MoveBG = MoveBG
		end

		-- Spawn single frames for Boss, Arena, and Party Targets
		for i = 1, #groupFrames do
			local frameName = 'oUF_RUF_' .. groupFrames[i]
			local profile = string.lower(groupFrames[i])
			local AnchorFrom
			if RUF.db.profile.unit[profile].Frame.Position.growth == 'BOTTOM' then
				AnchorFrom = 'TOP'
			elseif RUF.db.profile.unit[profile].Frame.Position.growth == 'TOP' then
				AnchorFrom = 'BOTTOM'
			end
			for u = 1, 5 do
				local unitName = groupFrames[i] .. u
				if groupFrames[i]:match('Target') then
					unitName = groupFrames[i]:gsub('Target', '') .. u .. 'Target'
				end
				local frame = self:Spawn(unitName)
				local unitFrame = _G['oUF_RUF_' .. unitName]
				if unitFrame then
					if unitFrame:GetObjectType() ~= 'Button' then
						unitFrame = nil
					end
				end
				if u == 1 then
					frame:SetPoint(
						RUF.db.profile.unit[profile].Frame.Position.AnchorFrom,
						RUF.db.profile.unit[profile].Frame.Position.AnchorFrame,
						RUF.db.profile.unit[profile].Frame.Position.AnchorTo,
						RUF.db.profile.unit[profile].Frame.Position.x,
						RUF.db.profile.unit[profile].Frame.Position.y)
				else
					local previousUnit = _G[frameName .. u -1]
					if groupFrames[i]:match('Target') then
						previousUnit = _G['oUF_RUF_' .. groupFrames[i]:gsub('Target', '') .. u -1 .. 'Target']
					end
					frame:SetPoint(
						AnchorFrom,
						previousUnit,
						RUF.db.profile.unit[profile].Frame.Position.growth,
						RUF.db.profile.unit[profile].Frame.Position.offsetx,
						RUF.db.profile.unit[profile].Frame.Position.offsety)
				end
				if RUF.db.profile.unit[profile].Enabled == false and unitFrame then
					unitFrame:Disable()
					unitFrame:SetAttribute('oUF-enableArenaPrep', false)
				end

				if profile == 'partypet' or profile == 'partytarget' then
					local unitType = string.gsub(profile, 'party', '')
					if RUF.db.profile.unit.party.showPlayer then
						if u == 1 then
							unitFrame:SetAttribute('unit', unitType)
							unitFrame.unit = unitType
						else
							if unitType == 'pet' then
								unitFrame:SetAttribute('unit', 'partypet' .. u-1)
								unitFrame.unit = 'partypet' .. u-1
							elseif unitType == 'target' then
								unitFrame:SetAttribute('unit', 'party' .. u-1 .. 'target')
								unitFrame.unit = 'party' .. u-1 .. 'target'
							end
						end
					end
				end

				if profile == 'partypet' or profile == 'partytarget' then
					local unitType = string.gsub(profile, 'party', '')
					local prefix,suffix
					if profile == 'partypet' then
						prefix = 'pet'
						suffix = ''
					elseif profile == 'partytarget' then
						prefix = ''
						suffix = 'target'
					end
					if RUF.db.profile.unit.party.showPlayer then
						if u == 1 then
							unitFrame:SetAttribute('unit', unitType)
							unitFrame.unit = unitType
						else
							unitFrame:SetAttribute('unit', 'party' .. prefix .. u-1 .. suffix)
							unitFrame.unit = 'party' .. prefix .. u-1 .. suffix
						end
					end
				end

			end
		end
	end)

	RUF.PixelScale()

	if PlayerClass == 'DEATHKNIGHT' then
		-- Cannot disable elements before the unit is actually spawned?
		-- TODO Check other elements and make sure we do this properly for them too.
		if RUF.db.profile.unit['player'].Frame.Bars.Class.Enabled == false then
			oUF_RUF_Player:DisableElement('Runes')
		end
	end

	if not RUF.db.profile.unit.party.showPlayer then
		if _G['oUF_RUF_Party5Target'] then
			_G['oUF_RUF_Party5Target']:Disable()
		end
	end

	RUF:UpdateAllUnitSettings()
end