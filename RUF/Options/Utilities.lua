assert(RUF, "RUF not found!")
local RUF = RUF
local _, ns = ...
local oUF = ns.oUF

local strgsub = string.gsub
local lower = string.lower

local TestModeToggle, UnitsSpawned
local anchorSwaps = {
	["BOTTOM"] = "TOP",
	["BOTTOMLEFT"] = "TOPRIGHT",
	["BOTTOMRIGHT"] = "TOPLEFT",
	["CENTER"] = "CENTER",
	["LEFT"] = "RIGHT",
	["RIGHT"] = "LEFT",
	["TOP"] = "BOTTOM",
	["TOPLEFT"] = "BOTTOMRIGHT",
	["TOPRIGHT"] = "BOTTOMLEFT"
}

local IsInGroup = RUF.IsInGroup
local GetNumSubgroupMembers = RUF.GetNumSubgroupMembers

function RUF:UpdateFramePosition(unitFrame, singleFrame, groupFrame, header, i, anchorFrom, anchorFrame, anchorTo, offsetX, offsetY)
	singleFrame = singleFrame or "none"
	groupFrame = groupFrame or "none"
	header = header or "none"

	local profileReference
	if header ~= "none" then
		profileReference = RUF.db.profile.unit[strlower(header)].Frame.Position
	else
		if i == -1 then
			profileReference = RUF.db.profile.unit[strlower(singleFrame)].Frame.Position
		else
			profileReference = RUF.db.profile.unit[strlower(groupFrame)].Frame.Position
		end
	end

	anchorFrom = anchorFrom or profileReference.AnchorFrom
	anchorFrame = anchorFrame or profileReference.AnchorFrame
	if not _G[anchorFrame] then
		anchorFrame = "UIParent"
	end

	anchorTo = anchorTo or profileReference.AnchorTo
	offsetX = offsetX or profileReference.x
	offsetY = offsetY or profileReference.y
	if not i or i == -1 or i == 1 then
		unitFrame:ClearAllPoints()
		unitFrame:SetPoint(anchorFrom, anchorFrame, anchorTo, offsetX, offsetY)
	else
		local _, originalAnchorFrame = unitFrame:GetPoint()
		if profileReference.growth == "BOTTOM" then
			unitFrame:ClearAllPoints()
			unitFrame:SetPoint("TOP", originalAnchorFrame, profileReference.growth, profileReference.offsetx, profileReference.offsety)
		elseif profileReference.growth == "TOP" then
			unitFrame:ClearAllPoints()
			unitFrame:SetPoint("BOTTOM", originalAnchorFrame, profileReference.growth, profileReference.offsetx, profileReference.offsety)
		end
	end
end

function RUF:OptionsUpdateCastbars()
	for k, v in next, oUF.objects do
		if v.Castbar then
			local Bar = v.Castbar
			local Border = Bar.Border
			local Background = Bar.bg
			local Time = Bar.Time
			local Text = Bar.Text
			local profileReference = RUF.db.profile.Appearance.Bars.Cast
			local unitProfile = RUF.db.profile.unit[v.frame].Frame.Bars.Cast
			local texture = RUF:MediaFetch("statusbar", profileReference.Texture)

			Bar:SetStatusBarTexture(texture)
			Bar:SetFillStyle(unitProfile.Fill)
			Bar:SetWidth(unitProfile.Width)
			Bar:SetHeight(unitProfile.Height)
			local anchorFrame = (unitProfile.Position.AnchorFrame == true) and v or "UIParent"
			Bar:ClearAllPoints()
			Bar:SetPoint(unitProfile.Position.AnchorFrom, anchorFrame, unitProfile.Position.AnchorTo, unitProfile.Position.x, unitProfile.Position.y)

			Border:SetBackdrop({
				edgeFile = RUF:MediaFetch("border", profileReference.Border.Style.edgeFile),
				edgeSize = profileReference.Border.Style.edgeSize
			})

			local r, g, b = unpack(profileReference.Border.Color)
			Border:SetBackdropBorderColor(r, g, b, profileReference.Border.Alpha)

			r, g, b = RUF:GetBarColor(Bar, v.frame, "Cast")
			Bar:SetStatusBarColor(r, g, b)
			if profileReference.Background.UseBarColor == false then
				r, g, b = unpack(profileReference.Background.CustomColor)
			end

			local Multiplier = profileReference.Background.Multiplier
			Background:SetTexture(RUF:MediaFetch("background", "Solid"))
			Background:SetVertexColor(r * Multiplier, g * Multiplier, b * Multiplier, profileReference.Background.Alpha)
			Background:SetAllPoints(Bar)
			Background.colorSmooth = false

			Time:ClearAllPoints()
			Text:ClearAllPoints()
			if unitProfile.Fill == "REVERSE" then
				Time:SetPoint("LEFT", Bar, 4, 0)
				Text:SetPoint("RIGHT", Bar, -4, 0)
			else
				Time:SetPoint("RIGHT", Bar, -4, 0)
				Text:SetPoint("LEFT", Bar, 4, 0)
			end

			v.Castbar.Enabled = unitProfile.Enabled
			if Bar.Enabled == false then
				v:DisableElement("Castbar")
				v.Castbar:Hide()
			else
				v:EnableElement("Castbar")
				v.Castbar:UpdateOptions()
				v.Castbar:Show()
			end
		end
	end
