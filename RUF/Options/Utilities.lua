assert(RUF, "RUF not found!")
local RUF = RUF
local L = LibStub('AceLocale-3.0'):GetLocale('RUF')
local RUF_Options = RUF:GetModule('Options')
local LSM = LibStub('LibSharedMedia-3.0')
local _,ns = ...
local oUF = ns.oUF
local _,PlayerClass = UnitClass('player')
local TestModeToggle,UnitsSpawned
local anchorSwaps = {
	["BOTTOM"] = "TOP",
	["BOTTOMLEFT"] = "TOPRIGHT",
	["BOTTOMRIGHT"] = "TOPLEFT",
	["CENTER"] = "CENTER",
	["LEFT"] = "RIGHT",
	["RIGHT"] = "LEFT",
	["TOP"] = "BOTTOM",
	["TOPLEFT"] = "BOTTOMRIGHT",
	["TOPRIGHT"] = "BOTTOMLEFT",
}

local IsInGroup = RUF.IsInGroup
local GetNumSubgroupMembers = RUF.GetNumSubgroupMembers

function RUF:NickValidator(string)
	if (string.len(string) > 14) then
		return 'Length'
	end
	if string.find(string,'%p') then
		return 'Letters'
	end
	if string.find(string,'%d') then
		return 'Letters'
	end
	if string.find(string,'%s%s+') then
		return 'Spaces'
	end
	local numSpaces = select(2,string.gsub(string,'%s',''))
	if numSpaces then
		if numSpaces > 2 then
			return 'Spaces'
		end
	end
		return true
end

function RUF:UpdateFramePosition(unitFrame,singleFrame,groupFrame,header,i,anchorFrom,anchorFrame,anchorTo,offsetX,offsetY)
	if not singleFrame then singleFrame = 'none' end
	if not groupFrame then groupFrame = 'none' end
	if not header then header = 'none' end
	local profileReference
	if header ~= 'none' then
		profileReference = RUF.db.profile.unit[string.lower(header)].Frame.Position
	else
		if i == -1 then
			profileReference = RUF.db.profile.unit[string.lower(singleFrame)].Frame.Position
		else
			profileReference = RUF.db.profile.unit[string.lower(groupFrame)].Frame.Position
		end
	end

	anchorFrom = anchorFrom or profileReference.AnchorFrom
	anchorFrame = anchorFrame or profileReference.AnchorFrame
	anchorTo = anchorTo or profileReference.AnchorTo
	offsetX = offsetX or profileReference.x
	offsetY = offsetY or profileReference.y
	if not _G[anchorFrame] then
		--print(unitFrame.frame)
		--print(unitFrame:GetName())
		--print("Couldn't find the frame that %s was supposed to be anchored to. The Frame anchor reset to UI Parent. You may want to move it."):format(unitFrame:GetName())
		anchorFrame = 'UIParent'
	end
	if not i or i == -1 or i == 1 then
		unitFrame:ClearAllPoints()
		unitFrame:SetPoint(anchorFrom,anchorFrame,anchorTo,offsetX,offsetY)
	else
		local groupAnchorFrom
		if profileReference.growth == "BOTTOM" then
			groupAnchorFrom = "TOP"
		elseif profileReference.growth == "TOP" then
			groupAnchorFrom = "BOTTOM"
		end
		local spacingX = profileReference.offsetx
		local spacingY = profileReference.offsety
		local _,originalAnchorFrame = unitFrame:GetPoint()
		unitFrame:ClearAllPoints()
		unitFrame:SetPoint(groupAnchorFrom,originalAnchorFrame,profileReference.growth,spacingX,spacingY)
	end

end

function RUF:OptionsUpdateCastbars()
	-- TODO Castbar Text
	for k,v in next,oUF.objects do
		if v.Cast then
			local Bar = v.Cast
			local Border = Bar.Border
			local Background = Bar.bg
			local Time = Bar.Time
			local Text = Bar.Text
			local profileReference = RUF.db.profile.Appearance.Bars.Cast
			local unitProfile = RUF.db.profile.unit[v.frame].Frame.Bars.Cast
			local texture = LSM:Fetch("statusbar",profileReference.Texture)

			Bar:SetStatusBarTexture(texture)
			Bar:SetFillStyle(unitProfile.Fill)
			Bar:SetWidth(unitProfile.Width)
			Bar:SetHeight(unitProfile.Height)
			local anchorFrame
			if unitProfile.Position.AnchorFrame == true then
				anchorFrame = v
			else
				anchorFrame = 'UIParent'
			end
			Bar:ClearAllPoints()
			Bar:SetPoint(
				unitProfile.Position.AnchorFrom,
				anchorFrame,
				unitProfile.Position.AnchorTo,
				unitProfile.Position.x,
				unitProfile.Position.y
			)

			Border:SetBackdrop({edgeFile = LSM:Fetch("border",profileReference.Border.Style.edgeFile),edgeSize = profileReference.Border.Style.edgeSize})
			local borderr,borderg,borderb = unpack(profileReference.Border.Color)
			Border:SetBackdropBorderColor(borderr,borderg,borderb,profileReference.Border.Alpha)

			local r,g,b = RUF:GetBarColor(Bar,v.frame,"Cast")
			Bar:SetStatusBarColor(r,g,b)
			if profileReference.Background.UseBarColor == false then
				r,g,b = unpack(profileReference.Background.CustomColor)
			end
			local Multiplier = profileReference.Background.Multiplier
			Background:SetTexture(LSM:Fetch("background","Solid"))
			Background:SetVertexColor(r*Multiplier,g*Multiplier,b*Multiplier,profileReference.Background.Alpha)
			Background:SetAllPoints(Bar)
			Background.colorSmooth = false

			Time:ClearAllPoints()
			Text:ClearAllPoints()
			if unitProfile.Fill == "REVERSE" then
				Time:SetPoint('LEFT',Bar,4,0)
				Text:SetPoint('RIGHT',Bar,-4,0)
			else
				Time:SetPoint('RIGHT',Bar,-4,0)
				Text:SetPoint('LEFT',Bar,4,0)
			end

			v.Cast.Enabled = unitProfile.Enabled
			if Bar.Enabled == false then
				v:DisableElement('Cast')
				v.Cast:Hide()
			else
				v:EnableElement('Cast')
				v.Cast:UpdateOptions()
				v.Cast:Show()
			end
		end
	end
