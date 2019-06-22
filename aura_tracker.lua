
--
-- Auras to track
--
local d = 0
local _, kPlayerClass = UnitClass("player")
local kPlayerGuid = nil
local kAurasToTrack = {
    ["MAGE"] = {  },
    ["PRIEST"] = {
    },
    ["WARLOCK"] = {
        ["target"] = {
            { "Corruption" },
            { "Agony" },
            { "Unstable Affliction" },
        },
     },
    ["DRUID"] = {
        ["player"] = {
            { "Lunar Empowerment", "Savage Roar", "Savage Defense" },
            { "Ironfur", "Solar Empowerment", "Bloodtalons", "Rejuvenation", },
            { "Clearcasting", },
            { "Tiger's Fury", },
        },
        ["target"] = {
            { "Rake", "Sunfire" },
            { "Rip", },
            { "Moonfire" },
            { "Thrash", },
        },
    },
    ["MONK"] = {
        ["player"] = {
            { "Mana Tea", "Tigereye Brew", "Shuffle" },
            { "Tiger Power", "Ironskin Brew", },
            { "Elusive Brew", "Vital Mists", "Storm, Earth, and Fire" },
            { "Serpent's Zeal", "Touch of Karma" },
        },
    },
    ["ROGUE"] = {
        ["player"] = {
            { "Slice and Dice", "Ruthless Precision", },
            { "Recuperate", "Grand Melee", },
            { "Revealing Strike", "Broadside", },
            { "Burst of Speed", "Skull and Crossbones" },
            { "Feint", },
            { "Buried Treasure", },
            { "True Bearing", },
        },
        ["target"] = {
            { "Cheap Shot", "Kidney Shot", "Between the Eyes", "Hammer of Justice", },
            { "Blind", "Gouge", },
            { "Garrote", "Nightblade", },
            { "Rupture", },
            { "Hemorrhage", },
        }
    },
    ["HUNTER"] = {
        ["player"] = {
            { "Mongoose Fury", "Lock and Load", "Frenzy", },
            { "Steady Focus", "Thrill of the Hunt", "Trueshot", },
            { "Beastial Wrath", "Trick Shots", },
            { "Misdirection" }
        },
        ["target"] = {
            { "Serpent Sting", },
            { "Wildfire Bomb", },
            { "Concussive Shot", },
        }
    },
    ["SHAMAN"] = {
        ["player"] = {
            { "Tidal Waves" },
            { "Lightning Shield", "Water Shield" }
        },
        ["target"] = {
            { "Flame Shock" },
        },
    },
    ["DEATHKNIGHT"] = {
        ["player"] = {
            { "Bone Shield", "Icy Talons" },
        },
        ["target"] = {
            { "Virulent Plague", "Blood Plague", "Frost Fever", },
            { "Festering Wound", "Pillar of Frost", },
        },
    },
    ["PALADIN"] = {
        ["player"] = {
            { "Shield of the Righteous",  },
            { "Divine Protection", "Supplication" },
            { "Ardent Defender", "Final Verdict" },
            { "Guardian of Ancient Kings", "Empowered Divine Storm" },
            { "Divine Shield", },
        },
    },
    ["WARRIOR"] = {
        ["player"] = {
            { "Colossus Smash", "Shield Block", "Shield Charge", "Whirlwind" },
            { "Shield Barrier", "Overpower", "Ignore Pain", },
            { "Demoralizing Shout" }, { "Enrage", },
            { "Shield Wall" },
            { "Last Stand" },
            { "Enraged Regeneration" },
            { "Unyielding Strikes", },
        },
        ["target"] = {
            { "Shockwave", },
        },
    },
    ["DEMONHUNTER"] = {
        ["player"] = {
            { "Demon Spikes", },
            { "Soul Fragments", },
            { "Immolation Aura", },
            { "Metamorphosis", },
        },
        ["target"] = {
            { "Imprison", },
            { "Hammer of Justice", "Chaos Nova", },
        }
    }
}
local kAuraSize = 32
local kNumAurasAcross = 4
local targetGUID = nil

local function format_time(time)
    if(time > 3599) then return ceil(time/3600).."h" end
    if(time > 599) then return ceil(time/60).."m" end
    if(time > 30) then return floor(time/60)..":"..format("%02d", floor(time%60)) end
    return format("%.1f", time)
end