end

function RUF:OptionsUpdateFrameBorders()
	for k, v in next, oUF.objects do
		local Border = v.Border
		local offset = RUF.db.profile.Appearance.Border.Offset
		Border:SetPoint("TOPLEFT", v, "TOPLEFT", -offset, offset)
		Border:SetPoint("BOTTOMRIGHT", v, "BOTTOMRIGHT", offset, -offset)
		Border:SetBackdrop({
			edgeFile = RUF:MediaFetch("border", RUF.db.profile.Appearance.Border.Style.edgeFile),
			edgeSize = RUF.db.profile.Appearance.Border.Style.edgeSize
		})

		local r, g, b = unpack(RUF.db.profile.Appearance.Border.Color)
		Border:SetBackdropBorderColor(r, g, b, RUF.db.profile.Appearance.Border.Alpha)

		if v.GlowBorder then
			local GlowBorder = v.GlowBorder
			local glowProfile = RUF.db.profile.Appearance.Border.Glow
			if glowProfile.Enabled ~= true then
				v:UnregisterEvent("UNIT_AURA", RUF.UpdateGlowBorder)
				v:UnregisterEvent("UNIT_TARGET", RUF.UpdateGlowBorder)
			else
				v:RegisterEvent("UNIT_AURA", RUF.UpdateGlowBorder, true)
				v:RegisterEvent("UNIT_TARGET", RUF.UpdateGlowBorder, true)
				GlowBorder:SetPoint("TOPLEFT", v, "TOPLEFT", -glowProfile.Offset, glowProfile.Offset)
				GlowBorder:SetPoint("BOTTOMRIGHT", v, "BOTTOMRIGHT", glowProfile.Offset, -glowProfile.Offset)
				GlowBorder:SetBackdrop({
					edgeFile = RUF:MediaFetch("border", glowProfile.Style.edgeFile),
					edgeSize = glowProfile.Style.edgeSize
				})
				GlowBorder:SetBackdropBorderColor(0, 0, 0, glowProfile.Alpha)
			end
		end
	end
end

function RUF:OptionsUpdateAllAuras()
	for k, v in next, oUF.objects do
		v.Buff:ForceUpdate()
		v.Debuff:ForceUpdate()
	end
end

function RUF:OptionsUpdateAuras(singleFrame, groupFrame, header, auraType)
	if not auraType then return end

	singleFrame = singleFrame or "none"
	groupFrame = groupFrame or "none"
	header = header or "none"

	local function UpdateAura(sFrame, gFrame, head, aType, i)
		local currentUnit, unitFrame, profileReference

		if head ~= "none" then
			currentUnit = head .. "UnitButton" .. i
			profileReference = RUF.db.profile.unit[strlower(head)][aType].Icons
		elseif gFrame ~= "none" then
			if gFrame:match("Target") then
				currentUnit = gFrame:gsub("Target", "") .. i .. "Target"
			else
				currentUnit = gFrame .. i
			end
			profileReference = RUF.db.profile.unit[strlower(gFrame)][aType].Icons
		else
			currentUnit = sFrame
			profileReference = RUF.db.profile.unit[strlower(sFrame)][aType].Icons
		end
		unitFrame = _G["oUF_RUF_" .. currentUnit]
		if not unitFrame then return end

		local currentElement = unitFrame[aType:sub(1, -2)]
		if not currentElement then return end

		currentElement:ClearAllPoints()
		currentElement:SetPoint(profileReference.Position.AnchorFrom, unitFrame, profileReference.Position.AnchorTo, profileReference.Position.x, profileReference.Position.y)
		currentElement.size = profileReference.Width
		currentElement.width = profileReference.Width
		currentElement.height = profileReference.Height
		currentElement["spacing-x"] = profileReference.Spacing.x
		currentElement["spacing-y"] = profileReference.Spacing.y
		currentElement.num = profileReference.Max
		currentElement["growth-x"] = profileReference.Growth.x
		currentElement["growth-y"] = profileReference.Growth.y
		currentElement.initialAnchor = profileReference.Position.AnchorFrom
		currentElement.disableMouse = profileReference.ClickThrough
		currentElement:SetSize((profileReference.Width * profileReference.Columns), (profileReference.Height * profileReference.Rows) + 2)

		currentElement.Enabled = profileReference.Enabled
		currentElement:ForceUpdate()

		return true
	end

	if header ~= "none" or groupFrame ~= "none" then
		for i = 1, 6 do
			if not UpdateAura(singleFrame, groupFrame, header, auraType, i) then
				break
			end
		end
	elseif singleFrame ~= "none" then
		UpdateAura(singleFrame, groupFrame, header, auraType, -1)
	end
