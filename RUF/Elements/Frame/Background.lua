local RUF = RUF
local CreateFrame = CreateFrame

function RUF.SetFrameBackground(self, unit)
	local name = self:GetName()
	local Background = CreateFrame("Frame", name .. ".Background", self)

	Background:SetAllPoints(self)
	Background:SetFrameLevel(4)

	local r, g, b = unpack(RUF.db.profile.Appearance.Bars.Health.Background.CustomColor)
	local bgMult = RUF.db.profile.Appearance.Bars.Health.Background.Multiplier

	-- Base Background
	local BaseFrame = CreateFrame("Frame", name .. ".Background.Base", Background)
	local BaseTexture = BaseFrame:CreateTexture(name .. ".Background.Base.Texture", "BACKGROUND")
	BaseTexture:SetTexture(RUF:MediaFetch("background", "Solid"))
	BaseTexture:SetVertexColor(r * bgMult, g * bgMult, b * bgMult, RUF.db.profile.Appearance.Bars.Health.Background.Alpha)
	BaseFrame:SetAllPoints(Background)
	BaseTexture:SetAllPoints(BaseFrame)

	self.Background = Background
	self.Background.Base = BaseFrame
	self.Background.Base.Texture = BaseTexture
end