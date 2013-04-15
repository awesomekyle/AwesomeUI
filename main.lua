-- Set up frame to run on login
local frame = CreateFrame("Frame");
frame:RegisterEvent("PLAYER_LOGIN")

frame:SetScript("OnEvent",function(self,event,id)
    if(event == "PLAYER_LOGIN") then
        --
        -- Disable Dragon end caps
        --
        MainMenuBarLeftEndCap:Hide()
        MainMenuBarRightEndCap:Hide()

        --
        -- Reposition tooltip --
        --
        hooksecurefunc("GameTooltip_SetDefaultAnchor", function(tooltip, parent)
            tooltip:SetOwner(parent, "ANCHOR_NONE")
            tooltip:SetPoint("BOTTOMLEFT", "UIParent", "CENTER", 300,-100)
            tooltip.default = 1
        end);

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
            elseif ( playerClass == "MONK") then
                DebuffButton1:SetPoint("TOPRIGHT", PlayerFrame, "BOTTOMRIGHT", 0, -6)
            elseif ( playerClass == "HUNTER" or playerClass == "WARLOCK") then
                DebuffButton1:SetPoint("TOPRIGHT", PetFrame, "BOTTOMRIGHT", 9, -7)
            else
                DebuffButton1:SetPoint("TOPRIGHT", PlayerFrame, "BOTTOMRIGHT", 0, 25)
            end
            print(playerClass);
            DebuffButton1.SetPoint = function() end
            DebuffButton1.SetParent = function() end
        end);

        --
        -- Setup cast bars --
        --
        CastingBarFrame:ClearAllPoints()
        CastingBarFrame:SetPoint("CENTER", UIParent, "CENTER", 0, -200)
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
        TargetFrameSpellBar:SetPoint("CENTER", UIParent, "CENTER", 0, 160)
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