end

function RUF:OptionsUpdateAllIndicators()
	for i = 1, #RUF.frameList.frames do
		if _G["oUF_RUF_" .. RUF.frameList.frames[i]] then
			for k, v in pairs(RUF.db.profile.unit[strlower(RUF.frameList.frames[i])].Frame.Indicators) do
				if v ~= "" then
					RUF:OptionsUpdateIndicators(RUF.frameList.frames[i], nil, nil, k)
				end
			end
		end
	end
	for i = 1, #RUF.frameList.groupFrames do
		if _G["oUF_RUF_" .. RUF.frameList.groupFrames[i] .. "1"] then
			for k, v in pairs(RUF.db.profile.unit[strlower(RUF.frameList.groupFrames[i])].Frame.Indicators) do
				if v ~= "" then
					RUF:OptionsUpdateIndicators(nil, RUF.frameList.groupFrames[i], nil, k)
				end
			end
		end
	end
	for i = 1, #RUF.frameList.headers do
		if _G["oUF_RUF_" .. RUF.frameList.headers[i]] then
			for k, v in pairs(RUF.db.profile.unit[strlower(RUF.frameList.headers[i])].Frame.Indicators) do
				if v ~= "" then
					RUF:OptionsUpdateIndicators(nil, nil, RUF.frameList.headers[i], k)
				end
			end
		end
	end
end

function RUF:OptionsUpdateIndicators(singleFrame, groupFrame, header, indicator)
	if not indicator then return end
	singleFrame = singleFrame or "none"
	groupFrame = groupFrame or "none"
	header = header or "none"

	local function UpdateIndicator(sFrame, gFrame, head, indic, i)
		local currentUnit, unitFrame, profileReference

		if head ~= "none" then
			currentUnit = head .. "UnitButton" .. i
			profileReference = RUF.db.profile.unit[strlower(head)].Frame.Indicators[indic]
		elseif gFrame ~= "none" then
			if gFrame:match("Target") then
				currentUnit = gFrame:gsub("Target", "") .. i .. "Target"
			else
				currentUnit = gFrame .. i
			end
			profileReference = RUF.db.profile.unit[strlower(gFrame)].Frame.Indicators[indic]
		else
			currentUnit = sFrame
			profileReference = RUF.db.profile.unit[strlower(sFrame)].Frame.Indicators[indic]
		end

		unitFrame = _G["oUF_RUF_" .. currentUnit]
		if not unitFrame then return end

		local currentIndicator = unitFrame[indic .. "Indicator"]
		if not currentIndicator then return end

		currentIndicator:SetFont([[Interface\AddOns\RUF\Media\RUF.ttf]], profileReference.Size, "OUTLINE")
		currentIndicator:ClearAllPoints()
		currentIndicator:SetPoint(
			profileReference.Position.AnchorFrom,
			RUF.GetIndicatorAnchorFrame(unitFrame, unitFrame.frame, indic), -- Args: Frame, Unit, Element
			profileReference.Position.AnchorTo,
			profileReference.Position.x,
			profileReference.Position.y
		)
		currentIndicator.Enabled = profileReference.Enabled
		currentIndicator:ForceUpdate()

		return true
	end

	if header ~= "none" or groupFrame ~= "none" then
		for i = 1, 6 do
			if not UpdateIndicator(singleFrame, groupFrame, header, indicator, i) then
				break
			end
		end
	elseif singleFrame ~= "none" then
		UpdateIndicator(singleFrame, groupFrame, header, indicator, -1)
	end
end

function RUF:OptionsAddTexts(singleFrame, groupFrame, header, textName)
	if not textName then return end
	singleFrame = singleFrame or "none"
	groupFrame = groupFrame or "none"
	header = header or "none"

	local function AddText(sFrame, gFrame, head, tName, i)
		local currentUnit, unitFrame

		if head ~= "none" then
			currentUnit = head .. "UnitButton" .. i
		elseif gFrame ~= "none" then
			if gFrame:match("Target") then
				currentUnit = gFrame:gsub("Target", "") .. i .. "Target"
			else
				currentUnit = gFrame .. i
			end
		else
			currentUnit = sFrame
		end
		unitFrame = _G["oUF_RUF_" .. currentUnit]
		if unitFrame then
			RUF.CreateTextArea(unitFrame, unitFrame.frame, tName) -- Args: self,unit,tName
			RUF.SetTextPoints(unitFrame, unitFrame.frame, tName)
			return true
		end
		return false
	end

	if header ~= "none" or groupFrame ~= "none" then
		for i = 1, 6 do
			if not AddText(singleFrame, groupFrame, header, textName, i) then
				break
			end
		end
	elseif singleFrame ~= "none" then
		AddText(singleFrame, groupFrame, header, textName, -1)
	end
