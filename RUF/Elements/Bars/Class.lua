assert(RUF, "RUF not found!")
local RUF = RUF
local uClass = RUF.uClass

local classPowerData = {
	DRUID = {
		classPowerID = 14,
		classPowerType = "COMBO_POINTS",
		unitPowerMaxAmount = 5
	},
	ROGUE = {
		classPowerID = 14,
		classPowerType = "COMBO_POINTS",
		unitPowerMaxAmount = 5
	}
}

function RUF.SetClassBar(self, unit)
	if not classPowerData[uClass] then
		return
	end
	local classPowerBar = {}
	local unitPowerMaxAmount = classPowerData[uClass].unitPowerMaxAmount or 5

	local name = self:GetName() .. ".ComboPoints"
	self.ComboPoints = {}

	local Holder = CreateFrame("Frame", name .. ".Holder", self)
	Holder.barHeight = RUF.db.profile.unit[unit].Frame.Bars.Class.Height

	if RUF.db.profile.unit[unit].Frame.Bars.Class.Position.Anchor == "TOP" then
		Holder:SetPoint("TOP", 0, 0)
		Holder:SetPoint("LEFT", 0, 0)
		Holder:SetPoint("RIGHT", 0, 0)
		Holder:SetHeight(RUF.db.profile.unit[unit].Frame.Bars.Class.Height)
		Holder.anchorTo = "TOP"
	else
		Holder:ClearAllPoints()
		Holder:SetPoint("BOTTOM", 0, 0)
		Holder:SetPoint("LEFT", 0, 0)
		Holder:SetPoint("RIGHT", 0, 0)
		Holder:SetHeight(RUF.db.profile.unit[unit].Frame.Bars.Class.Height)
		Holder.anchorTo = "BOTTOM"
	end

	local texture = RUF:MediaFetch("statusbar", RUF.db.profile.Appearance.Bars.Class.Texture)
	local r, g, b = unpack(RUF.db.profile.Appearance.Colors.PowerColors[classPowerData[uClass].classPowerID])
	local bgMult = RUF.db.profile.Appearance.Bars.Class.Background.Multiplier
	local colorAdd = RUF.db.profile.Appearance.Bars.Class.Color.SegmentMultiplier

	for i = 1, unitPowerMaxAmount do
		local Bar = RUF.StatusBarPrototype(name .. i, Holder)
		local Border = CreateFrame("Frame", name .. i .. ".Border", Bar)
		local Background = Bar.bg
		local size = (RUF.db.profile.unit[unit].Frame.Size.Width + (unitPowerMaxAmount - 1)) / unitPowerMaxAmount
		local counter = i
		if unitPowerMaxAmount == 4 then
			counter = i + 1
		end

		-- Set Bar Parent Size
		Bar:SetWidth(size)
		Bar:SetHeight(RUF.db.profile.unit[unit].Frame.Bars.Class.Height)
		if i == 1 then
			Bar:SetPoint("TOPLEFT", Holder, "TOPLEFT", 0, 0)
		else
			Bar:SetPoint("TOPLEFT", classPowerBar[i - 1], "TOPRIGHT", -1, 0)
		end
		Bar:SetFrameLevel(15)

		-- Set Status Bar
		Bar:SetFillStyle(RUF.db.profile.unit[unit].Frame.Bars.Class.Fill)
		Bar:SetFrameLevel(16)
		Bar:SetStatusBarTexture(texture)
		local ir = (r * (((counter + colorAdd) * 6.6667) / 100))
		local ig = (g * (((counter + colorAdd) * 6.6667) / 100))
		local ib = (b * (((counter + colorAdd) * 6.6667) / 100))
		Bar:SetStatusBarColor(ir, ig, ib)

		-- Set Border
		local offset = RUF.db.profile.Appearance.Bars.Class.Border.Offset or 0
		Border:SetPoint("TOPLEFT", Bar, "TOPLEFT", -offset, offset)
		Border:SetPoint("BOTTOMRIGHT", Bar, "BOTTOMRIGHT", offset, -offset)
		Border:SetFrameLevel(17)
		Border:SetBackdrop({
			edgeFile = RUF:MediaFetch("border", RUF.db.profile.Appearance.Bars.Class.Border.Style.edgeFile),
			edgeSize = RUF.db.profile.Appearance.Bars.Class.Border.Style.edgeSize
		})
		local borderr, borderg, borderb = unpack(RUF.db.profile.Appearance.Bars.Class.Border.Color)
		Border:SetBackdropBorderColor(borderr, borderg, borderb, RUF.db.profile.Appearance.Bars.Class.Border.Alpha)

		-- Set Background
		Background:SetAllPoints(Bar)
		Background:SetTexture(RUF:MediaFetch("background", "Solid"))
		Background:SetVertexColor(r * bgMult, g * bgMult, b * bgMult, RUF.db.profile.Appearance.Bars.Class.Background.Alpha)
		Background:Show()

		classPowerBar[i] = Bar
		self.ComboPoints[i] = Bar
		self.ComboPoints[i].Border = Border
		self.ComboPoints[i].Background = Background
	end

	self.ComboPoints.Override = RUF.ClassUpdate
	self.ComboPoints.UpdateColor = RUF.ClassUpdateColor
	self.ComboPoints.Holder = Holder
	self.ComboPoints.Holder.__owner = self
	self.ComboPoints.UpdateOptions = RUF.ClassUpdateOptions

	-- Force an update to make sure we are showing the correct number of bars for classes with talents that add additional points.
	RUF.ClassUpdate(self, "PLAYER_TALENT_UPDATE", unit, classPowerData[uClass].classPowerType)
