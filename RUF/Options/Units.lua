assert(RUF, "RUF not found!")
local RUF = RUF
local L = LibStub('AceLocale-3.0'):GetLocale('RUF')
local RUF_Options = RUF:GetModule('Options')
local LSM = LibStub('LibSharedMedia-3.0')
local _, ns = ...
local oUF = ns.oUF
local uClass = select(2, UnitClass("player"))

local tagList = {}
local localisedTags = {}
local tagInputs = {}
local frames,groupFrames,headers

local anchorPoints = {
	['TOP'] = L["Top"],
	['RIGHT'] = L["Right"],
	['BOTTOM'] = L["Bottom"],
	['LEFT'] = L["Left"],
	['TOPRIGHT'] = L["Top-right"],
	['TOPLEFT'] = L["Top-left"],
	['BOTTOMRIGHT'] = L["Bottom-right"],
	['BOTTOMLEFT'] = L["Bottom-left"],
	['CENTER'] = L["Center"],
}
local anchorSwaps = {
	['BOTTOM'] = 'TOP',
	['BOTTOMLEFT'] = 'TOPRIGHT',
	['BOTTOMRIGHT'] = 'TOPLEFT',
	['CENTER'] = 'CENTER',
	['LEFT'] = 'RIGHT',
	['RIGHT'] = 'LEFT',
	['TOP'] = 'BOTTOM',
	['TOPLEFT'] = 'BOTTOMRIGHT',
	['TOPRIGHT'] = 'BOTTOMLEFT',
}

local function CopyList(singleFrame, groupFrame, header, section)
	-- Generate list of units we can copy text elements from
	local copyList = {
		['Player'] = L["player"],
		['Pet'] = L["pet"],
		['PetTarget'] = L["pettarget"],
		['Target'] = L["target"],
		['TargetTarget'] = L["targettarget"],
		['TargetTargetTarget'] = L["targettargettarget"],
		['Party'] = L["party"],
		['PartyPet'] = L["partypet"],
		['PartyTarget'] = L["partytarget"],
	}

	if section then
		if section == 'Cast' then
			copyList = {
				['Player'] = L["player"],
				['Focus'] = L["focus"],
				['Target'] = L["target"],
			}
		end
	end

	-- Remove current Unit from list, we can't copy data from ourselves. Well, we can in this case, but it wouldn't do anything.
	copyList[singleFrame] = nil
	copyList[groupFrame] = nil
	copyList[header] = nil

	return copyList
end

local function ProfileData(singleFrame, groupFrame, header)
	if not singleFrame and not groupFrame and not header then return end
	if not singleFrame then singleFrame = 'none' end
	if not groupFrame then groupFrame = 'none' end
	if not header then header = 'none' end
	local ord = 99
	for i=1,#frames do
		if frames[i] == singleFrame then
			ord = i
		end
	end
	for i = 1,#groupFrames do
		if groupFrames[i] == groupFrame then
			ord = 100 + i
		end
	end
	for i = 1,#headers do
		if headers[i] == header then
			ord = 200 + i
		end
	end
	local referenceUnit, profileName
	if singleFrame ~= 'none' then
		referenceUnit = singleFrame
		profileName = string.lower(singleFrame)
	elseif groupFrame ~= 'none' then
		if groupFrame:match('Target') then
			referenceUnit = groupFrame:gsub('Target','') .. '1' .. 'Target'
		else
			referenceUnit = groupFrame .. '1'
		end
		profileName = string.lower(groupFrame)
	elseif header ~= 'none' then
		referenceUnit = header .. 'UnitButton1'
		profileName = string.lower(header)
	end

	return singleFrame, groupFrame, header, ord, referenceUnit, profileName
end

local function UnitGroup(singleFrame, groupFrame, header)
	local ord, referenceUnit, profileName
	singleFrame, groupFrame, header, ord, referenceUnit, profileName = ProfileData(singleFrame, groupFrame, header)

	local frameOptions = {
		name = L[profileName],
		type = 'group',
		childGroups = 'tab',
		order = ord,
		args = {
			frameSettings = {
				name = L["Layout"],
				type = 'group',
				childGroups = 'tab',
				order = 0,
				args = {
					enabled = {
						name = function()
							if RUF.db.profile.unit[profileName].Enabled == true then
								return '|cFF00FF00'..L["Enabled"]..'|r'
							else
								return '|cFFFF0000'..L["Enabled"]..'|r'
							end
						end,
						desc = L["Enable the Unit Frame."],
						type = 'toggle',
						order = 0.003,
						get = function(info)
							return RUF.db.profile.unit[profileName].Enabled
						end,
						set = function(info, value)
							RUF.db.profile.unit[profileName].Enabled = value
							RUF:OptionsUpdateFrame(singleFrame, groupFrame, header)
							RUF:UpdateOptions()
						end,
					},
					toggleForVehicle = {
						name = L["Replace frame with Vehicle"],
						desc = L["Enable to replace this unit frame with the vehicle frame when in a vehicle. If disabled, the pet frame will become the vehicle frame instead."],
						type = 'toggle',
						order = 0.004,
						hidden = function() return (profileName ~= 'player') end,
						get = function(info)
							return RUF.db.profile.unit[profileName].toggleForVehicle
						end,
						set = function(info, value)
							RUF.db.profile.unit[profileName].toggleForVehicle = value
							RUF:OptionsUpdateFrame(singleFrame, groupFrame, header)
							RUF:UpdateOptions()
						end,
					},
					showRaid = {
						name = L["Show in Raid"],
						type = 'toggle',
						order = 0.004,
						hidden = function()
							if profileName == 'partytarget' then return false end
							if profileName == 'partypet' then return false end
							if header ~= 'none' then return false end
							return true
						end,
						get = function(info)
							return RUF.db.profile.unit[profileName].showRaid
						end,
						set = function(info, value)
							RUF.db.profile.unit[profileName].showRaid = value
							RUF:OptionsUpdateFrame(singleFrame, groupFrame, header)
							if header ~= 'none' then
								RUF.TogglePartyChildren('partypet')
								RUF.TogglePartyChildren('partytarget')
							elseif profileName == 'partytarget' then
								RUF.TogglePartyChildren('partytarget')
							elseif profileName == 'partypet' then
								RUF.TogglePartyChildren('partypet')
							end
							RUF:UpdateOptions()
						end,
					},
					showArena = {
						name = L["Show in Arena"],
						type = 'toggle',
						order = 0.004,
						hidden = function()
							if profileName == 'partytarget' then return false end
							if profileName == 'partypet' then return false end
							if header ~= 'none' then return false end
							return true
						end,
						get = function(info)
							return RUF.db.profile.unit[profileName].showArena
						end,
						set = function(info, value)
							RUF.db.profile.unit[profileName].showArena = value
							RUF:OptionsUpdateFrame(singleFrame, groupFrame, header)
							if header ~= 'none' then
								RUF.TogglePartyChildren('partypet')
								RUF.TogglePartyChildren('partytarget')
							elseif profileName == 'partytarget' then
								RUF.TogglePartyChildren('partytarget')
							elseif profileName == 'partypet' then
								RUF.TogglePartyChildren('partypet')
							end
							RUF:UpdateOptions()
						end,
					},
					showPlayer = {
						name = L["Show Player"],
						desc = L["Shows the player in the party frames."],
						type = 'toggle',
						order = 0.0042,
						hidden = function()
							if profileName == 'party' then return false end
							return true
						end,
						get = function(info)
							return RUF.db.profile.unit[profileName].showPlayer
						end,
						set = function(info, value)
							RUF.db.profile.unit[profileName].showPlayer = value
							RUF:OptionsUpdateFrame(singleFrame, groupFrame, header)
							RUF:OptionsUpdateFrame(singleFrame, 'PartyTarget', 'none') -- So we also force Update and Hide/Show the 5th Party Target
							RUF:OptionsUpdateFrame(singleFrame, 'PartyPet', 'none')
							RUF.TogglePartyChildren('partypet')
							RUF.TogglePartyChildren('partytarget')
							RUF:UpdateOptions()
						end,
					},
					enabledSpacer = {
						name = ' ',
						type = 'description',
						order = 0.005,
						width = 'full',
					},
					rangeFading = {
						name = L["Fade out of Range"],
						desc = L["Fade the unit frame it the target is out of range of your spells."],
						type = 'toggle',
						order = 0.01,
						hidden = function() return (profileName == 'player') end,
						get = function(info)
							return RUF.db.profile.unit[profileName].Frame.RangeFading.Enabled
						end,
						set = function(info, value)
							RUF.db.profile.unit[profileName].Frame.RangeFading.Enabled = value
							RUF:OptionsUpdateFrame(singleFrame, groupFrame, header)
						end,
					},
					rangeFadingAlpha = {
						name = L["Alpha"],
						desc = L["Out of Range transparency"],
						type = 'range',
						isPercent = true,
						order = 0.02,
						min = 0,
						max = 1,
						softMin = 0,
						softMax = 1,
						step = 0.01,
						bigStep = 0.05,
						hidden = function() return (profileName == 'player') end,
						get = function(info)
							return RUF.db.profile.unit[profileName].Frame.RangeFading.Alpha
						end,
						set = function(info, value)
							RUF.db.profile.unit[profileName].Frame.RangeFading.Alpha = value
							RUF:OptionsUpdateFrame(singleFrame, groupFrame, header)
						end,
					},
					frameWidth = {
						name = L["Width"],
						type = 'range',
						order = 0.03,
						min = 50,
						max = 750,
						softMin = 100,
						softMax = 400,
						step = 1,
						bigStep = 10,
						get = function(info)
							return RUF.db.profile.unit[profileName].Frame.Size.Width
						end,
						set = function(info, value)
							RUF.db.profile.unit[profileName].Frame.Size.Width = value
							RUF:OptionsUpdateFrame(singleFrame, groupFrame, header)
						end,
					},
					frameHeight = {
						name = L["Height"],
						type = 'range',
						order = 0.04,
						min = 10,
						max = 300,
						softMin = 20,
						softMax = 100,
						step = 1,
						bigStep = 5,
						get = function(info)
							return RUF.db.profile.unit[profileName].Frame.Size.Height
						end,
						set = function(info, value)
							RUF.db.profile.unit[profileName].Frame.Size.Height = value
							RUF:OptionsUpdateFrame(singleFrame, groupFrame, header)
						end,
					},
					frameHeightSpacer = {
						name = ' ',
						type = 'description',
						order = 0.05,
						width = 'full',
					},
					frameAnchor = {
						type = 'input',
						name = L["Anchor Frame"],
						desc = L["The name of the frame for the unit to anchor to. Defaults to UI Parent if set blank."],
						multiline = false,
						order = 0.06,
						get = function(info)
							return RUF.db.profile.unit[profileName].Frame.Position.AnchorFrame
						end,
						set = function(info, value)
							if value ~= nil and value:match('%S') ~= nil then
								if _G[value] then
									if RUF:CanAttach(_G['oUF_RUF_' .. referenceUnit], _G[value]) then
										RUF.db.profile.unit[profileName].Frame.Position.AnchorFrame = value
									end
								else
									RUF.db.profile.unit[profileName].Frame.Position.AnchorFrame = 'UIParent'
								end
							else
								RUF.db.profile.unit[profileName].Frame.Position.AnchorFrame = 'UIParent'
							end
							RUF:UpdateOptions()
							RUF:OptionsUpdateFrame(singleFrame, groupFrame, header)
						end,
					},
					frameHorizontal = {
						type = 'range',
						name = L["X Offset"],
						desc = L["Horizontal Offset from the Frame Anchor."],
						order = 0.07,
						min = -5000,
						max = 5000,
						softMin = -1000,
						softMax = 1000,
						step = 0.5,
						bigStep = 1,
						get = function(info)
							return RUF.db.profile.unit[profileName].Frame.Position.x
						end,
						set = function(info, value)
							RUF.db.profile.unit[profileName].Frame.Position.x = value
							RUF:OptionsUpdateFrame(singleFrame, groupFrame, header)
						end,
					},
					frameVertical = {
						type = 'range',
						name = L["Y Offset"],
						desc = L["Vertical Offset from the Frame Anchor."],
						order = 0.08,
						min = -5000,
						max = 5000,
						softMin = -1000,
						softMax = 1000,
						step = 0.5,
						bigStep = 1,
						get = function(info)
							return RUF.db.profile.unit[profileName].Frame.Position.y
						end,
						set = function(info, value)
							RUF.db.profile.unit[profileName].Frame.Position.y = value
							RUF:OptionsUpdateFrame(singleFrame, groupFrame, header)
						end,
					},
					frameAnchorPoint = {
						type = 'select',
						name = L["Anchor From"],
						desc = L["Location area of the Unitframe to anchor from."],
						order = 0.09,
						values = anchorPoints,
						get = function(info)
							return RUF.db.profile.unit[profileName].Frame.Position.AnchorFrom
						end,
						set = function(info, value)
							RUF.db.profile.unit[profileName].Frame.Position.AnchorFrom = value
							RUF:OptionsUpdateFrame(singleFrame, groupFrame, header)
						end,
					},
					frameAnchorTo = {
						type = 'select',
						name = L["Anchor To"],
						desc = L["Area on the anchor frame to anchor the unitframe to."],
						order = 0.09,
						values = anchorPoints,
						get = function(info)
							return RUF.db.profile.unit[profileName].Frame.Position.AnchorTo
						end,
						set = function(info, value)
							RUF.db.profile.unit[profileName].Frame.Position.AnchorTo = value
							RUF:OptionsUpdateFrame(singleFrame, groupFrame, header)
						end,
					},
					frameAnchorToSeparator = {
						name = ' ',
						type = 'description',
						order = 0.095,
						width = 'full',
					},
					groupFrameGrowthDirection = {
						type = 'select',
						name = L["Growth Direction"],
						desc = L["Grow up or down."],
						hidden = groupFrame == 'none',
						order = 0.1,
						values = {
							TOP = L["Up"],
							BOTTOM = L["Down"],
						},
						get = function(info)
							return RUF.db.profile.unit[profileName].Frame.Position.growth
						end,
						set = function(info, value)

							if RUF.db.profile.unit[profileName].Frame.Position.growth ~= value then
								if RUF.db.profile.unit[profileName].Frame.Position.offsety > 0 then
									RUF.db.profile.unit[profileName].Frame.Position.offsety = 0 - RUF.db.profile.unit[profileName].Frame.Position.offsety
								else
									RUF.db.profile.unit[profileName].Frame.Position.offsety = 0 - (RUF.db.profile.unit[profileName].Frame.Position.offsety)
								end
							end

							RUF.db.profile.unit[profileName].Frame.Position.growth = value
							RUF:OptionsUpdateFrame(singleFrame, groupFrame, header)
							RUF:UpdateOptions()
						end,
					},
					partyFrameGrowthDirection = {
						type = 'select',
						name = L["Growth Direction"],
						desc = L["Vertical stacking or horizontal stacking."],
						hidden = header == 'none',
						order = 0.1,
						values = {
							VERTICAL = L["Vertical"],
							HORIZONTAL = L["Horizonal"],
						},
						get = function(info)
							return RUF.db.profile.unit[profileName].Frame.Position.growthDirection
						end,
						set = function(info, value)
							RUF.db.profile.unit[profileName].Frame.Position.growthDirection = value
							RUF:OptionsUpdateFrame(singleFrame, groupFrame, header)
							RUF:UpdateOptions()
						end,
					},
					partyFrameSortOrderVert = {
						type = 'select',
						name = L["Sort Direction"],
						hidden = function()
							if header ~= 'none' then
								if RUF.db.profile.unit[profileName].Frame.Position.growthDirection == 'HORIZONTAL' then
									return true
								else
									return false
								end
							else
								return true
							end
						end,
						order = 0.101,
						values = {
							TOP = L["Up"],
							BOTTOM = L["Down"],
						},
						get = function(info)
							return RUF.db.profile.unit[profileName].Frame.Position.growth
						end,
						set = function(info, value)

							if RUF.db.profile.unit[profileName].Frame.Position.growth ~= value then
								if RUF.db.profile.unit[profileName].Frame.Position.offsety > 0 then
									RUF.db.profile.unit[profileName].Frame.Position.offsety = 0 - RUF.db.profile.unit[profileName].Frame.Position.offsety
								else
									RUF.db.profile.unit[profileName].Frame.Position.offsety = 0 - (RUF.db.profile.unit[profileName].Frame.Position.offsety)
								end
							end
							RUF.db.profile.unit[profileName].Frame.Position.growth = value
							RUF:OptionsUpdateFrame(singleFrame, groupFrame, header)
							RUF:UpdateOptions()
						end,
					},
					partyFrameSortOrderHoriz = {
						type = 'select',
						name = L["Sort Direction"],
						hidden = function()
							if header ~= 'none' then
								if RUF.db.profile.unit[profileName].Frame.Position.growthDirection == 'VERTICAL' then
									return true
								else
									return false
								end
							else
								return true
							end
						end,
						order = 0.101,
						values = {
							LEFT = L["Right"],
							RIGHT = L["Left"],
						},
						get = function(info)
							return RUF.db.profile.unit[profileName].Frame.Position.growthHoriz
						end,
						set = function(info, value)
							RUF.db.profile.unit[profileName].Frame.Position.growthHoriz = value
							RUF:OptionsUpdateFrame(singleFrame, groupFrame, header)
							RUF:UpdateOptions()
						end,
					},
					groupFrameHorizontalOffset = {
						type = 'range',
						name = L["X Spacing"],
						desc = L["Horizontal Offset from the previous unit in the group."],
						hidden = function()
							if groupFrame ~= 'none' or header ~= 'none' then
								return false
							else
								return true
							end
						end,
						disabled = function()
							if header ~= 'none' then
								if RUF.db.profile.unit[profileName].Frame.Position.growthDirection == 'HORIZONTAL' then
									return false
								else
									return true
								end
							end
						end,
						order = 0.11,
						min = -5000,
						max = 5000,
						softMin = -1000,
						softMax = 1000,
						step = 0.5,
						bigStep = 1,
						get = function(info)
							return RUF.db.profile.unit[profileName].Frame.Position.offsetx
						end,
						set = function(info, value)
							RUF.db.profile.unit[profileName].Frame.Position.offsetx = value
							RUF:OptionsUpdateFrame(singleFrame, groupFrame, header)
						end,
					},
					groupFrameVerticalOffset = {
						type = 'range',
						name = L["Y Spacing"],
						desc = L["Vertical Offset from the previous unit in the group."],
						hidden = function()
							if groupFrame ~= 'none' or header ~= 'none' then
								return false
							else
								return true
							end
						end,
						disabled = function()
							if header ~= 'none' then
								if RUF.db.profile.unit[profileName].Frame.Position.growthDirection == 'VERTICAL' then
									return false
								else
									return true
								end
							end
						end,
						order = 0.12,
						min = -5000,
						max = 5000,
						softMin = -1000,
						softMax = 1000,
						step = 0.5,
						bigStep = 1,
						get = function(info)
							return RUF.db.profile.unit[profileName].Frame.Position.offsety
						end,
						set = function(info, value)
							RUF.db.profile.unit[profileName].Frame.Position.offsety = value
							RUF:OptionsUpdateFrame(singleFrame, groupFrame, header)
						end,
					},
				},
			},
		},
	}

	return frameOptions
