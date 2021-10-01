assert(RUF, "RUF not found!")
local RUF = RUF
local LSM = LibStub("LibSharedMedia-3.0")
local _, ns = ...
local oUF = ns.oUF

local uClass = select(2, UnitClass("player"))

local classPowerData = {
	DRUID = {
		classPowerID = 14,
		classPowerType = "COMBO_POINTS"
	},
	ROGUE = {
		classPowerID = 14,
		classPowerType = "COMBO_POINTS",
		unitPowerMaxAmount = 5
	}
}

function RUF.SetClassicClassBar(self, unit)
	if not classPowerData[uClass] then return end
	local classPowerBar = {}
	local classPowerBorder = {}
	local classPowerBackground = {}
	local unitPowerMaxAmount =
		classPowerData[uClass].unitPowerMaxAmount or UnitPowerMax(unit, classPowerData[uClass].classPowerID)

	local name = self:GetName() .. ".ClassicClassPower"
	self.ClassicClassPower = {}

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

	local texture = LSM:Fetch("statusbar", RUF.db.profile.Appearance.Bars.Class.Texture)
	local r, g, b = unpack(RUF.db.profile.Appearance.Colors.PowerColors[classPowerData[uClass].classPowerID])
	local bgMult = RUF.db.profile.Appearance.Bars.Class.Background.Multiplier
	local colorAdd = RUF.db.profile.Appearance.Bars.Class.Color.SegmentMultiplier

	for i = 1, unitPowerMaxAmount do
		local Bar = RUF.StatusBarPrototype(name .. i, Holder)
		local Border = CreateFrame("Frame", name .. i .. ".Border", Bar, BackdropTemplateMixin and "BackdropTemplate")
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
		-- Bar:SetFillStyle(RUF.db.profile.unit[unit].Frame.Bars.Class.Fill)
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
			edgeFile = LSM:Fetch("border", RUF.db.profile.Appearance.Bars.Class.Border.Style.edgeFile),
			edgeSize = RUF.db.profile.Appearance.Bars.Class.Border.Style.edgeSize
		})
		local borderr, borderg, borderb = unpack(RUF.db.profile.Appearance.Bars.Class.Border.Color)
		Border:SetBackdropBorderColor(borderr, borderg, borderb, RUF.db.profile.Appearance.Bars.Class.Border.Alpha)

		-- Set Background
		Background:SetAllPoints(Bar)
		Background:SetTexture(LSM:Fetch("background", "Solid"))
		Background:SetVertexColor(r * bgMult, g * bgMult, b * bgMult, RUF.db.profile.Appearance.Bars.Class.Background.Alpha)
		Background:Show()

		classPowerBar[i] = Bar
		classPowerBorder[i] = Border
		classPowerBackground[i] = Background
		self.ClassicClassPower[i] = Bar
		self.ClassicClassPower[i].Border = Border
		self.ClassicClassPower[i].Background = Background
	end

	self.ClassicClassPower.Override = RUF.ClassicClassUpdate
	self.ClassicClassPower.UpdateColor = RUF.ClassicClassUpdateColor
	self.ClassicClassPower.Holder = Holder
	self.ClassicClassPower.Holder.__owner = self
	self.ClassicClassPower.UpdateOptions = RUF.ClassicClassUpdateOptions

	-- Force an update to make sure we are showing the correct number of bars for classes with talents that add additional points.
	RUF.ClassicClassUpdate(self, "PLAYER_TALENT_UPDATE", unit, classPowerData[uClass].classPowerType)
end

function RUF.ClassicClassUpdateColor(element, powerType)
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

function RUF.ClassicClassUpdate(self, event, unit, powerType)
	-- Override function of oUF's ClassPower Update function.
	if not unit then
		return
	end
	if
		not UnitIsUnit(unit, "player") and
			(powerType == classPowerData[uClass].classPowerType or (unit == "vehicle" and powerType == "COMBO_POINTS"))
	 then
		return
	end

	local element = self.ClassicClassPower
	if RUF.db.profile.unit[self.frame].Frame.Bars.Class.Enabled ~= true then
		self:DisableElement("ClassicClassPower")
		return
	end

	local cur, max, oldMax
	if event ~= "ClassPowerDisable" then
		local powerID = unit == "vehicle" and SPELL_POWER_COMBO_POINTS or classPowerData[uClass].classPowerID
		cur = UnitPower(unit, powerID, true)
		max = UnitPowerMax(unit, powerID)

		local numActive = cur + 0.9
		local size = (RUF.db.profile.unit[self.frame].Frame.Size.Width + (max - 1)) / max
		if
			event == "UNIT_MAXPOWER" or event == "PLAYER_TALENT_UPDATE" or event == "ClassPowerEnable" or
				event == "ForceUpdate"
		 then
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
		for i = 1, #element do
			if cur >= i then
				element[i]:SetValue(cur)
			else
				element[i]:SetValue(0)
			end
		end

		oldMax = element.__max
		if (max ~= oldMax) then
			element.__max = max
		end
	end

	if event == "ClassPowerDisable" then
		self.ClassicClassPower.Holder:Hide()
	end
	if event == "ClassPowerEnable" then
		self.ClassicClassPower.Holder:Show()
	end
end

function RUF.ClassicClassUpdateOptions(self)
	if not classPowerData[uClass] then
		return
	end
	local unit = self.__owner.frame
	local unitPowerMaxAmount =
		classPowerData[uClass].unitPowerMaxAmount or UnitPowerMax(unit, classPowerData[uClass].classPowerID)
	local texture = LSM:Fetch("statusbar", RUF.db.profile.Appearance.Bars.Class.Texture)
	local r, g, b = unpack(RUF.db.profile.Appearance.Colors.PowerColors[classPowerData[uClass].classPowerID])
	local bgMult = RUF.db.profile.Appearance.Bars.Class.Background.Multiplier
	local colorAdd = RUF.db.profile.Appearance.Bars.Class.Color.SegmentMultiplier
	local element = self.__owner.ClassicClassPower
	local holder = self.__owner.ClassicClassPower.Holder
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
		-- Bar:SetFillStyle(RUF.db.profile.unit[unit].Frame.Bars.Class.Fill)
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
			edgeFile = LSM:Fetch("border", RUF.db.profile.Appearance.Bars.Class.Border.Style.edgeFile),
			edgeSize = RUF.db.profile.Appearance.Bars.Class.Border.Style.edgeSize
		})
		local borderr, borderg, borderb = unpack(RUF.db.profile.Appearance.Bars.Class.Border.Color)
		Border:SetBackdropBorderColor(borderr, borderg, borderb, RUF.db.profile.Appearance.Bars.Class.Border.Alpha)

		-- Set Background
		Background:SetAllPoints(Bar)
		Background:SetTexture(LSM:Fetch("background", "Solid"))
		Background:SetVertexColor(r * bgMult, g * bgMult, b * bgMult, RUF.db.profile.Appearance.Bars.Class.Background.Alpha)

		if RUF.db.profile.unit[unit].Frame.Bars.Class.Enabled == true then
			self.__owner:EnableElement("ClassicClassPower")
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