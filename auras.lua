local RetailAuras = {
    ["DEATHKNIGHT"] = {
        ["player"] = {
            ["all"] = {
                "Death's Advance",
                "Dark Succor",
                "Anti-Magic Shell",
                "Icebound Fortitude",
                "Abomination Limb",
            },
            ["Blood"] = {
                "Bone Shield",
                "Blood Shield",
            },
            ["Frost"] = {
                "Cold Heart",
                "Killing Machine",
                { "Icy Talons", "Unleashed Frenzy", },
            },
            ["Unholy"] = {
            },
        },
        ["target"] = {
            ["all"] = {
            },
            ["Blood"] = {
                "Blood Plague",
            },
            ["Frost"] = {
                "Frost Fever",
            },
            ["Unholy"] = {
                "Festering Wound",
                "Virulent Plague",
            },
        },
    },
    ["DEMONHUNTER"] = {
        ["player"] = {
            ["all"] = {
                "Immolation Aura",
            },
            ["Havoc"] = {
                "Bone Shield",
            },
            ["Vengeance"] = {
            },
        },
        ["target"] = {
            ["all"] = {
            },
            ["Havoc"] = {
            },
            ["Vengeance"] = {
            },
        },
    },
    ["DRUID"] = {
        ["player"] = {
            ["all"] = {
                "Clearcasting",
                "Survival Instincts",
            },
            ["Balance"] = {
                { "Eclipse (Lunar)", "Eclipse (Solar)", }
            },
            ["Feral"] = {
                "Tiger's Fury",
                "Berserk",
                "Predatory Swiftness",
                "Bloodtalons",
                "Sudden Ambush",
            },
            ["Guardian"] = {
                "Ironfur",
                "Pulverize",
            },
            ["Restoration"] = {
            },
        },
        ["target"] = {
            ["all"] = {
                "Moonfire",
                "Dreadful Wound",
            },
            ["Balance"] = {
                "Sunfire",
            },
            ["Feral"] = {
                "Rake",
                "Rip",
                "Thrash",
                "Maim",
            },
            ["Guardian"] = {
                "Thrash",
            },
            ["Restoration"] = {
            },
        },
    },
    ["EVOKER"] = {
        ["player"] = {
            ["Devastation"] = {
                "Essence Burst",
            },
            ["Augmentation"] = {
                "Ebon Might",
            },
            ["all"] = {
            },
        },
        ["target"] = {
            ["all"] = {
            },
        }
    },
    ["HUNTER"] = {
        ["player"] = {
            ["all"] = {
                "Misdirection",
                "Aspect of the Hawk",
            },
            ["Survival"] = {
                "Mongoose Fury",
            },
            ["Marksmanship"] = {
                "Trueshot",
            },
            ["Beast Mastery"] = {
                "Bestial Wrath",
                "Beast Cleave",
            }
        },
        ["pet"] = {
            ["all"] = {
                "Mend Pet",
            },
            ["Beast Mastery"] = {
                "Frenzy",
            },
        },
        ["target"] = {
            ["all"] = {
                "Serpent Sting",
            },
            ["Beast Mastery"] = {
                "Concussive Shot",
            },
            ["Marksmanship"] = {
                "Hunter's Mark",
                "Concussive Shot",
            },
            ["Survival"] = {
                "Serpent Sting",
                "Wildfire Bomb",
                "Wing Clip",
            },
        }
    },
    ["MAGE"] = {
        ["player"] = {
            ["all"] = {
            },
            ["Arcane"] = {
                "Clearcasting",
                "Prismatic Barrier",
                "Arcane Tempo",
            },
            ["Frost"] = {
                "Brain Freeze",
                "Fingers of Frost",
                "Icicles",
                "Icy Veins",
            },
            ["Fire"] = {
                "Hot Streak!",
                "Blazing Barrier",
                "Combustion",
            },
        },
        ["target"] = {
            ["all"] = {
            },
            ["Arcane"] = {
            },
            ["Frost"] = {
                "Winter's Chill",
            },
            ["Fire"] = {
                "Dragon's Breath",
            },
        },
    },
    ["MONK"] = {
        ["player"] = {
            ["all"] = {
            },
            ["Brewmaster"] = {
            },
            ["Mistweaver"] = {
            },
            ["Windwalker"] = {
                "Teachings of the Monastery",
                "Last Emperor's Capacitor",
            },
        },
        ["target"] = {
            ["all"] = {
            },
            ["Brewmaster"] = {
            },
            ["Mistweaver"] = {
            },
            ["Windwalker"] = {
            },
        },
    },
    ["PALADIN"] = {
        ["player"] = {
            ["Protection"] = {
                "Shield of the Righteous",
                "Ardent Defender",
                "Consecration",
                "Shining Light",
                "Guardian of the Ancient Kings",
            },
            ["Holy"] = {
                "Divine Protection",
                "Aura Mastery",
            },
            ["Retribution"] = {
                "Shield of Vengeance",
            },
            ["all"] = {
                "Divine Shield",
                "Blessing of Freedom",
                "Blessing of Protection",
                "Blessing of Sacrifice",
                { "Avenging Wrath", "Sentinel" },
                "Blessing of Dawn",
                "Blessing of Dusk",
                "Divine Steed",
            },
        },
        ["target"] = {
            ["all"] = {
                "Hammer of Justice",
            },
            ["Protection"] = {
                "Eye of Tyr",
            },
        }
    },
    ["PRIEST"] = {
        ["player"] = {
            ["Discipline"] = {
                "Atonement",
            },
            ["all"] = {
                "Power Word: Shield",
            },
        },
        ["target"] = {
            ["Shadow"] = {
                "Vampiric Touch",
                "Voidform",
            },
            ["all"] = {
                "Shadow Word: Pain",
            },
        }
    },
    ["ROGUE"] = {
        ["player"] = {
            ["Assassination"] = {
            },
            ["Outlaw"] = {
                "Ruthless Precision",
                "Grand Melee",
                "Broadside",
                "Skull and Crossbones",
                "Buried Treasure",
                "True Bearing",
            },
            ["Subtlety"] = {
                "Shadow Dance",
                "Symbols of Death",
                "Shadow Blades",
            },
            ["all"] = {
                "Feint",
                "Sprint",
                "Slice and Dice",
                "Evasion",
            },
        },
        ["target"] = {
            ["Assassination"] = {
                "Garrote",
                "Rupture",
                "Kidney Shot",
            },
            ["Outlaw"] = {
                "Between the Eyes",
            },
            ["Subtlety"] = {
                "Nightblade",
                "Kidney Shot",
            },
            ["all"] = {
                "Cheap Shot",
                "Blind",
            },
        }
    },
    ["SHAMAN"] = {
        ["player"] = {
            ["Enhancement"] = {
                "Maelstrom Weapon",
            },
        },
        ["target"] = {
            ["all"] = {
                "Flame Shock",
            },
            ["Elemental"] = {
            },
            ["Enhancement"] = {
            },
            ["Restoration"] = {
                "Flame Shock",
            },
        },
    },
    ["WARLOCK"] = {
        ["player"] = {
            ["all"] = {
            },
            ["Demonology"] = {
                "Demonic Core",
                "Sign of Iron",
            },
            ["Affliction"] = {
                "Inevitable Demise",
            },
        },
        ["target"] = {
            ["all"] = {
                "Fear",
            },
            ["Affliction"] = {
                "Corruption",
                "Agony",
                "Unstable Affliction",
                "Siphon Life",
                "Haunt",
            },
            ["Demonology"] = {
            },
            ["Destruction"] = {
                "Immolate",
                "Eradication",
            },

        },
    },
    ["WARRIOR"] = {
        ["player"] = {
            ["Fury"] = {
                "Enrage",
                "Whirlwind",
                "Enraged Regeneration",
                "Battle Trance",
                "Recklessness",
            },
            ["Protection"] = {
                "Shield Block",
                "Ignore Pain",
                "Shield Wall",
                "Last Stand",
                "Avatar",
            },
            ["Arms"] = {
                "Deep Wounds",
                "Overpower",
                "Sweeping Strikes",
                "Test of Might",
            },
            ["all"] = {
                "Berserker Rage",
                "Victorious",
            },
        },
        ["target"] = {
            ["Fury"] = {
                "Piercing Howl",
            },
            ["Arms"] = {
                "Colossus Smash",
                "Rend",
            },
            ["Protection"] = {
                "Demoralizing Shout",
                "Shockwave",
            },
        }
    },
}