end

local function BarSettings(singleFrame, groupFrame, header)
	local ord, referenceUnit, profileName
	singleFrame, groupFrame, header, ord, referenceUnit, profileName = ProfileData(singleFrame, groupFrame, header)

	local Powers = {["DRUID"] = _G['COMBO_POINTS'] or COMBO_POINTS, ["ROGUE"] = _G['COMBO_POINTS'] or COMBO_POINTS}
	local PowerDesc = {}

	local barOptions = {
		name = L["Bars"],
		type = 'group',
		childGroups = 'tab',
		order = 10,
		args = {
			Health = {
				name = L["Health"],
				type = 'group',
				order = 10,
				args = {},
			},
			Power = {
				name = L["Power"],
				type = 'group',
				order = 15,
				args = {},
			},
			Class = {
				name = function()
					if Powers[uClass] then
						return Powers[uClass]
					else
						return L["Class"]
					end
				end,
				desc = function()
					if PowerDesc[uClass] then
						return L["%s, %s, and class specific resources for other classes."]:format(PowerDesc[uClass][1],PowerDesc[uClass][2])
					elseif Powers[uClass] then
						return L["%s and class specific resources for other classes."]:format(Powers[uClass])
					end
				end,
				type = 'group',
				order = 20,
				hidden = function() return (profileName ~= 'player') end,
				args = {},
			},
			Absorb = {
				name = L["Absorb"],
				type = 'group',
				order = 25,
				args = {},
			},
		},
	}

	local barList = {
		[1] = 'Health',
		[2] = 'Class',
		[3] = 'Power',
		[4] = 'Absorb',
	}

	for i = 1,#barList do
		barOptions.args[barList[i]].args = {
			displayStyleAbsorbPower = {
				name = L["Display Style"],
				type = 'select',
				order = 0,
				hidden = i < 3,
				values = {
					[0] = L["Always Hidden"],
					[1] = L["Hidden at 0"],
					[2] = L["Always Visible"],
				},
				get = function(info)
					return RUF.db.profile.unit[profileName].Frame.Bars[barList[i]].Enabled
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Frame.Bars[barList[i]].Enabled = value
					RUF:OptionsUpdateBars(singleFrame, groupFrame, header, barList[i])
				end,
			},
			classEnabled = {
				name = function()
					if RUF.db.profile.unit[profileName].Frame.Bars[barList[i]].Enabled == true then
						return '|cFF00FF00'..L["Enabled"]..'|r'
					else
						return '|cFFFF0000'..L["Enabled"]..'|r'
					end
				end,
				type = 'toggle',
				order = 0,
				hidden = i ~= 2,
				get = function(info)
					return RUF.db.profile.unit[profileName].Frame.Bars[barList[i]].Enabled
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Frame.Bars[barList[i]].Enabled = value
					RUF:OptionsUpdateBars(singleFrame, groupFrame, header, barList[i])
				end,
			},
			toggleRainbowMode = {
				name = L["Rainbow Mode"],
				desc = L["Enables rainbow RGB animations for this bar."],
				type = 'toggle',
				order = 0.5,
				hidden = i ~= 1,
				get = function(info)
					return RUF.db.profile.unit[profileName].Frame.Bars[barList[i]].rainbow.enabled
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Frame.Bars[barList[i]].rainbow.enabled = value
					RUF:OptionsUpdateBars(singleFrame, groupFrame, header, barList[i])
				end,
			},
			smoothlyAnimate = {
				name = L["Animate"],
				desc = L["Smoothly animate bar changes. Does not affect class resources that are split into chunks such as Combo Points, or Holy Power."],
				type = 'toggle',
				order = 0.5,
				get = function(info)
					return RUF.db.profile.unit[profileName].Frame.Bars[barList[i]].Animate
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Frame.Bars[barList[i]].Animate = value
					RUF:OptionsUpdateBars(singleFrame, groupFrame, header, barList[i])
				end,
			},
			fillStyle = {
				name = L["Fill Type"],
				type = 'select',
				order = 1,
				values = function()
					if i == 2 then
						return {['STANDARD'] = L["Standard"], ['REVERSE'] = L["Reverse"]}
					end
					return {['STANDARD'] = L["Standard"], ['REVERSE'] = L["Reverse"], ['CENTER'] = L["Center"]}
				end,
				get = function(info)
					return RUF.db.profile.unit[profileName].Frame.Bars[barList[i]].Fill
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Frame.Bars[barList[i]].Fill = value
					RUF:OptionsUpdateBars(singleFrame, groupFrame, header, barList[i])
				end,
			},
			barHeight = {
				name = L["Height"],
				type = 'range',
				order = 0.04,
				hidden = i == 1,
				disabled = function() if RUF.db.profile.Appearance.Bars.Absorb.Type == 1 and i == 4 then return true end end,
				min = 2,
				max = 100,
				softMin = 4,
				softMax = 30,
				step = 1,
				bigStep = 1,
				get = function(info)
					return RUF.db.profile.unit[profileName].Frame.Bars[barList[i]].Height
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Frame.Bars[barList[i]].Height = value
					RUF:OptionsUpdateBars(singleFrame, groupFrame, header, barList[i])
				end,
			},
			barAnchor = {
				type = 'select',
				name = L["Anchor"],
				order = 0.05,
				hidden = i == 1,
				disabled = function() if RUF.db.profile.Appearance.Bars.Absorb.Type == 1 and i == 4 then return true end end,
				values = {
					['TOP'] = L["Top"],
					['BOTTOM'] = L["Bottom"],
				},
				get = function(info)
					return RUF.db.profile.unit[profileName].Frame.Bars[barList[i]].Position.Anchor
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Frame.Bars[barList[i]].Position.Anchor = value

					if profileName == 'player' then
						if RUF.db.profile.unit[profileName].Frame.Bars.Class.Position.Anchor == RUF.db.profile.unit[profileName].Frame.Bars.Power.Position.Anchor then
							local otherBar
							if i == 2 then otherBar = barList[3] elseif i == 3 then otherBar = barList[2] end
							if value == 'TOP' then
								RUF.db.profile.unit[profileName].Frame.Bars[otherBar].Position.Anchor = 'BOTTOM'
							else
								RUF.db.profile.unit[profileName].Frame.Bars[otherBar].Position.Anchor = 'TOP'
							end

						end
					end
					RUF:OptionsUpdateBars(singleFrame, groupFrame, header, barList[i])
				end,
			},
		}
	end

	return barOptions
end

