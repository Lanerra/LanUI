local F, C, G = unpack(select(2, ...))

-- Auto-DE/Greed
if C.Tweaks.AutoDEGreed == true then
    local f = CreateFrame('Frame', nil, UIParent)
     
    f:RegisterEvent('START_LOOT_ROLL')
    f:SetScript('OnEvent', function(_, _, id)
        if ((UnitLevel('player') < 90)) then
            return
        else
            if not id then return end -- What the fuck?
            local _, Name, _, Quality, BoP, _, _, CanDE = GetLootRollItemInfo(id)
            if (Quality == 2 or 3 and BoP) then
                RollOnLoot(id, CanDE and 3 or 2)
            elseif (Quality == 2 and not BoP) then
                RollOnLoot(id, CanDE and 3 or 2)
            elseif (Quality == 4) then
                return
            end
        end
    end)

    local f = CreateFrame('Frame')
    f:RegisterEvent('CONFIRM_DISENCHANT_ROLL')
    f:SetScript('OnEvent', function(self, event, id, rollType) ConfirmLootRoll(id, rollType) end)

    StaticPopupDialogs['LOOT_BIND'].OnCancel = function(self, slot)
        if GetNumPartyMembers() == 0 and GetNumRaidMembers() == 0 then ConfirmLootSlot(slot) end
    end
end

TicketStatusFrame:ClearAllPoints()
TicketStatusFrame:SetPoint('BOTTOMRIGHT', UIParent, 0, 0)

-- Custodial Stuff :P
local eventCount = 0
local LanJanitor = CreateFrame("Frame")
LanJanitor:RegisterAllEvents()
LanJanitor:SetScript("OnEvent", function(self, event)
    eventCount = eventCount + 1
    if InCombatLockdown() then return end

    if eventCount > 10000 then
        collectgarbage("collect")
        eventCount = 0        
    end
end)

local sh = UIParent:CreateTexture(nil, 'BACKGROUND')
sh:SetAllPoints(UIParent)
sh:SetTexture(0, 0, 0)
sh:Hide()

hooksecurefunc(GameMenuFrame, 'Show', function()
    sh:SetAlpha(0)
    securecall('UIFrameFadeIn', sh, 0.235, sh:GetAlpha(), 0.5)
end)

hooksecurefunc(GameMenuFrame, 'Hide', function()
    securecall('UIFrameFadeOut', sh, 0.235, sh:GetAlpha(), 0)
end)