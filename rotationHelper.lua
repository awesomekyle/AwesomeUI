local _, playerClass = UnitClass("player")

local function getCooldown(spell)
    local slot = spell.slot
    local start, cooldown = GetActionCooldown(slot)
    if start == 0 then
        return 0
    end

    local cooldownRemaining = cooldown - (GetTime() - start)
    return cooldownRemaining
end

local function isUsable(spell)
    local slot = spell.slot
    if slot == 0 then
        return false
    end
    local usable, noMana = IsUsableAction(slot)
    -- if not IsUsableAction(slot) then
    --     return false
    -- end

    local timeTilNextAction = 0.125
    local cooldownRemaining = getCooldown(spell)
    local name, text, texture, startTimeMS, endTimeMS = UnitCastingInfo("player")
    if name and (GetTime() + cooldownRemaining) < (endTimeMS / 1000) then
        return true
    end
    return cooldownRemaining < timeTilNextAction
end

if playerClass == "HUNTER" and false then
    print("Creating rotation helper")
    local forSpec = "Marksmanship"

    local f = CreateFrame("Frame")
    f.spells = {}

    f:SetScript("OnEvent",function(self,event,...)
        if self[event] then
            self[event](self,...)
        end
    end)

    function f:UNIT_HEALTH(...)
        local low = (UnitHealth("player")/UnitHealthMax("player")) < 0.35
        if low and not self.low then
            ActionButton_ShowOverlayGlow(button)
            self.low = true
        elseif not low and self.low then
            ActionButton_HideOverlayGlow(button)
            self.low = nil
        end
    end

    function f:OnUpdate(...)
        -- turn off glows
        for _, spell in pairs(self.spells) do
            spell:finish()
        end

        if not UnitExists("target") then
            -- no target, dont do anything
            return
        end
        if UnitIsFriend("player", "target") then
            -- friendly target, dont do anything
            return
        end

        local targetHealth = UnitHealth("target")

        local aimedShot = self.spells["Aimed Shot"]
        local rapidFire = self.spells["Rapid Fire"]
        local doubleTap = self.spells["Double Tap"]
        local arcaneShot = self.spells["Arcane Shot"]
        local steadyShot = self.spells["Steady Shot"]

        local preciseShots = AuraUtil.FindAuraByName("Precise Shots", "player", "HELPFUL") ~= nil

        local doubleTapSpender = nil
        if (targetHealth > 81 or targetHealth < 20) then
            doubleTapSpender = aimedShot
        else
            doubleTapSpender = rapidFire
        end

        if isUsable(self.spells["Hunter's Mark"]) and (AuraUtil.FindAuraByName("Hunter's Mark", "target", "HARMFUL|PLAYER") == nil) then
            self.spells["Hunter's Mark"]:setGlow()
        elseif AuraUtil.FindAuraByName("Double Tap", "player", "HELPFUL") ~= nil then
            doubleTapSpender:setGlow()
        elseif isUsable(doubleTap) and (getCooldown(doubleTapSpender) < 3) and (UnitPower("player") < 50) then
            doubleTap:setGlow()
        elseif isUsable(doubleTap) and (getCooldown(doubleTapSpender) < 3) and (UnitPower("player") > 30) then
            doubleTap:setGlow()
        elseif isUsable(aimedShot) and not preciseShots then
            aimedShot:setGlow()
        elseif isUsable(rapidFire) then
            rapidFire:setGlow()
        elseif (isUsable(arcaneShot) and preciseShots) or UnitPower("player") > 40 then
            arcaneShot:setGlow()
        else
            steadyShot:setGlow()
        end
    end

    function f:PLAYER_SPECIALIZATION_CHANGED(...)
        local spec = GetSpecialization()
        local _,specName = GetSpecializationInfo(spec)
        print("new spec: "..specName)

        local spells = {
            "Aimed Shot",
            "Rapid Fire",
            "Arcane Shot",
            "Steady Shot",
            "Hunter's Mark",
            "Double Tap",
        }

        for _, spellName in ipairs(spells) do
            local name, _, icon, castTime, minRange, maxRange, spellId = GetSpellInfo(spellName)
            if name ~= nil then
                local slots = C_ActionBar.FindSpellActionButtons(spellId)
                print("found "..name.." in slot "..slots[1])
                f.spells[spellName] = {
                    ["name"] = name,
                    ["slot"] = slots[1],
                    ["actionButton"] = _G["ActionButton"..slots[1]],
                    ["lastGlow"] = false,
                    ["glow"] = false,
                    ["setGlow"] = function(self)
                        if self.lastGlow == false then
                            ActionButton_ShowOverlayGlow(self.actionButton)
                        end
                        self.glow = true
                    end,
                    ["finish"] = function(self)
                        if self.glow == false and self.lastGlow == true then
                            ActionButton_HideOverlayGlow(self.actionButton)
                        end
                        self.lastGlow = self.glow
                        self.glow = false
                    end,
                }
            else
                f.spells[spellName] = {
                    ["slot"] = 0,
                    ["finish"] = function() end,
                }
            end
        end

        if specName==forSpec then
            f:SetScript("OnUpdate", self.OnUpdate )
        else
            f:SetScript("OnUpdate", function() end )
        end
    end

    f.PLAYER_LOGIN = f.PLAYER_SPECIALIZATION_CHANGED
    f:RegisterEvent("PLAYER_LOGIN")
    f:RegisterUnitEvent("PLAYER_SPECIALIZATION_CHANGED","player")
end
