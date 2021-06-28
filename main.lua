local wowVersion = GetBuildInfo()
local function starts_with(str, start)
    return str:sub(1, #start) == start
end

if starts_with(wowVersion, "1.") then
    wowVersion = "Classic"
elseif starts_with(wowVersion, "2.") then
    wowVersion = "BC"
else
    wowVersion = "Retail"
end

ACTION_BAR_OFFSET_Y = -160

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
    ["repositionActionBars"] = {
        ["displayName"] = "Reposition Action Bars",
        ["description"] = "Whether to move main action bar to middle of screen and stack others below. Reload UI to finalize changes. (Default: true)",
        ["defaultValue"] = true,
    }
}

--
-- helper functions
--
local function CheckboxOnClick(self)
    local checked = self:GetChecked()
    PlaySound(PlaySoundKitID and "igMainMenuOptionCheckBoxOn" or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
    self:SetValue(checked)
    if self.userHandler then
        self:userHandler(checked)
    end
end

local function NewCheckbox(parent, variableName, onClickFunction)
    -- Creates a new checkbox in the parent frame for the given variable name
    local displayData = PossibleOptions[variableName]
    local checkbox = CreateFrame("CheckButton", "AwesomeUICheckbox" .. variableName,
            parent, "InterfaceOptionsCheckButtonTemplate")

    if displayData["handler"] ~= nil then
        onClickFunction = AwesomeUI[displayData["handler"]]
    end

    checkbox.GetValue = function (self)
        return AccountSettings[variableName]
    end
    checkbox.SetValue = function (self, value)
        AccountSettings[variableName] = value
        AwesomeUI:Refresh()
    end

    checkbox.userHandler = onClickFunction
    checkbox:SetScript("OnClick", CheckboxOnClick)
    checkbox:SetChecked(checkbox:GetValue())

    checkbox.label = _G[checkbox:GetName() .. "Text"]
    checkbox.label:SetText(displayData["displayName"])

    checkbox.tooltipText = displayData["displayName"]
    checkbox.tooltipRequirement = displayData["description"]
    return checkbox
end

--
-- Register frame
--
AwesomeUI.frame = CreateFrame("Frame", "AwesomeUIFrame", UIParent)
AwesomeUI.frame.name = "AwesomeUI"
AwesomeUI.auras = {}

function AwesomeUIModifyButtonOverlay(overlayName, alpha)
    for i=1, 12 do
        _G["ActionButton"..i..overlayName]:SetAlpha(alpha) -- main bar
        _G["MultiBarBottomRightButton"..i..overlayName]:SetAlpha(alpha) -- bottom right bar
        _G["MultiBarBottomLeftButton"..i..overlayName]:SetAlpha(alpha) -- bottom left bar
        _G["MultiBarRightButton"..i..overlayName]:SetAlpha(alpha) -- right bar
        _G["MultiBarLeftButton"..i..overlayName]:SetAlpha(alpha) -- left bar
    end
end

AwesomeUI.Refresh = function()
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

    -- action bars
    AwesomeUI:UpdateActionbars(AccountSettings.repositionActionBars)
end

AwesomeUI.UpdateActionbars = function(self, moveEnabled)
    if not moveEnabled then
        return
    end

    local buttonSpacing = 6

    -- main action buttons
    ActionButton1:ClearAllPoints()
    ActionButton1:SetPoint("LEFT", UIParent, "CENTER", -123, ACTION_BAR_OFFSET_Y)
    ActionButton7:ClearAllPoints()
    ActionButton7:SetPoint("TOP", ActionButton1, "BOTTOM", 0, -buttonSpacing)

    for i=1, 12 do
        _G["ActionButton"..i]:SetAlpha(.7) -- main bar
    end

    local function width_of_buttons(buttonCount, buttonSize, spacing)
        return buttonSize * buttonCount + spacing * buttonCount-1
    end
    local buttonSize = MultiBarBottomRightButton1:GetWidth()

    local bottomActionBarAnchor, anchorPosition = (function()
        if wowVersion == "Classic" or wowVersion == "BC" then
            return ReputationWatchBar, "TOP"
        else
            return StatusTrackingBarManager, "BOTTOM"
        end
    end)()

    MultiBarBottomRightButton1:ClearAllPoints()
    MultiBarBottomRightButton1:SetPoint("BOTTOMLEFT", bottomActionBarAnchor, anchorPosition, -width_of_buttons(6,buttonSize,buttonSpacing) + 0.5 * buttonSpacing, 4)
    MultiBarBottomRightButton7:ClearAllPoints()
    MultiBarBottomRightButton7:SetPoint("LEFT", MultiBarBottomRightButton6, "RIGHT", 6, 0)

    MultiBarBottomLeftButton1:ClearAllPoints()
    MultiBarBottomLeftButton1:SetPoint("BOTTOM", MultiBarBottomRightButton1, "TOP", 0, 6)
    MultiBarBottomLeftButton7:ClearAllPoints()
    MultiBarBottomLeftButton7:SetPoint("LEFT", MultiBarBottomLeftButton6, "RIGHT", 6, 0)

    -- other bars and art frame
    if wowVersion == "Classic" or wowVersion == "BC" then
        PetActionBarFrame:ClearAllPoints()
        PetActionBarFrame:SetPoint("BOTTOMRIGHT", MultiBarBottomLeft, "TOPRIGHT", 31, buttonSpacing)
        PetActionBarFrame:SetScale(0.9)

        StanceButton1:ClearAllPoints()
        StanceButton1:SetPoint("BOTTOMLEFT", MultiBarBottomLeftButton1, "TOPLEFT", 10, buttonSpacing+2)

        for i=1, 8 do
            _G["StanceButton"..i]:SetScale(0.9)
        end

        MainMenuBarLeftEndCap:Hide()
        MainMenuBarRightEndCap:Hide()
        MainMenuBarPerformanceBarFrame:Hide()

        MainMenuBarTexture0:Hide()
        MainMenuBarTexture1:Hide()
        MainMenuBarTexture2:Hide()
        MainMenuBarTexture3:Hide()
        MainMenuBarOverlayFrame:Hide()
        -- MainMenuBarMaxLevelBar:Hide()
        -- MainMenuBarMaxLevelBar.Show = function() end

        ActionBarUpButton:Hide()
        ActionBarDownButton:Hide()
        MainMenuBarPageNumber:SetAlpha(0)

        -- move bars
        local width = CharacterMicroButton:GetWidth()
        CharacterMicroButton:ClearAllPoints()
        CharacterMicroButton:SetPoint("BOTTOMLEFT", UIPARENT, "BOTTOMRIGHT", -width * 7.5, 0)

        MainMenuBarBackpackButton:SetPoint("BOTTOMRIGHT", MainMenuMicroButton, "TOPRIGHT", 24, -20)

        MainMenuExpBar:ClearAllPoints()
        MainMenuExpBar:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, -3)
        for i=0, 3 do
            local height = _G["MainMenuXPBarTexture"..i]:GetHeight()
            _G["MainMenuXPBarTexture"..i]:SetHeight(height + 4)
        end
        MainMenuBarExpText:ClearAllPoints()
        MainMenuBarExpText:SetParent(MainMenuExpBar)
        MainMenuBarExpText:SetPoint("CENTER", MainMenuExpBar, "CENTER", 0, 3)
        MainMenuBarExpText:SetDrawLayer("OVERLAY")
        MainMenuBarExpText:Show()
        ReputationWatchBar:ClearAllPoints()
        ReputationWatchBar:SetPoint("BOTTOM", MainMenuExpBar, "TOP", 0, -2)
    else
        StatusTrackingBarManager:SetWidth((buttonSize + buttonSpacing) * 12)

        MainMenuBarArtFrame.LeftEndCap:Hide()
        MainMenuBarArtFrame.RightEndCap:Hide()
        MainMenuBarArtFrameBackground:ClearAllPoints()
        MainMenuBarArtFrameBackground:Hide()
        MainMenuBarArtFrameBackground.Show = function() end
    end
