local Addon, Engine = ...
Engine[1] = {} -- F, functions, constants, variables
Engine[2] = {} -- C, config
Engine[3] = {} -- G, globals (Optionnal)

LanUI = Engine -- Allow other addons to use Engine

--[[ Add this to the top to import settings. Also lets other addons
     use our stuff.
        local F, C, G = unpack(select(2, ...))
]]

local F, C, G = unpack(select(2, ...))

    -- Functions, constants, and variables
F.Dummy = function() return end
F.MyName = select(1, UnitName('player'))
F.MyClass = select(2, UnitClass('player'))
F.PlayerColor = RAID_CLASS_COLORS[F.MyClass]
F.MyRace = select(2, UnitRace('player'))
F.MyFaction = UnitFactionGroup('player')
F.Client = GetLocale() 
F.Resolution = GetCVar('gxResolution')
F.ScreenHeight = tonumber(string.match(F.Resolution, '%d+x(%d+)'))
F.ScreenWidth = tonumber(string.match(F.Resolution, '(%d+)x+%d'))
F.Version = GetAddOnMetadata('LanUI', 'Version')
F.VersionNumber = tonumber(F.Version)
F.InCombat = UnitAffectingCombat('player')
F.Patch, F.BuildText, F.ReleaseDate, F.TOC = GetBuildInfo()
F.Build = tonumber(F.BuildText)
F.Level = UnitLevel('player')
F.MyRealm = GetRealmName()

F.Scales = {
    ['720'] = { ['576'] = 0.65},
    ['800'] = { ['600'] = 0.7},
    ['960'] = { ['600'] = 0.84},
    ['1024'] = { ['600'] = 0.89, ['768'] = 0.7},
    ['1152'] = { ['864'] = 0.7},
    ['1176'] = { ['664'] = 0.93},
    ['1280'] = { ['800'] = 0.84, ['720'] = 0.93, ['768'] = 0.87, ['960'] = 0.7, ['1024'] = 0.65},
    ['1360'] = { ['768'] = 0.93},
    ['1366'] = { ['768'] = 0.93},
    ['1440'] = { ['900'] = 0.84},
    ['1600'] = { ['1200'] = 0.7, ['1024'] = 0.82, ['900'] = 0.93},
    ['1680'] = { ['1050'] = 0.84},
    ['1768'] = { ['992'] = 0.93},
    ['1920'] = { ['1440'] = 0.7, ['1200'] = 0.84, ['1080'] = 0.93},
    ['2048'] = { ['1536'] = 0.7},
    ['2560'] = { ['1600'] = 0.64},
}

    -- Tables
C.ActionBars = {}  
C.Minimap = {}
C.Media = {}
C.Panels = {}
C.Tooltip = {}
C.Tweaks = {}
C.Chat = {}
C.Buff = {}
C.FontSize = {}
C.Buffs = {}

    -- Modules
G.ActionBars = {}
G.Bags = {}
G.Auras = {}
G.Chat = {}
G.DataText = {}
G.Loot = {}
G.Maps = {}
G.Misc = {}
G.NamePlates = {}
G.Panels = {}
G.Skins = {}
G.Tooltips = {}
G.UnitFrames = {}
G.Install = {}

-- Hider
local UIHider = CreateFrame('Frame', 'LanUIHider', UIParent)
UIHider:Hide()
G.Misc.UIHider = UIHider

-- Hider Secure (mostly used to hide stuff while in pet battle)
local PetBattleHider = CreateFrame('Frame', 'LanUIPetBattleHider', UIParent, 'SecureHandlerStateTemplate');
PetBattleHider:SetAllPoints(UIParent)
RegisterStateDriver(PetBattleHider, 'visibility', '[petbattle] hide; show')

-- Where it's due...
SLASH_CREDITS1 = '/credits'
SlashCmdList['CREDITS'] = function()
    ChatFrame1:AddMessage('Special thanks to Neav, Bellagarba, Phanx, Tekkub, Elv, p3lim, Tukz, Haste, Haleth, and Roth. Without him I would not have had the inspiration or insight to be able to make this UI')
end

-- Easy ReloadUI
SLASH_RELOADUI1 = '/rl'
SlashCmdList['RELOADUI'] = ReloadUI

