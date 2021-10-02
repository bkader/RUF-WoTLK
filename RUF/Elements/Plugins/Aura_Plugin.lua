--[[
# Element: Aura

Handles creation and updating of aura icons.

## Widget

Aura   - A Frame to hold `Button`s representing both buffs and debuffs.
Buff   - A Frame to hold `Button`s representing buffs.
Debuff - A Frame to hold `Button`s representing debuffs.

## Notes

At least one of the above widgets must be present for the element to work.

## Options

.disableMouse       - Disables mouse events (boolean)
.disableCooldown    - Disables the cooldown spiral (boolean)
.size               - Aura icon size. Defaults to 16 (number)
.onlyShowPlayer     - Shows only auras created by player/vehicle (boolean)
.showStealableBuffs - Displays the stealable texture on buffs that can be stolen (boolean)
.spacing            - Spacing between each icon. Defaults to 0 (number)
.['spacing-x']      - Horizontal spacing between each icon. Takes priority over `spacing` (number)
.['spacing-y']      - Vertical spacing between each icon. Takes priority over `spacing` (number)
.['growth-x']       - Horizontal growth direction. Defaults to 'RIGHT' (string)
.['growth-y']       - Vertical growth direction. Defaults to 'UP' (string)
.initialAnchor      - Anchor point for the icons. Defaults to 'BOTTOMLEFT' (string)
.filter             - Custom filter list for auras to display. Defaults to 'HELPFUL' for buffs and 'HARMFUL' for
					  debuffs (string)
.tooltipAnchor      - Anchor point for the tooltip. Defaults to 'ANCHOR_BOTTOMRIGHT', however, if a frame has anchoring
					  restrictions it will be set to 'ANCHOR_CURSOR' (string)

## Options Auras

.numBuffs     - The maximum number of buffs to display. Defaults to 32 (number)
.numDebuffs   - The maximum number of debuffs to display. Defaults to 40 (number)
.numTotal     - The maximum number of auras to display. Prioritizes buffs over debuffs. Defaults to the sum of
				.numBuffs and .numDebuffs (number)
.gap          - Controls the creation of an invisible icon between buffs and debuffs. Defaults to false (boolean)
.buffFilter   - Custom filter list for buffs to display. Takes priority over `filter` (string)
.debuffFilter - Custom filter list for debuffs to display. Takes priority over `filter` (string)

## Options Buffs

.num - Number of buffs to display. Defaults to 32 (number)

## Options Debuffs

.num - Number of debuffs to display. Defaults to 40 (number)

## Attributes

button.caster   - the unit who cast the aura (string)
button.filter   - the filter list used to determine the visibility of the aura (string)
button.isDebuff - indicates if the button holds a debuff (boolean)
button.isPlayer - indicates if the aura caster is the player or their vehicle (boolean)

## Examples

	-- Position and size
	local Buffs = CreateFrame('Frame', nil, self)
	Buffs:SetPoint('RIGHT', self, 'LEFT')
	Buffs:SetSize(16 * 2, 16 * 16)

	-- Register with oUF
	self.Buff = Buffs
--]]
local _, ns = ...
local oUF = ns.oUF

local VISIBLE = 1
local HIDDEN = 0

local function UpdateTooltip(self)
	GameTooltip:SetUnitAura(self:GetParent().__owner.unit, self:GetID(), self.filter)
end

local function onEnter(self)
	if not self:IsVisible() then return end
	GameTooltip:SetOwner(self, self:GetParent().tooltipAnchor)
	self:UpdateTooltip()
end

local function onLeave()
	GameTooltip:Hide()
end

local function createAuraIcon(element, index)
	-- local button = CreateFrame('Button', element:GetDebugName() .. 'Button' .. index, element) -- FIXME
	local elementName = element:GetName()
	local button = CreateFrame("Button", elementName and (elementName .. "Button" .. index), element)
	button:RegisterForClicks("RightButtonUp")

	local cd = CreateFrame("Cooldown", "$parentCooldown", button, "CooldownFrameTemplate")
	cd:SetAllPoints()

	local icon = button:CreateTexture(nil, "BORDER")
	icon:SetAllPoints()

	local countFrame = CreateFrame("Frame", nil, button)
	countFrame:SetAllPoints(button)
	countFrame:SetFrameLevel(cd:GetFrameLevel() + 1)

	local count = countFrame:CreateFontString(nil, "OVERLAY", "NumberFontNormal")
	count:SetPoint("BOTTOMRIGHT", countFrame, "BOTTOMRIGHT", -1, 0)

	local overlay = button:CreateTexture(nil, "OVERLAY")
	overlay:SetTexture([[Interface\Buttons\UI-Debuff-Overlays]])
	overlay:SetAllPoints()
	overlay:SetTexCoord(.296875, .5703125, 0, .515625)
	button.overlay = overlay

	local stealable = button:CreateTexture(nil, "OVERLAY")
	stealable:SetTexture([[Interface\TargetingFrame\UI-TargetingFrame-Stealable]])
	stealable:SetPoint("TOPLEFT", -3, 3)
	stealable:SetPoint("BOTTOMRIGHT", 3, -3)
	stealable:SetBlendMode("ADD")
	button.stealable = stealable

	button.UpdateTooltip = UpdateTooltip
	button:SetScript("OnEnter", onEnter)
	button:SetScript("OnLeave", onLeave)

	button.icon = icon
	button.count = count
	button.cd = cd

	if element.PostCreateIcon then
		element:PostCreateIcon(button)
	end

	return button
