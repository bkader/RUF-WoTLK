assert(RUF, "RUF not found!")
local RUF = RUF
local LSM = LibStub("LibSharedMedia-3.0")
local _, ns = ...
local oUF = ns.oUF

local function DrawRainbow(element)
	local a, b, c, x, y, z = RUF:GetRainbow()
	element:GetStatusBarTexture():SetGradient("HORIZONTAL", a, b, c, x, y, z)
end

function RUF.HealthUpdateColor(element, unit, cur, max)
	if not element then
		return
	end
	if not element.__owner then
		return
	end
	local r, g, b = RUF:GetBarColor(element, unit, "Health", "Health", cur)

	-- Create Ticker per element because that's probably better than looping through all oUF objects to check if it should be enabled for those.
	if RUF.db.profile.unit[element.__owner.frame].Frame.Bars.Health.rainbow.enabled then
		if not element.rainbowTimer then
			element.rainbowTimer = RUF.NewTicker(0.001, function() DrawRainbow(element) end)
		end
		if not RUF.rainbowTicker then -- If no elements are using the Rainbow Mode, there's no point in having the rgb values for rainbow mode to continually update.
			RUF.rainbowTicker = RUF.NewTicker(0.001, RUF.UpdateRainbow)
		end
	else
		if element.rainbowTimer then
			element.rainbowTimer:Cancel()
			element.rainbowTimer = nil
		end
		element:SetStatusBarColor(r, g, b)
	end

	-- Update background
	local bgMult = RUF.db.profile.Appearance.Bars.Health.Background.Multiplier
	local a = RUF.db.profile.Appearance.Bars.Health.Background.Alpha
	if RUF.db.profile.Appearance.Bars.Health.Background.UseBarColor == false then
		r, g, b = unpack(RUF.db.profile.Appearance.Bars.Health.Background.CustomColor)
	end
	element.__owner.Background.Base.Texture:SetVertexColor(r * bgMult, g * bgMult, b * bgMult, a)
end

function RUF.HealthUpdate(self, event, unit)
	if (not unit or self.unit ~= unit) then
		return
	end
	local element = self.Health

	if (element.PreUpdate) then
		element:PreUpdate(unit)
	end

	local cur, max = UnitHealth(unit), UnitHealthMax(unit)
	local tapped = not UnitPlayerControlled(unit) and UnitIsTapped(unit)
	local disconnected = not UnitIsConnected(unit)
	element:SetMinMaxValues(0, max)

	element.disconnected = disconnected
	element.tapped = tapped

	if (disconnected) then
		element:SetValue(max)
	else
		element:SetValue(cur)
	end

	if RUF.db.global.TestMode == true then
		cur = math.random(max / 4, max - (max / 4))
		element:SetValue(cur)
	end

	element:UpdateColor(unit, cur, max)

	if (element.PostUpdate) then
		return element:PostUpdate(unit, cur, max)
	end
end

function RUF.SetHealthBar(self, unit)
	local texture = LSM:Fetch("statusbar", RUF.db.profile.Appearance.Bars.Health.Texture)
	local Bar = RUF.StatusBarPrototype(nil, self)

	-- Bar
	Bar.colorClass = RUF.db.profile.Appearance.Bars.Health.Color.Class
	Bar.colorDisconnected = RUF.db.profile.Appearance.Bars.Health.Color.Disconnected
	Bar.colorSmooth = RUF.db.profile.Appearance.Bars.Health.Color.Percentage
	Bar.smoothGradient = RUF.db.profile.Appearance.Bars.Health.Color.PercentageGradient
	Bar.colorReaction = RUF.db.profile.Appearance.Bars.Health.Color.Reaction
	Bar.colorTapping = RUF.db.profile.Appearance.Bars.Health.Color.Tapped
	Bar.colorHealth = true -- BaseColor, always enabled, so if none of the other colors match, it falls back to this.
	Bar.Smooth = RUF.db.profile.unit[unit].Frame.Bars.Health.Animate
	Bar.colorRainbow = RUF.db.profile.unit[self.frame].Frame.Bars.Health.rainbow.enabled
	Bar.frequentUpdates = true
	Bar.texture = texture
	Bar:SetStatusBarTexture(texture)
	Bar:SetAllPoints(self)
	Bar:SetFrameLevel(11)

	-- Register with oUF
	self.Health = Bar
	self.Health.UpdateOptions = RUF.HealthUpdateOptions
end

function RUF.HealthUpdateOptions(self)
	local unit = self.__owner.frame
	local texture = LSM:Fetch("statusbar", RUF.db.profile.Appearance.Bars.Health.Texture)
	local Bar = self

	Bar.colorClass = RUF.db.profile.Appearance.Bars.Health.Color.Class
	Bar.colorDisconnected = RUF.db.profile.Appearance.Bars.Health.Color.Disconnected
	Bar.colorSmooth = RUF.db.profile.Appearance.Bars.Health.Color.Percentage
	Bar.smoothGradient = RUF.db.profile.Appearance.Bars.Health.Color.PercentageGradient
	Bar.colorReaction = RUF.db.profile.Appearance.Bars.Health.Color.Reaction
	Bar.colorTapping = RUF.db.profile.Appearance.Bars.Health.Color.Tapped
	Bar.colorHealth = true -- BaseColor, always enabled, so if none of the other colors match, it falls back to this.
	Bar.Smooth = RUF.db.profile.unit[unit].Frame.Bars.Health.Animate
	Bar.colorRainbow = RUF.db.profile.unit[unit].Frame.Bars.Health.rainbow.enabled
	Bar.frequentUpdates = true
	Bar:SetStatusBarTexture(texture)
	Bar:SetAllPoints(self.__owner)
	Bar:SetFrameLevel(10)
	Bar.FillStyle = RUF.db.profile.unit[unit].Frame.Bars.Health.Fill
	Bar:SetFillStyle(Bar.FillStyle)

	if Bar.Smooth == true then
		self.__owner:SmoothBar(Bar)
	else
		self.__owner:UnSmoothBar(Bar)
	end

	self:ForceUpdate()
end