assert(RUF, "RUF not found!")
local RUF = RUF
local L = LibStub('AceLocale-3.0'):GetLocale('RUF')
local RUF_Options = RUF:GetModule('Options')
local LSM = LibStub('LibSharedMedia-3.0')
local _, ns = ...
local oUF = ns.oUF
local uClass = select(2, UnitClass("player"))

function RUF_Options.Bars()
	local LocalisedBar = {
		[1] = L["Health"],
		[2] = L["Power"],
		[3] = L["Class"],
		[4] = L["Absorb"],
		[5] = L["Cast Bar"],
	}

	local Powers = {["DRUID"] = _G['COMBO_POINTS'] or COMBO_POINTS, ["ROGUE"] = _G['COMBO_POINTS'] or COMBO_POINTS,}
	local PowerDesc = {}

	if Powers[uClass] then
		LocalisedBar[3] = Powers[uClass]
	end


	local Bar = {
		[1] = 'Health',
		[2] = 'Power',
		[3] = 'Class',
		[4] = 'Absorb',
		[5] = 'Cast',
	}
	local Bars = {
		name = L["Bars"],
		type = 'group',
		childGroups = 'tab',
		order = 1,
		args = {
		},
	}
	for i=1,5 do
		Bars.args[Bar[i]] = {
			name = LocalisedBar[i],
			type = 'group',
			order = i,
			hidden = function()
				if RUF.Client ~= 1 then
					if i == 4 then return true end
				end
			end,
			desc = function()
				if i == 3 then
					if PowerDesc[uClass] then
						return L["%s, %s, and class specific resources for other classes."]:format(PowerDesc[uClass][1],PowerDesc[uClass][2])
					elseif Powers[uClass] then
						return L["%s and class specific resources for other classes."]:format(Powers[uClass])
					end
				end
			end,
			args = {
				foregroundStyle = {
					name = L["Foreground Style"],
					type = 'group',
					order = 0,
					inline = true,
					childGroups = 'tab',
					args = {
						baseColor = {
							name = L["Base Color"],
							desc = L["Color used if none of the other options are checked."],
							type = 'color',
							order = 0.0,
							get = function(info)
								return unpack(RUF.db.profile.Appearance.Bars[Bar[i]].Color.BaseColor)
							end,
							set = function(info,r,g,b)
								RUF.db.profile.Appearance.Bars[Bar[i]].Color.BaseColor = {r,g,b}
								RUF:OptionsUpdateAllBars()
							end,
						},
						barTexture = {
							name = L["Texture"],
							type = 'select',
							order = 0.01,
							values = LSM:HashTable('statusbar'),
							dialogControl = 'LSM30_Statusbar',
							get = function(info)
								return RUF.db.profile.Appearance.Bars[Bar[i]].Texture
							end,
							set = function(info, value)
								RUF.db.profile.Appearance.Bars[Bar[i]].Texture = value
								RUF:OptionsUpdateAllBars()
							end,
						},
						barType = {
							name = L["Type"],
							type = 'select',
							order = 0.02,
							hidden = function() return i ~= 4 end,
							disabled = true,
							values = {
								[1] = L["Health Bar Overlay"],
								[2] = L["Separate Bar"],
							},
							get = function(info)
								return RUF.db.profile.Appearance.Bars[Bar[i]].Type
							end,
							set = function(info, value)
								RUF.db.profile.Appearance.Bars[Bar[i]].Type = value
								RUF:OptionsUpdateAllBars()
							end,
						},
						overlayAlpha = {
							name = L["Alpha"],
							desc = L["Overlay Alpha"],
							type = 'range',
							isPercent = true,
							order = 0.03,
							hidden = i ~= 4,
							min = 0,
							max = 1,
							softMin = 0,
							softMax = 1,
							step = 0.01,
							bigStep = 0.05,
							get = function(info)
								return RUF.db.profile.Appearance.Bars[Bar[i]].Color.Alpha
							end,
							set = function(info, value)
								RUF.db.profile.Appearance.Bars[Bar[i]].Color.Alpha = value
								RUF:OptionsUpdateAllBars()
							end,
						},
						brightnessMult = {
							name = L["Brightness Multiplier"],
							desc = L["Reduce Bar color's brightness by this percentage."],
							type = 'range',
							order = 0.04,
							min = 0,
							max = 1,
							softMin = 0,
							softMax = 1,
							step = 0.01,
							bigStep = 0.05,
							get = function(info)
								return RUF.db.profile.Appearance.Bars[Bar[i]].Color.Multiplier
							end,
							set = function(info, value)
								RUF.db.profile.Appearance.Bars[Bar[i]].Color.Multiplier = value
								RUF:OptionsUpdateAllBars()
							end,
						},
						segmentMult = {
							name = L["Segment Multiplier"],
							desc = L["Reduce each segment's brightness by this percentage."],
							type = 'range',
							order = 0.05,
							hidden = function() return (i ~= 3) end,
							min = 0.0,
							max = 33,
							softMin = 0,
							softMax = 20,
							step = 0.01,
							bigStep = 0.05,
							get = function(info)
								return RUF.db.profile.Appearance.Bars[Bar[i]].Color.SegmentMultiplier
							end,
							set = function(info, value)
								RUF.db.profile.Appearance.Bars[Bar[i]].Color.SegmentMultiplier = value
								RUF:OptionsUpdateAllBars()
							end,
						},
						spacerTypeColor = {
							name = " ",
							type = 'description',
							order = 0.055,
							width = 'full',
						},
						descColorPriority = {
							name = L["The colour options below are listed in order of precedence left to right, with the first being the highest priority."],
							type = 'description',
							order = 0.06,
							width = 'full',
						},
						disconnected = {
							name = L["Color Disconnected"],
							desc = L["Colors the bar using the disconnected color if the unit is disconnected."],
							type = 'toggle',
							order = 0.09,
							hidden = function() return (i >= 3) end,
							get = function(info)
								return RUF.db.profile.Appearance.Bars[Bar[i]].Color.Disconnected
							end,
							set = function(info, value)
								RUF.db.profile.Appearance.Bars[Bar[i]].Color.Disconnected = value
								RUF:OptionsUpdateAllBars()
							end,
						},
						tapped = {
							name = L["Color Tapped"],
							desc = L["Colors the bar using the tapped color if the unit is tapped."],
							type = 'toggle',
							order = 0.09,
							hidden = function() return (i >= 3) end,
							get = function(info)
								return RUF.db.profile.Appearance.Bars[Bar[i]].Color.Tapped
							end,
							set = function(info, value)
								RUF.db.profile.Appearance.Bars[Bar[i]].Color.Tapped = value
								RUF:OptionsUpdateAllBars()
							end,
						},
						class = {
							name = L["Color Class"],
							desc = L["Color player units by class color."],
							type = 'toggle',
							order = 0.1,
							get = function(info)
								return RUF.db.profile.Appearance.Bars[Bar[i]].Color.Class
							end,
							set = function(info, value)
								RUF.db.profile.Appearance.Bars[Bar[i]].Color.Class = value
								RUF:OptionsUpdateAllBars()
							end,
						},
						reaction = {
							name = L["Color Reaction"],
							desc = L["Color unit by reaction toward the player."],
							type = 'toggle',
							hidden = function() return i == 3 end,
							order = 0.11,
							get = function(info)
								return RUF.db.profile.Appearance.Bars[Bar[i]].Color.Reaction
							end,
							set = function(info, value)
								RUF.db.profile.Appearance.Bars[Bar[i]].Color.Reaction = value
								RUF:OptionsUpdateAllBars()
							end,
						},
						power = {
							name = L["Color Power Type"],
							desc = L["Colors the bar using the power color."],
							type = 'toggle',
							hidden = function() return (i == 1 or i == 4) end,
							order = 0.12,
							get = function(info)
								return RUF.db.profile.Appearance.Bars[Bar[i]].Color.PowerType
							end,
							set = function(info, value)
								RUF.db.profile.Appearance.Bars[Bar[i]].Color.PowerType = value
								RUF:OptionsUpdateAllBars()
							end,
						},
						colorInterruptEnabled = {
							name = L["Color Not Interruptible"],
							desc = L["Enable to force the bar to a specific color if the cast cannot be interrupted."],
							type = 'toggle',
							hidden = function() return i ~= 5 end,
							order = 0.13,
							get = function(info)
								return RUF.db.profile.Appearance.Bars[Bar[i]].ColorInterrupt.Enabled
							end,
							set = function(info, value)
								RUF.db.profile.Appearance.Bars[Bar[i]].ColorInterrupt.Enabled = value
								RUF:OptionsUpdateAllBars()
							end,
						},
						colorInterrupt = {
							name = L["Not Interruptible Color"],
							type = 'color',
							order = 0.14,
							hidden = function()
								if i ~= 5 then
									return true
								elseif not RUF.db.profile.Appearance.Bars[Bar[i]].ColorInterrupt.Enabled then
									return true
								else
									return false
								end
							end,
							get = function(info)
								return unpack(RUF.db.profile.Appearance.Bars[Bar[i]].ColorInterrupt.Color)
							end,
							set = function(info,r,g,b)
								RUF.db.profile.Appearance.Bars[Bar[i]].ColorInterrupt.Color = {r,g,b}
								RUF:OptionsUpdateAllBars()
							end,
						},
						spacerPercentage = {
							name = " ",
							type = 'description',
							order = 1,
							width = 'full',
							hidden = function() return (i >= 3) end,
						},
						percentage = {
							name = L["Color Percentage"],
							desc = L["Color Bar by percentage colors."],
							type = 'toggle',
							order = 1.2,
							hidden = function() return (i >= 3) end,
							get = function(info)
								return RUF.db.profile.Appearance.Bars[Bar[i]].Color.Percentage
							end,
							set = function(info, value)
								RUF.db.profile.Appearance.Bars[Bar[i]].Color.Percentage = value
								RUF:OptionsUpdateAllBars()
							end,
						},
						percentMaxSpacer = {
							name = " ",
							type = 'description',
							order = 1.25,
							width = 'full',
							hidden = function() return (i >= 3) end,
						},
						percent100 = {
							name = L["100%"],
							desc = L["Color at 100%"],
							type = 'color',
							order = 1.3,
							disabled = function() return RUF.db.profile.Appearance.Bars[Bar[i]].Color.percentageMaxClass end,
							hidden = function() return not RUF.db.profile.Appearance.Bars[Bar[i]].Color.Percentage end,
							get = function(info)
								return RUF.db.profile.Appearance.Bars[Bar[i]].Color.PercentageGradient[7],RUF.db.profile.Appearance.Bars[Bar[i]].Color.PercentageGradient[8],RUF.db.profile.Appearance.Bars[Bar[i]].Color.PercentageGradient[9]
							end,
							set = function(info,r,g,b)
								RUF.db.profile.Appearance.Bars[Bar[i]].Color.PercentageGradient[7] = r
								RUF.db.profile.Appearance.Bars[Bar[i]].Color.PercentageGradient[8] = g
								RUF.db.profile.Appearance.Bars[Bar[i]].Color.PercentageGradient[9] = b
								RUF:OptionsUpdateAllBars()
							end,
						},
						percentageMaxClass = {
							name = L["Color 100% by Class"],
							desc = L["Colour bar by class color when at 100%."],
							type = 'toggle',
							order = 1.31,
							hidden = function() return not RUF.db.profile.Appearance.Bars[Bar[i]].Color.Percentage end,
							get = function(info)
								return RUF.db.profile.Appearance.Bars[Bar[i]].Color.percentageMaxClass
							end,
							set = function(info, value)
								RUF.db.profile.Appearance.Bars[Bar[i]].Color.percentageMaxClass = value
								RUF:OptionsUpdateAllBars()
							end,
						},
						percentageMaxPower = {
							name = L["Color 100% by Power Type"],
							desc = L["Colour bar by power color when at 100%."],
							type = 'toggle',
							order = 1.32,
							hidden = function()
								if i ~= 2 then return true end
								if RUF.db.profile.Appearance.Bars[Bar[i]].Color.Percentage == true then return false
								else return true
								end
							end,
							get = function(info)
								return RUF.db.profile.Appearance.Bars[Bar[i]].Color.percentageMaxPower
							end,
							set = function(info, value)
								RUF.db.profile.Appearance.Bars[Bar[i]].Color.percentageMaxPower = value
								RUF:OptionsUpdateAllBars()
							end,
						},
						percent50Spacer = {
							name = " ",
							type = 'description',
							order = 1.35,
							width = 'full',
							hidden = function() return not RUF.db.profile.Appearance.Bars[Bar[i]].Color.Percentage end,
						},
						percent50 = {
							name = L["50%"],
							desc = L["Color at 50%"],
							type = 'color',
							order = 1.4,
							disabled = function() return RUF.db.profile.Appearance.Bars[Bar[i]].Color.percentage50Class end,
							hidden = function() return not RUF.db.profile.Appearance.Bars[Bar[i]].Color.Percentage end,
							get = function(info)
								return RUF.db.profile.Appearance.Bars[Bar[i]].Color.PercentageGradient[4],RUF.db.profile.Appearance.Bars[Bar[i]].Color.PercentageGradient[5],RUF.db.profile.Appearance.Bars[Bar[i]].Color.PercentageGradient[6]
							end,
							set = function(info,r,g,b)
								RUF.db.profile.Appearance.Bars[Bar[i]].Color.PercentageGradient[4] = r
								RUF.db.profile.Appearance.Bars[Bar[i]].Color.PercentageGradient[5] = g
								RUF.db.profile.Appearance.Bars[Bar[i]].Color.PercentageGradient[6] = b
								RUF:OptionsUpdateAllBars()
							end,
						},
						percentage50Class = {
							name = L["Color 50% by Class"],
							desc = L["Colour bar by class color when at 50%."],
							type = 'toggle',
							order = 1.41,
							hidden = function() return not RUF.db.profile.Appearance.Bars[Bar[i]].Color.Percentage end,
							get = function(info)
								return RUF.db.profile.Appearance.Bars[Bar[i]].Color.percentage50Class
							end,
							set = function(info, value)
								RUF.db.profile.Appearance.Bars[Bar[i]].Color.percentage50Class = value
								RUF:OptionsUpdateAllBars()
							end,
						},
						percentage50Power = {
							name = L["Color 50% by Power Type"],
							desc = L["Colour bar by power color when at 50%."],
							type = 'toggle',
							order = 1.42,
							hidden = function()
								if i ~= 2 then return true end
								if RUF.db.profile.Appearance.Bars[Bar[i]].Color.Percentage == true then return false
								else return true
								end
							end,
							get = function(info)
								return RUF.db.profile.Appearance.Bars[Bar[i]].Color.percentage50Power
							end,
							set = function(info, value)
								RUF.db.profile.Appearance.Bars[Bar[i]].Color.percentage50Power = value
								RUF:OptionsUpdateAllBars()
							end,
						},
						percent0Spacer = {
							name = " ",
							type = 'description',
							order = 1.45,
							width = 'full',
							hidden = function() return not RUF.db.profile.Appearance.Bars[Bar[i]].Color.Percentage end,
						},
						percent0 = {
							name = L["0%"],
							desc = L["Color at 0%"],
							type = 'color',
							order = 1.5,
							disabled = function() return RUF.db.profile.Appearance.Bars[Bar[i]].Color.percentage0Class end,
							hidden = function() return not RUF.db.profile.Appearance.Bars[Bar[i]].Color.Percentage end,
							get = function(info)
								return RUF.db.profile.Appearance.Bars[Bar[i]].Color.PercentageGradient[1],RUF.db.profile.Appearance.Bars[Bar[i]].Color.PercentageGradient[2],RUF.db.profile.Appearance.Bars[Bar[i]].Color.PercentageGradient[3]
							end,
							set = function(info,r,g,b)
								RUF.db.profile.Appearance.Bars[Bar[i]].Color.PercentageGradient[1] = r
								RUF.db.profile.Appearance.Bars[Bar[i]].Color.PercentageGradient[2] = g
								RUF.db.profile.Appearance.Bars[Bar[i]].Color.PercentageGradient[3] = b
								RUF:OptionsUpdateAllBars()
							end,
						},
						percentage0Class = {
							name = L["Color 0% by Class"],
							desc = L["Colour bar by class color when at 0%."],
							type = 'toggle',
							order = 1.51,
							hidden = function() return not RUF.db.profile.Appearance.Bars[Bar[i]].Color.Percentage end,
							get = function(info)
								return RUF.db.profile.Appearance.Bars[Bar[i]].Color.percentage0Class
							end,
							set = function(info, value)
								RUF.db.profile.Appearance.Bars[Bar[i]].Color.percentage0Class = value
								RUF:OptionsUpdateAllBars()
							end,
						},
						percentage0Power = {
							name = L["Color 0% by Power Type"],
							desc = L["Colour bar by power color when at 0%."],
							type = 'toggle',
							order = 1.52,
							hidden = function()
								if i ~= 2 then return true end
								if RUF.db.profile.Appearance.Bars[Bar[i]].Color.Percentage == true then return false
								else return true
								end
							end,
							get = function(info)
								return RUF.db.profile.Appearance.Bars[Bar[i]].Color.percentage0Power
							end,
							set = function(info, value)
								RUF.db.profile.Appearance.Bars[Bar[i]].Color.percentage0Power = value
								RUF:OptionsUpdateAllBars()
							end,
						},
					},
				},
				backgroundStyle = {
					name = L["Background Style"],
					type = 'group',
					order = 1,
					inline = true,
					disabled = function() return (i == 4 and RUF.db.profile.Appearance.Bars[Bar[i]].Type == 1) end,
					args = {
						customColor = {
							name = L["Background Color"],
							desc = L["Background Color to use if not using the bar's color."],
							type = 'color',
							order = 10.01,
							disabled = function() return (i == 4 and RUF.db.profile.Appearance.Bars[Bar[i]].Type == 1) or (RUF.db.profile.Appearance.Bars[Bar[i]].Background.UseBarColor) end,
							get = function(info)
								return unpack(RUF.db.profile.Appearance.Bars[Bar[i]].Background.CustomColor)
							end,
							set = function(info,r,g,b)
								RUF.db.profile.Appearance.Bars[Bar[i]].Background.CustomColor = {r,g,b}
								RUF:OptionsUpdateAllBars()
							end,
						},
						useBarColor = {
							name = L["Use Bar Color"],
							desc = L["Color the background the same as the bar's color. Brightness reduced by the Multiplier setting."],
							type = 'toggle',
							order = 10.02,
							disabled = function() return (i == 4 and RUF.db.profile.Appearance.Bars[Bar[i]].Type == 1) end,
							get = function(info)
								return RUF.db.profile.Appearance.Bars[Bar[i]].Background.UseBarColor
							end,
							set = function(info, value)
								RUF.db.profile.Appearance.Bars[Bar[i]].Background.UseBarColor = value
								RUF:OptionsUpdateAllBars()
							end,
						},
						backgroundMult = {
							name = L["Brightness Multiplier"],
							desc = L["Reduce background color's brightness by this percentage."],
							type = 'range',
							order = 10.03,
							min = 0,
							max = 1,
							softMin = 0,
							softMax = 1,
							step = 0.01,
							bigStep = 0.05,
							disabled = function() return (i == 4 and RUF.db.profile.Appearance.Bars[Bar[i]].Type == 1) end,
							get = function(info)
								return RUF.db.profile.Appearance.Bars[Bar[i]].Background.Multiplier
							end,
							set = function(info, value)
								RUF.db.profile.Appearance.Bars[Bar[i]].Background.Multiplier = value
								RUF:OptionsUpdateAllBars()
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
							disabled = function() return (i == 4 and RUF.db.profile.Appearance.Bars[Bar[i]].Type == 1) end,
							get = function(info)
								return RUF.db.profile.Appearance.Bars[Bar[i]].Background.Alpha
							end,
							set = function(info, value)
								RUF.db.profile.Appearance.Bars[Bar[i]].Background.Alpha = value
								RUF:OptionsUpdateAllBars()
							end,
						},
					},
				},
				borderStyle = {
					name = L["Border"],
					type = 'group',
					order = 2,
					inline = true,
					hidden = i==1 or i==4,
					args = {
						borderTexture = {
							name = L["Texture"],
							type = 'select',
							order = 20.02,
							hidden = i==1 or i==4,
							values = LSM:HashTable('border'),
							dialogControl = 'LSM30_Border',
							get = function(info)
								return RUF.db.profile.Appearance.Bars[Bar[i]].Border.Style.edgeFile
							end,
							set = function(info, value)
								RUF.db.profile.Appearance.Bars[Bar[i]].Border.Style.edgeFile = value
								RUF:OptionsUpdateAllBars()
							end,
						},
						borderSize = {
							name = L["Size"],
							type = 'range',
							order = 20.03,
							hidden = i==1 or i==4,
							min = -20,
							max = 20,
							softMin = -20,
							softMax = 20,
							step = 0.01,
							bigStep = 0.05,
							get = function(info)
								return RUF.db.profile.Appearance.Bars[Bar[i]].Border.Style.edgeSize
							end,
							set = function(info, value)
								RUF.db.profile.Appearance.Bars[Bar[i]].Border.Style.edgeSize = value
								RUF:OptionsUpdateAllBars()
							end,
						},
						borderInset = {
							name = L["Inset from bar edge"],
							type = 'range',
							order = 20.04,
							min = -100,
							max = 100,
							softMin = -30,
							softMax = 30,
							step = 1,
							bigStep = 1,
							get = function(info)
								return RUF.db.profile.Appearance.Bars[Bar[i]].Border.Offset or 0
							end,
							set = function(info, value)
								RUF.db.profile.Appearance.Bars[Bar[i]].Border.Offset = value
								RUF:OptionsUpdateAllBars()
							end,
						},
						borderAlpha = {
							name = L["Alpha"],
							desc = L["Overlay Alpha"],
							type = 'range',
							isPercent = true,
							order = 20.05,
							hidden = i==1 or i==4,
							min = 0,
							max = 1,
							softMin = 0,
							softMax = 1,
							step = 0.01,
							bigStep = 0.05,
							get = function(info)
								return RUF.db.profile.Appearance.Bars[Bar[i]].Border.Alpha
							end,
							set = function(info, value)
								RUF.db.profile.Appearance.Bars[Bar[i]].Border.Alpha = value
								RUF:OptionsUpdateAllBars()
							end,
						},
						borderColor = {
							name = L["Base Color"],
							type = 'color',
							order = 20.05,
							hidden = i==1 or i==4,
							get = function(info)
								return RUF.db.profile.Appearance.Bars[Bar[i]].Border.Color[1], RUF.db.profile.Appearance.Bars[Bar[i]].Border.Color[2],RUF.db.profile.Appearance.Bars[Bar[i]].Border.Color[3]
							end,
							set = function(info,r,g,b)
								RUF.db.profile.Appearance.Bars[Bar[i]].Border.Color[1] = r
								RUF.db.profile.Appearance.Bars[Bar[i]].Border.Color[2] = g
								RUF.db.profile.Appearance.Bars[Bar[i]].Border.Color[3] = b
								RUF:OptionsUpdateAllBars()
							end,
						},
					},
				},
				latencyStyle = {
					name = L["Latency"],
					type = 'group',
					order = 3,
					inline = true,
					hidden = i ~= 5,
					args = {
						safeZoneEnabled = {
							name = L["Enabled"],
							type = 'toggle',
							hidden = i ~= 5,
							order = 5.01,
							get = function(info)
								return RUF.db.profile.Appearance.Bars[Bar[i]].SafeZone.Enabled
							end,
							set = function(info, value)
								RUF.db.profile.Appearance.Bars[Bar[i]].SafeZone.Enabled = value
								RUF:OptionsUpdateAllBars()
							end,
						},
						safeZoneColor = {
							name = L["Color"],
							type = 'color',
							order = 5.02,
							hidden = i ~= 5,
							get = function(info)
								return unpack(RUF.db.profile.Appearance.Bars[Bar[i]].SafeZone.Color)
							end,
							set = function(info,r,g,b)
								RUF.db.profile.Appearance.Bars[Bar[i]].SafeZone.Color = {r,g,b}
								RUF:OptionsUpdateAllBars()
							end,
						},
						safeZoneAlpha = {
							name = L["Alpha"],
							type = 'range',
							isPercent = true,
							order = 5.03,
							hidden = i ~= 5,
							min = 0,
							max = 1,
							softMin = 0,
							softMax = 1,
							step = 0.01,
							bigStep = 0.05,
							get = function(info)
								return RUF.db.profile.Appearance.Bars[Bar[i]].SafeZone.Alpha
							end,
							set = function(info, value)
								RUF.db.profile.Appearance.Bars[Bar[i]].SafeZone.Alpha = value
								RUF:OptionsUpdateAllBars()
							end,
						},
					},
				},
			},
		}
	end

	Bars.args.HealPrediction = {
		name = L["Heal Prediction"],
		type = 'group',
		order = 50,
		args = {
			overflow = {
				name = L["Bar Overflow Amount"],
				desc = L["Allows incoming healing bars to overflow out of the frame by this amount. The value is a percentage of the frame's width. Set to 0 to disallow overflowing."],
				type = 'range',
				order = 0,
				min = 0,
				max = 5,
				softMin = 0,
				softMax = 1,
				step = 0.01,
				bigStep = 0.05,
				get = function(info)
					return RUF.db.profile.Appearance.Bars.HealPrediction.Overflow
				end,
				set = function(info, value)
					RUF.db.profile.Appearance.Bars.HealPrediction.Overflow = value
					RUF:OptionsUpdateAllBars()
				end,
			},
			playerStyle = {
				name = L["Player Heals"],
				type = 'group',
				order = 10,
				inline = true,
				args = {
					enabled = {
						name = function()
							if RUF.db.profile.Appearance.Bars.HealPrediction.Player.Enabled == true then
								return '|cFF00FF00'..L["Enabled"]..'|r'
							else
								return '|cFFFF0000'..L["Enabled"]..'|r'
							end
						end,
						type = 'toggle',
						order = 0.0,
						get = function(info)
							return RUF.db.profile.Appearance.Bars.HealPrediction.Player.Enabled
						end,
						set = function(info, value)
							RUF.db.profile.Appearance.Bars.HealPrediction.Player.Enabled = value
							RUF:OptionsUpdateAllBars()
						end,
					},
					baseColor = {
						name = L["Base Color"],
						desc = L["Color used if none of the other options are checked."],
						type = 'color',
						order = 0.01,
						get = function(info)
							return unpack(RUF.db.profile.Appearance.Bars.HealPrediction.Player.Color.BaseColor)
						end,
						set = function(info,r,g,b)
							RUF.db.profile.Appearance.Bars.HealPrediction.Player.Color.BaseColor = {r,g,b}
							RUF:OptionsUpdateAllBars()
						end,
					},
					barTexture = {
						name = L["Texture"],
						type = 'select',
						order = 0.02,
						values = LSM:HashTable('statusbar'),
						dialogControl = 'LSM30_Statusbar',
						get = function(info)
							return RUF.db.profile.Appearance.Bars.HealPrediction.Player.Texture
						end,
						set = function(info, value)
							RUF.db.profile.Appearance.Bars.HealPrediction.Player.Texture = value
							RUF:OptionsUpdateAllBars()
						end,
					},
					brightnessMult = {
						name = L["Brightness Multiplier"],
						desc = L["Reduce Bar color's brightness by this percentage."],
						type = 'range',
						order = 0.03,
						min = 0,
						max = 1,
						softMin = 0,
						softMax = 1,
						step = 0.01,
						bigStep = 0.05,
						get = function(info)
							return RUF.db.profile.Appearance.Bars.HealPrediction.Player.Color.Multiplier
						end,
						set = function(info, value)
							RUF.db.profile.Appearance.Bars.HealPrediction.Player.Color.Multiplier = value
							RUF:OptionsUpdateAllBars()
						end,
					},
					alpha = {
						name = L["Alpha"],
						type = 'range',
						isPercent = true,
						order = 0.04,
						min = 0,
						max = 1,
						softMin = 0,
						softMax = 1,
						step = 0.01,
						bigStep = 0.05,
						get = function(info)
							return RUF.db.profile.Appearance.Bars.HealPrediction.Player.Color.Alpha
						end,
						set = function(info, value)
							RUF.db.profile.Appearance.Bars.HealPrediction.Player.Color.Alpha = value
							RUF:OptionsUpdateAllBars()
						end,
					},
					spacerTypeColor = {
						name = " ",
						type = 'description',
						order = 0.055,
						width = 'full',
					},
					descColorPriority = {
						name = L["The colour options below are listed in order of precedence left to right, with the first being the highest priority."],
						type = 'description',
						order = 0.06,
						width = 'full',
					},
					class = {
						name = L["Color Class"],
						desc = L["Color player units by class color."],
						type = 'toggle',
						order = 0.1,
						get = function(info)
							return RUF.db.profile.Appearance.Bars.HealPrediction.Player.Color.Class
						end,
						set = function(info, value)
							RUF.db.profile.Appearance.Bars.HealPrediction.Player.Color.Class = value
							RUF:OptionsUpdateAllBars()
						end,
					},
					reaction = {
						name = L["Color Reaction"],
						desc = L["Color unit by reaction toward the player."],
						type = 'toggle',
						order = 0.11,
						get = function(info)
							return RUF.db.profile.Appearance.Bars.HealPrediction.Player.Color.Reaction
						end,
						set = function(info, value)
							RUF.db.profile.Appearance.Bars.HealPrediction.Player.Color.Reaction = value
							RUF:OptionsUpdateAllBars()
						end,
					},
					spacerPercentage = {
						name = " ",
						type = 'description',
						order = 1,
						width = 'full',
					},
					percentage = {
						name = L["Color Percentage"],
						desc = L["Color Bar by percentage colors."],
						type = 'toggle',
						order = 1.2,
						get = function(info)
							return RUF.db.profile.Appearance.Bars.HealPrediction.Player.Color.Percentage
						end,
						set = function(info, value)
							RUF.db.profile.Appearance.Bars.HealPrediction.Player.Color.Percentage = value
							RUF:OptionsUpdateAllBars()
						end,
					},
					percentMaxSpacer = {
						name = " ",
						type = 'description',
						order = 1.25,
						width = 'full',
					},
					percent100 = {
						name = L["100%"],
						desc = L["Color at 100%"],
						type = 'color',
						order = 1.3,
						disabled = function() return RUF.db.profile.Appearance.Bars.HealPrediction.Player.Color.percentageMaxClass end,
						hidden = function() return not RUF.db.profile.Appearance.Bars.HealPrediction.Player.Color.Percentage end,
						get = function(info)
							return RUF.db.profile.Appearance.Bars.HealPrediction.Player.Color.PercentageGradient[7],RUF.db.profile.Appearance.Bars.HealPrediction.Player.Color.PercentageGradient[8],RUF.db.profile.Appearance.Bars.HealPrediction.Player.Color.PercentageGradient[9]
						end,
						set = function(info,r,g,b)
							RUF.db.profile.Appearance.Bars.HealPrediction.Player.Color.PercentageGradient[7] = r
							RUF.db.profile.Appearance.Bars.HealPrediction.Player.Color.PercentageGradient[8] = g
							RUF.db.profile.Appearance.Bars.HealPrediction.Player.Color.PercentageGradient[9] = b
							RUF:OptionsUpdateAllBars()
						end,
					},
					percentageMaxClass = {
						name = L["Color 100% by Class"],
						desc = L["Colour bar by class color when at 100%."],
						type = 'toggle',
						order = 1.31,
						hidden = function() return not RUF.db.profile.Appearance.Bars.HealPrediction.Player.Color.Percentage end,
						get = function(info)
							return RUF.db.profile.Appearance.Bars.HealPrediction.Player.Color.percentageMaxClass
						end,
						set = function(info, value)
							RUF.db.profile.Appearance.Bars.HealPrediction.Player.Color.percentageMaxClass = value
							RUF:OptionsUpdateAllBars()
						end,
					},
					percent50Spacer = {
						name = " ",
						type = 'description',
						order = 1.35,
						width = 'full',
					},
					percent50 = {
						name = L["50%"],
						desc = L["Color at 50%"],
						type = 'color',
						order = 1.4,
						disabled = function() return RUF.db.profile.Appearance.Bars.HealPrediction.Player.Color.percentage50Class end,
						hidden = function() return not RUF.db.profile.Appearance.Bars.HealPrediction.Player.Color.Percentage end,
						get = function(info)
							return RUF.db.profile.Appearance.Bars.HealPrediction.Player.Color.PercentageGradient[4],RUF.db.profile.Appearance.Bars.HealPrediction.Player.Color.PercentageGradient[5],RUF.db.profile.Appearance.Bars.HealPrediction.Player.Color.PercentageGradient[6]
						end,
						set = function(info,r,g,b)
							RUF.db.profile.Appearance.Bars.HealPrediction.Player.Color.PercentageGradient[4] = r
							RUF.db.profile.Appearance.Bars.HealPrediction.Player.Color.PercentageGradient[5] = g
							RUF.db.profile.Appearance.Bars.HealPrediction.Player.Color.PercentageGradient[6] = b
							RUF:OptionsUpdateAllBars()
						end,
					},
					percentage50Class = {
						name = L["Color 50% by Class"],
						desc = L["Colour bar by class color when at 50%."],
						type = 'toggle',
						order = 1.41,
						hidden = function() return not RUF.db.profile.Appearance.Bars.HealPrediction.Player.Color.Percentage end,
						get = function(info)
							return RUF.db.profile.Appearance.Bars.HealPrediction.Player.Color.percentage50Class
						end,
						set = function(info, value)
							RUF.db.profile.Appearance.Bars.HealPrediction.Player.Color.percentage50Class = value
							RUF:OptionsUpdateAllBars()
						end,
					},
					percent0Spacer = {
						name = " ",
						type = 'description',
						order = 1.45,
						width = 'full',
					},
					percent0 = {
						name = L["0%"],
						desc = L["Color at 0%"],
						type = 'color',
						order = 1.5,
						disabled = function() return RUF.db.profile.Appearance.Bars.HealPrediction.Player.Color.percentage0Class end,
						hidden = function() return not RUF.db.profile.Appearance.Bars.HealPrediction.Player.Color.Percentage end,
						get = function(info)
							return RUF.db.profile.Appearance.Bars.HealPrediction.Player.Color.PercentageGradient[1],RUF.db.profile.Appearance.Bars.HealPrediction.Player.Color.PercentageGradient[2],RUF.db.profile.Appearance.Bars.HealPrediction.Player.Color.PercentageGradient[3]
						end,
						set = function(info,r,g,b)
							RUF.db.profile.Appearance.Bars.HealPrediction.Player.Color.PercentageGradient[1] = r
							RUF.db.profile.Appearance.Bars.HealPrediction.Player.Color.PercentageGradient[2] = g
							RUF.db.profile.Appearance.Bars.HealPrediction.Player.Color.PercentageGradient[3] = b
							RUF:OptionsUpdateAllBars()
						end,
					},
					percentage0Class = {
						name = L["Color 0% by Class"],
						desc = L["Colour bar by class color when at 0%."],
						type = 'toggle',
						order = 1.51,
						hidden = function() return not RUF.db.profile.Appearance.Bars.HealPrediction.Player.Color.Percentage end,
						get = function(info)
							return RUF.db.profile.Appearance.Bars.HealPrediction.Player.Color.percentage0Class
						end,
						set = function(info, value)
							RUF.db.profile.Appearance.Bars.HealPrediction.Player.Color.percentage0Class = value
							RUF:OptionsUpdateAllBars()
						end,
					},
				},
			},
			otherStyle = {
				name = L["Other's Heals"],
				type = 'group',
				order = 11,
				inline = true,
				args = {
					enabled = {
						name = function()
							if RUF.db.profile.Appearance.Bars.HealPrediction.Others.Enabled == true then
								return '|cFF00FF00'..L["Enabled"]..'|r'
							else
								return '|cFFFF0000'..L["Enabled"]..'|r'
							end
						end,
						type = 'toggle',
						order = 0.0,
						get = function(info)
							return RUF.db.profile.Appearance.Bars.HealPrediction.Others.Enabled
						end,
						set = function(info, value)
							RUF.db.profile.Appearance.Bars.HealPrediction.Others.Enabled = value
							RUF:OptionsUpdateAllBars()
						end,
					},

					baseColor = {
						name = L["Base Color"],
						desc = L["Color used if none of the other options are checked."],
						type = 'color',
						order = 0.01,
						get = function(info)
							return unpack(RUF.db.profile.Appearance.Bars.HealPrediction.Others.Color.BaseColor)
						end,
						set = function(info,r,g,b)
							RUF.db.profile.Appearance.Bars.HealPrediction.Others.Color.BaseColor = {r,g,b}
							RUF:OptionsUpdateAllBars()
						end,
					},
					barTexture = {
						name = L["Texture"],
						type = 'select',
						order = 0.02,
						values = LSM:HashTable('statusbar'),
						dialogControl = 'LSM30_Statusbar',
						get = function(info)
							return RUF.db.profile.Appearance.Bars.HealPrediction.Others.Texture
						end,
						set = function(info, value)
							RUF.db.profile.Appearance.Bars.HealPrediction.Others.Texture = value
							RUF:OptionsUpdateAllBars()
						end,
					},
					brightnessMult = {
						name = L["Brightness Multiplier"],
						desc = L["Reduce Bar color's brightness by this percentage."],
						type = 'range',
						order = 0.03,
						min = 0,
						max = 1,
						softMin = 0,
						softMax = 1,
						step = 0.01,
						bigStep = 0.05,
						get = function(info)
							return RUF.db.profile.Appearance.Bars.HealPrediction.Others.Color.Multiplier
						end,
						set = function(info, value)
							RUF.db.profile.Appearance.Bars.HealPrediction.Others.Color.Multiplier = value
							RUF:OptionsUpdateAllBars()
						end,
					},
					alpha = {
						name = L["Alpha"],
						type = 'range',
						isPercent = true,
						order = 0.04,
						min = 0,
						max = 1,
						softMin = 0,
						softMax = 1,
						step = 0.01,
						bigStep = 0.05,
						get = function(info)
							return RUF.db.profile.Appearance.Bars.HealPrediction.Others.Color.Alpha
						end,
						set = function(info, value)
							RUF.db.profile.Appearance.Bars.HealPrediction.Others.Color.Alpha = value
							RUF:OptionsUpdateAllBars()
						end,
					},
					spacerTypeColor = {
						name = " ",
						type = 'description',
						order = 0.055,
						width = 'full',
					},
					descColorPriority = {
						name = L["The colour options below are listed in order of precedence left to right, with the first being the highest priority."],
						type = 'description',
						order = 0.06,
						width = 'full',
					},
					class = {
						name = L["Color Class"],
						desc = L["Color player units by class color."],
						type = 'toggle',
						order = 0.1,
						get = function(info)
							return RUF.db.profile.Appearance.Bars.HealPrediction.Others.Color.Class
						end,
						set = function(info, value)
							RUF.db.profile.Appearance.Bars.HealPrediction.Others.Color.Class = value
							RUF:OptionsUpdateAllBars()
						end,
					},
					reaction = {
						name = L["Color Reaction"],
						desc = L["Color unit by reaction toward the player."],
						type = 'toggle',
						order = 0.11,
						get = function(info)
							return RUF.db.profile.Appearance.Bars.HealPrediction.Others.Color.Reaction
						end,
						set = function(info, value)
							RUF.db.profile.Appearance.Bars.HealPrediction.Others.Color.Reaction = value
							RUF:OptionsUpdateAllBars()
						end,
					},
					spacerPercentage = {
						name = " ",
						type = 'description',
						order = 1,
						width = 'full',
					},
					percentage = {
						name = L["Color Percentage"],
						desc = L["Color Bar by percentage colors."],
						type = 'toggle',
						order = 1.2,
						get = function(info)
							return RUF.db.profile.Appearance.Bars.HealPrediction.Others.Color.Percentage
						end,
						set = function(info, value)
							RUF.db.profile.Appearance.Bars.HealPrediction.Others.Color.Percentage = value
							RUF:OptionsUpdateAllBars()
						end,
					},
					percentMaxSpacer = {
						name = " ",
						type = 'description',
						order = 1.25,
						width = 'full',
					},
					percent100 = {
						name = L["100%"],
						desc = L["Color at 100%"],
						type = 'color',
						order = 1.3,
						disabled = function() return RUF.db.profile.Appearance.Bars.HealPrediction.Others.Color.percentageMaxClass end,
						hidden = function() return not RUF.db.profile.Appearance.Bars.HealPrediction.Others.Color.Percentage end,
						get = function(info)
							return RUF.db.profile.Appearance.Bars.HealPrediction.Others.Color.PercentageGradient[7],RUF.db.profile.Appearance.Bars.HealPrediction.Others.Color.PercentageGradient[8],RUF.db.profile.Appearance.Bars.HealPrediction.Others.Color.PercentageGradient[9]
						end,
						set = function(info,r,g,b)
							RUF.db.profile.Appearance.Bars.HealPrediction.Others.Color.PercentageGradient[7] = r
							RUF.db.profile.Appearance.Bars.HealPrediction.Others.Color.PercentageGradient[8] = g
							RUF.db.profile.Appearance.Bars.HealPrediction.Others.Color.PercentageGradient[9] = b
							RUF:OptionsUpdateAllBars()
						end,
					},
					percentageMaxClass = {
						name = L["Color 100% by Class"],
						desc = L["Colour bar by class color when at 100%."],
						type = 'toggle',
						order = 1.31,
						hidden = function() return not RUF.db.profile.Appearance.Bars.HealPrediction.Others.Color.Percentage end,
						get = function(info)
							return RUF.db.profile.Appearance.Bars.HealPrediction.Others.Color.percentageMaxClass
						end,
						set = function(info, value)
							RUF.db.profile.Appearance.Bars.HealPrediction.Others.Color.percentageMaxClass = value
							RUF:OptionsUpdateAllBars()
						end,
					},
					percent50Spacer = {
						name = " ",
						type = 'description',
						order = 1.35,
						width = 'full',
					},
					percent50 = {
						name = L["50%"],
						desc = L["Color at 50%"],
						type = 'color',
						order = 1.4,
						disabled = function() return RUF.db.profile.Appearance.Bars.HealPrediction.Others.Color.percentage50Class end,
						hidden = function() return not RUF.db.profile.Appearance.Bars.HealPrediction.Others.Color.Percentage end,
						get = function(info)
							return RUF.db.profile.Appearance.Bars.HealPrediction.Others.Color.PercentageGradient[4],RUF.db.profile.Appearance.Bars.HealPrediction.Others.Color.PercentageGradient[5],RUF.db.profile.Appearance.Bars.HealPrediction.Others.Color.PercentageGradient[6]
						end,
						set = function(info,r,g,b)
							RUF.db.profile.Appearance.Bars.HealPrediction.Others.Color.PercentageGradient[4] = r
							RUF.db.profile.Appearance.Bars.HealPrediction.Others.Color.PercentageGradient[5] = g
							RUF.db.profile.Appearance.Bars.HealPrediction.Others.Color.PercentageGradient[6] = b
							RUF:OptionsUpdateAllBars()
						end,
					},
					percentage50Class = {
						name = L["Color 50% by Class"],
						desc = L["Colour bar by class color when at 50%."],
						type = 'toggle',
						order = 1.41,
						hidden = function() return not RUF.db.profile.Appearance.Bars.HealPrediction.Others.Color.Percentage end,
						get = function(info)
							return RUF.db.profile.Appearance.Bars.HealPrediction.Others.Color.percentage50Class
						end,
						set = function(info, value)
							RUF.db.profile.Appearance.Bars.HealPrediction.Others.Color.percentage50Class = value
							RUF:OptionsUpdateAllBars()
						end,
					},
					percent0Spacer = {
						name = " ",
						type = 'description',
						order = 1.45,
						width = 'full',
					},
					percent0 = {
						name = L["0%"],
						desc = L["Color at 0%"],
						type = 'color',
						order = 1.5,
						disabled = function() return RUF.db.profile.Appearance.Bars.HealPrediction.Others.Color.percentage0Class end,
						hidden = function() return not RUF.db.profile.Appearance.Bars.HealPrediction.Others.Color.Percentage end,
						get = function(info)
							return RUF.db.profile.Appearance.Bars.HealPrediction.Others.Color.PercentageGradient[1],RUF.db.profile.Appearance.Bars.HealPrediction.Others.Color.PercentageGradient[2],RUF.db.profile.Appearance.Bars.HealPrediction.Others.Color.PercentageGradient[3]
						end,
						set = function(info,r,g,b)
							RUF.db.profile.Appearance.Bars.HealPrediction.Others.Color.PercentageGradient[1] = r
							RUF.db.profile.Appearance.Bars.HealPrediction.Others.Color.PercentageGradient[2] = g
							RUF.db.profile.Appearance.Bars.HealPrediction.Others.Color.PercentageGradient[3] = b
							RUF:OptionsUpdateAllBars()
						end,
					},
					percentage0Class = {
						name = L["Color 0% by Class"],
						desc = L["Colour bar by class color when at 0%."],
						type = 'toggle',
						order = 1.51,
						hidden = function() return not RUF.db.profile.Appearance.Bars.HealPrediction.Others.Color.Percentage end,
						get = function(info)
							return RUF.db.profile.Appearance.Bars.HealPrediction.Others.Color.percentage0Class
						end,
						set = function(info, value)
							RUF.db.profile.Appearance.Bars.HealPrediction.Others.Color.percentage0Class = value
							RUF:OptionsUpdateAllBars()
						end,
					},
				},
			},
		},
	}
	return Bars
end