local BCAuras = {
    ["HUNTER"] = {
        ["player"] = {
            ["all"] = {
                { "Aspect of the Hawk", "Aspect of the Monkey", "Aspect of the Cheetah", "Aspect of the Viper", "Aspect of the Dragonhawk" },

            },
        },
        ["pet"] = {
            ["all"] = {
                "Mend Pet",
            },
        },
        ["target"] = {
            ["all"] = {
                "Serpent Sting",
                "Concussive Shot",
                "Wing Clip",
            },
        }
    },
    ["PALADIN"] = {
        ["player"] = {
            ["all"] = {
                {
                    "Seal of Righteousness",
                    "Seal of Wisdom",
                    "Seal of Light",
                    "Seal of the Crusader",
                },
                "Blessing of Freedom",
                { "Divine Protection", "Divine Shield" },
                "Righteous Fury",
            }
        },
        ["target"] = {
            ["all"] = {
                {
                    "Judgement of the Crusader",
                    "Judgement of Light",
                    "Judgement of Wisdom",
                }
            }
        },
    },
    ["SHAMAN"] = {
        ["player"] = {
            ["all"] = {
                { "Lightning Shield", "Water Shield", },
            }
        },
        ["target"] = {
            ["all"] = {
            }
        },
    },
    ["TEMPLATE"] = {
        ["player"] = {
            ["all"] = {
            },
        },
        ["target"] = {
            ["all"] = {
            },
        },
    },
}

local AurasToTrack = {
    ["Retail"] = RetailAuras,
    ["Wrath"] = BCAuras,
}

function GetAurasForVersion(wowVersion)
    return AurasToTrack[wowVersion]
end