local function UpdateAuras(frame, target)
    for ii=1, #frame.auras do
        local aura = frame.auras[ii]
        for jj=1, #aura.spells do
            local check_name = nil
            local aura_name =  aura.spells[jj]
            local expires = 0
            local icon = nil
            local count = 0
            local exists = nil
            for kk=1, 40 do
                check_name,icon,count,_,_,expires = UnitAura(target, kk, "HELPFUL")
                if(check_name ~= aura_name) then
                    check_name,icon,count,_,_,expires = UnitAura(target, kk, "HARMFUL|PLAYER")
                end
                if(check_name == aura_name) then
                    break
                end
            end
            if(check_name == aura_name) then
                frame.auras[ii].texture:SetTexture(icon)
                frame.auras[ii]:Show()
                frame.auras[ii].expires = expires
                if( count == 0 ) then
                    frame.auras[ii].stack_text:Hide()
                else
                    frame.auras[ii].stack_text:SetText(count)
                    frame.auras[ii].stack_text:Show()
                end
                break
            else
                frame.auras[ii]:Hide()
                frame.auras[ii].expires = 0
            end
        end
    end
end

local function CreateAuraTracker(parent_frame, auras_to_track, target, direction)
    -- Set up frame to run on login
    local frame = CreateFrame("Frame", "Aura Tracker", UIParent)
    frame:RegisterEvent("ADDON_LOADED")
    frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    frame:RegisterEvent("UNIT_PET")
    frame:RegisterEvent("PLAYER_TARGET_CHANGED")
    frame:RegisterEvent("PLAYER_LOGIN")

    frame.auras_to_track = auras_to_track
    frame.target = target

    frame:SetScript("OnEvent",function(self,event,...)
        if(event == "PLAYER_LOGIN") then
            kPlayerGuid = UnitGUID("player")
        elseif( event == "COMBAT_LOG_EVENT_UNFILTERED" or event == "UNIT_PET") then
            local _, _, _, _, _, _, _, destGUID = CombatLogGetCurrentEventInfo()
            if (destGUID == kPlayerGuid or destGUID == targetGUID) then
                UpdateAuras(self, target)
            end
        elseif( event == "PLAYER_TARGET_CHANGED") then
            targetGUID = UnitGUID("target")
            UpdateAuras(self, target)
        elseif( event == "ADDON_LOADED" and ... == "AwesomeUI" ) then
            --
            -- Create each aura button
            --
            self.auras = {}
            local xoffset = 0
            local yoffset = 5
            for ii=1, #self.auras_to_track do
                local aura_name = self.auras_to_track[ii][1]
                local aura = CreateFrame("Frame", aura_name, self)
                local _,_,icon = GetSpellInfo(aura_name)

                local texture = aura:CreateTexture(nil)
                texture:SetTexture(icon)
                texture:SetAllPoints(aura)
                aura.texture = texture

                local timer_text = aura:CreateFontString(nil)
                timer_text:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")
                timer_text:Show()
                timer_text:SetPoint("TOP",aura,"BOTTOM")
                aura.text = timer_text

                local stack_text = aura:CreateFontString(nil)
                stack_text:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")
                stack_text:SetText("1")
                stack_text:SetParent(aura)
                stack_text:Show()
                stack_text:SetPoint("TOP"..direction,aura,"TOP"..direction,0,-3)
                aura.stack_text = stack_text

                aura.expires = 0
                aura.name = aura_name
                aura.spells = self.auras_to_track[ii]

                aura:SetPoint("BOTTOM"..direction,self,"BOTTOM"..direction, xoffset, yoffset)
                aura:SetSize(kAuraSize,kAuraSize)
                aura:Hide()

                self.auras[ii] = aura
                if(direction == "RIGHT") then
                    xoffset = xoffset - (kAuraSize + 2)
                else
                    xoffset = xoffset + (kAuraSize + 2)
                end
                if( ii == kNumAurasAcross) then
                    yoffset = yoffset + kAuraSize + 16
                    xoffset = 0
                end
            end

            self:SetPoint("BOTTOM"..direction,parent_frame,"TOP"..direction,0,0)
            self:SetSize(100,100)
            self:Show()

            -- Unregister from following messages
            self:UnregisterEvent("ADDON_LOADED");
        end
    end)

    frame:SetScript("OnUpdate",function(self,event,...)
        for ii=1, #self.auras do
            if(self.auras[ii].expires ~= 0) then
                local remaining = self.auras[ii].expires - GetTime()
                self.auras[ii].text:Show()
                self.auras[ii].text:SetFormattedText(format_time(remaining))
            else
                self.auras[ii].text:Hide()
            end
        end
    end)
    return frame
end

print("Aura Tracker loaded")
if(kAurasToTrack[kPlayerClass]["player"]) then
    local player_frame = CreateAuraTracker(PlayerFrame, kAurasToTrack[kPlayerClass]["player"], "player", "RIGHT")
end
if(kAurasToTrack[kPlayerClass]["target"]) then
    local target_frame = CreateAuraTracker(TargetFrame, kAurasToTrack[kPlayerClass]["target"], "target", "LEFT")
end

--
-- Slash commands
--