end

local function customFilter(element, unit, button, name)
	if ((element.onlyShowPlayer and button.isPlayer) or (not element.onlyShowPlayer and name)) then
		return true
	end
end

local function updateIcon(element, unit, index, offset, filter, isDebuff, visible)
	local name, rank, texture, count, debuffType, duration, expiration, caster, isStealable, _, spellID = UnitAura(unit, index, filter)
	if not name then return end

	if not duration or duration == 0 then
		-- FIXME
	end

	local position = visible + offset + 1
	local button = element[position]
	if not button then
		button = (element.CreateIcon or createAuraIcon)(element, position)
		table.insert(element, button)
		element.createdIcons = element.createdIcons + 1
	end

	button.caster = caster
	button.filter = filter
	button.isDebuff = isDebuff
	button.isPlayer = caster == "player" or caster == "vehicle"

	local show = (element.CustomFilter or customFilter)(element, unit, button, name, texture, count, debuffType, duration, expiration, caster, isStealable, nil, spellID, nil, nil, nil, nil, nil, nil, nil, nil)
	if show then
		-- We might want to consider delaying the creation of an actual cooldown
		-- object to this point, but I think that will just make things needlessly
		-- complicated.
		if button.cd and not element.disableCooldown then
			if tonumber(duration) and duration > 0 then
				button.cd:SetCooldown(expiration - duration, duration)
				button.cd:Show()
			else
				button.cd:Hide()
			end
		end

		if button.overlay then
			if ((isDebuff and element.showDebuffType) or (not isDebuff and element.showBuffType) or element.showType) then
				local color = element.__owner.colors.debuff[debuffType] or element.__owner.colors.debuff.none
				button.overlay:SetVertexColor(color[1], color[2], color[3])
				button.overlay:Show()
			else
				button.overlay:Hide()
			end
		end

		if button.stealable then
			if (not isDebuff and isStealable and element.showStealableBuffs and not UnitIsUnit("player", unit)) then
				button.stealable:Show()
			else
				button.stealable:Hide()
			end
		end

		if button.icon then
			button.icon:SetTexture(texture)
		end
		if button.count then
			button.count:SetText(tonumber(count) and count > 1 and count)
		end

		local size = element.size or 16
		local width = element.width or size
		local height = element.height or size
		button:SetSize(width, height)

		button:EnableMouse(not element.disableMouse)
		button:SetID(index)
		button:Show()

		if element.PostUpdateIcon then
			element:PostUpdateIcon(unit, button, index, position, duration, expiration, debuffType, isStealable)
		end
		return VISIBLE
	else
		return HIDDEN
	end
end

local function SetPosition(element, from, to)
	local sizex = (element.width or element.size or 16) + (element["spacing-x"] or element.spacing or 0)
	local sizey = (element.height or element.size or 16) + (element["spacing-y"] or element.spacing or 0)
	local anchor = element.initialAnchor or "BOTTOMLEFT"
	local growthx = (element["growth-x"] == "LEFT" and -1) or 1
	local growthy = (element["growth-y"] == "DOWN" and -1) or 1
	local cols = math.floor(element:GetWidth() / sizex + 0.5)

	for i = from, to do
		local button = element[i]
		if not button then break end -- Bail out if the to range is out of scope.
		local col = (i - 1) % cols
		local row = math.floor((i - 1) / cols)
		button:ClearAllPoints()
		button:SetPoint(anchor, element, anchor, col * sizex * growthx, row * sizey * growthy)
	end
end

