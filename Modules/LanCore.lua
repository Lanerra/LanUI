-- Auto-DE/Greed
if LanConfig.Tweaks.AutoDEGreed == true then
    local f = CreateFrame('Frame', nil, UIParent)
     
    f:RegisterEvent('START_LOOT_ROLL')
    f:SetScript('OnEvent', function(_, _, id)
        if ((UnitLevel('player') < 85)) then
            return
        else
            if not id then return end -- What the fuck?
            local _, _, _, quality, bop, _, _, canDE = GetLootRollItemInfo(id)
            if (quality == 2 or 3 and bop) then
                RollOnLoot(id, canDE and 3 or 2)
            elseif (quality == 2 and not bop) then
                RollOnLoot(id, canDE and 3 or 2)
            elseif (quality == 4) then
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

WorldMapShowDigSites:HookScript('OnShow', function(self) self:Hide() end)

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

-- Get frame info of mouse focus
SLASH_FRAME1 = "/frame"
SlashCmdList["FRAME"] = function(arg)
	if arg ~= "" then
		arg = _G[arg]
	else
		arg = GetMouseFocus()
	end
	if arg ~= nil and arg:GetName() ~= nil then
		local point, relativeTo, relativePoint, xOfs, yOfs = arg:GetPoint()
		ChatFrame1:AddMessage("|cffCC0000----------------------------")
		ChatFrame1:AddMessage("Name: |cffFFD100"..arg:GetName())
		if arg:GetParent() and arg:GetParent():GetName() then
			ChatFrame1:AddMessage("Parent: |cffFFD100"..arg:GetParent():GetName())
		end
 
		ChatFrame1:AddMessage("Width: |cffFFD100"..format("%.2f",arg:GetWidth()))
		ChatFrame1:AddMessage("Height: |cffFFD100"..format("%.2f",arg:GetHeight()))
		ChatFrame1:AddMessage("Strata: |cffFFD100"..arg:GetFrameStrata())
		ChatFrame1:AddMessage("Level: |cffFFD100"..arg:GetFrameLevel())
 
		if xOfs then
			ChatFrame1:AddMessage("X: |cffFFD100"..format("%.2f",xOfs))
		end
		if yOfs then
			ChatFrame1:AddMessage("Y: |cffFFD100"..format("%.2f",yOfs))
		end
		if relativeTo and relativeTo:GetName() then
			ChatFrame1:AddMessage("Point: |cffFFD100"..point.."|r anchored to "..relativeTo:GetName().."'s |cffFFD100"..relativePoint)
		end
		ChatFrame1:AddMessage("|cffCC0000----------------------------")
	elseif arg == nil then
		ChatFrame1:AddMessage("Invalid frame name")
	else
		ChatFrame1:AddMessage("Could not find frame info")
	end
end

--  ReloadUI
SlashCmdList['RELOAD_UI'] = function() ReloadUI() end
SLASH_RELOAD_UI1 = '/rl'

--  Command to fix the Combat Log if it breaks
local function CLFIX()
	CombatLogClearEntries()
end
SLASH_CLFIX1 = "/clfix"
SlashCmdList["CLFIX"] = CLFIX

-- List child frames of mouse focus
SlashCmdList["CHILDFRAMES"] = function() 
	for k,v in pairs({GetMouseFocus():GetChildren()}) do
		print(v:GetName(),'-',v:GetObjectType())
	end 
end
SLASH_CHILDFRAMES1 = "/child"

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