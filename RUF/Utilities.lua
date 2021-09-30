assert(RUF, "RUF not found!")
local RUF = RUF
local LSM = LibStub('LibSharedMedia-3.0')
local _, ns = ...
local oUF = ns.oUF

local Round = RUF.Round
local GetPhysicalScreenSize = RUF.GetPhysicalScreenSize
local IsInGroup, IsInRaid = RUF.IsInGroup, RUF.IsInRaid

function RUF:Print_Self(message) -- Send a message to your default chat window.
	ChatFrame1:AddMessage("|c5500DBBDRaeli's Unit Frames|r: " .. format(message))
end

function RUF:PopUp(name, message, button1value, button2value, acceptfunc)
	StaticPopupDialogs[name] = {
		text = message,
		button1 = button1value,
		button2 = button2value,
		OnAccept = acceptfunc, --function()
			--GreetTheWorld()
			--ReloadUI()
		--end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = false,
		showAlert = true,
		preferredIndex = 3, -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
	}
end

function RUF:IconTextureTrim(trim, w, h)
	local left, right, top, bottom = 0, 1, 0, 1 -- default without trim
	if trim then left = 0.05; right = 0.95; top = 0.05; bottom = 0.95 end
	if w > h then -- rectangular with width greater than height
		local crop = (bottom - top) * (w - h)/ w / 2 -- aspect ratio to reduce height by
		top = top + crop; bottom = bottom - crop
	elseif h > w then -- rectangular with height greater than width
		local crop = (right - left) * (h - w)/ h / 2 -- aspect ratio to reduce height by
		left = left + crop; right = right - crop
	end
	return left, right, top, bottom
end

function RUF:copyTable(src, dest)
	if type(dest) ~= 'table' then dest = {} end
	if type(src) == 'table' then
		for k, v in pairs(src) do
			if type(v) == 'table' then
				-- try to index the key first so that the metatable creates the defaults, if set, and use that table
				v = RUF:copyTable(v, dest[k])
			end
			--if dest[k] then
			--else
				dest[k] = v
			--end
		end
	end
	return dest
end

function RUF:Short(value, format)
	if type(value) == 'number' then
		local fmt
		local gsub
		if value >= 1000000000 or value <= -1000000000 then
			fmt = '%.1fB'
			value = value / 1000000000
		elseif value >= 10000000 or value <= -10000000 then
			fmt = '%.1fM'
			value = value / 1000000
		elseif value >= 1000000 or value <= -1000000 then
			fmt = '%.2fM'
			value = value / 1000000
		elseif value >= 100000 or value <= -100000 then
			fmt = '%.0fK'
			value = value / 1000
		elseif value >= 10000 or value <= -10000 then
			fmt = '%.1fK'
			value = value / 1000
		elseif value >= 1000 or value <= -1000 then
			gsub = string.gsub(value, '^(-?%d+)(%d%d%d)', '%1,%2')
		else
			fmt = '%d'
			value = math.floor(value + 0.5)
		end
		if format then
			if gsub then
				return gsub
			else
				return fmt:format(value)
			end
		end
		return fmt, value
	else
		local fmt_a, fmt_b
		local a, b = value:match('^(%d+)/(%d+)$')
		if a then
			a, b = tonumber(a), tonumber(b)
			if a >= 1000000000 or a <= -1000000000 then
				fmt_a = '%.1fB'
				a = a / 1000000000
			elseif a >= 10000000 or a <= -10000000 then
				fmt_a = '%.1fM'
				a = a / 1000000
			elseif a >= 1000000 or a <= -1000000 then
				fmt_a = '%.2fM'
				a = a / 1000000
			elseif a >= 100000 or a <= -100000 then
				fmt_a = '%.0fK'
				a = a / 1000
			elseif a >= 10000 or a <= -10000 then
				fmt_a = '%.1fK'
				a = a / 1000
			elseif a >= 1000 or a <= -1000 then
				fmt_a = '%s'
				a = string.gsub(a, '^(-?%d+)(%d%d%d)', '%1,%2')
			end
			if b >= 1000000000 or b <= -1000000000 then
				fmt_b = '%.1fB'
				b = b / 1000000000
			elseif b >= 10000000 or b <= -10000000 then
				fmt_b = '%.1fM'
				b = b / 1000000
			elseif b >= 1000000 or b <= -1000000 then
				fmt_b = '%.2fM'
				b = b / 1000000
			elseif b >= 100000 or b <= -100000 then
				fmt_b = '%.0fK'
				b = b / 1000
			elseif b >= 10000 or b <= -10000 then
				fmt_b = '%.1fK'
				b = b / 1000
			elseif b >= 1000 or b <= -1000 then
				fmt_b = '%s'
				b = string.gsub(b, '^(-?%d+)(%d%d%d)', '%1,%2')
			end
			local fmt = ('%s/%s'):format(fmt_a, fmt_b)
			if format then
				return fmt:format(a, b)
			end
			return fmt, a, b
		else
			return value
		end
	end