end

function RUF:OptionsDisableTexts(singleFrame, groupFrame, header, textName)
	if not textName then return end
	singleFrame = singleFrame or "none"
	groupFrame = groupFrame or "none"
	header = header or "none"

	local function RemoveText(sFrame, gFrame, head, tName, i)
		local currentUnit, unitFrame, profileReference

		if head ~= "none" then
			currentUnit = head .. "UnitButton" .. i
			profileReference = RUF.db.profile.unit[strlower(head)].Frame.Text[tName]
		elseif gFrame ~= "none" then
			if gFrame:match("Target") then
				currentUnit = gFrame:gsub("Target", "") .. i .. "Target"
			else
				currentUnit = gFrame .. i
			end
			profileReference = RUF.db.profile.unit[strlower(gFrame)].Frame.Text[tName]
		else
			currentUnit = sFrame
			profileReference = RUF.db.profile.unit[strlower(sFrame)].Frame.Text[tName]
		end
		unitFrame = _G["oUF_RUF_" .. currentUnit]
		if not unitFrame then return end

		if profileReference == "DISABLED" then
			if unitFrame.Text[textName] then
				unitFrame.Text[textName]:Hide()
			end
			unitFrame:Untag(unitFrame.Text[textName])
		end
		return true
	end

	if header ~= "none" or groupFrame ~= "none" then
		for i = 1, 6 do
			if not RemoveText(singleFrame, groupFrame, header, textName, i) then
				break
			end
		end
	elseif singleFrame ~= "none" then
		RemoveText(singleFrame, groupFrame, header, textName, -1)
	end
end

function RUF:OptionsUpdateAllTexts()
	for i = 1, #RUF.frameList.frames do
		if _G["oUF_RUF_" .. RUF.frameList.frames[i]] then
			RUF.RefreshTextElements(RUF.frameList.frames[i], nil, nil, -1)
			for k, v in pairs(RUF.db.profile.unit[strlower(RUF.frameList.frames[i])].Frame.Text) do
				if v ~= "" then
					RUF:OptionsUpdateTexts(RUF.frameList.frames[i], nil, nil, k)
				end
			end
		end
	end

	for i = 1, #RUF.frameList.groupFrames do
		if _G["oUF_RUF_" .. RUF.frameList.groupFrames[i] .. "1"] then
			for groupNum = 1, 5 do
				if _G["oUF_RUF_" .. RUF.frameList.groupFrames[i] .. i] then
					RUF.RefreshTextElements(nil, RUF.frameList.groupFrames[i], nil, groupNum)
				end
			end
			for k, v in pairs(RUF.db.profile.unit[strlower(RUF.frameList.groupFrames[i])].Frame.Text) do
				if v ~= "" then
					RUF:OptionsUpdateTexts(nil, RUF.frameList.groupFrames[i], nil, k)
				end
			end
		end
	end

	for i = 1, #RUF.frameList.headers do
		if _G["oUF_RUF_" .. RUF.frameList.headers[i]] then
			local headerUnits = {_G["oUF_RUF_" .. RUF.frameList.headers[i]]:GetChildren()}
			headerUnits[#headerUnits] = nil -- Remove MoveBG from list
			for groupNum = 1, #headerUnits do
				RUF.RefreshTextElements(nil, nil, RUF.frameList.headers[i], groupNum)
			end
			for k, v in pairs(RUF.db.profile.unit[strlower(RUF.frameList.headers[i])].Frame.Text) do
				if v ~= "" then
					RUF:OptionsUpdateTexts(nil, nil, RUF.frameList.headers[i], k)
				end
			end
		end
	end
end

function RUF:OptionsUpdateTexts(singleFrame, groupFrame, header, text)
	if not text then return end
	singleFrame = singleFrame or "none"
	groupFrame = groupFrame or "none"
	header = header or "none"

	local function UpdateText(sFrame, gFrame, head, text, i)
		local currentUnit, unitFrame, profileReference

		if head ~= "none" then
			currentUnit = head .. "UnitButton" .. i
			profileReference = RUF.db.profile.unit[strlower(head)].Frame.Text[text]
			if not profileReference.Position.AnchorTo then
				RUF.db.profile.unit[strlower(head)].Frame.Text[text].Position.AnchorTo = profileReference.Position.Anchor
			end
		elseif gFrame ~= "none" then
			if gFrame:match("Target") then
				currentUnit = gFrame:gsub("Target", "") .. i .. "Target"
			else
				currentUnit = gFrame .. i
			end
			profileReference = RUF.db.profile.unit[strlower(gFrame)].Frame.Text[text]
			if not profileReference.Position.AnchorTo then
				RUF.db.profile.unit[strlower(gFrame)].Frame.Text[text].Position.AnchorTo = profileReference.Position.Anchor
			end
		else
			currentUnit = sFrame
			profileReference = RUF.db.profile.unit[strlower(sFrame)].Frame.Text[text]
			if not profileReference.Position.AnchorTo then
				RUF.db.profile.unit[strlower(sFrame)].Frame.Text[text].Position.AnchorTo = profileReference.Position.Anchor
			end
		end
		unitFrame = _G["oUF_RUF_" .. currentUnit]
		if not unitFrame or not unitFrame.Text then return end

		local currentText = unitFrame.Text[text] and unitFrame.Text[text].String
		if not currentText then return end

		currentText:SetFont(RUF:MediaFetch("font", profileReference.Font), profileReference.Size, profileReference.Outline)
		currentText:SetShadowColor(0, 0, 0, profileReference.Shadow)
		currentText:ClearAllPoints()
		-- currentText:SetHeight(5) -- FIXME currentText:GetLineHeight())
		local anchorFrame
		if profileReference.Position.AnchorFrame == "Frame" then
			anchorFrame = unitFrame
		else
			anchorFrame = unitFrame.Text[profileReference.Position.AnchorFrame].String
		end
		if profileReference.CustomWidth then
			currentText:SetWordWrap(profileReference.WordWrap or false)
			currentText:SetWidth(profileReference.Width or 0)
			currentText:SetJustifyH(profileReference.Justify or "CENTER")
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
			unitFrame:Tag(currentText, profileReference.Tag)
			currentText:UpdateTag()
			currentText:Show()
		else
			unitFrame:Untag(currentText)
			currentText:SetText("")
			currentText:Hide()
		end

		return true
	end

	if header ~= "none" or groupFrame ~= "none" then
		for i = 1, 6 do
			if not UpdateText(singleFrame, groupFrame, header, text, i) then
				break
			end
		end
	elseif singleFrame ~= "none" then
		UpdateText(singleFrame, groupFrame, header, text, -1)
	end
