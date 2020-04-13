--
-- auras
--
local AuraSize = 32
local AurasAcross = 4
local AurasToTrack = {
    ["DEATHKNIGHT"] = {
        ["player"] = {
            ["all"] = {
                "Death's Advance",
            },
            ["Blood"] = {
            },
            ["Frost"] = {
            },
            ["Unholy"] = {
            },
        },
        ["target"] = {
            ["all"] = {
            },
            ["Blood"] = {
            },
            ["Frost"] = {
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
            ["all"] = {
                "Divine Shield",
                "Blessing of Freedom",
                "Blessing of Protection",
                "Blessing of Sacrifice",
                "Avenging Wrath",
            },
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
        },
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
    ["SHAMAN"] = {
        ["player"] = {
            ["Enhancement"] = {
                "Flametongue",
                "Frostbrand",
            },
        }
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

local function CreateAuraIcon(parent, name)
    local aura = CreateFrame("Frame", name, parent)

    local texture = aura:CreateTexture(nil)
    texture:SetAllPoints(aura)
    aura.texture = texture

    local timer_text = aura:CreateFontString(nil)
    timer_text:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")
    timer_text:Show()
    timer_text:SetPoint("TOP",aura,"BOTTOM")
    aura.text = timer_text

    local stack_text = aura:CreateFontString(nil)
    stack_text:SetFont("Fonts\\FRIZQT__.TTF", 16, "OUTLINE")
    stack_text:SetText("1")
    stack_text:SetParent(aura)
    stack_text:Show()
    stack_text:SetPoint("TOPRIGHT",aura,"TOPRIGHT",-3,-3)
    aura.stack_text = stack_text

    aura.auraInfo = {}
    return aura
end

local function FormatTime(time)
    if(time > 3599) then return ceil(time/3600).."h" end
    if(time > 599) then return ceil(time/60).."m" end
    if(time > 30) then return floor(time/60)..":"..format("%02d", floor(time%60)) end
    return format("%.1f", time)
end

local function CreateTargetAuraTracker(parentFrame, owner)
    local parentName = parentFrame:GetName()
    local tracker = CreateFrame("Frame", "AwesomeUI"..parentName.."AuraTracker", parentFrame)
    tracker.auras = {}
    if parentName == "PlayerFrame" then
        tracker.direction = "RIGHT"
    elseif parentName == "TargetFrame" then
        tracker.direction = "LEFT"
    end
    tracker.owner = owner
    tracker:SetPoint("BOTTOM"..tracker.direction, parentFrame, "TOP"..tracker.direction, 0, 0)
    tracker:SetSize(100,100)
    tracker:Show()

    tracker.AddAuras = function(self, auras)
        -- create any required auras
        local currentNumAuras = #self.auras
        local numRequiredAuras = #auras
        if currentNumAuras < numRequiredAuras then
            for ii=currentNumAuras+1, numRequiredAuras do
                local aura = CreateAuraIcon(self, self:GetName().."Aura"..ii)
                table.insert(self.auras, aura)
            end
        end

        -- clear all auras
        for _, aura in ipairs(self.auras) do
            aura.auraInfo = {}
        end

        -- setup auras
        local xoffset = 0
        local yoffset = 5
        for ii, auraInfo in ipairs(auras) do
            local aura = self.auras[ii]

            aura.auraInfo = auraInfo
            aura:SetPoint("BOTTOM"..self.direction, self, "BOTTOM"..self.direction, xoffset, yoffset)
            aura:SetSize(AuraSize, AuraSize)
            aura:Hide()

            if self.direction == "RIGHT" then
                xoffset = xoffset - (AuraSize + 2)
            else
                xoffset = xoffset + (AuraSize + 2)
            end
            if ii == AurasAcross then
                yoffset = yoffset + AuraSize + 16
                xoffset = 0
            end
        end
    end

    tracker:SetScript("OnUpdate", function(self,event,...)
        local curr_time = GetTime()
        for ii, aura in ipairs(self.auras) do
            local auraTarget = aura.auraInfo["target"]
            if auraTarget ~= nil then
                local auraName = aura.auraInfo.aura
                local filter = "HELPFUL"
                if auraTarget == "target" then
                    filter = "HARMFUL|PLAYER"
                end
                local name, icon, count, _, _, expirationTime,_,_,_,_,_,_,_,_,_,ignorePainRemaining = AuraUtil.FindAuraByName(auraName, auraTarget, filter)
                -- Ignore Pain caps at 1.3x it's maximum cast. If < 30% remains, we
                -- hide the icon because it's safe to recast
                if name == "Ignore Pain" then
                    local currMaxIgnorePain = self.owner.ignorePainReader:GetValue()
                    if ignorePainRemaining < (currMaxIgnorePain * 0.3) then
                        name = nil
                    end
                end
                if name == nil then
                    aura:Hide()
                else
                    aura.texture:SetTexture(icon)
                    aura:Show()
                    if count == 0 then
                        aura.stack_text:Hide()
                    else
                        aura.stack_text:SetText(count)
                        aura.stack_text:Show()
                    end

                    if expirationTime ~= 0 then
                        local remaining = expirationTime - curr_time
                        aura.text:SetFormattedText(FormatTime(remaining))
                        aura.text:Show()
                    else
                        aura.text:Hide()
                    end
                end
            end
        end
    end)

    return tracker
end

function CreateAuraTracker()
    local tracker = {}
    tracker.frame = CreateFrame("Frame", "AwesomeUIFrame", UIParent)
    tracker.frame.name = "AwesomeUI"
    tracker.auras = {}
    tracker.ignorePainReader = nil

    -- setup aura tracker
    tracker.friendlyAuras = CreateTargetAuraTracker(PlayerFrame, tracker)
    tracker.targetAuras = CreateTargetAuraTracker(TargetFrame, tracker)

    tracker.frame:RegisterEvent("PLAYER_LOGIN")
    tracker.frame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
    tracker.frame:RegisterEvent("PLAYER_ENTERING_WORLD")
    tracker.frame:SetScript("OnEvent", function(self, event, ...)
        tracker:UpdateSpec()
    end)

    tracker.UpdateSpec = function(self)
        local _, playerClass = UnitClass("player")
        local currentSpecIndex, currentSpecName = GetSpecializationInfo(GetSpecialization())

        -- setup Ignore Pain reader for warrior
        if select(2, UnitClass("player")) == "WARRIOR" then
            self.ignorePainReader = CreateFrame("GameTooltip", "AwesomeUIIgnorePainTooltipReader", UIParent, "GameTooltipTemplate")
            self.ignorePainReader:SetOwner(UIParent,"ANCHOR_NONE")
            self.ignorePainReader:SetSpellByID(190456) -- Ignore Pain Spell ID
            self.ignorePainReader.GetValue = function(self)
                local ignorePainMatch = AwesomeUIIgnorePainTooltipReaderTextLeft4:GetText():match("Fight through the pain, ignoring 50%% of damage taken, up to (.-) total damage prevented.")
                local ignorePainMatch = string.gsub(ignorePainMatch, ",", "")
                local nextIgnorePainValue = tonumber(ignorePainMatch)
                return nextIgnorePainValue
            end
        end

        -- if not a class with auras, just return
        if AurasToTrack[playerClass] == nil then
            return
        end

        local friendlyAuras = {}
        local targetAuras = {}
        local classAuras = AurasToTrack[playerClass]

        -- get all "friendly" auras
        for target, targetSpells in pairs(classAuras) do
            if target ~= "target" then
                for spec, specSpells in pairs(targetSpells) do
                    if spec == "all" or spec == currentSpecName then
                        for i, spell in ipairs(specSpells) do
                            table.insert(friendlyAuras, { ["target"] = target, ["aura"] = spell } )
                        end
                    end
                end
            end
        end

        -- get all "target" auras
        for target, targetSpells in pairs(classAuras) do
            if target == "target" then
                for spec, specSpells in pairs(targetSpells) do
                    if spec == "all" or spec == currentSpecName then
                        for i, spell in ipairs(specSpells) do
                            table.insert(targetAuras, { ["target"] = target, ["aura"] = spell })
                        end
                    end
                end
            end
        end

        self.friendlyAuras:AddAuras(friendlyAuras)
        self.targetAuras:AddAuras(targetAuras)
    end
end
