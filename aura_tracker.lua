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
    ["MONK"] = {  },
    ["ROGUE"] = {  },
    ["HUNTER"] = { "Steady Focus" },
    ["SHAMAN"] = {  },
    ["DEATH KNIGHT"] = {  },
    ["PALADIN"] = { "Inquisition", "Sacred Shield" },
    ["WARRIOR"] = {  },
}
local aura_size = 32
local num_auras_across = 4

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
                local exists = UnitAura("player",self.auras[i].name)
                if(exists ~= nil) then
                    self.auras[i]:Show()
                else
                    self.auras[i]:Hide()
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
        local yoffset = 0
        for i=1, #auras_to_track[player_class] do
            local aura_name = auras_to_track[player_class][i]
            local aura = CreateFrame("Frame", aura_name, self)
            local _,_,icon = GetSpellInfo(aura_name)
            local texture = aura:CreateTexture(nil,"OVERLAY")
            texture:SetTexture(icon)
            texture:SetAllPoints(aura)
            aura.texture = texture
            aura.name = aura_name

            aura:SetPoint("BOTTOMRIGHT",self,"BOTTOMRIGHT", xoffset, yoffset)
            aura:SetSize(aura_size,aura_size)
            aura:Hide()

            self.auras[i] = aura
            xoffset = xoffset - (aura_size + 2)
        end

        self:SetPoint("BOTTOMRIGHT",PlayerFrame,"TOPRIGHT",0,0)
        self:SetSize(100,100)
        self:Show()

        -- Unregister from following messages
        self:UnregisterEvent("ADDON_LOADED");
    end
end)

--
-- Slash commands
--
