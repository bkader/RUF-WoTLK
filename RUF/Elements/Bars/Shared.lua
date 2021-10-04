assert(RUF, "RUF not found!")
local RUF = RUF
local uClass = RUF.uClass

function RUF:GetBarColor(element, unit, barType, overridePowerType, testCurrent)
	local pType, uClass, _
	local profileReference
	if overridePowerType then
		if barType == "HealPrediction" then
			if overridePowerType == "Player" then
				profileReference = RUF.db.profile.Appearance.Bars.HealPrediction.Player.Color
			else
				profileReference = RUF.db.profile.Appearance.Bars.HealPrediction.Others.Color
			end
		else
			profileReference = RUF.db.profile.Appearance.Bars[barType].Color
			if overridePowerType ~= "Health" then
				pType = overridePowerType
			end
		end
	else
		profileReference = RUF.db.profile.Appearance.Bars[barType].Color
		pType, _ = UnitPowerType(unit)
	end
	local colorProfile = RUF.db.profile.Appearance.Colors
	_, uClass = UnitClass(unit)
	if not barType then
		return 1, 0, 1
	end -- Return magenta to show I messed up somewhere.
	if not uClass then
		uClass = "PRIEST"
	end
	local r, g, b = unpack(profileReference.BaseColor)
	local colorMult = profileReference.Multiplier
	if colorMult > 1 then
		colorMult = 1
	end -- Because we replaced Class bar multiplier default setting which could be higher.
	r = r * colorMult
	g = g * colorMult
	b = b * colorMult
	-- Color Priority: Disconnected, Tapped, Class (if unit is a player unit), Reaction, Power Type, Percentage Class, Percentage Power, Percentage, Base
	if profileReference.Disconnected and element.disconnected then
		r, g, b = unpack(colorProfile.MiscColors.Disconnected)
		r = r * colorMult
		g = g * colorMult
		b = b * colorMult
		return r, g, b
	end
	if profileReference.Tapped and element.tapped then
		r, g, b = unpack(colorProfile.MiscColors.Tapped)
		r = r * colorMult
		g = g * colorMult
		b = b * colorMult
		return r, g, b
	end
	if profileReference.Class and UnitIsPlayer(unit) then
		r, g, b = unpack(colorProfile.ClassColors[uClass])
		r = r * colorMult
		g = g * colorMult
		b = b * colorMult
		return r, g, b
	end
	if profileReference.Reaction then
		if UnitPlayerControlled(unit) and not UnitCanAttack(unit, "player") and not UnitIsPlayer(unit) then -- If the unit is an allied pet then show as blue.
			r, g, b = unpack(colorProfile.ReactionColors[10])
			r = r * colorMult
			g = g * colorMult
			b = b * colorMult
			return r, g, b
		elseif UnitReaction(unit, "player") then
			r, g, b = unpack(colorProfile.ReactionColors[UnitReaction(unit, "player")])
			r = r * colorMult
			g = g * colorMult
			b = b * colorMult
			return r, g, b
		elseif UnitInParty(unit) then
			r, g, b = unpack(colorProfile.ReactionColors[5]) -- So Reaction Works when Party member is in a different zone and UnitReaction returns nil
			r = r * colorMult
			g = g * colorMult
			b = b * colorMult
			return r, g, b
		end
	end
	if profileReference.PowerType and barType ~= "Health" then
		r, g, b = unpack(colorProfile.PowerColors[pType])
		r = r * colorMult
		g = g * colorMult
		b = b * colorMult
		return r, g, b
	end
	if profileReference.Percentage then
		local colorGradient = {unpack(profileReference.PercentageGradient)}
		-- Priority is by class, by power type, then base colour in keeping with non-percent color priority.
		if profileReference.percentageMaxPower then
			colorGradient[7], colorGradient[8], colorGradient[9] = unpack(colorProfile.PowerColors[pType])
		end
		if profileReference.percentage50Power then
			colorGradient[4], colorGradient[5], colorGradient[6] = unpack(colorProfile.PowerColors[pType])
		end
		if profileReference.percentage0Power then
			colorGradient[1], colorGradient[2], colorGradient[3] = unpack(colorProfile.PowerColors[pType])
		end
		if profileReference.percentageMaxClass and UnitIsPlayer(unit) then
			colorGradient[7], colorGradient[8], colorGradient[9] = unpack(colorProfile.ClassColors[uClass])
		end
		if profileReference.percentage50Class and UnitIsPlayer(unit) then
			colorGradient[4], colorGradient[5], colorGradient[6] = unpack(colorProfile.ClassColors[uClass])
		end
		if profileReference.percentage0Class and UnitIsPlayer(unit) then
			colorGradient[1], colorGradient[2], colorGradient[3] = unpack(colorProfile.ClassColors[uClass])
		end
		local cur, max = UnitPower(unit, pType), UnitPowerMax(unit, pType)
		if barType == "Health" or barType == "HealPrediction" then
			cur, max = UnitHealth(unit), UnitHealthMax(unit)
		end
		if RUF.db.global.TestMode == true then
			cur = testCurrent or math.random(25, 75)
			if barType == "Power" then
				max = 100
			end
		end
		r, g, b = RUF:ColorGradient(cur, max, unpack(colorGradient))
		r = r * colorMult
		g = g * colorMult
		b = b * colorMult
		return r, g, b
	end
	return r, g, b
end

