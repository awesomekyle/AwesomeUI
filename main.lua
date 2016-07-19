-- local function update_actionbars()
--     local kActionBarSpacing = 4

--     --MultiBarBottomRight:SetParent(UIParent)
--     MultiBarBottomRight:ClearAllPoints()
--     MultiBarBottomRight:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, kActionBarSpacing/2)
--     --MultiBarBottomLeft:SetParent(UIParent)
--     MultiBarBottomLeft:ClearAllPoints()
--     MultiBarBottomLeft:SetPoint("BOTTOM", MultiBarBottomRight, "TOP", 0, kActionBarSpacing)
--     MultiBarBottomLeft.SetPoint = function() end
--     MainMenuExpBar:ClearAllPoints()
--     MainMenuExpBar:SetPoint("BOTTOM", MultiBarBottomLeft, "TOP", 0, 4)

--     ActionButton1:ClearAllPoints()
--     ActionButton1:SetPoint("LEFT", UIParent, "CENTER", -123, -160)
--     ActionButton7:ClearAllPoints()
--     ActionButton7:SetPoint("TOP", ActionButton1, "BOTTOM", 0, -kActionBarSpacing)

--     for i=1, 12 do
--         _G["ActionButton"..i]:SetAlpha(.8) -- main bar
--     end

--     PetActionBarFrame:ClearAllPoints()
--     PetActionBarFrame:SetPoint("BOTTOMRIGHT", MultiBarBottomLeft, "TOPRIGHT", 31, kActionBarSpacing)
--     PetActionBarFrame:SetScale(0.9)

--     StanceButton1:ClearAllPoints()
--     StanceButton1:SetPoint("BOTTOMLEFT", MultiBarBottomLeft, "TOPLEFT", 10, kActionBarSpacing+2)
--     StanceButton1:SetScale(0.75)

--     for i=2, 8 do
--         -- _G["StanceButton"..i]:ClearAllPoints()
--         -- _G["StanceButton"..i]:SetPoint("BOTTOM", _G["StanceButton"..i-1], "TOP", 0, kActionBarSpacing)
--         _G["StanceButton"..i]:SetScale(0.75)
--     end
-- end

-- local BlizzHide = false
-- local function toggle_blizz()
--     if BlizzHide == false then
--         CharacterMicroButton:Hide()
--         SpellbookMicroButton:Hide()
--         TalentMicroButton:Hide()
--         AchievementMicroButton:SetAlpha(0)
--         QuestLogMicroButton:Hide()
--         GuildMicroButton:Hide()
--         LFDMicroButton:Hide()
--         CollectionsMicroButton:Hide()
--         EJMicroButton:Hide()
--         StoreMicroButton:Hide()
--         StoreMicroButton:SetAlpha(0)
--         MainMenuMicroButton:Hide()
--         if(PVPMicroButton) then
--             PVPMicroButton:Hide()
--         end
--         MainMenuBarBackpackButton:Hide()
--         CharacterBag0Slot:Hide()
--         CharacterBag1Slot:Hide()
--         CharacterBag2Slot:Hide()
--         CharacterBag3Slot:Hide()
--         ReputationWatchBar:Hide()
--         BlizzHide = true
--     elseif BlizzHide == true then
--         MainMenuBarBackpackButton:SetPoint("BOTTOMRIGHT", MainMenuMicroButton, "TOPRIGHT", 0, -20)
--         CharacterMicroButton:Show()
--         SpellbookMicroButton:Show()
--         TalentMicroButton:Show()
--         AchievementMicroButton:SetAlpha(1)
--         QuestLogMicroButton:Show()
--         GuildMicroButton:Show()
--         LFDMicroButton:Show()
--         CollectionsMicroButton:Show()
--         EJMicroButton:Show()
--         StoreMicroButton:Show()
--         StoreMicroButton:SetAlpha(1)
--         MainMenuMicroButton:Show()
--         if(PVPMicroButton) then
--             PVPMicroButton:Show()
--         end

