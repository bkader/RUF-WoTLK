local RUF = RUF

RUF.Indicators = RUF.Indicators or {}

RUF.IndicatorGlyphs = {
	["Assist"] = "",
	["InCombat"] = "",
	["Lead"] = "",
	["LootMaster"] = "",
	["MainAssist"] = "",
	["MainTank"] = "",
	["PvP-Alliance"] = "",
	["PvP-Horde"] = "",
	["Ready-No"] = "",
	["Ready-Question"] = "",
	["Ready-Yes"] = "",
	["Resting"] = "",
	["Role-DPS"] = "", -- Fire
	["Role-DPS-Alternative-1"] = "", -- Sword
	["Role-Heal"] = "",
	["Role-Heal-Alternative-1"] = "", -- Heart
	["Role-Heal-Alternative-2"] = "", -- Plaster
	["Role-Tank"] = "",
	["Target-Circle"] = "",
	["Target-Cross"] = "",
	["Target-Diamond"] = "",
	["Target-Moon"] = "",
	["Target-Skull"] = "",
	["Target-Square"] = "",
	["Target-Star"] = "",
	["Target-Triangle"] = "",
	["PetHappiness1"] = "", -- Angry Face
	["PetHappiness2"] = "", -- Neutral Face
	["PetHappiness3"] = "", -- Heart Happy Face
	["PetHappiness-Alternative"] = "" -- Star
}

function RUF.SetIndicators(self, unit)
	local Indicators = self.Indicators or CreateFrame("Frame", nil, self)

	Indicators:SetAllPoints(self)
	Indicators:SetFrameLevel(40)

	self.Indicators = Indicators

	RUF.Indicators.Assist(self, unit)
	RUF.Indicators.InCombat(self, unit)
	RUF.Indicators.Lead(self, unit)
	RUF.Indicators.MainTankAssist(self, unit)
	RUF.Indicators.PvPCombat(self, unit)

	RUF.Indicators.Ready(self, unit)
	RUF.Indicators.Rest(self, unit)
	RUF.Indicators.TargetMark(self, unit)
	RUF.Indicators.Role(self, unit)
	RUF.Indicators.LootMaster(self, unit)
	RUF.Indicators.PetHappiness(self, unit)
end