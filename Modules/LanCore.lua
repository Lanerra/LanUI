-- Auto-DE/Greed
if LanConfig.Tweaks.AutoDEGreed == true then
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

-- Raid Faker
SlashCmdList['RAIDFAKER'] = function()
    local RAIDMEMBER = 25;

    local allClasses = { "WARRIOR", "ROGUE", "PRIEST", "SHAMAN", "DEATHKNIGHT", "HUNTER", "PALADIN", "MAGE", "WARLOCK", "DRUID" };
    local simParty = {};
    for i=1, 4, 1 do
        simParty[i] = {};
        simParty[i].class = allClasses[math.floor(math.random()*10)+1]
        simParty[i].name = "Party #"..i;
        simParty["party"..i] = simParty[i];
    end
    for i=1, (RAIDMEMBER-1), 1 do
        simParty[i] = {};
        simParty[i].class = allClasses[math.floor(math.random()*10)+1];
        simParty[i].name = "Raid #"..i;
        simParty[i].subGroup = math.floor((i-1)/5)+1;
        simParty["raid"..i] = simParty[i];
    end

    local OriginalUnitClass = UnitClass
    function UnitClass(unit)
        if ( unit == "raid"..RAIDMEMBER ) then
            return OriginalUnitClass("player");
        elseif ( simParty[unit] ) then
            return simParty[unit].class, simParty[unit].class;
        end
        return OriginalUnitClass(unit);
    end

    local OriginalUnitName = UnitName
    function UnitName(unit)
        if ( unit == "raid"..RAIDMEMBER ) then
            return OriginalUnitName("player");
        elseif ( simParty[unit] ) then
            return simParty[unit].name;
        end
        return OriginalUnitName(unit);
    end

    local OriginalUnitIsUnit = UnitIsUnit
    function UnitIsUnit(u1,u2)
        if ( ( u1 == "raid"..RAIDMEMBER and u2 == "player" ) or ( u1 == "player" and u2 == "raid"..RAIDMEMBER ) ) then
            return true;
        end
        return OriginalUnitIsUnit(u1, u2);
    end

    local OriginalUnitHealth = UnitHealth
    function UnitHealth(unit)
        if ( unit == "raid"..RAIDMEMBER ) then
            return OriginalUnitHealth("player");
        elseif ( simParty[unit] ) then
            return simParty[unit].health;
        end
        return OriginalUnitHealth(unit);
    end

    local OriginalUnitHealthMax = UnitHealthMax
    function UnitHealthMax(unit)
        if ( unit == "raid"..RAIDMEMBER ) then
            return OriginalUnitHealthMax("player");
        elseif ( simParty[unit] ) then
            return simParty[unit].maxhealth;
        end
        return OriginalUnitHealthMax(unit);
    end

    local OriginalUnitPower = UnitPower
    function UnitPower(unit, type)
        if ( unit == "raid"..RAIDMEMBER ) then
            return OriginalUnitPower("player", type);
        elseif ( simParty[unit] ) then
            return simParty[unit].power, 0;
        end
        return OriginalUnitPower(unit, type);
    end

    local OriginalUnitPowerMax = UnitPowerMax
    function UnitPowerMax(unit, type)
        if ( unit == "raid"..RAIDMEMBER ) then
            return OriginalUnitPowerMax("player", type);
        elseif ( simParty[unit] ) then
            return simParty[unit].maxpower, 0;
        end
        return OriginalUnitPowerMax(unit, type);
    end
    UnitMana = UnitPower;
    UnitManaMax = UnitPowerMax;

    function GetNumRaidMembers()
        return RAIDMEMBER;
    end

    function IsRaidLeader()
        return true;
    end

    function GetRaidRosterInfo(unit)
        if ( unit == RAIDMEMBER ) then
            local _,cls=UnitClass("player")
            return UnitName("player"), 2, (math.floor((RAIDMEMBER-1)/5)+1), 80, cls, cls, "", true, false, nil, nil;
        elseif ( simParty[unit] ) then
            return simParty[unit].name, 0, simParty[unit].subGroup, 80, simParty[unit].class, simParty[unit].class, "", true, false, nil, nil;
        end
        return nil;
    end
end
SLASH_RAIDFAKER1 = "/faker"