local function TextSettings(singleFrame, groupFrame, header)
	local ord, referenceUnit, profileName
	singleFrame, groupFrame, header, ord, referenceUnit, profileName = ProfileData(singleFrame, groupFrame, header)

	local copyList = CopyList(singleFrame, groupFrame, header)

	local textOptions = {
		name = L["Texts"],
		type = 'group',
		childGroups = 'tree',
		order = 20,
		args = {
			addTextElement = {
				name = L["Add Text Area"],
				type = 'input',
				desc = L["Add a Text Area for this unit with this name."],
				order = 0.0,
				set = function(info, value)
					if RUF.db.profile.unit[profileName].Frame.Text[value] then
						if RUF.db.profile.unit[profileName].Frame.Text[value] ~= '' then
							RUF:Print_Self(L["A text area with that name already exists!"])
							return
						end
					end
					RUF.db.profile.unit[profileName].Frame.Text[value] = {
						Font = 'RUF',
						Outline = 'OUTLINE',
						Shadow = 0,
						Tag = value,
						Enabled = true,
						Size = 21,
						Width = 100,
						CustomWidth = false,
						Justify = 'CENTER',
						Position = {
							x = 0,
							y = 0,
							AnchorFrame = 'Frame',
							Anchor = 'CENTER',
							AnchorTo = 'CENTER',
						},
					}
					RUF:OptionsAddTexts(singleFrame,groupFrame,header,value)
					RUF:UpdateOptions()
				end,
			},
			removeTextElement = {
				name = L["Remove Text Area"],
				type = 'input',
				desc = L["Remove Text Area from this unit with this name."],
				order = 0.1,
				set = function(info, value)
					if not RUF.db.profile.unit[profileName].Frame.Text[value] then return end --TODO Error Message
					if RUF.db.profile.unit[profileName].Frame.Text[value] == '' then return end
					RUF.db.profile.unit[profileName].Frame.Text[value] = 'DISABLED'
					RUF:OptionsDisableTexts(singleFrame,groupFrame,header,value)
					RUF.db.profile.unit[profileName].Frame.Text[value] = ''
					RUF:UpdateOptions()
				end,
			},
			copyUnit = {
				name = '|cff00B2FA' .. L["Copy Settings from:"] .. '|r',
				type = 'select',
				desc = L["Copy and replace all text elements from the selected unit to this unit."],
				order = 0.2,
				values = copyList,
				confirm = function() return L["Are you sure you want to replace these settings? You cannot undo this change."] end,
				set = function(info, value)
					local target = {}
					RUF:copyTable(RUF.db.profile.unit[string.lower(value)].Frame.Text, target)
					RUF.db.profile.unit[profileName].Frame.Text = nil
					RUF.db.profile.unit[profileName].Frame.Text = target
					RUF:UpdateAllUnitSettings()
					RUF:UpdateOptions()
				end,
			},
		},
	}

	-- Generate list of text elements
	local textList = {}
	for k,v in pairs(RUF.db.profile.unit[profileName].Frame.Text) do
		if type(v) == 'table' then
			table.insert(textList,k)
		end
	end

	-- For each text element, generate a list of valid anchor elements.
	for i = 1,#textList do
		local textAnchors = {}
		textAnchors['Frame'] = 'Frame'
		for k,v in pairs(RUF.db.profile.unit[profileName].Frame.Text) do
			if type(v) == 'table' then
				if k ~= textList[i] and _G['oUF_RUF_' .. referenceUnit] and _G['oUF_RUF_' .. referenceUnit].Text[textList[i]] then
					local frameA = _G['oUF_RUF_' .. referenceUnit].Text[textList[i]].String
					local frameB = _G['oUF_RUF_' .. referenceUnit].Text[k].String
					if frameA and frameB then
						if RUF:CanAttach(frameA, frameB) then
							textAnchors[k] = k
						end
					end
				end
			end
		end

		textOptions.args[textList[i]] = {
			name = textList[i],
			type = 'group',
			order = 10,
			args = {
				enabled = {
					name = function()
						if RUF.db.profile.unit[profileName].Frame.Text[textList[i]].Enabled == true then
							return '|cFF00FF00'..L["Enabled"]..'|r'
						else
							return '|cFFFF0000'..L["Enabled"]..'|r'
						end
					end,
					type = 'toggle',
					order = 0,
					get = function(info)
						return RUF.db.profile.unit[profileName].Frame.Text[textList[i]].Enabled
					end,
					set = function(info, value)
						RUF.db.profile.unit[profileName].Frame.Text[textList[i]].Enabled = value
						RUF:OptionsUpdateTexts(singleFrame,groupFrame,header,textList[i])
					end,
				},
				tag = {
					name = L["Tag"],
					type = 'select',
					order = 0.01,
					values = tagInputs,
					get = function(info)
						return RUF.db.profile.unit[profileName].Frame.Text[textList[i]].Tag
					end,
					set = function(info, value)
						RUF.db.profile.unit[profileName].Frame.Text[textList[i]].Tag = value
						RUF:OptionsUpdateTexts(singleFrame,groupFrame,header,textList[i])
					end,
				},
				tagSpacer = {
					name = ' ',
					type = 'description',
					order = 0.02,
					width = 'full',
				},
				offsetX = {
					name = L["X Offset"],
					type = 'range',
					desc = L["Horizontal Offset from the Anchor."],
					order = 0.03,
					min = -500,
					max = 500,
					softMin = -100,
					softMax = 100,
					step = 0.5,
					bigStep = 1,
					get = function(info)
						return RUF.db.profile.unit[profileName].Frame.Text[textList[i]].Position.x
					end,
					set = function(info, value)
						RUF.db.profile.unit[profileName].Frame.Text[textList[i]].Position.x = value
						RUF:OptionsUpdateTexts(singleFrame,groupFrame,header,textList[i])
					end,
				},
				offsetY = {
					name = L["Y Offset"],
					type = 'range',
					desc = L["Vertical Offset from the Anchor."],
					order = 0.04,
					min = -500,
					max = 500,
					softMin = -100,
					softMax = 100,
					step = 0.5,
					bigStep = 1,
					get = function(info)
						return RUF.db.profile.unit[profileName].Frame.Text[textList[i]].Position.y
					end,
					set = function(info, value)
						RUF.db.profile.unit[profileName].Frame.Text[textList[i]].Position.y = value
						RUF:OptionsUpdateTexts(singleFrame,groupFrame,header,textList[i])
					end,
				},
				anchorFrame = {
					name = L["Attach To"],
					type = 'select',
					desc = L["Choose an element to attach to, either the frame or another text area."],
					order = 0.06,
					values = textAnchors,
					get = function(info)
						RUF:OptionsUpdateTexts(singleFrame,groupFrame,header,textList[i])
						return RUF.db.profile.unit[profileName].Frame.Text[textList[i]].Position.AnchorFrame
					end,
					set = function(info, value)
						if value ~= nil and value:match('%S') ~= nil then
							if value == 'Frame' then
								RUF.db.profile.unit[profileName].Frame.Text[textList[i]].Position.AnchorFrame = 'Frame'
							elseif RUF:CanAttach(
								_G['oUF_RUF_' .. referenceUnit].Text[textList[i]].String,
								_G['oUF_RUF_' .. referenceUnit].Text[value].String) then
								RUF.db.profile.unit[profileName].Frame.Text[textList[i]].Position.AnchorFrame = value
							else
								RUF.db.profile.unit[profileName].Frame.Text[textList[i]].Position.AnchorFrame = 'Frame'
							end
						else
							RUF.db.profile.unit[profileName].Frame.Text[textList[i]].Position.AnchorFrame = 'Frame'
						end
						RUF:OptionsUpdateTexts(singleFrame,groupFrame,header,textList[i])
						RUF:UpdateOptions()
					end,
				},
				anchorFrom = {
					name = L["Anchor From"],
					type = 'select',
					order = 0.07,
					values = anchorPoints,
					get = function(info)
						return RUF.db.profile.unit[profileName].Frame.Text[textList[i]].Position.Anchor
					end,
					set = function(info, value)
						RUF.db.profile.unit[profileName].Frame.Text[textList[i]].Position.Anchor = value
						RUF:OptionsUpdateTexts(singleFrame,groupFrame,header,textList[i])
					end,
				},
				anchorPoint = {
					name = L["Anchor To"],
					type = 'select',
					order = 0.08,
					values = anchorPoints,
					get = function(info)
						if not RUF.db.profile.unit[profileName].Frame.Text[textList[i]].Position.AnchorTo then -- Update all existing text elements from before this change so they have the correct anchor points.
							local reverseAnchor = RUF.db.profile.unit[profileName].Frame.Text[textList[i]].Position.Anchor
							RUF.db.profile.unit[profileName].Frame.Text[textList[i]].Position.AnchorTo = reverseAnchor
							if RUF.db.profile.unit[profileName].Frame.Text[textList[i]].Position.AnchorFrame ~= 'Frame' then
								reverseAnchor = anchorSwaps[reverseAnchor]
							end
							RUF.db.profile.unit[profileName].Frame.Text[textList[i]].Position.Anchor = reverseAnchor
						end
						return RUF.db.profile.unit[profileName].Frame.Text[textList[i]].Position.AnchorTo
					end,
					set = function(info, value)
						RUF.db.profile.unit[profileName].Frame.Text[textList[i]].Position.AnchorTo = value
						RUF:OptionsUpdateTexts(singleFrame,groupFrame,header,textList[i])
					end,
				},
				font = {
					name = L["Font"],
					type = 'select',
					order = 10,
					values = LSM:HashTable('font'),
					dialogControl = 'LSM30_Font',
					get = function(info)
						return RUF.db.profile.unit[profileName].Frame.Text[textList[i]].Font
					end,
					set = function(info, value)
						RUF.db.profile.unit[profileName].Frame.Text[textList[i]].Font = value
						RUF:OptionsUpdateTexts(singleFrame,groupFrame,header,textList[i])
					end,
				},
				fontSize = {
					name = L["Font Size"],
					type = 'range',
					order = 10,
					min = 4,
					max = 256,
					softMin = 8,
					softMax = 48,
					step = 1,
					bigStep = 1,
					get = function(info)
						return RUF.db.profile.unit[profileName].Frame.Text[textList[i]].Size
					end,
					set = function(info, value)
						RUF.db.profile.unit[profileName].Frame.Text[textList[i]].Size = value
						RUF:OptionsUpdateTexts(singleFrame,groupFrame,header,textList[i])
					end,
				},
				fontOutline = {
					name = L["Outline"],
					type = 'select',
					order = 10,
					values = {
						[''] = L["None"],
						['OUTLINE'] = L["Outline"],
						['THICKOUTLINE'] = L["Thick Outline"],
						['MONOCHROME'] = L["Monochrome"],
						['MONOCHROME,OUTLINE'] = L["Monochrome Outline"],
						['MONOCHROME,THICKOUTLINE'] = L["Monochrome Thick Outline"],
					},
					get = function(info)
						return RUF.db.profile.unit[profileName].Frame.Text[textList[i]].Outline
					end,
					set = function(info, value)
						RUF.db.profile.unit[profileName].Frame.Text[textList[i]].Outline = value
						RUF:OptionsUpdateTexts(singleFrame,groupFrame,header,textList[i])
					end,
				},
				fontShadow = {
					name = L["Shadow"],
					type = 'toggle',
					desc = L["Enable Text Shadow"],
					order = 10,
					get = function(info)
						if RUF.db.profile.unit[profileName].Frame.Text[textList[i]].Shadow == 1 then
							return true
						else
							return false
						end
					end,
					set = function(info, value)
						if value == true then
							RUF.db.profile.unit[profileName].Frame.Text[textList[i]].Shadow = 1
						else
							RUF.db.profile.unit[profileName].Frame.Text[textList[i]].Shadow = 0
						end
						RUF:OptionsUpdateTexts(singleFrame,groupFrame,header,textList[i])
					end,
				},
				customWidthSpacer = {
					name = ' ',
					type = 'description',
					order = 20,
					width = 'full',
				},
				customWidth = {
					name = L["Custom Width"],
					type = 'toggle',
					desc = L["Toggle on to force text element to be set to a custom width. If the text is longer than the width, truncation will occur unless word wrap is enabled."],
					order = 20.01,
					--hidden = true,
					get = function(info)
						return RUF.db.profile.unit[profileName].Frame.Text[textList[i]].CustomWidth
					end,
					set = function(info, value)
						RUF.db.profile.unit[profileName].Frame.Text[textList[i]].CustomWidth = value
						RUF:OptionsUpdateTexts(singleFrame,groupFrame,header,textList[i])
					end,
				},
				textWrapSpacer = {
					name = ' ',
					type = 'description',
					order = 20.1,
					width = 'full',
				},
				textWrap = {
					name = L["Word Wrap"],
					type = 'toggle',
					desc = L["Allows text to display on multiple lines when the width is too short to display everything on one line."],
					order = 20.11,
					hidden = function() return not RUF.db.profile.unit[profileName].Frame.Text[textList[i]].CustomWidth end,
					get = function(info)
						return RUF.db.profile.unit[profileName].Frame.Text[textList[i]].WordWrap
					end,
					set = function(info, value)
						RUF.db.profile.unit[profileName].Frame.Text[textList[i]].WordWrap = value
						RUF:OptionsUpdateTexts(singleFrame,groupFrame,header,textList[i])
					end,
				},
				textWidth = {
					name = L["Width"],
					type = 'range',
					order = 20.12,
					min = 0,
					max = 750,
					softMin = 10,
					softMax = RUF.db.profile.unit[profileName].Frame.Size.Width,
					step = 1,
					bigStep = 10,
					hidden = function() return not RUF.db.profile.unit[profileName].Frame.Text[textList[i]].CustomWidth end,
					get = function(info)
						return RUF.db.profile.unit[profileName].Frame.Text[textList[i]].Width
					end,
					set = function(info, value)
						RUF.db.profile.unit[profileName].Frame.Text[textList[i]].Width = value
						RUF:OptionsUpdateTexts(singleFrame,groupFrame,header,textList[i])
					end,
				},
				textJustify = {
					name = L["Justify"],
					type = 'select',
					order = 20.13,
					values = {
						['LEFT'] = L["Left"],
						['RIGHT'] = L["Right"],
						['CENTER'] = L["Center"],
					},
					hidden = function() return not RUF.db.profile.unit[profileName].Frame.Text[textList[i]].CustomWidth end,
					get = function(info)
						return RUF.db.profile.unit[profileName].Frame.Text[textList[i]].Justify
					end,
					set = function(info, value)
						RUF.db.profile.unit[profileName].Frame.Text[textList[i]].Justify = value
						RUF:OptionsUpdateTexts(singleFrame,groupFrame,header,textList[i])
					end,
				},
			},
		}

	end

	return textOptions
end