end

function RUF:OptionsUpdatePortraits(singleFrame, groupFrame, header)
	singleFrame = singleFrame or "none"
	groupFrame = groupFrame or "none"
	header = header or "none"

	local function UpdatePortrait(sFrame, gFrame, head, i)
		local currentUnit, unitFrame, profileReference

		if head ~= "none" then
			currentUnit = head .. "UnitButton" .. i
			profileReference = RUF.db.profile.unit[strlower(head)].Frame.Portrait
		elseif gFrame ~= "none" then
			if gFrame:match("Target") then
				currentUnit = gFrame:gsub("Target", "") .. i .. "Target"
			else
				currentUnit = gFrame .. i
			end
			profileReference = RUF.db.profile.unit[strlower(gFrame)].Frame.Portrait
		else
			currentUnit = sFrame
			profileReference = RUF.db.profile.unit[strlower(sFrame)].Frame.Portrait
		end
		unitFrame = _G["oUF_RUF_" .. currentUnit]
		if not unitFrame or not unitFrame.Portrait then return end

		unitFrame.Portrait.Enabled = profileReference.Enabled
		unitFrame.Portrait.Cutaway = profileReference.Cutaway

		unitFrame.Portrait:UpdateOptions()
		unitFrame.Portrait:ForceUpdate()

		return true
	end

	if header ~= "none" or groupFrame ~= "none" then
		for i = 1, 6 do
			if not UpdatePortrait(singleFrame, groupFrame, header, i) then
				break
			end
		end
	elseif singleFrame ~= "none" then
		UpdatePortrait(singleFrame, groupFrame, header, -1)
	end
end

