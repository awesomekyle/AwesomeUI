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

local show_macros = true
local show_keybinds = true


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

local function toggle_macros()
    show_macros = not show_macros
    if(show_macros == true) then
        for i=1, 12 do
            _G["ActionButton"..i.."Name"]:SetAlpha(1) -- main bar
            _G["MultiBarBottomRightButton"..i.."Name"]:SetAlpha(1) -- bottom right bar
            _G["MultiBarBottomLeftButton"..i.."Name"]:SetAlpha(1) -- bottom left bar
            _G["MultiBarRightButton"..i.."Name"]:SetAlpha(1) -- right bar
            _G["MultiBarLeftButton"..i.."Name"]:SetAlpha(1) -- left bar
        end
    else
        for i=1, 12 do
            _G["ActionButton"..i.."Name"]:SetAlpha(0) -- main bar
            _G["MultiBarBottomRightButton"..i.."Name"]:SetAlpha(0) -- bottom right bar
            _G["MultiBarBottomLeftButton"..i.."Name"]:SetAlpha(0) -- bottom left bar
            _G["MultiBarRightButton"..i.."Name"]:SetAlpha(0) -- right bar
            _G["MultiBarLeftButton"..i.."Name"]:SetAlpha(0) -- left bar
        end
    end
end

function update_actionbars()
    local kActionBarSpacing = 4

    MultiBarBottomRight:SetParent(UIParent)
    MultiBarBottomRight:ClearAllPoints()
    MultiBarBottomRight:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, kActionBarSpacing/2)
    MultiBarBottomLeft:SetParent(UIParent)
    MultiBarBottomLeft:ClearAllPoints()
    MultiBarBottomLeft:SetPoint("BOTTOM", MultiBarBottomRight, "TOP", 0, kActionBarSpacing)
    MultiBarBottomLeft.SetPoint = function() end

    ActionButton1:ClearAllPoints()
    ActionButton1:SetPoint("LEFT", UIParent, "CENTER", -123, -190)
    ActionButton7:ClearAllPoints()
    ActionButton7:SetPoint("TOP", ActionButton1, "BOTTOM", 0, -kActionBarSpacing)

    for i=1, 12 do
        _G["ActionButton"..i]:SetAlpha(.8) -- main bar
    end

    PetActionBarFrame:ClearAllPoints()
    PetActionBarFrame:SetPoint("BOTTOMRIGHT", MultiBarBottomLeft, "TOPRIGHT", 31, kActionBarSpacing)
    PetActionBarFrame:SetScale(0.9)

    StanceButton1:ClearAllPoints()
    StanceButton1:SetPoint("BOTTOMLEFT", MultiBarBottomLeft, "TOPLEFT", 10, kActionBarSpacing+2)
    StanceButton1:SetScale(0.75)

    for i=2, 8 do
        -- _G["StanceButton"..i]:ClearAllPoints()
        -- _G["StanceButton"..i]:SetPoint("BOTTOM", _G["StanceButton"..i-1], "TOP", 0, kActionBarSpacing)
        _G["StanceButton"..i]:SetScale(0.75)
    end