local function HideIndicatorOptions(profileName,indicator)
	if indicator == 'Honor' then return true end -- Not implemented
	if indicator == 'LootMaster' or indicator == 'PetHappiness' then
		return true
	end
	if indicator == 'Role' or indicator == 'Objective' or indicator == 'Honor' then
		return true
	end
	if (indicator == 'InCombat' or indicator == 'Rest') and profileName ~= 'player' then return true end
	if indicator == 'PetHappiness' then
		if profileName == 'player' or profileName == 'pet' then
			return false
		else
			return true
		end
	end
	if profileName == 'player' then
		if indicator == 'Objective' or indicator == 'Phased' then
			return true
		else
			return false
		end
	elseif profileName == 'party' then
		if indicator == 'Objective' then
			return true
		else
			return false
		end
	elseif profileName == 'arena' then
		if indicator == 'Assist' or indicator == 'Lead' or indicator == 'MainTankAssist' or indicator == 'Objective' or indicator == 'Ready' then
			return true
		else
			return false
		end
	elseif profileName == 'pet' then
		if indicator == 'TargetMark' or indicator == 'PvPCombat' then
			return false
		else
			return true
		end
	elseif profileName == 'partypet' then
		if indicator == 'TargetMark' or indicator == 'Phased' or indicator == 'PvPCombat' then
			return false
		else
			return true
		end
	elseif profileName == 'boss' then
		if indicator == 'Phased' or indicator == 'Objective' or indicator == 'TargetMark' then
			return false
		else
			return true
		end
	end
end

local function IndicatorSettings(singleFrame,groupFrame,header)
	local ord, referenceUnit, profileName
	singleFrame, groupFrame, header, ord, referenceUnit, profileName = ProfileData(singleFrame, groupFrame, header)

	local indicators = {
		[1] = 'Assist',
		[2] = 'Honor',
		[3] = 'InCombat',
		[4] = 'Lead',
		[5] = 'LootMaster',
		[6] = 'MainTankAssist',
		[7] = 'PetHappiness',
		[8] = 'Phased',
		[9] = 'PvPCombat',
		[10] = 'Objective',
		[11] = 'Ready',
		[12] = 'Rest',
		[13] = 'Role',
		[14] = 'TargetMark',
	}

	local indicatorOptions = {
		name = L["Indicators"],
		type = 'group',
		order = 30,
		args = {
		},
	}

	for i = 1,#indicators do
		local currentIndicator = indicators[i] .. 'Indicator'
		local indicatorAnchors = {}
		indicatorAnchors['Frame'] = 'Frame'
		for k,v in pairs(RUF.db.profile.unit[profileName].Frame.Indicators) do
			if v ~= '' then
				if k ~= indicators[i] and _G['oUF_RUF_' .. referenceUnit] then
					local targetIndicator = k..'Indicator'
					if RUF:CanAttach(_G['oUF_RUF_' .. referenceUnit][currentIndicator],_G['oUF_RUF_' .. referenceUnit][targetIndicator]) then
						indicatorAnchors[k] = L[k]
					end
				end
			end
		end
		indicatorOptions.args[indicators[i]] = {
			name = L[indicators[i]],
			type = 'group',
			order = 0,
			hidden = HideIndicatorOptions(profileName, indicators[i]),
			args = {
				enabled = {
					name = function()
						if RUF.db.profile.unit[profileName].Frame.Indicators[indicators[i]].Enabled == true then
							return '|cFF00FF00'..L["Enabled"]..'|r'
						else
							return '|cFFFF0000'..L["Enabled"]..'|r'
						end
					end,
					type = 'toggle',
					order = 0,
					get = function(info)
						return RUF.db.profile.unit[profileName].Frame.Indicators[indicators[i]].Enabled
					end,
					set = function(info, value)
						RUF.db.profile.unit[profileName].Frame.Indicators[indicators[i]].Enabled = value
						RUF:OptionsUpdateIndicators(singleFrame,groupFrame,header,indicators[i])
					end,
				},
				enabledSpacer = {
					name = '',
					type = 'description',
					order = 1,
					width = 'full',
				},
				indicatorSize = {
					name = L["Size"],
					type = 'range',
					order = 2,
					min = 4,
					max = 256,
					softMin = 8,
					softMax = 64,
					step = 1,
					bigStep = 1,
					get = function(info)
						return RUF.db.profile.unit[profileName].Frame.Indicators[indicators[i]].Size
					end,
					set = function(info, value)
						RUF.db.profile.unit[profileName].Frame.Indicators[indicators[i]].Size = value
						RUF:OptionsUpdateIndicators(singleFrame,groupFrame,header,indicators[i])
					end,
				},
				offsetX = {
					name = L["X Offset"],
					type = 'range',
					desc = L["Horizontal Offset from the Anchor."],
					order = 3,
					min = -500,
					max = 500,
					softMin = -100,
					softMax = 100,
					step = 0.5,
					bigStep = 1,
					get = function(info)
						return RUF.db.profile.unit[profileName].Frame.Indicators[indicators[i]].Position.x
					end,
					set = function(info, value)
						RUF.db.profile.unit[profileName].Frame.Indicators[indicators[i]].Position.x = value
						RUF:OptionsUpdateIndicators(singleFrame,groupFrame,header,indicators[i])
					end,
				},
				offsetY = {
					name = L["Y Offset"],
					type = 'range',
					desc = L["Vertical Offset from the Anchor."],
					order = 4,
					min = -500,
					max = 500,
					softMin = -100,
					softMax = 100,
					step = 0.5,
					bigStep = 1,
					get = function(info)
						return RUF.db.profile.unit[profileName].Frame.Indicators[indicators[i]].Position.y
					end,
					set = function(info, value)
						RUF.db.profile.unit[profileName].Frame.Indicators[indicators[i]].Position.y = value
						RUF:OptionsUpdateIndicators(singleFrame,groupFrame,header,indicators[i])
					end,
				},
				anchorFrom = {
					name = L["Anchor From"],
					type = 'select',
					desc = L["Location area of the Indicator to anchor from."],
					order = 5,
					values = anchorPoints,
					get = function(info)
						return RUF.db.profile.unit[profileName].Frame.Indicators[indicators[i]].Position.AnchorFrom
					end,
					set = function(info, value)
						RUF.db.profile.unit[profileName].Frame.Indicators[indicators[i]].Position.AnchorFrom = value
						RUF:OptionsUpdateIndicators(singleFrame,groupFrame,header,indicators[i])
					end,
				},
				anchorFrame = {
					name = L["Attach To"],
					type = 'select',
					desc = L["Choose an element to attach to, either the frame or another indicator."],
					values = indicatorAnchors,
					order = 6,
					get = function(info)
						return RUF.db.profile.unit[profileName].Frame.Indicators[indicators[i]].Position.AnchorFrame
					end,
					set = function(info, value)
						if value ~= nil and value:match('%S') ~= nil then
							if value == 'Frame' then
								RUF.db.profile.unit[profileName].Frame.Indicators[indicators[i]].Position.AnchorFrame = 'Frame'
							elseif RUF:CanAttach(_G['oUF_RUF_' .. referenceUnit][currentIndicator], _G['oUF_RUF_' .. referenceUnit][value..'Indicator']) then
								RUF.db.profile.unit[profileName].Frame.Indicators[indicators[i]].Position.AnchorFrame = value
							else
								RUF.db.profile.unit[profileName].Frame.Indicators[indicators[i]].Position.AnchorFrame = 'Frame'
							end
						else
							RUF.db.profile.unit[profileName].Frame.Indicators[indicators[i]].Position.AnchorFrame = 'Frame'
						end
						RUF:OptionsUpdateIndicators(singleFrame,groupFrame,header,indicators[i])
						RUF:UpdateOptions()
					end,
				},
				anchorPoint = {
					name = L["Anchor To"],
					type = 'select',
					desc = L["Area on the anchor frame to anchor the indicator to."],
					order = 7,
					values = anchorPoints,
					get = function(info)
						return RUF.db.profile.unit[profileName].Frame.Indicators[indicators[i]].Position.AnchorTo
					end,
					set = function(info, value)
						RUF.db.profile.unit[profileName].Frame.Indicators[indicators[i]].Position.AnchorTo = value
						RUF:OptionsUpdateIndicators(singleFrame,groupFrame,header,indicators[i])
					end,
				},
			},
		}
	end
	return indicatorOptions
end