end

function RUF:OptionsUpdateFrameBorders()
	for k,v in next,oUF.objects do
		local Border = v.Border
		local offset = RUF.db.profile.Appearance.Border.Offset
		Border:SetPoint('TOPLEFT',v,'TOPLEFT',-offset,offset)
		Border:SetPoint('BOTTOMRIGHT',v,'BOTTOMRIGHT',offset,-offset)
		Border:SetBackdrop({edgeFile = LSM:Fetch('border',RUF.db.profile.Appearance.Border.Style.edgeFile),edgeSize = RUF.db.profile.Appearance.Border.Style.edgeSize})
		local r,g,b = unpack(RUF.db.profile.Appearance.Border.Color)
		Border:SetBackdropBorderColor(r,g,b,RUF.db.profile.Appearance.Border.Alpha)

		if v.GlowBorder then
			local GlowBorder = v.GlowBorder
			local glowProfile = RUF.db.profile.Appearance.Border.Glow
			if glowProfile.Enabled ~= true then
				v:UnregisterEvent('UNIT_AURA',RUF.UpdateGlowBorder)
				v:UnregisterEvent('UNIT_TARGET',RUF.UpdateGlowBorder)
			else
				v:RegisterEvent('UNIT_AURA',RUF.UpdateGlowBorder,true)
				v:RegisterEvent('UNIT_TARGET',RUF.UpdateGlowBorder,true)
				GlowBorder:SetPoint('TOPLEFT',v,'TOPLEFT',-glowProfile.Offset,glowProfile.Offset)
				GlowBorder:SetPoint('BOTTOMRIGHT',v,'BOTTOMRIGHT',glowProfile.Offset,-glowProfile.Offset)
				GlowBorder:SetBackdrop({edgeFile = LSM:Fetch('border',glowProfile.Style.edgeFile),edgeSize = glowProfile.Style.edgeSize})
				GlowBorder:SetBackdropBorderColor(0,0,0,glowProfile.Alpha)
			end
		end
	end
end

function RUF:OptionsUpdateAllAuras()
	for k,v in next,oUF.objects do
		v.Buff:ForceUpdate()
		v.Debuff:ForceUpdate()
	end
end