--         MainMenuBarBackpackButton:Show()
--         CharacterBag0Slot:Show()
--         CharacterBag1Slot:Show()
--         CharacterBag2Slot:Show()
--         CharacterBag3Slot:Show()
--         ReputationWatchBar:Show()
--         BlizzHide = false
--     end
-- end

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
        --
        -- Disable Dragon end caps
        --
        -- MainMenuBarLeftEndCap:Hide()
        -- MainMenuBarRightEndCap:Hide()

        -- --
        -- -- Hide Blizzard stuff
        -- --
        -- HelpMicroButton:Hide()
        -- HelpMicroButton.Show = function() end
        -- CharacterMicroButton:ClearAllPoints()
        -- CharacterMicroButton:SetPoint("RIGHT",145,0)
        -- -- Rep bar
        -- local width, height = ReputationWatchBar:GetSize()
        -- ReputationWatchBar:SetSize(width / 2, height)
        -- ReputationWatchBar:SetSize(width / 2, height)
        -- ReputationWatchBar.StatusBar.WatchBarTexture2:Hide()
        -- ReputationWatchBar.StatusBar.WatchBarTexture3:Hide()

        -- ReputationWatchBar:SetSize(width/2, height)
        -- ReputationWatchBar:SetPoint("BOTTOM", MainMenuExpBar, "TOP")
        -- ReputationWatchBar.SetPoint = function() end
        -- ReputationWatchBar:Hide()
        -- ReputationWatchBar.Show = function() end

        -- MainMenuBarTexture0:Hide()
        -- MainMenuBarTexture1:Hide()
        -- MainMenuBarTexture2:Hide()
        -- MainMenuBarTexture3:Hide()
        -- MainMenuBarOverlayFrame:Hide()
        -- MainMenuBarMaxLevelBar:Hide()
        -- MainMenuBarMaxLevelBar.Show = function() end

        -- ActionBarUpButton:Hide()
        -- ActionBarDownButton:Hide()
        -- MainMenuBarPageNumber:SetAlpha(0)

        -- toggle_blizz()
        -- update_actionbars()

        -- -- Exp bar
        -- local width, height = MainMenuExpBar:GetSize()
        -- MainMenuExpBar:SetSize(width/2, height)
        -- MainMenuExpBar.SetSize = function() end
        -- -- Hide XP bar ticks
        -- for i=19,10,-1 do
        --     local texture = _G["MainMenuXPBarDiv"..i];
        --     if texture then
        --         texture:Hide()
        --     end
        -- end


        --
        -- Reposition tooltip --
        --
        hooksecurefunc("GameTooltip_SetDefaultAnchor", function(tooltip, parent)
            tooltip:SetOwner(parent, "ANCHOR_CURSOR")
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
        CastingBarFrame.SetPoint = function() end

        CastingBarFrame.Border:ClearAllPoints()
        CastingBarFrame.Border:SetPoint("TOP", 0, 26)

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
        CastingBarFrame.timer:SetPoint("RIGHT", CastingBarFrame, "RIGHT", 2, -16)
        CastingBarFrame.update = .1
        hooksecurefunc("CastingBarFrame_OnUpdate", function(self, elapsed)
            if not self.timer then return end
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

        --
        -- Create button to toggle blizzard UI
        --
        -- local f = CreateFrame("Button",nil,UIParent)
        -- f:SetSize(30,30)
        -- f.t=f:CreateTexture(nil,"BORDER")
        -- f.t:SetTexture("Interface\\CHATFRAME\\UI-ChatIcon-Maximize-Up.blp")
        -- f.t:SetAllPoints(f)
        -- f:SetPoint("BOTTOMRIGHT", UIParent,"BOTTOMRIGHT",0,0)
        -- f:Show()
        -- f.hide = true

        -- f:SetScript("OnMouseDown", function(self, button)
        --     if f.hide  == false then
        --         if button == "LeftButton" then
        --             f.t:SetTexture("Interface\\CHATFRAME\\UI-ChatIcon-Minimize-Down.blp")
        --         end
        --     elseif f.hide == true then
        --         if button == "LeftButton" then
        --             f.t:SetTexture("Interface\\CHATFRAME\\UI-ChatIcon-Maximize-Down.blp")
        --         end
        --     end
        -- end)

        -- f:SetScript("OnMouseUp", function(self, button)
        --     if f.hide  == false then
        --         if button == "LeftButton" then
        --             f.t:SetTexture("Interface\\CHATFRAME\\UI-ChatIcon-Minimize-Up.blp")
        --         end
        --     elseif f.hide == true then
        --         if button == "LeftButton" then
        --             f.t:SetTexture("Interface\\CHATFRAME\\UI-ChatIcon-Maximize-Up.blp")
        --         end
        --     end
        -- end)

        -- f:SetScript("OnClick", function(self, button)
        --     toggle_blizz()
        --     if f.hide == false then
        --         f.t:SetTexture("Interface\\CHATFRAME\\UI-ChatIcon-Maximize-Up.blp")
        --         f.hide = true
        --     elseif f.hide == true then
        --         f.t:SetTexture("Interface\\CHATFRAME\\UI-ChatIcon-Minimize-Up.blp")
        --         CharacterMicroButton:ClearAllPoints()
        --         CharacterMicroButton:SetPoint("BOTTOMRIGHT", f, "BOTTOMLEFT", -265, 0)
        --         -- MainMenuExpBar:ClearAllPoints()
        --         -- MainMenuExpBar:SetPoint("BOTTOMRIGHT", f, "BOTTOMLEFT", -10, 0)
        --         -- ReputationWatchBar:ClearAllPoints()
        --         -- ReputationWatchBar:SetPoint("BOTTOMRIGHT", f, "BOTTOMLEFT", -10, 5)
        --         f.hide = false
        --     end
        -- end)

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
    FCF_ResetChatWindows();

    -- Set up tabs
    FCF_SetLocked(ChatFrame1, 1);
    FCF_OpenNewWindow("Whispers");
    FCF_OpenNewWindow("Guild");
    FCF_OpenNewWindow("Group");
    FCF_OpenNewWindow("Misc");

    -- Move and resize Chat window
    ChatFrame1:ClearAllPoints();
    ChatFrame1:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 0, 165 );
    ChatFrame1:SetSize( 450, 150 );

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

    -- Enable class color for every channel
    ToggleChatColorNamesByClassGroup(true, "SAY")
    ToggleChatColorNamesByClassGroup(true, "EMOTE")
    ToggleChatColorNamesByClassGroup(true, "YELL")
    ToggleChatColorNamesByClassGroup(true, "GUILD")
    ToggleChatColorNamesByClassGroup(true, "OFFICER")
    ToggleChatColorNamesByClassGroup(true, "GUILD_ACHIEVEMENT")
    ToggleChatColorNamesByClassGroup(true, "ACHIEVEMENT")
    ToggleChatColorNamesByClassGroup(true, "WHISPER")
    ToggleChatColorNamesByClassGroup(true, "PARTY")
    ToggleChatColorNamesByClassGroup(true, "PARTY_LEADER")
    ToggleChatColorNamesByClassGroup(true, "INSTANCE_CHAT")
    ToggleChatColorNamesByClassGroup(true, "INSTANCE_CHAT_LEADER")
    ToggleChatColorNamesByClassGroup(true, "RAID")
    ToggleChatColorNamesByClassGroup(true, "RAID_LEADER")
    ToggleChatColorNamesByClassGroup(true, "RAID_WARNING")
    ToggleChatColorNamesByClassGroup(true, "BATTLEGROUND")
    ToggleChatColorNamesByClassGroup(true, "BATTLEGROUND_LEADER")
    ToggleChatColorNamesByClassGroup(true, "CHANNEL1")
    ToggleChatColorNamesByClassGroup(true, "CHANNEL2")
    ToggleChatColorNamesByClassGroup(true, "CHANNEL3")
    ToggleChatColorNamesByClassGroup(true, "CHANNEL4")
    ToggleChatColorNamesByClassGroup(true, "CHANNEL5")

    Installed = true;
end -- Install
-------------------------------------------------------------

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