end

function RUF:Round(number, digits)
	local mantissa = 10^(digits or 0)
	local norm = number * mantissa + 0.5
	local norm_floor = math.floor(norm)
	if norm == norm_floor and (norm_floor % 2) == 1 then
		return (norm_floor - 1) / mantissa
	end
	return norm_floor / mantissa
end

function RUF:Percent(x, y)
	if y ~= 0 then
		return Round(x / y * 100, 1)
	end
	return 0
end

function RUF:ColorsAndPercent(a, b, ...)
	if(a <= 0 or b == 0) then
		return nil, ...
	elseif(a >= b) then
		return nil, select(select('#', ...) - 2, ...)
	end

	local num = select('#', ...) / 3
	local segment, relperc = math.modf((a / b) * (num - 1))
	return relperc, select((segment * 3) + 1, ...)
end

function RUF:ColorGradient(...)
	local relperc, r1, g1, b1, r2, g2, b2 = RUF:ColorsAndPercent(...)
	if(relperc) then
		return r1 + (r2 - r1) * relperc, g1 + (g2 - g1) * relperc, b1 + (b2 - b1) * relperc
	else
		return r1, g1, b1
	end
end

function RUF:HSLtoRGB(h, s, l)
	if s == 0 then return l, l, l end
	local function to(p, q, t)
		if t < 0 then t = t + 1 end
		if t > 1 then t = t - 1 end
		if t < .16667 then return p + (q - p) * 6 * t end
		if t < .5 then return q end
		if t < .66667 then return p + (q - p) * (.66667 - t) * 6 end
		return p
	end
	local q = l < .5 and l * (1 + s) or l + s - l * s
	local p = 2 * l - q
	return to(p, q, h + .33334), to(p, q, h), to(p, q, h - .33334)
end

function RUF:RGBtoHSL(r, g, b)
	local max, min = math.max(r, g, b), math.min(r, g, b)
	local t = max + min
	local d = max - min
	local h, s, l

	if t == 0 then return 0, 0, 0 end
	l = t / 2

	s = l > .5 and d / (2 - t) or d / t

	if max == r then
		h = (g - b) / d + (g < b and 6 or 0)
	elseif max == g then
		h = (b - r) / d + 2
	elseif max == b then
		h = (r - g) / d + 4
	end

	h = h * 0.16667

	return h, s, l
end

local firstH, firstS, firstL = RUF:RGBtoHSL(255/255, 151/255, 3/255)
local secondH, secondS, secondL = RUF:RGBtoHSL(RUF:HSLtoRGB( ((firstH * 360) + 67) / 360, firstS, firstL))
function RUF:UpdateRainbow()
	firstH = firstH + (1/360)
	secondH = secondH + (1/360)
	if firstH > 1 then
		firstH = 1/360
	end
	if secondH > 1 then
		secondH = 1/360
	end
end

function RUF:GetRainbow()
	local a,b,c = RUF:HSLtoRGB(firstH, firstS, firstL)
	local x,y,z = RUF:HSLtoRGB(secondH, secondS, secondL)
	return a,b,c,x,y,z
end

local function AlphaAnimationDataUpdate(self)
	local parent = self:GetParent()
	self:GetParent().Alpha.current = parent:GetAlpha()
end

function RUF.AnimateAlpha(self, to, duration)
	self.Alpha.current = self:GetAlpha()
	self.Alpha.target = to or 1

	if not self.Animator then
		local animationGroup = self:CreateAnimationGroup()
		self.Animator = animationGroup
		local animation = animationGroup:CreateAnimation('Alpha')
		self.Animator.animation = animation
	end

	local animationGroup = self.Animator
	local animation = self.Animator.animation

	if animationGroup:IsPlaying() then animationGroup:Stop() end
	animation:SetFromAlpha(self.Alpha.current)
	animation:SetToAlpha(self.Alpha.target)
	animation:SetDuration(duration)
	animationGroup:Play()
	animationGroup:SetToFinalAlpha(true)
	animationGroup:SetScript('OnUpdate', AlphaAnimationDataUpdate)