function RUF.SetBarLocation(self, unit)
	if not self then
		return
	end
	if unit == "ACTIVE_TALENT_GROUP_CHANGED" then
		unit = "player"
	end
	if unit == "PLAYER_ENTERING_WORLD" then
		unit = "player"
	end
	local profileUnit = self.frame
	local profileReference = RUF.db.profile.unit[profileUnit].Frame.Bars
	local barsAtTop = {}
	local barsAtBottom = {}
	if profileUnit == "player" then
		local _, pType = UnitPowerType(unit)
		local visibleTopBars = false
		local visibleBottomBars = false
		local powerShouldShow = false
		if profileReference.Class.Position.Anchor == profileReference.Power.Position.Anchor then
			-- Force override from old broken ability to place both bars at same location
			RUF.db.profile.unit[profileUnit].Frame.Bars.Class.Position.Anchor = "TOP"
			RUF.db.profile.unit[profileUnit].Frame.Bars.Power.Position.Anchor = "BOTTOM"
		end
		if self.ClassPower and profileReference.Class.Enabled == true then
			if profileReference.Class.Position.Anchor == "TOP" then
				table.insert(barsAtTop, "ClassPower")
			else
				table.insert(barsAtBottom, "ClassPower")
			end
		end
		if self.Runes and profileReference.Class.Enabled == true then
			if profileReference.Class.Position.Anchor == "TOP" then
				table.insert(barsAtTop, "Runes")
			else
				table.insert(barsAtBottom, "Runes")
			end
		end

		if profileReference.Power.Enabled == 1 then
			if RUF.db.global.TestMode == true then
				powerShouldShow = true
			end
			if UnitPower(unit) > 0 then
				powerShouldShow = true
			end
		end
		if profileReference.Power.Enabled == 2 then
			powerShouldShow = true
		end
		if powerShouldShow == true then
			if profileReference.Power.Position.Anchor == "TOP" then
				table.insert(barsAtTop, "Power")
			else
				table.insert(barsAtBottom, "Power")
			end
		end
		local bottomOffset
		for i = 1, #barsAtTop do
			local element
			local profileName = "Class"
			if barsAtTop[i] == "ClassPower" then
				element = self.ClassPower.Holder
			elseif barsAtTop[i] == "Runes" then
				element = self.Runes.Holder
			elseif barsAtTop[i] == "Power" then
				profileName = "Power"
				element = self.Power
			end
			element:ClearAllPoints()
			element:SetPoint("TOP", 0, 0)
			element:SetPoint("LEFT", 0, 0)
			element:SetPoint("RIGHT", 0, 0)
			element:SetHeight(profileReference[profileName].Height)
			element.anchorTo = "TOP"
			if element:IsVisible() then
				visibleTopBars = true
				self.Background.Base:SetPoint("TOPLEFT", element, "BOTTOMLEFT", 0, 0)
			end
		end
		for i = 1, #barsAtBottom do
			local element
			local profileName = "Class"
			if barsAtBottom[i] == "ClassPower" then
				element = self.ClassPower.Holder
			elseif barsAtBottom[i] == "Runes" then
				element = self.Runes.Holder
			elseif barsAtBottom[i] == "Power" then
				profileName = "Power"
				element = self.Power
			end
			element:ClearAllPoints()
			element:SetPoint("BOTTOM", 0, 0)
			element:SetPoint("LEFT", 0, 0)
			element:SetPoint("RIGHT", 0, 0)
			element:SetHeight(profileReference[profileName].Height)
			element.anchorTo = "BOTTOM"
			if element:IsVisible() then
				visibleBottomBars = true
				self.Background.Base:SetPoint("BOTTOMRIGHT", element, "TOPRIGHT", 0, 0)
			end
		end
		if visibleTopBars == false then
			self.Background.Base:SetPoint("TOPLEFT", self, 0, 0)
		end
		if visibleBottomBars == false then
			self.Background.Base:SetPoint("BOTTOMRIGHT", self, 0, 0)
		end
	else
		local powerShouldShow = false
		if profileReference.Power.Enabled == 2 then
			powerShouldShow = true
		end
		if profileReference.Power.Enabled == 1 then
			if RUF.db.global.TestMode == true then
				powerShouldShow = true
			end
			if UnitPower(profileUnit) > 0 then
				powerShouldShow = true
			end
		end
		if powerShouldShow then
			if profileReference.Power.Position.Anchor == "TOP" then
				table.insert(barsAtTop, "Power")
			else
				table.insert(barsAtBottom, "Power")
			end
		end
		local bottomOffset
		for i = 1, #barsAtTop do
			local element
			local profileName = barsAtTop[i]
			if barsAtTop[i] == "Power" then
				profileName = "Power"
				element = self.Power
			end
			element:ClearAllPoints()
			element:SetPoint("TOP", 0, 0)
			element:SetPoint("LEFT", 0, 0)
			element:SetPoint("RIGHT", 0, 0)
			element:SetHeight(profileReference[profileName].Height)
			element.anchorTo = "TOP"
			self.Background.Base:SetPoint("TOPLEFT", element, "BOTTOMLEFT", 0, 0)
		end
		for i = 1, #barsAtBottom do
			local element
			local profileName = barsAtBottom[i]
			if barsAtBottom[i] == "Power" then
				profileName = "Power"
				element = self.Power
			end
			element:ClearAllPoints()
			element:SetPoint("BOTTOM", 0, 0)
			element:SetPoint("LEFT", 0, 0)
			element:SetPoint("RIGHT", 0, 0)
			element:SetHeight(profileReference[profileName].Height)
			element.anchorTo = "BOTTOM"
			self.Background.Base:SetPoint("BOTTOMRIGHT", element, "TOPRIGHT", 0, 0)
		end
		if #barsAtTop == 0 then
			self.Background.Base:SetPoint("TOPLEFT", self, 0, 0)
		end
		if #barsAtBottom == 0 then
			self.Background.Base:SetPoint("BOTTOMRIGHT", self, 0, 0)
		end
	end
end