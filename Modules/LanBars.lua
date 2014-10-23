local F, C, G = unpack(select(2, ...))

local _G = _G
local IsUsableAction = IsUsableAction
local IsActionInRange = IsActionInRange
local HasAction = HasAction

-- Kill Blizzard options for ActionBars
--[[InterfaceOptionsActionBarsPanelBottomLeft:Kill()
InterfaceOptionsActionBarsPanelBottomRight:Kill()
InterfaceOptionsActionBarsPanelRight:Kill()
InterfaceOptionsActionBarsPanelRightTwo:Kill()
InterfaceOptionsActionBarsPanelAlwaysShowActionBars:Kill()]]

-- Kill micromenu
CharacterMicroButton:SetScale(0.0001)
CharacterMicroButton:EnableMouse(false)
SpellbookMicroButton:SetScale(0.0001)
SpellbookMicroButton:EnableMouse(false)
TalentMicroButton:SetScale(0.0001)
TalentMicroButton:EnableMouse(false)
AchievementMicroButton:SetScale(0.0001)
AchievementMicroButton:EnableMouse(false)
QuestLogMicroButton:SetScale(0.0001)
QuestLogMicroButton:EnableMouse(false)
GuildMicroButton:SetScale(0.0001)
GuildMicroButton:EnableMouse(false)
LFDMicroButton:SetScale(0.0001)
LFDMicroButton:EnableMouse(false)
EJMicroButton:SetScale(0.0001)
EJMicroButton:EnableMouse(false)
MainMenuMicroButton:SetScale(0.0001)
MainMenuMicroButton:EnableMouse(false)
HelpMicroButton:SetScale(0.0001)
HelpMicroButton:EnableMouse(false)
CompanionsMicroButton:SetScale(0.0001)
CompanionsMicroButton:EnableMouse(false)
StoreMicroButton:SetScale(0.0001)
StoreMicroButton:EnableMouse(false)

-- Hide macro text
if not C.ActionBars.Macro then
	for i=1, 12 do
		_G['ActionButton'..i..'Name']:SetAlpha(0) -- main bar
		_G['MultiBarBottomRightButton'..i..'Name']:SetAlpha(0) -- bottom right bar
		_G['MultiBarBottomLeftButton'..i..'Name']:SetAlpha(0) -- bottom left bar
		_G['MultiBarRightButton'..i..'Name']:SetAlpha(0) -- right bar
		_G['MultiBarLeftButton'..i..'Name']:SetAlpha(0) -- left bar
	end
end

-- Hide hotkey
if not C.ActionBars.Hotkey then
	for i=1, 12 do
		_G['ActionButton'..i..'HotKey']:SetAlpha(0) -- main bar
		_G['MultiBarBottomRightButton'..i..'HotKey']:SetAlpha(0) -- bottom right bar
		_G['MultiBarBottomLeftButton'..i..'HotKey']:SetAlpha(0) -- bottom left bar
		_G['MultiBarRightButton'..i..'HotKey']:SetAlpha(0) -- right bar
		_G['MultiBarLeftButton'..i..'HotKey']:SetAlpha(0) -- left bar
	end
end

-- Meat and Potatoes
local num = NUM_ACTIONBAR_BUTTONS
local buttonList = {}

-- Bar 1
local frame = CreateFrame('Frame', 'LanBar1', UIParent, 'SecureHandlerStateTemplate')
frame:SetWidth(num * C.ActionBars.ButtonSize + (num - 1) * C.ActionBars.ButtonSpacing + 2 * C.ActionBars.ButtonSpacing)
frame:SetHeight(C.ActionBars.ButtonSize + 2 * C.ActionBars.ButtonSpacing)

if C.Panels.ABPanel then
    frame:SetPoint('TOPLEFT', ABPanel, 2, -2)
else
    frame:SetPoint('BOTTOM', UIParent, 0, 200)
end

frame:SetScale(1)

MainMenuBarArtFrame:SetParent(frame)
MainMenuBarArtFrame:EnableMouse(false)

for i = 1, num do
	local button = _G['ActionButton'..i]
	table.insert(buttonList, button)
	button:SetSize(C.ActionBars.ButtonSize, C.ActionBars.ButtonSize)
	button:ClearAllPoints()
    
	if not button.skinned then
		button:SetTemplate(true)
        button:SetBeautyBorderPadding(2)
	end
    
	if i == 1 then
		button:SetPoint('BOTTOMLEFT', frame, C.ActionBars.ButtonSpacing, C.ActionBars.ButtonSpacing)
	else
		local previous = _G['ActionButton'..i-1]
		button:SetPoint('LEFT', previous, 'RIGHT', C.ActionBars.ButtonSpacing, 0)
	end
    
    button:StyleButton()
