local RetailAuras = {
    ["DEATHKNIGHT"] = {
        ["player"] = {
            ["all"] = {
                "Death's Advance",
                "Dark Succor",
                "Anti-Magic Shell",
                "Icebound Fortitude",
            },
            ["Blood"] = {
                "Bone Shield",
            },
            ["Frost"] = {
                "Cold Heart",
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
    ["DRUID"] = {
        ["player"] = {
            ["all"] = {
                "Clearcasting",
                "Survival Instincts",
            },
            ["Balance"] = {
                "Lunar Empowerment",
                "Solar Empowerment",
            },
            ["Feral"] = {
                "Tiger's Fury",
                "Berserk",
                "Predatory Swiftness",
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

            },
            ["Frost"] = {
                "Brain Freeze",
                "Fingers of Frost",
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
    ["PALADIN"] = {
        ["player"] = {
            ["Protection"] = {
                "Shield of the Righteous",
                "Ardent Defender",
                "Consecration",
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
                "Avenging Wrath",
            },
        },
        ["target"] = {
            ["all"] = {
                "Hammer of Justice",
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
                -- "Ruthless Precision",
                -- "Grand Melee",
                -- "Broadside",
                -- "Skull and Crossbones",
                -- "Buried Treasure",
                -- "True Bearing",
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
                "Flametongue",
                "Frostbrand",
            },
        },
        ["target"] = {
            ["Elemental"] = {
                "Flame Shock",
            },
            ["Restoration"] = {
                "Flame Shock",
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
                { "Aspect of the Hawk", "Aspect of the Monkey" },
                "Aspect of the Cheetah",
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
            }
        },
    },
    ["TEMPLATE"] = {
        ["player"] = {
            ["all"] = {
            }
        },
        ["target"] = {
            ["all"] = {
            }
        },
    },
}

local AurasToTrack = {
    ["Retail"] = RetailAuras,
    ["BC"] = BCAuras,
}

function GetAurasForVersion(wowVersion)
    print(wowVersion)
    return AurasToTrack[wowVersion]
end