end

AwesomeUI.Install = function(self)
    -- Set Saved Variables
    SetCVar("autoLootDefault", 1)
    SetCVar("useCompactPartyFrames", 1)
    SetCVar("raidOptionKeepGroupsTogether", 1)
    SetCVar("raidFramesDisplayPowerBars", 1)
    SetCVar("raidFramesHeight", 40)
    SetCVar("raidFramesWidth", 82)
    SetCVar("raidOptionShowBorders", 0)
    SetCVar("raidFramesDisplayClassColor", 1)
    SetCVar("nameplateShowEnemies", 1)
    SetCVar("nameplateShowEnemyTotems", 0)
    SetCVar("ShowClassColorInNameplate", 1)
    SetCVar("xpBarText", 1)
    SetCVar("chatClassColorOverride", 0)
    SetCVar("ffxglow", 0)
    -- SetCVar("worldPreloadNonCritical", 0)

    if wowVersion ~= "Classic" and wowVersion ~= "BC" then
        SetCVar("miniWorldMap", 1)
    end

    -- BC-specific options
    if wowVersion == "BC" then
        SetCVar("nameplateMaxDistance", "41")
    end

     -- Set up chat
    FCF_ResetChatWindows();

    -- Set up tabs
    FCF_SetLocked(ChatFrame1, 1);
    FCF_OpenNewWindow("Whispers");
    FCF_OpenNewWindow("Guild");
    FCF_OpenNewWindow("Group");
    FCF_OpenNewWindow("Misc");

    -- -- Move and resize Chat window
    ChatFrame1:ClearAllPoints();
    ChatFrame1:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 0, 0)
    ChatFrame1:SetSize(450, 150)
    FCF_SavePositionAndDimensions(ChatFrame1)

    FCF_SetChatWindowFontSize(nil, ChatFrame1, 14)
    FCF_SetChatWindowFontSize(nil, ChatFrame2, 14)
    FCF_SetChatWindowFontSize(nil, ChatFrame3, 14)
    FCF_SetChatWindowFontSize(nil, ChatFrame4, 14)
    FCF_SetChatWindowFontSize(nil, ChatFrame5, 14)
    FCF_SetChatWindowFontSize(nil, ChatFrame6, 14)

    -- Set up the general tab

    -- Set up the whisper tab
    ChatFrame_RemoveAllMessageGroups(ChatFrame3)
    ChatFrame_AddMessageGroup(ChatFrame3, "WHISPER")
    ChatFrame_AddMessageGroup(ChatFrame3, "BN_WHISPER")

    -- Set up the Guild tab
    ChatFrame_RemoveAllMessageGroups(ChatFrame4)
    ChatFrame_AddMessageGroup(ChatFrame4, "GUILD")
    ChatFrame_AddMessageGroup(ChatFrame4, "OFFICER")
    ChatFrame_AddMessageGroup(ChatFrame4, "GUILD_ACHIEVEMENT")

    -- Set up the Group tab
    ChatFrame_RemoveAllMessageGroups(ChatFrame5)
    ChatFrame_AddMessageGroup(ChatFrame5, "PARTY")
    ChatFrame_AddMessageGroup(ChatFrame5, "PARTY_LEADER")
    ChatFrame_AddMessageGroup(ChatFrame5, "RAID")
    ChatFrame_AddMessageGroup(ChatFrame5, "RAID_LEADER")
    ChatFrame_AddMessageGroup(ChatFrame5, "RAID_WARNING")
    ChatFrame_AddMessageGroup(ChatFrame5, "BATTLEGROUND")
    ChatFrame_AddMessageGroup(ChatFrame5, "BATTLEGROUND_LEADER")
    ChatFrame_AddMessageGroup(ChatFrame5, "INSTANCE_CHAT")
    ChatFrame_AddMessageGroup(ChatFrame5, "INSTANCE_CHAT_LEADER")
    ChatFrame_AddMessageGroup(ChatFrame5, "EMOTE")

    -- Set up the misc tab
    ChatFrame_RemoveAllMessageGroups(ChatFrame6)
    ChatFrame_AddMessageGroup(ChatFrame6, "COMBAT_XP_GAIN")
    ChatFrame_AddMessageGroup(ChatFrame6, "COMBAT_HONOR_GAIN")
    ChatFrame_AddMessageGroup(ChatFrame6, "COMBAT_MISC_INFO")
    ChatFrame_AddMessageGroup(ChatFrame6, "COMBAT_GUILD_XP_GAIN")
    ChatFrame_AddMessageGroup(ChatFrame6, "SKILL")
    ChatFrame_AddMessageGroup(ChatFrame6, "LOOT")
    ChatFrame_AddMessageGroup(ChatFrame6, "MONEY")
    ChatFrame_AddMessageGroup(ChatFrame6, "TARGETICONS")
