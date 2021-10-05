assert(RUF, "RUF not found!")
local RUF = RUF
local _, ns = ...
local oUF = ns.oUF

local unpack = unpack

local offsetFix = 0.3

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

local function PortraitPostUpdate(self, unit)
	if self and self.Alpha then
		self:SetAlpha(self.Alpha)
	end
end

function RUF.SetFramePortrait(self, unit)
	local profileReference = RUF.db.profile.unit[unit].Frame.Portrait
	if not profileReference then return end

	local Portrait = CreateFrame("PlayerModel", nil, self)
	local Border = CreateFrame("Frame", nil, Portrait)
	local Background = Portrait:CreateTexture(nil, "BACKGROUND")

	Portrait:SetFrameLevel(self.Health:GetFrameLevel() + 1)

	-- Border
	local offset = profileReference.Border.Offset
	Border:SetPoint("TOPLEFT", Portrait, "TOPLEFT", -(offset + offsetFix), offset + offsetFix)
	Border:SetPoint("BOTTOMRIGHT", Portrait, "BOTTOMRIGHT", offset + offsetFix, -(offset + offsetFix))
	Border:SetFrameLevel(Portrait:GetFrameLevel() + 1)
	Border:SetBackdrop({
		edgeFile = RUF:MediaFetch("border", profileReference.Border.Style.edgeFile),
		edgeSize = profileReference.Border.Style.edgeSize
	})

	local r, g, b = unpack(profileReference.Border.Color)
	Border:SetBackdropBorderColor(r, g, b, profileReference.Border.Alpha)

	-- Background
	r, g, b = unpack(profileReference.Background.Color)
	Background:SetTexture(RUF:MediaFetch("background", "Solid"))
	Background:SetVertexColor(r, g, b, profileReference.Background.Alpha)
	Background:SetPoint("TOPLEFT", Portrait, "TOPLEFT", -offsetFix, offsetFix)
	Background:SetPoint("BOTTOMRIGHT", Portrait, "BOTTOMRIGHT", offsetFix, -offsetFix)

	if profileReference.Style == 1 then
		Background:Hide()
		Border:Hide()
		Portrait.Alpha = profileReference.Alpha
		if profileReference.Cutaway == true then
			Portrait:ClearAllPoints()
			local ofs = -0.15
			Portrait:SetPoint("TOPLEFT", self.Health.bg, "TOPLEFT", -ofs, ofs)
			Portrait:SetPoint("BOTTOMRIGHT", self.Health.bg, "BOTTOMRIGHT", ofs, -ofs)
			Portrait.Cutaway = true
		else
			Portrait:ClearAllPoints()
			Portrait:SetAllPoints(self)
		end
	elseif profileReference.Style == 2 then
		Portrait.Alpha = 1
		Portrait:SetSize(profileReference.Width, profileReference.Height)
		Portrait:ClearAllPoints()
		Portrait:SetPoint(profileReference.Position.AnchorFrom, self, profileReference.Position.AnchorTo, profileReference.Position.x - offsetFix, profileReference.Position.y - offsetFix)
	end

	-- Register with oUF
	self.Portrait = Portrait
	self.Portrait.Border = Border
	self.Portrait.Background = Background
	self.Portrait.UpdateOptions = RUF.PortraitUpdateOptions
	self.Portrait.PostUpdate = PortraitPostUpdate
	self.Portrait.Enabled = true

	if profileReference.Enabled ~= true then
		self:DisableElement("Portrait")
		self.Portrait.Enabled = false
	end
end

function RUF.PortraitUpdateOptions(self)
	local unit = self.__owner.frame
	local Portrait = self
	local Background = self.Background
	local Border = self.Border
	local profileReference = RUF.db.profile.unit[unit].Frame.Portrait
	if profileReference.Enabled == true then
		Portrait.Enabled = true
		self.__owner:EnableElement("Portrait")
		Portrait:Show()
		self.__owner:SetHitRectInsets(0, 0, 0, 0)
		if profileReference.Style == 1 then
			Background:Hide()
			Border:Hide()
			Portrait.Cutaway = profileReference.Cutaway
			Portrait.Alpha = profileReference.Alpha
			Portrait:SetAlpha(profileReference.Alpha)
			if profileReference.Cutaway == true then
				Portrait:ClearAllPoints()
				local offset = -0.15
				Portrait:SetPoint("TOPLEFT", self.__owner.Health.fg, "TOPLEFT", -offset, offset)
				Portrait:SetPoint("BOTTOMRIGHT", self.__owner.Health.fg, "BOTTOMRIGHT", offset, -offset)
			else
				Portrait:ClearAllPoints()
				Portrait:SetAllPoints(self.__owner)
			end
		elseif profileReference.Style == 2 or profileReference.Style == 3 then
			Background:Show()
			Border:Show()
			Portrait.Alpha = 1
			Portrait:SetAlpha(1)
			Portrait:ClearAllPoints()

			-- Border
			local offset = profileReference.Border.Offset
			Border:SetPoint("TOPLEFT", Portrait, "TOPLEFT", -(offset + offsetFix), offset + offsetFix)
			Border:SetPoint("BOTTOMRIGHT", Portrait, "BOTTOMRIGHT", offset + offsetFix, -(offset + offsetFix))
			Border:SetFrameLevel(17)
			Border:SetBackdrop({
				edgeFile = RUF:MediaFetch("border", profileReference.Border.Style.edgeFile),
				edgeSize = profileReference.Border.Style.edgeSize
			})
			local r, g, b = unpack(profileReference.Border.Color)
			Border:SetBackdropBorderColor(r, g, b, profileReference.Border.Alpha)

			-- Background
			r, g, b = unpack(profileReference.Background.Color)
			Background:SetTexture(RUF:MediaFetch("background", "Solid"))
			Background:SetVertexColor(r, g, b, profileReference.Background.Alpha)
			Background:SetPoint("TOPLEFT", Portrait, "TOPLEFT", -offsetFix, offsetFix)
			Background:SetPoint("BOTTOMRIGHT", Portrait, "BOTTOMRIGHT", offsetFix, -offsetFix)

			Portrait.Cutaway = false
			if profileReference.Style == 2 then
				Portrait:SetSize(profileReference.Width, profileReference.Height)
				Portrait:SetPoint(profileReference.Position.AnchorFrom, self.__owner, profileReference.Position.AnchorTo, profileReference.Position.x - offsetFix, profileReference.Position.y - offsetFix)
			elseif profileReference.Style == 3 then
				Portrait:SetSize(profileReference.Width, self.__owner:GetHeight())
				local anchor = profileReference.Position.AttachedStyleAnchor or "LEFT"
				local anchorTo = anchorSwaps[anchor]
				Portrait:SetPoint(anchorTo, self.__owner, anchor, 0 - offsetFix, 0 - offsetFix)
				if anchor == "LEFT" then
					self.__owner:SetHitRectInsets(-profileReference.Width, 0, 0, 0)
				else
					self.__owner:SetHitRectInsets(0, -profileReference.Width, 0, 0, 0)
				end
			end
		end
	else
		Portrait.Enabled = false
		self.__owner:DisableElement("Portrait")
		Portrait:Hide()
	end
end