end

function RUF:FrameIsDependentOnFrame(frame, otherFrame)
	if (frame and otherFrame) then
		if frame == otherFrame then
			return true
		end
		local points = frame:GetNumPoints()
		for i = 1, points do
			local point, parent, relative, x, y  = frame:GetPoint(i)
			if RUF:FrameIsDependentOnFrame(parent, otherFrame) then
				return true
			end
		end
	end
end

function RUF:CanAttach(frame, otherFrame)
	if not(frame and otherFrame) then
		return
	elseif frame:GetNumPoints() == 0 or otherFrame:GetNumPoints() == 0 then
		return
	elseif frame:GetWidth() == 0 or frame:GetHeight() == 0 or otherFrame:GetWidth() == 0 or otherFrame:GetHeight() == 0 then
		return
	elseif RUF:FrameIsDependentOnFrame(otherFrame, frame) then
		return
	end
	return true
end

function RUF.GetIndicatorAnchorFrame(self, unit, indicator)
	-- TODO: Anchor to element (health, power)

	local AnchorFrame = 'Frame'
	if RUF.db.profile.unit[unit].Frame.Indicators[indicator].Position.AnchorFrame == 'Frame' then
		AnchorFrame = self:GetName()
	else
		AnchorFrame = self:GetName() .. '.' .. RUF.db.profile.unit[unit].Frame.Indicators[indicator].Position.AnchorFrame .. 'Indicator'
		if not _G[AnchorFrame] then
			AnchorFrame = self:GetName()
		end
	end
	return AnchorFrame
end

function RUF.GetLevelColor(self, level, unit)
	if level <= 0 then level = 500 end
	local color = GetQuestDifficultyColor(level)
	local index = 4

	if color.font == 'QuestDifficulty_Impossible' then
		index = 0
	elseif color.font == 'QuestDifficulty_VeryDifficult' then
		index = 1
	elseif color.font == 'QuestDifficulty_Difficult' then
		index = 2
	elseif color.font == 'QuestDifficulty_Standard' then
		index = 3
	elseif color.font == 'QuestDifficulty_Trivial' then
		index = 4
	end

	-- if RUF.Client == 1 and unit then
	-- 	if UnitIsWildBattlePet(unit) or UnitIsBattlePetCompanion(unit) then
	-- 		local petLevel = UnitBattlePetLevel(unit)
	-- 		if petLevel < 9 then
	-- 			index = 4
	-- 		elseif petLevel < 17 then
	-- 			index = 3
	-- 		elseif petLevel < 21 then
	-- 			index = 2
	-- 		elseif petLevel < 24 then
	-- 			index = 1
	-- 		else
	-- 			index = 0
	-- 		end
	-- 	end
	-- end

	local r, g, b = unpack(RUF.db.profile.Appearance.Colors.DifficultyColors[index])
	return r, g, b
end