function RUF:OptionsUpdateFrame(singleFrame, groupFrame, header)
	singleFrame = singleFrame or "none"
	groupFrame = groupFrame or "none"
	header = header or "none"

	local function UpdateFrame(sFrame, gFrame, head, i)
		local currentUnit, unitFrame, profileReference

		if head ~= "none" then
			currentUnit = head .. "UnitButton" .. i
			profileReference = RUF.db.profile.unit[strlower(head)]
		elseif gFrame ~= "none" then
			if gFrame:match("Target") then
				currentUnit = gFrame:gsub("Target", "") .. i .. "Target"
			else
				currentUnit = gFrame .. i
			end
			profileReference = RUF.db.profile.unit[strlower(gFrame)]
		else
			currentUnit = sFrame
			profileReference = RUF.db.profile.unit[strlower(sFrame)]
		end
		unitFrame = _G["oUF_RUF_" .. currentUnit]
		if not unitFrame then return end

		if head == "none" then
			if profileReference.Enabled == false then
				unitFrame:Disable()
				if gFrame == "Arena" then
					unitFrame:SetAttribute("oUF-enableArenaPrep", false)
				end
			else
				unitFrame:Enable()
				if gFrame == "Arena" then
					unitFrame:SetAttribute("oUF-enableArenaPrep", true)
				end
			end
		end

		if sFrame == "Player" then
			if profileReference.toggleForVehicle == true then
				unitFrame:SetAttribute("toggleForVehicle", profileReference.toggleForVehicle or false)
				if _G["oUF_RUF_Pet"] then
					_G["oUF_RUF_Pet"]:SetAttribute("toggleForVehicle", profileReference.toggleForVehicle or false)
				end
			end
		end

		if profileReference.Frame.RangeFading.Enabled == true then
			if sFrame ~= "Player" then
				if unitFrame.EnableElement then
					unitFrame:EnableElement("RangeCheck")
					unitFrame.RangeCheck = unitFrame.RangeCheckor or {}
					unitFrame.RangeCheck.enabled = profileReference.Frame.RangeFading.Enabled
					unitFrame.RangeCheck.insideAlpha = 1
					unitFrame.RangeCheck.outsideAlpha = profileReference.Frame.RangeFading.Alpha or 0.55
				end
			end
		elseif unitFrame.DisableElement then
			unitFrame:DisableElement("RangeCheck")
		end

		if unitFrame:GetWidth() ~= profileReference.Frame.Size.Width then
			unitFrame:SetWidth(profileReference.Frame.Size.Width)
			if unitFrame.ClassPower then
				unitFrame.ClassPower.UpdateOptions(unitFrame.ClassPower)
			end
		end
		unitFrame:SetHeight(profileReference.Frame.Size.Height)
		if profileReference.Frame.Portrait.Enabled then
			if profileReference.Frame.Portrait.Style == 3 then
				unitFrame.Portrait:SetHeight(profileReference.Frame.Size.Height)
			end
		end

		if i == -1 then
			RUF:UpdateFramePosition(unitFrame, sFrame, gFrame, head, i)
		end

		if gFrame ~= "none" then
			if i == 1 then
				RUF:UpdateFramePosition(unitFrame, sFrame, gFrame, head, i)
			elseif profileReference.Frame.Position.growth == "BOTTOM" then
				RUF:UpdateFramePosition(unitFrame, sFrame, gFrame, head, i, "TOP", _G["oUF_RUF_" .. gFrame .. i - 1])
			elseif profileReference.Frame.Position.growth == "TOP" then
				RUF:UpdateFramePosition(unitFrame, sFrame, gFrame, head, i, "BOTTOM", _G["oUF_RUF_" .. gFrame .. i - 1])
			end

			if gFrame == "PartyPet" or gFrame == "PartyTarget" and not RUF.db.global.TestMode == true then
				local unitType = strgsub(gFrame, "Party", "")
				local prefix, suffix
				if gFrame == "PartyPet" then
					prefix = "pet"
					suffix = ""
				elseif gFrame == "PartyTarget" then
					prefix = ""
					suffix = "target"
				end
				if RUF.db.profile.unit.party.showPlayer then
					if i == 1 then
						unitFrame:SetAttribute("unit", unitType)
						unitFrame.unit = unitType
					else
						unitFrame:SetAttribute("unit", "party" .. prefix .. i - 1 .. suffix)
						unitFrame.unit = "party" .. prefix .. i - 1 .. suffix
					end
				else
					unitFrame:SetAttribute("unit", "party" .. prefix .. i .. suffix)
					unitFrame.unit = "partypet" .. prefix .. i .. suffix
				end
			end
		end

		if head ~= "none" then
			local headerFrame = _G["oUF_RUF_" .. head]
			local anchorFrom
			if profileReference.Frame.Position.growth == "BOTTOM" then
				anchorFrom = "TOP"
			elseif profileReference.Frame.Position.growth == "TOP" then
				anchorFrom = "BOTTOM"
			end

			local growthDirection
			if profileReference.Frame.Position.growthDirection then
				if profileReference.Frame.Position.growthDirection == "VERTICAL" then
					growthDirection = 5
				elseif profileReference.Frame.Position.growthDirection == "HORIZONTAL" then
					growthDirection = 1
				end
			end

			headerFrame:SetAttribute("unitsPerColumn", growthDirection)
			headerFrame:SetAttribute("columnSpacing", profileReference.Frame.Position.offsetx)
			headerFrame:SetAttribute("columnAnchorPoint", profileReference.Frame.Position.growthHoriz)

			headerFrame:SetAttribute("Point", anchorFrom)
			headerFrame:SetAttribute("yOffset", profileReference.Frame.Position.offsety)
			headerFrame:SetAttribute("showPlayer", RUF.db.profile.unit.party.showPlayer)

			RUF:UpdateFramePosition(headerFrame, sFrame, gFrame, head)
			headerFrame.Enabled = profileReference.Enabled

			if RUF.db.global.TestMode == true then
				unitFrame:Disable()
				if profileReference.Enabled == false then
					headerFrame.visibility = "hide"
					RegisterStateDriver(headerFrame, "visibility", "hide")
					unitFrame:Hide()
				else
					headerFrame.visibility = "show"
					RegisterStateDriver(headerFrame, "visibility", "show")
					unitFrame:Show()
				end
			else
				if profileReference.Enabled == false then
					unitFrame:Disable()
					headerFrame.visibility = "hide"
					RegisterStateDriver(headerFrame, "visibility", "hide")
				else
					unitFrame:Enable()
					local showIn = "[group:party,nogroup:raid]show;hide"
					if profileReference.showRaid then
						showIn = "[group:party,nogroup:raid]show;[group:raid]show;hide"
					end
					if profileReference.showArena then
						showIn = "[@arena1,exists]show;[@arena2,exists]show;[@arena3,exists]show;" .. showIn
					end
					headerFrame.visibility = showIn
					RegisterStateDriver(headerFrame, "visibility", headerFrame.visibility)
				end
			end
			unitFrame:ClearAllPoints()
		end

		return true
	end

	if header ~= "none" or groupFrame ~= "none" then
		for i = 1, 6 do
			if not UpdateFrame(singleFrame, groupFrame, header, i) then
				break
			end
		end
	elseif singleFrame ~= "none" then
		UpdateFrame(singleFrame, groupFrame, header, -1)
	end
