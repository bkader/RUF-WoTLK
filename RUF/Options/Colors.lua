assert(RUF, "RUF not found!")
local RUF = RUF
local L = LibStub("AceLocale-3.0"):GetLocale("RUF")
local RUF_Options = RUF:GetModule("Options")
local _, ns = ...
local oUF = ns.oUF
local _, PlayerClass = UnitClass("player")

local GetClassInfo = RUF.GetClassInfo

function RUF_Options.Colors()
	local Reactions = {
		[1] = FACTION_STANDING_LABEL1,
		[2] = FACTION_STANDING_LABEL2,
		[3] = FACTION_STANDING_LABEL3,
		[4] = FACTION_STANDING_LABEL4,
		[5] = FACTION_STANDING_LABEL5,
		[6] = FACTION_STANDING_LABEL6,
		[7] = FACTION_STANDING_LABEL7,
		[8] = FACTION_STANDING_LABEL8,
	}
	local Difficulties = {
		[0] = L["Very Hard"],
		[1] = L["Hard"],
		[2] = L["Normal"],
		[3] = L["Easy"],
		[4] = L["Trivial"]
	}
	local Powers = {
		[0] = _G["MANA"] or MANA,
		[1] = _G["RAGE"] or RAGE,
		[2] = _G["FOCUS"] or FOCUS,
		[3] = _G["ENERGY"] or ENERGY,
		[4] = L["Combo Points"],
		[6] = _G["RUNIC_POWER"] or RUNIC_POWER
	}
	local classData = {
		[1] = {GetClassInfo(1)}, -- Warrior
		[2] = {GetClassInfo(2)}, -- Paladin
		[3] = {GetClassInfo(3)}, -- Hunter
		[4] = {GetClassInfo(4)}, -- Rogue
		[5] = {GetClassInfo(5)}, -- Priest
		[6] = {GetClassInfo(6)}, -- Death Knight
		[7] = {GetClassInfo(7)}, -- Shaman
		[8] = {GetClassInfo(8)}, -- Mage
		[9] = {GetClassInfo(9)}, -- Warlock
		[11] = {GetClassInfo(11)} -- Druid
	}
	local Colors = {
		name = L["Colors"],
		type = "group",
		order = 0,
		args = {
			classColors = {
				name = L["Class Colors"],
				type = "group",
				order = 0,
				inline = true,
				args = {
					useClassColorsAddon = {
						order = 0.01,
						type = "toggle",
						name = L["Use Class Colors addon"],
						desc = L["Sets if RUF will use class colours from the Class Colors addon if you have it installed."],
						disabled = not CUSTOM_CLASS_COLORS,
						get = function(info)
							if (CUSTOM_CLASS_COLORS) and RUF.db.profile.Appearance.Colors.UseClassColors then
								for classToken, color in next, CUSTOM_CLASS_COLORS do
									RUF.db.profile.Appearance.Colors.ClassColors[classToken] = {(color.r), (color.g), (color.b)}
								end
							end
							if not CUSTOM_CLASS_COLORS then
								RUF.db.profile.Appearance.Colors.UseClassColors = false
							end
							return RUF.db.profile.Appearance.Colors.UseClassColors
						end,
						set = function(info, value)
							if CUSTOM_CLASS_COLORS then
								RUF.db.profile.Appearance.Colors.UseClassColors = value
							else
								RUF.db.profile.Appearance.Colors.UseClassColors = false
							end
							if (CUSTOM_CLASS_COLORS) and RUF.db.profile.Appearance.Colors.UseClassColors then
								for classToken, color in next, CUSTOM_CLASS_COLORS do
									RUF.db.profile.Appearance.Colors.ClassColors[classToken] = {(color.r), (color.g), (color.b)}
								end
							end
							RUF:OptionsUpdateAllBars()
						end
					},
					setBlizzColors = {
						order = 0.02,
						type = "execute",
						name = L["Use Blizard Colors"],
						desc = L["Set class colors to the default Blizzard colors."],
						func = function(info, value)
							RUF.db.profile.Appearance.Colors.UseClassColors = false
							for classToken, color in next, RAID_CLASS_COLORS do
								RUF.db.profile.Appearance.Colors.ClassColors[classToken] = {(color.r), (color.g), (color.b)}
							end
							RUF:OptionsUpdateAllBars()
						end
					},
					spacer = {
						name = " ",
						type = "description",
						order = 0.05,
						width = "full"
					}
				}
			},
			powerColors = {
				name = L["Power Colors"],
				type = "group",
				order = 1,
				inline = true,
				args = {}
			},
			reactionColors = {
				name = L["Reaction Colors"],
				type = "group",
				order = 2,
				inline = true,
				args = {}
			},
			difficultyColors = {
				name = L["Difficulty Colors"],
				type = "group",
				order = 3,
				inline = true,
				args = {}
			},
			miscColors = {
				name = L["Misc Colors"],
				type = "group",
				order = 4,
				inline = true,
				args = {
					Disconnected = {
						name = L["Disconnected"],
						type = "color",
						order = 0,
						get = function(info)
							return unpack(RUF.db.profile.Appearance.Colors.MiscColors.Disconnected)
						end,
						set = function(info, r, g, b)
							RUF.db.profile.Appearance.Colors.MiscColors.Disconnected = {r, g, b}
							RUF:OptionsUpdateAllBars()
						end
					},
					Tapped = {
						name = L["Tapped"],
						type = "color",
						order = 0,
						get = function(info)
							return unpack(RUF.db.profile.Appearance.Colors.MiscColors.Tapped)
						end,
						set = function(info, r, g, b)
							RUF.db.profile.Appearance.Colors.MiscColors.Tapped = {r, g, b}
							RUF:OptionsUpdateAllBars()
						end
					}
				}
			}
		}
	}
	for i = 1, 11 do
		if classData[i] then
			Colors.args.classColors.args[classData[i][2]] = {
				name = classData[i][1],
				type = "color",
				order = 1,
				get = function(info)
					return unpack(RUF.db.profile.Appearance.Colors.ClassColors[classData[i][2]])
				end,
				set = function(info, r, g, b)
					RUF.db.profile.Appearance.Colors.ClassColors[classData[i][2]] = {r, g, b}
					RUF:OptionsUpdateAllBars()
				end
			}
		end
	end
	for i = 0, 6 do
		local power = Powers[i]
		if power then
			Colors.args.powerColors.args[power] = {
				name = power,
				type = "color",
				order = 0,
				get = function(info)
					return unpack(RUF.db.profile.Appearance.Colors.PowerColors[i])
				end,
				set = function(info, r, g, b)
					RUF.db.profile.Appearance.Colors.PowerColors[i] = {r, g, b}
					RUF:OptionsUpdateAllBars()
				end
			}
		end
	end
	for i = 1, #Reactions do
		if Reactions[i] then
			Colors.args.reactionColors.args[Reactions[i]] = {
				name = Reactions[i],
				type = "color",
				order = 20 + ((i) + 2) / 100,
				get = function(info)
					return unpack(RUF.db.profile.Appearance.Colors.ReactionColors[i])
				end,
				set = function(info, r, g, b)
					RUF.db.profile.Appearance.Colors.ReactionColors[i] = {r, g, b}
					RUF:OptionsUpdateAllBars()
				end
			}
		end
	end
	for i = 0, #Difficulties do
		if Difficulties[i] then
			Colors.args.difficultyColors.args[Difficulties[i]] = {
				name = Difficulties[i],
				type = "color",
				order = 30 + ((i) + 2) / 100,
				get = function(info)
					return unpack(RUF.db.profile.Appearance.Colors.DifficultyColors[i])
				end,
				set = function(info, r, g, b)
					RUF.db.profile.Appearance.Colors.DifficultyColors[i] = {r, g, b}
					RUF:OptionsUpdateAllBars()
				end
			}
		end
	end
	return Colors
end