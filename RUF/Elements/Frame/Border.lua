assert(RUF, "RUF not found!")
local RUF = RUF
local LSM = LibStub('LibSharedMedia-3.0')
local _, ns = ...
local oUF = ns.oUF
local uClass = select(2, UnitClass("player"))

local GetSpecialization = RUF.GetSpecialization

local DebuffDispel = {-- DISPELLING ALLIES, 10 = Classic since there are no specs in classic.
	['DEATHKNIGHT'] = {
		[1] = {'None'},
		[2] = {'None'},
		[3] = {'None'},
		[10] = {'None'},
	},
	['DRUID'] = {
		[1] = {'Curse','Poison'},
		[2] = {'Curse','Poison'},
		[3] = {'Curse','Poison'},
		[4] = {'Curse','Magic','Poison'},
		[10] = {'Curse','Poison'}
	},
	['HUNTER'] = {
		[1] = {'None'},
		[2] = {'None'},
		[3] = {'None'},
		[10] = {'None'},
	},
	['MAGE'] = {
		[1] = {'Curse'},
		[2] = {'Curse'},
		[3] = {'Curse'},
		[10] = {'Curse'},
	},
	['PALADIN'] = {
		[1] = {'Disease','Magic','Poison'},
		[2] = {'Disease','Poison'},
		[3] = {'Disease','Poison'},
		[10] = {'Disease','Magic','Poison'},
	},
	['PRIEST'] = {
		[1] = {'Disease','Magic'},
		[2] = {'Disease','Magic'},
		[3] = {'Disease'},
		[10] = {'Disease','Magic'},
	},
	['ROGUE'] = {
		[1] = {'None'},
		[2] = {'None'},
		[3] = {'None'},
		[10] = {'None'},
	},
	['SHAMAN'] = {
		[1] = {'Curse'},
		[2] = {'Curse'},
		[3] = {'Curse','Magic'},
		[10] = {'Disease','Poison'},
	},
	['WARLOCK'] = {
		[1] = {'Magic'},
		[2] = {'Magic'},
		[3] = {'Magic'},
		[10] = {'Magic'},
	},
	['WARRIOR'] = {
		[1] = {'None'},
		[2] = {'None'},
		[3] = {'None'},
		[10] = {'None'},
	},
}
local BuffDispel = {-- PURGES
	['DEATHKNIGHT'] = {
		[1] = {'None'},
		[2] = {'None'},
		[3] = {'None'},
		[10] = {'None'},
	},
	['DRUID'] = {
		[1] = {'Enrage'},
		[2] = {'Enrage'},
		[3] = {'Enrage'},
		[4] = {'Enrage'},
		[10] = {'None'},
	},
	['HUNTER'] = {
		[1] = {'Enrage'},
		[2] = {'Enrage'},
		[3] = {'Enrage'},
		[10] = {'Enrage'},
	},
	['MAGE'] = {
		[1] = {'Magic'},
		[2] = {'Magic'},
		[3] = {'Magic'},
		[10] = {'None'},
	},
	['PALADIN'] = {
		[1] = {'None'},
		[2] = {'None'},
		[3] = {'None'},
		[10] = {'None'},
	},
	['PRIEST'] = {
		[1] = {'Magic'},
		[2] = {'Magic'},
		[3] = {'Magic'},
		[10] = {'Magic'},
	},
	['ROGUE'] = {
		[1] = {'None'},
		[2] = {'None'},
		[3] = {'None'},
		[10] = {'None'},
	},
	['SHAMAN'] = {
		[1] = {'Magic'},
		[2] = {'Magic'},
		[3] = {'Magic'},
		[10] = {'Magic'},
	},
	['WARLOCK'] = {
		[1] = {'Magic'},
		[2] = {'Magic'},
		[3] = {'Magic'},
		[10] = {'Magic'},
	},
	['WARRIOR'] = {
		[1] = {'None'},
		[2] = {'None'},
		[3] = {'None'},
		[10] = {'None'},
	},
}

