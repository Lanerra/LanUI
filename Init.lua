local Addon, Engine = ...

Engine[1] = {} -- F, functions, constants, variables
Engine[2] = {} -- C, config
Engine[3] = {} -- G, globals (Optionnal)

_G[Addon] = Engine -- Allow other addons to use Engine

--[[ Add this to the top to import settings. Also lets other addons
     use our stuff.
        For files inside this addon: local F, C, G = unpack(select(2, ...))
        For other addons: local F, C, G = unpack(LanUI)
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

local TrueScale = (768/string.match(({GetScreenResolutions()})[GetCurrentResolution()], "%d+x(%d+)"))
F.TrueScale = TrueScale

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
    ChatFrame1:AddMessage('Special thanks to Neav, Bellagarba, Phanx, Tekkub, Elv, p3lim, Tukz, Haste, Haleth, and Roth. Without them I would not have had the inspiration or insight to be able to make this UI')
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

SlashCmdList.TEST_EXTRABUTTON = function()
    if ExtraActionBarFrame:IsShown() then
        ExtraActionBarFrame:Hide()
    else
        ExtraActionBarFrame:Show()
        ExtraActionBarFrame:SetAlpha(1)
        ExtraActionButton1:Show()
        ExtraActionButton1:SetAlpha(1)
        ExtraActionButton1.icon:SetTexture("Interface\\Icons\\INV_Pet_DiseasedSquirrel")
        ExtraActionButton1.icon:Show()
        ExtraActionButton1.icon:SetAlpha(1)
    end
end
SLASH_TEST_EXTRABUTTON1 = "/teb"

local p = PlayerPowerBarAlt
local a = CreateFrame("Frame", nil, UIParent)
p:SetSize(100, 20)
a:SetSize(100, 20)
a:SetPoint("TOP", p, "TOP", 0, 2.5)
a:EnableMouse(true)
p:SetMovable(true)
p:SetUserPlaced(true)
a:SetScript("OnMouseDown", function() p:StartMoving() end)
a:SetScript("OnMouseUp", function() p:StopMovingOrSizing() end)
a.t = a:CreateTexture()
a.t:SetAllPoints()
a.t:SetTexture(1,1,1)
a.t:SetAlpha(0.3)
a:Hide()
SlashCmdList["MOVEPOWERBAR"] = function()
    if a:IsShown() then
        a:Hide()
    else
        a:Show()
    end
end
SLASH_MOVEPOWERBAR1 = "/mpb"

SlashCmdList.TEST_OVERRIDE = function()
    if OverrideActionBar:IsShown() then
        OverrideActionBar:Hide()
    else
        OverrideActionBar:Show()
        OverrideActionBar:SetAlpha(1)
        
        for i = 1, 6 do
            local Override = _G['OverrideActionBarButton'..i]
            Override:Show()
            Override:SetAlpha(1)
            Override.icon:SetTexture("Interface\\Icons\\INV_Pet_DiseasedSquirrel")
            Override.icon:Show()
            Override.icon:SetAlpha(1)
        end
    end
end
SLASH_TEST_OVERRIDE1 = "/tob"

SlashCmdList.TEST_ACHIEVEMENT = function()
    PlaySound("LFG_Rewards")
    if not AchievementFrame then
        AchievementFrame_LoadUI()
    end
    
    AchievementAlertFrame_ShowAlert(8399)
    AchievementAlertFrame_ShowAlert(8401)
    GuildChallengeAlertFrame_ShowAlert(3, 2, 5)
    CriteriaAlertFrame_ShowAlert(6301, 29918)
    MoneyWonAlertFrame_ShowAlert(9999999)
    LootWonAlertFrame_ShowAlert(GetItemInfo(6948), -1, 1, 100)
    ChallengeModeAlertFrame_ShowAlert()
    AlertFrame_AnimateIn(ScenarioAlertFrame1)
    AlertFrame_FixAnchors()
end

SLASH_TEST_ACHIEVEMENT1 = "/tach"

SlashCmdList.SPOOF = function()
    PlaySound("LFG_Rewards")
    if not AchievementFrame then
        AchievementFrame_LoadUI()
    end
    
    AchievementAlertFrame_ShowAlert(8399)
    AchievementAlertFrame_ShowAlert(8401)
end

SLASH_SPOOF1 = '/spoof'

SlashCmdList['GM'] = function()
    ToggleHelpFrame() 
end

SLASH_GM1 = '/gm'
SLASH_GM2 = '/ticket'
SLASH_GM3 = '/gamemaster'