function RUF:OptionsUpdateAuras(singleFrame,groupFrame,header,auraType)
	if not singleFrame then singleFrame = 'none' end
	if not groupFrame then groupFrame = 'none' end
	if not header then header = 'none' end
	if not auraType then return end

	local function UpdateAura(singleFrame,groupFrame,header,auraType,i)
		local currentUnit,unitFrame,profileReference

		if header ~= 'none' then
			currentUnit = header .. 'UnitButton' .. i
			profileReference = RUF.db.profile.unit[string.lower(header)][auraType].Icons
		elseif groupFrame ~= 'none' then
			if groupFrame:match('Target') then
				currentUnit = groupFrame:gsub('Target','') .. i .. 'Target'
			else
				currentUnit = groupFrame .. i
			end
			profileReference = RUF.db.profile.unit[string.lower(groupFrame)][auraType].Icons
		else
			currentUnit = singleFrame
			profileReference = RUF.db.profile.unit[string.lower(singleFrame)][auraType].Icons
		end
		unitFrame = _G['oUF_RUF_' .. currentUnit]
		if not unitFrame then return end

		local currentElement = unitFrame[auraType:sub(1,-2)]
		if not currentElement then return end

		currentElement:ClearAllPoints()
		currentElement:SetPoint(
			profileReference.Position.AnchorFrom,
			unitFrame,
			profileReference.Position.AnchorTo,
			profileReference.Position.x,
			profileReference.Position.y
		)
		currentElement.size = profileReference.Width
		currentElement.width = profileReference.Width
		currentElement.height = profileReference.Height
		currentElement['spacing-x'] = profileReference.Spacing.x
		currentElement['spacing-y'] = profileReference.Spacing.y
		currentElement.num = profileReference.Max
		currentElement['growth-x'] = profileReference.Growth.x
		currentElement['growth-y'] = profileReference.Growth.y
		currentElement.initialAnchor = profileReference.Position.AnchorFrom
		currentElement.disableMouse = profileReference.ClickThrough
		currentElement:SetSize((profileReference.Width * profileReference.Columns),(profileReference.Height * profileReference.Rows) + 2)

		currentElement.Enabled = profileReference.Enabled
		currentElement:ForceUpdate()

	end

	if header ~= 'none' then
		local headerUnits = { _G['oUF_RUF_' .. header]:GetChildren() }
		headerUnits[#headerUnits] = nil -- Remove moveBG entry
		for i = 1,#headerUnits do
			UpdateAura(singleFrame,groupFrame,header,auraType,i)
		end
	elseif groupFrame ~= 'none' then
		for i = 1,5 do
			UpdateAura(singleFrame,groupFrame,header,auraType,i)
		end
	elseif singleFrame ~= 'none' then
		UpdateAura(singleFrame,groupFrame,header,auraType,-1)
	end

end

function RUF:OptionsUpdateAllIndicators()
	local frames = RUF.frameList.frames
	local groupFrames = RUF.frameList.groupFrames
	local headers = RUF.frameList.headers

	for i = 1,#frames do
		if _G['oUF_RUF_' .. frames[i]] then
			for k,v in pairs(RUF.db.profile.unit[string.lower(frames[i])].Frame.Indicators) do
				if v ~= '' then
					RUF:OptionsUpdateIndicators(frames[i],nil,nil,k)
				end
			end
		end
	end
	for i = 1,#groupFrames do
		if _G['oUF_RUF_' .. groupFrames[i] .. '1'] then
			for k,v in pairs(RUF.db.profile.unit[string.lower(groupFrames[i])].Frame.Indicators) do
				if v ~= '' then
					RUF:OptionsUpdateIndicators(nil,groupFrames[i],nil,k)
				end
			end
		end
	end
	for i = 1,#headers do
		if _G['oUF_RUF_' .. headers[i]] then
			for k,v in pairs(RUF.db.profile.unit[string.lower(headers[i])].Frame.Indicators) do
				if v ~= '' then
					RUF:OptionsUpdateIndicators(nil,nil,headers[i],k)
				end
			end
		end
	end

end

function RUF:OptionsUpdateIndicators(singleFrame,groupFrame,header,indicator)
	if not singleFrame then singleFrame = 'none' end
	if not groupFrame then groupFrame = 'none' end
	if not header then header = 'none' end
	if not indicator then return end

	local function UpdateIndicator(singleFrame,groupFrame,header,indicator,i)
		local currentUnit,unitFrame,profileReference

		if header ~= 'none' then
			currentUnit = header .. 'UnitButton' .. i
			profileReference = RUF.db.profile.unit[string.lower(header)].Frame.Indicators[indicator]
		elseif groupFrame ~= 'none' then
			if groupFrame:match('Target') then
				currentUnit = groupFrame:gsub('Target','') .. i .. 'Target'
			else
				currentUnit = groupFrame .. i
			end
			profileReference = RUF.db.profile.unit[string.lower(groupFrame)].Frame.Indicators[indicator]
		else
			currentUnit = singleFrame
			profileReference = RUF.db.profile.unit[string.lower(singleFrame)].Frame.Indicators[indicator]
		end
		unitFrame = _G['oUF_RUF_' .. currentUnit]
		if not unitFrame then return end

		local currentIndicator = unitFrame[indicator .. 'Indicator']
		if not currentIndicator then return end -- When refresh profile,ensure we don't try to update indicators that don't exist.
		currentIndicator:SetFont([[Interface\Addons\RUF\Media\RUF.ttf]],profileReference.Size,"OUTLINE")
		currentIndicator:ClearAllPoints()
		currentIndicator:SetPoint(
			profileReference.Position.AnchorFrom,
			RUF.GetIndicatorAnchorFrame(unitFrame,unitFrame.frame,indicator), -- Args: Frame, Unit, Element
			profileReference.Position.AnchorTo,
			profileReference.Position.x,
			profileReference.Position.y
		)
		currentIndicator.Enabled = profileReference.Enabled
		currentIndicator:ForceUpdate()

	end

	if header ~= 'none' then
		local headerUnits = { _G['oUF_RUF_' .. header]:GetChildren() }
		headerUnits[#headerUnits] = nil -- Remove moveBG entry
		for i = 1,#headerUnits do
			UpdateIndicator(singleFrame,groupFrame,header,indicator,i)
		end
	elseif groupFrame ~= 'none' then
		for i = 1,5 do
			UpdateIndicator(singleFrame,groupFrame,header,indicator,i)
		end
	elseif singleFrame ~= 'none' then
		UpdateIndicator(singleFrame,groupFrame,header,indicator,-1)
	end

end

function RUF:OptionsAddTexts(singleFrame,groupFrame,header,textName)
	if not singleFrame then singleFrame = 'none' end
	if not groupFrame then groupFrame = 'none' end
	if not header then header = 'none' end
	if not textName then return end

	local function AddText(singleFrame,groupFrame,header,textName,i)
		local currentUnit,unitFrame

		if header ~= 'none' then
			currentUnit = header .. 'UnitButton' .. i
		elseif groupFrame ~= 'none' then
			if groupFrame:match('Target') then
				currentUnit = groupFrame:gsub('Target','') .. i .. 'Target'
			else
				currentUnit = groupFrame .. i
			end
		else
			currentUnit = singleFrame
		end
		unitFrame = _G['oUF_RUF_' .. currentUnit]
		if not unitFrame then return end

		RUF.CreateTextArea(unitFrame,unitFrame.frame,textName) -- Args: self,unit,textName
		RUF.SetTextPoints(unitFrame,unitFrame.frame,textName)
	end

	if header ~= 'none' then
		local headerUnits = { _G['oUF_RUF_' .. header]:GetChildren() }
		headerUnits[#headerUnits] = nil -- Remove moveBG entry
		for i = 1,#headerUnits do
			AddText(singleFrame,groupFrame,header,textName,i)
		end
	elseif groupFrame ~= 'none' then
		for i = 1,5 do
			AddText(singleFrame,groupFrame,header,textName,i)
		end
	elseif singleFrame ~= 'none' then
		AddText(singleFrame,groupFrame,header,textName,-1)
	end

end

function RUF:OptionsDisableTexts(singleFrame,groupFrame,header,textName)

	local function RemoveText(singleFrame,groupFrame,header,textName,i)
		local currentUnit,unitFrame,profileReference

		if header ~= 'none' then
			currentUnit = header .. 'UnitButton' .. i
			profileReference = RUF.db.profile.unit[string.lower(header)].Frame.Text[textName]
		elseif groupFrame ~= 'none' then
			if groupFrame:match('Target') then
				currentUnit = groupFrame:gsub('Target','') .. i .. 'Target'
			else
				currentUnit = groupFrame .. i
			end
			profileReference = RUF.db.profile.unit[string.lower(groupFrame)].Frame.Text[textName]
		else
			currentUnit = singleFrame
			profileReference = RUF.db.profile.unit[string.lower(singleFrame)].Frame.Text[textName]
		end
		unitFrame = _G['oUF_RUF_' .. currentUnit]
		if not unitFrame then return end

		if profileReference == 'DISABLED' then
			if unitFrame.Text[textName] then
				unitFrame.Text[textName]:Hide()
			end
			unitFrame:Untag(unitFrame.Text[textName])
		end

	end

	if header ~= 'none' then
		local headerUnits = { _G['oUF_RUF_' .. header]:GetChildren() }
		headerUnits[#headerUnits] = nil -- Remove moveBG entry
		for i = 1,#headerUnits do
			RemoveText(singleFrame,groupFrame,header,textName,i)
		end
	elseif groupFrame ~= 'none' then
		for i = 1,5 do
			RemoveText(singleFrame,groupFrame,header,textName,i)
		end
	elseif singleFrame ~= 'none' then
		RemoveText(singleFrame,groupFrame,header,textName,-1)
	end

end

function RUF:OptionsUpdateAllTexts()
	local frames = RUF.frameList.frames
	local groupFrames = RUF.frameList.groupFrames
	local headers = RUF.frameList.headers

	for i = 1,#frames do
		if _G['oUF_RUF_' .. frames[i]] then
			RUF.RefreshTextElements(frames[i],nil,nil,-1)
			for k,v in pairs(RUF.db.profile.unit[string.lower(frames[i])].Frame.Text) do
				if v ~= '' then
					RUF:OptionsUpdateTexts(frames[i],nil,nil,k)
				end
			end
		end
	end
	for i = 1,#groupFrames do
		if _G['oUF_RUF_' .. groupFrames[i] .. '1'] then
			for groupNum = 1,5 do
				if _G['oUF_RUF_' .. groupFrames[i] .. i] then
					RUF.RefreshTextElements(nil,groupFrames[i],nil,groupNum)
				end
			end
			for k,v in pairs(RUF.db.profile.unit[string.lower(groupFrames[i])].Frame.Text) do
				if v ~= '' then
					RUF:OptionsUpdateTexts(nil,groupFrames[i],nil,k)
				end
			end
		end
	end
	for i = 1,#headers do
		if _G['oUF_RUF_' .. headers[i]] then
			local headerUnits = { _G['oUF_RUF_' .. headers[i]]:GetChildren() }
			headerUnits[#headerUnits] = nil -- Remove MoveBG from list
			for groupNum = 1,#headerUnits do
				RUF.RefreshTextElements(nil,nil,headers[i],groupNum)
			end
			for k,v in pairs(RUF.db.profile.unit[string.lower(headers[i])].Frame.Text) do
				if v ~= '' then
					RUF:OptionsUpdateTexts(nil,nil,headers[i],k)
				end
			end
		end
	end

end

function RUF:OptionsUpdateTexts(singleFrame,groupFrame,header,text)
	if not singleFrame then singleFrame = 'none' end
	if not groupFrame then groupFrame = 'none' end
	if not header then header = 'none' end
	if not text then return end

	local function UpdateText(singleFrame,groupFrame,header,text,i)
		local currentUnit,unitFrame,profileReference

		if header ~= 'none' then
			currentUnit = header .. 'UnitButton' .. i
			profileReference = RUF.db.profile.unit[string.lower(header)].Frame.Text[text]
			if not profileReference.Position.AnchorTo then
				RUF.db.profile.unit[string.lower(header)].Frame.Text[text].Position.AnchorTo = profileReference.Position.Anchor
			end
		elseif groupFrame ~= 'none' then
			if groupFrame:match('Target') then
				currentUnit = groupFrame:gsub('Target','') .. i .. 'Target'
			else
				currentUnit = groupFrame .. i
			end
			profileReference = RUF.db.profile.unit[string.lower(groupFrame)].Frame.Text[text]
			if not profileReference.Position.AnchorTo then
				RUF.db.profile.unit[string.lower(groupFrame)].Frame.Text[text].Position.AnchorTo = profileReference.Position.Anchor
			end
		else
			currentUnit = singleFrame
			profileReference = RUF.db.profile.unit[string.lower(singleFrame)].Frame.Text[text]
			if not profileReference.Position.AnchorTo then
				RUF.db.profile.unit[string.lower(singleFrame)].Frame.Text[text].Position.AnchorTo = profileReference.Position.Anchor
			end
		end
		unitFrame = _G['oUF_RUF_' .. currentUnit]
		if not unitFrame then return end

		local currentText = unitFrame.Text[text].String
		if not currentText then return end -- When refresh profile,ensure we don't try to update indicators that don't exist.

		currentText:SetFont(LSM:Fetch('font',profileReference.Font),profileReference.Size,profileReference.Outline)
		currentText:SetShadowColor(0,0,0,profileReference.Shadow)
		currentText:ClearAllPoints()
		currentText:SetHeight(5) -- FIXMEcurrentText:GetLineHeight())
		local anchorFrame
		if profileReference.Position.AnchorFrame == "Frame" then
			anchorFrame = unitFrame
		else
			anchorFrame = unitFrame.Text[profileReference.Position.AnchorFrame].String
		end
		if profileReference.CustomWidth then
			currentText:SetWordWrap(profileReference.WordWrap or false)
			currentText:SetWidth(profileReference.Width or 0)
			currentText:SetJustifyH(profileReference.Justify or 'CENTER')
			currentText:SetHeight(0)
		else
			currentText:SetWidth(0)
		end
		currentText:SetPoint(
			profileReference.Position.Anchor,
			anchorFrame,
			profileReference.Position.AnchorTo,
			profileReference.Position.x,
			profileReference.Position.y
		)
		if profileReference.Enabled then
			unitFrame:Tag(currentText,profileReference.Tag)
			currentText:UpdateTag()
			currentText:Show()
		else
			unitFrame:Untag(currentText)
			currentText:SetText('')
			currentText:Hide()
		end
	end

	if header ~= 'none' then
		local headerUnits = { _G['oUF_RUF_' .. header]:GetChildren() }
		headerUnits[#headerUnits] = nil -- Remove moveBG entry
		for i = 1,#headerUnits do
			UpdateText(singleFrame,groupFrame,header,text,i)
		end
	elseif groupFrame ~= 'none' then
		for i = 1,5 do
			UpdateText(singleFrame,groupFrame,header,text,i)
		end
	elseif singleFrame ~= 'none' then
		UpdateText(singleFrame,groupFrame,header,text,-1)
	end

end

function RUF:OptionsUpdatePortraits(singleFrame,groupFrame,header)
	if not singleFrame then singleFrame = 'none' end
	if not groupFrame then groupFrame = 'none' end
	if not header then header = 'none' end

	local function UpdatePortrait(singleFrame,groupFrame,header,i)
		local currentUnit,unitFrame,profileReference

		if header ~= 'none' then
			currentUnit = header .. 'UnitButton' .. i
			profileReference = RUF.db.profile.unit[string.lower(header)].Frame.Portrait
		elseif groupFrame ~= 'none' then
			if groupFrame:match('Target') then
				currentUnit = groupFrame:gsub('Target','') .. i .. 'Target'
			else
				currentUnit = groupFrame .. i
			end
			profileReference = RUF.db.profile.unit[string.lower(groupFrame)].Frame.Portrait
		else
			currentUnit = singleFrame
			profileReference = RUF.db.profile.unit[string.lower(singleFrame)].Frame.Portrait
		end
		unitFrame = _G['oUF_RUF_' .. currentUnit]
		if not unitFrame then return end

		unitFrame.Portrait.Enabled = profileReference.Enabled
		unitFrame.Portrait.Cutaway = profileReference.Cutaway

		unitFrame.Portrait:UpdateOptions()
		unitFrame.Portrait:ForceUpdate()
	end

	if header ~= 'none' then
		local headerUnits = { _G['oUF_RUF_' .. header]:GetChildren() }
		headerUnits[#headerUnits] = nil -- Remove moveBG entry
		for i = 1,#headerUnits do
			UpdatePortrait(singleFrame,groupFrame,header,i)
		end
	elseif groupFrame ~= 'none' then
		for i = 1,5 do
			UpdatePortrait(singleFrame,groupFrame,header,i)
		end
	elseif singleFrame ~= 'none' then
		UpdatePortrait(singleFrame,groupFrame,header,-1)
	end
end

function RUF:OptionsUpdateFrame(singleFrame,groupFrame,header)
	if not singleFrame then singleFrame = 'none' end
	if not groupFrame then groupFrame = 'none' end
	if not header then header = 'none' end

	local function UpdateFrame(singleFrame,groupFrame,header,i)
		local currentUnit,unitFrame,profileReference

		if header ~= 'none' then
			currentUnit = header .. 'UnitButton' .. i
			profileReference = RUF.db.profile.unit[string.lower(header)]
		elseif groupFrame ~= 'none' then
			if groupFrame:match('Target') then
				currentUnit = groupFrame:gsub('Target','') .. i .. 'Target'
			else
				currentUnit = groupFrame .. i
			end
			profileReference = RUF.db.profile.unit[string.lower(groupFrame)]
		else
			currentUnit = singleFrame
			profileReference = RUF.db.profile.unit[string.lower(singleFrame)]
		end
		unitFrame = _G['oUF_RUF_' .. currentUnit]
		if not unitFrame then return end

		if header == 'none' then
			if profileReference.Enabled == false then
				unitFrame:Disable()
				if groupFrame == 'Arena' then
					unitFrame:SetAttribute('oUF-enableArenaPrep', false)
				end
			else
				unitFrame:Enable()
				if groupFrame == 'Arena' then
					unitFrame:SetAttribute('oUF-enableArenaPrep', true)
				end
			end
		end

		if singleFrame == 'Player' then
			if profileReference.toggleForVehicle == true then
				unitFrame:SetAttribute('toggleForVehicle', profileReference.toggleForVehicle or false)
				if _G['oUF_RUF_Pet'] then
					_G['oUF_RUF_Pet']:SetAttribute('toggleForVehicle', profileReference.toggleForVehicle or false)
				end
			end
		end

		if profileReference.Frame.RangeFading.Enabled == true then
			if singleFrame ~= 'Player' then
				unitFrame:EnableElement('RangeCheck')
				if not unitFrame.RangeCheck then
					unitFrame.RangeCheck = {}
				end
				unitFrame.RangeCheck.enabled = profileReference.Frame.RangeFading.Enabled
				unitFrame.RangeCheck.insideAlpha = 1
				unitFrame.RangeCheck.outsideAlpha = profileReference.Frame.RangeFading.Alpha or 0.55
			end
		else
			unitFrame:DisableElement('RangeCheck')
		end

		if unitFrame:GetWidth() ~= profileReference.Frame.Size.Width then
			unitFrame:SetWidth(profileReference.Frame.Size.Width)
			if unitFrame.ClassicClassPower then -- and RUF.Client == 2 then
				unitFrame.ClassicClassPower.UpdateOptions(unitFrame.ClassicClassPower)
			end
		end
		unitFrame:SetHeight(profileReference.Frame.Size.Height)
		if profileReference.Frame.Portrait.Enabled then
			if profileReference.Frame.Portrait.Style == 3 then
				unitFrame.Portrait:SetHeight(profileReference.Frame.Size.Height)
			end
		end

		if i == -1 then
			RUF:UpdateFramePosition(unitFrame,singleFrame,groupFrame,header,i)
		end

		if groupFrame ~= 'none' then
			local anchorFrom
			if profileReference.Frame.Position.growth == "BOTTOM" then
				anchorFrom = "TOP"
			elseif profileReference.Frame.Position.growth == "TOP" then
				anchorFrom = "BOTTOM"
			end
			if i == 1 then
				RUF:UpdateFramePosition(unitFrame,singleFrame,groupFrame,header,i)
			else
				RUF:UpdateFramePosition(unitFrame,singleFrame,groupFrame,header,i,anchorFrom,_G['oUF_RUF_' .. groupFrame .. i-1])
			end

			if groupFrame == 'PartyPet' or groupFrame == 'PartyTarget' and not RUF.db.global.TestMode == true then
				local unitType = string.gsub(groupFrame, 'Party', '')
				local prefix,suffix
				if groupFrame == 'PartyPet' then
					prefix = 'pet'
					suffix = ''
				elseif groupFrame == 'PartyTarget' then
					prefix = ''
					suffix = 'target'
				end
				if RUF.db.profile.unit.party.showPlayer then
					if i == 1 then
						unitFrame:SetAttribute('unit', unitType)
						unitFrame.unit = unitType
					else
						unitFrame:SetAttribute('unit', 'party' .. prefix .. i-1 .. suffix)
						unitFrame.unit = 'party' .. prefix .. i-1 .. suffix
					end
				else
					unitFrame:SetAttribute('unit', 'party' .. prefix .. i .. suffix)
					unitFrame.unit = 'partypet' .. prefix .. i .. suffix
				end
			end



		end

		if header ~= 'none' then
			local headerFrame = _G['oUF_RUF_' .. header]
			local anchorFrom
			if profileReference.Frame.Position.growth == "BOTTOM" then
				anchorFrom = "TOP"
			elseif profileReference.Frame.Position.growth == "TOP" then
				anchorFrom = "BOTTOM"
			end

			local growthDirection
			if profileReference.Frame.Position.growthDirection then
				if profileReference.Frame.Position.growthDirection == 'VERTICAL' then
					growthDirection = 5
				elseif profileReference.Frame.Position.growthDirection == 'HORIZONTAL' then
					growthDirection = 1
				end
			end

			headerFrame:SetAttribute('unitsPerColumn', growthDirection)
			headerFrame:SetAttribute('columnSpacing', profileReference.Frame.Position.offsetx)
			headerFrame:SetAttribute('columnAnchorPoint', profileReference.Frame.Position.growthHoriz)

			headerFrame:SetAttribute("Point",anchorFrom)
			headerFrame:SetAttribute('yOffset',profileReference.Frame.Position.offsety)
			headerFrame:SetAttribute('showPlayer', RUF.db.profile.unit.party.showPlayer)

			RUF:UpdateFramePosition(headerFrame,singleFrame,groupFrame,header)
			headerFrame.Enabled = profileReference.Enabled

			if RUF.db.global.TestMode == true then
				unitFrame:Disable()
				if profileReference.Enabled == false then
					headerFrame.visibility = 'hide'
					headerFrame:SetAttribute('state-visibility',"hide")
					unitFrame:Hide()
				else
					headerFrame.visibility = 'show'
					headerFrame:SetAttribute('state-visibility',"show")
					unitFrame:Show()
				end
			else
				if profileReference.Enabled == false then
					unitFrame:Disable()
					headerFrame.visibility = 'hide'
					headerFrame:SetAttribute('state-visibility',"hide")
				else
					unitFrame:Enable()
					local showIn = '[group:party,nogroup:raid]show;hide'
					if profileReference.showRaid then
						showIn = '[group:party,nogroup:raid]show;[group:raid]show;hide'
					end
					if profileReference.showArena then
						showIn = '[@arena1,exists]show;[@arena2,exists]show;[@arena3,exists]show;' .. showIn
					end
					headerFrame.visibility = showIn
					headerFrame:SetAttribute('state-visibility',headerFrame.visibility)
				end
			end
			unitFrame:ClearAllPoints()

		end

	end

	if header ~= 'none' then
		local headerUnits = { _G['oUF_RUF_' .. header]:GetChildren() }
		headerUnits[#headerUnits] = nil -- Remove moveBG entry
		for i = 1,#headerUnits do
			UpdateFrame(singleFrame,groupFrame,header,i)
		end
	elseif groupFrame ~= 'none' then
		for i = 1,5 do
			UpdateFrame(singleFrame,groupFrame,header,i)
		end
	elseif singleFrame ~= 'none' then
		UpdateFrame(singleFrame,groupFrame,header,-1)
	end

end

function RUF:OptionsUpdateAllBars()
	local frames = RUF.frameList.frames
	local groupFrames = RUF.frameList.groupFrames
	local headers = RUF.frameList.headers

	for i = 1,#frames do
		if _G['oUF_RUF_' .. frames[i]] then
			RUF:OptionsUpdateBars(frames[i],nil,nil,'Health')
			RUF:OptionsUpdateBars(frames[i],nil,nil,'Power')
			RUF:OptionsUpdateBars(frames[i],nil,nil,'HealPrediction')
			RUF:OptionsUpdateBars(frames[i],nil,nil,'Absorb')
			if i == 1 then
				RUF:OptionsUpdateBars(frames[i],nil,nil,'Class')
			end
		end
	end
	for i = 1,#groupFrames do
		RUF:OptionsUpdateBars(nil,groupFrames[i],nil,'Health')
		RUF:OptionsUpdateBars(nil,groupFrames[i],nil,'Power')
		RUF:OptionsUpdateBars(nil,groupFrames[i],nil,'HealPrediction')
		RUF:OptionsUpdateBars(nil,groupFrames[i],nil,'Absorb')
	end
	for i = 1,#headers do
		RUF:OptionsUpdateBars(nil,nil,headers[i],'Health')
		RUF:OptionsUpdateBars(nil,nil,headers[i],'Power')
		RUF:OptionsUpdateBars(nil,nil,headers[i],'HealPrediction')
		RUF:OptionsUpdateBars(nil,nil,headers[i],'Absorb')
	end

	RUF:OptionsUpdateCastbars()

end

function RUF:OptionsUpdateBars(singleFrame,groupFrame,header,bar)
	if not singleFrame then singleFrame = 'none' end
	if not groupFrame then groupFrame = 'none' end
	if not header then header = 'none' end
	if not bar then return end

	local function UpdateBar(singleFrame,groupFrame,header,bar,i)
		local currentUnit,unitFrame,profileReference

		if header ~= 'none' then
			currentUnit = header .. 'UnitButton' .. i
			profileReference = RUF.db.profile.unit[string.lower(header)].Frame.Bars[bar]
		elseif groupFrame ~= 'none' then
			if groupFrame:match('Target') then
				currentUnit = groupFrame:gsub('Target','') .. i .. 'Target'
			else
				currentUnit = groupFrame .. i
			end
			profileReference = RUF.db.profile.unit[string.lower(groupFrame)].Frame.Bars[bar]
		else
			currentUnit = singleFrame
			profileReference = RUF.db.profile.unit[string.lower(singleFrame)].Frame.Bars[bar]
		end
		unitFrame = _G['oUF_RUF_' .. currentUnit]
		if not unitFrame then return end

		local originalBar = bar
		if bar == 'Class' then
			bar = 'ClassicClassPower'
		end
		if not unitFrame[bar] then return end
		unitFrame[bar].UpdateOptions(unitFrame[bar])
		unitFrame[bar]:ForceUpdate()
		if bar then
			unitFrame[bar].UpdateOptions(unitFrame[bar])
			if PlayerClass == 'DRUID' then
				if unitFrame['FakeClassPower'] then
					unitFrame['FakeClassPower'].UpdateOptions(unitFrame['FakeClassPower'])
				end
			end
		end
		if bar == 'Power' or bar == 'Absorb' then
				if profileReference.Enabled == 0 then
					unitFrame:DisableElement(bar)
				elseif profileReference.Enabled == 1 then
					unitFrame[bar].hideAtZero = true
					unitFrame:DisableElement(bar)
					unitFrame:EnableElement(bar)
					unitFrame[bar]:ForceUpdate()
				else
					unitFrame[bar].hideAtZero = false
					unitFrame:DisableElement(bar)
					unitFrame:EnableElement(bar)
					unitFrame[bar]:ForceUpdate()
				end
		elseif originalBar == 'Class' then
			if profileReference.Enabled == true then
				unitFrame:EnableElement(bar)
				if unitFrame[bar] then
					unitFrame[bar]:ForceUpdate()
				end
				if PlayerClass == 'DRUID'then
					unitFrame:EnableElement('FakeClassPower')
					unitFrame['FakeClassPower']:ForceUpdate()
				end
			else
				unitFrame:DisableElement(bar)
				if PlayerClass == 'DRUID'then
					unitFrame:DisableElement('FakeClassPower')
				end
			end
		end
	end

	if header ~= 'none' then
		local headerUnits = { _G['oUF_RUF_' .. header]:GetChildren() }
		headerUnits[#headerUnits] = nil -- Remove moveBG entry
		for i = 1,#headerUnits do
			UpdateBar(singleFrame,groupFrame,header,bar,i)
		end
	elseif groupFrame ~= 'none' then
		for i = 1,5 do
			UpdateBar(singleFrame,groupFrame,header,bar,i)
		end
	elseif singleFrame ~= 'none' then
		UpdateBar(singleFrame,groupFrame,header,bar,-1)
	end

end

function RUF:SpawnUnits()
	if UnitsSpawned == true then return end
	TestModeToggle = true

	local headers = RUF.frameList.headers
	local partyNum = 0
	local startingIndex = -4
	if IsInGroup() then
		startingIndex = -3
		partyNum = GetNumSubgroupMembers()
	end

	for i = 1,#headers do
		local currentHeader = _G['oUF_RUF_' .. headers[i]]
		currentHeader:SetAttribute('startingIndex', startingIndex + partyNum)
		if currentHeader.Enabled then
			currentHeader:SetAttribute('state-visibility','show')
		end
	end

	for k,v in next,oUF.objects do
		v.oldUnit = v.unit
		if v.realUnit then v.oldUnit = v.realUnit end
		v:SetAttribute('unit','player')
		v:Disable()
		if RUF.db.profile.unit[v.frame].Enabled then
			if RUF.db.global.TestModeShowUnits then
				v.Text.DisplayName:Show()
			else
				v.Text.DisplayName:Hide()
			end
			if v.oldUnit == 'party5target' or v.oldUnit == 'PartyPet5' then
				if RUF.db.profile.unit.party.showPlayer then
					v:Show()
				else
					v:Hide()
				end
			else
				v:Show()
			end
		else
			v:Hide()
		end
		if v.Cast then
			v.Cast:Show()
			v.Cast:OnUpdate()
		end
	end
	UnitsSpawned = true
end

function RUF:RestoreUnits()
	if UnitsSpawned ~= true then return end
	TestModeToggle = false

	local headers = RUF.frameList.headers
	local partyNum = GetNumSubgroupMembers()
	for i = 1,#headers do
		local currentHeader = _G['oUF_RUF_' .. headers[i]]
		currentHeader:SetAttribute('startingIndex',1)
		if currentHeader.Enabled then
			currentHeader:SetAttribute('state-visibility',currentHeader.visibility)
		else
			currentHeader:SetAttribute('state-visibility',"hide")
		end
	end

	for k,v in next,oUF.objects do
		if v.Cast then
			v.Cast:Show()
			v.Cast:OnUpdate()
		end
		v.realUnit = v.oldUnit
		v.unit = v.oldUnit
		v:SetAttribute('unit',v.unit)
		v.Text.DisplayName:Hide()
		v:Hide()
		if v.unit == 'party5target' or v.unit == 'PartyPet5' then
			if RUF.db.profile.unit.party.showPlayer and RUF.db.profile.unit[v.frame].Enabled then
				v:Show()
			else
				v:Hide()
			end
		elseif RUF.db.profile.unit[v.frame].Enabled then
			v:Enable()
		else
			v:Disable()
		end
	end

	UnitsSpawned = false
end

function RUF:TestMode()
	if RUF.db.global.TestMode == true then
		if TestModeToggle ~= true and not InCombatLockdown() then
			RUF:SpawnUnits()
		elseif TestModeToggle == true and not InCombatLockdown() then
			RUF:RestoreUnits()
			RUF:SpawnUnits()
		end
	else
		if TestModeToggle == true and not InCombatLockdown() then
			RUF:RestoreUnits()
			RUF:OptionsUpdateFrame('none', 'PartyTarget', 'none') -- So we also force Update and Hide/Show the 5th Party Target
			RUF:OptionsUpdateFrame('none', 'PartyPet', 'none')
			RUF.TogglePartyChildren('partypet')
			RUF.TogglePartyChildren('partytarget')
		end
	end
end

function RUF:UpdateAllUnitSettings()
	local frames = RUF.frameList.frames
	local groupFrames = RUF.frameList.groupFrames
	local headers = RUF.frameList.headers

	for i = 1,#frames do
		RUF:OptionsUpdateFrame(frames[i])
		RUF:OptionsUpdateAuras(frames[i],nil,nil,'Buffs')
		RUF:OptionsUpdateAuras(frames[i],nil,nil,'Debuffs')
		RUF:OptionsUpdatePortraits(frames[i])
	end
	for i = 1,#groupFrames do
		RUF:OptionsUpdateFrame(nil,groupFrames[i])
		RUF:OptionsUpdateAuras(nil,groupFrames[i],nil,'Buffs')
		RUF:OptionsUpdateAuras(nil,groupFrames[i],nil,'Debuffs')
		RUF:OptionsUpdatePortraits(nil,groupFrames[i])
	end
	for i = 1,#headers do
		RUF:OptionsUpdateFrame(nil,nil,headers[i])
		RUF:OptionsUpdateAuras(nil,nil,headers[i],'Buffs')
		RUF:OptionsUpdateAuras(nil,nil,headers[i],'Debuffs')
		RUF:OptionsUpdatePortraits(nil,nil,headers[i])
	end

	RUF:OptionsUpdateAllBars()
	RUF:OptionsUpdateAllTexts()
	RUF:OptionsUpdateAllIndicators()
	RUF:OptionsUpdateAllAuras()
	RUF:OptionsUpdateFrameBorders()
	RUF:OptionsUpdateCastbars()

	RUF.CombatFaderRegister()
end