local function BuffSettings(singleFrame,groupFrame,header)
	local ord, referenceUnit, profileName
	singleFrame, groupFrame, header, ord, referenceUnit, profileName = ProfileData(singleFrame, groupFrame, header)

	local copyList = CopyList(singleFrame, groupFrame, header)

	local buffOptions = {
		name = L["Buffs"],
		type = 'group',
		order = 40,
		args = {
			copyUnit = {
				name = '|cff00B2FA' .. L["Copy Settings from:"] .. '|r',
				type = 'select',
				desc = L["Copy and replace settings from the selected unit to this unit."],
				order = 0,
				values = copyList,
				confirm = function() return L["Are you sure you want to replace these settings? You cannot undo this change."] end,
				set = function(info, value)
					local target = {}
					RUF:copyTable(RUF.db.profile.unit[string.lower(value)].Buffs, target)
					RUF.db.profile.unit[profileName].Buffs = nil
					RUF.db.profile.unit[profileName].Buffs = target
					RUF:UpdateAllUnitSettings()
					RUF:UpdateOptions()
				end,
			},
			enabled = {
				name = function()
					if RUF.db.profile.unit[profileName].Buffs.Icons.Enabled == true then
						return '|cFF00FF00'..L["Enabled"]..'|r'
					else
						return '|cFFFF0000'..L["Enabled"]..'|r'
					end
				end,
				type = 'toggle',
				order = 0.01,
				get = function(info)
					return RUF.db.profile.unit[profileName].Buffs.Icons.Enabled
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Buffs.Icons.Enabled = value
					RUF:OptionsUpdateAuras(singleFrame,groupFrame,header,'Buffs')
				end,
			},
			enabledSpacer = {
				name = ' ',
				type = 'description',
				order = 1,
				width = 'full',
			},
			buffWidth = {
				name = L["Icon Width"],
				type = 'range',
				order = 2,
				min = 4,
				max = 64,
				softMin = 12,
				softMax = 32,
				step = 1,
				bigStep = 1,
				get = function(info)
					return RUF.db.profile.unit[profileName].Buffs.Icons.Width
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Buffs.Icons.Width = value
					RUF:OptionsUpdateAuras(singleFrame,groupFrame,header,'Buffs')
				end,
			},
			buffHeight = {
				name = L["Icon Height"],
				type = 'range',
				order = 2,
				min = 4,
				max = 64,
				softMin = 12,
				softMax = 32,
				step = 1,
				bigStep = 1,
				get = function(info)
					return RUF.db.profile.unit[profileName].Buffs.Icons.Height
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Buffs.Icons.Height = value
					RUF:OptionsUpdateAuras(singleFrame,groupFrame,header,'Buffs')
				end,
			},
			numColumns = {
				name = L["Columns"],
				type = 'range',
				order = 3,
				min = 1,
				max = 64,
				softMin = 1,
				softMax = 32,
				step = 1,
				bigStep = 1,
				get = function(info)
					return RUF.db.profile.unit[profileName].Buffs.Icons.Columns
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Buffs.Icons.Columns = value
					RUF:OptionsUpdateAuras(singleFrame,groupFrame,header,'Buffs')
				end,
			},
			horizontalPadding = {
				name = L["Horizontal Spacing"],
				type = 'range',
				order = 3.1,
				min = -500,
				max = 500,
				softMin = -100,
				softMax = 100,
				step = 0.5,
				bigStep = 1,
				get = function(info)
					return RUF.db.profile.unit[profileName].Buffs.Icons.Spacing.x
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Buffs.Icons.Spacing.x = value
					RUF:OptionsUpdateAuras(singleFrame,groupFrame,header,'Buffs')
				end,
			},
			verticalPadding = {
				name = L["Vertical Spacing"],
				type = 'range',
				order = 3.2,
				min = -500,
				max = 500,
				softMin = -100,
				softMax = 100,
				step = 0.5,
				bigStep = 1,
				get = function(info)
					return RUF.db.profile.unit[profileName].Buffs.Icons.Spacing.y
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Buffs.Icons.Spacing.y = value
					RUF:OptionsUpdateAuras(singleFrame,groupFrame,header,'Buffs')
				end,
			},
			horizontalGrowthDirection = {
				type = 'select',
				name = L["Horizontal Growth"],
				order = 3.3,
				values = {
					['RIGHT'] = L["Right"],
					['LEFT'] = L["Left"],
				},
				get = function(info)
					return RUF.db.profile.unit[profileName].Buffs.Icons.Growth.x
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Buffs.Icons.Growth.x = value
					RUF:OptionsUpdateAuras(singleFrame,groupFrame,header,'Buffs')
				end,
			},
			verticalGrowthDirection = {
				type = 'select',
				name = L["Vertical Growth"],
				order = 3.3,
				values = {
					DOWN = L["Down"],
					UP = L["Up"],
				},
				get = function(info)
					return RUF.db.profile.unit[profileName].Buffs.Icons.Growth.y
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Buffs.Icons.Growth.y = value
					RUF:OptionsUpdateAuras(singleFrame,groupFrame,header,'Buffs')
				end,
			},
			sortingHeader = {
				name = L["Sorting"],
				type = 'header',
				order = 3.5,
				hidden = true,
			},
			sortDirection = {
				name = L["Direction"],
				type = 'select',
				hidden = true, -- Why? TODO
				order = 4,
				values = {
					Ascending = L["Ascending"],
					Descending = L["Descending"],
				},
				get = function(info)
					return RUF.db.profile.unit[profileName].Buffs.Icons.Sort.Direction
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Buffs.Icons.Sort.Direction = value
					RUF:OptionsUpdateAuras(singleFrame,groupFrame,header,'Buffs')
				end,
			},
			sortType = {
				type = 'select',
				name = L["Sort By"],
				hidden = true, -- Why? NYI? Check it. TODO
				order = 4,
				values = {
					Alphabetically = L["Alphabetically"],
					Duration = L["Duration"],
					Index = L["Index"],
					Player = L["Player"],
					Remaining = L["Time Remaining"],
				},
				get = function(info)
					return RUF.db.profile.unit[profileName].Buffs.Icons.Sort.SortBy
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Buffs.Icons.Sort.SortBy = value
					RUF:OptionsUpdateAuras(singleFrame,groupFrame,header,'Buffs')
				end,
			},
			anchorHeader = {
				name = L["Anchoring"],
				type = 'header',
				order = 4.5,
			},
			horizontalOffset = {
				name = L["X Offset"],
				type = 'range',
				desc = L["Horizontal Offset from the Anchor."],
				order = 5,
				min = -500,
				max = 500,
				softMin = -100,
				softMax = 100,
				step = 0.5,
				bigStep = 1,
				get = function(info)
					return RUF.db.profile.unit[profileName].Buffs.Icons.Position.x
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Buffs.Icons.Position.x = value
					RUF:OptionsUpdateAuras(singleFrame,groupFrame,header,'Buffs')
				end,
			},
			verticalOffset = {
				name = L["Y Offset"],
				type = 'range',
				desc = L["Vertical Offset from the Anchor."],
				order = 6,
				min = -500,
				max = 500,
				softMin = -100,
				softMax = 100,
				step = 0.5,
				bigStep = 1,
				get = function(info)
					return RUF.db.profile.unit[profileName].Buffs.Icons.Position.y
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Buffs.Icons.Position.y = value
					RUF:OptionsUpdateAuras(singleFrame,groupFrame,header,'Buffs')
				end,
			},
			anchorFrom = {
				name = L["Anchor From"],
				type = 'select',
				order = 7,
				values = anchorPoints,
				get = function(info)
					return RUF.db.profile.unit[profileName].Buffs.Icons.Position.AnchorFrom
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Buffs.Icons.Position.AnchorFrom = value
					RUF:OptionsUpdateAuras(singleFrame,groupFrame,header,'Buffs')
				end,
			},
			anchorPoint = {
				name = L["Anchor To"],
				type = 'select',
				order = 7,
				values = anchorPoints,
				get = function(info)
					return RUF.db.profile.unit[profileName].Buffs.Icons.Position.AnchorTo
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Buffs.Icons.Position.AnchorTo = value
					RUF:OptionsUpdateAuras(singleFrame,groupFrame,header,'Buffs')
				end,
			},
			clickThrough = {
				name = L["Click Through"],
				type = 'toggle',
				order = 8,
				get = function(info)
					return RUF.db.profile.unit[profileName].Buffs.Icons.ClickThrough
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Buffs.Icons.ClickThrough = value
					RUF:OptionsUpdateAuras(singleFrame,groupFrame,header,'Buffs')
				end,
			},
			filterHeader = {
				name = L["Filtering"],
				type = 'header',
				order = 10.5,
			},
			filterCasterByPlayer = {
				name = L["Show Player"],
				type = 'toggle',
				desc = L["Show buffs cast by %s on this unit."]:format(L["Player"]),
				order = 15,
				get = function(info)
					return RUF.db.profile.unit[profileName].Buffs.Icons.Filter.Caster.Player
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Buffs.Icons.Filter.Caster.Player = value
					RUF:OptionsUpdateAuras(singleFrame,groupFrame,header,'Buffs')
				end,
			},
			filterCasterByCurrentUnit = {
				name = L["Show %s"]:format(L[profileName]),
				type = 'toggle',
				desc = L["Show buffs cast by %s on this unit."]:format(L[profileName]),
				hidden = profileName == 'player',
				order = 16,
				get = function(info)
					return RUF.db.profile.unit[profileName].Buffs.Icons.Filter.Caster.Unit
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Buffs.Icons.Filter.Caster.Unit = value
					RUF:OptionsUpdateAuras(singleFrame,groupFrame,header,'Buffs')
				end,
			},
			filterCasterByGroupUnits = {
				name = L["Show Group Members"],
				type = 'toggle',
				desc = L["Show buffs cast by %s on this unit."]:format(L["group members"]),
				order = 16,
				get = function(info)
					return RUF.db.profile.unit[profileName].Buffs.Icons.Filter.Caster.Group
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Buffs.Icons.Filter.Caster.Group = value
					RUF:OptionsUpdateAuras(singleFrame,groupFrame,header,'Buffs')
				end,
			},
			filterCasterByOtherUnits = {
				name = L["Show Others"],
				type = 'toggle',
				desc = L["Show buffs cast by %s on this unit."]:format(L["others"]),
				order = 16,
				get = function(info)
					return RUF.db.profile.unit[profileName].Buffs.Icons.Filter.Caster.Other
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Buffs.Icons.Filter.Caster.Other = value
					RUF:OptionsUpdateAuras(singleFrame,groupFrame,header,'Buffs')
				end,
			},
			filterSpacer = {
				name = ' ',
				type = 'description',
				order = 17,
				width = 'full',
			},
			minDuration = {
				name = L["Minimum Duration"],
				type = 'range',
				order = 20,
				min = 0,
				max = 3600,
				softMin = 0,
				softMax = 360,
				step = 0.5,
				bigStep = 1,
				get = function(info)
					return RUF.db.profile.unit[profileName].Buffs.Icons.Filter.Time.Min
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Buffs.Icons.Filter.Time.Min = value
					RUF:OptionsUpdateAuras(singleFrame,groupFrame,header,'Buffs')
				end,
			},
			maxDuration = {
				name = L["Maximum Duration"],
				type = 'range',
				order = 21,
				min = 0,
				max = 86400,
				softMin = 0,
				softMax = 3600,
				step = 0.5,
				bigStep = 5,
				get = function(info)
					return RUF.db.profile.unit[profileName].Buffs.Icons.Filter.Time.Max
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Buffs.Icons.Filter.Time.Max = value
					RUF:OptionsUpdateAuras(singleFrame,groupFrame,header,'Buffs')
				end,
			},
			toggleDurationLimit = {
				name = L["Show Unlimited Duration"],
				type = 'toggle',
				order = 22,
				get = function(info)
					return RUF.db.profile.unit[profileName].Buffs.Icons.Filter.Time.Unlimited
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Buffs.Icons.Filter.Time.Unlimited = value
					RUF:OptionsUpdateAuras(singleFrame,groupFrame,header,'Buffs')
				end,
			},
			filterDispellable = {
				name = L["Show Only Dispellable"],
				type = 'toggle',
				desc = L["Show only auras you can dispel"],
				order = 23,
				get = function(info)
					return RUF.db.profile.unit[profileName].Buffs.Icons.Filter.Dispellable
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Buffs.Icons.Filter.Dispellable = value
					RUF:OptionsUpdateAuras(singleFrame,groupFrame,header,'Buffs')
				end,
			},
			maxAuras = {
				name = L["Max Auras"],
				type = 'range',
				order = 24,
				min = 1,
				max = 64,
				softMin = 1,
				softMax = 32,
				step = 1,
				bigStep = 1,
				get = function(info)
					return RUF.db.profile.unit[profileName].Buffs.Icons.Max
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Buffs.Icons.Max = value
					RUF:OptionsUpdateAuras(singleFrame,groupFrame,header,'Buffs')
				end,
			},
		},
	}

	return buffOptions
end