end

-- Show/Hide
RegisterStateDriver(frame, 'visibility', '[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists] hide; show')

-- Bar 2
if C.ActionBars.Bar2 then
    local frame = CreateFrame('Frame', 'LanBar2', UIParent, 'SecureHandlerStateTemplate') -- MultiBarBottomLeft
    frame:SetWidth(num * C.ActionBars.ButtonSize + (num - 1) * C.ActionBars.ButtonSpacing + 2 * C.ActionBars.ButtonSpacing)
    frame:SetHeight(C.ActionBars.ButtonSize + C.ActionBars.ButtonSpacing)
    frame:SetPoint('TOP', LanBar1, 'BOTTOM')
    frame:SetScale(1)
    
    MultiBarBottomLeft:SetParent(frame)
    MultiBarBottomLeft:EnableMouse(false)
    
    for i = 1, num do
        local button = _G['MultiBarBottomLeftButton'..i]
        table.insert(buttonList, button)
        button:SetSize(C.ActionBars.ButtonSize, C.ActionBars.ButtonSize)
        button:ClearAllPoints()
        
        if not button.skinned then
            button:SetTemplate(true)
            button:SetBeautyBorderPadding(2)
        end
        
        if i == 1 then
            button:SetPoint('BOTTOMLEFT', frame, C.ActionBars.ButtonSpacing, C.ActionBars.ButtonSpacing)
        else
            local previous = _G['MultiBarBottomLeftButton'..i - 1]
            button:SetPoint('LEFT', previous, 'RIGHT', C.ActionBars.ButtonSpacing, 0)
        end
        
        button:StyleButton()
    end
    
    -- Show/Hide
    RegisterStateDriver(frame, 'visibility', '[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists] hide; show')
end

if C.ActionBars.Bar3 then
    -- Bar 3
    local frame = CreateFrame('Frame', 'LanBar3', UIParent, 'SecureHandlerStateTemplate') -- MultiBarBottomRight
    frame:SetWidth(num * C.ActionBars.ButtonSize + (num - 1) * C.ActionBars.ButtonSpacing + 2 * C.ActionBars.ButtonSpacing)
    frame:SetHeight(C.ActionBars.ButtonSize + C.ActionBars.ButtonSpacing)
    frame:SetPoint('TOP', LanBar2, 'BOTTOM')
    frame:SetScale(1)
    
    MultiBarBottomRight:SetParent(frame)
    MultiBarBottomRight:EnableMouse(false)
    
    for i = 1, num do
        local button = _G['MultiBarBottomRightButton'..i]
        table.insert(buttonList, button)
        button:SetSize(C.ActionBars.ButtonSize, C.ActionBars.ButtonSize)
        button:ClearAllPoints()
        
        if not button.skinned then
            button:SetTemplate(true)
            button:SetBeautyBorderPadding(2)
        end
        
        if i == 1 then
            button:SetPoint('BOTTOMLEFT', frame, C.ActionBars.ButtonSpacing, C.ActionBars.ButtonSpacing)
        else
            local previous = _G['MultiBarBottomRightButton'..i - 1]
            button:SetPoint('LEFT', previous, 'RIGHT', C.ActionBars.ButtonSpacing, 0)
        end
        
        button:StyleButton()
    end
    
    -- Show/Hide
    RegisterStateDriver(frame, 'visibility', '[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists] hide; show')
end

-- LeaveVehicle Button
local button = CreateFrame('BUTTON', 'LanLeave', ABPanel or ChatFrame1, 'SecureHandlerClickTemplate, SecureHandlerStateTemplate');
table.insert(buttonList, button)
button:SetSize(C.Media.FontSize, C.Media.FontSize)

if C.Panels.ABPanel then
    button:SetPoint('TOPRIGHT', ABPanel, 'TOPLEFT', -2, 0)
else
    button:SetPoint('BOTTOMLEFT', ChatFrame1, 'BOTTOMRIGHT', C.ActionBars.ButtonSpacing, 0)
end

button:RegisterForClicks('AnyUp')
button:SetScript('OnClick', function(self) VehicleExit() end)

