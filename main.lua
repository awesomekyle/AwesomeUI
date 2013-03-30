-- Set up frame to run on login
local frame = CreateFrame("Frame");
frame:RegisterEvent("PLAYER_LOGIN")

frame:SetScript("OnEvent",function(self,event,id)
    if(event == "PLAYER_LOGIN") then
        -- Disable Dragon end caps
        MainMenuBarLeftEndCap:Hide()
        MainMenuBarRightEndCap:Hide()
    end
end)

--
-- Slash commands
--
SLASH_RL1 = "/rl";
SlashCmdList["RL"] = function() ReloadUI() end