end

--
-- Event handlers
--
AwesomeUI.OnAddonLoaded = function(self)
    -- setup options panel
    AwesomeUI.optionsFrame = CreateFrame("Frame", "AwesomeUIOptions", AwesomeUI.frame)
    AwesomeUI.optionsFrame.name = "Settings"
    AwesomeUI.optionsFrame.parent = AwesomeUI.frame.name
    local lastKey = nil
    for key, value in pairs(PossibleOptions) do
        AwesomeUI.optionsFrame[key] = NewCheckbox(AwesomeUI.optionsFrame, key)
        if lastKey then
            AwesomeUI.optionsFrame[key]:SetPoint("TOPLEFT", AwesomeUI.optionsFrame[lastKey], "BOTTOMLEFT")
        else
            AwesomeUI.optionsFrame[key]:SetPoint("TOPLEFT", 16, -16)
        end
        lastKey = key
    end

    -- add interface options
    InterfaceOptions_AddCategory(AwesomeUI.frame)
    InterfaceOptions_AddCategory(AwesomeUI.optionsFrame)

    -- set up aura tracker
    -- TODO: create classic aura tracker that doesn't depend on Specializations
    if wowVersion == "Retail" then
        self.auraTracker = CreateAuraTracker()
    elseif wowVersion == "BC" then
        -- self.auraTracker = CreateAuraTracker()
    end