if button.SetHighlightTexture and not button.hover then
    local hover = button:CreateTexture('frame', nil, self)
    hover:SetTexture(1, 1, 1, 0.3)
    hover:Point('TOPLEFT', 1, -1)
    hover:Point('BOTTOMRIGHT', -1, 1)
    button.hover = hover
    button:SetHighlightTexture(hover)
end

if button.SetPushedTexture and not button.pushed then
    local pushed = button:CreateTexture('frame', nil, self)
    pushed:SetTexture(0.9, 0.8, 0.1, 0.3)
    pushed:Point('TOPLEFT', 1, -1)
    pushed:Point('BOTTOMRIGHT', -1, 1)
    button.pushed = pushed
    button:SetPushedTexture(pushed)
end

if not button.skinned then
	button:SetTemplate()
    button:SetBackdropColor(1, 0, 0, 0.5)
end

-- Show/Hide
RegisterStateDriver(button, 'visibility', '[petbattle][overridebar][vehicleui] hide; [possessbar][@vehicle,exists] show; hide')

-- Override Bar
local frame = CreateFrame('Frame', 'LanOverride', UIParent, 'SecureHandlerStateTemplate')
frame:SetWidth(num * C.ActionBars.ButtonSize + (num - 1) * C.ActionBars.ButtonSpacing + 2 * C.ActionBars.ButtonSpacing)
frame:SetHeight(C.ActionBars.ButtonSize + 2 * C.ActionBars.ButtonSpacing)

if C.Panels.ABPanel then
    frame:SetPoint('TOPLEFT', ABPanel, 2, -2)
else
    frame:SetPoint('BOTTOM', UIParent, 0, 200)
end

frame:SetScale(0.8)

OverrideActionBar:SetParent(frame)
OverrideActionBar:EnableMouse(false)
OverrideActionBar:SetScript('OnShow', nil) -- Kill OnShow

local leaveButtonPlaced = false

for i = 1, num do
	local button = _G['OverrideActionBarButton'..i]
	if not button and not leaveButtonPlaced then
		button = OverrideActionBar.LeaveButton
		leaveButtonPlaced = true
	end
    
	if not button then
		break
	end
    
	table.insert(buttonList, button)
	button:SetSize(C.ActionBars.ButtonSize, C.ActionBars.ButtonSize)
	button:ClearAllPoints()
    
	if not button.skinned then
		button:SetTemplate(true)
        button:SetBeautyBorderPadding(2)
	end
    
	if i == 1 then
		button:SetPoint('BOTTOMLEFT', frame, C.ActionBars.ButtonSpacing, C.ActionBars.ButtonSpacing)
	else
		local previous = _G['OverrideActionBarButton'..i - 1]
		button:SetPoint('LEFT', previous, 'RIGHT', C.ActionBars.ButtonSpacing, 0)
	end
    
    button:SetNormalTexture(nil)
    button:StyleButton()
end

-- Show/Hide
RegisterStateDriver(frame, 'visibility', '[petbattle] hide; [overridebar][vehicleui][possessbar,@vehicle,exists] show; hide')
RegisterStateDriver(OverrideActionBar, 'visibility', '[overridebar][vehicleui][possessbar,@vehicle,exists] show; hide')
	
-- Extra Action Bar
local Extra = CreateFrame('Frame', 'LanExtraBar', UIParent, 'SecureHandlerStateTemplate')
Extra:SetSize(C.ActionBars.ButtonSize, C.ActionBars.ButtonSize)
Extra:SetPoint('BOTTOM', LanBar1, 'TOP', 0, C.ActionBars.ButtonSize * 2)

RegisterStateDriver(Extra, 'visibility', '[petbattle][overridebar][vehicleui] hide; show')

ExtraActionBarFrame:SetParent(Extra)
ExtraActionBarFrame:EnableMouse(false)
ExtraActionBarFrame:SetAllPoints()
ExtraActionBarFrame.ignoreFramePositionManager = true

_G['ExtraActionButton1']:SetTemplate(true)
_G['ExtraActionButton1']:SetBeautyBorderPadding(2)
_G['ExtraActionButton1']:StyleButton()
_G['ExtraActionButton1HotKey']:Hide()

local normal = ExtraActionButton1NormalTexture2 or ExtraActionButton1NormalTexture
if normal then
    hooksecurefunc(ExtraActionButton1, 'SetNormalTexture', function()
        ExtraActionButton1NormalTexture:SetTexture(nil)
        ExtraActionButton1NormalTexture2:SetTexture(nil)
    end)
