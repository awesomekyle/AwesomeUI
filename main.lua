local function width_of_buttons(buttonCount, buttonSize, spacing)
    return buttonSize * buttonCount + spacing * buttonCount-1
end

local function update_actionbars()
    local buttonSize = MultiBarBottomRightButton1:GetWidth()
    local buttonSpacing = 6

    MultiBarBottomRightButton1:ClearAllPoints()
    MultiBarBottomRightButton1:SetPoint("BOTTOMLEFT", StatusTrackingBarManager, "BOTTOM",-width_of_buttons(6,buttonSize,buttonSpacing) + 0.5 * buttonSpacing, 4)
    MultiBarBottomRightButton7:ClearAllPoints()
    MultiBarBottomRightButton7:SetPoint("LEFT", MultiBarBottomRightButton6, "RIGHT", 6, 0)

    MultiBarBottomLeftButton1:ClearAllPoints()
    MultiBarBottomLeftButton1:SetPoint("BOTTOM", MultiBarBottomRightButton1, "TOP", 0, 6)
    MultiBarBottomLeftButton7:ClearAllPoints()
    MultiBarBottomLeftButton7:SetPoint("LEFT", MultiBarBottomLeftButton6, "RIGHT", 6, 0)

    ActionButton1:ClearAllPoints()
    ActionButton1:SetPoint("LEFT", UIParent, "CENTER", -123, -160)
    ActionButton7:ClearAllPoints()
    ActionButton7:SetPoint("TOP", ActionButton1, "BOTTOM", 0, -buttonSpacing)

    for i=1, 12 do
        _G["ActionButton"..i]:SetAlpha(.7) -- main bar
    end

    MainMenuBarArtFrame.LeftEndCap:Hide()
    MainMenuBarArtFrame.RightEndCap:Hide()
    MainMenuBarArtFrameBackground:ClearAllPoints()
    MainMenuBarArtFrameBackground:Hide()
    MainMenuBarArtFrameBackground.Show = function() end

    StatusTrackingBarManager:SetWidth((buttonSize + buttonSpacing) * 12)
end

-- Set up frame to run on login
local frame = CreateFrame("Frame");
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("PLAYER_TALENT_UPDATE")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("GROUP_ROSTER_UPDATE")
frame:RegisterEvent("PLAYER_TARGET_CHANGED")
frame:RegisterEvent("PLAYER_FOCUS_CHANGED")
frame:RegisterEvent("UNIT_FACTION")

frame:SetScript("OnEvent",function(self,event,id)
    if(event == "PLAYER_LOGIN") then
        if AccountSettings == nil then
            AccountSettings = {
                ["showMacroText"] = true,
                ["repositionActionBars"] = true,
            }
        end
        if CharacterSettings == nil then
            CharacterSettings = {}
        end

        if AccountSettings.repositionActionBars == true then
            update_actionbars()
        end

        --
        -- Reposition tooltip --
        --
        hooksecurefunc("GameTooltip_SetDefaultAnchor", function(tooltip, parent)
            tooltip:SetOwner(parent, "ANCHOR_NONE")
            tooltip:ClearAllPoints()
            tooltip:SetPoint("BOTTOMLEFT", "UIParent", "CENTER", 300,-50)
            tooltip.default = 1
        end);

        --
        -- Class icons instead of portraits
        --
        hooksecurefunc("UnitFramePortrait_Update",function(self)
            if self.portrait then
                if UnitIsPlayer(self.unit) then
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
                PlayerFrameHealthBar:SetStatusBarColor(0,1,0)
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
            if( playerClass == "PALADIN") then
                DebuffButton1:SetPoint("TOPRIGHT", PaladinPowerBarFrame, "BOTTOMRIGHT", 0, 0)
            elseif ( playerClass == "DEATHKNIGHT" ) then
                DebuffButton1:SetPoint("TOPRIGHT", RuneFrame, "BOTTOMRIGHT", 0, -10)
            elseif ( playerClass == "PRIEST" ) then
                DebuffButton1:SetPoint("TOPRIGHT", PlayerFrame, "BOTTOMRIGHT", 0, 13)
            elseif ( playerClass == "SHAMAN" ) then
                DebuffButton1:SetPoint("TOPRIGHT", TotemFrame, "BOTTOMRIGHT", 0, 0)
            elseif ( playerClass == "HUNTER" or playerClass == "WARLOCK") then
                DebuffButton1:SetPoint("TOPRIGHT", PetFrame, "BOTTOMRIGHT", 9, -7)
            elseif ( playerClass == "MONK" ) then
                DebuffButton1:SetPoint("TOPRIGHT", PlayerFrame, "BOTTOMRIGHT", 0, 0)
            elseif ( playerClass == "DRUID" ) then
                DebuffButton1:SetPoint("TOPRIGHT", PlayerFrame, "BOTTOMRIGHT", 0, 0)
            else
                DebuffButton1:SetPoint("TOPRIGHT", PlayerFrame, "BOTTOMRIGHT", 0, 20)
            end
            DebuffButton1.SetPoint = function() end
            DebuffButton1.SetParent = function() end
        end);

        --
        -- Setup cast bars --
        --
        CastingBarFrame:ClearAllPoints()
        CastingBarFrame:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 355)
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
        MiniMapTracking:ClearAllPoints()
        MiniMapTracking:SetPoint("TOPRIGHT", -26, 7)

    elseif( event == "GROUP_ROSTER_UPDATE" or
        event == "PLAYER_TARGET_CHANGED" or
        event == "PLAYER_FOCUS_CHANGED" or
        event == "UNIT_FACTION") then
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
end)