function RUF.ReturnTextColors(self, unit, tag, cur, max, test) -- Get Text Colors
	local r, g, b = unpack(RUF.db.profile.Appearance.Text[tag].Color.BaseColor)
	local _, class = UnitClass(unit)

	if not class then class = 'PRIEST' end
	if not cur then
		cur = UnitHealth(unit)
	end
	if not max then
		max = UnitHealthMax(unit)
	end
	if RUF.db.profile.Appearance.Text[tag].Color.Percentage and RUF.db.profile.Appearance.Text[tag].Color.PercentageAtMax and cur == max then -- If we want to show gradient colors at max health, and we're at max health.
		r, g, b = RUF:ColorGradient(cur, max, unpack(RUF.db.profile.Appearance.Text[tag].Color.PercentageGradient))
	elseif RUF.db.profile.Appearance.Text[tag].Color.Percentage and cur < max and cur > 0 then -- If we want to show gradient colors and we're not at max health.
		r, g, b = RUF:ColorGradient(cur, max, unpack(RUF.db.profile.Appearance.Text[tag].Color.PercentageGradient))
	elseif RUF.db.profile.Appearance.Text[tag].Color.Class and UnitIsPlayer(unit) then -- If we want to show class colors.
		r, g, b = unpack(RUF.db.profile.Appearance.Colors.ClassColors[class])
	elseif RUF.db.profile.Appearance.Text[tag].Color.Reaction then -- If we want to show unit reaction colors
		if UnitPlayerControlled(unit) and not UnitCanAttack(unit, 'player') and not UnitIsPlayer(unit) then -- If the unit is an allied pet then show as blue.
			r, g, b = unpack(RUF.db.profile.Appearance.Colors.ReactionColors[10])
		elseif UnitReaction(unit, 'player') then -- If the unit is an offline party member, possibly others too?
			r, g, b = unpack(RUF.db.profile.Appearance.Colors.ReactionColors[UnitReaction(unit, 'player')])
		elseif UnitInParty(unit) then
			r, g, b = unpack(RUF.db.profile.Appearance.Colors.ReactionColors[5]) -- So Reaction Works when Party member is in a different zone and UnitReaction returns nil
		else
			r, g, b = unpack(RUF.db.profile.Appearance.Text[tag].Color.BaseColor)
		end
	elseif RUF.db.profile.Appearance.Text[tag].Color.Level then
		local level = UnitLevel(unit)
		if level <= 0 then level = 500 end
		r, g, b = RUF:GetLevelColor(level, unit)
	elseif RUF.db.profile.Appearance.Text[tag].Color.PowerType then -- Color by UnitPower (Mana, Rage, etc.)
		if tag == 'CurMana' or tag == 'ManaPerc' or tag == 'CurManaPerc' then
			r, g, b = unpack(RUF.db.profile.Appearance.Colors.PowerColors[0])
		else
			local pType, pToken, altr, altg, altb = UnitPowerType(unit)
			r, g, b = unpack(RUF.db.profile.Appearance.Colors.PowerColors[pType])
		end
	else -- If none of that matches, show the base colour
		r, g, b = unpack(RUF.db.profile.Appearance.Text[tag].Color.BaseColor)
	end
	return r, g, b
end

function RUF.TogglePartyChildrenGroupStatus()
	RUF.TogglePartyChildren('partypet')
	RUF.TogglePartyChildren('partytarget')
end

function RUF.TogglePartyChildren(childUnit) -- TODO: Implement this better.
	if InCombatLockdown() then return end

	local unitFrame
	local showRaid = RUF.db.profile.unit[childUnit].showRaid or false
	local enable = RUF.db.profile.unit[childUnit].Enabled or false
	local numFrames = 4
	if RUF.db.profile.unit.party.showPlayer then -- Use party setting, if we don'y have 5 party units, we don't have 5 party targets.
		numFrames = 5
	end

	local shouldShow = false
	if IsInRaid() then
		if showRaid and enable then
			shouldShow = true
		else
			shouldShow = false
		end
	elseif IsInGroup() then
		if enable then
			shouldShow = true
		else
			shouldShow = false
		end
	else
			shouldShow = false
	end

	for i = 1,5 do
		if childUnit == 'partypet' then
			unitFrame = _G['oUF_RUF_PartyPet' .. i]
		elseif childUnit == 'partytarget' then
			unitFrame = _G['oUF_RUF_Party' .. i .. 'Target']
		end
		if shouldShow then
			if not unitFrame:IsEnabled() then
				if numFrames < 5 then
					if i < 5 then
						unitFrame:Enable()
					else
						unitFrame:Disable()
					end
				else
					unitFrame:Enable()
				end
			elseif numFrames < 5 then
				if i == 5 then
					unitFrame:Disable()
				end
			end
		elseif unitFrame then
			unitFrame:Disable()
		end
	end

end

function RUF.RefreshTextElements(singleFrame, groupFrame, header, groupNum)
	if not singleFrame then singleFrame = 'none' end
	if not groupFrame then groupFrame = 'none' end
	if not header then header = 'none' end
	local currentUnit, unitFrame, profileReference
	if header ~= 'none' then
		currentUnit = header .. 'UnitButton' .. groupNum
	elseif groupFrame ~= 'none' then
		currentUnit = groupFrame .. groupNum
	elseif singleFrame ~= 'none' then
		currentUnit = singleFrame
	else
		return
	end

	unitFrame = _G['oUF_RUF_' .. currentUnit]

	local profileTexts = {}
	for k, v in pairs(RUF.db.profile.unit[unitFrame.frame].Frame.Text) do
		if v ~= '' then
			table.insert(profileTexts, k)
		end
	end

	local existingTexts = { unitFrame.Text:GetChildren() }
	for old = 1, #existingTexts do
		local currentText = existingTexts[old]
		local currentTextName = currentText:GetName()
		for new = 1, #profileTexts do
			local newTextName = 'oUF_RUF_' .. currentUnit .. '.Text.' .. profileTexts[new]
			local exists = false
			if currentTextName == newTextName then
				currentText:Show()
				break
			end
			if exists == false then
				currentText:Hide()
				unitFrame:Untag(currentText)
			end
		end
	end

	for new = 1, #profileTexts do
		local currentTextName = 'oUF_RUF_' .. currentUnit .. '.Text.' .. profileTexts[new]
		if not _G[currentTextName] then
			RUF.CreateTextArea(unitFrame, unitFrame.frame, profileTexts[new])
			RUF.SetTextPoints(unitFrame, unitFrame.frame, profileTexts[new])
		end
	end