end

-- Stance Bar
local num = NUM_STANCE_SLOTS
local num2 = NUM_POSSESS_SLOTS

local frame = CreateFrame('Frame', 'LanStance', UIParent, 'SecureHandlerStateTemplate')
frame:SetWidth(num * C.ActionBars.ButtonSize + (num - 1) * C.ActionBars.ButtonSpacing + 2 * C.ActionBars.ButtonSpacing)
frame:SetHeight(C.ActionBars.ButtonSize + 2 * C.ActionBars.ButtonSpacing)
frame:SetPoint('BOTTOMRIGHT', LanBar1, 'BOTTOMLEFT', -C.ActionBars.ButtonSpacing, 0)
frame:SetScale(1)

StanceBarFrame:SetParent(frame)
StanceBarFrame:EnableMouse(false)

-- Fix button1 if there's only one form
StanceBarFrame:ClearAllPoints()
StanceBarFrame:SetPoint('BOTTOMLEFT', frame, C.ActionBars.ButtonSpacing - 12, C.ActionBars.ButtonSpacing - 3)
StanceBarFrame.ignoreFramePositionManager = true

for i = 1, num do
	local button = _G['StanceButton'..i]
	table.insert(buttonList, button)
	button:SetSize(C.ActionBars.ButtonSize, C.ActionBars.ButtonSize)
	button:ClearAllPoints()
    
	if not button.skinned then
		button:SetTemplate(true)
        button:SetBeautyBorderPadding(2)
	end
    
	if i == 1 then
		button:SetPoint('BOTTOMLEFT', frame, C.ActionBars.ButtonSpacing, C.ActionBars.ButtonSpacing)
	else
		local previous = _G['StanceButton'..i - 1]
		button:SetPoint('LEFT', previous, 'RIGHT', C.ActionBars.ButtonSpacing, 0)
	end
    
    button:StyleButton()
end

-- Possess Bar
PossessBarFrame:SetParent(frame)
PossessBarFrame:EnableMouse(false)

for i = 1, num2 do
	local button = _G['PossessButton'..i]
	table.insert(buttonList, button)
	button:SetSize(C.ActionBars.ButtonSize, C.ActionBars.ButtonSize)
	button:ClearAllPoints()
    
	if not button.skinned then
		button:SetTemplate(true)
        button:SetBeautyBorderPadding(2)
	end
    
	if i == 1 then
		button:SetPoint('BOTTOMLEFT', frame, C.ActionBars.ButtonSpacing, C.ActionBars.ButtonSpacing)
	else
		local previous = _G['PossessButton'..i - 1]
		button:SetPoint('LEFT', previous, 'RIGHT', C.ActionBars.ButtonSpacing, 0)
	end
    
    button:StyleButton()
end

-- Show/Hide
RegisterStateDriver(frame, 'visibility', '[petbattle][overridebar][vehicleui] hide; show')

-- Pet Bar
local num = NUM_PET_ACTION_SLOTS
local frame = CreateFrame('Frame', 'LanPet', UIParent, 'SecureHandlerStateTemplate')
frame:SetWidth(num * C.ActionBars.ButtonSize + (num - 1) * C.ActionBars.ButtonSpacing + 2 * C.ActionBars.ButtonSpacing)
frame:SetHeight(C.ActionBars.ButtonSize + 2 * C.ActionBars.ButtonSpacing)

if C.Panels.ABPanel then
    frame:SetPoint('BOTTOM', ABPanel, 'TOP')
else
    frame:SetPoint('BOTTOMLEFT', ActionButton1, 'TOPRIGHT', 0, 5)
end

frame:SetScale(1)

PetActionBarFrame:SetParent(frame)
PetActionBarFrame:EnableMouse(false)

for i = 1, num do
	local button = _G['PetActionButton'..i]
	table.insert(buttonList, button)
	button:SetSize(C.ActionBars.ButtonSize, C.ActionBars.ButtonSize)
	button:ClearAllPoints()
    
	if not button.skinned then
		button:SetTemplate(true)
        button:SetBeautyBorderPadding(2)
	end
    
	if i == 1 then
		button:SetPoint('LEFT', frame, C.ActionBars.ButtonSpacing, 0)
	else
		local previous = _G['PetActionButton'..i - 1]
		button:SetPoint('LEFT', previous, 'RIGHT', C.ActionBars.ButtonSpacing, 0)
	end
    
	-- Cooldown fix
	local cd = _G['PetActionButton'..i..'Cooldown']
	cd:SetAllPoints(button)
    
    F.StylePet()
    hooksecurefunc('PetActionBar_Update', F.PetBarUpdate)
