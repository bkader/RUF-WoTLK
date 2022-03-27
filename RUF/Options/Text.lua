local RUF = RUF
local RUF_Options = RUF:GetModule("Options")

local tinsert, wipe = table.insert, wipe

local L = LibStub("AceLocale-3.0"):GetLocale("RUF")

local TagList = {}
local LocalisedTags = {}
local TagInputs = {}

function RUF_Options.Texts()
	wipe(TagList)
	wipe(LocalisedTags)
	wipe(TagInputs)
	for k, v in pairs(RUF.db.profile.Appearance.Text) do
		if v ~= "" then
			tinsert(TagList, k)
			tinsert(LocalisedTags, L[k])
			TagInputs["[RUF:" .. k .. "]"] = L[k]
		end
	end

	local Texts = {
		name = L["Tags"],
		type = "group",
		order = 4,
		args = {}
	}
	for i = 1, #TagList do
		Texts.args[TagList[i]] = {
			name = LocalisedTags[i],
			type = "group",
			args = {
				Case = {
					type = "select",
					name = L["Text Case"],
					desc = L["Choose if text is Capitalised, All Lower Case or all Upper case."],
					order = 0.03,
					values = {
						[0] = L["Normal"],
						[1] = L["Upper Case"],
						[2] = L["Lower Case"]
					},
					get = function(info)
						return RUF.db.profile.Appearance.Text[TagList[i]].Case
					end,
					set = function(info, value)
						RUF.db.profile.Appearance.Text[TagList[i]].Case = value
					end
				},
				Base_Color = {
					type = "color",
					name = L["Base Color"],
					desc = L["Color used if none of the other options are checked."],
					order = 0.04,
					get = function(info)
						return unpack(RUF.db.profile.Appearance.Text[TagList[i]].Color.BaseColor)
					end,
					set = function(info, r, g, b)
						RUF.db.profile.Appearance.Text[TagList[i]].Color.BaseColor = {r, g, b}
					end
				},
				Class = {
					type = "toggle",
					name = L["Color Class"],
					order = 0.05,
					get = function(info)
						return RUF.db.profile.Appearance.Text[TagList[i]].Color.Class
					end,
					set = function(info, value)
						RUF.db.profile.Appearance.Text[TagList[i]].Color.Class = value
					end
				},
				Level = {
					type = "toggle",
					name = L["Color Level"],
					order = 0.05,
					get = function(info)
						return RUF.db.profile.Appearance.Text[TagList[i]].Color.Level
					end,
					set = function(info, value)
						RUF.db.profile.Appearance.Text[TagList[i]].Color.Level = value
					end
				},
				Reaction = {
					type = "toggle",
					name = L["Color Reaction"],
					order = 0.05,
					get = function(info)
						return RUF.db.profile.Appearance.Text[TagList[i]].Color.Reaction
					end,
					set = function(info, value)
						RUF.db.profile.Appearance.Text[TagList[i]].Color.Reaction = value
					end
				},
				PowerType = {
					type = "toggle",
					name = L["Color Power Type"],
					order = 0.05,
					get = function(info)
						return RUF.db.profile.Appearance.Text[TagList[i]].Color.PowerType
					end,
					set = function(info, value)
						RUF.db.profile.Appearance.Text[TagList[i]].Color.PowerType = value
					end
				},
				Percentage = {
					type = "toggle",
					name = L["Color Percentage"],
					order = 0.05,
					get = function(info)
						return RUF.db.profile.Appearance.Text[TagList[i]].Color.Percentage
					end,
					set = function(info, value)
						RUF.db.profile.Appearance.Text[TagList[i]].Color.Percentage = value
					end
				},
				PercentageAtMax = {
					type = "toggle",
					name = L["Color Percentage At Max"],
					order = 0.05,
					get = function(info)
						return RUF.db.profile.Appearance.Text[TagList[i]].Color.PercentageAtMax
					end,
					set = function(info, value)
						RUF.db.profile.Appearance.Text[TagList[i]].Color.PercentageAtMax = value
					end
				},
				Percent_100 = {
					type = "color",
					name = L["100%"],
					desc = L["Color at 100%"],
					order = 0.1,
					hidden = function()
						return not RUF.db.profile.Appearance.Text[TagList[i]].Color.Percentage
					end,
					get = function(info)
						return RUF.db.profile.Appearance.Text[TagList[i]].Color.PercentageGradient[7],
						RUF.db.profile.Appearance.Text[TagList[i]].Color.PercentageGradient[8],
						RUF.db.profile.Appearance.Text[TagList[i]].Color.PercentageGradient[9]
					end,
					set = function(info, r, g, b)
						RUF.db.profile.Appearance.Text[TagList[i]].Color.PercentageGradient[7] = r
						RUF.db.profile.Appearance.Text[TagList[i]].Color.PercentageGradient[8] = g
						RUF.db.profile.Appearance.Text[TagList[i]].Color.PercentageGradient[9] = b
					end
				},
				Percent_50 = {
					type = "color",
					name = L["50%"],
					desc = L["Color at 50%"],
					order = 0.11,
					hidden = function()
						return not RUF.db.profile.Appearance.Text[TagList[i]].Color.Percentage
					end,
					get = function(info)
						return RUF.db.profile.Appearance.Text[TagList[i]].Color.PercentageGradient[4],
						RUF.db.profile.Appearance.Text[TagList[i]].Color.PercentageGradient[5],
						RUF.db.profile.Appearance.Text[TagList[i]].Color.PercentageGradient[6]
					end,
					set = function(info, r, g, b)
						RUF.db.profile.Appearance.Text[TagList[i]].Color.PercentageGradient[4] = r
						RUF.db.profile.Appearance.Text[TagList[i]].Color.PercentageGradient[5] = g
						RUF.db.profile.Appearance.Text[TagList[i]].Color.PercentageGradient[6] = b
					end
				},
				Percent_0 = {
					type = "color",
					name = L["0%"],
					desc = L["Color at 0%"],
					order = 0.12,
					hidden = function()
						return not RUF.db.profile.Appearance.Text[TagList[i]].Color.Percentage
					end,
					get = function(info)
						return RUF.db.profile.Appearance.Text[TagList[i]].Color.PercentageGradient[1],
						RUF.db.profile.Appearance.Text[TagList[i]].Color.PercentageGradient[2],
						RUF.db.profile.Appearance.Text[TagList[i]].Color.PercentageGradient[3]
					end,
					set = function(info, r, g, b)
						RUF.db.profile.Appearance.Text[TagList[i]].Color.PercentageGradient[1] = r
						RUF.db.profile.Appearance.Text[TagList[i]].Color.PercentageGradient[2] = g
						RUF.db.profile.Appearance.Text[TagList[i]].Color.PercentageGradient[3] = b
					end
				},
				Spacer = {
					type = "description",
					name = " ",
					width = "full",
					order = 10.0
				},
				HideSameLevel = {
					type = "toggle",
					name = L["Hide same level"],
					desc = L["Hide the level text if the unit is the same level as you."],
					order = 10.01,
					width = "full",
					hidden = function() return TagList[i] ~= "Level" end,
					disabled = not RUF.db.profile.Appearance.Text[TagList[i]].ShowLevel,
					get = function(info)
						return RUF.db.profile.Appearance.Text[TagList[i]].HideSameLevel
					end,
					set = function(info, value)
						RUF.db.profile.Appearance.Text[TagList[i]].HideSameLevel = value
					end
				},
				ShowLevel = {
					type = "toggle",
					name = L["Show Level"],
					order = 10.01,
					width = "full",
					hidden = function() return TagList[i] ~= "Level" end,
					get = function(info)
						return RUF.db.profile.Appearance.Text[TagList[i]].ShowLevel
					end,
					set = function(info, value)
						RUF.db.profile.Appearance.Text[TagList[i]].ShowLevel = value
					end
				},
				ShowClassification = {
					type = "toggle",
					name = L["Show Classification"],
					desc = L["Show the ++ for rare elites, + for elites etc."],
					order = 10.01,
					width = "full",
					hidden = function() return TagList[i] ~= "Level" end,
					get = function(info)
						return RUF.db.profile.Appearance.Text[TagList[i]].ShowClassification
					end,
					set = function(info, value)
						RUF.db.profile.Appearance.Text[TagList[i]].ShowClassification = value
					end
				},
				ClassificationBeforeLevel = {
					type = "toggle",
					name = L["Show Classification before Level"],
					order = 10.02,
					width = "full",
					hidden = function() return TagList[i] ~= "Level" end,
					get = function(info)
						return RUF.db.profile.Appearance.Text[TagList[i]].ClassificationBeforeLevel
					end,
					set = function(info, value)
						RUF.db.profile.Appearance.Text[TagList[i]].ClassificationBeforeLevel = value
					end
				},
				HideWhenPrimaryIsMana = {
					type = "toggle",
					name = L["Hide if Primary Power is Mana."],
					desc = L["Sets this to hidden if your primary resource is mana, so it only shows if you have a class resource, such as Energy."],
					width = "full",
					order = 10.01,
					hidden = function() return not (TagList[i] == "CurMana" or TagList[i] == "ManaPerc" or TagList[i] == "CurManaPerc") end,
					get = function(info)
						return RUF.db.profile.Appearance.Text[TagList[i]].HideWhenPrimaryIsMana
					end,
					set = function(info, value)
						RUF.db.profile.Appearance.Text[TagList[i]].HideWhenPrimaryIsMana = value
					end
				},
				characterLimit = {
					type = "range",
					name = L["Character Limit"],
					desc = L["Abbreviate Character Names longer than this. Set 0 for no limit."],
					order = 10.03,
					hidden = function() return TagList[i] ~= "Name" end,
					min = 0,
					max = 50,
					softMin = 0,
					softMax = 50,
					step = 1,
					bigStep = 1,
					get = function(info)
						return RUF.db.profile.Appearance.Text.Name.CharLimit
					end,
					set = function(info, value)
						RUF.db.profile.Appearance.Text.Name.CharLimit = value
					end
				},
				abbreviateAboveCharacterLimit = {
					type = "select",
					name = L["Abbreviate Style"],
					desc = L["Trim simply removes any letters above the limit.\nElipsis adds an elipsis to the end of the trimmed name to signify it has been cut short.\nAbbreviate turns any words that would be trimmed into an initial.\nInitialism turns the entire name into initials if it would be trimmed."],
					order = 10.031,
					hidden = function() return TagList[i] ~= "Name" end,
					values = {
						[0] = L["Trim"],
						[1] = L["Elipsis"],
						[2] = L["Abbreviate"],
						[3] = L["Initialism"]
					},
					get = function(info)
						return RUF.db.profile.Appearance.Text.Name.CharLimitStyle
					end,
					set = function(info, value)
						RUF.db.profile.Appearance.Text.Name.CharLimitStyle = value
					end
				},
				CurManaPerc_Enabled = {
					type = "select",
					name = L["Display Style"],
					desc = L["Hide this tag at 0 or always display."],
					order = 10.01,
					hidden = function()
						if TagList[i] == "CurMana" or
							TagList[i] == "ManaPerc" or
							TagList[i] == "CurManaPerc" or
							TagList[i] == "CurPower" or
							TagList[i] == "PowerPerc" or
							TagList[i] == "CurPowerPerc"
						 then
							return false
						else
							return true
						end
					end,
					values = {
						[1] = L["Hidden at 0"],
						[2] = L["Always Visible"]
					},
					get = function(info)
						return RUF.db.profile.Appearance.Text[TagList[i]].Enabled
					end,
					set = function(info, value)
						RUF.db.profile.Appearance.Text[TagList[i]].Enabled = value
					end
				},
				MaxAtMax = {
					type = "toggle",
					name = L["Show Max at Max"],
					order = 10.01,
					hidden = function() return not (TagList[i] == "CurMaxHPPerc" or TagList[i] == "CurMaxHP") end,
					get = function(info)
						return RUF.db.profile.Appearance.Text[TagList[i]].ShowMaxAtMax
					end,
					set = function(info, value)
						RUF.db.profile.Appearance.Text[TagList[i]].ShowMaxAtMax = value
					end
				},
				PercAtMax = {
					type = "toggle",
					name = L["Show Percentage at Max"],
					hidden = function() return not (TagList[i] == "CurMaxHPPerc" or TagList[i] == "CurHPPerc") end,
					order = 10.01,
					get = function(info)
						return RUF.db.profile.Appearance.Text[TagList[i]].ShowPercAtMax
					end,
					set = function(info, value)
						RUF.db.profile.Appearance.Text[TagList[i]].ShowPercAtMax = value
					end
				}
			}
		}
	end
	return Texts
end