end

function RUF.PixelScale()
	local RUFParent = RUF.UIParent
	if RUF.db.global.pixelScale then
		local screenHeight = select(2,GetPhysicalScreenSize())
		local pixelSize = GetScreenHeight() / screenHeight
		local gamePixelSize = UIParent:GetEffectiveScale() * pixelSize
		local compareHeight = (768 / gamePixelSize) - screenHeight
		if math.abs(compareHeight) < 1 then
			RUFParent:SetScale(gamePixelSize)
		end
		if not RUF.PixelScaleMonitor then
			local monitor = CreateFrame('frame')
			monitor:RegisterEvent('UI_SCALE_CHANGED')
			monitor:RegisterEvent('DISPLAY_SIZE_CHANGED')
			monitor:SetScript('OnEvent', RUF.PixelScale)
			RUF.PixelScaleMonitor = monitor
		end
	else
		RUFParent:SetScale(1)
		if RUF.PixelScaleMonitor then
			RUF.PixelScaleMonitor:UnregisterAllEvents()
			RUF.PixelScaleMonitor:SetScript('OnEvent', nil)
			RUF.PixelScaleMonitor = nil
		end
	end
end

function RUF.ToggleFrameLock(status)
	local frames = RUF.frameList.frames
	local groupFrames = RUF.frameList.groupFrames
	local headers = RUF.frameList.headers

	if status == false then
		for i = 1, #frames do
			local anchorFrom1, anchorFrame1, anchorTo1, x1, y1, anchorFrom2, anchorFrame2, anchorTo2, x2, y2, x3, y3
			local frameName = _G['oUF_RUF_' .. frames[i]]
			if frameName then
				local profile = string.lower(frames[i])
				frameName:SetMovable(true)
				frameName:SetScript('OnMouseDown', function()
				frameName:StartMoving()
				anchorFrom1, anchorFrame1, anchorTo1, x1, y1 = frameName:GetPoint() end)

				frameName:SetScript('OnMouseUp', function()
				anchorFrom2, anchorFrame2, anchorTo2, x2, y2 = frameName:GetPoint()
				frameName:StopMovingOrSizing()
				x3 = x2-x1
				y3 = y2-y1
				RUF.db.profile.unit[profile].Frame.Position.x = RUF.db.profile.unit[profile].Frame.Position.x + x3
				RUF.db.profile.unit[profile].Frame.Position.y = RUF.db.profile.unit[profile].Frame.Position.y + y3
				frameName:ClearAllPoints()
				frameName:SetPoint(
					RUF.db.profile.unit[profile].Frame.Position.AnchorFrom,
					RUF.db.profile.unit[profile].Frame.Position.AnchorFrame,
					RUF.db.profile.unit[profile].Frame.Position.AnchorTo,
					RUF.db.profile.unit[profile].Frame.Position.x,
					RUF.db.profile.unit[profile].Frame.Position.y)
				LibStub('AceConfigRegistry-3.0'):NotifyChange('RUF') end)
			end
		end
		for i = 1, #groupFrames do
			local anchorFrom1, anchorFrame1, anchorTo1, x1, y1, anchorFrom2, anchorFrame2, anchorTo2, x2, y2, x3, y3
			local frameName = _G['oUF_RUF_' .. groupFrames[i] .. '1']
			if groupFrames[i]:match('Target') then
				frameName = _G['oUF_RUF_' .. groupFrames[i]:gsub('Target','') .. '1' .. 'Target']
			end
			local profile = string.lower(groupFrames[i])
			frameName:SetMovable(true)
			frameName:SetScript('OnMouseDown', function()
			frameName:StartMoving()
			anchorFrom1, anchorFrame1, anchorTo1, x1, y1 = frameName:GetPoint() end)

			frameName:SetScript('OnMouseUp', function()
			anchorFrom2, anchorFrame2, anchorTo2, x2, y2 = frameName:GetPoint()
			frameName:StopMovingOrSizing()
			x3 = x2-x1
			y3 = y2-y1
			RUF.db.profile.unit[profile].Frame.Position.x = RUF.db.profile.unit[profile].Frame.Position.x + x3
			RUF.db.profile.unit[profile].Frame.Position.y = RUF.db.profile.unit[profile].Frame.Position.y + y3
			frameName:ClearAllPoints()
			frameName:SetPoint(
				RUF.db.profile.unit[profile].Frame.Position.AnchorFrom,
				RUF.db.profile.unit[profile].Frame.Position.AnchorFrame,
				RUF.db.profile.unit[profile].Frame.Position.AnchorTo,
				RUF.db.profile.unit[profile].Frame.Position.x,
				RUF.db.profile.unit[profile].Frame.Position.y)
			LibStub('AceConfigRegistry-3.0'):NotifyChange('RUF') end)
		end
		for i = 1, #headers do
			local anchorFrom1, anchorFrame1, anchorTo1, x1, y1, anchorFrom2, anchorFrame2, anchorTo2, x2, y2, x3, y3
			local frameName = _G['oUF_RUF_' .. headers[i]]
			local MoveBG = frameName.MoveBG
			local profile = string.lower(headers[i])
			MoveBG:Show()
			frameName:SetMovable(true)
			MoveBG:SetMovable(true)

			MoveBG:SetScript('OnMouseDown', function(MoveBG)
			frameName:StartMoving()
			MoveBG:StartMoving()
			anchorFrom1, anchorFrame1, anchorTo1, x1, y1 = frameName:GetPoint() end)

			MoveBG:SetScript('OnMouseUp', function(MoveBG)
			anchorFrom2, anchorFrame2, anchorTo2, x2, y2 = frameName:GetPoint()
			frameName:StopMovingOrSizing()
			MoveBG:StopMovingOrSizing()
			x3 = x2-x1
			y3 = y2-y1
			RUF.db.profile.unit[profile].Frame.Position.x = RUF.db.profile.unit[profile].Frame.Position.x + x3
			RUF.db.profile.unit[profile].Frame.Position.y = RUF.db.profile.unit[profile].Frame.Position.y + y3
			frameName:ClearAllPoints()
			frameName:SetPoint(
				RUF.db.profile.unit[profile].Frame.Position.AnchorFrom,
				RUF.db.profile.unit[profile].Frame.Position.AnchorFrame,
				RUF.db.profile.unit[profile].Frame.Position.AnchorTo,
				RUF.db.profile.unit[profile].Frame.Position.x,
				RUF.db.profile.unit[profile].Frame.Position.y)
			LibStub('AceConfigRegistry-3.0'):NotifyChange('RUF') end)
		end
	else -- lock
		for i = 1, #frames do
			local frameName = 'oUF_RUF_' .. frames[i]
			if _G[frameName] then
				local profile = string.lower(frames[i])
				_G[frameName]:SetMovable(false)
				_G[frameName]:SetScript('OnMouseDown', nil)
				_G[frameName]:SetScript('OnMouseUp', nil)
			end
		end
		for i = 1, #groupFrames do
			local frameName = 'oUF_RUF_' .. groupFrames[i] .. '1'
			if groupFrames[i]:match('Target') then
				frameName = _G['oUF_RUF_' .. groupFrames[i]:gsub('Target','') .. '1' .. 'Target']
			end
			if _G[frameName] then
				local profile = string.lower(groupFrames[i])
				_G[frameName]:SetMovable(false)
				_G[frameName]:SetScript('OnMouseDown', nil)
				_G[frameName]:SetScript('OnMouseUp', nil)
			end
		end
		for i = 1, #headers do
			local frameName = 'oUF_RUF_' .. headers[i]
			if _G[frameName] then
				local MoveBG = _G[frameName .. '.MoveBG']
				MoveBG:Hide()
				MoveBG:SetMovable(false)
				_G[frameName]:SetMovable(false)
				MoveBG:SetScript('OnMouseDown', nil)
				MoveBG:SetScript('OnMouseUp', nil)
			end
		end
	end

end