end

-- Show/Hide
RegisterStateDriver(frame, 'visibility', '[petbattle] hide; [vehicleui] hide; [@pet,exists,nodead] show; hide')
	
-- Bag Bar
local bagbuttonList = {
        MainMenuBarBackpackButton,
        CharacterBag0Slot,
        CharacterBag1Slot,
        CharacterBag2Slot,
        CharacterBag3Slot,
}

for _, kill in pairs(bagbuttonList) do
    kill:Kill()
end

-- Hide Blizzard Crap
MainMenuBar:SetParent(G.Misc.UIHider)
MainMenuBarPageNumber:SetParent(G.Misc.UIHider)
ActionBarDownButton:SetParent(G.Misc.UIHider)
ActionBarUpButton:SetParent(G.Misc.UIHider)
OverrideActionBarExpBar:SetParent(G.Misc.UIHider)
OverrideActionBarHealthBar:SetParent(G.Misc.UIHider)
OverrideActionBarPowerBar:SetParent(G.Misc.UIHider)
OverrideActionBarPitchFrame:SetParent(G.Misc.UIHider)

-- Textures
StanceBarLeft:SetTexture(nil)
StanceBarMiddle:SetTexture(nil)
StanceBarRight:SetTexture(nil)
SlidingActionBarTexture0:SetTexture(nil)
SlidingActionBarTexture1:SetTexture(nil)
PossessBackground1:SetTexture(nil)
PossessBackground2:SetTexture(nil)
MainMenuBarTexture0:SetTexture(nil)
MainMenuBarTexture1:SetTexture(nil)
MainMenuBarTexture2:SetTexture(nil)
MainMenuBarTexture3:SetTexture(nil)
MainMenuBarLeftEndCap:SetTexture(nil)
MainMenuBarRightEndCap:SetTexture(nil)

local textureList =  {
	'_BG',
	'EndCapL',
	'EndCapR',
	'_Border',
	'Divider1',
	'Divider2',
	'Divider3',
	'ExitBG',
	'MicroBGL',
	'MicroBGR',
	'_MicroBGMid',
	'ButtonBGL',
	'ButtonBGR',
	'_ButtonBGMid',
}

for _,tex in pairs(textureList) do
    OverrideActionBar[tex]:SetAlpha(0)
end

-- ExtraActionButton	
-- Hook the ExtraActionButton1 texture, idea by roth via WoWInterface forums
-- Code by Tukz
local button = ExtraActionButton1
local icon = button.icon
local texture = button.style
local disableTexture = function(style, texture)
	-- Looks like sometimes the texture path is set to capital letter instead of lower-case
	if string.sub(texture,1,9) == 'Interface' or string.sub(texture,1,9) == 'INTERFACE' then
		style:SetTexture('')
	end
end
button.style:SetTexture('')
hooksecurefunc(texture, 'SetTexture', disableTexture)

-- Change button status color
local function RangeUpdate(self)
    -- Force an initial update because it isn't triggered on login in 6.0.2
    ActionButton_UpdateHotkeys(self, self.buttonType)
    
    if (IsAddOnLoaded('RedRange') or IsAddOnLoaded('GreenRange') or IsAddOnLoaded('tullaRange') or IsAddOnLoaded('RangeColors')) then
        return
    end  
    
    local Name = self:GetName()
	local Icon = _G[Name.."Icon"]
    local NormalTexture
    if Name.SetNormalTexture then
        NormalTexture = Name:GetNormalTexture()
    end
    local ID = self.action
    local IsUsable, NotEnoughMana = IsUsableAction(ID)
	local HasRange = ActionHasRange(ID)
	local InRange = IsActionInRange(ID)
	
    if NormalTexture and Icon.SetVertexColor and NormalTexture.SetVertexColor then
        NormalTexture:SetTexture(nil)

        hooksecurefunc(NormalTexture, 'SetVertexColor', function()
            if IsUsable then -- Usable
                if (HasRange and InRange == false) then -- Out of range
                    Icon:SetVertexColor(0.8, 0.1, 0.1)
                    NormalTexture:SetVertexColor(0.8, 0.1, 0.1)
                else -- In range
                    Icon:SetVertexColor(1.0, 1.0, 1.0)
                    NormalTexture:SetVertexColor(1.0, 1.0, 1.0)
                end
            elseif NotEnoughMana then -- Not enough power
                Icon:SetVertexColor(0.1, 0.3, 1.0)
                NormalTexture:SetVertexColor(0.1, 0.3, 1.0)
            else -- Not usable
                Icon:SetVertexColor(0.3, 0.3, 0.3)
                NormalTexture:SetVertexColor(0.3, 0.3, 0.3)
            end
        end)
    end
