--
-- auras
--
local AuraSize = 32
local AurasAcross = 4

local function CreateAuraIcon(parent, name)
    local aura = CreateFrame("Frame", name, parent)

    local texture = aura:CreateTexture(nil)
    texture:SetAllPoints(aura)
    aura.texture = texture
    aura.texture:SetAlpha(0.75)

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
        for _, aura in ipairs(self.auras) do
            local auraTarget = aura.auraInfo["target"]
            if auraTarget ~= nil then
                local filter = "HELPFUL"
                if auraTarget == "target" then
                    filter = "HARMFUL|PLAYER"
                end
                local name, icon, count, expirationTime, ignorePainRemaining

                for _, auraName in ipairs(aura.auraInfo.aura) do
                    name, icon, count, _, _, expirationTime,_,_,_,_,_,_,_,_,_,ignorePainRemaining = AuraUtil.FindAuraByName(auraName, auraTarget, filter)
                    if name ~= nil then
                        break
                    end
                end
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
                        if remaining > 0.0 then
                            if remaining <= 2.0 then
                                aura.text:SetTextColor(1,0,0,1)
                            else
                                aura.text:SetTextColor(1,1,1,1)
                            end
                            aura.text:SetFormattedText(FormatTime(remaining))
                            aura.text:Show()
                        else
                            aura.text:Hide()
                        end
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

    local events = {
        ["Retail"] = {
            "ADDON_LOADED",
            "PLAYER_LOGIN",
            "PLAYER_SPECIALIZATION_CHANGED",
            "PLAYER_ENTERING_WORLD",
        },
        ["BC"] = {
            "ADDON_LOADED",
            "PLAYER_LOGIN",
            "PLAYER_ENTERING_WORLD",
        }
    }

    -- setup aura tracker
    tracker.friendlyAuras = CreateTargetAuraTracker(PlayerFrame, tracker)
    tracker.targetAuras = CreateTargetAuraTracker(TargetFrame, tracker)

    function register_event(frame, event)
        frame:RegisterEvent(event)
    end

    for i, event in ipairs(events[wowVersion]) do
        register_event(tracker.frame, event)
    end
    tracker.frame:SetScript("OnEvent", function(self, event, ...)
        tracker:UpdateSpec()
    end)

    tracker.UpdateSpec = function(self)
        local _, playerClass = UnitClass("player")
        local currentSpecIndex, currentSpecName
        if wowVersion == "Retail" then
            currentSpecIndex, currentSpecName = GetSpecializationInfo(GetSpecialization())
        else
            currentSpecName = "all"
        end

        -- setup Ignore Pain reader for warrior
        if select(2, UnitClass("player")) == "WARRIOR" and wowVersion == "Retail" then
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

        local aurasToTrack = GetAurasForVersion(wowVersion)

        -- if not a class with auras, just return
        if aurasToTrack[playerClass] == nil then
            return
        end

        local friendlyAuras = {}
        local targetAuras = {}
        local classAuras = aurasToTrack[playerClass]

        -- collect all auras to track
        for target, targetSpells in pairs(classAuras) do
            local currentTable
            if target ~= "target" then
                currentTable = friendlyAuras
            else
                currentTable = targetAuras
            end
            for spec, specSpells in pairs(targetSpells) do
                if spec == "all" or spec == currentSpecName then
                    for _, spell in ipairs(specSpells) do
                        if type(spell) == "string" then
                            spell = { spell }
                        end
                        table.insert(currentTable, { ["target"] = target, ["aura"] = spell } )
                    end
                end
            end
        end

        self.friendlyAuras:AddAuras(friendlyAuras)
        self.targetAuras:AddAuras(targetAuras)
    end
    return tracker
end