local function DebuffSettings(singleFrame,groupFrame,header)
	local ord, referenceUnit, profileName
	singleFrame, groupFrame, header, ord, referenceUnit, profileName = ProfileData(singleFrame, groupFrame, header)

	local copyList = CopyList(singleFrame, groupFrame, header)

	local debuffOptions = {
		name = L["Debuffs"],
		type = 'group',
		order = 40,
		args = {
			copyUnit = {
				name = '|cff00B2FA' .. L["Copy Settings from:"] .. '|r',
				type = 'select',
				desc = L["Copy and replace settings from the selected unit to this unit."],
				order = 0,
				values = copyList,
				confirm = function() return L["Are you sure you want to replace these settings? You cannot undo this change."] end,
				set = function(info, value)
					local target = {}
					RUF:copyTable(RUF.db.profile.unit[string.lower(value)].Debuffs, target)
					RUF.db.profile.unit[profileName].Debuffs = nil
					RUF.db.profile.unit[profileName].Debuffs = target
					RUF:UpdateAllUnitSettings()
					RUF:UpdateOptions()
				end,
			},
			enabled = {
				name = function()
					if RUF.db.profile.unit[profileName].Debuffs.Icons.Enabled == true then
						return '|cFF00FF00'..L["Enabled"]..'|r'
					else
						return '|cFFFF0000'..L["Enabled"]..'|r'
					end
				end,
				type = 'toggle',
				order = 0.01,
				get = function(info)
					return RUF.db.profile.unit[profileName].Debuffs.Icons.Enabled
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Debuffs.Icons.Enabled = value
					RUF:OptionsUpdateAuras(singleFrame,groupFrame,header,'Debuffs')
				end,
			},
			enabledSpacer = {
				name = ' ',
				type = 'description',
				order = 1,
				width = 'full',
			},
			debuffWidth = {
				name = L["Icon Width"],
				type = 'range',
				order = 2,
				min = 4,
				max = 64,
				softMin = 12,
				softMax = 32,
				step = 1,
				bigStep = 1,
				get = function(info)
					return RUF.db.profile.unit[profileName].Debuffs.Icons.Width
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Debuffs.Icons.Width = value
					RUF:OptionsUpdateAuras(singleFrame,groupFrame,header,'Debuffs')
				end,
			},
			debuffHeight = {
				name = L["Icon Height"],
				type = 'range',
				order = 2,
				min = 4,
				max = 64,
				softMin = 12,
				softMax = 32,
				step = 1,
				bigStep = 1,
				get = function(info)
					return RUF.db.profile.unit[profileName].Debuffs.Icons.Height
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Debuffs.Icons.Height = value
					RUF:OptionsUpdateAuras(singleFrame,groupFrame,header,'Debuffs')
				end,
			},
			numColumns = {
				name = L["Columns"],
				type = 'range',
				order = 3,
				min = 1,
				max = 64,
				softMin = 1,
				softMax = 32,
				step = 1,
				bigStep = 1,
				get = function(info)
					return RUF.db.profile.unit[profileName].Debuffs.Icons.Columns
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Debuffs.Icons.Columns = value
					RUF:OptionsUpdateAuras(singleFrame,groupFrame,header,'Debuffs')
				end,
			},
			horizontalPadding = {
				name = L["Horizontal Spacing"],
				type = 'range',
				order = 3.1,
				min = -500,
				max = 500,
				softMin = -100,
				softMax = 100,
				step = 0.5,
				bigStep = 1,
				get = function(info)
					return RUF.db.profile.unit[profileName].Debuffs.Icons.Spacing.x
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Debuffs.Icons.Spacing.x = value
					RUF:OptionsUpdateAuras(singleFrame,groupFrame,header,'Debuffs')
				end,
			},
			verticalPadding = {
				name = L["Vertical Spacing"],
				type = 'range',
				order = 3.2,
				min = -500,
				max = 500,
				softMin = -100,
				softMax = 100,
				step = 0.5,
				bigStep = 1,
				get = function(info)
					return RUF.db.profile.unit[profileName].Debuffs.Icons.Spacing.y
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Debuffs.Icons.Spacing.y = value
					RUF:OptionsUpdateAuras(singleFrame,groupFrame,header,'Debuffs')
				end,
			},
			horizontalGrowthDirection = {
				type = 'select',
				name = L["Horizontal Growth"],
				order = 3.3,
				values = {
					['RIGHT'] = L["Right"],
					['LEFT'] = L["Left"],
				},
				get = function(info)
					return RUF.db.profile.unit[profileName].Debuffs.Icons.Growth.x
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Debuffs.Icons.Growth.x = value
					RUF:OptionsUpdateAuras(singleFrame,groupFrame,header,'Debuffs')
				end,
			},
			verticalGrowthDirection = {
				type = 'select',
				name = L["Vertical Growth"],
				order = 3.3,
				values = {
					DOWN = L["Down"],
					UP = L["Up"],
				},
				get = function(info)
					return RUF.db.profile.unit[profileName].Debuffs.Icons.Growth.y
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Debuffs.Icons.Growth.y = value
					RUF:OptionsUpdateAuras(singleFrame,groupFrame,header,'Debuffs')
				end,
			},
			sortingHeader = {
				name = L["Sorting"],
				type = 'header',
				order = 3.5,
				hidden = true,
			},
			sortDirection = {
				name = L["Direction"],
				type = 'select',
				hidden = true, -- Why?
				order = 4,
				values = {
					Ascending = L["Ascending"],
					Descending = L["Descending"],
				},
				get = function(info)
					return RUF.db.profile.unit[profileName].Debuffs.Icons.Sort.Direction
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Debuffs.Icons.Sort.Direction = value
					RUF:OptionsUpdateAuras(singleFrame,groupFrame,header,'Debuffs')
				end,
			},
			sortType = {
				type = 'select',
				name = L["Sort By"],
				hidden = true, -- Why? NYI? Check it.
				order = 4,
				values = {
					Alphabetically = L["Alphabetically"],
					Duration = L["Duration"],
					Index = L["Index"],
					Player = L["Player"],
					Remaining = L["Time Remaining"],
				},
				get = function(info)
					return RUF.db.profile.unit[profileName].Debuffs.Icons.Sort.SortBy
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Debuffs.Icons.Sort.SortBy = value
					RUF:OptionsUpdateAuras(singleFrame,groupFrame,header,'Debuffs')
				end,
			},
			anchorHeader = {
				name = L["Anchoring"],
				type = 'header',
				order = 4.5,
			},
			horizontalOffset = {
				name = L["X Offset"],
				type = 'range',
				desc = L["Horizontal Offset from the Anchor."],
				order = 5,
				min = -500,
				max = 500,
				softMin = -100,
				softMax = 100,
				step = 0.5,
				bigStep = 1,
				get = function(info)
					return RUF.db.profile.unit[profileName].Debuffs.Icons.Position.x
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Debuffs.Icons.Position.x = value
					RUF:OptionsUpdateAuras(singleFrame,groupFrame,header,'Debuffs')
				end,
			},
			verticalOffset = {
				name = L["Y Offset"],
				type = 'range',
				desc = L["Vertical Offset from the Anchor."],
				order = 6,
				min = -500,
				max = 500,
				softMin = -100,
				softMax = 100,
				step = 0.5,
				bigStep = 1,
				get = function(info)
					return RUF.db.profile.unit[profileName].Debuffs.Icons.Position.y
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Debuffs.Icons.Position.y = value
					RUF:OptionsUpdateAuras(singleFrame,groupFrame,header,'Debuffs')
				end,
			},
			anchorFrom = {
				name = L["Anchor From"],
				type = 'select',
				order = 7,
				values = anchorPoints,
				get = function(info)
					return RUF.db.profile.unit[profileName].Debuffs.Icons.Position.AnchorFrom
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Debuffs.Icons.Position.AnchorFrom = value
					RUF:OptionsUpdateAuras(singleFrame,groupFrame,header,'Debuffs')
				end,
			},
			anchorPoint = {
				name = L["Anchor To"],
				type = 'select',
				order = 7,
				values = anchorPoints,
				get = function(info)
					return RUF.db.profile.unit[profileName].Debuffs.Icons.Position.AnchorTo
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Debuffs.Icons.Position.AnchorTo = value
					RUF:OptionsUpdateAuras(singleFrame,groupFrame,header,'Debuffs')
				end,
			},
			clickThrough = {
				name = L["Click Through"],
				type = 'toggle',
				order = 8,
				get = function(info)
					return RUF.db.profile.unit[profileName].Debuffs.Icons.ClickThrough
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Debuffs.Icons.ClickThrough = value
					RUF:OptionsUpdateAuras(singleFrame,groupFrame,header,'Debuffs')
				end,
			},
			filterHeader = {
				name = L["Filtering"],
				type = 'header',
				order = 10.5,
			},
			filterCasterByPlayer = {
				name = L["Show Player"],
				type = 'toggle',
				desc = L["Show debuffs cast by %s on this unit."]:format(L["Player"]),
				order = 15,
				get = function(info)
					return RUF.db.profile.unit[profileName].Debuffs.Icons.Filter.Caster.Player
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Debuffs.Icons.Filter.Caster.Player = value
					RUF:OptionsUpdateAuras(singleFrame,groupFrame,header,'Debuffs')
				end,
			},
			filterCasterByCurrentUnit = {
				name = L["Show %s"]:format(L[profileName]),
				type = 'toggle',
				desc = L["Show debuffs cast by %s on this unit."]:format(L[profileName]),
				hidden = profileName == 'player',
				order = 16,
				get = function(info)
					return RUF.db.profile.unit[profileName].Debuffs.Icons.Filter.Caster.Unit
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Debuffs.Icons.Filter.Caster.Unit = value
					RUF:OptionsUpdateAuras(singleFrame,groupFrame,header,'Debuffs')
				end,
			},
			filterCasterByGroupUnits = {
				name = L["Show Group Members"],
				type = 'toggle',
				desc = L["Show debuffs cast by %s on this unit."]:format(L["group members"]),
				order = 16,
				get = function(info)
					return RUF.db.profile.unit[profileName].Debuffs.Icons.Filter.Caster.Group
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Debuffs.Icons.Filter.Caster.Group = value
					RUF:OptionsUpdateAuras(singleFrame,groupFrame,header,'Debuffs')
				end,
			},
			filterCasterByOtherUnits = {
				name = L["Show Others"],
				type = 'toggle',
				desc = L["Show debuffs cast by %s on this unit."]:format(L["others"]),
				order = 16,
				get = function(info)
					return RUF.db.profile.unit[profileName].Debuffs.Icons.Filter.Caster.Other
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Debuffs.Icons.Filter.Caster.Other = value
					RUF:OptionsUpdateAuras(singleFrame,groupFrame,header,'Debuffs')
				end,
			},
			filterSpacer = {
				name = ' ',
				type = 'description',
				order = 17,
				width = 'full',
			},
			minDuration = {
				name = L["Minimum Duration"],
				type = 'range',
				order = 20,
				min = 0,
				max = 3600,
				softMin = 0,
				softMax = 360,
				step = 0.5,
				bigStep = 1,
				get = function(info)
					return RUF.db.profile.unit[profileName].Debuffs.Icons.Filter.Time.Min
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Debuffs.Icons.Filter.Time.Min = value
					RUF:OptionsUpdateAuras(singleFrame,groupFrame,header,'Debuffs')
				end,
			},
			maxDuration = {
				name = L["Maximum Duration"],
				type = 'range',
				order = 21,
				min = 0,
				max = 86400,
				softMin = 0,
				softMax = 3600,
				step = 0.5,
				bigStep = 5,
				get = function(info)
					return RUF.db.profile.unit[profileName].Debuffs.Icons.Filter.Time.Max
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Debuffs.Icons.Filter.Time.Max = value
					RUF:OptionsUpdateAuras(singleFrame,groupFrame,header,'Debuffs')
				end,
			},
			toggleDurationLimit = {
				name = L["Show Unlimited Duration"],
				type = 'toggle',
				order = 22,
				get = function(info)
					return RUF.db.profile.unit[profileName].Debuffs.Icons.Filter.Time.Unlimited
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Debuffs.Icons.Filter.Time.Unlimited = value
					RUF:OptionsUpdateAuras(singleFrame,groupFrame,header,'Debuffs')
				end,
			},
			filterDispellable = {
				name = L["Show Only Dispellable"],
				type = 'toggle',
				desc = L["Show only auras you can dispel"],
				order = 23,
				get = function(info)
					return RUF.db.profile.unit[profileName].Debuffs.Icons.Filter.Dispellable
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Debuffs.Icons.Filter.Dispellable = value
					RUF:OptionsUpdateAuras(singleFrame,groupFrame,header,'Debuffs')
				end,
			},
			maxAuras = {
				name = L["Max Auras"],
				type = 'range',
				order = 24,
				min = 1,
				max = 64,
				softMin = 1,
				softMax = 32,
				step = 1,
				bigStep = 1,
				get = function(info)
					return RUF.db.profile.unit[profileName].Debuffs.Icons.Max
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Debuffs.Icons.Max = value
					RUF:OptionsUpdateAuras(singleFrame,groupFrame,header,'Debuffs')
				end,
			},
		},
	}

	return debuffOptions
end