local function filterIcons(element, unit, filter, limit, isDebuff, offset, dontHide)
	offset = offset or 0
	local index = 1
	local visible = 0
	local hidden = 0
	while (visible < limit) do
		local result = updateIcon(element, unit, index, offset, filter, isDebuff, visible)
		if not result then
			break
		elseif result == VISIBLE then
			visible = visible + 1
		elseif result == HIDDEN then
			hidden = hidden + 1
		end

		index = index + 1
	end

	if not dontHide then
		for i = visible + offset + 1, #element do
			element[i]:Hide()
		end
	end

	return visible, hidden
end

local function UpdateAuras(self, event, unit)
	if self.unit ~= unit then return end

	local auras = self.Aura
	if auras then
		if auras.PreUpdate then
			auras:PreUpdate(unit)
		end

		local numBuffs = auras.numBuffs or 32
		local numDebuffs = auras.numDebuffs or 40
		local max = auras.numTotal or numBuffs + numDebuffs

		local visibleBuffs, hiddenBuffs = filterIcons(auras, unit, auras.buffFilter or auras.filter or "HELPFUL", math.min(numBuffs, max), nil, 0, true)

		local hasGap
		if visibleBuffs ~= 0 and auras.gap then
			hasGap = true
			visibleBuffs = visibleBuffs + 1

			local button = auras[visibleBuffs]
			if not button then
				button = (auras.CreateIcon or createAuraIcon)(auras, visibleBuffs)
				table.insert(auras, button)
				auras.createdIcons = auras.createdIcons + 1
			end

			-- Prevent the button from displaying anything.
			if button.cd then
				button.cd:Hide()
			end
			if button.icon then
				button.icon:SetTexture()
			end
			if button.overlay then
				button.overlay:Hide()
			end
			if button.stealable then
				button.stealable:Hide()
			end
			if button.count then
				button.count:SetText()
			end

			button:EnableMouse(false)
			button:Show()

			if auras.PostUpdateGapIcon then
				auras:PostUpdateGapIcon(unit, button, visibleBuffs)
			end
			if not auras.Enabled then
				auras:Hide()
			else
				auras:Show()
			end
		end

		local visibleDebuffs, hiddenDebuffs = filterIcons(auras, unit, auras.debuffFilter or auras.filter or "HARMFUL", math.min(numDebuffs, max - visibleBuffs), true, visibleBuffs)
		auras.visibleDebuffs = visibleDebuffs

		if hasGap and visibleDebuffs == 0 then
			auras[visibleBuffs]:Hide()
			visibleBuffs = visibleBuffs - 1
		end

		auras.visibleBuffs = visibleBuffs
		auras.visibleAuras = auras.visibleBuffs + auras.visibleDebuffs

		local fromRange, toRange

		if auras.PreSetPosition then
			fromRange, toRange = auras:PreSetPosition(max)
		end

		if fromRange or auras.createdIcons > auras.anchoredIcons then
			(auras.SetPosition or SetPosition)(auras, fromRange or auras.anchoredIcons + 1, toRange or auras.createdIcons)
			auras.anchoredIcons = auras.createdIcons
		end

		if auras.PostUpdate then
			auras:PostUpdate(unit)
		end
	end

	local buffs = self.Buff
	if buffs then
		if (buffs.PreUpdate) then
			buffs:PreUpdate(unit)
		end

		local numBuffs = buffs.num or 32
		local visibleBuffs, hiddenBuffs = filterIcons(buffs, unit, buffs.filter or "HELPFUL", numBuffs)
		buffs.visibleBuffs = visibleBuffs

		local fromRange, toRange
		if buffs.PreSetPosition then
			fromRange, toRange = buffs:PreSetPosition(numBuffs)
		end

		if fromRange or buffs.createdIcons > buffs.anchoredIcons then
			(buffs.SetPosition or SetPosition)(buffs, fromRange or buffs.anchoredIcons + 1, toRange or buffs.createdIcons)
			buffs.anchoredIcons = buffs.createdIcons
		end

		if buffs.PostUpdate then
			buffs:PostUpdate(unit)
		end
		if not buffs.Enabled then
			buffs:Hide()
		else
			buffs:Show()
		end
	end

	local debuffs = self.Debuff
	if debuffs then
		if debuffs.PreUpdate then
			debuffs:PreUpdate(unit)
		end

		local numDebuffs = debuffs.num or 40
		local visibleDebuffs, hiddenDebuffs = filterIcons(debuffs, unit, debuffs.filter or "HARMFUL", numDebuffs, true)
		debuffs.visibleDebuffs = visibleDebuffs

		local fromRange, toRange
		if debuffs.PreSetPosition then
			fromRange, toRange = debuffs:PreSetPosition(numDebuffs)
		end

		if fromRange or debuffs.createdIcons > debuffs.anchoredIcons then
			(debuffs.SetPosition or SetPosition)(debuffs, fromRange or debuffs.anchoredIcons + 1, toRange or debuffs.createdIcons)
			debuffs.anchoredIcons = debuffs.createdIcons
		end

		if debuffs.PostUpdate then
			debuffs:PostUpdate(unit)
		end
		if not debuffs.Enabled then
			debuffs:Hide()
		else
			debuffs:Show()
		end
	end
