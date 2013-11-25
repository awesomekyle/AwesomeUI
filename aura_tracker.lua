--
-- Auras to track
--
local d = 0
local _, player_class = UnitClass("player")
local player_guid = UnitGUID("player")
local auras_to_track = {
    ["MAGE"] = {  },
    ["PRIEST"] = {  },
    ["WARLOCK"] = {  },
    ["DRUID"] = {  },
    ["MONK"] = { { "Tiger Power" } },
    ["ROGUE"] = {  },
    ["HUNTER"] = {
        { "Steady Focus" },
    },
    ["SHAMAN"] = {  },
    ["DEATH KNIGHT"] = {  },
    ["PALADIN"] = {
        { "Inquisition", },
        { "Sacred Shield", },
        { "Blessing of Kings", }
    },
    ["WARRIOR"] = {
        { "Shield Barrier", "Sweeping Strikes" },
        { "Shield Block" },
        { "Berserker Rage", "Enrage" },
        { "Battle Shout", "Trueshot Aura", "Horn of Winter" },
        { "Commanding Shout", "Power Word: Fortitude", "Dark Intent", "Qiraji Fortitude" },
    }
}
local aura_size = 32
local num_auras_across = 4


local function format_time(time)
    if(time > 3599) then return ceil(time/3600).."h" end
    if(time > 599) then return ceil(time/60).."m" end
    if(time > 30) then return floor(time/60)..":"..format("%02d", floor(time%60)) end
    return format("%.1f", time)
end

-- Set up frame to run on login
local frame = CreateFrame("Frame", "Aura Tracker", UIParent)
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
frame:RegisterEvent("UNIT_PET")

frame:SetScript("OnEvent",function(self,event,...)
    if( event == "COMBAT_LOG_EVENT_UNFILTERED" or event == "UNIT_PET") then
        local timestamp, type, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = ...
        if( destGUID == player_guid or sourceGUID == player_guid or true ) then
            for i=1, #self.auras do
                for j=1, #auras_to_track[player_class][i] do
                    local exists,_,icon,_,_,_,expires = UnitAura("player",auras_to_track[player_class][i][j])
                    if(exists ~= nil) then
                        self.auras[i].texture:SetTexture(icon)
                        self.auras[i]:Show()
                        self.auras[i].expires = expires
                        break
                    else
                        self.auras[i]:Hide()
                        self.auras[i].expires = 0
                    end
                end
            end
        end
    elseif( event == "ADDON_LOADED" and ... == "AwesomeUI" ) then
        print("Aura Tracker loaded")

        --
        -- Create each aura button
        --
        self.auras = {}
        local xoffset = 0
        local yoffset = 5
        for i=1, #auras_to_track[player_class] do
            local aura_name = auras_to_track[player_class][i][1]
            local aura = CreateFrame("Frame", aura_name, self)
            local _,_,icon = GetSpellInfo(aura_name)

            local texture = aura:CreateTexture(nil,"OVERLAY")
            texture:SetTexture(icon)
            texture:SetAllPoints(aura)
            aura.texture = texture

            local timer_text = aura:CreateFontString(nil)
            timer_text:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")
            timer_text:SetText("Test")
            timer_text:Show()
            timer_text:SetPoint("TOP",aura,"BOTTOM")
            aura.text = timer_text

            aura.expires = 0
            aura.name = aura_name

            aura:SetPoint("BOTTOMRIGHT",self,"BOTTOMRIGHT", xoffset, yoffset)
            aura:SetSize(aura_size,aura_size)
            aura:Hide()

            self.auras[i] = aura
            xoffset = xoffset - (aura_size + 2)
            if((i-1)%num_auras_across == 0) then
                yoffset = yoffset + aura_size + 16
            end
        end

        self:SetPoint("BOTTOMRIGHT",PlayerFrame,"TOPRIGHT",0,0)
        self:SetSize(100,100)
        self:Show()

        -- Unregister from following messages
        self:UnregisterEvent("ADDON_LOADED");
    end
end)

frame:SetScript("OnUpdate",function(self,event,...)
    for i=1, #self.auras do
        if(self.auras[i].expires ~= 0) then
            local remaining = self.auras[i].expires - GetTime()
            self.auras[i].text:SetFormattedText(format_time(remaining))
        end
    end
end)


--
-- Slash commands
--
