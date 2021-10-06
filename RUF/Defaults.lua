assert(RUF, "RUF not found!")
local RUF = RUF
RUF.Layout = {}
local cfg = {
	global = {
		pixelScale = true,
		TestModeShowUnits = true
	},
	profile = {
		Appearance = {
			Border = {
				Glow = {
					Enabled = true,
					SoundEnabled = false,
					Offset = -1,
					Alpha = 0.75,
					Style = {
						edgeFile = "RUF Glow", -- Pixel Border settings.
						edgeSize = 14
					}
				},
				Style = {
					edgeFile = "RUF Pixel", -- Pixel Border settings.
					edgeSize = 1
				},
				Offset = 0,
				Color = {0, 0, 0},
				Alpha = 1
			},
			CombatFader = {
				Enabled = false,
				targetOverride = true,
				targetAlpha = 1,
				combatAlpha = 1,
				restAlpha = 0.5,
				damagedOverride = true,
				damagedPercent = 95,
				damagedAlpha = 1
			},
			Bars = {
				Health = {
					Texture = "RUF 5",
					Color = {
						BaseColor = {0.10, 0.10, 0.10},
						--colorHealth -- Set in Core to true automatically
						Class = false,
						Disconnected = true,
						Percentage = true,
						percentageMaxClass = false,
						percentage50Class = false,
						percentage0Class = true,
						PercentageGradient = {
							1,
							0,
							0.22, -- 0% HP: Magenta
							0.14,
							0.14,
							0.14, -- 50% HP: Grey
							0.14,
							0.14,
							0.14 -- 100% HP: Grey
						},
						Reaction = false,
						Tapped = true,
						Multiplier = 1
					},
					Background = {
						UseBarColor = false, -- Use Bar Color or Custom Color
						CustomColor = {0, 0, 0}, -- Custom Color Value
						Multiplier = 0.25, -- Reduce Bar Background Color brightness by this multiplier
						Alpha = 0.5
					}
				},
				Absorb = {
					Type = 1,
					Texture = "RUF 5",
					Color = {
						BaseColor = {1, 1, 1},
						Class = false,
						Reaction = false,
						Alpha = 0.25,
						Multiplier = 1
					},
					Border = {
						Style = {
							edgeFile = "RUF Pixel", -- Pixel Border settings.
							edgeSize = 1
						},
						Color = {0, 0, 0},
						Alpha = 1
					},
					Background = {
						UseBarColor = false,
						CustomColor = {0, 0, 0},
						Multiplier = 0.25,
						Alpha = 0.5
					}
				},
				Class = {
					Texture = "RUF 1",
					Color = {
						BaseColor = {0.39, 0.39, 0.39},
						Class = false,
						PowerType = true, -- Use Resource's Color
						Multiplier = 1,
						SegmentMultiplier = 10 -- Make the bars increase in brightness by this multiplier
					},
					Border = {
						Style = {
							edgeFile = "RUF Pixel", -- Pixel Border settings.
							edgeSize = 1
						},
						Color = {0, 0, 0},
						Alpha = 1
					},
					Background = {
						UseBarColor = true,
						CustomColor = {0, 0, 0},
						Multiplier = 0.25,
						Alpha = 0.5
					}
				},
				Power = {
					Texture = "RUF 1",
					Color = {
						BaseColor = {0.20, 0.20, 0.20},
						Class = false,
						Disconnected = false,
						Percentage = false,
						percentageMaxClass = false,
						percentage50Class = false,
						percentage0Class = false,
						percentageMaxPower = true,
						percentage50Power = true,
						percentage0Power = false,
						PercentageGradient = {
							1,
							1,
							1,
							0.10,
							0.10,
							0.10,
							0.10,
							0.10,
							0.10
						},
						Reaction = false,
						Tapped = false,
						PowerType = true,
						Multiplier = 1
					},
					Border = {
						Style = {
							edgeFile = "RUF Pixel", -- Pixel Border settings.
							edgeSize = 1
						},
						Color = {0, 0, 0},
						Alpha = 1
					},
					Background = {
						UseBarColor = true,
						CustomColor = {0, 0, 0},
						Multiplier = 0.25,
						Alpha = 0.5
					}
				},
				Cast = {
					Texture = "RUF 1",
					ColorInterrupt = {
						Enabled = true,
						Color = {0.78, 0.25, 0.25}
					},
					Color = {
						BaseColor = {1, 0.80, 0},
						Class = false,
						Reaction = false,
						PowerType = false,
						Multiplier = 1
					},
					Border = {
						Style = {
							edgeFile = "RUF Pixel", -- Pixel Border settings.
							edgeSize = 1
						},
						Color = {0, 0, 0},
						Alpha = 1
					},
					Background = {
						UseBarColor = true,
						CustomColor = {0, 0, 0},
						Multiplier = 0.25,
						Alpha = 0.5
					},
					SafeZone = {
						Enabled = true,
						Color = {0, 0.76, 1},
						Alpha = 1
					}
				},
				HealPrediction = {
					Overflow = 0,
					Player = {
						Texture = "RUF 5",
						Enabled = true,
						Color = {
							Alpha = 0.75,
							BaseColor = {0.20, 0.66, 0.25},
							--colorHealth -- Set in Core to true automatically
							Class = false,
							Percentage = false,
							percentageMaxClass = false,
							percentage50Class = false,
							percentage0Class = false,
							PercentageGradient = {
								1,
								0,
								0.22, -- 0% HP: Magenta
								0.14,
								0.14,
								0.14, -- 50% HP: Grey
								0.14,
								0.14,
								0.14 -- 100% HP: Grey
							},
							Reaction = false,
							Multiplier = 1
						}
					},
					Others = {
						Texture = "RUF 5",
						Enabled = true,
						Color = {
							Alpha = 0.75,
							BaseColor = {0.85, 0.77, 0.36},
							--colorHealth -- Set in Core to true automatically
							Class = false,
							Percentage = false,
							percentageMaxClass = false,
							percentage50Class = false,
							percentage0Class = false,
							PercentageGradient = {
								1,
								0,
								0.22, -- 0% HP: Magenta
								0.14,
								0.14,
								0.14, -- 50% HP: Grey
								0.14,
								0.14,
								0.14 -- 100% HP: Grey
							},
							Reaction = false,
							Multiplier = 1
						}
					}
				}
			},
			Aura = {
				Buff = true,
				Debuff = true,
				OnlyDispellable = true,
				Border = {
					Style = {
						edgeFile = "RUF Glow", -- Pixel Border settings.
						edgeSize = 6
					},
					Offset = -1 -- Inset from edge.
				},
				Pixel = {
					Enabled = true,
					Style = {
						edgeFile = "RUF Pixel", -- Pixel Border settings.
						edgeSize = 1
					},
					Offset = 0
				},
				spiral = {
					enabled = true,
					reverse = false
				}
			},
			Colors = {
				UseClassColors = true, -- Use ClassColors Addon
				ClassColors = {
					-- !ClassColors Addon Overrides these values.
					DEATHKNIGHT = {0.77, 0.12, 0.23},
					DRUID = {1, 0.49, 0.04},
					HUNTER = {0.67, 0.83, 0.45},
					MAGE = {0.25, 0.78, 0.92},
					PALADIN = {0.96, 0.55, 0.73},
					PRIEST = {1, 1, 1},
					ROGUE = {1, 0.96, 0.41},
					SHAMAN = {0, 0.44, 0.87},
					WARLOCK = {0.53, 0.53, 0.93},
					WARRIOR = {0.78, 0.61, 0.43}
				},
				MiscColors = {
					Tapped = {0.39, 0.39, 0.39},
					Disconnected = {0.59, 0.59, 0.59}
				},
				Aura = {
					DefaultBuff = {0, 0, 0, 0},
					DefaultDebuff = {0.71, 0, 0.08, 1},
					Pixel = {0, 0, 0, 1},
					Magic = {0, 0.62, 1, 1},
					Disease = {1, 0.61, 0, 1},
					Curse = {0.33, 0.17, 0.74, 1},
					Poison = {0.57, 0.75, 0.06, 1},
					Enrage = {1, 0, 0.56, 1}
				},
				DifficultyColors = {
					[0] = {1, 0.1, 0.1}, -- Impossible
					[1] = {1, 0.5, 0.25}, -- Hard
					[2] = {1, 0.82, 0}, -- Normal
					[3] = {0.25, 0.75, 0.25}, -- Easy
					[4] = {0.5, 0.5, 0.5} -- Trivial
				},
				PowerColors = {
					[0] = {0, 0.62, 1}, -- Mana
					[1] = {1, 0, 0.22}, -- Rage
					[2] = {1, 0.50, 0.25}, -- Focus
					[3] = {1, 1, 0}, -- Energy
					[4] = {1, 0.96, 0.41}, -- Combo Points
					[5] = {0.50, 0.50, 0.50}, -- Runes
					[6] = {0, 0.83, 1}, -- Runic Power
					[7] = {0.59, 0.47, 0.90}, -- Soul Shards
					[8] = {0.30, 0.52, 0.90}, -- Astral Power
					[9] = {0.95, 0.90, 0.60}, -- Holy Power
					[10] = {0, 0.62, 1}, -- Alternate Power
					[11] = {0, 0.50, 1}, -- Maelstrom
					[12] = {0, 0.97, 0.79}, -- Chi
					[13] = {0.40, 0, 0.80}, -- Insanity
					[14] = {1, 0.96, 0.41} -- Classic Combo Points
				},
				ReactionColors = {
					[1] = {0.90, 0.30, 0.22}, -- Hated
					[2] = {0.90, 0.30, 0.22}, -- Hostile Also Enemy Players and NPCs
					[3] = {0.75, 0.27, 0}, -- Unfriendly
					[4] = {0.90, 0.70, 0}, -- Neutral
					[5] = {0, 0.60, 0.10}, -- Friendly Also Allied Players
					[6] = {0, 0.60, 0.10}, -- Honored
					[7] = {0, 0.60, 0.10}, -- Revered
					[8] = {0, 0.60, 0.10} -- Exalted
				}
			},
			Text = {
				CurHPPerc = {
					Font = "RUF",
					Outline = "OUTLINE",
					Shadow = 0,
					Case = 1, -- 0,1,2 0 == Default, 1 == Uppercase, 2 == Lowercase
					ShowPercAtMax = true,
					Color = {
						BaseColor = {1, 1, 1},
						Class = false,
						Level = false,
						Percentage = true, -- Below 100%
						PercentageAtMax = true,
						PercentageGradient = {
							1,
							0,
							0,
							1,
							1,
							0,
							0,
							1,
							0
						},
						PowerType = false,
						Reaction = false
					}
				},
				CurMaxHPPerc = {
					Font = "RUF",
					Outline = "OUTLINE",
					Shadow = 0,
					Case = 1, -- 0,1,2 0 == Default, 1 == Uppercase, 2 == Lowercase
					ShowMaxAtMax = true,
					ShowPercAtMax = true,
					Color = {
						BaseColor = {1, 1, 1},
						Class = false,
						Level = false,
						Percentage = true, -- Below 100%
						PercentageAtMax = true,
						PercentageGradient = {
							1,
							0,
							0,
							1,
							1,
							0,
							0,
							1,
							0
						},
						PowerType = false,
						Reaction = false
					}
				},
				CurMaxHP = {
					Font = "RUF",
					Outline = "OUTLINE",
					Shadow = 0,
					Case = 1, -- 0,1,2 0 == Default, 1 == Uppercase, 2 == Lowercase
					ShowMaxAtMax = true,
					Color = {
						BaseColor = {1, 1, 1},
						Class = false,
						Level = false,
						Percentage = true, -- Below 100%
						PercentageAtMax = true,
						PercentageGradient = {
							1,
							0,
							0,
							1,
							1,
							0,
							0,
							1,
							0
						},
						PowerType = false,
						Reaction = false
					}
				},
				CurHP = {
					Font = "RUF",
					Outline = "OUTLINE",
					Shadow = 0,
					Case = 1, -- 0,1,2 0 == Default, 1 == Uppercase, 2 == Lowercase
					Color = {
						BaseColor = {1, 1, 1},
						Class = false,
						Level = false,
						Percentage = true, -- Below 100%
						PercentageAtMax = true,
						PercentageGradient = {
							1,
							0,
							0,
							1,
							1,
							0,
							0,
							1,
							0
						},
						PowerType = false,
						Reaction = false
					}
				},
				MaxHP = {
					Font = "RUF",
					Outline = "OUTLINE",
					Shadow = 0,
					Case = 1, -- 0,1,2 0 == Default, 1 == Uppercase, 2 == Lowercase
					Color = {
						BaseColor = {1, 1, 1},
						Class = false,
						Level = false,
						Percentage = true, -- Below 100%
						PercentageAtMax = true,
						PercentageGradient = {
							1,
							0,
							0,
							1,
							1,
							0,
							0,
							1,
							0
						},
						PowerType = false,
						Reaction = false
					}
				},
				HPPerc = {
					Font = "RUF",
					Outline = "OUTLINE",
					Shadow = 0,
					Case = 1, -- 0,1,2 0 == Default, 1 == Uppercase, 2 == Lowercase
					Color = {
						BaseColor = {1, 1, 1},
						Class = false,
						Level = false,
						Percentage = true, -- Below 100%
						PercentageAtMax = true,
						PercentageGradient = {
							1,
							0,
							0,
							1,
							1,
							0,
							0,
							1,
							0
						},
						PowerType = false,
						Reaction = false
					}
				},
				CurManaPerc = {
					Enabled = 1,
					HideWhenPrimaryIsMana = true,
					Case = 1, -- 0,1,2 0 == Default, 1 == Uppercase, 2 == Lowercase
					Color = {
						BaseColor = {1, 1, 1},
						Class = false,
						Level = false,
						Percentage = false, -- Below 100%
						PercentageAtMax = false,
						PercentageGradient = {
							1,
							0,
							0,
							1,
							1,
							0,
							0,
							1,
							0
						},
						PowerType = true,
						Reaction = false
					}
				},
				CurMana = {
					Enabled = 1,
					HideWhenPrimaryIsMana = true,
					Case = 1, -- 0,1,2 0 == Default, 1 == Uppercase, 2 == Lowercase
					Color = {
						BaseColor = {1, 1, 1},
						Class = false,
						Level = false,
						Percentage = false, -- Below 100%
						PercentageAtMax = false,
						PercentageGradient = {
							1,
							0,
							0,
							1,
							1,
							0,
							0,
							1,
							0
						},
						PowerType = true,
						Reaction = false
					}
				},
				ManaPerc = {
					Enabled = 1,
					HideWhenPrimaryIsMana = true,
					Case = 1, -- 0,1,2 0 == Default, 1 == Uppercase, 2 == Lowercase
					Color = {
						BaseColor = {1, 1, 1},
						Class = false,
						Level = false,
						Percentage = false, -- Below 100%
						PercentageAtMax = false,
						PercentageGradient = {
							1,
							0,
							0,
							1,
							1,
							0,
							0,
							1,
							0
						},
						PowerType = true,
						Reaction = false
					}
				},
				Name = {
					CharLimit = 18,
					Case = 1, -- 0,1,2 0 == Default, 1 == Uppercase, 2 == Lowercase
					Color = {
						BaseColor = {1, 1, 1},
						Class = true,
						Level = false,
						Percentage = false, -- Below 100%
						PercentageAtMax = false,
						PercentageGradient = {
							1,
							0,
							0,
							1,
							1,
							0,
							0,
							1,
							0
						},
						PowerType = false,
						Reaction = true
					}
				},
				CurPowerPerc = {
					Enabled = 1,
					Case = 1, -- 0,1,2 0 == Default, 1 == Uppercase, 2 == Lowercase
					Color = {
						BaseColor = {1, 1, 1},
						Class = false,
						Level = false,
						Percentage = false, -- Below 100%
						PercentageAtMax = false,
						PercentageGradient = {
							1,
							0,
							0,
							1,
							1,
							0,
							0,
							1,
							0
						},
						PowerType = true,
						Reaction = false
					}
				},
				CurPower = {
					Enabled = 1,
					Case = 1, -- 0,1,2 0 == Default, 1 == Uppercase, 2 == Lowercase
					Color = {
						BaseColor = {1, 1, 1},
						Class = false,
						Level = false,
						Percentage = false, -- Below 100%
						PercentageAtMax = false,
						PercentageGradient = {
							1,
							0,
							0,
							1,
							1,
							0,
							0,
							1,
							0
						},
						PowerType = true,
						Reaction = false
					}
				},
				PowerPerc = {
					Enabled = 1,
					Case = 1, -- 0,1,2 0 == Default, 1 == Uppercase, 2 == Lowercase
					Color = {
						BaseColor = {1, 1, 1},
						Class = false,
						Level = false,
						Percentage = false, -- Below 100%
						PercentageAtMax = false,
						PercentageGradient = {
							1,
							0,
							0,
							1,
							1,
							0,
							0,
							1,
							0
						},
						PowerType = true, -- Always Mana if tag is Raeli:Mana
						Reaction = false
					}
				},
				Level = {
					Case = 1, -- 0,1,2 0 == Default, 1 == Uppercase, 2 == Lowercase
					HideSameLevel = true,
					ShowLevel = true,
					ShowClassification = true,
					ClassificationBeforeLevel = true,
					Color = {
						BaseColor = {1, 1, 1},
						Class = false,
						Level = true,
						Percentage = false, -- Below 100%
						PercentageAtMax = false,
						PercentageGradient = {
							1,
							0,
							0,
							1,
							1,
							0,
							0,
							1,
							0
						},
						PowerType = false,
						Reaction = false
					}
				},
				AFKDND = {
					Case = 1, -- 0,1,2 0 == Default, 1 == Uppercase, 2 == Lowercase
					Color = {
						BaseColor = {1, 1, 1},
						Class = false,
						Level = false,
						Percentage = false, -- Below 100%
						PercentageAtMax = false,
						PercentageGradient = {
							1,
							0,
							0,
							1,
							1,
							0,
							0,
							1,
							0
						},
						PowerType = false,
						Reaction = false
					}
				}
			},
			disableBlizzard = {
				["player"] = true,
				["pet"] = true,
				["target"] = true,
				["focus"] = true,
				["targettarget"] = true,
				["boss"] = true,
				["party"] = true,
				["arena"] = true,
				["nameplate"] = false
			}
		},
		unit = {
			["player"] = {
				["Enabled"] = true,
				["Frame"] = {
					["Portrait"] = {
						["Enabled"] = false,
						["Style"] = 1,
						["Cutaway"] = true,
						["Width"] = 100,
						["Height"] = 60,
						["Alpha"] = 0.75,
						["Position"] = {
							["AnchorFrom"] = "TOPRIGHT",
							["AnchorTo"] = "TOPLEFT",
							["x"] = 1,
							["y"] = 0
						},
						["Border"] = {
							["Color"] = {0, 0, 0},
							["Alpha"] = 1,
							["Offset"] = 0,
							["Style"] = {
								["edgeFile"] = "RUF Pixel",
								["edgeSize"] = 1
							}
						},
						["Background"] = {
							["Color"] = {0, 0, 0},
							["Alpha"] = 0.5
						}
					},
					["Indicators"] = {
						["TargetMark"] = {
							["Enabled"] = true,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "RIGHT",
								["AnchorFrom"] = "LEFT",
								["AnchorFrame"] = "InCombat"
							}
						},
						["InCombat"] = {
							["Enabled"] = true,
							["Size"] = 20,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "CENTER",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Frame"
							}
						},
						["LootMaster"] = {
							["Enabled"] = true,
							["Size"] = 14,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "TOPLEFT",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Frame"
							}
						},
						["Lead"] = {
							["Enabled"] = true,
							["Size"] = 14,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "TOPRIGHT",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Frame"
							}
						},
						["Role"] = {
							["Enabled"] = true,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "LEFT",
								["AnchorFrom"] = "RIGHT",
								["AnchorFrame"] = "InCombat"
							}
						},
						["MainTankAssist"] = {
							["Enabled"] = true,
							["Size"] = 12,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "LEFT",
								["AnchorFrom"] = "RIGHT",
								["AnchorFrame"] = "Lead"
							}
						},
						["PvPCombat"] = {
							["Enabled"] = true,
							["Size"] = 28,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "RIGHT",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Frame"
							}
						},
						["Assist"] = {
							["Enabled"] = true,
							["Size"] = 14,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "CENTER",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Lead"
							}
						},
						["PetHappiness"] = {
							["Enabled"] = false,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = -2,
								["AnchorTo"] = "LEFT",
								["AnchorFrom"] = "RIGHT",
								["AnchorFrame"] = "Frame"
							}
						},
						["Rest"] = {
							["Enabled"] = true,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "TOPRIGHT",
								["AnchorFrom"] = "BOTTOMLEFT",
								["AnchorFrame"] = "Frame"
							}
						},
						["Ready"] = {
							["Enabled"] = true,
							["Size"] = 36,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 10,
								["AnchorTo"] = "RIGHT",
								["AnchorFrom"] = "LEFT",
								["AnchorFrame"] = "Frame"
							}
						}
					},
					["Position"] = {
						["y"] = -200,
						["x"] = -390,
						["AnchorTo"] = "CENTER",
						["AnchorFrom"] = "CENTER",
						["AnchorFrame"] = "UIParent"
					},
					["Text"] = {
						["Health"] = {
							["Outline"] = "OUTLINE",
							["Font"] = "RUF",
							["Width"] = 150,
							["Position"] = {
								["y"] = 4,
								["x"] = -4,
								["AnchorTo"] = "RIGHT",
								["Anchor"] = "RIGHT",
								["AnchorFrame"] = "Frame"
							},
							["Size"] = 28,
							["Enabled"] = true,
							["Shadow"] = 0,
							["Tag"] = "[RUF:CurHPPerc]"
						},
						["Power"] = {
							["Outline"] = "OUTLINE",
							["Font"] = "RUF",
							["Width"] = 100,
							["Position"] = {
								["y"] = 3,
								["x"] = -4,
								["AnchorTo"] = "BOTTOMRIGHT",
								["Anchor"] = "BOTTOMRIGHT",
								["AnchorFrame"] = "Frame"
							},
							["Size"] = 18,
							["Enabled"] = true,
							["Shadow"] = 0,
							["Tag"] = "[RUF:CurPowerPerc]"
						},
						["Mana"] = {
							["Outline"] = "OUTLINE",
							["Font"] = "RUF",
							["Width"] = 100,
							["Position"] = {
								["y"] = 0,
								["x"] = 1,
								["AnchorTo"] = "LEFT",
								["Anchor"] = "RIGHT",
								["AnchorFrame"] = "Power"
							},
							["Size"] = 18,
							["Enabled"] = true,
							["Shadow"] = 0,
							["Tag"] = "[RUF:CurMana]"
						},
						["Level"] = {
							["Outline"] = "OUTLINE",
							["Font"] = "RUF",
							["Width"] = 100,
							["Position"] = {
								["y"] = 3,
								["x"] = 4,
								["AnchorTo"] = "BOTTOMLEFT",
								["Anchor"] = "BOTTOMLEFT",
								["AnchorFrame"] = "Frame"
							},
							["Size"] = 18,
							["Enabled"] = true,
							["Shadow"] = 0,
							["Tag"] = "[RUF:Level]"
						},
						["Name"] = {
							["Outline"] = "OUTLINE",
							["Font"] = "RUF",
							["Width"] = 100,
							["Position"] = {
								["y"] = 4,
								["x"] = 4,
								["AnchorTo"] = "LEFT",
								["Anchor"] = "LEFT",
								["AnchorFrame"] = "Frame"
							},
							["Size"] = 21,
							["Enabled"] = true,
							["Shadow"] = 0,
							["Tag"] = "[RUF:Name]"
						},
						["AFKDND"] = {
							["Outline"] = "OUTLINE",
							["Shadow"] = 0,
							["Tag"] = "[RUF:AFKDND]",
							["Position"] = {
								["y"] = 1,
								["x"] = -2,
								["AnchorTo"] = "RIGHT",
								["Anchor"] = "LEFT",
								["AnchorFrame"] = "Name"
							},
							["Enabled"] = true,
							["Size"] = 21,
							["Font"] = "RUF",
							["Width"] = 100
						}
					},
					["RangeFading"] = {
						["Enabled"] = true,
						["Alpha"] = 0.5
					},
					["Bars"] = {
						["Cast"] = {
							["Enabled"] = true,
							["Position"] = {
								["y"] = -38,
								["x"] = 0,
								["AnchorTo"] = "BOTTOM",
								["AnchorFrom"] = "TOP",
								["AnchorFrame"] = true
							},
							["Height"] = 26,
							["Fill"] = "STANDARD",
							["Width"] = 300,
							["Time"] = {
								["Enabled"] = true,
								["Font"] = "RUF",
								["Size"] = 18,
								["Outline"] = "OUTLINE",
								["Shadow"] = 0,
								["Style"] = 3
							},
							["Text"] = {
								["Enabled"] = true,
								["Font"] = "RUF",
								["Size"] = 18,
								["Outline"] = "OUTLINE",
								["Shadow"] = 0
							}
						},
						["Absorb"] = {
							["Animate"] = true,
							["Enabled"] = 1,
							["Fill"] = "STANDARD",
							["Height"] = 8,
							["Position"] = {
								["Anchor"] = "BOTTOM",
								["Order"] = 1
							}
						},
						["Health"] = {
							["Animate"] = true,
							["Fill"] = "STANDARD",
							["rainbow"] = {
								["enabled"] = false
							}
						},
						["Power"] = {
							["Animate"] = true,
							["Enabled"] = 1,
							["Fill"] = "STANDARD",
							["Height"] = 8,
							["Position"] = {
								["Anchor"] = "BOTTOM",
								["Order"] = 0
							}
						},
						["Class"] = {
							["Animate"] = true,
							["Enabled"] = true,
							["Fill"] = "STANDARD",
							["Height"] = 8,
							["Position"] = {
								["Anchor"] = "TOP"
							}
						}
					},
					["Size"] = {
						["Height"] = 60,
						["Width"] = 300
					}
				},
				["Debuffs"] = {
					["Icons"] = {
						["Enabled"] = true,
						["Columns"] = 5,
						["Max"] = 15,
						["Rows"] = 1,
						["Growth"] = {
							["y"] = "UP",
							["x"] = "LEFT"
						},
						["Width"] = 28,
						["CooldownSpiral"] = true,
						["Sort"] = {
							["SortBy"] = "Remaining",
							["Direction"] = "Descending"
						},
						["Spacing"] = {
							["y"] = -1,
							["x"] = 1
						},
						["Height"] = 28,
						["Filter"] = {
							["BlackOrWhite"] = "Black",
							["Dispellable"] = false,
							["Time"] = {
								["Max"] = 0,
								["Min"] = 0,
								["Unlimited"] = true
							},
							["Caster"] = {
								["Group"] = true,
								["Player"] = true,
								["Other"] = true,
								["Unit"] = true
							},
							["Lists"] = {}
						},
						["Position"] = {
							["y"] = 1,
							["x"] = 0,
							["AnchorTo"] = "TOPRIGHT",
							["AnchorFrom"] = "BOTTOMRIGHT",
							["AnchorFrame"] = "Frame"
						},
						["ClickThrough"] = false
					},
					["Bars"] = {}
				},
				["Buffs"] = {
					["Icons"] = {
						["Enabled"] = true,
						["Columns"] = 5,
						["Max"] = 15,
						["Rows"] = 1,
						["Growth"] = {
							["y"] = "UP",
							["x"] = "RIGHT"
						},
						["Width"] = 28,
						["CooldownSpiral"] = true,
						["Sort"] = {
							["SortBy"] = "Remaining",
							["Direction"] = "Descending"
						},
						["Spacing"] = {
							["y"] = 1,
							["x"] = 1
						},
						["Height"] = 28,
						["Filter"] = {
							["BlackOrWhite"] = "Black",
							["Dispellable"] = false,
							["Time"] = {
								["Max"] = 0,
								["Min"] = 0,
								["Unlimited"] = false
							},
							["Caster"] = {
								["Group"] = false,
								["Player"] = true,
								["Other"] = true,
								["Unit"] = true
							},
							["Lists"] = {}
						},
						["Position"] = {
							["y"] = 1,
							["x"] = 0,
							["AnchorTo"] = "TOPLEFT",
							["AnchorFrom"] = "BOTTOMLEFT",
							["AnchorFrame"] = "Frame"
						},
						["ClickThrough"] = false
					},
					["Bars"] = {}
				}
			},
			["target"] = {
				["Enabled"] = true,
				["Frame"] = {
					["Portrait"] = {
						["Enabled"] = false,
						["Style"] = 1,
						["Cutaway"] = true,
						["Width"] = 100,
						["Height"] = 60,
						["Alpha"] = 0.75,
						["Position"] = {
							["AnchorFrom"] = "TOPLEFT",
							["AnchorTo"] = "TOPRIGHT",
							["x"] = -1,
							["y"] = 0
						},
						["Border"] = {
							["Color"] = {0, 0, 0},
							["Alpha"] = 1,
							["Offset"] = 0,
							["Style"] = {
								["edgeFile"] = "RUF Pixel",
								["edgeSize"] = 1
							}
						},
						["Background"] = {
							["Color"] = {0, 0, 0},
							["Alpha"] = 0.5
						}
					},
					["Indicators"] = {
						["TargetMark"] = {
							["Enabled"] = true,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "LEFT",
								["AnchorFrom"] = "RIGHT",
								["AnchorFrame"] = "Frame"
							}
						},
						["LootMaster"] = {
							["Enabled"] = true,
							["Size"] = 14,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "TOPRIGHT",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Frame"
							}
						},
						["Lead"] = {
							["Enabled"] = true,
							["Size"] = 14,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "TOPLEFT",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Frame"
							}
						},
						["Role"] = {
							["Enabled"] = true,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "RIGHT",
								["AnchorFrom"] = "LEFT",
								["AnchorFrame"] = "Frame"
							}
						},
						["MainTankAssist"] = {
							["Enabled"] = true,
							["Size"] = 12,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "RIGHT",
								["AnchorFrom"] = "LEFT",
								["AnchorFrame"] = "Lead"
							}
						},
						["PvPCombat"] = {
							["Enabled"] = true,
							["Size"] = 28,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "LEFT",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Frame"
							}
						},
						["Assist"] = {
							["Enabled"] = true,
							["Size"] = 14,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "CENTER",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Lead"
							}
						},
						["PetHappiness"] = {
							["Enabled"] = false,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 2,
								["AnchorTo"] = "RIGHT",
								["AnchorFrom"] = "LEFT",
								["AnchorFrame"] = "Frame"
							}
						},
						["Rest"] = {
							["Enabled"] = false,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "CENTER",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Frame"
							}
						},
						["Ready"] = {
							["Enabled"] = true,
							["Size"] = 36,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = -10,
								["AnchorTo"] = "LEFT",
								["AnchorFrom"] = "RIGHT",
								["AnchorFrame"] = "Frame"
							}
						}
					},
					["Position"] = {
						["y"] = -200,
						["x"] = 390,
						["AnchorTo"] = "CENTER",
						["AnchorFrom"] = "CENTER",
						["AnchorFrame"] = "UIParent"
					},
					["Text"] = {
						["Health"] = {
							["Outline"] = "OUTLINE",
							["Font"] = "RUF",
							["Width"] = 150,
							["Position"] = {
								["y"] = 4,
								["x"] = 4,
								["AnchorTo"] = "LEFT",
								["Anchor"] = "LEFT",
								["AnchorFrame"] = "Frame"
							},
							["Size"] = 28,
							["Enabled"] = true,
							["Shadow"] = 0,
							["Tag"] = "[RUF:CurHPPerc]"
						},
						["Power"] = {
							["Outline"] = "OUTLINE",
							["Font"] = "RUF",
							["Width"] = 100,
							["Position"] = {
								["y"] = 3,
								["x"] = 4,
								["AnchorTo"] = "BOTTOMLEFT",
								["Anchor"] = "BOTTOMLEFT",
								["AnchorFrame"] = "Frame"
							},
							["Size"] = 18,
							["Enabled"] = true,
							["Shadow"] = 0,
							["Tag"] = "[RUF:CurPowerPerc]"
						},
						["Level"] = {
							["Outline"] = "OUTLINE",
							["Font"] = "RUF",
							["Width"] = 100,
							["Position"] = {
								["y"] = 3,
								["x"] = -4,
								["AnchorTo"] = "BOTTOMRIGHT",
								["Anchor"] = "BOTTOMRIGHT",
								["AnchorFrame"] = "Frame"
							},
							["Size"] = 18,
							["Enabled"] = true,
							["Shadow"] = 0,
							["Tag"] = "[RUF:Level]"
						},
						["Name"] = {
							["Outline"] = "OUTLINE",
							["Font"] = "RUF",
							["Width"] = 100,
							["Position"] = {
								["y"] = 4,
								["x"] = -4,
								["AnchorTo"] = "RIGHT",
								["Anchor"] = "RIGHT",
								["AnchorFrame"] = "Frame"
							},
							["Size"] = 21,
							["Enabled"] = true,
							["Shadow"] = 0,
							["Tag"] = "[RUF:Name]"
						},
						["AFKDND"] = {
							["Outline"] = "OUTLINE",
							["Shadow"] = 0,
							["Tag"] = "[RUF:AFKDND]",
							["Position"] = {
								["y"] = 1,
								["x"] = 2,
								["AnchorTo"] = "LEFT",
								["Anchor"] = "RIGHT",
								["AnchorFrame"] = "Name"
							},
							["Enabled"] = true,
							["Size"] = 21,
							["Font"] = "RUF",
							["Width"] = 100
						}
					},
					["RangeFading"] = {
						["Enabled"] = true,
						["Alpha"] = 0.5
					},
					["Bars"] = {
						["Cast"] = {
							["Enabled"] = true,
							["Position"] = {
								["y"] = -38,
								["x"] = 0,
								["AnchorTo"] = "BOTTOM",
								["AnchorFrom"] = "TOP",
								["AnchorFrame"] = true
							},
							["Height"] = 26,
							["Fill"] = "REVERSE",
							["Width"] = 300,
							["Time"] = {
								["Enabled"] = true,
								["Font"] = "RUF",
								["Size"] = 18,
								["Outline"] = "OUTLINE",
								["Shadow"] = 0,
								["Style"] = 3
							},
							["Text"] = {
								["Enabled"] = true,
								["Font"] = "RUF",
								["Size"] = 18,
								["Outline"] = "OUTLINE",
								["Shadow"] = 0
							}
						},
						["Absorb"] = {
							["Animate"] = true,
							["Enabled"] = 1,
							["Fill"] = "REVERSE",
							["Height"] = 8,
							["Position"] = {
								["Anchor"] = "BOTTOM",
								["Order"] = 1
							}
						},
						["Health"] = {
							["Animate"] = true,
							["Fill"] = "REVERSE",
							["rainbow"] = {
								["enabled"] = false
							}
						},
						["Power"] = {
							["Animate"] = true,
							["Enabled"] = 1,
							["Fill"] = "REVERSE",
							["Height"] = 8,
							["Position"] = {
								["Anchor"] = "BOTTOM",
								["Order"] = 0
							}
						},
						["Class"] = {
							["Animate"] = true,
							["Enabled"] = true,
							["Fill"] = "REVERSE",
							["Height"] = 8,
							["Position"] = {
								["Anchor"] = "TOP"
							}
						}
					},
					["Size"] = {
						["Height"] = 60,
						["Width"] = 300
					}
				},
				["Debuffs"] = {
					["Icons"] = {
						["Enabled"] = true,
						["Columns"] = 5,
						["Max"] = 15,
						["Rows"] = 1,
						["Growth"] = {
							["y"] = "UP",
							["x"] = "RIGHT"
						},
						["Width"] = 28,
						["CooldownSpiral"] = true,
						["Sort"] = {
							["SortBy"] = "Remaining",
							["Direction"] = "Descending"
						},
						["Spacing"] = {
							["y"] = -1,
							["x"] = 1
						},
						["Height"] = 28,
						["Filter"] = {
							["BlackOrWhite"] = "Black",
							["Dispellable"] = false,
							["Time"] = {
								["Max"] = 0,
								["Min"] = 0,
								["Unlimited"] = true
							},
							["Caster"] = {
								["Group"] = false,
								["Player"] = true,
								["Other"] = false,
								["Unit"] = true
							},
							["Lists"] = {}
						},
						["Position"] = {
							["y"] = 1,
							["x"] = 0,
							["AnchorTo"] = "TOPLEFT",
							["AnchorFrom"] = "BOTTOMLEFT",
							["AnchorFrame"] = "Frame"
						},
						["ClickThrough"] = false
					},
					["Bars"] = {}
				},
				["Buffs"] = {
					["Icons"] = {
						["Enabled"] = true,
						["Columns"] = 5,
						["Max"] = 15,
						["Rows"] = 1,
						["Growth"] = {
							["y"] = "UP",
							["x"] = "LEFT"
						},
						["Width"] = 28,
						["CooldownSpiral"] = true,
						["Sort"] = {
							["SortBy"] = "Remaining",
							["Direction"] = "Descending"
						},
						["Spacing"] = {
							["y"] = 1,
							["x"] = 1
						},
						["Height"] = 28,
						["Filter"] = {
							["BlackOrWhite"] = "Black",
							["Dispellable"] = false,
							["Time"] = {
								["Max"] = 0,
								["Min"] = 0,
								["Unlimited"] = false
							},
							["Caster"] = {
								["Group"] = false,
								["Player"] = true,
								["Other"] = false,
								["Unit"] = true
							},
							["Lists"] = {}
						},
						["Position"] = {
							["y"] = 1,
							["x"] = 0,
							["AnchorTo"] = "TOPRIGHT",
							["AnchorFrom"] = "BOTTOMRIGHT",
							["AnchorFrame"] = "Frame"
						},
						["ClickThrough"] = false
					},
					["Bars"] = {}
				}
			},
			["focus"] = {
				["Enabled"] = true,
				["Frame"] = {
					["Portrait"] = {
						["Enabled"] = false,
						["Style"] = 1,
						["Cutaway"] = true,
						["Width"] = 100,
						["Height"] = 60,
						["Alpha"] = 0.75,
						["Position"] = {
							["AnchorFrom"] = "TOPLEFT",
							["AnchorTo"] = "TOPRIGHT",
							["x"] = -1,
							["y"] = 0
						},
						["Border"] = {
							["Color"] = {0, 0, 0},
							["Alpha"] = 1,
							["Offset"] = 0,
							["Style"] = {
								["edgeFile"] = "RUF Pixel",
								["edgeSize"] = 1
							}
						},
						["Background"] = {
							["Color"] = {0, 0, 0},
							["Alpha"] = 0.5
						}
					},
					["Indicators"] = {
						["TargetMark"] = {
							["Enabled"] = true,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 13,
								["x"] = 0,
								["AnchorTo"] = "RIGHT",
								["AnchorFrom"] = "LEFT",
								["AnchorFrame"] = "Frame"
							}
						},
						["InCombat"] = {
							["Enabled"] = true,
							["Size"] = 20,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "CENTER",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Frame"
							}
						},
						["LootMaster"] = {
							["Enabled"] = true,
							["Size"] = 14,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "TOPLEFT",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Frame"
							}
						},
						["Lead"] = {
							["Enabled"] = true,
							["Size"] = 14,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "TOPRIGHT",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Frame"
							}
						},
						["Role"] = {
							["Enabled"] = true,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = -13,
								["x"] = 0,
								["AnchorTo"] = "LEFT",
								["AnchorFrom"] = "RIGHT",
								["AnchorFrame"] = "Frame"
							}
						},
						["MainTankAssist"] = {
							["Enabled"] = true,
							["Size"] = 12,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "LEFT",
								["AnchorFrom"] = "RIGHT",
								["AnchorFrame"] = "Lead"
							}
						},
						["PvPCombat"] = {
							["Enabled"] = true,
							["Size"] = 28,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "RIGHT",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Frame"
							}
						},
						["Assist"] = {
							["Enabled"] = true,
							["Size"] = 14,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "CENTER",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Lead"
							}
						},
						["PetHappiness"] = {
							["Enabled"] = false,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = -2,
								["AnchorTo"] = "LEFT",
								["AnchorFrom"] = "RIGHT",
								["AnchorFrame"] = "Frame"
							}
						},
						["Rest"] = {
							["Enabled"] = true,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "TOPRIGHT",
								["AnchorFrom"] = "BOTTOMLEFT",
								["AnchorFrame"] = "Frame"
							}
						},
						["Ready"] = {
							["Enabled"] = true,
							["Size"] = 36,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 10,
								["AnchorTo"] = "RIGHT",
								["AnchorFrom"] = "LEFT",
								["AnchorFrame"] = "Frame"
							}
						}
					},
					["Position"] = {
						["y"] = 160,
						["x"] = 4,
						["AnchorTo"] = "LEFT",
						["AnchorFrom"] = "LEFT",
						["AnchorFrame"] = "UIParent"
					},
					["Text"] = {
						["Health"] = {
							["Outline"] = "OUTLINE",
							["Font"] = "RUF",
							["Width"] = 150,
							["Position"] = {
								["y"] = 4,
								["x"] = -4,
								["AnchorTo"] = "RIGHT",
								["Anchor"] = "RIGHT",
								["AnchorFrame"] = "Frame"
							},
							["Size"] = 28,
							["Enabled"] = true,
							["Shadow"] = 0,
							["Tag"] = "[RUF:CurHPPerc]"
						},
						["Power"] = {
							["Outline"] = "OUTLINE",
							["Font"] = "RUF",
							["Width"] = 100,
							["Position"] = {
								["y"] = 3,
								["x"] = -4,
								["AnchorTo"] = "BOTTOMRIGHT",
								["Anchor"] = "BOTTOMRIGHT",
								["AnchorFrame"] = "Frame"
							},
							["Size"] = 18,
							["Enabled"] = true,
							["Shadow"] = 0,
							["Tag"] = "[RUF:CurPowerPerc]"
						},
						["Level"] = {
							["Outline"] = "OUTLINE",
							["Font"] = "RUF",
							["Width"] = 100,
							["Position"] = {
								["y"] = 3,
								["x"] = 4,
								["AnchorTo"] = "BOTTOMLEFT",
								["Anchor"] = "BOTTOMLEFT",
								["AnchorFrame"] = "Frame"
							},
							["Size"] = 18,
							["Enabled"] = true,
							["Shadow"] = 0,
							["Tag"] = "[RUF:Level]"
						},
						["Name"] = {
							["Outline"] = "OUTLINE",
							["Font"] = "RUF",
							["Width"] = 100,
							["Position"] = {
								["y"] = 4,
								["x"] = 4,
								["AnchorTo"] = "LEFT",
								["Anchor"] = "LEFT",
								["AnchorFrame"] = "Frame"
							},
							["Size"] = 21,
							["Enabled"] = true,
							["Shadow"] = 0,
							["Tag"] = "[RUF:Name]"
						},
						["AFKDND"] = {
							["Outline"] = "OUTLINE",
							["Shadow"] = 0,
							["Tag"] = "[RUF:AFKDND]",
							["Position"] = {
								["y"] = 1,
								["x"] = -2,
								["AnchorTo"] = "RIGHT",
								["Anchor"] = "LEFT",
								["AnchorFrame"] = "Name"
							},
							["Enabled"] = true,
							["Size"] = 21,
							["Font"] = "RUF",
							["Width"] = 100
						}
					},
					["RangeFading"] = {
						["Enabled"] = true,
						["Alpha"] = 0.5
					},
					["Bars"] = {
						["Cast"] = {
							["Enabled"] = true,
							["Position"] = {
								["y"] = -38,
								["x"] = 0,
								["AnchorTo"] = "BOTTOM",
								["AnchorFrom"] = "TOP",
								["AnchorFrame"] = true
							},
							["Height"] = 26,
							["Fill"] = "STANDARD",
							["Width"] = 300,
							["Time"] = {
								["Enabled"] = true,
								["Font"] = "RUF",
								["Size"] = 18,
								["Outline"] = "OUTLINE",
								["Shadow"] = 0,
								["Style"] = 3
							},
							["Text"] = {
								["Enabled"] = true,
								["Font"] = "RUF",
								["Size"] = 18,
								["Outline"] = "OUTLINE",
								["Shadow"] = 0
							}
						},
						["Absorb"] = {
							["Animate"] = true,
							["Enabled"] = 1,
							["Fill"] = "STANDARD",
							["Height"] = 8,
							["Position"] = {
								["Anchor"] = "BOTTOM",
								["Order"] = 1
							}
						},
						["Health"] = {
							["Animate"] = true,
							["Fill"] = "STANDARD",
							["rainbow"] = {
								["enabled"] = false
							}
						},
						["Power"] = {
							["Animate"] = true,
							["Enabled"] = 1,
							["Fill"] = "STANDARD",
							["Height"] = 8,
							["Position"] = {
								["Anchor"] = "BOTTOM",
								["Order"] = 0
							}
						},
						["Class"] = {
							["Animate"] = true,
							["Enabled"] = true,
							["Fill"] = "STANDARD",
							["Height"] = 8,
							["Position"] = {
								["Anchor"] = "TOP"
							}
						}
					},
					["Size"] = {
						["Height"] = 60,
						["Width"] = 300
					}
				},
				["Debuffs"] = {
					["Icons"] = {
						["Enabled"] = true,
						["Columns"] = 5,
						["Max"] = 5,
						["Rows"] = 1,
						["Growth"] = {
							["y"] = "DOWN",
							["x"] = "RIGHT"
						},
						["Width"] = 28,
						["CooldownSpiral"] = true,
						["Sort"] = {
							["SortBy"] = "Remaining",
							["Direction"] = "Descending"
						},
						["Spacing"] = {
							["y"] = -1,
							["x"] = 1
						},
						["Height"] = 28,
						["Filter"] = {
							["BlackOrWhite"] = "Black",
							["Dispellable"] = false,
							["Time"] = {
								["Max"] = 0,
								["Min"] = 0,
								["Unlimited"] = false
							},
							["Caster"] = {
								["Group"] = false,
								["Player"] = true,
								["Other"] = false,
								["Unit"] = true
							},
							["Lists"] = {}
						},
						["Position"] = {
							["y"] = 0,
							["x"] = 1,
							["AnchorTo"] = "BOTTOMRIGHT",
							["AnchorFrom"] = "BOTTOMLEFT",
							["AnchorFrame"] = "Frame"
						},
						["ClickThrough"] = false
					},
					["Bars"] = {}
				},
				["Buffs"] = {
					["Icons"] = {
						["Enabled"] = true,
						["Columns"] = 5,
						["Max"] = 5,
						["Rows"] = 1,
						["Growth"] = {
							["y"] = "UP",
							["x"] = "RIGHT"
						},
						["Width"] = 28,
						["CooldownSpiral"] = true,
						["Sort"] = {
							["SortBy"] = "Remaining",
							["Direction"] = "Descending"
						},
						["Spacing"] = {
							["y"] = 1,
							["x"] = 1
						},
						["Height"] = 28,
						["Filter"] = {
							["BlackOrWhite"] = "Black",
							["Dispellable"] = false,
							["Time"] = {
								["Max"] = 0,
								["Min"] = 0,
								["Unlimited"] = false
							},
							["Caster"] = {
								["Group"] = false,
								["Player"] = true,
								["Other"] = false,
								["Unit"] = true
							},
							["Lists"] = {}
						},
						["Position"] = {
							["y"] = 0,
							["x"] = 1,
							["AnchorTo"] = "TOPRIGHT",
							["AnchorFrom"] = "TOPLEFT",
							["AnchorFrame"] = "Frame"
						},
						["ClickThrough"] = false
					},
					["Bars"] = {}
				}
			},
			["pet"] = {
				["Enabled"] = true,
				["Frame"] = {
					["Portrait"] = {
						["Enabled"] = false,
						["Style"] = 1,
						["Cutaway"] = true,
						["Width"] = 60,
						["Height"] = 30,
						["Alpha"] = 0.75,
						["Position"] = {
							["AnchorFrom"] = "TOPRIGHT",
							["AnchorTo"] = "TOPLEFT",
							["x"] = 1,
							["y"] = 0
						},
						["Border"] = {
							["Color"] = {0, 0, 0},
							["Alpha"] = 1,
							["Offset"] = 0,
							["Style"] = {
								["edgeFile"] = "RUF Pixel",
								["edgeSize"] = 1
							}
						},
						["Background"] = {
							["Color"] = {0, 0, 0},
							["Alpha"] = 0.5
						}
					},
					["Indicators"] = {
						["LootMaster"] = {
							["Enabled"] = false,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "TOPLEFT",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Frame"
							}
						},
						["Lead"] = {
							["Enabled"] = false,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "TOPRIGHT",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Frame"
							}
						},
						["Role"] = {
							["Enabled"] = false,
							["Size"] = 18,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = -2,
								["x"] = 50,
								["AnchorTo"] = "CENTER",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Frame"
							}
						},
						["MainTankAssist"] = {
							["Enabled"] = false,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "LEFT",
								["AnchorFrom"] = "RIGHT",
								["AnchorFrame"] = "Lead"
							}
						},
						["PvPCombat"] = {
							["Enabled"] = false,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "BOTTOMRIGHT",
								["AnchorFrom"] = "BOTTOM",
								["AnchorFrame"] = "Frame"
							}
						},
						["Assist"] = {
							["Enabled"] = false,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "CENTER",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Lead"
							}
						},
						["PetHappiness"] = {
							["Enabled"] = true,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = -2,
								["AnchorTo"] = "LEFT",
								["AnchorFrom"] = "RIGHT",
								["AnchorFrame"] = "Frame"
							}
						},
						["TargetMark"] = {
							["Enabled"] = true,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "CENTER",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Frame"
							}
						},
						["Ready"] = {
							["Enabled"] = false,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = -2,
								["x"] = -50,
								["AnchorTo"] = "CENTER",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Frame"
							}
						}
					},
					["Position"] = {
						["y"] = -4,
						["x"] = 0,
						["AnchorTo"] = "BOTTOM",
						["AnchorFrom"] = "TOP",
						["AnchorFrame"] = "oUF_RUF_Player"
					},
					["Text"] = {
						["Name"] = {
							["Outline"] = "OUTLINE",
							["Font"] = "RUF",
							["Width"] = 100,
							["Position"] = {
								["y"] = 1,
								["x"] = 4,
								["AnchorTo"] = "LEFT",
								["Anchor"] = "LEFT",
								["AnchorFrame"] = "Frame"
							},
							["Size"] = 21,
							["Enabled"] = true,
							["Shadow"] = 0,
							["Tag"] = "[RUF:Name]"
						},
						["Level"] = {
							["Outline"] = "OUTLINE",
							["Font"] = "RUF",
							["Width"] = 100,
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "CENTER",
								["Anchor"] = "CENTER",
								["AnchorFrame"] = "Frame"
							},
							["Size"] = 18,
							["Enabled"] = false,
							["Shadow"] = 0,
							["Tag"] = "[RUF:Level]"
						},
						["Health"] = {
							["Outline"] = "OUTLINE",
							["Font"] = "RUF",
							["Width"] = 150,
							["Position"] = {
								["y"] = 1,
								["x"] = -4,
								["AnchorTo"] = "RIGHT",
								["Anchor"] = "RIGHT",
								["AnchorFrame"] = "Frame"
							},
							["Size"] = 21,
							["Enabled"] = true,
							["Shadow"] = 0,
							["Tag"] = "[RUF:CurHPPerc]"
						},
						["Power"] = {
							["Outline"] = "OUTLINE",
							["Font"] = "RUF",
							["Width"] = 100,
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "CENTER",
								["Anchor"] = "CENTER",
								["AnchorFrame"] = "Frame"
							},
							["Size"] = 18,
							["Enabled"] = false,
							["Shadow"] = 0,
							["Tag"] = "[RUF:CurPowerPerc]"
						}
					},
					["RangeFading"] = {
						["Enabled"] = true,
						["Alpha"] = 0.5
					},
					["Bars"] = {
						["Cast"] = {
							["Enabled"] = false,
							["Position"] = {
								["y"] = -38,
								["x"] = 0,
								["AnchorTo"] = "BOTTOM",
								["AnchorFrom"] = "TOP",
								["AnchorFrame"] = true
							},
							["Height"] = 26,
							["Fill"] = "STANDARD",
							["Width"] = 300,
							["Time"] = {
								["Enabled"] = true,
								["Font"] = "RUF",
								["Size"] = 18,
								["Outline"] = "OUTLINE",
								["Shadow"] = 0,
								["Style"] = 3
							},
							["Text"] = {
								["Enabled"] = true,
								["Font"] = "RUF",
								["Size"] = 18,
								["Outline"] = "OUTLINE",
								["Shadow"] = 0
							}
						},
						["Absorb"] = {
							["Animate"] = true,
							["Enabled"] = 1,
							["Fill"] = "STANDARD",
							["Height"] = 8,
							["Position"] = {
								["Anchor"] = "BOTTOM",
								["Order"] = 1
							}
						},
						["Health"] = {
							["Animate"] = true,
							["Fill"] = "STANDARD",
							["rainbow"] = {
								["enabled"] = false
							}
						},
						["Power"] = {
							["Animate"] = true,
							["Enabled"] = 1,
							["Fill"] = "STANDARD",
							["Height"] = 4,
							["Position"] = {
								["Anchor"] = "BOTTOM",
								["Order"] = 0
							}
						},
						["Class"] = {
							["Animate"] = true,
							["Enabled"] = false,
							["Fill"] = "STANDARD",
							["Height"] = 4,
							["Position"] = {
								["Anchor"] = "TOP"
							}
						}
					},
					["Size"] = {
						["Height"] = 30,
						["Width"] = 300
					}
				},
				["Debuffs"] = {
					["Icons"] = {
						["Enabled"] = false,
						["Columns"] = 5,
						["Max"] = 5,
						["Rows"] = 1,
						["Growth"] = {
							["y"] = "DOWN",
							["x"] = "RIGHT"
						},
						["Width"] = 28,
						["CooldownSpiral"] = true,
						["Sort"] = {
							["SortBy"] = "Remaining",
							["Direction"] = "Descending"
						},
						["Spacing"] = {
							["y"] = -1,
							["x"] = 1
						},
						["Height"] = 28,
						["Filter"] = {
							["BlackOrWhite"] = "Black",
							["Dispellable"] = false,
							["Time"] = {
								["Max"] = 0,
								["Min"] = 0,
								["Unlimited"] = false
							},
							["Caster"] = {
								["Group"] = false,
								["Player"] = true,
								["Other"] = false,
								["Unit"] = true
							},
							["Lists"] = {}
						},
						["Position"] = {
							["y"] = 0,
							["x"] = 1,
							["AnchorTo"] = "BOTTOMRIGHT",
							["AnchorFrom"] = "BOTTOMLEFT",
							["AnchorFrame"] = "Frame"
						},
						["ClickThrough"] = false
					},
					["Bars"] = {}
				},
				["Buffs"] = {
					["Icons"] = {
						["Enabled"] = false,
						["Columns"] = 5,
						["Max"] = 5,
						["Rows"] = 1,
						["Growth"] = {
							["y"] = "UP",
							["x"] = "RIGHT"
						},
						["Width"] = 28,
						["CooldownSpiral"] = true,
						["Sort"] = {
							["SortBy"] = "Remaining",
							["Direction"] = "Descending"
						},
						["Spacing"] = {
							["y"] = 1,
							["x"] = -1
						},
						["Height"] = 28,
						["Filter"] = {
							["BlackOrWhite"] = "Black",
							["Dispellable"] = false,
							["Time"] = {
								["Max"] = 0,
								["Min"] = 0,
								["Unlimited"] = false
							},
							["Caster"] = {
								["Group"] = false,
								["Player"] = true,
								["Other"] = false,
								["Unit"] = true
							},
							["Lists"] = {}
						},
						["Position"] = {
							["y"] = 0,
							["x"] = 1,
							["AnchorTo"] = "TOPRIGHT",
							["AnchorFrom"] = "TOPLEFT",
							["AnchorFrame"] = "Frame"
						},
						["ClickThrough"] = false
					},
					["Bars"] = {}
				}
			},
			["targettarget"] = {
				["Enabled"] = true,
				["Frame"] = {
					["Portrait"] = {
						["Enabled"] = false,
						["Style"] = 1,
						["Cutaway"] = true,
						["Width"] = 60,
						["Height"] = 30,
						["Alpha"] = 0.75,
						["Position"] = {
							["AnchorFrom"] = "TOPLEFT",
							["AnchorTo"] = "TOPRIGHT",
							["x"] = -1,
							["y"] = 0
						},
						["Border"] = {
							["Color"] = {0, 0, 0},
							["Alpha"] = 1,
							["Offset"] = 0,
							["Style"] = {
								["edgeFile"] = "RUF Pixel",
								["edgeSize"] = 1
							}
						},
						["Background"] = {
							["Color"] = {0, 0, 0},
							["Alpha"] = 0.5
						}
					},
					["Indicators"] = {
						["LootMaster"] = {
							["Enabled"] = false,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "TOPRIGHT",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Frame"
							}
						},
						["Lead"] = {
							["Enabled"] = false,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "TOPLEFT",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Frame"
							}
						},
						["Role"] = {
							["Enabled"] = false,
							["Size"] = 18,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = -2,
								["x"] = -50,
								["AnchorTo"] = "CENTER",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Frame"
							}
						},
						["MainTankAssist"] = {
							["Enabled"] = false,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "RIGHT",
								["AnchorFrom"] = "LEFT",
								["AnchorFrame"] = "Lead"
							}
						},
						["PvPCombat"] = {
							["Enabled"] = false,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "BOTTOMLEFT",
								["AnchorFrom"] = "BOTTOM",
								["AnchorFrame"] = "Frame"
							}
						},
						["Assist"] = {
							["Enabled"] = false,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "CENTER",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Lead"
							}
						},
						["PetHappiness"] = {
							["Enabled"] = false,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 2,
								["AnchorTo"] = "RIGHT",
								["AnchorFrom"] = "LEFT",
								["AnchorFrame"] = "Frame"
							}
						},
						["TargetMark"] = {
							["Enabled"] = true,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "CENTER",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Frame"
							}
						},
						["Ready"] = {
							["Enabled"] = false,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = -2,
								["x"] = 50,
								["AnchorTo"] = "CENTER",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Frame"
							}
						}
					},
					["Position"] = {
						["y"] = -4,
						["x"] = 0,
						["AnchorTo"] = "BOTTOM",
						["AnchorFrom"] = "TOP",
						["AnchorFrame"] = "oUF_RUF_Target"
					},
					["Text"] = {
						["Name"] = {
							["Outline"] = "OUTLINE",
							["Font"] = "RUF",
							["Width"] = 100,
							["Position"] = {
								["y"] = 1,
								["x"] = -4,
								["AnchorTo"] = "RIGHT",
								["Anchor"] = "RIGHT",
								["AnchorFrame"] = "Frame"
							},
							["Size"] = 21,
							["Enabled"] = true,
							["Shadow"] = 0,
							["Tag"] = "[RUF:Name]"
						},
						["Level"] = {
							["Outline"] = "OUTLINE",
							["Font"] = "RUF",
							["Width"] = 100,
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "CENTER",
								["Anchor"] = "CENTER",
								["AnchorFrame"] = "Frame"
							},
							["Size"] = 18,
							["Enabled"] = false,
							["Shadow"] = 0,
							["Tag"] = "[RUF:Level]"
						},
						["Health"] = {
							["Outline"] = "OUTLINE",
							["Font"] = "RUF",
							["Width"] = 150,
							["Position"] = {
								["y"] = 1,
								["x"] = 4,
								["AnchorTo"] = "LEFT",
								["Anchor"] = "LEFT",
								["AnchorFrame"] = "Frame"
							},
							["Size"] = 21,
							["Enabled"] = true,
							["Shadow"] = 0,
							["Tag"] = "[RUF:CurHPPerc]"
						},
						["Power"] = {
							["Outline"] = "OUTLINE",
							["Font"] = "RUF",
							["Width"] = 100,
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "CENTER",
								["Anchor"] = "CENTER",
								["AnchorFrame"] = "Frame"
							},
							["Size"] = 18,
							["Enabled"] = false,
							["Shadow"] = 0,
							["Tag"] = "[RUF:CurPowerPerc]"
						}
					},
					["RangeFading"] = {
						["Enabled"] = true,
						["Alpha"] = 0.5
					},
					["Bars"] = {
						["Cast"] = {
							["Enabled"] = false,
							["Position"] = {
								["y"] = -38,
								["x"] = 0,
								["AnchorTo"] = "BOTTOM",
								["AnchorFrom"] = "TOP",
								["AnchorFrame"] = true
							},
							["Height"] = 26,
							["Fill"] = "REVERSE",
							["Width"] = 300,
							["Time"] = {
								["Enabled"] = true,
								["Font"] = "RUF",
								["Size"] = 18,
								["Outline"] = "OUTLINE",
								["Shadow"] = 0,
								["Style"] = 3
							},
							["Text"] = {
								["Enabled"] = true,
								["Font"] = "RUF",
								["Size"] = 18,
								["Outline"] = "OUTLINE",
								["Shadow"] = 0
							}
						},
						["Absorb"] = {
							["Animate"] = true,
							["Enabled"] = 1,
							["Fill"] = "REVERSE",
							["Height"] = 8,
							["Position"] = {
								["Anchor"] = "BOTTOM",
								["Order"] = 1
							}
						},
						["Health"] = {
							["Animate"] = true,
							["Fill"] = "REVERSE",
							["rainbow"] = {
								["enabled"] = false
							}
						},
						["Power"] = {
							["Animate"] = true,
							["Enabled"] = 1,
							["Fill"] = "REVERSE",
							["Height"] = 4,
							["Position"] = {
								["Anchor"] = "BOTTOM",
								["Order"] = 0
							}
						},
						["Class"] = {
							["Animate"] = true,
							["Enabled"] = false,
							["Fill"] = "REVERSE",
							["Height"] = 4,
							["Position"] = {
								["Anchor"] = "TOP"
							}
						}
					},
					["Size"] = {
						["Height"] = 30,
						["Width"] = 300
					}
				},
				["Debuffs"] = {
					["Icons"] = {
						["Enabled"] = false,
						["Columns"] = 5,
						["Max"] = 5,
						["Rows"] = 1,
						["Growth"] = {
							["y"] = "DOWN",
							["x"] = "LEFT"
						},
						["Width"] = 28,
						["CooldownSpiral"] = true,
						["Sort"] = {
							["SortBy"] = "Remaining",
							["Direction"] = "Descending"
						},
						["Spacing"] = {
							["y"] = -1,
							["x"] = 1
						},
						["Height"] = 28,
						["Filter"] = {
							["BlackOrWhite"] = "Black",
							["Dispellable"] = false,
							["Time"] = {
								["Max"] = 0,
								["Min"] = 0,
								["Unlimited"] = false
							},
							["Caster"] = {
								["Group"] = false,
								["Player"] = true,
								["Other"] = false,
								["Unit"] = true
							},
							["Lists"] = {}
						},
						["Position"] = {
							["y"] = 0,
							["x"] = -1,
							["AnchorTo"] = "BOTTOMLEFT",
							["AnchorFrom"] = "BOTTOMRIGHT",
							["AnchorFrame"] = "Frame"
						},
						["ClickThrough"] = false
					},
					["Bars"] = {}
				},
				["Buffs"] = {
					["Icons"] = {
						["Enabled"] = false,
						["Columns"] = 5,
						["Max"] = 5,
						["Rows"] = 1,
						["Growth"] = {
							["y"] = "UP",
							["x"] = "LEFT"
						},
						["Width"] = 28,
						["CooldownSpiral"] = true,
						["Sort"] = {
							["SortBy"] = "Remaining",
							["Direction"] = "Descending"
						},
						["Spacing"] = {
							["y"] = 1,
							["x"] = 1
						},
						["Height"] = 28,
						["Filter"] = {
							["BlackOrWhite"] = "Black",
							["Dispellable"] = false,
							["Time"] = {
								["Max"] = 0,
								["Min"] = 0,
								["Unlimited"] = false
							},
							["Caster"] = {
								["Group"] = false,
								["Player"] = true,
								["Other"] = false,
								["Unit"] = true
							},
							["Lists"] = {}
						},
						["Position"] = {
							["y"] = 0,
							["x"] = -1,
							["AnchorTo"] = "TOPLEFT",
							["AnchorFrom"] = "TOPRIGHT",
							["AnchorFrame"] = "Frame"
						},
						["ClickThrough"] = false
					},
					["Bars"] = {}
				}
			},
			["targettargettarget"] = {
				["Enabled"] = false,
				["Frame"] = {
					["Portrait"] = {
						["Enabled"] = false,
						["Style"] = 1,
						["Cutaway"] = true,
						["Width"] = 60,
						["Height"] = 30,
						["Alpha"] = 0.75,
						["Position"] = {
							["AnchorFrom"] = "TOPLEFT",
							["AnchorTo"] = "TOPRIGHT",
							["x"] = -1,
							["y"] = 0
						},
						["Border"] = {
							["Color"] = {0, 0, 0},
							["Alpha"] = 1,
							["Offset"] = 0,
							["Style"] = {
								["edgeFile"] = "RUF Pixel",
								["edgeSize"] = 1
							}
						},
						["Background"] = {
							["Color"] = {0, 0, 0},
							["Alpha"] = 0.5
						}
					},
					["Indicators"] = {
						["LootMaster"] = {
							["Enabled"] = false,
							["Size"] = 18,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "TOPLEFT",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Frame"
							}
						},
						["Lead"] = {
							["Enabled"] = false,
							["Size"] = 18,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "TOPRIGHT",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Frame"
							}
						},
						["Role"] = {
							["Enabled"] = false,
							["Size"] = 18,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = -2,
								["x"] = 0,
								["AnchorTo"] = "CENTER",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Frame"
							}
						},
						["MainTankAssist"] = {
							["Enabled"] = false,
							["Size"] = 18,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "LEFT",
								["AnchorFrom"] = "RIGHT",
								["AnchorFrame"] = "Lead"
							}
						},
						["PvPCombat"] = {
							["Enabled"] = false,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = -2,
								["x"] = 0,
								["AnchorTo"] = "RIGHT",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Frame"
							}
						},
						["Assist"] = {
							["Enabled"] = false,
							["Size"] = 18,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "CENTER",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Lead"
							}
						},
						["PetHappiness"] = {
							["Enabled"] = false,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "CENTER",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Frame"
							}
						},
						["TargetMark"] = {
							["Enabled"] = true,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = -1,
								["x"] = 2,
								["AnchorTo"] = "LEFT",
								["AnchorFrom"] = "LEFT",
								["AnchorFrame"] = "Frame"
							}
						},
						["Ready"] = {
							["Enabled"] = false,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "LEFT",
								["AnchorFrom"] = "RIGHT",
								["AnchorFrame"] = "Frame"
							}
						}
					},
					["Position"] = {
						["y"] = 0,
						["x"] = 4,
						["AnchorTo"] = "BOTTOMRIGHT",
						["AnchorFrom"] = "BOTTOMLEFT",
						["AnchorFrame"] = "oUF_RUF_TargetTarget"
					},
					["Text"] = {
						["Name"] = {
							["Outline"] = "OUTLINE",
							["Font"] = "RUF",
							["Width"] = 100,
							["Position"] = {
								["y"] = 1,
								["x"] = 0,
								["AnchorTo"] = "CENTER",
								["Anchor"] = "CENTER",
								["AnchorFrame"] = "Frame"
							},
							["Size"] = 21,
							["Enabled"] = true,
							["Shadow"] = 0,
							["Tag"] = "[RUF:Name]"
						},
						["Level"] = {
							["Outline"] = "OUTLINE",
							["Font"] = "RUF",
							["Width"] = 100,
							["Position"] = {
								["y"] = 1,
								["x"] = 0,
								["AnchorTo"] = "CENTER",
								["Anchor"] = "CENTER",
								["AnchorFrame"] = "Frame"
							},
							["Size"] = 18,
							["Enabled"] = false,
							["Shadow"] = 0,
							["Tag"] = "[RUF:Level]"
						},
						["Health"] = {
							["Outline"] = "OUTLINE",
							["Font"] = "RUF",
							["Width"] = 100,
							["Position"] = {
								["y"] = 1,
								["x"] = 0,
								["AnchorTo"] = "CENTER",
								["Anchor"] = "CENTER",
								["AnchorFrame"] = "Frame"
							},
							["Size"] = 21,
							["Enabled"] = false,
							["Shadow"] = 0,
							["Tag"] = "[RUF:CurHPPerc]"
						},
						["Power"] = {
							["Outline"] = "OUTLINE",
							["Font"] = "RUF",
							["Width"] = 100,
							["Position"] = {
								["y"] = 1,
								["x"] = 0,
								["AnchorTo"] = "CENTER",
								["Anchor"] = "CENTER",
								["AnchorFrame"] = "Frame"
							},
							["Size"] = 18,
							["Enabled"] = false,
							["Shadow"] = 0,
							["Tag"] = "[RUF:CurPowerPerc]"
						}
					},
					["RangeFading"] = {
						["Enabled"] = true,
						["Alpha"] = 0.5
					},
					["Bars"] = {
						["Cast"] = {
							["Enabled"] = false,
							["Position"] = {
								["y"] = -38,
								["x"] = 0,
								["AnchorTo"] = "BOTTOM",
								["AnchorFrom"] = "TOP",
								["AnchorFrame"] = true
							},
							["Height"] = 26,
							["Fill"] = "STANDARD",
							["Width"] = 300,
							["Time"] = {
								["Enabled"] = true,
								["Font"] = "RUF",
								["Size"] = 18,
								["Outline"] = "OUTLINE",
								["Shadow"] = 0,
								["Style"] = 3
							},
							["Text"] = {
								["Enabled"] = true,
								["Font"] = "RUF",
								["Size"] = 18,
								["Outline"] = "OUTLINE",
								["Shadow"] = 0
							}
						},
						["Absorb"] = {
							["Animate"] = true,
							["Enabled"] = 1,
							["Fill"] = "STANDARD",
							["Height"] = 8,
							["Position"] = {
								["Anchor"] = "BOTTOM",
								["Order"] = 1
							}
						},
						["Health"] = {
							["Animate"] = true,
							["Fill"] = "STANDARD",
							["rainbow"] = {
								["enabled"] = false
							}
						},
						["Power"] = {
							["Animate"] = true,
							["Enabled"] = 1,
							["Fill"] = "STANDARD",
							["Height"] = 4,
							["Position"] = {
								["Anchor"] = "BOTTOM",
								["Order"] = 0
							}
						},
						["Class"] = {
							["Animate"] = true,
							["Enabled"] = false,
							["Fill"] = "STANDARD",
							["Height"] = 8,
							["Position"] = {
								["Anchor"] = "TOP"
							}
						}
					},
					["Size"] = {
						["Height"] = 30,
						["Width"] = 125
					}
				},
				["Debuffs"] = {
					["Icons"] = {
						["Enabled"] = true,
						["Columns"] = 5,
						["Max"] = 12,
						["Rows"] = 2,
						["Growth"] = {
							["y"] = "UP",
							["x"] = "RIGHT"
						},
						["Width"] = 28,
						["CooldownSpiral"] = true,
						["Sort"] = {
							["SortBy"] = "Remaining",
							["Direction"] = "Descending"
						},
						["Spacing"] = {
							["y"] = 2,
							["x"] = -1
						},
						["Height"] = 28,
						["Filter"] = {
							["BlackOrWhite"] = "Black",
							["Dispellable"] = false,
							["Time"] = {
								["Max"] = 0,
								["Min"] = 0,
								["Unlimited"] = false
							},
							["Caster"] = {
								["Group"] = false,
								["Player"] = true,
								["Other"] = true,
								["Unit"] = true
							},
							["Lists"] = {}
						},
						["Position"] = {
							["y"] = 0,
							["x"] = 0,
							["AnchorTo"] = "TOPRIGHT",
							["AnchorFrom"] = "BOTTOMRIGHT",
							["AnchorFrame"] = "Frame"
						},
						["ClickThrough"] = true
					},
					["Bars"] = {}
				},
				["Buffs"] = {
					["Icons"] = {
						["Enabled"] = true,
						["Columns"] = 5,
						["Max"] = 12,
						["Rows"] = 2,
						["Growth"] = {
							["y"] = "UP",
							["x"] = "RIGHT"
						},
						["Width"] = 28,
						["CooldownSpiral"] = true,
						["Sort"] = {
							["SortBy"] = "Remaining",
							["Direction"] = "Descending"
						},
						["Spacing"] = {
							["y"] = 2,
							["x"] = -1
						},
						["Height"] = 28,
						["Filter"] = {
							["BlackOrWhite"] = "Black",
							["Dispellable"] = false,
							["Time"] = {
								["Max"] = 0,
								["Min"] = 0,
								["Unlimited"] = false
							},
							["Caster"] = {
								["Group"] = false,
								["Player"] = true,
								["Other"] = true,
								["Unit"] = true
							},
							["Lists"] = {}
						},
						["Position"] = {
							["y"] = 0,
							["x"] = 0,
							["AnchorTo"] = "TOPLEFT",
							["AnchorFrom"] = "BOTTOMLEFT",
							["AnchorFrame"] = "Frame"
						},
						["ClickThrough"] = true
					},
					["Bars"] = {}
				}
			},
			["focustarget"] = {
				["Enabled"] = true,
				["Frame"] = {
					["Portrait"] = {
						["Enabled"] = false,
						["Style"] = 1,
						["Cutaway"] = true,
						["Width"] = 60,
						["Height"] = 30,
						["Alpha"] = 0.75,
						["Position"] = {
							["AnchorFrom"] = "TOPLEFT",
							["AnchorTo"] = "TOPRIGHT",
							["x"] = -1,
							["y"] = 0
						},
						["Border"] = {
							["Color"] = {0, 0, 0},
							["Alpha"] = 1,
							["Offset"] = 0,
							["Style"] = {
								["edgeFile"] = "RUF Pixel",
								["edgeSize"] = 1
							}
						},
						["Background"] = {
							["Color"] = {0, 0, 0},
							["Alpha"] = 0.5
						}
					},
					["Indicators"] = {
						["LootMaster"] = {
							["Enabled"] = false,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "TOPLEFT",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Frame"
							}
						},
						["Lead"] = {
							["Enabled"] = false,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "TOPRIGHT",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Frame"
							}
						},
						["Role"] = {
							["Enabled"] = false,
							["Size"] = 18,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = -2,
								["x"] = 50,
								["AnchorTo"] = "CENTER",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Frame"
							}
						},
						["MainTankAssist"] = {
							["Enabled"] = false,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "LEFT",
								["AnchorFrom"] = "RIGHT",
								["AnchorFrame"] = "Lead"
							}
						},
						["PvPCombat"] = {
							["Enabled"] = false,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "BOTTOMRIGHT",
								["AnchorFrom"] = "BOTTOM",
								["AnchorFrame"] = "Frame"
							}
						},
						["Assist"] = {
							["Enabled"] = false,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "CENTER",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Lead"
							}
						},
						["PetHappiness"] = {
							["Enabled"] = true,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = -2,
								["AnchorTo"] = "LEFT",
								["AnchorFrom"] = "RIGHT",
								["AnchorFrame"] = "Frame"
							}
						},
						["TargetMark"] = {
							["Enabled"] = true,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "CENTER",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Frame"
							}
						},
						["Ready"] = {
							["Enabled"] = false,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = -2,
								["x"] = -50,
								["AnchorTo"] = "CENTER",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Frame"
							}
						}
					},
					["Position"] = {
						["y"] = -4,
						["x"] = 0,
						["AnchorTo"] = "BOTTOMLEFT",
						["AnchorFrom"] = "TOPLEFT",
						["AnchorFrame"] = "oUF_RUF_Focus"
					},
					["Text"] = {
						["Name"] = {
							["Outline"] = "OUTLINE",
							["Font"] = "RUF",
							["Width"] = 100,
							["Position"] = {
								["y"] = 1,
								["x"] = 4,
								["AnchorTo"] = "LEFT",
								["Anchor"] = "LEFT",
								["AnchorFrame"] = "Frame"
							},
							["Size"] = 21,
							["Enabled"] = true,
							["Shadow"] = 0,
							["Tag"] = "[RUF:Name]"
						},
						["Level"] = {
							["Outline"] = "OUTLINE",
							["Font"] = "RUF",
							["Width"] = 100,
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "CENTER",
								["Anchor"] = "CENTER",
								["AnchorFrame"] = "Frame"
							},
							["Size"] = 18,
							["Enabled"] = false,
							["Shadow"] = 0,
							["Tag"] = "[RUF:Level]"
						},
						["Health"] = {
							["Outline"] = "OUTLINE",
							["Font"] = "RUF",
							["Width"] = 150,
							["Position"] = {
								["y"] = 1,
								["x"] = -4,
								["AnchorTo"] = "RIGHT",
								["Anchor"] = "RIGHT",
								["AnchorFrame"] = "Frame"
							},
							["Size"] = 21,
							["Enabled"] = true,
							["Shadow"] = 0,
							["Tag"] = "[RUF:CurHPPerc]"
						},
						["Power"] = {
							["Outline"] = "OUTLINE",
							["Font"] = "RUF",
							["Width"] = 100,
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "CENTER",
								["Anchor"] = "CENTER",
								["AnchorFrame"] = "Frame"
							},
							["Size"] = 18,
							["Enabled"] = false,
							["Shadow"] = 0,
							["Tag"] = "[RUF:CurPowerPerc]"
						}
					},
					["RangeFading"] = {
						["Enabled"] = true,
						["Alpha"] = 0.5
					},
					["Bars"] = {
						["Cast"] = {
							["Enabled"] = false,
							["Position"] = {
								["y"] = -38,
								["x"] = 0,
								["AnchorTo"] = "BOTTOM",
								["AnchorFrom"] = "TOP",
								["AnchorFrame"] = true
							},
							["Height"] = 26,
							["Fill"] = "STANDARD",
							["Width"] = 300,
							["Time"] = {
								["Enabled"] = true,
								["Font"] = "RUF",
								["Size"] = 18,
								["Outline"] = "OUTLINE",
								["Shadow"] = 0,
								["Style"] = 3
							},
							["Text"] = {
								["Enabled"] = true,
								["Font"] = "RUF",
								["Size"] = 18,
								["Outline"] = "OUTLINE",
								["Shadow"] = 0
							}
						},
						["Absorb"] = {
							["Animate"] = true,
							["Enabled"] = 1,
							["Fill"] = "STANDARD",
							["Height"] = 8,
							["Position"] = {
								["Anchor"] = "BOTTOM",
								["Order"] = 1
							}
						},
						["Health"] = {
							["Animate"] = true,
							["Fill"] = "STANDARD",
							["rainbow"] = {
								["enabled"] = false
							}
						},
						["Power"] = {
							["Animate"] = true,
							["Enabled"] = 1,
							["Fill"] = "STANDARD",
							["Height"] = 4,
							["Position"] = {
								["Anchor"] = "BOTTOM",
								["Order"] = 0
							}
						},
						["Class"] = {
							["Animate"] = true,
							["Enabled"] = false,
							["Fill"] = "STANDARD",
							["Height"] = 4,
							["Position"] = {
								["Anchor"] = "TOP"
							}
						}
					},
					["Size"] = {
						["Height"] = 30,
						["Width"] = 300
					}
				},
				["Debuffs"] = {
					["Icons"] = {
						["Enabled"] = false,
						["Columns"] = 5,
						["Max"] = 5,
						["Rows"] = 1,
						["Growth"] = {
							["y"] = "DOWN",
							["x"] = "RIGHT"
						},
						["Width"] = 28,
						["CooldownSpiral"] = true,
						["Sort"] = {
							["SortBy"] = "Remaining",
							["Direction"] = "Descending"
						},
						["Spacing"] = {
							["y"] = -1,
							["x"] = 1
						},
						["Height"] = 28,
						["Filter"] = {
							["BlackOrWhite"] = "Black",
							["Dispellable"] = false,
							["Time"] = {
								["Max"] = 0,
								["Min"] = 0,
								["Unlimited"] = false
							},
							["Caster"] = {
								["Group"] = false,
								["Player"] = true,
								["Other"] = false,
								["Unit"] = true
							},
							["Lists"] = {}
						},
						["Position"] = {
							["y"] = 0,
							["x"] = 1,
							["AnchorTo"] = "BOTTOMRIGHT",
							["AnchorFrom"] = "BOTTOMLEFT",
							["AnchorFrame"] = "Frame"
						},
						["ClickThrough"] = false
					},
					["Bars"] = {}
				},
				["Buffs"] = {
					["Icons"] = {
						["Enabled"] = false,
						["Columns"] = 5,
						["Max"] = 5,
						["Rows"] = 1,
						["Growth"] = {
							["y"] = "UP",
							["x"] = "RIGHT"
						},
						["Width"] = 28,
						["CooldownSpiral"] = true,
						["Sort"] = {
							["SortBy"] = "Remaining",
							["Direction"] = "Descending"
						},
						["Spacing"] = {
							["y"] = 1,
							["x"] = -1
						},
						["Height"] = 28,
						["Filter"] = {
							["BlackOrWhite"] = "Black",
							["Dispellable"] = false,
							["Time"] = {
								["Max"] = 0,
								["Min"] = 0,
								["Unlimited"] = false
							},
							["Caster"] = {
								["Group"] = false,
								["Player"] = true,
								["Other"] = false,
								["Unit"] = true
							},
							["Lists"] = {}
						},
						["Position"] = {
							["y"] = 0,
							["x"] = 1,
							["AnchorTo"] = "TOPRIGHT",
							["AnchorFrom"] = "TOPLEFT",
							["AnchorFrame"] = "Frame"
						},
						["ClickThrough"] = false
					},
					["Bars"] = {}
				}
			},
			["pettarget"] = {
				["Enabled"] = false,
				["Frame"] = {
					["Portrait"] = {
						["Enabled"] = false,
						["Style"] = 1,
						["Cutaway"] = true,
						["Width"] = 60,
						["Height"] = 30,
						["Alpha"] = 0.75,
						["Position"] = {
							["AnchorFrom"] = "TOPLEFT",
							["AnchorTo"] = "TOPRIGHT",
							["x"] = -1,
							["y"] = 0
						},
						["Border"] = {
							["Color"] = {0, 0, 0},
							["Alpha"] = 1,
							["Offset"] = 0,
							["Style"] = {
								["edgeFile"] = "RUF Pixel",
								["edgeSize"] = 1
							}
						},
						["Background"] = {
							["Color"] = {0, 0, 0},
							["Alpha"] = 0.5
						}
					},
					["Indicators"] = {
						["LootMaster"] = {
							["Enabled"] = false,
							["Size"] = 18,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "TOPLEFT",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Frame"
							}
						},
						["Lead"] = {
							["Enabled"] = false,
							["Size"] = 18,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "TOPRIGHT",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Frame"
							}
						},
						["Role"] = {
							["Enabled"] = false,
							["Size"] = 18,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = -2,
								["x"] = 0,
								["AnchorTo"] = "CENTER",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Frame"
							}
						},
						["MainTankAssist"] = {
							["Enabled"] = false,
							["Size"] = 18,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "LEFT",
								["AnchorFrom"] = "RIGHT",
								["AnchorFrame"] = "Lead"
							}
						},
						["PvPCombat"] = {
							["Enabled"] = false,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = -2,
								["x"] = 0,
								["AnchorTo"] = "RIGHT",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Frame"
							}
						},
						["Assist"] = {
							["Enabled"] = false,
							["Size"] = 18,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "CENTER",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Lead"
							}
						},
						["PetHappiness"] = {
							["Enabled"] = false,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "CENTER",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Frame"
							}
						},
						["TargetMark"] = {
							["Enabled"] = true,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = -1,
								["x"] = 2,
								["AnchorTo"] = "LEFT",
								["AnchorFrom"] = "LEFT",
								["AnchorFrame"] = "Frame"
							}
						},
						["Ready"] = {
							["Enabled"] = false,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "RIGHT",
								["AnchorFrom"] = "LEFT",
								["AnchorFrame"] = "Frame"
							}
						}
					},
					["Position"] = {
						["y"] = 0,
						["x"] = 4,
						["AnchorTo"] = "BOTTOMRIGHT",
						["AnchorFrom"] = "BOTTOMLEFT",
						["AnchorFrame"] = "oUF_RUF_Pet"
					},
					["Text"] = {
						["Name"] = {
							["Outline"] = "OUTLINE",
							["Font"] = "RUF",
							["Width"] = 100,
							["Position"] = {
								["y"] = 1,
								["x"] = 0,
								["AnchorTo"] = "CENTER",
								["Anchor"] = "CENTER",
								["AnchorFrame"] = "Frame"
							},
							["Size"] = 21,
							["Enabled"] = true,
							["Shadow"] = 0,
							["Tag"] = "[RUF:Name]"
						},
						["Level"] = {
							["Outline"] = "OUTLINE",
							["Font"] = "RUF",
							["Width"] = 100,
							["Position"] = {
								["y"] = 1,
								["x"] = 0,
								["AnchorTo"] = "CENTER",
								["Anchor"] = "CENTER",
								["AnchorFrame"] = "Frame"
							},
							["Size"] = 18,
							["Enabled"] = false,
							["Shadow"] = 0,
							["Tag"] = "[RUF:Level]"
						},
						["Health"] = {
							["Outline"] = "OUTLINE",
							["Font"] = "RUF",
							["Width"] = 100,
							["Position"] = {
								["y"] = 1,
								["x"] = 0,
								["AnchorTo"] = "CENTER",
								["Anchor"] = "CENTER",
								["AnchorFrame"] = "Frame"
							},
							["Size"] = 21,
							["Enabled"] = false,
							["Shadow"] = 0,
							["Tag"] = "[RUF:CurHPPerc]"
						},
						["Power"] = {
							["Outline"] = "OUTLINE",
							["Font"] = "RUF",
							["Width"] = 100,
							["Position"] = {
								["y"] = 1,
								["x"] = 0,
								["AnchorTo"] = "CENTER",
								["Anchor"] = "CENTER",
								["AnchorFrame"] = "Frame"
							},
							["Size"] = 18,
							["Enabled"] = false,
							["Shadow"] = 0,
							["Tag"] = "[RUF:CurPowerPerc]"
						}
					},
					["RangeFading"] = {
						["Enabled"] = true,
						["Alpha"] = 0.5
					},
					["Bars"] = {
						["Cast"] = {
							["Enabled"] = false,
							["Position"] = {
								["y"] = -38,
								["x"] = 0,
								["AnchorTo"] = "BOTTOM",
								["AnchorFrom"] = "TOP",
								["AnchorFrame"] = true
							},
							["Height"] = 26,
							["Fill"] = "STANDARD",
							["Width"] = 300,
							["Time"] = {
								["Enabled"] = true,
								["Font"] = "RUF",
								["Size"] = 18,
								["Outline"] = "OUTLINE",
								["Shadow"] = 0,
								["Style"] = 3
							},
							["Text"] = {
								["Enabled"] = true,
								["Font"] = "RUF",
								["Size"] = 18,
								["Outline"] = "OUTLINE",
								["Shadow"] = 0
							}
						},
						["Absorb"] = {
							["Animate"] = true,
							["Enabled"] = 1,
							["Fill"] = "STANDARD",
							["Height"] = 8,
							["Position"] = {
								["Anchor"] = "BOTTOM",
								["Order"] = 1
							}
						},
						["Health"] = {
							["Animate"] = true,
							["Fill"] = "STANDARD",
							["rainbow"] = {
								["enabled"] = false
							}
						},
						["Power"] = {
							["Animate"] = true,
							["Enabled"] = 1,
							["Fill"] = "STANDARD",
							["Height"] = 4,
							["Position"] = {
								["Anchor"] = "BOTTOM",
								["Order"] = 0
							}
						},
						["Class"] = {
							["Animate"] = true,
							["Enabled"] = false,
							["Fill"] = "STANDARD",
							["Height"] = 8,
							["Position"] = {
								["Anchor"] = "TOP"
							}
						}
					},
					["Size"] = {
						["Height"] = 30,
						["Width"] = 125
					}
				},
				["Debuffs"] = {
					["Icons"] = {
						["Enabled"] = true,
						["Columns"] = 5,
						["Max"] = 12,
						["Rows"] = 2,
						["Growth"] = {
							["y"] = "UP",
							["x"] = "RIGHT"
						},
						["Width"] = 28,
						["CooldownSpiral"] = true,
						["Sort"] = {
							["SortBy"] = "Remaining",
							["Direction"] = "Descending"
						},
						["Spacing"] = {
							["y"] = 2,
							["x"] = -1
						},
						["Height"] = 28,
						["Filter"] = {
							["BlackOrWhite"] = "Black",
							["Dispellable"] = false,
							["Time"] = {
								["Max"] = 0,
								["Min"] = 0,
								["Unlimited"] = false
							},
							["Caster"] = {
								["Group"] = false,
								["Player"] = true,
								["Other"] = true,
								["Unit"] = true
							},
							["Lists"] = {}
						},
						["Position"] = {
							["y"] = 0,
							["x"] = 0,
							["AnchorTo"] = "TOPRIGHT",
							["AnchorFrom"] = "BOTTOMRIGHT",
							["AnchorFrame"] = "Frame"
						},
						["ClickThrough"] = true
					},
					["Bars"] = {}
				},
				["Buffs"] = {
					["Icons"] = {
						["Enabled"] = true,
						["Columns"] = 5,
						["Max"] = 12,
						["Rows"] = 2,
						["Growth"] = {
							["y"] = "UP",
							["x"] = "RIGHT"
						},
						["Width"] = 28,
						["CooldownSpiral"] = true,
						["Sort"] = {
							["SortBy"] = "Remaining",
							["Direction"] = "Descending"
						},
						["Spacing"] = {
							["y"] = 2,
							["x"] = -1
						},
						["Height"] = 28,
						["Filter"] = {
							["BlackOrWhite"] = "Black",
							["Dispellable"] = false,
							["Time"] = {
								["Max"] = 0,
								["Min"] = 0,
								["Unlimited"] = false
							},
							["Caster"] = {
								["Group"] = false,
								["Player"] = true,
								["Other"] = true,
								["Unit"] = true
							},
							["Lists"] = {}
						},
						["Position"] = {
							["y"] = 0,
							["x"] = 0,
							["AnchorTo"] = "TOPLEFT",
							["AnchorFrom"] = "BOTTOMLEFT",
							["AnchorFrame"] = "Frame"
						},
						["ClickThrough"] = true
					},
					["Bars"] = {}
				}
			},
			["party"] = {
				["Enabled"] = true,
				["Frame"] = {
					["Portrait"] = {
						["Enabled"] = false,
						["Style"] = 1,
						["Cutaway"] = true,
						["Width"] = 60,
						["Height"] = 60,
						["Alpha"] = 0.75,
						["Position"] = {
							["AnchorFrom"] = "TOPLEFT",
							["AnchorTo"] = "TOPRIGHT",
							["x"] = -1,
							["y"] = 0
						},
						["Border"] = {
							["Color"] = {0, 0, 0},
							["Alpha"] = 1,
							["Offset"] = 0,
							["Style"] = {
								["edgeFile"] = "RUF Pixel",
								["edgeSize"] = 1
							}
						},
						["Background"] = {
							["Color"] = {0, 0, 0},
							["Alpha"] = 0.5
						}
					},
					["Indicators"] = {
						["TargetMark"] = {
							["Enabled"] = true,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "RIGHT",
								["AnchorFrom"] = "LEFT",
								["AnchorFrame"] = "Frame"
							}
						},
						["InCombat"] = {
							["Enabled"] = true,
							["Size"] = 20,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "CENTER",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Frame"
							}
						},
						["LootMaster"] = {
							["Enabled"] = true,
							["Size"] = 14,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "TOPLEFT",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Frame"
							}
						},
						["Lead"] = {
							["Enabled"] = true,
							["Size"] = 14,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "TOPRIGHT",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Frame"
							}
						},
						["Role"] = {
							["Enabled"] = true,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "LEFT",
								["AnchorFrom"] = "RIGHT",
								["AnchorFrame"] = "Frame"
							}
						},
						["MainTankAssist"] = {
							["Enabled"] = true,
							["Size"] = 12,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "LEFT",
								["AnchorFrom"] = "RIGHT",
								["AnchorFrame"] = "Lead"
							}
						},
						["PvPCombat"] = {
							["Enabled"] = true,
							["Size"] = 28,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "RIGHT",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Frame"
							}
						},
						["Assist"] = {
							["Enabled"] = true,
							["Size"] = 14,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "CENTER",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Lead"
							}
						},
						["PetHappiness"] = {
							["Enabled"] = false,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = -2,
								["AnchorTo"] = "LEFT",
								["AnchorFrom"] = "RIGHT",
								["AnchorFrame"] = "Frame"
							}
						},
						["Rest"] = {
							["Enabled"] = true,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "TOPRIGHT",
								["AnchorFrom"] = "BOTTOMLEFT",
								["AnchorFrame"] = "Frame"
							}
						},
						["Ready"] = {
							["Enabled"] = true,
							["Size"] = 36,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 10,
								["AnchorTo"] = "RIGHT",
								["AnchorFrom"] = "LEFT",
								["AnchorFrame"] = "Frame"
							}
						}
					},
					["Position"] = {
						["y"] = -40,
						["x"] = 4,
						["offsety"] = -4,
						["AnchorTo"] = "LEFT",
						["growth"] = "BOTTOM",
						["growthDirection"] = "VERTICAL",
						["growthHoriz"] = "LEFT",
						["offsetx"] = 0,
						["AnchorFrom"] = "TOPLEFT",
						["AnchorFrame"] = "UIParent"
					},
					["Text"] = {
						["Health"] = {
							["Outline"] = "OUTLINE",
							["Font"] = "RUF",
							["Width"] = 150,
							["Position"] = {
								["y"] = 4,
								["x"] = -4,
								["AnchorTo"] = "RIGHT",
								["Anchor"] = "RIGHT",
								["AnchorFrame"] = "Frame"
							},
							["Size"] = 28,
							["Enabled"] = true,
							["Shadow"] = 0,
							["Tag"] = "[RUF:CurHPPerc]"
						},
						["Power"] = {
							["Outline"] = "OUTLINE",
							["Font"] = "RUF",
							["Width"] = 100,
							["Position"] = {
								["y"] = 3,
								["x"] = -4,
								["AnchorTo"] = "BOTTOMRIGHT",
								["Anchor"] = "BOTTOMRIGHT",
								["AnchorFrame"] = "Frame"
							},
							["Size"] = 18,
							["Enabled"] = true,
							["Shadow"] = 0,
							["Tag"] = "[RUF:CurPowerPerc]"
						},
						["Level"] = {
							["Outline"] = "OUTLINE",
							["Font"] = "RUF",
							["Width"] = 100,
							["Position"] = {
								["y"] = 3,
								["x"] = 4,
								["AnchorTo"] = "BOTTOMLEFT",
								["Anchor"] = "BOTTOMLEFT",
								["AnchorFrame"] = "Frame"
							},
							["Size"] = 18,
							["Enabled"] = true,
							["Shadow"] = 0,
							["Tag"] = "[RUF:Level]"
						},
						["Name"] = {
							["Outline"] = "OUTLINE",
							["Font"] = "RUF",
							["Width"] = 100,
							["Position"] = {
								["y"] = 4,
								["x"] = 4,
								["AnchorTo"] = "LEFT",
								["Anchor"] = "LEFT",
								["AnchorFrame"] = "Frame"
							},
							["Size"] = 21,
							["Enabled"] = true,
							["Shadow"] = 0,
							["Tag"] = "[RUF:Name]"
						},
						["AFKDND"] = {
							["Outline"] = "OUTLINE",
							["Shadow"] = 0,
							["Tag"] = "[RUF:AFKDND]",
							["Position"] = {
								["y"] = 1,
								["x"] = -2,
								["AnchorTo"] = "RIGHT",
								["Anchor"] = "LEFT",
								["AnchorFrame"] = "Name"
							},
							["Enabled"] = true,
							["Size"] = 21,
							["Font"] = "RUF",
							["Width"] = 100
						}
					},
					["RangeFading"] = {
						["Enabled"] = true,
						["Alpha"] = 0.5
					},
					["Bars"] = {
						["Cast"] = {
							["Enabled"] = true,
							["Position"] = {
								["y"] = -38,
								["x"] = 0,
								["AnchorTo"] = "BOTTOM",
								["AnchorFrom"] = "TOP",
								["AnchorFrame"] = true
							},
							["Height"] = 26,
							["Fill"] = "STANDARD",
							["Width"] = 300,
							["Time"] = {
								["Enabled"] = true,
								["Font"] = "RUF",
								["Size"] = 18,
								["Outline"] = "OUTLINE",
								["Shadow"] = 0,
								["Style"] = 3
							},
							["Text"] = {
								["Enabled"] = true,
								["Font"] = "RUF",
								["Size"] = 18,
								["Outline"] = "OUTLINE",
								["Shadow"] = 0
							}
						},
						["Absorb"] = {
							["Animate"] = true,
							["Enabled"] = 1,
							["Fill"] = "STANDARD",
							["Height"] = 8,
							["Position"] = {
								["Anchor"] = "BOTTOM",
								["Order"] = 1
							}
						},
						["Health"] = {
							["Animate"] = true,
							["Fill"] = "STANDARD",
							["rainbow"] = {
								["enabled"] = false
							}
						},
						["Power"] = {
							["Animate"] = true,
							["Enabled"] = 1,
							["Fill"] = "STANDARD",
							["Height"] = 8,
							["Position"] = {
								["Anchor"] = "BOTTOM",
								["Order"] = 0
							}
						},
						["Class"] = {
							["Animate"] = true,
							["Enabled"] = true,
							["Fill"] = "STANDARD",
							["Height"] = 8,
							["Position"] = {
								["Anchor"] = "TOP"
							}
						}
					},
					["Size"] = {
						["Height"] = 60,
						["Width"] = 300
					}
				},
				["Debuffs"] = {
					["Icons"] = {
						["Enabled"] = true,
						["Columns"] = 5,
						["Max"] = 5,
						["Rows"] = 1,
						["Growth"] = {
							["y"] = "DOWN",
							["x"] = "RIGHT"
						},
						["Width"] = 28,
						["CooldownSpiral"] = true,
						["Sort"] = {
							["SortBy"] = "Remaining",
							["Direction"] = "Descending"
						},
						["Spacing"] = {
							["y"] = -1,
							["x"] = 1
						},
						["Height"] = 28,
						["Filter"] = {
							["BlackOrWhite"] = "Black",
							["Dispellable"] = false,
							["Time"] = {
								["Max"] = 0,
								["Min"] = 0,
								["Unlimited"] = false
							},
							["Caster"] = {
								["Group"] = false,
								["Player"] = true,
								["Other"] = false,
								["Unit"] = true
							},
							["Lists"] = {}
						},
						["Position"] = {
							["y"] = 0,
							["x"] = 1,
							["AnchorTo"] = "BOTTOMRIGHT",
							["AnchorFrom"] = "BOTTOMLEFT",
							["AnchorFrame"] = "Frame"
						},
						["ClickThrough"] = false
					},
					["Bars"] = {}
				},
				["showRaid"] = false,
				["showArena"] = false,
				["showPlayer"] = false,
				["Buffs"] = {
					["Icons"] = {
						["Enabled"] = true,
						["Columns"] = 5,
						["Max"] = 5,
						["Rows"] = 1,
						["Growth"] = {
							["y"] = "UP",
							["x"] = "RIGHT"
						},
						["Width"] = 28,
						["CooldownSpiral"] = true,
						["Sort"] = {
							["SortBy"] = "Remaining",
							["Direction"] = "Descending"
						},
						["Spacing"] = {
							["y"] = 1,
							["x"] = 1
						},
						["Height"] = 28,
						["Filter"] = {
							["BlackOrWhite"] = "Black",
							["Dispellable"] = false,
							["Time"] = {
								["Max"] = 0,
								["Min"] = 0,
								["Unlimited"] = false
							},
							["Caster"] = {
								["Group"] = false,
								["Player"] = true,
								["Other"] = false,
								["Unit"] = true
							},
							["Lists"] = {}
						},
						["Position"] = {
							["y"] = 0,
							["x"] = 1,
							["AnchorTo"] = "TOPRIGHT",
							["AnchorFrom"] = "TOPLEFT",
							["AnchorFrame"] = "Frame"
						},
						["ClickThrough"] = false
					},
					["Bars"] = {}
				}
			},
			["partypet"] = {
				["Enabled"] = false,
				["Frame"] = {
					["Portrait"] = {
						["Enabled"] = false,
						["Style"] = 1,
						["Cutaway"] = true,
						["Width"] = 60,
						["Height"] = 30,
						["Alpha"] = 0.75,
						["Position"] = {
							["AnchorFrom"] = "TOPLEFT",
							["AnchorTo"] = "TOPRIGHT",
							["x"] = -1,
							["y"] = 0
						},
						["Border"] = {
							["Color"] = {0, 0, 0},
							["Alpha"] = 1,
							["Offset"] = 0,
							["Style"] = {
								["edgeFile"] = "RUF Pixel",
								["edgeSize"] = 1
							}
						},
						["Background"] = {
							["Color"] = {0, 0, 0},
							["Alpha"] = 0.5
						}
					},
					["Indicators"] = {
						["LootMaster"] = {
							["Enabled"] = false,
							["Size"] = 18,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "TOPLEFT",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Frame"
							}
						},
						["Lead"] = {
							["Enabled"] = false,
							["Size"] = 18,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "TOPRIGHT",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Frame"
							}
						},
						["Role"] = {
							["Enabled"] = false,
							["Size"] = 18,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = -2,
								["x"] = 0,
								["AnchorTo"] = "CENTER",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Frame"
							}
						},
						["MainTankAssist"] = {
							["Enabled"] = false,
							["Size"] = 18,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "LEFT",
								["AnchorFrom"] = "RIGHT",
								["AnchorFrame"] = "Lead"
							}
						},
						["PvPCombat"] = {
							["Enabled"] = false,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = -2,
								["x"] = 0,
								["AnchorTo"] = "RIGHT",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Frame"
							}
						},
						["Assist"] = {
							["Enabled"] = false,
							["Size"] = 18,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "CENTER",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Lead"
							}
						},
						["PetHappiness"] = {
							["Enabled"] = false,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "CENTER",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Frame"
							}
						},
						["TargetMark"] = {
							["Enabled"] = true,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = -1,
								["x"] = 2,
								["AnchorTo"] = "LEFT",
								["AnchorFrom"] = "LEFT",
								["AnchorFrame"] = "Frame"
							}
						},
						["Ready"] = {
							["Enabled"] = false,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "LEFT",
								["AnchorFrom"] = "RIGHT",
								["AnchorFrame"] = "Frame"
							}
						}
					},
					["Position"] = {
						["y"] = 0,
						["x"] = 4,
						["offsety"] = -34,
						["AnchorTo"] = "TOPRIGHT",
						["growth"] = "BOTTOM",
						["growthDirection"] = "VERTICAL",
						["growthHoriz"] = "LEFT",
						["offsetx"] = 0,
						["AnchorFrom"] = "TOPLEFT",
						["AnchorFrame"] = "oUF_RUF_Party"
					},
					["Text"] = {
						["Name"] = {
							["Outline"] = "OUTLINE",
							["Font"] = "RUF",
							["Width"] = 100,
							["Position"] = {
								["y"] = 1,
								["x"] = 0,
								["AnchorTo"] = "CENTER",
								["Anchor"] = "CENTER",
								["AnchorFrame"] = "Frame"
							},
							["Size"] = 21,
							["Enabled"] = true,
							["Shadow"] = 0,
							["Tag"] = "[RUF:Name]"
						},
						["Level"] = {
							["Outline"] = "OUTLINE",
							["Font"] = "RUF",
							["Width"] = 100,
							["Position"] = {
								["y"] = 1,
								["x"] = 0,
								["AnchorTo"] = "CENTER",
								["Anchor"] = "CENTER",
								["AnchorFrame"] = "Frame"
							},
							["Size"] = 18,
							["Enabled"] = false,
							["Shadow"] = 0,
							["Tag"] = "[RUF:Level]"
						},
						["Health"] = {
							["Outline"] = "OUTLINE",
							["Font"] = "RUF",
							["Width"] = 100,
							["Position"] = {
								["y"] = 1,
								["x"] = 0,
								["AnchorTo"] = "CENTER",
								["Anchor"] = "CENTER",
								["AnchorFrame"] = "Frame"
							},
							["Size"] = 21,
							["Enabled"] = false,
							["Shadow"] = 0,
							["Tag"] = "[RUF:CurHPPerc]"
						},
						["Power"] = {
							["Outline"] = "OUTLINE",
							["Font"] = "RUF",
							["Width"] = 100,
							["Position"] = {
								["y"] = 1,
								["x"] = 0,
								["AnchorTo"] = "CENTER",
								["Anchor"] = "CENTER",
								["AnchorFrame"] = "Frame"
							},
							["Size"] = 18,
							["Enabled"] = false,
							["Shadow"] = 0,
							["Tag"] = "[RUF:CurPowerPerc]"
						}
					},
					["RangeFading"] = {
						["Enabled"] = true,
						["Alpha"] = 0.5
					},
					["Bars"] = {
						["Cast"] = {
							["Enabled"] = false,
							["Position"] = {
								["y"] = -38,
								["x"] = 0,
								["AnchorTo"] = "BOTTOM",
								["AnchorFrom"] = "TOP",
								["AnchorFrame"] = true
							},
							["Height"] = 26,
							["Fill"] = "STANDARD",
							["Width"] = 300,
							["Time"] = {
								["Enabled"] = true,
								["Font"] = "RUF",
								["Size"] = 18,
								["Outline"] = "OUTLINE",
								["Shadow"] = 0,
								["Style"] = 3
							},
							["Text"] = {
								["Enabled"] = true,
								["Font"] = "RUF",
								["Size"] = 18,
								["Outline"] = "OUTLINE",
								["Shadow"] = 0
							}
						},
						["Absorb"] = {
							["Animate"] = true,
							["Enabled"] = 1,
							["Fill"] = "STANDARD",
							["Height"] = 8,
							["Position"] = {
								["Anchor"] = "BOTTOM",
								["Order"] = 1
							}
						},
						["Health"] = {
							["Animate"] = true,
							["Fill"] = "STANDARD",
							["rainbow"] = {
								["enabled"] = false
							}
						},
						["Power"] = {
							["Animate"] = true,
							["Enabled"] = 1,
							["Fill"] = "STANDARD",
							["Height"] = 4,
							["Position"] = {
								["Anchor"] = "BOTTOM",
								["Order"] = 0
							}
						},
						["Class"] = {
							["Animate"] = true,
							["Enabled"] = false,
							["Fill"] = "STANDARD",
							["Height"] = 8,
							["Position"] = {
								["Anchor"] = "TOP"
							}
						}
					},
					["Size"] = {
						["Height"] = 30,
						["Width"] = 125
					}
				},
				["Debuffs"] = {
					["Icons"] = {
						["Enabled"] = true,
						["Columns"] = 5,
						["Max"] = 12,
						["Rows"] = 2,
						["Growth"] = {
							["y"] = "UP",
							["x"] = "RIGHT"
						},
						["Width"] = 28,
						["CooldownSpiral"] = true,
						["Sort"] = {
							["SortBy"] = "Remaining",
							["Direction"] = "Descending"
						},
						["Spacing"] = {
							["y"] = 2,
							["x"] = -1
						},
						["Height"] = 28,
						["Filter"] = {
							["BlackOrWhite"] = "Black",
							["Dispellable"] = false,
							["Time"] = {
								["Max"] = 0,
								["Min"] = 0,
								["Unlimited"] = false
							},
							["Caster"] = {
								["Group"] = false,
								["Player"] = true,
								["Other"] = true,
								["Unit"] = true
							},
							["Lists"] = {}
						},
						["Position"] = {
							["y"] = 0,
							["x"] = 0,
							["AnchorTo"] = "TOPRIGHT",
							["AnchorFrom"] = "BOTTOMRIGHT",
							["AnchorFrame"] = "Frame"
						},
						["ClickThrough"] = true
					},
					["Bars"] = {}
				},
				["showRaid"] = false,
				["Buffs"] = {
					["Icons"] = {
						["Enabled"] = true,
						["Columns"] = 5,
						["Max"] = 12,
						["Rows"] = 2,
						["Growth"] = {
							["y"] = "UP",
							["x"] = "RIGHT"
						},
						["Width"] = 28,
						["CooldownSpiral"] = true,
						["Sort"] = {
							["SortBy"] = "Remaining",
							["Direction"] = "Descending"
						},
						["Spacing"] = {
							["y"] = 2,
							["x"] = -1
						},
						["Height"] = 28,
						["Filter"] = {
							["BlackOrWhite"] = "Black",
							["Dispellable"] = false,
							["Time"] = {
								["Max"] = 0,
								["Min"] = 0,
								["Unlimited"] = false
							},
							["Caster"] = {
								["Group"] = false,
								["Player"] = true,
								["Other"] = true,
								["Unit"] = true
							},
							["Lists"] = {}
						},
						["Position"] = {
							["y"] = 0,
							["x"] = 0,
							["AnchorTo"] = "TOPLEFT",
							["AnchorFrom"] = "BOTTOMLEFT",
							["AnchorFrame"] = "Frame"
						},
						["ClickThrough"] = true
					},
					["Bars"] = {}
				}
			},
			["partytarget"] = {
				["Enabled"] = false,
				["Frame"] = {
					["Portrait"] = {
						["Enabled"] = false,
						["Style"] = 1,
						["Cutaway"] = true,
						["Width"] = 60,
						["Height"] = 30,
						["Alpha"] = 0.75,
						["Position"] = {
							["AnchorFrom"] = "TOPLEFT",
							["AnchorTo"] = "TOPRIGHT",
							["x"] = -1,
							["y"] = 0
						},
						["Border"] = {
							["Color"] = {0, 0, 0},
							["Alpha"] = 1,
							["Offset"] = 0,
							["Style"] = {
								["edgeFile"] = "RUF Pixel",
								["edgeSize"] = 1
							}
						},
						["Background"] = {
							["Color"] = {0, 0, 0},
							["Alpha"] = 0.5
						}
					},
					["Indicators"] = {
						["LootMaster"] = {
							["Enabled"] = false,
							["Size"] = 18,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "TOPLEFT",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Frame"
							}
						},
						["Lead"] = {
							["Enabled"] = false,
							["Size"] = 18,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "TOPRIGHT",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Frame"
							}
						},
						["Role"] = {
							["Enabled"] = false,
							["Size"] = 18,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = -2,
								["x"] = 0,
								["AnchorTo"] = "CENTER",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Frame"
							}
						},
						["MainTankAssist"] = {
							["Enabled"] = false,
							["Size"] = 18,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "LEFT",
								["AnchorFrom"] = "RIGHT",
								["AnchorFrame"] = "Lead"
							}
						},
						["PvPCombat"] = {
							["Enabled"] = false,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = -2,
								["x"] = 0,
								["AnchorTo"] = "RIGHT",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Frame"
							}
						},
						["Assist"] = {
							["Enabled"] = false,
							["Size"] = 18,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "CENTER",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Lead"
							}
						},
						["PetHappiness"] = {
							["Enabled"] = false,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "CENTER",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Frame"
							}
						},
						["TargetMark"] = {
							["Enabled"] = true,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = -1,
								["x"] = 2,
								["AnchorTo"] = "LEFT",
								["AnchorFrom"] = "LEFT",
								["AnchorFrame"] = "Frame"
							}
						},
						["Ready"] = {
							["Enabled"] = false,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "LEFT",
								["AnchorFrom"] = "RIGHT",
								["AnchorFrame"] = "Frame"
							}
						}
					},
					["Position"] = {
						["y"] = -30,
						["x"] = 4,
						["offsety"] = -34,
						["AnchorTo"] = "TOPRIGHT",
						["growth"] = "BOTTOM",
						["offsetx"] = 0,
						["AnchorFrom"] = "TOPLEFT",
						["AnchorFrame"] = "oUF_RUF_Party"
					},
					["Text"] = {
						["Name"] = {
							["Outline"] = "OUTLINE",
							["Font"] = "RUF",
							["Width"] = 100,
							["Position"] = {
								["y"] = 1,
								["x"] = 0,
								["AnchorTo"] = "CENTER",
								["Anchor"] = "CENTER",
								["AnchorFrame"] = "Frame"
							},
							["Size"] = 21,
							["Enabled"] = true,
							["Shadow"] = 0,
							["Tag"] = "[RUF:Name]"
						},
						["Level"] = {
							["Outline"] = "OUTLINE",
							["Font"] = "RUF",
							["Width"] = 100,
							["Position"] = {
								["y"] = 1,
								["x"] = 0,
								["AnchorTo"] = "CENTER",
								["Anchor"] = "CENTER",
								["AnchorFrame"] = "Frame"
							},
							["Size"] = 18,
							["Enabled"] = false,
							["Shadow"] = 0,
							["Tag"] = "[RUF:Level]"
						},
						["Health"] = {
							["Outline"] = "OUTLINE",
							["Font"] = "RUF",
							["Width"] = 100,
							["Position"] = {
								["y"] = 1,
								["x"] = 0,
								["AnchorTo"] = "CENTER",
								["Anchor"] = "CENTER",
								["AnchorFrame"] = "Frame"
							},
							["Size"] = 21,
							["Enabled"] = false,
							["Shadow"] = 0,
							["Tag"] = "[RUF:CurHPPerc]"
						},
						["Power"] = {
							["Outline"] = "OUTLINE",
							["Font"] = "RUF",
							["Width"] = 100,
							["Position"] = {
								["y"] = 1,
								["x"] = 0,
								["AnchorTo"] = "CENTER",
								["Anchor"] = "CENTER",
								["AnchorFrame"] = "Frame"
							},
							["Size"] = 18,
							["Enabled"] = false,
							["Shadow"] = 0,
							["Tag"] = "[RUF:CurPowerPerc]"
						}
					},
					["RangeFading"] = {
						["Enabled"] = true,
						["Alpha"] = 0.5
					},
					["Bars"] = {
						["Cast"] = {
							["Enabled"] = false,
							["Position"] = {
								["y"] = -38,
								["x"] = 0,
								["AnchorTo"] = "BOTTOM",
								["AnchorFrom"] = "TOP",
								["AnchorFrame"] = true
							},
							["Height"] = 26,
							["Fill"] = "STANDARD",
							["Width"] = 300,
							["Time"] = {
								["Enabled"] = true,
								["Font"] = "RUF",
								["Size"] = 18,
								["Outline"] = "OUTLINE",
								["Shadow"] = 0,
								["Style"] = 3
							},
							["Text"] = {
								["Enabled"] = true,
								["Font"] = "RUF",
								["Size"] = 18,
								["Outline"] = "OUTLINE",
								["Shadow"] = 0
							}
						},
						["Absorb"] = {
							["Animate"] = true,
							["Enabled"] = 1,
							["Fill"] = "STANDARD",
							["Height"] = 8,
							["Position"] = {
								["Anchor"] = "BOTTOM",
								["Order"] = 1
							}
						},
						["Health"] = {
							["Animate"] = true,
							["Fill"] = "STANDARD",
							["rainbow"] = {
								["enabled"] = false
							}
						},
						["Power"] = {
							["Animate"] = true,
							["Enabled"] = 1,
							["Fill"] = "STANDARD",
							["Height"] = 4,
							["Position"] = {
								["Anchor"] = "BOTTOM",
								["Order"] = 0
							}
						},
						["Class"] = {
							["Animate"] = true,
							["Enabled"] = false,
							["Fill"] = "STANDARD",
							["Height"] = 8,
							["Position"] = {
								["Anchor"] = "TOP"
							}
						}
					},
					["Size"] = {
						["Height"] = 30,
						["Width"] = 125
					}
				},
				["Debuffs"] = {
					["Icons"] = {
						["Enabled"] = true,
						["Columns"] = 5,
						["Max"] = 12,
						["Rows"] = 2,
						["Growth"] = {
							["y"] = "UP",
							["x"] = "RIGHT"
						},
						["Width"] = 28,
						["CooldownSpiral"] = true,
						["Sort"] = {
							["SortBy"] = "Remaining",
							["Direction"] = "Descending"
						},
						["Spacing"] = {
							["y"] = 2,
							["x"] = -1
						},
						["Height"] = 28,
						["Filter"] = {
							["BlackOrWhite"] = "Black",
							["Dispellable"] = false,
							["Time"] = {
								["Max"] = 0,
								["Min"] = 0,
								["Unlimited"] = false
							},
							["Caster"] = {
								["Group"] = false,
								["Player"] = true,
								["Other"] = true,
								["Unit"] = true
							},
							["Lists"] = {}
						},
						["Position"] = {
							["y"] = 0,
							["x"] = 0,
							["AnchorTo"] = "TOPRIGHT",
							["AnchorFrom"] = "BOTTOMRIGHT",
							["AnchorFrame"] = "Frame"
						},
						["ClickThrough"] = true
					},
					["Bars"] = {}
				},
				["showRaid"] = false,
				["Buffs"] = {
					["Icons"] = {
						["Enabled"] = true,
						["Columns"] = 5,
						["Max"] = 12,
						["Rows"] = 2,
						["Growth"] = {
							["y"] = "UP",
							["x"] = "RIGHT"
						},
						["Width"] = 28,
						["CooldownSpiral"] = true,
						["Sort"] = {
							["SortBy"] = "Remaining",
							["Direction"] = "Descending"
						},
						["Spacing"] = {
							["y"] = 2,
							["x"] = -1
						},
						["Height"] = 28,
						["Filter"] = {
							["BlackOrWhite"] = "Black",
							["Dispellable"] = false,
							["Time"] = {
								["Max"] = 0,
								["Min"] = 0,
								["Unlimited"] = false
							},
							["Caster"] = {
								["Group"] = false,
								["Player"] = true,
								["Other"] = true,
								["Unit"] = true
							},
							["Lists"] = {}
						},
						["Position"] = {
							["y"] = 0,
							["x"] = 0,
							["AnchorTo"] = "TOPLEFT",
							["AnchorFrom"] = "BOTTOMLEFT",
							["AnchorFrame"] = "Frame"
						},
						["ClickThrough"] = true
					},
					["Bars"] = {}
				}
			},
			["arena"] = {
				["Enabled"] = true,
				["Frame"] = {
					["Portrait"] = {
						["Enabled"] = false,
						["Style"] = 1,
						["Cutaway"] = true,
						["Width"] = 60,
						["Height"] = 60,
						["Alpha"] = 0.75,
						["Position"] = {
							["AnchorFrom"] = "TOPRIGHT",
							["AnchorTo"] = "TOPLEFT",
							["x"] = 1,
							["y"] = 0
						},
						["Border"] = {
							["Color"] = {0, 0, 0},
							["Alpha"] = 1,
							["Offset"] = 0,
							["Style"] = {
								["edgeFile"] = "RUF Pixel",
								["edgeSize"] = 1
							}
						},
						["Background"] = {
							["Color"] = {0, 0, 0},
							["Alpha"] = 0.5
						}
					},
					["Indicators"] = {
						["TargetMark"] = {
							["Enabled"] = true,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "LEFT",
								["AnchorFrom"] = "RIGHT",
								["AnchorFrame"] = "Frame"
							}
						},
						["LootMaster"] = {
							["Enabled"] = false,
							["Size"] = 14,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "TOPRIGHT",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Frame"
							}
						},
						["Lead"] = {
							["Enabled"] = false,
							["Size"] = 14,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "TOPLEFT",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Frame"
							}
						},
						["Role"] = {
							["Enabled"] = true,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "RIGHT",
								["AnchorFrom"] = "LEFT",
								["AnchorFrame"] = "Frame"
							}
						},
						["MainTankAssist"] = {
							["Enabled"] = false,
							["Size"] = 12,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "RIGHT",
								["AnchorFrom"] = "LEFT",
								["AnchorFrame"] = "Lead"
							}
						},
						["PvPCombat"] = {
							["Enabled"] = true,
							["Size"] = 28,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "LEFT",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Frame"
							}
						},
						["Assist"] = {
							["Enabled"] = false,
							["Size"] = 14,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "CENTER",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Lead"
							}
						},
						["PetHappiness"] = {
							["Enabled"] = false,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 2,
								["AnchorTo"] = "RIGHT",
								["AnchorFrom"] = "LEFT",
								["AnchorFrame"] = "Frame"
							}
						},
						["Rest"] = {
							["Enabled"] = false,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "CENTER",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Frame"
							}
						},
						["Ready"] = {
							["Enabled"] = false,
							["Size"] = 36,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = -10,
								["AnchorTo"] = "LEFT",
								["AnchorFrom"] = "RIGHT",
								["AnchorFrame"] = "Frame"
							}
						}
					},
					["Position"] = {
						["y"] = 40,
						["x"] = -4,
						["offsety"] = 4,
						["AnchorTo"] = "RIGHT",
						["growth"] = "TOP",
						["offsetx"] = 0,
						["AnchorFrom"] = "BOTTOMRIGHT",
						["AnchorFrame"] = "UIParent"
					},
					["Text"] = {
						["Health"] = {
							["Outline"] = "OUTLINE",
							["Font"] = "RUF",
							["Width"] = 150,
							["Position"] = {
								["y"] = 4,
								["x"] = 4,
								["AnchorTo"] = "LEFT",
								["Anchor"] = "LEFT",
								["AnchorFrame"] = "Frame"
							},
							["Size"] = 28,
							["Enabled"] = true,
							["Shadow"] = 0,
							["Tag"] = "[RUF:CurHPPerc]"
						},
						["Power"] = {
							["Outline"] = "OUTLINE",
							["Font"] = "RUF",
							["Width"] = 100,
							["Position"] = {
								["y"] = 3,
								["x"] = 4,
								["AnchorTo"] = "BOTTOMLEFT",
								["Anchor"] = "BOTTOMLEFT",
								["AnchorFrame"] = "Frame"
							},
							["Size"] = 18,
							["Enabled"] = true,
							["Shadow"] = 0,
							["Tag"] = "[RUF:CurPowerPerc]"
						},
						["Level"] = {
							["Outline"] = "OUTLINE",
							["Font"] = "RUF",
							["Width"] = 100,
							["Position"] = {
								["y"] = 3,
								["x"] = -4,
								["AnchorTo"] = "BOTTOMRIGHT",
								["Anchor"] = "BOTTOMRIGHT",
								["AnchorFrame"] = "Frame"
							},
							["Size"] = 18,
							["Enabled"] = true,
							["Shadow"] = 0,
							["Tag"] = "[RUF:Level]"
						},
						["Name"] = {
							["Outline"] = "OUTLINE",
							["Font"] = "RUF",
							["Width"] = 100,
							["Position"] = {
								["y"] = 4,
								["x"] = -4,
								["AnchorTo"] = "RIGHT",
								["Anchor"] = "RIGHT",
								["AnchorFrame"] = "Frame"
							},
							["Size"] = 21,
							["Enabled"] = true,
							["Shadow"] = 0,
							["Tag"] = "[RUF:Name]"
						},
						["AFKDND"] = {
							["Outline"] = "OUTLINE",
							["Shadow"] = 0,
							["Tag"] = "[RUF:AFKDND]",
							["Position"] = {
								["y"] = 1,
								["x"] = 2,
								["AnchorTo"] = "LEFT",
								["Anchor"] = "RIGHT",
								["AnchorFrame"] = "Name"
							},
							["Enabled"] = true,
							["Size"] = 21,
							["Font"] = "RUF",
							["Width"] = 100
						}
					},
					["RangeFading"] = {
						["Enabled"] = true,
						["Alpha"] = 0.5
					},
					["Bars"] = {
						["Cast"] = {
							["Enabled"] = true,
							["Position"] = {
								["y"] = -38,
								["x"] = 0,
								["AnchorTo"] = "BOTTOM",
								["AnchorFrom"] = "TOP",
								["AnchorFrame"] = true
							},
							["Height"] = 26,
							["Fill"] = "REVERSE",
							["Width"] = 300,
							["Time"] = {
								["Enabled"] = true,
								["Font"] = "RUF",
								["Size"] = 18,
								["Outline"] = "OUTLINE",
								["Shadow"] = 0,
								["Style"] = 3
							},
							["Text"] = {
								["Enabled"] = true,
								["Font"] = "RUF",
								["Size"] = 18,
								["Outline"] = "OUTLINE",
								["Shadow"] = 0
							}
						},
						["Absorb"] = {
							["Animate"] = true,
							["Enabled"] = 1,
							["Fill"] = "REVERSE",
							["Height"] = 8,
							["Position"] = {
								["Anchor"] = "BOTTOM",
								["Order"] = 1
							}
						},
						["Health"] = {
							["Animate"] = true,
							["Fill"] = "REVERSE",
							["rainbow"] = {
								["enabled"] = false
							}
						},
						["Power"] = {
							["Animate"] = true,
							["Enabled"] = 1,
							["Fill"] = "REVERSE",
							["Height"] = 8,
							["Position"] = {
								["Anchor"] = "BOTTOM",
								["Order"] = 0
							}
						},
						["Class"] = {
							["Animate"] = true,
							["Enabled"] = true,
							["Fill"] = "REVERSE",
							["Height"] = 8,
							["Position"] = {
								["Anchor"] = "TOP"
							}
						}
					},
					["Size"] = {
						["Height"] = 60,
						["Width"] = 300
					}
				},
				["Debuffs"] = {
					["Icons"] = {
						["Enabled"] = true,
						["Columns"] = 5,
						["Max"] = 5,
						["Rows"] = 1,
						["Growth"] = {
							["y"] = "DOWN",
							["x"] = "LEFT"
						},
						["Width"] = 28,
						["CooldownSpiral"] = true,
						["Sort"] = {
							["SortBy"] = "Remaining",
							["Direction"] = "Descending"
						},
						["Spacing"] = {
							["y"] = -1,
							["x"] = 1
						},
						["Height"] = 28,
						["Filter"] = {
							["BlackOrWhite"] = "Black",
							["Dispellable"] = false,
							["Time"] = {
								["Max"] = 0,
								["Min"] = 0,
								["Unlimited"] = false
							},
							["Caster"] = {
								["Group"] = false,
								["Player"] = true,
								["Other"] = false,
								["Unit"] = true
							},
							["Lists"] = {}
						},
						["Position"] = {
							["y"] = 0,
							["x"] = -1,
							["AnchorTo"] = "BOTTOMLEFT",
							["AnchorFrom"] = "BOTTOMRIGHT",
							["AnchorFrame"] = "Frame"
						},
						["ClickThrough"] = false
					},
					["Bars"] = {}
				},
				["Buffs"] = {
					["Icons"] = {
						["Enabled"] = true,
						["Columns"] = 5,
						["Max"] = 5,
						["Rows"] = 1,
						["Growth"] = {
							["y"] = "UP",
							["x"] = "LEFT"
						},
						["Width"] = 28,
						["CooldownSpiral"] = true,
						["Sort"] = {
							["SortBy"] = "Remaining",
							["Direction"] = "Descending"
						},
						["Spacing"] = {
							["y"] = 1,
							["x"] = 1
						},
						["Height"] = 28,
						["Filter"] = {
							["BlackOrWhite"] = "Black",
							["Dispellable"] = false,
							["Time"] = {
								["Max"] = 0,
								["Min"] = 0,
								["Unlimited"] = false
							},
							["Caster"] = {
								["Group"] = false,
								["Player"] = true,
								["Other"] = false,
								["Unit"] = true
							},
							["Lists"] = {}
						},
						["Position"] = {
							["y"] = 0,
							["x"] = -1,
							["AnchorTo"] = "TOPLEFT",
							["AnchorFrom"] = "TOPRIGHT",
							["AnchorFrame"] = "Frame"
						},
						["ClickThrough"] = false
					},
					["Bars"] = {}
				}
			},
			["arenatarget"] = {
				["Enabled"] = false,
				["Frame"] = {
					["Portrait"] = {
						["Enabled"] = false,
						["Style"] = 1,
						["Cutaway"] = true,
						["Width"] = 60,
						["Height"] = 30,
						["Alpha"] = 0.75,
						["Position"] = {
							["AnchorFrom"] = "TOPLEFT",
							["AnchorTo"] = "TOPRIGHT",
							["x"] = -1,
							["y"] = 0
						},
						["Border"] = {
							["Color"] = {0, 0, 0},
							["Alpha"] = 1,
							["Offset"] = 0,
							["Style"] = {
								["edgeFile"] = "RUF Pixel",
								["edgeSize"] = 1
							}
						},
						["Background"] = {
							["Color"] = {0, 0, 0},
							["Alpha"] = 0.5
						}
					},
					["Indicators"] = {
						["LootMaster"] = {
							["Enabled"] = false,
							["Size"] = 18,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "TOPLEFT",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Frame"
							}
						},
						["Lead"] = {
							["Enabled"] = false,
							["Size"] = 18,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "TOPRIGHT",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Frame"
							}
						},
						["Role"] = {
							["Enabled"] = false,
							["Size"] = 18,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = -2,
								["x"] = 0,
								["AnchorTo"] = "CENTER",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Frame"
							}
						},
						["MainTankAssist"] = {
							["Enabled"] = false,
							["Size"] = 18,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "LEFT",
								["AnchorFrom"] = "RIGHT",
								["AnchorFrame"] = "Lead"
							}
						},
						["PvPCombat"] = {
							["Enabled"] = false,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = -2,
								["x"] = 0,
								["AnchorTo"] = "RIGHT",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Frame"
							}
						},
						["Assist"] = {
							["Enabled"] = false,
							["Size"] = 18,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "CENTER",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Lead"
							}
						},
						["PetHappiness"] = {
							["Enabled"] = false,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "CENTER",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Frame"
							}
						},
						["TargetMark"] = {
							["Enabled"] = true,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = -1,
								["x"] = 2,
								["AnchorTo"] = "LEFT",
								["AnchorFrom"] = "LEFT",
								["AnchorFrame"] = "Frame"
							}
						},
						["Ready"] = {
							["Enabled"] = false,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "LEFT",
								["AnchorFrom"] = "RIGHT",
								["AnchorFrame"] = "Frame"
							}
						}
					},
					["Position"] = {
						["y"] = 0,
						["x"] = -4,
						["offsety"] = 34,
						["AnchorTo"] = "BOTTOMLEFT",
						["growth"] = "TOP",
						["offsetx"] = 0,
						["AnchorFrom"] = "BOTTOMRIGHT",
						["AnchorFrame"] = "oUF_RUF_Arena1"
					},
					["Text"] = {
						["Name"] = {
							["Outline"] = "OUTLINE",
							["Font"] = "RUF",
							["Width"] = 100,
							["Position"] = {
								["y"] = 1,
								["x"] = 0,
								["AnchorTo"] = "CENTER",
								["Anchor"] = "CENTER",
								["AnchorFrame"] = "Frame"
							},
							["Size"] = 21,
							["Enabled"] = true,
							["Shadow"] = 0,
							["Tag"] = "[RUF:Name]"
						},
						["Level"] = {
							["Outline"] = "OUTLINE",
							["Font"] = "RUF",
							["Width"] = 100,
							["Position"] = {
								["y"] = 1,
								["x"] = 0,
								["AnchorTo"] = "CENTER",
								["Anchor"] = "CENTER",
								["AnchorFrame"] = "Frame"
							},
							["Size"] = 18,
							["Enabled"] = false,
							["Shadow"] = 0,
							["Tag"] = "[RUF:Level]"
						},
						["Health"] = {
							["Outline"] = "OUTLINE",
							["Font"] = "RUF",
							["Width"] = 100,
							["Position"] = {
								["y"] = 1,
								["x"] = 0,
								["AnchorTo"] = "CENTER",
								["Anchor"] = "CENTER",
								["AnchorFrame"] = "Frame"
							},
							["Size"] = 21,
							["Enabled"] = false,
							["Shadow"] = 0,
							["Tag"] = "[RUF:CurHPPerc]"
						},
						["Power"] = {
							["Outline"] = "OUTLINE",
							["Font"] = "RUF",
							["Width"] = 100,
							["Position"] = {
								["y"] = 1,
								["x"] = 0,
								["AnchorTo"] = "CENTER",
								["Anchor"] = "CENTER",
								["AnchorFrame"] = "Frame"
							},
							["Size"] = 18,
							["Enabled"] = false,
							["Shadow"] = 0,
							["Tag"] = "[RUF:CurPowerPerc]"
						}
					},
					["RangeFading"] = {
						["Enabled"] = true,
						["Alpha"] = 0.5
					},
					["Bars"] = {
						["Cast"] = {
							["Enabled"] = false,
							["Position"] = {
								["y"] = -38,
								["x"] = 0,
								["AnchorTo"] = "BOTTOM",
								["AnchorFrom"] = "TOP",
								["AnchorFrame"] = true
							},
							["Height"] = 26,
							["Fill"] = "STANDARD",
							["Width"] = 300,
							["Time"] = {
								["Enabled"] = true,
								["Font"] = "RUF",
								["Size"] = 18,
								["Outline"] = "OUTLINE",
								["Shadow"] = 0,
								["Style"] = 3
							},
							["Text"] = {
								["Enabled"] = true,
								["Font"] = "RUF",
								["Size"] = 18,
								["Outline"] = "OUTLINE",
								["Shadow"] = 0
							}
						},
						["Absorb"] = {
							["Animate"] = true,
							["Enabled"] = 1,
							["Fill"] = "STANDARD",
							["Height"] = 8,
							["Position"] = {
								["Anchor"] = "BOTTOM",
								["Order"] = 1
							}
						},
						["Health"] = {
							["Animate"] = true,
							["Fill"] = "STANDARD",
							["rainbow"] = {
								["enabled"] = false
							}
						},
						["Power"] = {
							["Animate"] = true,
							["Enabled"] = 1,
							["Fill"] = "STANDARD",
							["Height"] = 4,
							["Position"] = {
								["Anchor"] = "BOTTOM",
								["Order"] = 0
							}
						},
						["Class"] = {
							["Animate"] = true,
							["Enabled"] = false,
							["Fill"] = "STANDARD",
							["Height"] = 8,
							["Position"] = {
								["Anchor"] = "TOP"
							}
						}
					},
					["Size"] = {
						["Height"] = 30,
						["Width"] = 125
					}
				},
				["Debuffs"] = {
					["Icons"] = {
						["Enabled"] = true,
						["Columns"] = 5,
						["Max"] = 12,
						["Rows"] = 2,
						["Growth"] = {
							["y"] = "UP",
							["x"] = "RIGHT"
						},
						["Width"] = 28,
						["CooldownSpiral"] = true,
						["Sort"] = {
							["SortBy"] = "Remaining",
							["Direction"] = "Descending"
						},
						["Spacing"] = {
							["y"] = 2,
							["x"] = -1
						},
						["Height"] = 28,
						["Filter"] = {
							["BlackOrWhite"] = "Black",
							["Dispellable"] = false,
							["Time"] = {
								["Max"] = 0,
								["Min"] = 0,
								["Unlimited"] = false
							},
							["Caster"] = {
								["Group"] = false,
								["Player"] = true,
								["Other"] = true,
								["Unit"] = true
							},
							["Lists"] = {}
						},
						["Position"] = {
							["y"] = 0,
							["x"] = 0,
							["AnchorTo"] = "TOPRIGHT",
							["AnchorFrom"] = "BOTTOMRIGHT",
							["AnchorFrame"] = "Frame"
						},
						["ClickThrough"] = true
					},
					["Bars"] = {}
				},
				["showRaid"] = false,
				["Buffs"] = {
					["Icons"] = {
						["Enabled"] = true,
						["Columns"] = 5,
						["Max"] = 12,
						["Rows"] = 2,
						["Growth"] = {
							["y"] = "UP",
							["x"] = "RIGHT"
						},
						["Width"] = 28,
						["CooldownSpiral"] = true,
						["Sort"] = {
							["SortBy"] = "Remaining",
							["Direction"] = "Descending"
						},
						["Spacing"] = {
							["y"] = 2,
							["x"] = -1
						},
						["Height"] = 28,
						["Filter"] = {
							["BlackOrWhite"] = "Black",
							["Dispellable"] = false,
							["Time"] = {
								["Max"] = 0,
								["Min"] = 0,
								["Unlimited"] = false
							},
							["Caster"] = {
								["Group"] = false,
								["Player"] = true,
								["Other"] = true,
								["Unit"] = true
							},
							["Lists"] = {}
						},
						["Position"] = {
							["y"] = 0,
							["x"] = 0,
							["AnchorTo"] = "TOPLEFT",
							["AnchorFrom"] = "BOTTOMLEFT",
							["AnchorFrame"] = "Frame"
						},
						["ClickThrough"] = true
					},
					["Bars"] = {}
				}
			},
			["boss"] = {
				["Enabled"] = true,
				["Frame"] = {
					["Portrait"] = {
						["Enabled"] = false,
						["Style"] = 1,
						["Cutaway"] = true,
						["Width"] = 60,
						["Height"] = 60,
						["Alpha"] = 0.75,
						["Position"] = {
							["AnchorFrom"] = "TOPRIGHT",
							["AnchorTo"] = "TOPLEFT",
							["x"] = 1,
							["y"] = 0
						},
						["Border"] = {
							["Color"] = {0, 0, 0},
							["Alpha"] = 1,
							["Offset"] = 0,
							["Style"] = {
								["edgeFile"] = "RUF Pixel",
								["edgeSize"] = 1
							}
						},
						["Background"] = {
							["Color"] = {0, 0, 0},
							["Alpha"] = 0.5
						}
					},
					["Indicators"] = {
						["TargetMark"] = {
							["Enabled"] = true,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "LEFT",
								["AnchorFrom"] = "RIGHT",
								["AnchorFrame"] = "Frame"
							}
						},
						["LootMaster"] = {
							["Enabled"] = false,
							["Size"] = 14,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "TOPRIGHT",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Frame"
							}
						},
						["Lead"] = {
							["Enabled"] = false,
							["Size"] = 14,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "TOPLEFT",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Frame"
							}
						},
						["Role"] = {
							["Enabled"] = false,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "RIGHT",
								["AnchorFrom"] = "LEFT",
								["AnchorFrame"] = "Frame"
							}
						},
						["MainTankAssist"] = {
							["Enabled"] = false,
							["Size"] = 12,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "RIGHT",
								["AnchorFrom"] = "LEFT",
								["AnchorFrame"] = "Lead"
							}
						},
						["PvPCombat"] = {
							["Enabled"] = false,
							["Size"] = 28,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "LEFT",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Frame"
							}
						},
						["Assist"] = {
							["Enabled"] = false,
							["Size"] = 14,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "CENTER",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Lead"
							}
						},
						["PetHappiness"] = {
							["Enabled"] = false,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 2,
								["AnchorTo"] = "RIGHT",
								["AnchorFrom"] = "LEFT",
								["AnchorFrame"] = "Frame"
							}
						},
						["Rest"] = {
							["Enabled"] = false,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "CENTER",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Frame"
							}
						},
						["Ready"] = {
							["Enabled"] = false,
							["Size"] = 36,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = -10,
								["AnchorTo"] = "LEFT",
								["AnchorFrom"] = "RIGHT",
								["AnchorFrame"] = "Frame"
							}
						}
					},
					["Position"] = {
						["y"] = -40,
						["x"] = -4,
						["offsety"] = -4,
						["AnchorTo"] = "RIGHT",
						["growth"] = "BOTTOM",
						["offsetx"] = 0,
						["AnchorFrom"] = "TOPRIGHT",
						["AnchorFrame"] = "UIParent"
					},
					["Text"] = {
						["Health"] = {
							["Outline"] = "OUTLINE",
							["Font"] = "RUF",
							["Width"] = 150,
							["Position"] = {
								["y"] = 4,
								["x"] = 4,
								["AnchorTo"] = "LEFT",
								["Anchor"] = "LEFT",
								["AnchorFrame"] = "Frame"
							},
							["Size"] = 28,
							["Enabled"] = true,
							["Shadow"] = 0,
							["Tag"] = "[RUF:CurHPPerc]"
						},
						["Power"] = {
							["Outline"] = "OUTLINE",
							["Font"] = "RUF",
							["Width"] = 100,
							["Position"] = {
								["y"] = 3,
								["x"] = 4,
								["AnchorTo"] = "BOTTOMLEFT",
								["Anchor"] = "BOTTOMLEFT",
								["AnchorFrame"] = "Frame"
							},
							["Size"] = 18,
							["Enabled"] = true,
							["Shadow"] = 0,
							["Tag"] = "[RUF:CurPowerPerc]"
						},
						["Level"] = {
							["Outline"] = "OUTLINE",
							["Font"] = "RUF",
							["Width"] = 100,
							["Position"] = {
								["y"] = 3,
								["x"] = -4,
								["AnchorTo"] = "BOTTOMRIGHT",
								["Anchor"] = "BOTTOMRIGHT",
								["AnchorFrame"] = "Frame"
							},
							["Size"] = 18,
							["Enabled"] = true,
							["Shadow"] = 0,
							["Tag"] = "[RUF:Level]"
						},
						["Name"] = {
							["Outline"] = "OUTLINE",
							["Font"] = "RUF",
							["Width"] = 100,
							["Position"] = {
								["y"] = 4,
								["x"] = -4,
								["AnchorTo"] = "RIGHT",
								["Anchor"] = "RIGHT",
								["AnchorFrame"] = "Frame"
							},
							["Size"] = 21,
							["Enabled"] = true,
							["Shadow"] = 0,
							["Tag"] = "[RUF:Name]"
						},
						["AFKDND"] = {
							["Outline"] = "OUTLINE",
							["Shadow"] = 0,
							["Tag"] = "[RUF:AFKDND]",
							["Position"] = {
								["y"] = 1,
								["x"] = 2,
								["AnchorTo"] = "LEFT",
								["Anchor"] = "RIGHT",
								["AnchorFrame"] = "Name"
							},
							["Enabled"] = true,
							["Size"] = 21,
							["Font"] = "RUF",
							["Width"] = 100
						}
					},
					["RangeFading"] = {
						["Enabled"] = true,
						["Alpha"] = 0.5
					},
					["Bars"] = {
						["Cast"] = {
							["Enabled"] = true,
							["Position"] = {
								["y"] = -38,
								["x"] = 0,
								["AnchorTo"] = "BOTTOM",
								["AnchorFrom"] = "TOP",
								["AnchorFrame"] = true
							},
							["Height"] = 26,
							["Fill"] = "REVERSE",
							["Width"] = 300,
							["Time"] = {
								["Enabled"] = true,
								["Font"] = "RUF",
								["Size"] = 18,
								["Outline"] = "OUTLINE",
								["Shadow"] = 0,
								["Style"] = 3
							},
							["Text"] = {
								["Enabled"] = true,
								["Font"] = "RUF",
								["Size"] = 18,
								["Outline"] = "OUTLINE",
								["Shadow"] = 0
							}
						},
						["Absorb"] = {
							["Animate"] = true,
							["Enabled"] = 1,
							["Fill"] = "REVERSE",
							["Height"] = 8,
							["Position"] = {
								["Anchor"] = "BOTTOM",
								["Order"] = 1
							}
						},
						["Health"] = {
							["Animate"] = true,
							["Fill"] = "REVERSE",
							["rainbow"] = {
								["enabled"] = false
							}
						},
						["Power"] = {
							["Animate"] = true,
							["Enabled"] = 1,
							["Fill"] = "REVERSE",
							["Height"] = 8,
							["Position"] = {
								["Anchor"] = "BOTTOM",
								["Order"] = 0
							}
						},
						["Class"] = {
							["Animate"] = true,
							["Enabled"] = true,
							["Fill"] = "REVERSE",
							["Height"] = 8,
							["Position"] = {
								["Anchor"] = "TOP"
							}
						}
					},
					["Size"] = {
						["Height"] = 60,
						["Width"] = 300
					}
				},
				["Debuffs"] = {
					["Icons"] = {
						["Enabled"] = true,
						["Columns"] = 5,
						["Max"] = 5,
						["Rows"] = 1,
						["Growth"] = {
							["y"] = "DOWN",
							["x"] = "LEFT"
						},
						["Width"] = 28,
						["CooldownSpiral"] = true,
						["Sort"] = {
							["SortBy"] = "Remaining",
							["Direction"] = "Descending"
						},
						["Spacing"] = {
							["y"] = -1,
							["x"] = 1
						},
						["Height"] = 28,
						["Filter"] = {
							["BlackOrWhite"] = "Black",
							["Dispellable"] = false,
							["Time"] = {
								["Max"] = 0,
								["Min"] = 0,
								["Unlimited"] = false
							},
							["Caster"] = {
								["Group"] = false,
								["Player"] = true,
								["Other"] = false,
								["Unit"] = true
							},
							["Lists"] = {}
						},
						["Position"] = {
							["y"] = 0,
							["x"] = -1,
							["AnchorTo"] = "BOTTOMLEFT",
							["AnchorFrom"] = "BOTTOMRIGHT",
							["AnchorFrame"] = "Frame"
						},
						["ClickThrough"] = false
					},
					["Bars"] = {}
				},
				["Buffs"] = {
					["Icons"] = {
						["Enabled"] = true,
						["Columns"] = 5,
						["Max"] = 5,
						["Rows"] = 1,
						["Growth"] = {
							["y"] = "UP",
							["x"] = "LEFT"
						},
						["Width"] = 28,
						["CooldownSpiral"] = true,
						["Sort"] = {
							["SortBy"] = "Remaining",
							["Direction"] = "Descending"
						},
						["Spacing"] = {
							["y"] = 1,
							["x"] = 1
						},
						["Height"] = 28,
						["Filter"] = {
							["BlackOrWhite"] = "Black",
							["Dispellable"] = false,
							["Time"] = {
								["Max"] = 0,
								["Min"] = 0,
								["Unlimited"] = false
							},
							["Caster"] = {
								["Group"] = false,
								["Player"] = true,
								["Other"] = false,
								["Unit"] = true
							},
							["Lists"] = {}
						},
						["Position"] = {
							["y"] = 0,
							["x"] = -1,
							["AnchorTo"] = "TOPLEFT",
							["AnchorFrom"] = "TOPRIGHT",
							["AnchorFrame"] = "Frame"
						},
						["ClickThrough"] = false
					},
					["Bars"] = {}
				}
			},
			["bosstarget"] = {
				["Enabled"] = false,
				["Frame"] = {
					["Portrait"] = {
						["Enabled"] = false,
						["Style"] = 1,
						["Cutaway"] = true,
						["Width"] = 60,
						["Height"] = 30,
						["Alpha"] = 0.75,
						["Position"] = {
							["AnchorFrom"] = "TOPLEFT",
							["AnchorTo"] = "TOPRIGHT",
							["x"] = -1,
							["y"] = 0
						},
						["Border"] = {
							["Color"] = {0, 0, 0},
							["Alpha"] = 1,
							["Offset"] = 0,
							["Style"] = {
								["edgeFile"] = "RUF Pixel",
								["edgeSize"] = 1
							}
						},
						["Background"] = {
							["Color"] = {0, 0, 0},
							["Alpha"] = 0.5
						}
					},
					["Indicators"] = {
						["LootMaster"] = {
							["Enabled"] = false,
							["Size"] = 18,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "TOPLEFT",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Frame"
							}
						},
						["Lead"] = {
							["Enabled"] = false,
							["Size"] = 18,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "TOPRIGHT",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Frame"
							}
						},
						["Role"] = {
							["Enabled"] = false,
							["Size"] = 18,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = -2,
								["x"] = 0,
								["AnchorTo"] = "CENTER",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Frame"
							}
						},
						["MainTankAssist"] = {
							["Enabled"] = false,
							["Size"] = 18,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "LEFT",
								["AnchorFrom"] = "RIGHT",
								["AnchorFrame"] = "Lead"
							}
						},
						["PvPCombat"] = {
							["Enabled"] = false,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = -2,
								["x"] = 0,
								["AnchorTo"] = "RIGHT",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Frame"
							}
						},
						["Assist"] = {
							["Enabled"] = false,
							["Size"] = 18,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "CENTER",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Lead"
							}
						},
						["PetHappiness"] = {
							["Enabled"] = false,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "CENTER",
								["AnchorFrom"] = "CENTER",
								["AnchorFrame"] = "Frame"
							}
						},
						["TargetMark"] = {
							["Enabled"] = true,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = -1,
								["x"] = 2,
								["AnchorTo"] = "LEFT",
								["AnchorFrom"] = "LEFT",
								["AnchorFrame"] = "Frame"
							}
						},
						["Ready"] = {
							["Enabled"] = false,
							["Size"] = 26,
							["Style"] = "RUF",
							["Position"] = {
								["y"] = 0,
								["x"] = 0,
								["AnchorTo"] = "LEFT",
								["AnchorFrom"] = "RIGHT",
								["AnchorFrame"] = "Frame"
							}
						}
					},
					["Position"] = {
						["y"] = 0,
						["x"] = -4,
						["offsety"] = -34,
						["AnchorTo"] = "BOTTOMLEFT",
						["growth"] = "BOTTOM",
						["offsetx"] = 0,
						["AnchorFrom"] = "BOTTOMRIGHT",
						["AnchorFrame"] = "oUF_RUF_Boss1"
					},
					["Text"] = {
						["Name"] = {
							["Outline"] = "OUTLINE",
							["Font"] = "RUF",
							["Width"] = 100,
							["Position"] = {
								["y"] = 1,
								["x"] = 0,
								["AnchorTo"] = "CENTER",
								["Anchor"] = "CENTER",
								["AnchorFrame"] = "Frame"
							},
							["Size"] = 21,
							["Enabled"] = true,
							["Shadow"] = 0,
							["Tag"] = "[RUF:Name]"
						},
						["Level"] = {
							["Outline"] = "OUTLINE",
							["Font"] = "RUF",
							["Width"] = 100,
							["Position"] = {
								["y"] = 1,
								["x"] = 0,
								["AnchorTo"] = "CENTER",
								["Anchor"] = "CENTER",
								["AnchorFrame"] = "Frame"
							},
							["Size"] = 18,
							["Enabled"] = false,
							["Shadow"] = 0,
							["Tag"] = "[RUF:Level]"
						},
						["Health"] = {
							["Outline"] = "OUTLINE",
							["Font"] = "RUF",
							["Width"] = 100,
							["Position"] = {
								["y"] = 1,
								["x"] = 0,
								["AnchorTo"] = "CENTER",
								["Anchor"] = "CENTER",
								["AnchorFrame"] = "Frame"
							},
							["Size"] = 21,
							["Enabled"] = false,
							["Shadow"] = 0,
							["Tag"] = "[RUF:CurHPPerc]"
						},
						["Power"] = {
							["Outline"] = "OUTLINE",
							["Font"] = "RUF",
							["Width"] = 100,
							["Position"] = {
								["y"] = 1,
								["x"] = 0,
								["AnchorTo"] = "CENTER",
								["Anchor"] = "CENTER",
								["AnchorFrame"] = "Frame"
							},
							["Size"] = 18,
							["Enabled"] = false,
							["Shadow"] = 0,
							["Tag"] = "[RUF:CurPowerPerc]"
						}
					},
					["RangeFading"] = {
						["Enabled"] = true,
						["Alpha"] = 0.5
					},
					["Bars"] = {
						["Cast"] = {
							["Enabled"] = false,
							["Position"] = {
								["y"] = -38,
								["x"] = 0,
								["AnchorTo"] = "BOTTOM",
								["AnchorFrom"] = "TOP",
								["AnchorFrame"] = true
							},
							["Height"] = 26,
							["Fill"] = "STANDARD",
							["Width"] = 300,
							["Time"] = {
								["Enabled"] = true,
								["Font"] = "RUF",
								["Size"] = 18,
								["Outline"] = "OUTLINE",
								["Shadow"] = 0,
								["Style"] = 3
							},
							["Text"] = {
								["Enabled"] = true,
								["Font"] = "RUF",
								["Size"] = 18,
								["Outline"] = "OUTLINE",
								["Shadow"] = 0
							}
						},
						["Absorb"] = {
							["Animate"] = true,
							["Enabled"] = 1,
							["Fill"] = "STANDARD",
							["Height"] = 8,
							["Position"] = {
								["Anchor"] = "BOTTOM",
								["Order"] = 1
							}
						},
						["Health"] = {
							["Animate"] = true,
							["Fill"] = "STANDARD",
							["rainbow"] = {
								["enabled"] = false
							}
						},
						["Power"] = {
							["Animate"] = true,
							["Enabled"] = 1,
							["Fill"] = "STANDARD",
							["Height"] = 4,
							["Position"] = {
								["Anchor"] = "BOTTOM",
								["Order"] = 0
							}
						},
						["Class"] = {
							["Animate"] = true,
							["Enabled"] = false,
							["Fill"] = "STANDARD",
							["Height"] = 8,
							["Position"] = {
								["Anchor"] = "TOP"
							}
						}
					},
					["Size"] = {
						["Height"] = 30,
						["Width"] = 125
					}
				},
				["Debuffs"] = {
					["Icons"] = {
						["Enabled"] = true,
						["Columns"] = 5,
						["Max"] = 12,
						["Rows"] = 2,
						["Growth"] = {
							["y"] = "UP",
							["x"] = "RIGHT"
						},
						["Width"] = 28,
						["CooldownSpiral"] = true,
						["Sort"] = {
							["SortBy"] = "Remaining",
							["Direction"] = "Descending"
						},
						["Spacing"] = {
							["y"] = 2,
							["x"] = -1
						},
						["Height"] = 28,
						["Filter"] = {
							["BlackOrWhite"] = "Black",
							["Dispellable"] = false,
							["Time"] = {
								["Max"] = 0,
								["Min"] = 0,
								["Unlimited"] = false
							},
							["Caster"] = {
								["Group"] = false,
								["Player"] = true,
								["Other"] = true,
								["Unit"] = true
							},
							["Lists"] = {}
						},
						["Position"] = {
							["y"] = 0,
							["x"] = 0,
							["AnchorTo"] = "TOPRIGHT",
							["AnchorFrom"] = "BOTTOMRIGHT",
							["AnchorFrame"] = "Frame"
						},
						["ClickThrough"] = true
					},
					["Bars"] = {}
				},
				["showRaid"] = false,
				["Buffs"] = {
					["Icons"] = {
						["Enabled"] = true,
						["Columns"] = 5,
						["Max"] = 12,
						["Rows"] = 2,
						["Growth"] = {
							["y"] = "UP",
							["x"] = "RIGHT"
						},
						["Width"] = 28,
						["CooldownSpiral"] = true,
						["Sort"] = {
							["SortBy"] = "Remaining",
							["Direction"] = "Descending"
						},
						["Spacing"] = {
							["y"] = 2,
							["x"] = -1
						},
						["Height"] = 28,
						["Filter"] = {
							["BlackOrWhite"] = "Black",
							["Dispellable"] = false,
							["Time"] = {
								["Max"] = 0,
								["Min"] = 0,
								["Unlimited"] = false
							},
							["Caster"] = {
								["Group"] = false,
								["Player"] = true,
								["Other"] = true,
								["Unit"] = true
							},
							["Lists"] = {}
						},
						["Position"] = {
							["y"] = 0,
							["x"] = 0,
							["AnchorTo"] = "TOPLEFT",
							["AnchorFrom"] = "BOTTOMLEFT",
							["AnchorFrame"] = "Frame"
						},
						["ClickThrough"] = true
					},
					["Bars"] = {}
				}
			}
		}
	}
}

RUF.Layout.cfg = cfg