end

local function Update(self, event, unit)
	if self.unit ~= unit then return end

	UpdateAuras(self, event, unit)

	-- Assume no event means someone wants to re-anchor things. This is usually
	-- done by UpdateAllElements and :ForceUpdate.
	if event == "ForceUpdate" or not event then
		local buffs = self.Buff
		if buffs then
			if buffs.Enabled then
				(buffs.SetPosition or SetPosition)(buffs, 1, buffs.createdIcons)
			else
				buffs:Hide()
			end
		end

		local debuffs = self.Debuff
		if debuffs then
			if debuffs.Enabled then
				(debuffs.SetPosition or SetPosition)(debuffs, 1, debuffs.createdIcons)
			else
				debuffs:Hide()
			end
		end

		local auras = self.Aura
		if auras then
			if auras.Enabled then
				(auras.SetPosition or SetPosition)(auras, 1, auras.createdIcons)
			else
				auras:Hide()
			end
		end
	end
end

local function ForceUpdate(element)
	return Update(element.__owner, "ForceUpdate", element.__owner.unit)
end

local function Enable(self)
	if self.Buff or self.Debuff or self.Aura then
		self:RegisterEvent("UNIT_AURA", UpdateAuras)

		local buffs = self.Buff
		if buffs then
			buffs.__owner = self
			buffs.ForceUpdate = ForceUpdate

			buffs.createdIcons = buffs.createdIcons or 0
			buffs.anchoredIcons = 0

			-- Avoid parenting GameTooltip to frames with anchoring restrictions,
			-- otherwise it'll inherit said restrictions which will cause issues
			-- with its further positioning, clamping, etc
			if not pcall(self.GetCenter, self) then
				buffs.tooltipAnchor = "ANCHOR_CURSOR"
			else
				buffs.tooltipAnchor = buffs.tooltipAnchor or "ANCHOR_BOTTOMRIGHT"
			end

			buffs:Show()
		end

		local debuffs = self.Debuff
		if debuffs then
			debuffs.__owner = self
			debuffs.ForceUpdate = ForceUpdate

			debuffs.createdIcons = debuffs.createdIcons or 0
			debuffs.anchoredIcons = 0

			-- Avoid parenting GameTooltip to frames with anchoring restrictions,
			-- otherwise it'll inherit said restrictions which will cause issues
			-- with its further positioning, clamping, etc
			if not pcall(self.GetCenter, self) then
				debuffs.tooltipAnchor = "ANCHOR_CURSOR"
			else
				debuffs.tooltipAnchor = debuffs.tooltipAnchor or "ANCHOR_BOTTOMRIGHT"
			end

			debuffs:Show()
		end

		local auras = self.Aura
		if auras then
			auras.__owner = self
			auras.ForceUpdate = ForceUpdate

			auras.createdIcons = auras.createdIcons or 0
			auras.anchoredIcons = 0

			-- Avoid parenting GameTooltip to frames with anchoring restrictions,
			-- otherwise it'll inherit said restrictions which will cause issues
			-- with its further positioning, clamping, etc
			if not pcall(self.GetCenter, self) then
				auras.tooltipAnchor = "ANCHOR_CURSOR"
			else
				auras.tooltipAnchor = auras.tooltipAnchor or "ANCHOR_BOTTOMRIGHT"
			end

			auras:Show()
		end

		return true
	end
end

local function Disable(self)
	local buff, debuff, aura
	if self.Buff then
		buff = true
		if self.Buff.Enabled == false then
			buff = false
			self.Buff:Hide()
		end
	end
	if self.Debuff then
		debuff = true
		if self.Debuff.Enabled == false then
			debuff = false
			self.Debuff:Hide()
		end
	end
	if self.Aura then
		aura = true
		if self.Aura.Enabled == false then
			aura = false
			self.Aura:Hide()
		end
	end
	if not buff and not debuff and not aura then
		self:UnregisterEvent("UNIT_AURA", UpdateAuras)
	end
end

oUF:AddElement("Aura_Plugin", Update, Enable, Disable)