end

function RUF:OptionsUpdateAllBars()
	for i = 1, #RUF.frameList.frames do
		if _G["oUF_RUF_" .. RUF.frameList.frames[i]] then
			RUF:OptionsUpdateBars(RUF.frameList.frames[i], nil, nil, "Health")
			RUF:OptionsUpdateBars(RUF.frameList.frames[i], nil, nil, "Power")
			RUF:OptionsUpdateBars(RUF.frameList.frames[i], nil, nil, "HealPrediction")
			RUF:OptionsUpdateBars(RUF.frameList.frames[i], nil, nil, "Absorb")
			if i == 1 then
				RUF:OptionsUpdateBars(RUF.frameList.frames[i], nil, nil, "Class")
			end
		end
	end

	for i = 1, #RUF.frameList.groupFrames do
		RUF:OptionsUpdateBars(nil, RUF.frameList.groupFrames[i], nil, "Health")
		RUF:OptionsUpdateBars(nil, RUF.frameList.groupFrames[i], nil, "Power")
		RUF:OptionsUpdateBars(nil, RUF.frameList.groupFrames[i], nil, "HealPrediction")
		RUF:OptionsUpdateBars(nil, RUF.frameList.groupFrames[i], nil, "Absorb")
	end

	for i = 1, #RUF.frameList.headers do
		RUF:OptionsUpdateBars(nil, nil, RUF.frameList.headers[i], "Health")
		RUF:OptionsUpdateBars(nil, nil, RUF.frameList.headers[i], "Power")
		RUF:OptionsUpdateBars(nil, nil, RUF.frameList.headers[i], "HealPrediction")
		RUF:OptionsUpdateBars(nil, nil, RUF.frameList.headers[i], "Absorb")
	end

	RUF:OptionsUpdateCastbars()
end

function RUF:OptionsUpdateBars(singleFrame, groupFrame, header, bar)
	if not bar then return end
	singleFrame = singleFrame or "none"
	groupFrame = groupFrame or "none"
	header = header or "none"

	local function UpdateBar(sFrame, gFrame, head, bar, i)
		local currentUnit, unitFrame, profileReference

		if head ~= "none" then
			currentUnit = head .. "UnitButton" .. i
			profileReference = RUF.db.profile.unit[strlower(head)].Frame.Bars[bar]
		elseif gFrame ~= "none" then
			if gFrame:match("Target") then
				currentUnit = gFrame:gsub("Target", "") .. i .. "Target"
			else
				currentUnit = gFrame .. i
			end
			profileReference = RUF.db.profile.unit[strlower(gFrame)].Frame.Bars[bar]
		else
			currentUnit = sFrame
			profileReference = RUF.db.profile.unit[strlower(sFrame)].Frame.Bars[bar]
		end
		unitFrame = _G["oUF_RUF_" .. currentUnit]
		if not unitFrame or not unitFrame[bar] then return end

		unitFrame[bar].UpdateOptions(unitFrame[bar])
		unitFrame[bar]:ForceUpdate()
		if bar then
			unitFrame[bar].UpdateOptions(unitFrame[bar])
		end
		if bar == "Power" or bar == "Absorb" then
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
		elseif bar == "Class" then
			if profileReference.Enabled == true then
				unitFrame:EnableElement(bar)
				if unitFrame[bar] then
					unitFrame[bar]:ForceUpdate()
				end
			else
				unitFrame:DisableElement(bar)
			end
		end
		return true
	end

	if header ~= "none" or groupFrame ~= "none" then
		for i = 1, 6 do
			if not UpdateBar(singleFrame, groupFrame, header, bar, i) then
				break
			end
		end
	elseif singleFrame ~= "none" then
		UpdateBar(singleFrame, groupFrame, header, bar, -1)
	end