local function CastBarSettings(singleFrame, groupFrame, header)
	local ord, referenceUnit, profileName
	singleFrame, groupFrame, header, ord, referenceUnit, profileName = ProfileData(singleFrame, groupFrame, header)

	local copyList = CopyList(singleFrame, groupFrame, header, 'Cast')

	local castBarOptions = {
		name = L["Cast Bar"],
		type = 'group',
		order = 15,
		childGroups = 'tab',
		hidden = function()
			if profileName == 'player' or profileName == 'target' then
				return false
			elseif profileName == 'focus' then
				return false
			else
				return true
			end
		end,
		args = {
			copyUnit = {
				name = '|cff00B2FA' .. L["Copy Settings from:"] .. '|r',
				type = 'select',
				desc = L["Copy and replace settings from the selected unit to this unit."],
				order = 0,
				values = copyList,
				confirm = function() return L["Are you sure you want to replace these settings? You cannot undo this change."] end,
				set = function(info, value)
					local target = {}
					RUF:copyTable(RUF.db.profile.unit[string.lower(value)].Frame.Bars.Cast, target)
					RUF.db.profile.unit[profileName].Frame.Bars.Cast = nil
					RUF.db.profile.unit[profileName].Frame.Bars.Cast = target
					RUF:UpdateAllUnitSettings()
					RUF:UpdateOptions()
				end,
			},
			enabled = {
				name = function()
					if RUF.db.profile.unit[profileName].Frame.Bars.Cast.Enabled == true then
						return '|cFF00FF00'..L["Enabled"]..'|r'
					else
						return '|cFFFF0000'..L["Enabled"]..'|r'
					end
				end,
				type = 'toggle',
				order = 0.01,
				get = function(info)
					return RUF.db.profile.unit[profileName].Frame.Bars.Cast.Enabled
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Frame.Bars.Cast.Enabled = value
					RUF:OptionsUpdateCastbars()
				end,
			},
			enabledSpacer = {
				name = ' ',
				type = 'description',
				order = 0.05,
				width = 'full',
			},
			fillStyle = {
				name = L["Fill Type"],
				type = 'select',
				order = 1.01,
				values = {['STANDARD'] = L["Standard"], ['REVERSE'] = L["Reverse"], ['CENTER'] = L["Center"]},
				get = function(info)
					return RUF.db.profile.unit[profileName].Frame.Bars.Cast.Fill
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Frame.Bars.Cast.Fill = value
					RUF:OptionsUpdateCastbars()
				end,
			},
			width = {
				name = L["Width"],
				type = 'range',
				order = 1.03,
				min = 50,
				max = 750,
				softMin = 100,
				softMax = 400,
				step = 1,
				bigStep = 10,
				get = function(info)
					return RUF.db.profile.unit[profileName].Frame.Bars.Cast.Width
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Frame.Bars.Cast.Width = value
					RUF:OptionsUpdateCastbars()
				end,
			},
			height = {
				name = L["Height"],
				type = 'range',
				order = 1.04,
				min = 2,
				max = 100,
				softMin = 6,
				softMax = 50,
				step = 1,
				bigStep = 5,
				get = function(info)
					return RUF.db.profile.unit[profileName].Frame.Bars.Cast.Height
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Frame.Bars.Cast.Height = value
					RUF:OptionsUpdateCastbars()
				end,
			},
			frameAnchor = {
				type = 'toggle',
				name = L["Anchor to Unit Frame"],
				desc = L["Attach to the unit frame or allow free placement."],
				order = 1.06,
				get = function(info)
					return RUF.db.profile.unit[profileName].Frame.Bars.Cast.Position.AnchorFrame
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Frame.Bars.Cast.Position.AnchorFrame = value
					RUF:OptionsUpdateCastbars()
				end,
			},
			frameHorizontal = {
				type = 'range',
				name = L["X Offset"],
				desc = L["Horizontal Offset from the Frame Anchor."],
				order = 1.07,
				min = -5000,
				max = 5000,
				softMin = -1000,
				softMax = 1000,
				step = 0.5,
				bigStep = 1,
				get = function(info)
					return RUF.db.profile.unit[profileName].Frame.Bars.Cast.Position.x
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Frame.Bars.Cast.Position.x = value
					RUF:OptionsUpdateCastbars()
				end,
			},
			frameVertical = {
				type = 'range',
				name = L["Y Offset"],
				desc = L["Vertical Offset from the Frame Anchor."],
				order = 1.08,
				min = -5000,
				max = 5000,
				softMin = -1000,
				softMax = 1000,
				step = 0.5,
				bigStep = 1,
				get = function(info)
					return RUF.db.profile.unit[profileName].Frame.Bars.Cast.Position.y
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Frame.Bars.Cast.Position.y = value
					RUF:OptionsUpdateCastbars()
				end,
			},
			frameAnchorPoint = {
				type = 'select',
				name = L["Anchor From"],
				desc = L["Location area of the Unitframe to anchor from."],
				order = 1.09,
				values = anchorPoints,
				get = function(info)
					return RUF.db.profile.unit[profileName].Frame.Bars.Cast.Position.AnchorFrom
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Frame.Bars.Cast.Position.AnchorFrom = value
					RUF:OptionsUpdateCastbars()
				end,
			},
			frameAnchorTo = {
				type = 'select',
				name = L["Anchor To"],
				desc = L["Area on the anchor frame to anchor the unitframe to."],
				order = 1.09,
				values = anchorPoints,
				get = function(info)
					return RUF.db.profile.unit[profileName].Frame.Bars.Cast.Position.AnchorTo
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Frame.Bars.Cast.Position.AnchorTo = value
					RUF:OptionsUpdateCastbars()
				end,
			},
			text = {
				name = L["Texts"],
				type = 'group',
				order = 100,
				childGroups = 'tab',
				args = {
					timeText = {
						name = L["Time"],
						type = 'group',
						order = 0,
						args = {
							enabled = {
								name = function()
									if RUF.db.profile.unit[profileName].Frame.Bars.Cast.Time.Enabled == true then
										return '|cFF00FF00'..L["Enabled"]..'|r'
									else
										return '|cFFFF0000'..L["Enabled"]..'|r'
									end
								end,
								type = 'toggle',
								order = 0.0,
								get = function(info)
									return RUF.db.profile.unit[profileName].Frame.Bars.Cast.Time.Enabled
								end,
								set = function(info, value)
									RUF.db.profile.unit[profileName].Frame.Bars.Cast.Time.Enabled = value
									RUF:OptionsUpdateAllBars()
								end,
							},
							enabledSpacer = {
								name = '',
								type = 'description',
								order = 1,
								width = 'full',
							},
							style = {
								name = L["Display Style"],
								type = 'select',
								order = 2,
								values = {
									[1] = L["Duration"],
									[2] = L["Remaining"],
									[3] = ("%s/%s"):format(L["Duration"],L["Max"]),
								},
								get = function(info)
									return RUF.db.profile.unit[profileName].Frame.Bars.Cast.Time.Style
								end,
								set = function(info, value)
									RUF.db.profile.unit[profileName].Frame.Bars.Cast.Time.Style = value
									RUF:OptionsUpdateAllBars()
								end,
							},
							font = {
								name = L["Font"],
								type = 'select',
								order = 10,
								values = LSM:HashTable('font'),
								dialogControl = 'LSM30_Font',
								get = function(info)
									return RUF.db.profile.unit[profileName].Frame.Bars.Cast.Time.Font
								end,
								set = function(info, value)
									RUF.db.profile.unit[profileName].Frame.Bars.Cast.Time.Font = value
									RUF:OptionsUpdateAllBars()
								end,
							},
							fontSize = {
								name = L["Font Size"],
								type = 'range',
								order = 10,
								min = 4,
								max = 256,
								softMin = 8,
								softMax = 48,
								step = 1,
								bigStep = 1,
								get = function(info)
									return RUF.db.profile.unit[profileName].Frame.Bars.Cast.Time.Size
								end,
								set = function(info, value)
									RUF.db.profile.unit[profileName].Frame.Bars.Cast.Time.Size = value
									RUF:OptionsUpdateAllBars()
								end,
							},
							fontOutline = {
								name = L["Outline"],
								type = 'select',
								order = 10,
								values = {
									[''] = L["None"],
									['OUTLINE'] = L["Outline"],
									['THICKOUTLINE'] = L["Thick Outline"],
									['MONOCHROME'] = L["Monochrome"],
									['MONOCHROME,OUTLINE'] = L["Monochrome Outline"],
									['MONOCHROME,THICKOUTLINE'] = L["Monochrome Thick Outline"],
								},
								get = function(info)
									return RUF.db.profile.unit[profileName].Frame.Bars.Cast.Time.Outline
								end,
								set = function(info, value)
									RUF.db.profile.unit[profileName].Frame.Bars.Cast.Time.Outline = value
									RUF:OptionsUpdateAllBars()
								end,
							},
							fontShadow = {
								name = L["Shadow"],
								type = 'toggle',
								desc = L["Enable Text Shadow"],
								order = 10,
								get = function(info)
									if RUF.db.profile.unit[profileName].Frame.Bars.Cast.Time.Shadow == 1 then
										return true
									else
										return false
									end
								end,
								set = function(info, value)
									if value == true then
										RUF.db.profile.unit[profileName].Frame.Bars.Cast.Time.Shadow = 1
									else
										RUF.db.profile.unit[profileName].Frame.Bars.Cast.Time.Shadow = 0
									end
									RUF:OptionsUpdateAllBars()
								end,
							},
						},
					},
					castText = {
						name = L["Spell Name"],
						type = 'group',
						order = 0,
						args = {
							enabled = {
								name = function()
									if RUF.db.profile.unit[profileName].Frame.Bars.Cast.Text.Enabled == true then
										return '|cFF00FF00'..L["Enabled"]..'|r'
									else
										return '|cFFFF0000'..L["Enabled"]..'|r'
									end
								end,
								type = 'toggle',
								order = 0.0,
								get = function(info)
									return RUF.db.profile.unit[profileName].Frame.Bars.Cast.Text.Enabled
								end,
								set = function(info, value)
									RUF.db.profile.unit[profileName].Frame.Bars.Cast.Text.Enabled = value
									RUF:OptionsUpdateAllBars()
								end,
							},
							enabledSpacer = {
								name = '',
								type = 'description',
								order = 1,
								width = 'full',
							},
							font = {
								name = L["Font"],
								type = 'select',
								order = 10,
								values = LSM:HashTable('font'),
								dialogControl = 'LSM30_Font',
								get = function(info)
									return RUF.db.profile.unit[profileName].Frame.Bars.Cast.Text.Font
								end,
								set = function(info, value)
									RUF.db.profile.unit[profileName].Frame.Bars.Cast.Text.Font = value
									RUF:OptionsUpdateAllBars()
								end,
							},
							fontSize = {
								name = L["Font Size"],
								type = 'range',
								order = 10,
								min = 4,
								max = 256,
								softMin = 8,
								softMax = 48,
								step = 1,
								bigStep = 1,
								get = function(info)
									return RUF.db.profile.unit[profileName].Frame.Bars.Cast.Text.Size
								end,
								set = function(info, value)
									RUF.db.profile.unit[profileName].Frame.Bars.Cast.Text.Size = value
									RUF:OptionsUpdateAllBars()
								end,
							},
							fontOutline = {
								name = L["Outline"],
								type = 'select',
								order = 10,
								values = {
									[''] = L["None"],
									['OUTLINE'] = L["Outline"],
									['THICKOUTLINE'] = L["Thick Outline"],
									['MONOCHROME'] = L["Monochrome"],
									['MONOCHROME,OUTLINE'] = L["Monochrome Outline"],
									['MONOCHROME,THICKOUTLINE'] = L["Monochrome Thick Outline"],
								},
								get = function(info)
									return RUF.db.profile.unit[profileName].Frame.Bars.Cast.Text.Outline
								end,
								set = function(info, value)
									RUF.db.profile.unit[profileName].Frame.Bars.Cast.Text.Outline = value
									RUF:OptionsUpdateAllBars()
								end,
							},
							fontShadow = {
								name = L["Shadow"],
								type = 'toggle',
								desc = L["Enable Text Shadow"],
								order = 10,
								get = function(info)
									if RUF.db.profile.unit[profileName].Frame.Bars.Cast.Text.Shadow == 1 then
										return true
									else
										return false
									end
								end,
								set = function(info, value)
									if value == true then
										RUF.db.profile.unit[profileName].Frame.Bars.Cast.Text.Shadow = 1
									else
										RUF.db.profile.unit[profileName].Frame.Bars.Cast.Text.Shadow = 0
									end
									RUF:OptionsUpdateAllBars()
								end,
							},
						},
					},
				},
			},
		},
	}

	return castBarOptions
end