end

function RUF.ClassUpdateColor(element, powerType)
	local r, g, b = unpack(RUF.db.profile.Appearance.Colors.PowerColors[classPowerData[uClass].classPowerID])
	local colorAdd = RUF.db.profile.Appearance.Bars.Class.Color.SegmentMultiplier
	for i = 1, #element do
		local counter = i
		if #element == 4 then
			counter = i + 1
		end
		local Bar = element[i]
		local Background = element[i].Background
		local ir = (r * (((counter + colorAdd) * 6.6667) / 100))
		local ig = (g * (((counter + colorAdd) * 6.6667) / 100))
		local ib = (b * (((counter + colorAdd) * 6.6667) / 100))
		Bar:SetStatusBarColor(ir, ig, ib)

		-- Update background
		local bgMult = RUF.db.profile.Appearance.Bars.Class.Background.Multiplier
		if RUF.db.profile.Appearance.Bars.Class.Background.UseBarColor == false then
			r, g, b = unpack(RUF.db.profile.Appearance.Bars.Class.Background.CustomColor)
		end
		Background:SetVertexColor(r * bgMult, g * bgMult, b * bgMult, RUF.db.profile.Appearance.Bars.Class.Background.Alpha)
	end
end

function RUF.ClassUpdate(self, event, unit, powerType)
	unit = unit or event == "PLAYER_TARGET_CHANGED" and "player" or nil
	-- Override function of oUF's ComboPoints Update function.
	if unit ~= "player" or not self.frame then return end
	if (powerType == classPowerData[uClass].classPowerType or (unit == "vehicle" and powerType == "COMBO_POINTS")) then
		return
	end

	local element = self.ComboPoints
	if RUF.db.profile.unit[self.frame].Frame.Bars.Class.Enabled ~= true then
		self:DisableElement("ComboPoints")
		return
	end

	local max, cur, oldMax = 5
	if event ~= "ComboPointsDisable" then
		cur = GetComboPoints(UnitHasVehicleUI("player") and "vehicle" or "player", "target")

		local size = (RUF.db.profile.unit[self.frame].Frame.Size.Width + (max - 1)) / max
		if event == "UNIT_COMBO_POINTS" or event == "PLAYER_TALENT_UPDATE" or event == "ComboPointsEnable" or event == "ForceUpdate" then
			for i = 1, #element do
				if i > max then
					if element[i]:IsVisible() then
						element[i]:Hide()
						element[i]:SetValue(0)
						for j = 1, #element do
							element[j]:SetWidth(size)
						end
					end
				else
					if not element[i]:IsVisible() then
						element[i]:Show()
						element[i]:SetValue(1)
						for j = 1, #element do
							element[j]:SetWidth(size)
						end
					end
				end
			end
		end

		if RUF.db.global.TestMode == true then
			cur = math.random(0, max)
		end

		local numActive = cur + 0.9
		for i = 1, #element do
			if (i > numActive) then
				element[i]:SetValue(0)
			else
				element[i]:SetValue(cur - i + 1)
			end
		end

		oldMax = element.__max
		if (max ~= oldMax) then
			element.__max = max
		end
	end

	if event == "ComboPointsDisable" then
		self.ComboPoints.Holder:Hide()
	end
	if event == "ComboPointsEnable" then
		self.ComboPoints.Holder:Show()
	end