end

function RUF:SpawnUnits()
	if UnitsSpawned then return end
	TestModeToggle = true

	local partyNum, startingIndex = 0, -4
	if IsInGroup() then
		startingIndex = -3
		partyNum = GetNumSubgroupMembers()
	end

	for i = 1, #RUF.frameList.headers do
		local currentHeader = _G["oUF_RUF_" .. RUF.frameList.headers[i]]
		currentHeader:SetAttribute("startingIndex", startingIndex + partyNum)
		if currentHeader.Enabled then
			RegisterStateDriver(currentHeader, "visibility", "show")
		end
	end

	for k, v in next, oUF.objects do
		v.oldUnit = v.unit
		if v.realUnit then
			v.oldUnit = v.realUnit
		end
		v:SetAttribute("unit", "player")
		v:Disable()
		if RUF.db.profile.unit[v.frame].Enabled then
			if RUF.db.global.TestModeShowUnits then
				v.Text.DisplayName:Show()
			else
				v.Text.DisplayName:Hide()
			end
			if v.oldUnit == "party5target" or v.oldUnit == "PartyPet5" then
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
		if v.Castbar then
			v.Castbar:Show()
			v.Castbar:OnUpdate()
		end
	end
	UnitsSpawned = true
end

function RUF:RestoreUnits()
	if not UnitsSpawned then return end
	TestModeToggle = false

	for i = 1, #RUF.frameList.headers do
		local currentHeader = _G["oUF_RUF_" .. RUF.frameList.headers[i]]
		currentHeader:SetAttribute("startingIndex", 1)
		if currentHeader.Enabled then
			RegisterStateDriver(currentHeader, "visibility", currentHeader.visibility)
		else
			RegisterStateDriver(currentHeader, "visibility", "hide")
		end
	end

	for k, v in next, oUF.objects do
		if v.Castbar then
			v.Castbar:Show()
			v.Castbar:OnUpdate()
		end
		v.realUnit = v.oldUnit
		v.unit = v.oldUnit
		v:SetAttribute("unit", v.unit)
		v.Text.DisplayName:Hide()
		v:Hide()
		if v.unit == "party5target" or v.unit == "PartyPet5" then
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

	RUF.ResetPartyFrames()
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
			RUF:OptionsUpdateFrame("none", "PartyTarget", "none") -- So we also force Update and Hide/Show the 5th Party Target
			RUF:OptionsUpdateFrame("none", "PartyPet", "none")
			RUF.TogglePartyChildren("partypet")
			RUF.TogglePartyChildren("partytarget")
		end
	end
end

function RUF:UpdateAllUnitSettings()
	for i = 1, #RUF.frameList.frames do
		RUF:OptionsUpdateFrame(RUF.frameList.frames[i])
		RUF:OptionsUpdateAuras(RUF.frameList.frames[i], nil, nil, "Buffs")
		RUF:OptionsUpdateAuras(RUF.frameList.frames[i], nil, nil, "Debuffs")
		RUF:OptionsUpdatePortraits(RUF.frameList.frames[i])
	end

	for i = 1, #RUF.frameList.groupFrames do
		RUF:OptionsUpdateFrame(nil, RUF.frameList.groupFrames[i])
		RUF:OptionsUpdateAuras(nil, RUF.frameList.groupFrames[i], nil, "Buffs")
		RUF:OptionsUpdateAuras(nil, RUF.frameList.groupFrames[i], nil, "Debuffs")
		RUF:OptionsUpdatePortraits(nil, RUF.frameList.groupFrames[i])
	end
	for i = 1, #RUF.frameList.headers do
		RUF:OptionsUpdateFrame(nil, nil, RUF.frameList.headers[i])
		RUF:OptionsUpdateAuras(nil, nil, RUF.frameList.headers[i], "Buffs")
		RUF:OptionsUpdateAuras(nil, nil, RUF.frameList.headers[i], "Debuffs")
		RUF:OptionsUpdatePortraits(nil, nil, RUF.frameList.headers[i])
	end

	RUF:OptionsUpdateAllBars()
	RUF:OptionsUpdateAllTexts()
	RUF:OptionsUpdateAllIndicators()
	RUF:OptionsUpdateAllAuras()
	RUF:OptionsUpdateFrameBorders()
	RUF:OptionsUpdateCastbars()

	RUF.CombatFaderRegister()
end