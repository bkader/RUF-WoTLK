local RUF = RUF
local L = LibStub("AceLocale-3.0"):GetLocale("RUF")

local type = type
local CreateFrame = CreateFrame

--[[
	Easiest 'best' version:

	Icons need to register which point they are on, then when visibility is changed of an icon in that area we move the others appropriately.

	Icons and Text don't anchor to each other.
	Text anchor to main 9 points, top, left, right, bottomright etc.

	-- Find all tags registered for a given text by profile data. Register relevant events and update size from that.
	local pattern = '%[..-%]+'

	local mstring = '[RUF:ManaPerc][RUF:ManaPerc]'

	for a in mstring:gmatch(pattern) do
	end

]]--

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

function RUF.SetTextParent(self, unit)
	local name = self:GetName()
	local TextParent = CreateFrame("Frame", name .. ".Text", self)
	TextParent:SetFrameLevel(50)
	TextParent:SetAllPoints(self)

	local testModeDisplayName = CreateFrame("Frame", name .. ".Text.DisplayName", TextParent)
	testModeDisplayName:SetFrameLevel(100)
	testModeDisplayName:SetAllPoints(self)

	local text = testModeDisplayName:CreateFontString(name .. ".Text.DisplayName.String", "OVERLAY")
	local font = RUF:MediaFetch("font", "RUF")
	text:SetFont(font, 21, "OUTLINE")

	local displayText = name:gsub("oUF_RUF_", ""):gsub("UnitButton", "")
	local unitNum = displayText:match("%d")
	displayText = string.lower(displayText:gsub("%d", ""))
	if unitNum then
		displayText = L[displayText .. " %s"]:format(unitNum)
	else
		displayText = L[displayText]
	end

	text:SetText(displayText)
	text:SetAllPoints(testModeDisplayName)
	testModeDisplayName:Hide()

	self.Text = TextParent
	self.Text.DisplayName = testModeDisplayName
end

function RUF.SetTextPoints(self, unit, textName)
	local name = self:GetName()
	local profileReference = RUF.db.profile.unit[self.frame].Frame.Text[textName]
	local anchorFrame = "Frame"
	local element = self.Text[textName].String
	if profileReference.Position.AnchorFrame == "Frame" then
		anchorFrame = name
	else
		anchorFrame = (name .. ".Text." .. profileReference.Position.AnchorFrame .. ".String")
		if not _G[anchorFrame] then
			anchorFrame = name
		end
	end
	if not profileReference.Position.AnchorTo then
		RUF.db.profile.unit[self.frame].Frame.Text[textName].AnchorTo = profileReference.Position.Anchor
	end
	element:SetPoint(
		profileReference.Position.Anchor,
		anchorFrame,
		profileReference.Position.AnchorTo,
		profileReference.Position.x,
		profileReference.Position.y
	)

	self.Text[textName]:SetAllPoints(element)
end

function RUF.CreateTextArea(self, unit, textName)
	local name = self:GetName()
	local profileReference = RUF.db.profile.unit[self.frame].Frame.Text[textName]
	if type(profileReference) ~= "table" then return end

	-- Purely so we can control frame level
	local stringParent = CreateFrame("Frame", name .. ".Text." .. textName, self.Text)
	stringParent:SetFrameLevel(50)
	self.Text[textName] = stringParent

	local Font = RUF:MediaFetch("font", profileReference.Font, "RUF")
	local size = profileReference.Size or 18

	local Text = self.Text[textName]:CreateFontString(name .. ".Text." .. textName .. ".String", "OVERLAY")
	Text:SetFont(Font, size, profileReference.Outline)

	if not profileReference.Shadow then
		profileReference.Shadow = 0
	end
	Text:SetShadowColor(0, 0, 0, profileReference.Shadow or 1)
	Text:SetShadowOffset(1, -1)
	Text:SetTextColor(1, 1, 1, 1)
	Text.overrideUnit = true
	Text.frequentUpdates = 0.5
	local anchorPoint = profileReference.Position.Anchor
	Text:SetWordWrap(false)
	Text:SetHeight(5) -- FIXME -- Prevents FontString from collapsing to a 1x1 box when the string is empty, which our tags do to 'hide'

	if profileReference.CustomWidth then
		if not profileReference.Justify then -- Update existing texts to store this data.
			if anchorPoint == "RIGHT" or anchorPoint == "TOPRIGHT" or anchorPoint == "BOTTOMRIGHT" then
				profileReference.Justify = "RIGHT"
			elseif anchorPoint == "LEFT" or anchorPoint == "TOPLEFT" or anchorPoint == "BOTTOMLEFT" then
				profileReference.Justify = "LEFT"
			else
				profileReference.Justify = "CENTER"
			end
		end
		Text:SetWordWrap(profileReference.WordWrap or false)
		Text:SetWidth(profileReference.Width or 300)
		Text:SetJustifyH(profileReference.Justify)
	end

	self.Text[textName].String = Text
	self:Tag(Text, profileReference.Tag)
end