end

hooksecurefunc("ActionButton_Update", RangeUpdate)
hooksecurefunc("ActionButton_UpdateUsable", RangeUpdate)   

hooksecurefunc('ActionButton_OnUpdate', function(self, elapsed)
    if (IsAddOnLoaded('tullaRange') or IsAddOnLoaded('RangeColors')) then
        return
    end

    if (self.rangeTimer) then
        if (self.rangeTimer - elapsed <= 0) then
            local isInRange = false
            if (IsActionInRange(self.action) == false) then
                _G[self:GetName()..'Icon']:SetVertexColor(0.9, 0, 0)
                isInRange = true
            end

            if (self.isInRange ~= isInRange) then
                self.isInRange = isInRange
                ActionButton_UpdateUsable(self)
            end
        end
    end
end)
hooksecurefunc('ActionButton_OnUpdate', ActionButton_OnUpdate)

local f = CreateFrame('Frame', MainMenuBar)
f:RegisterEvent('ADDON_LOADED')
f:SetScript('OnEvent', function(addon)
    if addon == 'LanUI' then
        if C.ActionBars.Bar3 then
            SetActionBarToggles(true, true, false, false, true)
            InterfaceOptionsActionBarsPanelBottomLeft:SetChecked(1)
            InterfaceOptionsActionBarsPanelBottomRight:SetChecked(1)
            
            InterfaceOptions_UpdateMultiActionBars()
        elseif C.ActionBars.Bar2 then
            if C.ActionBars.Bar3 then return end
            
            SetActionBarToggles(true, false, false, false, true)
            InterfaceOptionsActionBarsPanelBottomLeft:SetChecked(1)
            InterfaceOptionsActionBarsPanelBottomRight:SetChecked(0)
            
            InterfaceOptions_UpdateMultiActionBars()
        else
            SetActionBarToggles(false, false, false, false, true)
            InterfaceOptionsActionBarsPanelBottomLeft:SetChecked(0)
            InterfaceOptionsActionBarsPanelBottomRight:SetChecked(0)
            
            InterfaceOptions_UpdateMultiActionBars()
        end
    end
end)

-- Shorten Hotkey display
local gsub = string.gsub

hooksecurefunc('ActionButton_UpdateHotkeys', function(self, actionButtonType)
    local hotkey = _G[self:GetName()..'HotKey']
    local text = hotkey:GetText()

    text = gsub(text, '(s%-)', 'S-')
    text = gsub(text, '(a%-)', 'A-')
    text = gsub(text, '(c%-)', 'C-')
    text = gsub(text, '(st%-)', 'C-')

    for i = 1, 30 do
        text = gsub(text, _G['KEY_BUTTON'..i], 'M'..i)
    end

    for i = 1, 9 do
        text = gsub(text, _G['KEY_NUMPAD'..i], 'Nu'..i)
    end

    text = gsub(text, KEY_NUMPADDECIMAL, 'Nu.')
    text = gsub(text, KEY_NUMPADDIVIDE, 'Nu/')
    text = gsub(text, KEY_NUMPADMINUS, 'Nu-')
    text = gsub(text, KEY_NUMPADMULTIPLY, 'Nu*')
    text = gsub(text, KEY_NUMPADPLUS, 'Nu+')

    text = gsub(text, KEY_MOUSEWHEELUP, 'MU')
    text = gsub(text, KEY_MOUSEWHEELDOWN, 'MD')
    text = gsub(text, KEY_NUMLOCK, 'NuL')
    text = gsub(text, KEY_PAGEUP, 'PU')
    text = gsub(text, KEY_PAGEDOWN, 'PD')
    text = gsub(text, KEY_SPACE, '_')
    text = gsub(text, KEY_INSERT, 'Ins')
    text = gsub(text, KEY_HOME, 'Hm')
    text = gsub(text, KEY_DELETE, 'Del')

    hotkey:SetText(text)
end)