function RUF.SetFrameBorder(self, unit)
	local name = self:GetName()
	local Border = CreateFrame('Frame',name..'.Border',self)
	local offset = RUF.db.profile.Appearance.Border.Offset

	Border:SetPoint('TOPLEFT',self,'TOPLEFT',-offset,offset)
	Border:SetPoint('BOTTOMRIGHT',self,'BOTTOMRIGHT',offset,-offset)

	Border:SetFrameLevel(35)
	Border:SetBackdrop({edgeFile = LSM:Fetch('border', RUF.db.profile.Appearance.Border.Style.edgeFile), edgeSize = RUF.db.profile.Appearance.Border.Style.edgeSize})
	local r,g,b = unpack(RUF.db.profile.Appearance.Border.Color)
	Border:SetBackdropBorderColor(r,g,b, RUF.db.profile.Appearance.Border.Alpha)

	self.Border = Border
end

function RUF.UpdateGlowBorder(self, event)
	local unit = self.unit
	if event == 'UNIT_TARGET' then
		self.GlowBorder:Hide() -- Immediately hide until we check the new unit.
	end
	RUF.Specialization = GetSpecialization()
	local removable = false
	local dispelType
	local auraTypes
	local buffFilter
	if UnitIsFriend('player',unit) then
		auraTypes = DebuffDispel[uClass][RUF.Specialization]
		buffFilter = "HARMFUL"
	else
		auraTypes = BuffDispel[uClass][RUF.Specialization]
		buffFilter = "HELPFUL"
	end
	for i = 1,40 do
		local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster,
		isStealable, shouldConsolidate, spellId = UnitAura(unit, i, buffFilter)
		if name == nil or auraTypes == 'None' then
			removable = false
			break
		else
			for k,v in pairs(auraTypes) do
				if v == debuffType then
					removable = true
					dispelType = debuffType
				end
			end
		end
	end
	if removable == true then
		local r,g,b,a = unpack(RUF.db.profile.Appearance.Colors.Aura.DefaultDebuff)
		r,g,b = unpack(RUF.db.profile.Appearance.Colors.Aura[dispelType])
		a = RUF.db.profile.Appearance.Border.Glow.Alpha
		self.GlowBorder:SetBackdropBorderColor(r,g,b,a)
		self.GlowBorder:Show()
		if RUF.db.profile.Appearance.Border.Glow.SoundEnabled and self.frame ~= 'target' then
			if not self.auraSound then
				PlaySoundFile(LSM:Fetch("sound", RUF.db.profile.Appearance.Border.Glow.Sound),'Master')
				self.auraSound = true
			end
		end
	else
		self.GlowBorder:Hide()
		if self.auraSound then
			self.auraSound = nil
		end
	end
end

function RUF.SetGlowBorder(self, unit) -- Aura Highlight Border
	local name = self:GetName()
	local profileReference = RUF.db.profile.Appearance.Border.Glow
	local offset = profileReference.Offset

	local GlowBorder = CreateFrame('Frame',name..'.GlowBorder',self)
	GlowBorder:SetPoint('TOPLEFT',self,'TOPLEFT',-offset,offset)
	GlowBorder:SetPoint('BOTTOMRIGHT',self,'BOTTOMRIGHT',offset,-offset)
	GlowBorder:SetFrameLevel(35)
	GlowBorder:SetBackdrop({edgeFile = LSM:Fetch('border', profileReference.Style.edgeFile), edgeSize = profileReference.Style.edgeSize})
	GlowBorder:SetBackdropBorderColor(0,0,0, profileReference.Alpha)
	GlowBorder:Hide()

	self.GlowBorder = GlowBorder
	if profileReference.Enabled == true then
		self:RegisterEvent('UNIT_AURA',RUF.UpdateGlowBorder,true)
		self:RegisterEvent('UNIT_TARGET',RUF.UpdateGlowBorder,true)
	end
end