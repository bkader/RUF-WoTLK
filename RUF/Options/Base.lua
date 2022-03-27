local RUF = RUF
local _, ns = ...
local oUF = ns.oUF
local RUF_Options = RUF:GetModule("Options")

local L = LibStub("AceLocale-3.0"):GetLocale("RUF")

function RUF_Options.MainOptions()
	local options = {
		type = "group",
		name = "RUF r|c5500DBBD" .. RUF.db.global.Version .. "|r",
		order = 0,
		childGroups = "tab",
		args = {
			showAlways = {
				type = "group",
				name = "",
				inline = true,
				order = 0,
				args = {
					FrameLock = {
						name = "|cff00B2FA" .. L["Frame Lock"] .. "|r",
						desc = L["Allow unit frames to be repositioned by dragging."],
						order = 0,
						type = "toggle",
						get = function(info) return RUF.db.global.frameLock end,
						set = function(info, value)
							RUF.db.global.frameLock = value
							RUF.ToggleFrameLock(value == true)
						end
					},
					TestMode = {
						type = "toggle",
						name = "|cff00B2FA" .. L["Test Mode"] .. "|r",
						desc = L["Shows all unitframes so you can easily configure them."],
						order = 1,
						get = function(info) return RUF.db.global.TestMode end,
						set = function(info, value)
							RUF.db.global.TestMode = value
							RUF:TestMode()
						end
					},
					TestModeShowUnits = {
						type = "toggle",
						name = "|cff00B2FA" .. L["Show Unit in Test Mode"] .. "|r",
						desc = L["Displays the name of the unit frame in test mode."],
						order = 2,
						width = "double",
						get = function(info) return RUF.db.global.TestModeShowUnits end,
						set = function(info, value)
							RUF.db.global.TestModeShowUnits = value
							RUF:TestMode()
						end
					},
					pixelScale = {
						type = "toggle",
						name = "|cff00B2FA" .. L["Pixel Perfect scaling"] .. "|r",
						desc = L["Scales RUF to be pixel perfect if it isn't already. Only affects RUF."],
						order = 3,
						get = function(info) return RUF.db.global.pixelScale end,
						set = function(info, value)
							RUF.db.global.pixelScale = value
							RUF:PixelScale()
						end
					}
				}
			},
			Appearance = {
				type = "group",
				name = L["General"],
				desc = L["These settings affect all frames."],
				childGroups = "tab",
				order = 1,
				args = {
					globalDesc = {
						name = L["These settings affect all frames."],
						type = "description",
						order = 0
					},
					Bars = {
						type = "group",
						name = L["Bars"],
						order = 2,
						args = {}
					},
					Colors = {
						type = "group",
						name = L["Colors"],
						order = 1,
						args = {}
					},
					auras = {
						type = "group",
						name = L["Auras"],
						order = 4,
						childGroups = "tab",
						args = {
							colors = {
								type = "group",
								name = L["Aura Colors"],
								inline = true,
								order = 0,
								args = {
									buffColorType = {
										type = "toggle",
										name = L["Color Buffs by Type"],
										order = 0.01,
										get = function(info)
											return RUF.db.profile.Appearance.Aura.Buff
										end,
										set = function(info, value)
											RUF.db.profile.Appearance.Aura.Buff = value
											RUF:OptionsUpdateAllAuras()
										end
									},
									debuffColorType = {
										name = L["Color Debuffs by Type"],
										type = "toggle",
										order = 0.01,
										get = function(info)
											return RUF.db.profile.Appearance.Aura.Debuff
										end,
										set = function(info, value)
											RUF.db.profile.Appearance.Aura.Debuff = value
											RUF:OptionsUpdateAllAuras()
										end
									},
									onlyDispellableColoring = {
										type = "toggle",
										name = L["Color only removable"],
										desc = L["Color auras by type only if you can dispel / purge them."],
										order = 0.01,
										get = function(info)
											return RUF.db.profile.Appearance.Aura.OnlyDispellable
										end,
										set = function(info, value)
											RUF.db.profile.Appearance.Aura.OnlyDispellable = value
											RUF:OptionsUpdateAllAuras()
										end
									},
									buffColor = {
										name = L["Default Buff Glow"],
										type = "color",
										hasAlpha = true,
										order = 0.1,
										get = function(info) return unpack(RUF.db.profile.Appearance.Colors.Aura.DefaultBuff) end,
										set = function(info, r, g, b, a)
											RUF.db.profile.Appearance.Colors.Aura.DefaultBuff = {r, g, b, a}
											RUF:OptionsUpdateAllAuras()
										end
									},
									debuffColor = {
										type = "color",
										name = L["Default Debuff Glow"],
										hasAlpha = true,
										order = 0.1,
										get = function(info) return unpack(RUF.db.profile.Appearance.Colors.Aura.DefaultDebuff) end,
										set = function(info, r, g, b, a)
											RUF.db.profile.Appearance.Colors.Aura.DefaultDebuff = {r, g, b, a}
											RUF:OptionsUpdateAllAuras()
										end
									},
									colorMagic = {
										type = "color",
										name = L["Magic"],
										hasAlpha = true,
										order = 0.3,
										get = function(info) return unpack(RUF.db.profile.Appearance.Colors.Aura.Magic) end,
										set = function(info, r, g, b, a)
											RUF.db.profile.Appearance.Colors.Aura.Magic = {r, g, b, a}
											RUF:OptionsUpdateAllAuras()
										end
									},
									colorDisease = {
										type = "color",
										name = L["Disease"],
										hasAlpha = true,
										order = 0.3,
										get = function(info) return unpack(RUF.db.profile.Appearance.Colors.Aura.Disease) end,
										set = function(info, r, g, b, a)
											RUF.db.profile.Appearance.Colors.Aura.Disease = {r, g, b, a}
											RUF:OptionsUpdateAllAuras()
										end
									},
									colorCurse = {
										type = "color",
										name = L["Curse"],
										hasAlpha = true,
										order = 0.3,
										get = function(info) return unpack(RUF.db.profile.Appearance.Colors.Aura.Curse) end,
										set = function(info, r, g, b, a)
											RUF.db.profile.Appearance.Colors.Aura.Curse = {r, g, b, a}
											RUF:OptionsUpdateAllAuras()
										end
									},
									colorPoison = {
										type = "color",
										name = L["Poison"],
										hasAlpha = true,
										order = 0.3,
										get = function(info) return unpack(RUF.db.profile.Appearance.Colors.Aura.Poison) end,
										set = function(info, r, g, b, a)
											RUF.db.profile.Appearance.Colors.Aura.Poison = {r, g, b, a}
											RUF:OptionsUpdateAllAuras()
										end
									},
									colorEnrage = {
										type = "color",
										name = L["Enrage"],
										hasAlpha = true,
										order = 0.3,
										get = function(info) return unpack(RUF.db.profile.Appearance.Colors.Aura.Enrage) end,
										set = function(info, r, g, b, a)
											RUF.db.profile.Appearance.Colors.Aura.Enrage = {r, g, b, a}
											RUF:OptionsUpdateAllAuras()
										end
									}
								}
							},
							highlightBorder = {
								type = "group",
								name = L["Aura Highlight Glow"],
								order = 1,
								inline = true,
								args = {
									desc = {
										type = "description",
										name = L["The border on buff or debuff icons that is colored using the colors above."],
										order = 0,
										width = "full"
									},
									highlightTexture = {
										type = "select",
										name = L["Texture"],
										order = 1,
										values = RUF:MediaList("border"),
										dialogControl = "LSM30_Border",
										get = function(info)
											return RUF.db.profile.Appearance.Aura.Border.Style.edgeFile
										end,
										set = function(info, value)
											RUF.db.profile.Appearance.Aura.Border.Style.edgeFile = value
											RUF:OptionsUpdateAllAuras()
										end
									},
									highlightSize = {
										type = "range",
										name = L["Size"],
										desc = L["Thickness of the highlight."],
										order = 1.1,
										min = -100,
										max = 100,
										softMin = -20,
										softMax = 20,
										step = 0.01,
										bigStep = 0.05,
										get = function(info)
											return RUF.db.profile.Appearance.Aura.Border.Style.edgeSize
										end,
										set = function(info, value)
											RUF.db.profile.Appearance.Aura.Border.Style.edgeSize = value
											RUF:OptionsUpdateAllAuras()
										end
									},
									highlightOffset = {
										type = "range",
										name = L["Size relative to the aura icon"],
										order = 1.2,
										min = -100,
										max = 100,
										softMin = -30,
										softMax = 30,
										step = 1,
										bigStep = 1,
										get = function(info)
											return RUF.db.profile.Appearance.Aura.Border.Offset
										end,
										set = function(info, value)
											RUF.db.profile.Appearance.Aura.Border.Offset = value
											RUF:OptionsUpdateAllAuras()
										end
									}
								}
							},
							pixelBorder = {
								type = "group",
								name = L["Simple Border"],
								order = 2,
								inline = true,
								args = {
									desc = {
										type = "description",
										name = L["A simple border around the edge of each buff or debuff icon."],
										order = 0,
										width = "full"
									},
									pixelEnabled = {
										type = "toggle",
										name = function()
											if RUF.db.profile.Appearance.Aura.Pixel.Enabled == true then
												return "|cFF00FF00" .. L["Enabled"] .. "|r"
											else
												return "|cFFFF0000" .. L["Enabled"] .. "|r"
											end
										end,
										order = 15.01,
										width = "full",
										get = function(info)
											return RUF.db.profile.Appearance.Aura.Pixel.Enabled
										end,
										set = function(info, value)
											RUF.db.profile.Appearance.Aura.Pixel.Enabled = value
											RUF:OptionsUpdateAllAuras()
										end
									},
									pixelTexture = {
										type = "select",
										name = L["Texture"],
										order = 15.1,
										values = RUF:MediaList("border"),
										dialogControl = "LSM30_Border",
										get = function(info)
											return RUF.db.profile.Appearance.Aura.Pixel.Style.edgeFile
										end,
										set = function(info, value)
											RUF.db.profile.Appearance.Aura.Pixel.Style.edgeFile = value
											RUF:OptionsUpdateAllAuras()
										end
									},
									pixelSize = {
										type = "range",
										name = L["Size"],
										order = 15.2,
										min = -100,
										max = 100,
										softMin = -20,
										softMax = 20,
										step = 0.01,
										bigStep = 0.05,
										get = function(info)
											return RUF.db.profile.Appearance.Aura.Pixel.Style.edgeSize
										end,
										set = function(info, value)
											RUF.db.profile.Appearance.Aura.Pixel.Style.edgeSize = value
											RUF:OptionsUpdateAllAuras()
										end
									},
									pixelOffset = {
										type = "range",
										name = L["Inset from icon edge"],
										order = 15.3,
										min = -100,
										max = 100,
										softMin = -30,
										softMax = 30,
										step = 1,
										bigStep = 1,
										get = function(info)
											return RUF.db.profile.Appearance.Aura.Pixel.Offset
										end,
										set = function(info, value)
											RUF.db.profile.Appearance.Aura.Pixel.Offset = value
											RUF:OptionsUpdateAllAuras()
										end
									},
									pixelColor = {
										type = "color",
										name = L["Color"],
										hasAlpha = true,
										order = 15.4,
										get = function(info) return unpack(RUF.db.profile.Appearance.Colors.Aura.Pixel) end,
										set = function(info, r, g, b, a)
											RUF.db.profile.Appearance.Colors.Aura.Pixel = {r, g, b, a}
											RUF:OptionsUpdateAllAuras()
										end
									}
								}
							},
							frameGlow = {
								type = "group",
								name = L["Frame Highlighting"],
								order = 3,
								inline = true,
								args = {
									desc = {
										type = "description",
										name = L["The unit frame border that glows when the unit has a dispellable buff or debuff."],
										order = 0,
										width = "full"
									},
									frameGlowEnabled = {
										type = "toggle",
										name = function()
											if RUF.db.profile.Appearance.Border.Glow.Enabled == true then
												return "|cFF00FF00" .. L["Enabled"] .. "|r"
											else
												return "|cFFFF0000" .. L["Enabled"] .. "|r"
											end
										end,
										order = 0.01,
										width = "full",
										get = function(info)
											return RUF.db.profile.Appearance.Border.Glow.Enabled
										end,
										set = function(info, value)
											RUF.db.profile.Appearance.Border.Glow.Enabled = value
											RUF:OptionsUpdateFrameBorders()
										end
									},
									frameGlowTexture = {
										type = "select",
										name = L["Texture"],
										order = 0.02,
										values = RUF:MediaList("border"),
										dialogControl = "LSM30_Border",
										get = function(info)
											return RUF.db.profile.Appearance.Border.Glow.Style.edgeFile
										end,
										set = function(info, value)
											RUF.db.profile.Appearance.Border.Glow.Style.edgeFile = value
											RUF:OptionsUpdateFrameBorders()
										end
									},
									frameGlowSize = {
										type = "range",
										name = L["Size"],
										order = 0.03,
										min = -100,
										max = 100,
										softMin = -20,
										softMax = 20,
										step = 0.01,
										bigStep = 0.05,
										get = function(info)
											return RUF.db.profile.Appearance.Border.Glow.Style.edgeSize
										end,
										set = function(info, value)
											RUF.db.profile.Appearance.Border.Glow.Style.edgeSize = value
											RUF:OptionsUpdateFrameBorders()
										end
									},
									frameGlowOffset = {
										type = "range",
										name = L["Inset from frame edge"],
										order = 0.04,
										min = -100,
										max = 100,
										softMin = -30,
										softMax = 30,
										step = 1,
										bigStep = 1,
										get = function(info)
											return RUF.db.profile.Appearance.Border.Glow.Offset
										end,
										set = function(info, value)
											RUF.db.profile.Appearance.Border.Glow.Offset = value
											RUF:OptionsUpdateFrameBorders()
										end
									},
									frameGlowAlpha = {
										type = "range",
										name = L["Alpha"],
										isPercent = true,
										order = 0.05,
										min = 0,
										max = 1,
										softMin = 0,
										softMax = 1,
										step = 0.1,
										bigStep = 0.1,
										get = function(info)
											return RUF.db.profile.Appearance.Border.Glow.Alpha
										end,
										set = function(info, value)
											RUF.db.profile.Appearance.Border.Glow.Alpha = value
											RUF:OptionsUpdateFrameBorders()
										end
									},
									frameGlowSoundToggle = {
										type = "toggle",
										name = L["Play sound on highlight"],
										desc = L["Plays a sound when a removable aura is found on a unit. Does not affect target units."],
										order = 0.08,
										width = "double",
										get = function(info)
											return RUF.db.profile.Appearance.Border.Glow.SoundEnabled
										end,
										set = function(info, value)
											RUF.db.profile.Appearance.Border.Glow.SoundEnabled = value
										end
									},
									frameGlowSound = {
										type = "select",
										name = L["Sound"],
										order = 0.09,
										values = RUF:MediaList("sound"),
										dialogControl = "LSM30_Sound",
										hidden = function()
											return not RUF.db.profile.Appearance.Border.Glow.SoundEnabled
										end,
										get = function(info)
											return RUF.db.profile.Appearance.Border.Glow.Sound
										end,
										set = function(info, value)
											RUF.db.profile.Appearance.Border.Glow.Sound = value
										end
									}
								}
							},
							spiral = {
								type = "group",
								name = L["Cooldown Sprial"],
								order = 4,
								inline = true,
								args = {
									enabled = {
										type = "toggle",
										name = L["Enabled"],
										desc = L["Enables the cooldown spiral showing duration remaining on buff or debuff icons."],
										order = 0.01,
										get = function(info)
											return RUF.db.profile.Appearance.Aura.spiral.enabled
										end,
										set = function(info, value)
											RUF.db.profile.Appearance.Aura.spiral.enabled = value
											RUF:OptionsUpdateAllAuras()
										end
									},
									reverse = {
										type = "toggle",
										name = L["Reverse Spiral"],
										desc = L["Starts the cooldown spirals as empty, filling up as the aura runs out."],
										order = 0.02,
										get = function(info)
											return RUF.db.profile.Appearance.Aura.spiral.reverse
										end,
										set = function(info, value)
											RUF.db.profile.Appearance.Aura.spiral.reverse = value
											RUF:OptionsUpdateAllAuras()
										end
									}
								}
							}
						}
					},
					frameBorder = {
						type = "group",
						name = L["Frame Border"],
						order = 5,
						args = {
							texture = {
								type = "select",
								name = L["Texture"],
								order = 0.02,
								values = RUF:MediaList("border"),
								dialogControl = "LSM30_Border",
								get = function(info)
									return RUF.db.profile.Appearance.Border.Style.edgeFile
								end,
								set = function(info, value)
									RUF.db.profile.Appearance.Border.Style.edgeFile = value
									RUF:OptionsUpdateFrameBorders()
								end
							},
							size = {
								type = "range",
								name = L["Size"],
								order = 0.03,
								min = -100,
								max = 100,
								softMin = -20,
								softMax = 20,
								step = 0.01,
								bigStep = 0.05,
								get = function(info)
									return RUF.db.profile.Appearance.Border.Style.edgeSize
								end,
								set = function(info, value)
									RUF.db.profile.Appearance.Border.Style.edgeSize = value
									RUF:OptionsUpdateFrameBorders()
								end
							},
							offset = {
								type = "range",
								name = L["Inset from frame edge"],
								order = 0.04,
								min = -100,
								max = 100,
								softMin = -30,
								softMax = 30,
								step = 1,
								bigStep = 1,
								get = function(info)
									return RUF.db.profile.Appearance.Border.Offset
								end,
								set = function(info, value)
									RUF.db.profile.Appearance.Border.Offset = value
									RUF:OptionsUpdateFrameBorders()
								end
							},
							alpha = {
								type = "range",
								name = L["Alpha"],
								isPercent = true,
								order = 0.05,
								min = 0,
								max = 1,
								softMin = 0,
								softMax = 1,
								step = 0.01,
								bigStep = 0.05,
								get = function(info)
									return RUF.db.profile.Appearance.Border.Alpha
								end,
								set = function(info, value)
									RUF.db.profile.Appearance.Border.Alpha = value
									RUF:OptionsUpdateFrameBorders()
								end
							},
							color = {
								type = "color",
								name = L["Color"],
								order = 0.06,
								get = function(info)
									return unpack(RUF.db.profile.Appearance.Border.Color)
								end,
								set = function(info, r, g, b)
									RUF.db.profile.Appearance.Border.Color = {r, g, b}
									RUF:OptionsUpdateFrameBorders()
								end
							}
						}
					},
					combatFading = {
						type = "group",
						name = L["Combat Fading"],
						order = 6,
						args = {
							enabled = {
								type = "toggle",
								name = function()
									if RUF.db.profile.Appearance.CombatFader.Enabled == true then
										return "|cFF00FF00" .. L["Enabled"] .. "|r"
									else
										return "|cFFFF0000" .. L["Enabled"] .. "|r"
									end
								end,
								order = 0.1,
								get = function(info)
									return RUF.db.profile.Appearance.CombatFader.Enabled
								end,
								set = function(info, value)
									RUF.db.profile.Appearance.CombatFader.Enabled = value
									RUF.CombatFaderRegister()
								end
							},
							enabledSpacer = {
								type = "description",
								name = " ",
								order = 0.15,
								width = "full"
							},
							combatAlpha = {
								type = "range",
								name = L["In combat alpha"],
								isPercent = true,
								order = 0.25,
								min = 0,
								max = 1,
								softMin = 0,
								softMax = 1,
								step = 0.01,
								bigStep = 0.05,
								get = function(info)
									return RUF.db.profile.Appearance.CombatFader.combatAlpha
								end,
								set = function(info, value)
									RUF.db.profile.Appearance.CombatFader.combatAlpha = value
									RUF.CombatFaderUpdate()
								end
							},
							restAlpha = {
								type = "range",
								name = L["Out of combat alpha"],
								isPercent = true,
								order = 0.26,
								min = 0,
								max = 1,
								softMin = 0,
								softMax = 1,
								step = 0.01,
								bigStep = 0.01,
								get = function(info)
									return RUF.db.profile.Appearance.CombatFader.restAlpha
								end,
								set = function(info, value)
									RUF.db.profile.Appearance.CombatFader.restAlpha = value
									RUF.CombatFaderUpdate()
								end
							},
							restSpacer = {
								type = "description",
								name = " ",
								order = 0.3,
								width = "full"
							},
							disableWithTarget = {
								type = "toggle",
								name = L["Enable targeting alpha"],
								desc = L["Use a different alpha value when you have a target."],
								order = 0.35,
								get = function(info)
									return RUF.db.profile.Appearance.CombatFader.targetOverride
								end,
								set = function(info, value)
									RUF.db.profile.Appearance.CombatFader.targetOverride = value
									RUF.CombatFaderRegister()
								end
							},
							targetAlpha = {
								type = "range",
								name = L["Targeting alpha"],
								desc = L["Alpha of all frames when you are targeting something."],
								isPercent = true,
								order = 0.36,
								min = 0,
								max = 1,
								softMin = 0,
								softMax = 1,
								step = 0.01,
								bigStep = 0.01,
								disabled = function()
									return not RUF.db.profile.Appearance.CombatFader.targetOverride
								end,
								get = function(info)
									return RUF.db.profile.Appearance.CombatFader.targetAlpha
								end,
								set = function(info, value)
									RUF.db.profile.Appearance.CombatFader.targetAlpha = value
									RUF.CombatFaderUpdate()
								end
							},
							targetSpacer = {
								type = "description",
								name = " ",
								order = 0.4,
								width = "full"
							},
							damagedAlphaToggle = {
								type = "toggle",
								name = L["Enable player damaged alpha"],
								desc = L["Use a different alpha value for the player frame when you are under max health."],
								width = "double",
								order = 0.45,
								get = function(info)
									return RUF.db.profile.Appearance.CombatFader.damagedOverride
								end,
								set = function(info, value)
									RUF.db.profile.Appearance.CombatFader.damagedOverride = value
									RUF.CombatFaderRegister()
								end
							},
							damagedPercentTrigger = {
								type = "range",
								name = L["Trigger below this percent"],
								desc = L["The damaged alpha will only be used when you are below this percentage of health."],
								isPercent = true,
								order = 0.46,
								min = 0.01,
								max = 1,
								softMin = 0.01,
								softMax = 1,
								step = 0.001,
								bigStep = 0.01,
								disabled = function()
									return not RUF.db.profile.Appearance.CombatFader.damagedOverride
								end,
								get = function(info)
									return RUF.db.profile.Appearance.CombatFader.damagedPercent / 100
								end,
								set = function(info, value)
									RUF.db.profile.Appearance.CombatFader.damagedPercent = value * 100
									RUF.CombatFaderUpdate()
								end
							},
							damagedAlpha = {
								type = "range",
								name = L["Damaged alpha"],
								desc = L["Alpha of the player frame when you are under max health."],
								isPercent = true,
								order = 0.47,
								min = 0,
								max = 1,
								softMin = 0,
								softMax = 1,
								step = 0.01,
								bigStep = 0.01,
								disabled = function()
									return not RUF.db.profile.Appearance.CombatFader.damagedOverride
								end,
								get = function(info)
									return RUF.db.profile.Appearance.CombatFader.damagedAlpha
								end,
								set = function(info, value)
									RUF.db.profile.Appearance.CombatFader.damagedAlpha = value
									RUF.CombatFaderUpdate()
								end
							}
						}
					},
					disableBlizzard = {
						type = "group",
						name = L["Disable Blizzard Frames"],
						order = 7,
						args = {}
					}
				}
			},
			Unit = {
				type = "group",
				name = L["Unit Options"],
				order = 2,
				args = {}
			},
			Filtering = {
				type = "group",
				name = L["Filtering"],
				order = 3,
				hidden = true,
				args = {}
			},
			Feedback = {
				type = "group",
				name = L["Feedback"],
				order = 1000,
				args = {
					Head = {
						type = "header",
						name = L["Feedback"],
						order = 0
					},
					Revision = {
						type = "description",
						name = "|cffFFCC00" .. L["Current Version: %s"]:format("r|r|c5500DBBD" .. RUF.db.global.Version) .. "|r",
						order = 0.5,
						fontSize = "large"
					},
					RevisionDescription = {
						type = "description",
						name = L["When reporting an issue, please also post the revision number above. Thanks!"],
						order = 0.6
					},
					RevisionDate = {
						type = "description",
						name = GetAddOnMetadata("RUF", "X-Date"),
						order = 0.7
					},
					Spacer_FeedbackOnline = {
						type = "description",
						name = "\n",
						order = 1
					},
					GitHub_Header = {
						type = "description",
						name = "|cff91BE0F" .. L["GitHub"] .. "|r",
						order = 50,
						fontSize = "large"
					},
					GitHub_URL = {
						type = "input",
						name = L["URL"],
						order = 50.2,
						width = "full",
						get = function() return GetAddOnMetadata("RUF", "X-Website") end,
						set = function() return GetAddOnMetadata("RUF", "X-Website") end
					},
					Spacer_OnlineCommunity1 = {
						name = "\n\n",
						type = "description",
						order = 75
					},
					Community_Header = {
						type = "description",
						name = "|cff00B2FA" .. L["Discord"] .. "|r",
						order = 100,
						fontSize = "large"
					},
					Community_URL = {
						name = L["Invite Link"],
						type = "input",
						order = 100.2,
						width = "full",
						get = function() return GetAddOnMetadata("RUF", "X-Discord") end,
						set = function() return GetAddOnMetadata("RUF", "X-Discord") end
					},
					Spacer_OnlineCommunity2 = {
						type = "description",
						name = "\n\n",
						order = 125
					},
					Donate_Header = {
						type = "description",
						name = "|cffffa500Donation|r",
						order = 150,
						fontSize = "large"
					},
					Donate_URL = {
						type = "input",
						name = "PayPal/Paysera Email",
						order = 150.2,
						width = "full",
						get = function() return GetAddOnMetadata("RUF", "X-Email") end,
						set = function() return GetAddOnMetadata("RUF", "X-Email") end
					}
				}
			}
		}
	}

	local blizzardFrames = {
		"player",
		"pet",
		"target",
		"focus",
		"targettarget",
		"boss",
		"party",
		"arena"
	}

	for i = 1, #blizzardFrames do
		options.args.Appearance.args.disableBlizzard.args[blizzardFrames[i]] = {
			name = L[blizzardFrames[i]],
			type = "toggle",
			get = function(info)
				return RUF.db.profile.Appearance.disableBlizzard[blizzardFrames[i]]
			end,
			set = function(info, value)
				RUF.db.profile.Appearance.disableBlizzard[blizzardFrames[i]] = value
				if value == true then
					oUF:DisableBlizzard(blizzardFrames[i])
				end
			end
		}
	end

	return options
end