end
-- frame:SetScript("OnUpdate",function(self,event,id)
--     update_actionbars()
-- end)
frame:SetScript("OnEvent",function(self,event,id)
    if(event == "PLAYER_LOGIN") then
        --
        -- Disable Dragon end caps
        --
        MainMenuBarLeftEndCap:Hide()
        MainMenuBarRightEndCap:Hide()

        --
        -- Hide Blizzard stuff
        --
        CharacterMicroButton:ClearAllPoints()
        CharacterMicroButton:SetPoint("RIGHT",145,0)
        MainMenuExpBar:ClearAllPoints()
        MainMenuExpBar:SetPoint("BOTTOMRIGHT", HelpMicroButton, "TOPRIGHT", 0, -39)
        MainMenuExpBar.SetPoint = function() end
        MainMenuExpBar:SetScale(0.5)
        MainMenuBarBackpackButton:SetPoint("BOTTOMRIGHT", MainMenuExpBar, "TOPRIGHT", 0, 5)
        MainMenuBarBackpackButton.SetPoint = function() end

        MainMenuBarTexture0:Hide()
        MainMenuBarTexture1:Hide()
        MainMenuBarTexture2:Hide()
        MainMenuBarTexture3:Hide()

        ActionBarUpButton:Hide()
        ActionBarDownButton:Hide()
        MainMenuBarPageNumber:SetAlpha(0)

        CharacterMicroButton:Hide()
        SpellbookMicroButton:Hide()
        TalentMicroButton:Hide()
        AchievementMicroButton:SetAlpha(0)
        QuestLogMicroButton:Hide()
        GuildMicroButton:Hide()
        PVPMicroButton:Hide()
        LFDMicroButton:Hide()
        CompanionsMicroButton:Hide()
        EJMicroButton:Hide()
        MainMenuMicroButton:Hide()
        HelpMicroButton:SetAlpha(0)
        MainMenuBarBackpackButton:Hide()
        CharacterBag0Slot:Hide()
        CharacterBag1Slot:Hide()
        CharacterBag2Slot:Hide()
        CharacterBag3Slot:Hide()

        MainMenuExpBar:SetStatusBarColor(1,0,0)


        ReputationWatchBar:Hide()
        ReputationWatchBar:SetAlpha(0)
        MainMenuExpBar:Hide()
        MainMenuExpBar:SetAlpha(0)
        MainMenuBarMaxLevelBar:SetAlpha(0) -- hide the xp bar

        update_actionbars()

        --
        -- Turn off keybinds and macro names
        --
        toggle_keybinds()
        toggle_macros()

        --
        -- Resize target and player frames
        --
        PlayerFrame:SetScale(1.2)
        TargetFrame:SetScale(1.2)

        --
        -- Reposition tooltip --
        --
        hooksecurefunc("GameTooltip_SetDefaultAnchor", function(tooltip, parent)
            tooltip:SetOwner(parent, "ANCHOR_NONE")
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
        local function colour(statusbar, unit)
            local _, class, c
            if UnitIsPlayer(unit) and UnitIsConnected(unit) and unit == statusbar.unit and UnitClass(unit) then
                _, class = UnitClass(unit)
                c = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]
                statusbar:SetStatusBarColor(c.r, c.g, c.b)
                PlayerFrameHealthBar:SetStatusBarColor(0,1,0)
            end
        end

        hooksecurefunc("UnitFrameHealthBar_Update", colour)
        hooksecurefunc("HealthBar_OnValueChanged", function(self)
            colour(self, self.unit)
        end)

        --
        -- Move debuffs
        --
        hooksecurefunc("CreateFrame", function(frameType, name, frame, ...)
            local _, playerClass = UnitClass("player")
            if (name ~= "DebuffButton1") then return end

            DebuffButton1:ClearAllPoints()
            if( playerClass == "PALADIN") then
                DebuffButton1:SetPoint("TOPRIGHT", PaladinPowerBar, "BOTTOMRIGHT", 0, 0)
            elseif ( playerClass == "DEATHKNIGHT" ) then
                DebuffButton1:SetPoint("TOPRIGHT", RuneFrame, "BOTTOMRIGHT", 0, -10)
            elseif ( playerClass == "WARLOCK" ) then
                DebuffButton1:SetPoint("TOPRIGHT", PlayerFrame, "BOTTOMRIGHT", 0, 10)
            elseif ( playerClass == "SHAMAN" ) then
                DebuffButton1:SetPoint("TOPRIGHT", TotemFrame, "BOTTOMRIGHT", 0, 0)
            elseif ( playerClass == "HUNTER" or playerClass == "WARLOCK") then
                DebuffButton1:SetPoint("TOPRIGHT", PetFrame, "BOTTOMRIGHT", 9, -7)
            else
                DebuffButton1:SetPoint("TOPRIGHT", PlayerFrame, "BOTTOMRIGHT", 0, 25)
            end
            DebuffButton1.SetPoint = function() end
            DebuffButton1.SetParent = function() end
        end);   

        --
        -- Darken stuff
        --
        if (addon == "Blizzard_TimeManager") then
            for i, v in pairs({PlayerFrameTexture, TargetFrameTextureFrameTexture, PetFrameTexture, PartyMemberFrame1Texture, PartyMemberFrame2Texture, PartyMemberFrame3Texture, PartyMemberFrame4Texture,
                PartyMemberFrame1PetFrameTexture, PartyMemberFrame2PetFrameTexture, PartyMemberFrame3PetFrameTexture, PartyMemberFrame4PetFrameTexture, FocusFrameTextureFrameTexture,
                TargetFrameToTTextureFrameTexture, FocusFrameToTTextureFrameTexture, BonusActionBarFrameTexture0, BonusActionBarFrameTexture1, BonusActionBarFrameTexture2, BonusActionBarFrameTexture3,
                BonusActionBarFrameTexture4, MainMenuBarTexture0, MainMenuBarTexture1, MainMenuBarTexture2, MainMenuBarTexture3, MainMenuMaxLevelBar0, MainMenuMaxLevelBar1, MainMenuMaxLevelBar2,
                MainMenuMaxLevelBar3, MinimapBorder, CastingBarFrameBorder, FocusFrameSpellBarBorder, TargetFrameSpellBarBorder, MiniMapTrackingButtonBorder, MiniMapLFGFrameBorder, MiniMapBattlefieldBorder,
                MiniMapMailBorder, MinimapBorderTop,
                select(1, TimeManagerClockButton:GetRegions())
                }) do
                v:SetVertexColor(.4, .4, .4)
            end

            for i,v in pairs({ select(2, TimeManagerClockButton:GetRegions()) }) do
                v:SetVertexColor(1, 1, 1)
            end
        end

        --
        -- Setup cast bars --
        --
        CastingBarFrame:ClearAllPoints()
        CastingBarFrame:SetPoint("CENTER", UIParent, "CENTER", 0, -270)
        CastingBarFrame:SetHeight(12)
        CastingBarFrame.SetPoint = function() end

        CastingBarFrameBorder:ClearAllPoints()
        CastingBarFrameBorder:SetPoint("TOP", 0, 26)

        CastingBarFrameBorder:SetTexture("Interface\\CastingBar\\UI-CastingBar-Border-Small.blp")
        CastingBarFrameFlash:SetTexture(nil)
        CastingBarFrameSpark:SetTexture(nil)

        CastingBarFrameText:ClearAllPoints()
        CastingBarFrameText:SetPoint("CENTER",0,1)

        TargetFrameSpellBar:ClearAllPoints()
        TargetFrameSpellBar:SetPoint("CENTER", UIParent, "CENTER", 0, 140)
        TargetFrameSpellBar.SetPoint = function() end
        TargetFrameSpellBar:SetScale( 1.5 )

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
        local f = CreateFrame("Button",nil,UIParent)
        f:SetSize(30,30)
        f.t=f:CreateTexture(nil,"BORDER")
        f.t:SetTexture("Interface\\CHATFRAME\\UI-ChatIcon-Maximize-Up.blp")
        f.t:SetAllPoints(f)
        f:SetPoint("BOTTOMRIGHT", UIParent,"BOTTOMRIGHT",0,0)
        f:Show()

        local BlizzHide = true
        f:SetScript("OnMouseDown", function(self, button)
                if BlizzHide  == false then
                        if button == "LeftButton" then
                                f.t:SetTexture("Interface\\CHATFRAME\\UI-ChatIcon-Minimize-Down.blp")
                        end
                elseif BlizzHide == true then
                        if button == "LeftButton" then
                                f.t:SetTexture("Interface\\CHATFRAME\\UI-ChatIcon-Maximize-Down.blp")
                        end
                end
        end)

        f:SetScript("OnMouseUp", function(self, button)
                if BlizzHide  == false then
                        if button == "LeftButton" then
                                f.t:SetTexture("Interface\\CHATFRAME\\UI-ChatIcon-Minimize-Up.blp")
                        end
                elseif BlizzHide == true then
                        if button == "LeftButton" then
                                f.t:SetTexture("Interface\\CHATFRAME\\UI-ChatIcon-Maximize-Up.blp")
                        end
                end
        end)

        f:SetScript("OnClick", function(self, button)
            if BlizzHide == false then
                f.t:SetTexture("Interface\\CHATFRAME\\UI-ChatIcon-Maximize-Up.blp")
                CharacterMicroButton:Hide()
                SpellbookMicroButton:Hide()
                TalentMicroButton:Hide()
                AchievementMicroButton:SetAlpha(0)
                QuestLogMicroButton:Hide()
                GuildMicroButton:Hide()
                PVPMicroButton:Hide()
                LFDMicroButton:Hide()
                CompanionsMicroButton:Hide()
                EJMicroButton:Hide()
                MainMenuMicroButton:Hide()
                HelpMicroButton:SetAlpha(0)
                HelpMicroButton:Hide()
                MainMenuBarBackpackButton:Hide()
                CharacterBag0Slot:Hide()
                CharacterBag1Slot:Hide()
                CharacterBag2Slot:Hide()
                CharacterBag3Slot:Hide()
                MainMenuExpBar:Hide()
                MainMenuExpBar:SetAlpha(0)
                -- ReputationWatchBar:Hide()
                -- ReputationWatchBar:SetAlpha(0)
                BlizzHide = true
            elseif BlizzHide == true then
                f.t:SetTexture("Interface\\CHATFRAME\\UI-ChatIcon-Minimize-Up.blp")
                CharacterMicroButton:Show()
                SpellbookMicroButton:Show()
                TalentMicroButton:Show()
                AchievementMicroButton:SetAlpha(1)
                QuestLogMicroButton:Show()
                GuildMicroButton:Show()
                PVPMicroButton:Show()
                LFDMicroButton:Show()
                CompanionsMicroButton:Show()
                EJMicroButton:Show()
                MainMenuMicroButton:Show()
                HelpMicroButton:SetAlpha(1)
                HelpMicroButton:Show()
                MainMenuBarBackpackButton:Show()
                CharacterBag0Slot:Show()
                CharacterBag1Slot:Show()
                CharacterBag2Slot:Show()
                CharacterBag3Slot:Show()
                MainMenuExpBar:Show()
                MainMenuExpBar:SetAlpha(1)
                -- ReputationWatchBar:Show()
                -- ReputationWatchBar:SetAlpha(1)
                BlizzHide = false
            end
        end)

    elseif( event == "GROUP_ROSTER_UPDATE" or
        event == "PLAYER_TARGET_CHANGED" or
        event == "PLAYER_FOCUS_CHANGED" or
        event == "UNIT_FACTION") then
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
    ChatFrame_AddMessageGroup( ChatFrame5, "BATTLEGROUND" );
    ChatFrame_AddMessageGroup( ChatFrame5, "BATTLEGROUND_LEADER" );
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
    ToggleChatColorNamesByClassGroup(true, "INSTANCE")
    ToggleChatColorNamesByClassGroup(true, "INSTANCE_LEADER")
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