-------------------------------------------------------------
-- Install function, used to set up common things on characters
local function Install()
    -- Set Saved Variables
    SetCVar( "autoLootDefault", 1);
    SetCVar( "minimapZoom", 0 );
    SetCVar( "minimapInsideZoom", 0 );
    SetCVar( "useCompactPartyFrames", 1 );
    SetCVar( "raidOptionKeepGroupsTogether", 1 );
    SetCVar( "raidFramesDisplayPowerBars", 1 );
    SetCVar( "raidFramesHeight", 40 );
    SetCVar( "raidFramesWidth", 82 );
    SetCVar( "raidOptionShowBorders", 0 );
    SetCVar( "raidFramesDisplayClassColor", 1 );
    SetCVar( "nameplateShowEnemies", 1 );
    SetCVar( "nameplateShowEnemyTotems", 0 );
    SetCVar( "ShowClassColorInNameplate", 1 );
    SetCVar( "miniWorldMap", 1 );

    -- Set up chat
    -- FCF_ResetChatWindows();

    -- Set up tabs
    FCF_SetLocked(ChatFrame1, 1);
    FCF_OpenNewWindow("Whispers");
    FCF_OpenNewWindow("Guild");
    FCF_OpenNewWindow("Group");
    FCF_OpenNewWindow("Misc");

    -- -- Move and resize Chat window
    -- ChatFrame1:ClearAllPoints();
    -- ChatFrame1:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 0, 165 );
    -- ChatFrame1:SetSize( 450, 150 );

    FCF_SavePositionAndDimensions( ChatFrame1 );
    FCF_SetChatWindowFontSize( nil, ChatFrame1, 12 );
    FCF_SetChatWindowFontSize( nil, ChatFrame2, 12 );
    FCF_SetChatWindowFontSize( nil, ChatFrame3, 12 );
    FCF_SetChatWindowFontSize( nil, ChatFrame4, 12 );
    FCF_SetChatWindowFontSize( nil, ChatFrame5, 12 );
    FCF_SetChatWindowFontSize( nil, ChatFrame6, 12 );

    -- Set up the general tab

    -- Set up the whisper tab
    ChatFrame_RemoveAllMessageGroups( ChatFrame3 );
    ChatFrame_AddMessageGroup( ChatFrame3, "WHISPER" );
    ChatFrame_AddMessageGroup( ChatFrame3, "BN_WHISPER" );

    -- Set up the Guild tab
    ChatFrame_RemoveAllMessageGroups( ChatFrame4 );
    ChatFrame_AddMessageGroup( ChatFrame4, "GUILD" );
    ChatFrame_AddMessageGroup( ChatFrame4, "OFFICER" );
    ChatFrame_AddMessageGroup( ChatFrame4, "GUILD_ACHIEVEMENT" );

    -- Set up the Group tab
    ChatFrame_RemoveAllMessageGroups( ChatFrame5 );
    ChatFrame_AddMessageGroup( ChatFrame5, "PARTY" );
    ChatFrame_AddMessageGroup( ChatFrame5, "PARTY_LEADER" );
    ChatFrame_AddMessageGroup( ChatFrame5, "RAID" );
    ChatFrame_AddMessageGroup( ChatFrame5, "RAID_LEADER" );
    ChatFrame_AddMessageGroup( ChatFrame5, "RAID_WARNING" );
    ChatFrame_AddMessageGroup( ChatFrame5, "BATTLEGROUND" );
    ChatFrame_AddMessageGroup( ChatFrame5, "BATTLEGROUND_LEADER" );
    ChatFrame_AddMessageGroup( ChatFrame5, "INSTANCE_CHAT")
    ChatFrame_AddMessageGroup( ChatFrame5, "INSTANCE_CHAT_LEADER")
    ChatFrame_AddMessageGroup( ChatFrame5, "EMOTE" );

    -- Set up the misc tab
    ChatFrame_RemoveAllMessageGroups( ChatFrame6 );
    ChatFrame_AddMessageGroup( ChatFrame6, "COMBAT_XP_GAIN" );
    ChatFrame_AddMessageGroup( ChatFrame6, "COMBAT_HONOR_GAIN" );
    ChatFrame_AddMessageGroup( ChatFrame6, "COMBAT_MISC_INFO" );
    ChatFrame_AddMessageGroup( ChatFrame6, "COMBAT_GUILD_XP_GAIN" );
    ChatFrame_AddMessageGroup( ChatFrame6, "SKILL" );
    ChatFrame_AddMessageGroup( ChatFrame6, "LOOT" );
    ChatFrame_AddMessageGroup( ChatFrame6, "MONEY" );
    ChatFrame_AddMessageGroup( ChatFrame6, "TARGETICONS" );

    Installed = true;
