AwesomeUI = {}

--
-- Possible options
--
local PossibleOptions = {
    ["showMacroText"] = {
        ["displayName"] = "Show Macro Text",
        ["description"] = "Whether to show macro text overlayed on the action bars. (Default: true)",
        ["defaultValue"] = true,
    },
    ["showKeybinds"] = {
        ["displayName"] = "Show Key Binds",
        ["description"] = "Whether to show keybinds overlayed on the action bars. (Default: true)",
        ["defaultValue"] = true,
    },
}

--
-- auras
--
local AuraSize = 32
local AurasToTrack = {
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
                "Beastial Wrath",
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
    }
}

--
-- helper functions
--
local function CheckboxOnClick(self)
    local checked = self:GetChecked()
    PlaySound(PlaySoundKitID and "igMainMenuOptionCheckBoxOn" or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
    self:SetValue(checked)
end

local function newCheckbox(parent, variableName, onClickFunction)
    -- Creates a new checkbox in the parent frame for the given variable name
    onClickFunction = onClickFunction or CheckboxOnClick
    local displayData = PossibleOptions[variableName]
    local checkbox = CreateFrame("CheckButton", "AwesomeUICheckbox" .. variableName,
            parent, "InterfaceOptionsCheckButtonTemplate")

    checkbox.GetValue = function (self)
        return AccountSettings[variableName]
    end
    checkbox.SetValue = function (self, value)
        AccountSettings[variableName] = value
        AwesomeUIRefresh()
    end

    checkbox:SetScript("OnClick", onClickFunction)
    checkbox:SetChecked(checkbox:GetValue())

    checkbox.label = _G[checkbox:GetName() .. "Text"]
    checkbox.label:SetText(displayData["displayName"])

    checkbox.tooltipText = displayData["displayName"]
    checkbox.tooltipRequirement = displayData["description"]
    return checkbox
end

--
-- Event handlers
--
function AwesomeUIModifyButtonOverlay(overlayName, alpha)
    for i=1, 12 do
        _G["ActionButton"..i..overlayName]:SetAlpha(alpha) -- main bar
        _G["MultiBarBottomRightButton"..i..overlayName]:SetAlpha(alpha) -- bottom right bar
        _G["MultiBarBottomLeftButton"..i..overlayName]:SetAlpha(alpha) -- bottom left bar
        _G["MultiBarRightButton"..i..overlayName]:SetAlpha(alpha) -- right bar
        _G["MultiBarLeftButton"..i..overlayName]:SetAlpha(alpha) -- left bar
    end
end

function AwesomeUIRefresh()
    -- macro text
    local alpha = 1
    if not AccountSettings.showMacroText then
        alpha = 0
    end
    AwesomeUIModifyButtonOverlay("Name", alpha)

    -- keybinds
    local alpha = 1
    if not AccountSettings.showKeybinds then
        alpha = 0
    end
    AwesomeUIModifyButtonOverlay("HotKey", alpha)
end

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
    stack_text:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")
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

local function CreateAuraTracker(parentFrame)
    local parentName = parentFrame:GetName()
    local tracker = CreateFrame("Frame", "AwesomeUI"..parentName.."AuraTracker", parentFrame)
    tracker.auras = {}
    if parentName == "PlayerFrame" then
        tracker.direction = "RIGHT"
    elseif parentName == "TargetFrame" then
        tracker.direction = "LEFT"
    end
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

            if(self.direction == "RIGHT") then
                xoffset = xoffset - (AuraSize + 2)
            else
                xoffset = xoffset + (AuraSize + 2)
            end
            if( ii == kNumAurasAcross) then
                yoffset = yoffset + AuraSize + 16
                xoffset = 0
            end
        end
    end

    tracker:SetScript("OnUpdate", function(self,event,...)
        for ii, aura in ipairs(self.auras) do
            local auraTarget = aura.auraInfo["target"]
            if auraTarget ~= nil then
                local auraName = aura.auraInfo.aura
                local filter = "HELPFUL"
                if auraTarget == "target" then
                    filter = "HARMFUL|PLAYER"
                end
                local name, icon, count, _, _, expirationTime = AuraUtil.FindAuraByName(auraName, auraTarget, filter)
                if name == nil then
                    aura:Hide()
                else
                    aura.texture:SetTexture(icon)
                    aura:Show()
                    if( count == 0 ) then
                        aura.stack_text:Hide()
                    else
                        aura.stack_text:SetText(count)
                        aura.stack_text:Show()
                    end

                    if expirationTime ~= 0 then
                        local remaining = expirationTime - GetTime()
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

--
-- Register frame
--
AwesomeUI.frame = CreateFrame("Frame", "AwesomeUIFrame", UIParent)
AwesomeUI.frame.name = "AwesomeUI"
AwesomeUI.auras = {}

AwesomeUI.UpdateSpec = function()
    local _, playerClass = UnitClass("player")
    local currentSpecIndex, currentSpecName = GetSpecializationInfo(GetSpecialization())

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

    AwesomeUI.friendlyAuras:AddAuras(friendlyAuras)
    AwesomeUI.targetAuras:AddAuras(targetAuras)
end

AwesomeUI.frame:RegisterEvent("PLAYER_LOGIN")
AwesomeUI.frame:RegisterEvent("ADDON_LOADED")
AwesomeUI.frame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")

AwesomeUI.frame:SetScript("OnEvent", function(self,event,...)
    if (event == "ADDON_LOADED") and (... == "AwesomeUI") then
        -- setup options panel
        AwesomeUI.optionsFrame = CreateFrame("Frame", "AwesomeUIOptions", AwesomeUI.frame)
        AwesomeUI.optionsFrame.name = "Settings"
        AwesomeUI.optionsFrame.parent = AwesomeUI.frame.name
        local lastKey = nil
        for key, value in pairs(PossibleOptions) do
            AwesomeUI.optionsFrame[key] = newCheckbox(AwesomeUI.optionsFrame, key)
            if lastKey then
                AwesomeUI.optionsFrame[key]:SetPoint("TOPLEFT", AwesomeUI.optionsFrame[lastKey], "BOTTOMLEFT")
            else
                AwesomeUI.optionsFrame[key]:SetPoint("TOPLEFT", 16, -16)
            end
            lastKey = key
        end

        -- setup aura options panel
        AwesomeUI.auraOptionsFrame = CreateFrame("Frame", "AwesomeUIAuraOptions", AwesomeUI.frame)
        AwesomeUI.auraOptionsFrame.name = "Auras"
        AwesomeUI.auraOptionsFrame.parent = AwesomeUI.frame.name

        -- add interface options
        InterfaceOptions_AddCategory(AwesomeUI.frame)
        InterfaceOptions_AddCategory(AwesomeUI.optionsFrame)
        InterfaceOptions_AddCategory(AwesomeUI.auraOptionsFrame)

        -- setup aura tracker
        AwesomeUI.friendlyAuras = CreateAuraTracker(PlayerFrame)
        AwesomeUI.targetAuras = CreateAuraTracker(TargetFrame)

    elseif event == "PLAYER_LOGIN"  then
        if AccountSettings == nil then
            AccountSettings = {}
        end

        for key, value in pairs(PossibleOptions) do
            if AccountSettings[key] == nil then
                AccountSettings[key] = value.defaultValue
            end
        end

        AwesomeUIRefresh()
        AwesomeUI:UpdateSpec()
    elseif event == "PLAYER_SPECIALIZATION_CHANGED" then
        AwesomeUI:UpdateSpec()
    end
end)