-- XP Bar/Rep Bar
local bc = C.Media.BorderColor

local XP = CreateFrame('Frame', 'LanXP', UIParent)
XP:SetPoint('BOTTOM', BottomPanel, 'TOP', 0, 2)
XP:SetWidth(512)
XP:SetHeight(13)

XP:SetTemplate()

local font = CreateFont('LanXPFont')
font:SetFontObject(GameFontHighlightSmall)
font:SetTextColor(bc.r, bc.g, bc.b)

local indictator = XP:CreateTexture(nil, 'OVERLAY')
indictator:SetWidth(1)
indictator:SetTexture(bc.r, bc.g, bc.b)
indictator:SetHeight(13)

local textMain = XP:CreateFontString(nil, 'OVERLAY')
textMain:SetPoint('LEFT', indictator, 'RIGHT', 10, 0)
textMain:SetFontObject(font)

local textTR = XP:CreateFontString(nil, 'OVERLAY')
textTR:SetPoint('BOTTOMRIGHT', XP, 'TOPRIGHT', 0, 2)
textTR:SetFontObject(font)

local textTL = XP:CreateFontString(nil, 'OVERLAY')
textTL:SetPoint('BOTTOMLEFT', XP, 'TOPLEFT', 0, 2)
textTL:SetFontObject(font)

local textBR = XP:CreateFontString(nil, 'OVERLAY')
textBR:SetPoint('TOPRIGHT', XP, 'BOTTOMRIGHT', 0, -2)
textBR:SetFontObject(font)

local textBL = XP:CreateFontString(nil, 'OVERLAY')
textBL:SetPoint('TOPLEFT', XP, 'BOTTOMLEFT', 0, -2)
textBL:SetFontObject(font)

-- Helper Functions
function XP:Move(ind, perc)
    ind:ClearAllPoints()
    ind:SetPoint('TOPLEFT', 512 * perc, 0)
end

local function truncate(value)
    if(value > 999 or value < -999) then
        return string.format('|cffffffff%.0f|r k', value / 1e3)
    else
        return '|cffffffff'..value..'|r'
    end
end

-- Update Functions for xp bar
function XP:PLAYER_ENTERING_WORLD()
    if F.Level == MAX_PLAYER_LEVEL_TABLE[GetExpansionLevel()] then
        self:UPDATE_FACTION()
    else
        self:PLAYER_XP_UPDATE()
    end
end

function XP:PLAYER_XP_UPDATE()
    local min = UnitXP('player')
    local max = UnitXPMax('player')
    local rested =  GetRestState()

    textMain:SetFormattedText('|cffffffff%.1f|r%%', min/max*100)
    textTL:SetFormattedText('%s', truncate(min))
    textTR:SetFormattedText('%s', truncate(min-max))
    textBL:SetFormattedText('|cffffffff%.1f|r bars', min/max*20)
    textBR:SetFormattedText('|cffffffff%.1f|r bars', min/max*20-20)

    self:Move(indictator, min/max)
end
XP.PLAYER_LEVEL_UP = XP.PLAYER_XP_UPDATE

function XP:UPDATE_FACTION()
if F.Level == MAX_PLAYER_LEVEL_TABLE[GetExpansionLevel()] then
        local name, standing, min, max, value = GetWatchedFactionInfo()

        if(not name) then return nil end
        max, min = (max-min), (value-min)

        textMain:SetFormattedText('|cffffffff%.1f|r%%', min/max*100)
        textTL:SetFormattedText('|cffffffff%s|r (|cffffffff%s|r)', name, _G['FACTION_STANDING_LABEL'..standing])
        textTR:SetFormattedText('|cffffffff%s|r / |cffffffff%s|r', min, max)
        textBL:SetFormattedText('')
        textBR:SetFormattedText('')
        self:Move(indictator, min/max)
    end	
end

-- RegisterEvents
XP:SetScript('OnEvent', function(self, event, ...) self[event](self, event, ...)
end)
XP:RegisterEvent('PLAYER_XP_UPDATE')
XP:RegisterEvent('UPDATE_FACTION')
XP:RegisterEvent('PLAYER_LEVEL_UP')
XP:RegisterEvent('PLAYER_ENTERING_WORLD')

-- Move AltPowerBar
PlayerPowerBarAlt:SetPoint('TOP', ABPanel, 'BOTTOM', 0, -2)