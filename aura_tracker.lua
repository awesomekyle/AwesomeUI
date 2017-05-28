
--
-- Auras to track
--
local d = 0
local _, kPlayerClass = UnitClass("player")
local kPlayerGuid = UnitGUID("player")
local kAurasToTrack = {
    ["MAGE"] = {  },
    ["PRIEST"] = {
    },
    ["WARLOCK"] = {  },
    ["DRUID"] = {
        ["player"] = {
            { "Lunar Empowerment", "Solar Empowerment", "Savage Roar", "Savage Defense" },
            { "Bloodtalons", "Rejuvenation", },
            { "Clearcasting", },
        },
        ["target"] = {
            { "Rake", },
            { "Rip", },
            { "Moonfire" }
        },
    },
    ["MONK"] = {
        ["player"] = {
            { "Mana Tea", "Tigereye Brew", "Shuffle" },
            { "Tiger Power" },
            { "Elusive Brew", "Vital Mists", "Storm, Earth, and Fire" },
            { "Serpent's Zeal", "Touch of Karma" },
        },
    },
    ["ROGUE"] = {
        ["player"] = {
            { "Slice and Dice", },
            { "Recuperate", },
            { "Revealing Strike", },
            { "Burst of Speed", },
            { "Feint", },
        },
        ["target"] = {
            { "Cheap Shot", "Kidney Shot", },
            { "Blind", "Gouge", },
            { "Garrote", },
            { "Rupture", },
            { "Hemorrhage", },
        }
    },
    ["HUNTER"] = {
        ["player"] = {
            { "Lock and Load", "Sniper Training", "Sniper Training: Recently Moved" },
            { "Steady Focus", "Thrill of the Hunt", },
            { "Beastial Wrath", },
            { "Misdirection" }
        },
        ["target"] = {
            { "Vulnerable" }
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
            { "Blood Plague", },
            { "Frost Fever", },
        },
    },
    ["PALADIN"] = {
        ["player"] = {
            { "Shield of the Righteous", "Zeal", },
            { "Divine Protection", "Supplication" },
            { "Ardent Defender", "Final Verdict" },
            { "Guardian of Ancient Kings", "Empowered Divine Storm" },
            { "Divine Shield", },
        },
    },
    ["WARRIOR"] = {
        ["player"] = {
            { "Colossus Smash", "Shield Block", "Shield Charge" },
            { "Shield Barrier" },
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
            { "Metamorphosis", },
        }
    }
}
local kAuraSize = 32
local kNumAurasAcross = 4


local function format_time(time)
    if(time > 3599) then return ceil(time/3600).."h" end
    if(time > 599) then return ceil(time/60).."m" end
    if(time > 30) then return floor(time/60)..":"..format("%02d", floor(time%60)) end
    return format("%.1f", time)
end

local function CreateAuraTracker(parent_frame, auras_to_track, target, direction)
    -- Set up frame to run on login
    local frame = CreateFrame("Frame", "Aura Tracker", UIParent)
    frame:RegisterEvent("ADDON_LOADED")
    frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    frame:RegisterEvent("UNIT_PET")
    frame:RegisterEvent("PLAYER_TARGET_CHANGED")

    frame.auras_to_track = auras_to_track
    frame.target = target

    frame:SetScript("OnEvent",function(self,event,...)
        if( event == "COMBAT_LOG_EVENT_UNFILTERED" or event == "UNIT_PET") then
            local timestamp, type, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = ...
            if( destGUID == kPlayerGuid or sourceGUID == kPlayerGuid or true) then
                for ii=1, #self.auras do
                    local aura = self.auras[ii]
                    for jj=1, #aura.spells do
                        local exists,_,icon,count,_,_,expires = UnitAura(target, aura.spells[jj], nil, "HELPFUL")
                        if(exists == nil) then
                            exists,_,icon,count,_,_,expires = UnitAura(target, aura.spells[jj], nil, "HARMFUL|PLAYER")
                        end
                        if(exists ~= nil) then
                            self.auras[ii].texture:SetTexture(icon)
                            self.auras[ii]:Show()
                            self.auras[ii].expires = expires
                            if( count == 0 ) then
                                self.auras[ii].stack_text:Hide()
                            else
                                self.auras[ii].stack_text:SetText(count)
                                self.auras[ii].stack_text:Show()
                            end
                            break
                        else
                            self.auras[ii]:Hide()
                            self.auras[ii].expires = 0
                        end
                    end
                end
            end
        elseif( event == "PLAYER_TARGET_CHANGED") then
            for ii=1, #self.auras do
                local aura = self.auras[ii]
                for jj=1, #aura.spells do
                    local exists,_,icon,count,_,_,expires = UnitAura(target,aura.spells[jj])
                    if(exists ~= nil) then
                        self.auras[ii].texture:SetTexture(icon)
                        self.auras[ii]:Show()
                        self.auras[ii].expires = expires
                        if( count == 0 ) then
                            self.auras[ii].stack_text:Hide()
                        else
                            self.auras[ii].stack_text:SetText(count)
                            self.auras[ii].stack_text:Show()
                        end
                        break
                    else
                        self.auras[ii]:Hide()
                        self.auras[ii].expires = 0
                    end
                end
            end
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