end -- Install
-------------------------------------------------------------

local function toggle_keybinds()
    show_keybinds = not show_keybinds
    if(show_keybinds == true) then
        for i=1, 12 do
            _G["ActionButton"..i.."HotKey"]:SetAlpha(1) -- main bar
            _G["MultiBarBottomRightButton"..i.."HotKey"]:SetAlpha(1) -- bottom right bar
            _G["MultiBarBottomLeftButton"..i.."HotKey"]:SetAlpha(1) -- bottom left bar
            _G["MultiBarRightButton"..i.."HotKey"]:SetAlpha(1) -- right bar
            _G["MultiBarLeftButton"..i.."HotKey"]:SetAlpha(1) -- left bar
        end
    else
        for i=1, 12 do
            _G["ActionButton"..i.."HotKey"]:SetAlpha(0) -- main bar
            _G["MultiBarBottomRightButton"..i.."HotKey"]:SetAlpha(0) -- bottom right bar
            _G["MultiBarBottomLeftButton"..i.."HotKey"]:SetAlpha(0) -- bottom left bar
            _G["MultiBarRightButton"..i.."HotKey"]:SetAlpha(0) -- right bar
            _G["MultiBarLeftButton"..i.."HotKey"]:SetAlpha(0) -- left bar
        end
    end
end

local function set_macro_text(enabled)
    local alpha = 1
    if enabled == false then
        alpha = 0
    end
    for i=1, 12 do
        _G["ActionButton"..i.."Name"]:SetAlpha(alpha) -- main bar
        _G["MultiBarBottomRightButton"..i.."Name"]:SetAlpha(alpha) -- bottom right bar
        _G["MultiBarBottomLeftButton"..i.."Name"]:SetAlpha(alpha) -- bottom left bar
        _G["MultiBarRightButton"..i.."Name"]:SetAlpha(alpha) -- right bar
        _G["MultiBarLeftButton"..i.."Name"]:SetAlpha(alpha) -- left bar
    end
end
local function toggle_macros()
    AccountSettings["showMacroText"] = not AccountSettings["showMacroText"]
    set_macro_text(AccountSettings["showMacroText"])
end

--
-- Slash commands
--
SLASH_RL1 = "/rl";
SlashCmdList["RL"] = function() ReloadUI() end

SLASH_INSTALL1 = "/install";
SlashCmdList["INSTALL"] = function() Install() end

SLASH_KEYBINDS1 = "/keybinds"
SlashCmdList["KEYBINDS"] = function() toggle_keybinds() end

SLASH_MACROS1 = "/macros"
SlashCmdList["MACROS"] = function() toggle_macros() end

SlashCmdList["CLCE"] = function() CombatLogClearEntries() end
SLASH_CLCE1 = "/clc"

SlashCmdList["TICKET"] = function() ToggleHelpFrame() end
SLASH_TICKET1 = "/gm"

SlashCmdList["READYCHECK"] = function() DoReadyCheck() end
SLASH_READYCHECK1 = '/rc'

SlashCmdList["CHECKROLE"] = function() InitiateRolePoll() end
SLASH_CHECKROLE1 = '/cr'

--
-- Interface options
--
-- awesomeUI = {}
-- awesomeUI.frame = CreateFrame("Frame", "AwesomeUIPanel", UIParent)
-- awesomeUI.frame.name = "AwesomeUI"

-- local macroTextCheckbox = CreateFrame("CheckButton", "AwesomeUI_ShowMacroTextCheckButton", awesomeUI.frame, "InterfaceOptionsCheckButtonTemplate")
-- AwesomeUI_ShowMacroTextCheckButtonText:SetText("Show macro text in action bars")
-- macroTextCheckbox:SetScript("OnClick",
--     function(self)
--         AccountSettings["showMacroText"] = self:GetChecked()
--         set_macro_text(AccountSettings["showMacroText"])
--     end
-- )
-- -- macroTextCheckbox.label = _G[macroTextCheckbox:GetName().."Text"]
-- -- macroTextCheckbox.label:SetText()

-- awesomeUI.frame.showMacroText = macroTextCheckbox
-- awesomeUI.frame.showMacroText:SetPoint("TOPLEFT", 16, -16)
-- InterfaceOptions_AddCategory(awesomeUI.frame)

-- function AwesomeUI_LoadOptionsPanel(panel)
--     panel.name = "AwesomeUI"
--     InterfaceOptions_AddCategory(panel)
-- end