local function PortraitSettings(singleFrame, groupFrame, header)
	local ord, referenceUnit, profileName
	singleFrame, groupFrame, header, ord, referenceUnit, profileName = ProfileData(singleFrame, groupFrame, header)

	local copyList = CopyList(singleFrame, groupFrame, header)

	local portraitOptions = {
		name = L["Portrait"],
		type = 'group',
		order = 15,
		args = {
			copyUnit = {
				name = '|cff00B2FA' .. L["Copy Settings from:"] .. '|r',
				type = 'select',
				desc = L["Copy and replace settings from the selected unit to this unit."],
				order = 0,
				values = copyList,
				confirm = function() return L["Are you sure you want to replace these settings? You cannot undo this change."] end,
				set = function(info, value)
					local target = {}
					RUF:copyTable(RUF.db.profile.unit[string.lower(value)].Frame.Portrait, target)
					RUF.db.profile.unit[profileName].Frame.Portrait = nil
					RUF.db.profile.unit[profileName].Frame.Portrait = target
					RUF:UpdateAllUnitSettings()
					RUF:UpdateOptions()
				end,
			},
			enabled = {
				name = function()
					if RUF.db.profile.unit[profileName].Frame.Portrait.Enabled == true then
						return '|cFF00FF00'..L["Enabled"]..'|r'
					else
						return '|cFFFF0000'..L["Enabled"]..'|r'
					end
				end,
				type = 'toggle',
				order = 0.01,
				get = function(info)
					return RUF.db.profile.unit[profileName].Frame.Portrait.Enabled
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Frame.Portrait.Enabled = value
					RUF:OptionsUpdatePortraits(singleFrame, groupFrame, header)
				end,
			},
			enabledSpacer = {
				name = ' ',
				type = 'description',
				order = 0.05,
				width = 'full',
			},
			displayStyle = {
				name = L["Display Style"],
				type = 'select',
				order = 0.1,
				values = {
					[1] = L["Unitframe Overlay"],
					[2] = L["Free floating"],
					[3] = L["Attached"],
				},
				disabled = function()
					if not RUF.db.profile.unit[profileName].Frame.Portrait.Enabled == true then return true end
					return false
				end,
				get = function(info)
					return RUF.db.profile.unit[profileName].Frame.Portrait.Style
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Frame.Portrait.Style = value
					RUF:OptionsUpdatePortraits(singleFrame, groupFrame, header)
				end,
			},
			anchorToHealth = {
				name = L["Health Cutaway"],
				desc = L["Makes the portrait disappear with the health bar as it lowers."],
				type = 'toggle',
				order = 0.2,
				disabled = function()
					if not RUF.db.profile.unit[profileName].Frame.Portrait.Enabled == true then return true end
					if RUF.db.profile.unit[profileName].Frame.Portrait.Style ~= 1 then return true end
					return false
				end,
				get = function(info)
					return RUF.db.profile.unit[profileName].Frame.Portrait.Cutaway
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Frame.Portrait.Cutaway = value
					RUF:OptionsUpdatePortraits(singleFrame, groupFrame, header)
				end,
			},
			alpha = {
				name = L["Alpha"],
				type = 'range',
				isPercent = true,
				order = 1.13,
				min = 0,
				max = 1,
				softMin = 0,
				softMax = 1,
				step = 0.01,
				bigStep = 0.05,
				disabled = function()
					if not RUF.db.profile.unit[profileName].Frame.Portrait.Enabled == true then return true end
					if RUF.db.profile.unit[profileName].Frame.Portrait.Style ~= 1 then return true end
					return false
				end,
				get = function(info)
					return RUF.db.profile.unit[profileName].Frame.Portrait.Alpha
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Frame.Portrait.Alpha = value
					RUF:OptionsUpdatePortraits(singleFrame, groupFrame, header)
				end,
			},
			freeFloatWarn = {
				name = '|cFFFF0000' .. L["Portraits are not clickable or interactable in free floating mode."] .. '|r',
				type = 'description',
				order = 4.99,
				width = 'full',
				hidden = function()
					if RUF.db.profile.unit[profileName].Frame.Portrait.Style ~= 2 then return true end
					return false
				end,
			},
			modelAppearance = {
				name = L["Model Appearance"],
				order = 5,
				type = 'group',
				inline = true,
				args = {
					rotation = {
						name = L["Rotation"],
						type = 'range',
						order = 5.11,
						min = 0,
						max = 360,
						step = 1,
						get = function(info)
							return RUF.db.profile.unit[profileName].Frame.Portrait.Model.Rotation
						end,
						set = function(info, value)
							RUF.db.profile.unit[profileName].Frame.Portrait.Model.Rotation = value
							RUF:OptionsUpdatePortraits(singleFrame, groupFrame, header)
						end,
					},
					portraitZoom = {
						name = L["Portrait Zoom"],
						type = 'range',
						order = 5.12,
						min = 0.01,
						max = 5,
						step = 0.01,
						get = function(info)
							return RUF.db.profile.unit[profileName].Frame.Portrait.Model.PortraitZoom
						end,
						set = function(info, value)
							RUF.db.profile.unit[profileName].Frame.Portrait.Model.PortraitZoom = value
							RUF:OptionsUpdatePortraits(singleFrame, groupFrame, header)
						end,
					},
					cameraDistance = {
						name = L["Camera Distance"],
						type = 'range',
						order = 5.13,
						min = 0.01,
						max = 5,
						step = 0.01,
						get = function(info)
							return RUF.db.profile.unit[profileName].Frame.Portrait.Model.CameraDistance
						end,
						set = function(info, value)
							RUF.db.profile.unit[profileName].Frame.Portrait.Model.CameraDistance = value
							RUF:OptionsUpdatePortraits(singleFrame, groupFrame, header)
						end,
					},
					offsetX = {
						name = L["X Offset"],
						type = 'range',
						order = 5.31,
						min = -10,
						max = 10,
						step = 0.01,
						get = function(info)
							return RUF.db.profile.unit[profileName].Frame.Portrait.Model.x
						end,
						set = function(info, value)
							RUF.db.profile.unit[profileName].Frame.Portrait.Model.x = value
							RUF:OptionsUpdatePortraits(singleFrame, groupFrame, header)
						end,
					},
					offsetY = {
						name = L["Y Offset"],
						type = 'range',
						order = 5.32,
						min = -10,
						max = 10,
						step = 0.01,
						get = function(info)
							return RUF.db.profile.unit[profileName].Frame.Portrait.Model.y
						end,
						set = function(info, value)
							RUF.db.profile.unit[profileName].Frame.Portrait.Model.y = value
							RUF:OptionsUpdatePortraits(singleFrame, groupFrame, header)
						end,
					},
					offsetZ = {
						name = L["Z Offset"],
						type = 'range',
						order = 5.33,
						min = -10,
						max = 10,
						step = 0.01,
						get = function(info)
							return RUF.db.profile.unit[profileName].Frame.Portrait.Model.z
						end,
						set = function(info, value)
							RUF.db.profile.unit[profileName].Frame.Portrait.Model.z = value
							RUF:OptionsUpdatePortraits(singleFrame, groupFrame, header)
						end,
					},
					pauseAnimation = {
						name = L["Freeze Animation"],
						order = 5.4,
						type = 'toggle',
						get = function(info)
							return RUF.db.profile.unit[profileName].Frame.Portrait.Model.Animation.Paused
						end,
						set = function(info, value)
							RUF.db.profile.unit[profileName].Frame.Portrait.Model.Animation.Paused = value
							RUF:OptionsUpdatePortraits(singleFrame, groupFrame, header)
						end,
					},
					desaturate = {
						name = L["Desaturate"],
						order = 5.4,
						type = 'toggle',
						get = function(info)
							return RUF.db.profile.unit[profileName].Frame.Portrait.Model.Desaturate
						end,
						set = function(info, value)
							RUF.db.profile.unit[profileName].Frame.Portrait.Model.Desaturate = value
							RUF:OptionsUpdatePortraits(singleFrame, groupFrame, header)
						end,
					},
				},
			},
			positioning = {
				name = L["Position"],
				type = 'group',
				order = 10,
				inline = true,
				hidden = function()
					if not RUF.db.profile.unit[profileName].Frame.Portrait.Enabled == true then return true end
					if RUF.db.profile.unit[profileName].Frame.Portrait.Style ~= 2 then return true end
					return false
				end,
				args = {
					width = {
						name = L["Width"],
						type = 'range',
						order = 0.2,
						min = 4,
						max = 600,
						softMin = 20,
						softMax = 300,
						step = 1,
						bigStep = 1,
						get = function(info)
							return RUF.db.profile.unit[profileName].Frame.Portrait.Width
						end,
						set = function(info, value)
							RUF.db.profile.unit[profileName].Frame.Portrait.Width = value
							RUF:OptionsUpdatePortraits(singleFrame, groupFrame, header)
						end,
					},
					height = {
						name = L["Height"],
						type = 'range',
						order = 0.21,
						min = 4,
						max = 600,
						softMin = 20,
						softMax = 150,
						step = 1,
						bigStep = 1,
						get = function(info)
							return RUF.db.profile.unit[profileName].Frame.Portrait.Height
						end,
						set = function(info, value)
							RUF.db.profile.unit[profileName].Frame.Portrait.Height = value
							RUF:OptionsUpdatePortraits(singleFrame, groupFrame, header)
						end,
					},
					anchorPoint = {
						type = 'select',
						name = L["Anchor From"],
						order = 1.1,
						values = anchorPoints,
						get = function(info)
							return RUF.db.profile.unit[profileName].Frame.Portrait.Position.AnchorFrom
						end,
						set = function(info, value)
							RUF.db.profile.unit[profileName].Frame.Portrait.Position.AnchorFrom = value
							RUF:OptionsUpdatePortraits(singleFrame, groupFrame, header)
						end,
					},
					anchorTo = {
						type = 'select',
						name = L["Anchor To"],
						order = 1.11,
						values = anchorPoints,
						get = function(info)
							return RUF.db.profile.unit[profileName].Frame.Portrait.Position.AnchorTo
						end,
						set = function(info, value)
							RUF.db.profile.unit[profileName].Frame.Portrait.Position.AnchorTo = value
							RUF:OptionsUpdatePortraits(singleFrame, groupFrame, header)
						end,
					},
					horizontalOffset = {
						type = 'range',
						name = L["X Offset"],
						desc = L["Horizontal Offset from the Frame Anchor."],
						order = 1.12,
						min = -5000,
						max = 5000,
						softMin = -1000,
						softMax = 1000,
						step = 0.5,
						bigStep = 1,
						get = function(info)
							return RUF.db.profile.unit[profileName].Frame.Portrait.Position.x
						end,
						set = function(info, value)
							RUF.db.profile.unit[profileName].Frame.Portrait.Position.x = value
							RUF:OptionsUpdatePortraits(singleFrame, groupFrame, header)
						end,
					},
					verticalOffset = {
						type = 'range',
						name = L["Y Offset"],
						desc = L["Vertical Offset from the Frame Anchor."],
						order = 1.13,
						min = -5000,
						max = 5000,
						softMin = -1000,
						softMax = 1000,
						step = 0.5,
						bigStep = 1,
						get = function(info)
							return RUF.db.profile.unit[profileName].Frame.Portrait.Position.y
						end,
						set = function(info, value)
							RUF.db.profile.unit[profileName].Frame.Portrait.Position.y = value
							RUF:OptionsUpdatePortraits(singleFrame, groupFrame, header)
						end,
					},
				},
			},
			positioningAttached = {
				name = L["Position"],
				type = 'group',
				order = 10,
				inline = true,
				hidden = function()
					if not RUF.db.profile.unit[profileName].Frame.Portrait.Enabled == true then return true end
					if RUF.db.profile.unit[profileName].Frame.Portrait.Style ~= 3 then return true end
					return false
				end,
				args = {
					width = {
						name = L["Width"],
						type = 'range',
						order = 0.2,
						min = 4,
						max = 600,
						softMin = 20,
						softMax = 300,
						step = 1,
						bigStep = 1,
						get = function(info)
							return RUF.db.profile.unit[profileName].Frame.Portrait.Width
						end,
						set = function(info, value)
							RUF.db.profile.unit[profileName].Frame.Portrait.Width = value
							RUF:OptionsUpdatePortraits(singleFrame, groupFrame, header)
						end,
					},
					anchorTo = {
						type = 'select',
						name = L["Anchor To"],
						order = 1.11,
						values = {
							--['BOTTOM'] = L["Bottom"],
							['LEFT'] = L["Left"],
							['RIGHT'] = L["Right"],
							--['TOP'] = L["Top"],
						},
						get = function(info)
							return RUF.db.profile.unit[profileName].Frame.Portrait.Position.AttachedStyleAnchor or 'LEFT'
						end,
						set = function(info, value)
							RUF.db.profile.unit[profileName].Frame.Portrait.Position.AttachedStyleAnchor = value
							RUF:OptionsUpdatePortraits(singleFrame, groupFrame, header)
						end,
					},
				},
			},
			border = {
				name = L["Border"],
				type = 'group',
				order = 11,
				inline = true,
				hidden = function()
					if not RUF.db.profile.unit[profileName].Frame.Portrait.Enabled == true then return true end
					if RUF.db.profile.unit[profileName].Frame.Portrait.Style == 1 then return true end
					return false
				end,
				args = {
					texture = {
						name = L["Texture"],
						type = 'select',
						order = 0.02,
						values = LSM:HashTable('border'),
						dialogControl = 'LSM30_Border',
						get = function(info)
							return RUF.db.profile.unit[profileName].Frame.Portrait.Border.Style.edgeFile
						end,
						set = function(info, value)
							RUF.db.profile.unit[profileName].Frame.Portrait.Border.Style.edgeFile = value
							RUF:OptionsUpdatePortraits(singleFrame, groupFrame, header)
						end,
					},
					size = {
						name = L["Size"],
						type = 'range',
						order = 0.03,
						min = -100,
						max = 100,
						softMin = -20,
						softMax = 20,
						step = 0.01,
						bigStep = 0.05,
						get = function(info)
							return RUF.db.profile.unit[profileName].Frame.Portrait.Border.Style.edgeSize
						end,
						set = function(info, value)
							RUF.db.profile.unit[profileName].Frame.Portrait.Border.Style.edgeSize = value
							RUF:OptionsUpdatePortraits(singleFrame, groupFrame, header)
						end,
					},
					offset = {
						name = L["Inset from frame edge"],
						type = 'range',
						order = 0.04,
						min = -100,
						max = 100,
						softMin = -30,
						softMax = 30,
						step = 1,
						bigStep = 1,
						get = function(info)
							return RUF.db.profile.unit[profileName].Frame.Portrait.Border.Offset
						end,
						set = function(info, value)
							RUF.db.profile.unit[profileName].Frame.Portrait.Border.Offset = value
							RUF:OptionsUpdatePortraits(singleFrame, groupFrame, header)
						end,
					},
						alpha = {
							name = L["Alpha"],
							type = 'range',
							isPercent = true,
							order = 0.05,
							min = 0,
							max = 1,
							softMin = 0,
							softMax = 1,
							step = 0.01,
							bigStep = 0.05,
							get = function(info)
								return RUF.db.profile.unit[profileName].Frame.Portrait.Border.Alpha
							end,
							set = function(info, value)
								RUF.db.profile.unit[profileName].Frame.Portrait.Border.Alpha = value
								RUF:OptionsUpdatePortraits(singleFrame, groupFrame, header)
							end,
						},
					color = {
						name = L["Color"],
						type = 'color',
						order = 0.06,
						get = function(info)
							return unpack(RUF.db.profile.unit[profileName].Frame.Portrait.Border.Color)
						end,
						set = function(info,r,g,b)
							RUF.db.profile.unit[profileName].Frame.Portrait.Border.Color = {r,g,b}
							RUF:OptionsUpdatePortraits(singleFrame, groupFrame, header)
						end,
					},
				},
			},
			background = {
				name = L["Background"],
				type = 'group',
				order = 12,
				inline = true,
				hidden = function()
					if not RUF.db.profile.unit[profileName].Frame.Portrait.Enabled == true then return true end
					if RUF.db.profile.unit[profileName].Frame.Portrait.Style == 1 then return true end
					return false
				end,
				args = {
					customColor = {
						name = L["Background Color"],
						type = 'color',
						order = 10.01,
						get = function(info)
							return unpack(RUF.db.profile.unit[profileName].Frame.Portrait.Background.Color)
						end,
						set = function(info,r,g,b)
							RUF.db.profile.unit[profileName].Frame.Portrait.Background.Color = {r,g,b}
							RUF:OptionsUpdatePortraits(singleFrame, groupFrame, header)
						end,
					},
					backgroundAlpha = {
						name = L["Alpha"],
						desc = L["Background Alpha"],
						type = 'range',
						isPercent = true,
						order = 10.04,
						min = 0,
						max = 1,
						softMin = 0,
						softMax = 1,
						step = 0.01,
						bigStep = 0.05,
						get = function(info)
							return RUF.db.profile.unit[profileName].Frame.Portrait.Background.Alpha
						end,
						set = function(info, value)
							RUF.db.profile.unit[profileName].Frame.Portrait.Background.Alpha = value
							RUF:OptionsUpdatePortraits(singleFrame, groupFrame, header)
						end,
					},
				},
			},
		},
	}

	return portraitOptions
end

function RUF_Options.GenerateUnits()
	wipe(tagList)
	wipe(localisedTags)
	wipe(tagInputs)
	frames = RUF.frameList.frames
	groupFrames = RUF.frameList.groupFrames
	headers = RUF.frameList.headers

	for k,v in pairs(RUF.db.profile.Appearance.Text) do
		if v ~= '' then
			table.insert(tagList,k)
			table.insert(localisedTags,L[k])
			tagInputs['[RUF:'..k..']'] = L[k]
		end
	end

	local Units = {
		name = L["Unit Options"],
		type = 'group',
		childGroups = 'tree',
		order = 2,
		args = {
		},
	}

	for i = 1,#frames do
		Units.args[frames[i]] = UnitGroup(frames[i])
		Units.args[frames[i]].args.frameSettings.args.barOptions = BarSettings(frames[i])
		Units.args[frames[i]].args.textOptions = TextSettings(frames[i])
		Units.args[frames[i]].args.indicatorOptions = IndicatorSettings(frames[i])
		Units.args[frames[i]].args.buffOptions = BuffSettings(frames[i])
		Units.args[frames[i]].args.debuffOptions = DebuffSettings(frames[i])
		Units.args[frames[i]].args.castBarOptions = CastBarSettings(frames[i])
		Units.args[frames[i]].args.portraitOptions = PortraitSettings(frames[i])
	end
	for i = 1,#groupFrames do
		Units.args[groupFrames[i]] = UnitGroup(nil,groupFrames[i])
		Units.args[groupFrames[i]].args.frameSettings.args.barOptions = BarSettings(nil,groupFrames[i])
		Units.args[groupFrames[i]].args.textOptions = TextSettings(nil,groupFrames[i])
		Units.args[groupFrames[i]].args.indicatorOptions = IndicatorSettings(nil,groupFrames[i])
		Units.args[groupFrames[i]].args.buffOptions = BuffSettings(nil,groupFrames[i])
		Units.args[groupFrames[i]].args.debuffOptions = DebuffSettings(nil,groupFrames[i])
		Units.args[groupFrames[i]].args.castBarOptions = CastBarSettings(nil,groupFrames[i])
		Units.args[groupFrames[i]].args.portraitOptions = PortraitSettings(nil,groupFrames[i])
	end
	for i = 1,#headers do
		Units.args[headers[i]] = UnitGroup(nil,nil,headers[i])
		Units.args[headers[i]].args.frameSettings.args.barOptions = BarSettings(nil,nil,headers[i])
		Units.args[headers[i]].args.textOptions = TextSettings(nil,nil,headers[i])
		Units.args[headers[i]].args.indicatorOptions = IndicatorSettings(nil,nil,headers[i])
		Units.args[headers[i]].args.buffOptions = BuffSettings(nil,nil,headers[i])
		Units.args[headers[i]].args.debuffOptions = DebuffSettings(nil,nil,headers[i])
		Units.args[headers[i]].args.castBarOptions = CastBarSettings(nil,nil,headers[i])
		Units.args[headers[i]].args.portraitOptions = PortraitSettings(nil,nil,headers[i])
	end

	return Units

end