end

function RUF.ClassUpdateOptions(self)
	if not classPowerData[uClass] or not self.__owner then return end
	local unit = self.__owner.frame
	local unitPowerMaxAmount = classPowerData[uClass].unitPowerMaxAmount or 5
	local texture = RUF:MediaFetch("statusbar", RUF.db.profile.Appearance.Bars.Class.Texture)
	local r, g, b = unpack(RUF.db.profile.Appearance.Colors.PowerColors[classPowerData[uClass].classPowerID])
	local bgMult = RUF.db.profile.Appearance.Bars.Class.Background.Multiplier
	local colorAdd = RUF.db.profile.Appearance.Bars.Class.Color.SegmentMultiplier
	local element = self.__owner.ComboPoints
	local holder = self.__owner.ComboPoints.Holder
	holder:SetHeight(RUF.db.profile.unit[unit].Frame.Bars.Class.Height)
	holder.barHeight = RUF.db.profile.unit[unit].Frame.Bars.Class.Height

	for i = 1, unitPowerMaxAmount do
		local Bar = self[i]
		local Background = self[i].Background
		local Border = self[i].Border
		local size = (RUF.db.profile.unit[unit].Frame.Size.Width + (unitPowerMaxAmount - 1)) / unitPowerMaxAmount
		local counter = i
		if unitPowerMaxAmount == 4 then
			counter = i + 1
		end

		-- Set Bar Parent Size
		Bar:SetWidth(size)
		Bar:SetHeight(RUF.db.profile.unit[unit].Frame.Bars.Class.Height)
		Bar:SetFrameLevel(15)

		-- Set Status Bar
		Bar:SetFillStyle(RUF.db.profile.unit[unit].Frame.Bars.Class.Fill)
		Bar:SetFrameLevel(16)
		Bar:SetStatusBarTexture(texture)
		local ir = (r * (((counter + colorAdd) * 6.6667) / 100))
		local ig = (g * (((counter + colorAdd) * 6.6667) / 100))
		local ib = (b * (((counter + colorAdd) * 6.6667) / 100))
		Bar:SetStatusBarColor(ir, ig, ib)

		-- Set Border
		local offset = RUF.db.profile.Appearance.Bars.Class.Border.Offset or 0
		Border:SetPoint("TOPLEFT", Bar, "TOPLEFT", -offset, offset)
		Border:SetPoint("BOTTOMRIGHT", Bar, "BOTTOMRIGHT", offset, -offset)
		Border:SetFrameLevel(17)
		Border:SetBackdrop({
			edgeFile = RUF:MediaFetch("border", RUF.db.profile.Appearance.Bars.Class.Border.Style.edgeFile),
			edgeSize = RUF.db.profile.Appearance.Bars.Class.Border.Style.edgeSize
		})
		local borderr, borderg, borderb = unpack(RUF.db.profile.Appearance.Bars.Class.Border.Color)
		Border:SetBackdropBorderColor(borderr, borderg, borderb, RUF.db.profile.Appearance.Bars.Class.Border.Alpha)

		-- Set Background
		Background:SetAllPoints(Bar)
		Background:SetTexture(RUF:MediaFetch("background", "Solid"))
		Background:SetVertexColor(r * bgMult, g * bgMult, b * bgMult, RUF.db.profile.Appearance.Bars.Class.Background.Alpha)

		if RUF.db.profile.unit[unit].Frame.Bars.Class.Enabled == true then
			self.__owner:EnableElement("ComboPoints")
			if i > unitPowerMaxAmount then
				if element[i]:IsVisible() then
					element[i]:Hide()
					element[i]:SetValue(0)
					for j = 1, #element do
						element[j]:SetWidth(size)
					end
				end
			else
				if not element[i]:IsVisible() then
					element[i]:Show()
					for j = 1, #element do
						element[j]:SetWidth(size)
					end
				end
			end
		end
	end

	RUF.SetBarLocation(self.__owner, unit)
	self:ForceUpdate()
end