-- Get frame info of mouse focus
SLASH_FRAME1 = '/frame'
SlashCmdList['FRAME'] = function(arg)
	if arg ~= '' then
		arg = _G[arg]
	else
		arg = GetMouseFocus()
	end
	if arg ~= nil and arg:GetName() ~= nil then
		local point, relativeTo, relativePoint, xOfs, yOfs = arg:GetPoint()
		ChatFrame1:AddMessage('|cffCC0000----------------------------')
		ChatFrame1:AddMessage('Name: |cffFFD100'..arg:GetName())
		if arg:GetParent() and arg:GetParent():GetName() then
			ChatFrame1:AddMessage('Parent: |cffFFD100'..arg:GetParent():GetName())
		end
 
		ChatFrame1:AddMessage('Width: |cffFFD100'..format('%.2f',arg:GetWidth()))
		ChatFrame1:AddMessage('Height: |cffFFD100'..format('%.2f',arg:GetHeight()))
		ChatFrame1:AddMessage('Strata: |cffFFD100'..arg:GetFrameStrata())
		ChatFrame1:AddMessage('Level: |cffFFD100'..arg:GetFrameLevel())
 
		if xOfs then
			ChatFrame1:AddMessage('X: |cffFFD100'..format('%.2f',xOfs))
		end
		if yOfs then
			ChatFrame1:AddMessage('Y: |cffFFD100'..format('%.2f',yOfs))
		end
		if relativeTo and relativeTo:GetName() then
			ChatFrame1:AddMessage('Point: |cffFFD100'..point..'|r anchored to '..relativeTo:GetName().."'s |cffFFD100"..relativePoint)
		end
		ChatFrame1:AddMessage('|cffCC0000----------------------------')
	elseif arg == nil then
		ChatFrame1:AddMessage('Invalid frame name')
	else
		ChatFrame1:AddMessage('Could not find frame info')
	end
end

-- List child frames of mouse focus
SlashCmdList['CHILDFRAMES'] = function() 
	for k,v in pairs({GetMouseFocus():GetChildren()}) do
		print(v:GetName(),'-',v:GetObjectType())
	end 
end
SLASH_CHILDFRAMES1 = '/child'

-- Raid Faker
SlashCmdList['RAIDFAKER'] = function()
    local RAIDMEMBER = 25;

    local allClasses = { 'WARRIOR', 'ROGUE', 'PRIEST', 'SHAMAN', 'DEATHKNIGHT', 'HUNTER', 'PALADIN', 'MAGE', 'WARLOCK', 'DRUID' };
    local simParty = {};
    for i=1, 4, 1 do
        simParty[i] = {};
        simParty[i].class = allClasses[math.floor(math.random()*10)+1]
        simParty[i].name = 'Party #'..i;
        simParty['party'..i] = simParty[i];
    end
    for i=1, (RAIDMEMBER-1), 1 do
        simParty[i] = {};
        simParty[i].class = allClasses[math.floor(math.random()*10)+1];
        simParty[i].name = 'Raid #'..i;
        simParty[i].subGroup = math.floor((i-1)/5)+1;
        simParty['raid'..i] = simParty[i];
    end

    local OriginalUnitClass = UnitClass
    function UnitClass(unit)
        if ( unit == 'raid'..RAIDMEMBER ) then
            return OriginalUnitClass('player');
        elseif ( simParty[unit] ) then
            return simParty[unit].class, simParty[unit].class;
        end
        return OriginalUnitClass(unit);
    end

    local OriginalUnitName = UnitName
    function UnitName(unit)
        if ( unit == 'raid'..RAIDMEMBER ) then
            return OriginalUnitName('player');
        elseif ( simParty[unit] ) then
            return simParty[unit].name;
        end
        return OriginalUnitName(unit);
    end

    local OriginalUnitIsUnit = UnitIsUnit
    function UnitIsUnit(u1,u2)
        if ( ( u1 == 'raid'..RAIDMEMBER and u2 == 'player' ) or ( u1 == 'player' and u2 == 'raid'..RAIDMEMBER ) ) then
            return true;
        end
        return OriginalUnitIsUnit(u1, u2);
    end

    local OriginalUnitHealth = UnitHealth
    function UnitHealth(unit)
        if ( unit == 'raid'..RAIDMEMBER ) then
            return OriginalUnitHealth('player');
        elseif ( simParty[unit] ) then
            return simParty[unit].health;
        end
        return OriginalUnitHealth(unit);
    end

    local OriginalUnitHealthMax = UnitHealthMax
    function UnitHealthMax(unit)
        if ( unit == 'raid'..RAIDMEMBER ) then
            return OriginalUnitHealthMax('player');
        elseif ( simParty[unit] ) then
            return simParty[unit].maxhealth;
        end
        return OriginalUnitHealthMax(unit);
    end

    local OriginalUnitPower = UnitPower
    function UnitPower(unit, type)
        if ( unit == 'raid'..RAIDMEMBER ) then
            return OriginalUnitPower('player', type);
        elseif ( simParty[unit] ) then
            return simParty[unit].power, 0;
        end
        return OriginalUnitPower(unit, type);
    end

    local OriginalUnitPowerMax = UnitPowerMax
    function UnitPowerMax(unit, type)
        if ( unit == 'raid'..RAIDMEMBER ) then
            return OriginalUnitPowerMax('player', type);
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
            local _,cls=UnitClass('player')
            return UnitName('player'), 2, (math.floor((RAIDMEMBER-1)/5)+1), 80, cls, cls, '', true, false, nil, nil;
        elseif ( simParty[unit] ) then
            return simParty[unit].name, 0, simParty[unit].subGroup, 80, simParty[unit].class, simParty[unit].class, '', true, false, nil, nil;
        end
        return nil;
    end
end
SLASH_RAIDFAKER1 = '/faker'