end

AwesomeUI.OnTargetChange = function(self)
    -- Change color of player name bar
    if UnitIsPlayer("target") then
        c = RAID_CLASS_COLORS[select(2, UnitClass("target"))]
        TargetFrameNameBackground:SetVertexColor(c.r, c.g, c.b)
    end
    if UnitIsPlayer("focus") then
        c = RAID_CLASS_COLORS[select(2, UnitClass("focus"))]
        FocusFrameNameBackground:SetVertexColor(c.r, c.g, c.b)
    end
end

AwesomeUI.OnPlayerLogin = function(self)
    if AccountSettings == nil then
        AccountSettings = {}
    end

    for key, value in pairs(PossibleOptions) do
        if AccountSettings[key] == nil then
            AccountSettings[key] = value.defaultValue
        end
    end

    --
    -- Reposition tooltip --
    --
    hooksecurefunc("GameTooltip_SetDefaultAnchor", function(tooltip, parent)
        tooltip:SetOwner(parent, "ANCHOR_NONE")
        tooltip:ClearAllPoints()
        tooltip:SetPoint("BOTTOMLEFT", "UIParent", "CENTER", 300,-50)
        tooltip.default = 1
    end)

    --
    -- Class icons instead of portraits
    --
    hooksecurefunc("UnitFramePortrait_Update",function(self)
        if self.portrait then
            if UnitIsPlayer(self.unit) and self.unit ~= "player" then
                local t = CLASS_ICON_TCOORDS[select(2, UnitClass(self.unit))]
                if t then
                    self.portrait:SetTexture("Interface\\TargetingFrame\\UI-Classes-Circles")
                    self.portrait:SetTexCoord(unpack(t))
                end
            else
                self.portrait:SetTexCoord(0,1,0,1)
            end
        end
    end)

    --
    -- Class color in HP bars
    --
    local function color(statusbar, unit)
        local _, class, c
        if UnitIsPlayer(unit) and UnitIsConnected(unit) and unit == statusbar.unit and UnitClass(unit) then
            _, class = UnitClass(unit)
            c = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]
            statusbar:SetStatusBarColor(c.r, c.g, c.b)
            if unit == "player" then
                local health_percentage = UnitHealth("player") / UnitHealthMax("player")
                local r, g = 0, 1
                if health_percentage > 0.5 then
                    r = Lerp(1, 0, (health_percentage - 0.5) * 2)
                else
                    r = 1
                    g = Lerp(0, 1, health_percentage * 2)
                end
                PlayerFrameHealthBar:SetStatusBarColor(r,g,0)
            end
        end
    end

    hooksecurefunc("UnitFrameHealthBar_Update", color)
    hooksecurefunc("HealthBar_OnValueChanged", function(self)
        color(self, self.unit)
    end)

    --
    -- Move debuffs
    --
    hooksecurefunc("CreateFrame", function(frameType, name, frame, ...)
        local _, playerClass = UnitClass("player")
        if (name ~= "DebuffButton1") then return end

        DebuffButton1:ClearAllPoints()
        if playerClass == "PALADIN" then
            DebuffButton1:SetPoint("TOPRIGHT", PaladinPowerBarFrame, "BOTTOMRIGHT", 0, -7)
        elseif  playerClass == "DEATHKNIGHT" then
            DebuffButton1:SetPoint("TOPRIGHT", RuneFrame, "BOTTOMRIGHT", 0, -13)
        elseif  playerClass == "PRIEST" then
            DebuffButton1:SetPoint("TOPRIGHT", PlayerFrame, "BOTTOMRIGHT", 0, 13)
        elseif  playerClass == "SHAMAN" then
            DebuffButton1:SetPoint("TOPRIGHT", TotemFrame, "BOTTOMRIGHT", 0, 0)
        elseif  playerClass == "HUNTER" or playerClass == "WARLOCK"then
            DebuffButton1:SetPoint("TOPRIGHT", PetFrame, "BOTTOMRIGHT", 9, -7)
        elseif  playerClass == "MONK" then
            DebuffButton1:SetPoint("TOPRIGHT", PlayerFrame, "BOTTOMRIGHT", 0, 0)
        elseif  playerClass == "DRUID" then
            DebuffButton1:SetPoint("TOPRIGHT", PlayerFrame, "BOTTOMRIGHT", 0, 0)
        elseif  playerClass == "MAGE" then
            DebuffButton1:SetPoint("TOPRIGHT", PlayerFrame, "BOTTOMRIGHT", 0,-8)
        else
            DebuffButton1:SetPoint("TOPRIGHT", PlayerFrame, "BOTTOMRIGHT", 0, 20)
        end
        DebuffButton1.SetPoint = function() end
        DebuffButton1.SetParent = function() end
    end)

    --
    -- Setup cast bars
    --
    CastingBarFrame:ClearAllPoints()
    CastingBarFrame:SetPoint("BOTTOM", UIParent, "CENTER", 0, ACTION_BAR_OFFSET_Y - 85)
    CastingBarFrame:SetHeight(12)
    CastingBarFrame:SetWidth(CastingBarFrame:GetWidth() * 1.2)
    CastingBarFrame.SetPoint = function() end

    CastingBarFrame.Border:ClearAllPoints()
    CastingBarFrame.Border:SetPoint("TOP", 0, 26)
    CastingBarFrame.Border:SetWidth(CastingBarFrame.Border:GetWidth() * 1.22)
    CastingBarFrame.Border:SetTexture("Interface\\CastingBar\\UI-CastingBar-Border-Small.blp")

    CastingBarFrame.Flash:SetTexture(nil)
    CastingBarFrame.Spark:SetTexture(nil)

    CastingBarFrame.Text:ClearAllPoints()
    CastingBarFrame.Text:SetPoint("CENTER",0,1)

    --
    -- Casting bar timer
    --
    CastingBarFrame.timer = CastingBarFrame:CreateFontString(nil)
    CastingBarFrame.timer:SetFont(STANDARD_TEXT_FONT,12,"OUTLINE")
    CastingBarFrame.timer:SetPoint("RIGHT", CastingBarFrame, "RIGHT", 0, 0)
    CastingBarFrame.update = .1
    CastingBarFrame:HookScript("OnUpdate", function(self, elapsed)
        if not self.timer then
            return
        end
        if self.update and self.update < elapsed then
            if self.casting then
                self.timer:SetText(format("%2.1f/%1.1f", max(self.maxValue - self.value, 0), self.maxValue))
                elseif self.channeling then
                    self.timer:SetText(format("%.1f", max(self.value, 0)))
                else
                    self.timer:SetText("")
                end
                self.update = .1
            else
                self.update = self.update - elapsed
            end
        end)

    --
    -- Minimap tweaks
    --
    MinimapZoomIn:Hide()
    MinimapZoomOut:Hide()
    Minimap:EnableMouseWheel(true)
    Minimap:SetScript('OnMouseWheel', function(self, delta)
        if delta > 0 then
            Minimap_ZoomIn()
        else
            Minimap_ZoomOut()
        end
    end)
    if wowVersion == "Retail" then
        MiniMapTracking:ClearAllPoints()
        MiniMapTracking:SetPoint("TOPRIGHT", -26, 7)
    elseif wowVersion == "BC" then
        MiniMapTracking:ClearAllPoints()
        MiniMapTracking:SetPoint("TOPLEFT", 28, 0)
    end

    self:Refresh()
end

AwesomeUI.frame:RegisterEvent("ADDON_LOADED")
AwesomeUI.frame:RegisterEvent("PLAYER_LOGIN")
AwesomeUI.frame:RegisterEvent("PLAYER_TARGET_CHANGED")
AwesomeUI.frame:RegisterEvent("GROUP_ROSTER_UPDATE")
AwesomeUI.frame:RegisterEvent("UNIT_FACTION")
if wowVersion ~= "Classic" then
    AwesomeUI.frame:RegisterEvent("PLAYER_FOCUS_CHANGED")
end

AwesomeUI.frame:SetScript("OnEvent", function(self,event,...)
    if event == "ADDON_LOADED" and (... == "AwesomeUI") then
        AwesomeUI:OnAddonLoaded()
    elseif event == "PLAYER_LOGIN" then
        AwesomeUI:OnPlayerLogin()
    elseif (event == "GROUP_ROSTER_UPDATE" or
        event == "PLAYER_TARGET_CHANGED" or
        event == "PLAYER_FOCUS_CHANGED" or
        event == "UNIT_FACTION") then
        AwesomeUI:OnTargetChange()
    end
end)


--
-- Slash commands
--
SLASH_RL1 = "/rl";
SlashCmdList["RL"] = function() ReloadUI() end

SLASH_INSTALL1 = "/install";
SlashCmdList["INSTALL"] = function()
    AwesomeUI:Install()
end
