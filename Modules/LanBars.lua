local F, C, G = unpack(select(2, ...))

--[[MainMenuBar:SetScale(1)
OverrideActionBar:SetScale(0.8)
MultiBarBottomLeft:SetAlpha(1)
MultiBarBottomRight:SetAlpha(1)
MultiBarLeft:SetAlpha(1)
MultiBarLeft:SetScale(1)
MultiBarLeft:SetParent(UIParent)
MultiBarRight:SetAlpha(1)
MultiBarRight:SetScale(1)]]

-- Kill Blizzard options for ActionBars
InterfaceOptionsActionBarsPanelBottomLeft:Kill()
InterfaceOptionsActionBarsPanelBottomRight:Kill()
InterfaceOptionsActionBarsPanelRight:Kill()
InterfaceOptionsActionBarsPanelRightTwo:Kill()
InterfaceOptionsActionBarsPanelAlwaysShowActionBars:Kill()

--kill micromenu (or rather just make it too small to see then set the button to non interactive (just in case)
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
PVPMicroButton:SetScale(0.0001)
PVPMicroButton:EnableMouse(false)
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

--hide macro textleave
if not C.ActionBars.Macro then
	for i=1, 12 do
		_G["ActionButton"..i.."Name"]:SetAlpha(0) -- main bar
		_G["MultiBarBottomRightButton"..i.."Name"]:SetAlpha(0) -- bottom right bar
		_G["MultiBarBottomLeftButton"..i.."Name"]:SetAlpha(0) -- bottom left bar
		_G["MultiBarRightButton"..i.."Name"]:SetAlpha(0) -- right bar
		_G["MultiBarLeftButton"..i.."Name"]:SetAlpha(0) -- left bar
	end
end
--hide hotkey
if not C.ActionBars.Hotkey then
	for i=1, 12 do
		_G["ActionButton"..i.."HotKey"]:SetAlpha(0) -- main bar
		_G["MultiBarBottomRightButton"..i.."HotKey"]:SetAlpha(0) -- bottom right bar
		_G["MultiBarBottomLeftButton"..i.."HotKey"]:SetAlpha(0) -- bottom left bar
		_G["MultiBarRightButton"..i.."HotKey"]:SetAlpha(0) -- right bar
		_G["MultiBarLeftButton"..i.."HotKey"]:SetAlpha(0) -- left bar
	end
end

--Lets get our hands dirty now, easy stuff is over.
local num = NUM_ACTIONBAR_BUTTONS
local buttonList = {}

------------[[Bar 1]]------------
--create the frame to hold the buttons
local frame = CreateFrame("Frame", "LanBar1", UIParent, "SecureHandlerStateTemplate")
frame:SetWidth(num * C.ActionBars.ButtonSize + (num - 1) * C.ActionBars.ButtonSpacing + 2 * C.ActionBars.ButtonSpacing)
frame:SetHeight(C.ActionBars.ButtonSize + 2 * C.ActionBars.ButtonSpacing)

if C.Panels.ABPanel then
    frame:SetPoint('TOPLEFT', ABPanel, 2, -2)
else
    frame:SetPoint('BOTTOM', UIParent, 0, 200)
end

frame:SetScale(1)

--move the buttons into position and reparent them
MainMenuBarArtFrame:SetParent(frame)
MainMenuBarArtFrame:EnableMouse(false)

for i = 1, num do
	local button = _G["ActionButton"..i]
	table.insert(buttonList, button) --add the button object to the list
	button:SetSize(C.ActionBars.ButtonSize, C.ActionBars.ButtonSize)
	button:ClearAllPoints()
    
	if not button.skinned then
		button:SetTemplate(true)
        button:SetBeautyBorderPadding(2)
	end
    
	if i == 1 then
		button:SetPoint("BOTTOMLEFT", frame, C.ActionBars.ButtonSpacing, C.ActionBars.ButtonSpacing)
	else
		local previous = _G["ActionButton"..i-1]
		button:SetPoint("LEFT", previous, "RIGHT", C.ActionBars.ButtonSpacing, 0)
	end
    
    button:StyleButton()
end

hooksecurefunc('ActionButton_ShowGrid', function(self)
    local normal = _G[self:GetName()..'NormalTexture']
    
    if normal then
        normal:SetVertexColor(0, 0, 0, 0)
    end
end)

--show/hide the frame on a given state driver
RegisterStateDriver(frame, "visibility", "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists] hide; show")

------------[[Bar 2]]------------
if C.ActionBars.Bar2 then
    local frame = CreateFrame("Frame", "LanBar2", UIParent, "SecureHandlerStateTemplate") -- MultiBarBottomLeft
    frame:SetWidth(num * C.ActionBars.ButtonSize + (num - 1) * C.ActionBars.ButtonSpacing + 2 * C.ActionBars.ButtonSpacing)
    frame:SetHeight(C.ActionBars.ButtonSize + C.ActionBars.ButtonSpacing)
    frame:SetPoint('TOP', LanBar1, 'BOTTOM')
    frame:SetScale(1)
    
    --move the buttons into position and reparent them
    MultiBarBottomLeft:SetParent(frame)
    MultiBarBottomLeft:EnableMouse(false)
    
    for i = 1, num do
        local button = _G["MultiBarBottomLeftButton"..i]
        table.insert(buttonList, button) --add the button object to the list
        button:SetSize(C.ActionBars.ButtonSize, C.ActionBars.ButtonSize)
        button:ClearAllPoints()
        
        if not button.skinned then
            button:SetTemplate(true)
            button:SetBeautyBorderPadding(2)
        end
        
        if i == 1 then
            button:SetPoint("BOTTOMLEFT", frame, C.ActionBars.ButtonSpacing, C.ActionBars.ButtonSpacing)
        else
            local previous = _G["MultiBarBottomLeftButton"..i - 1]
            button:SetPoint("LEFT", previous, "RIGHT", C.ActionBars.ButtonSpacing, 0)
        end
        
        button:StyleButton()
    end
    
    --show/hide the frame on a given state driver
    RegisterStateDriver(frame, "visibility", "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists] hide; show")
end

if C.ActionBars.Bar3 then
    ------------[[Bar 3]]------------
    local frame = CreateFrame("Frame", "LanBar3", UIParent, "SecureHandlerStateTemplate") -- MultiBarBottomRight
    frame:SetWidth(num * C.ActionBars.ButtonSize + (num - 1) * C.ActionBars.ButtonSpacing + 2 * C.ActionBars.ButtonSpacing)
    frame:SetHeight(C.ActionBars.ButtonSize + C.ActionBars.ButtonSpacing)
    frame:SetPoint('TOP', LanBar2, 'BOTTOM')
    frame:SetScale(1)
    
    --move the buttons into position and reparent them
    MultiBarBottomRight:SetParent(frame)
    MultiBarBottomRight:EnableMouse(false)
    
    for i = 1, num do
        local button = _G["MultiBarBottomRightButton"..i]
        table.insert(buttonList, button) --add the button object to the list
        button:SetSize(C.ActionBars.ButtonSize, C.ActionBars.ButtonSize)
        button:ClearAllPoints()
        
        if not button.skinned then
            button:SetTemplate(true)
            button:SetBeautyBorderPadding(2)
        end
        
        if i == 1 then
            button:SetPoint("BOTTOMLEFT", frame, C.ActionBars.ButtonSpacing, C.ActionBars.ButtonSpacing)
        else
            local previous = _G["MultiBarBottomRightButton"..i - 1]
            button:SetPoint("LEFT", previous, "RIGHT", C.ActionBars.ButtonSpacing, 0)
        end
        
        button:StyleButton()
    end
    
    --show/hide the frame on a given state driver
    RegisterStateDriver(frame, "visibility", "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists] hide; show")
end

------------[[LeaveVehicle]]------------
--create the button
local button = CreateFrame("BUTTON", "LanLeave", ABPanel or ChatFrame1, "SecureHandlerClickTemplate, SecureHandlerStateTemplate");
table.insert(buttonList, button) --add the button object to the list
button:SetSize(C.Media.FontSize, C.Media.FontSize)

if C.Panels.ABPanel then
    button:SetPoint('TOPRIGHT', ABPanel, 'TOPLEFT', -2, 0)
else
    button:SetPoint("BOTTOMLEFT", ChatFrame1, 'BOTTOMRIGHT', C.ActionBars.ButtonSpacing, 0)
end

button:RegisterForClicks("AnyUp")
button:SetScript("OnClick", function(self) VehicleExit() end)

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

--the button will spawn if a vehicle exists, but no vehicle ui is in place (the vehicle ui has its own exit button)
RegisterStateDriver(button, "visibility", "[petbattle][overridebar][vehicleui] hide; [possessbar][@vehicle,exists] show; hide")

------------[[Override Bar]]------------
--create the frame to hold the buttons
local frame = CreateFrame("Frame", "LanOverride", UIParent, "SecureHandlerStateTemplate")
frame:SetWidth(num * C.ActionBars.ButtonSize + (num - 1) * C.ActionBars.ButtonSpacing + 2 * C.ActionBars.ButtonSpacing)
frame:SetHeight(C.ActionBars.ButtonSize + 2 * C.ActionBars.ButtonSpacing)

if C.Panels.ABPanel then
    frame:SetPoint('TOPLEFT', ABPanel)
else
    frame:SetPoint('BOTTOM', UIParent, 0, 200)
end

frame:SetScale(0.8)
--move the buttons into position and reparent them
OverrideActionBar:SetParent(frame)
OverrideActionBar:EnableMouse(false)
OverrideActionBar:SetScript("OnShow", nil) --remove the onshow script
local leaveButtonPlaced = false

for i=1, num do
	local button = _G["OverrideActionBarButton"..i]
	if not button and not leaveButtonPlaced then
		button = OverrideActionBar.LeaveButton --the magic 7th button
		leaveButtonPlaced = true
	end
    
	if not button then
		break
	end
    
	table.insert(buttonList, button) --add the button object to the list
	button:SetSize(C.ActionBars.ButtonSize, C.ActionBars.ButtonSize)
	button:ClearAllPoints()
    
	if not button.skinned then
		button:SetTemplate(true)
        button:SetBeautyBorderPadding(2)
	end
    
	if i == 1 then
		button:SetPoint("BOTTOMLEFT", frame, C.ActionBars.ButtonSpacing, C.ActionBars.ButtonSpacing)
	else
		local previous = _G["OverrideActionBarButton"..i - 1]
		button:SetPoint("LEFT", previous, "RIGHT", C.ActionBars.ButtonSpacing, 0)
	end
    
    button:SetNormalTexture(nil)
    button:StyleButton()
end

--show/hide the frame on a given state driver
RegisterStateDriver(frame, "visibility", "[petbattle] hide; [overridebar][vehicleui][possessbar,@vehicle,exists] show; hide")
RegisterStateDriver(OverrideActionBar, "visibility", "[overridebar][vehicleui][possessbar,@vehicle,exists] show; hide")
	
------------[[Extra Action Bar]]------------
_G["ExtraActionButton1"]:SetParent(UIParent)
_G["ExtraActionButton1"]:SetSize(C.ActionBars.ButtonSize, C.ActionBars.ButtonSize)
_G["ExtraActionButton1"]:SetScale(1)
_G["ExtraActionButton1"]:SetPoint('BOTTOM', LanBar1, 'TOP', 0, C.ActionBars.ButtonSize * 2)
_G["ExtraActionButton1"]:SetTemplate(true)
_G['ExtraActionButton1']:SetBeautyBorderPadding(2)
_G["ExtraActionButton1"]:StyleButton()
local normal = ExtraActionButton1NormalTexture2 or ExtraActionButton1NormalTexture
normal:SetVertexColor(0, 0, 0, 0)

------------[[Stance Bar]]------------
local num = NUM_STANCE_SLOTS
local num2 = NUM_POSSESS_SLOTS
--make a frame that fits the size of all microbuttons
local frame = CreateFrame("Frame", "LanStance", UIParent, "SecureHandlerStateTemplate")
frame:SetWidth(num * C.ActionBars.ButtonSize + (num - 1) * C.ActionBars.ButtonSpacing + 2 * C.ActionBars.ButtonSpacing)
frame:SetHeight(C.ActionBars.ButtonSize + 2 * C.ActionBars.ButtonSpacing)
frame:SetPoint('BOTTOMRIGHT', LanBar1, 'BOTTOMLEFT', -C.ActionBars.ButtonSpacing, 0)
frame:SetScale(1)

--move the buttons into position and reparent them
StanceBarFrame:SetParent(frame)
StanceBarFrame:EnableMouse(false)

--fix for button1 placement with only one form
StanceBarFrame:ClearAllPoints()
StanceBarFrame:SetPoint("BOTTOMLEFT", frame, C.ActionBars.ButtonSpacing - 12, C.ActionBars.ButtonSpacing - 3)
StanceBarFrame.ignoreFramePositionManager = true

for i = 1, num do
	local button = _G["StanceButton"..i]
	table.insert(buttonList, button) --add the button object to the list
	button:SetSize(C.ActionBars.ButtonSize, C.ActionBars.ButtonSize)
	button:ClearAllPoints()
    
	if not button.skinned then
		button:SetTemplate(true)
        button:SetBeautyBorderPadding(2)
	end
    
	if i == 1 then
		button:SetPoint("BOTTOMLEFT", frame, C.ActionBars.ButtonSpacing, C.ActionBars.ButtonSpacing)
	else
		local previous = _G["StanceButton"..i - 1]
		button:SetPoint("LEFT", previous, "RIGHT", C.ActionBars.ButtonSpacing, 0)
	end
    
    button:StyleButton()
end

--POSSESS BAR
--move the buttons into position and reparent them
PossessBarFrame:SetParent(frame)
PossessBarFrame:EnableMouse(false)

for i = 1, num2 do
	local button = _G["PossessButton"..i]
	table.insert(buttonList, button) --add the button object to the list
	button:SetSize(C.ActionBars.ButtonSize, C.ActionBars.ButtonSize)
	button:ClearAllPoints()
    
	if not button.skinned then
		button:SetTemplate(true)
        button:SetBeautyBorderPadding(2)
	end
    
	if i == 1 then
		button:SetPoint("BOTTOMLEFT", frame, C.ActionBars.ButtonSpacing, C.ActionBars.ButtonSpacing)
	else
		local previous = _G["PossessButton"..i - 1]
		button:SetPoint("LEFT", previous, "RIGHT", C.ActionBars.ButtonSpacing, 0)
	end
    
    button:StyleButton()
end

--show/hide the frame on a given state driver
RegisterStateDriver(frame, "visibility", "[petbattle][overridebar][vehicleui] hide; show")

------------[[Pet Bar]]------------
local num = NUM_PET_ACTION_SLOTS
--create the frame to hold the buttons
local frame = CreateFrame("Frame", "LanPet", UIParent, "SecureHandlerStateTemplate")
frame:SetWidth(num * C.ActionBars.ButtonSize + (num - 1) * C.ActionBars.ButtonSpacing + 2 * C.ActionBars.ButtonSpacing)
frame:SetHeight(C.ActionBars.ButtonSize + 2 * C.ActionBars.ButtonSpacing)

if C.Panels.ABPanel then
    frame:SetPoint('BOTTOM', ABPanel, 'TOP')
else
    frame:SetPoint('BOTTOMLEFT', ActionButton1, 'TOPRIGHT', 0, 5)
end

frame:SetScale(1)

--move the buttons into position and reparent them
PetActionBarFrame:SetParent(frame)
PetActionBarFrame:EnableMouse(false)
for i = 1, num do
	local button = _G["PetActionButton"..i]
	table.insert(buttonList, button) --add the button object to the list
	button:SetSize(C.ActionBars.ButtonSize, C.ActionBars.ButtonSize)
	button:ClearAllPoints()
    
	if not button.skinned then
		button:SetTemplate(true)
        button:SetBeautyBorderPadding(2)
	end
    
	if i == 1 then
		button:SetPoint("LEFT", frame, C.ActionBars.ButtonSpacing, 0)
	else
		local previous = _G["PetActionButton"..i - 1]
		button:SetPoint("LEFT", previous, "RIGHT", C.ActionBars.ButtonSpacing, 0)
	end
    
	--cooldown fix
	local cd = _G["PetActionButton"..i.."Cooldown"]
	cd:SetAllPoints(button)
    
    F.StylePet()
    hooksecurefunc('PetActionBar_Update', F.PetBarUpdate)
end

--show/hide the frame on a given state driver
RegisterStateDriver(frame, "visibility", "[petbattle] hide; [vehicleui] hide; [@pet,exists,nodead] show; hide")
	
------------[[Bag Bar]]------------
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

for _, name in pairs({
    'MultiBarBottomLeftButton',
    'MultiBarBottomRightButton',
    'ActionButton',
}) do
    if not InCombatLockdown() then
        for i = 1, 12 do
            local button = _G[name..i]
            local normal = _G[name..i..'NormalTexture'] or _G[name..i..'NormalTexture2']
            
            if normal then
                normal:SetVertexColor(0, 0, 0, 0)
            end
        end
    end
end

-----------------------------
-- blizzHider
-----------------------------
--hide blizzard
local Bar1enable = true --This addon breaks if this is false
local overridebarenable = true --breaks vehicle bar if false
local blizzHider = G.Misc.UIHider
blizzHider:Hide()

--hide main menu bar frames
if Bar1enable then
	MainMenuBar:SetParent(blizzHider)
	MainMenuBarPageNumber:SetParent(blizzHider)
	ActionBarDownButton:SetParent(blizzHider)
	ActionBarUpButton:SetParent(blizzHider)
end

--hide override actionbar frames
if overridebarenable then
	OverrideActionBarExpBar:SetParent(blizzHider)
	OverrideActionBarHealthBar:SetParent(blizzHider)
	OverrideActionBarPowerBar:SetParent(blizzHider)
	OverrideActionBarPitchFrame:SetParent(blizzHider) --maybe we can use that frame later for pitchig and such
end

-----------------------------
-- HIDE TEXTURES
-----------------------------
--remove some the default background textures
StanceBarLeft:SetTexture(nil)
StanceBarMiddle:SetTexture(nil)
StanceBarRight:SetTexture(nil)
SlidingActionBarTexture0:SetTexture(nil)
SlidingActionBarTexture1:SetTexture(nil)
PossessBackground1:SetTexture(nil)
PossessBackground2:SetTexture(nil)

if Bar1enable then
	MainMenuBarTexture0:SetTexture(nil)
	MainMenuBarTexture1:SetTexture(nil)
	MainMenuBarTexture2:SetTexture(nil)
	MainMenuBarTexture3:SetTexture(nil)
	MainMenuBarLeftEndCap:SetTexture(nil)
	MainMenuBarRightEndCap:SetTexture(nil)
end

--remove OverrideBar textures
if overridebarenable then
	local textureList =  {
	"_BG",
	"EndCapL",
	"EndCapR",
	"_Border",
	"Divider1",
	"Divider2",
	"Divider3",
	"ExitBG",
	"MicroBGL",
	"MicroBGR",
	"_MicroBGMid",
	"ButtonBGL",
	"ButtonBGR",
	"_ButtonBGMid",
	}

	for _,tex in pairs(textureList) do
		OverrideActionBar[tex]:SetAlpha(0)
	end
end

--Cleanup the ExtraActionButton	
-- hook the ExtraActionButton1 texture, idea by roth via WoWInterface forums
-- code taken from Tukui
local button = ExtraActionButton1
local icon = button.icon
local texture = button.style
local disableTexture = function(style, texture)
	-- look like sometime the texture path is set to capital letter instead of lower-case
	if string.sub(texture,1,9) == "Interface" or string.sub(texture,1,9) == "INTERFACE" then
		style:SetTexture("")
	end
end
button.style:SetTexture("")
hooksecurefunc(texture, "SetTexture", disableTexture)

hooksecurefunc('ActionButton_ShowGrid', function(self)
    local normal = _G[self:GetName()..'NormalTexture']
    
    if normal then
        normal:SetVertexColor(0, 0, 0, 0)
    end
end)

-- Change action status color

hooksecurefunc('ActionButton_UpdateUsable', function(self)
    if (IsAddOnLoaded('RedRange') or IsAddOnLoaded('GreenRange') or IsAddOnLoaded('tullaRange') or IsAddOnLoaded('RangeColors')) then
        return
    end  

    local isUsable, notEnoughMana = IsUsableAction(self.action)
    if (isUsable) then
        _G[self:GetName()..'Icon']:SetVertexColor(1, 1, 1)
    elseif (notEnoughMana) then
        _G[self:GetName()..'Icon']:SetVertexColor(0.3, 0.3, 1)
    else
        _G[self:GetName()..'Icon']:SetVertexColor(0.35, 0.35, 0.35)
    end
end)

local function ActionButton_OnUpdate(self, elapsed)
    if (IsAddOnLoaded('RedRange') or IsAddOnLoaded('GreenRange') or IsAddOnLoaded('tullaRange') or IsAddOnLoaded('RangeColors')) then
        return
    end     

    if (ActionButton_IsFlashing(self)) then
        local flashtime = self.flashtime
        flashtime = flashtime - elapsed

        if (flashtime <= 0) then
            local overtime = - flashtime
            if (overtime >= ATTACK_BUTTON_FLASH_TIME) then
                overtime = 0
            end

            flashtime = ATTACK_BUTTON_FLASH_TIME - overtime

            local flashTexture = _G[self:GetName()..'Flash']
            if (flashTexture:IsShown()) then
                flashTexture:Hide()
            else
                flashTexture:Show()
            end
        end

        self.flashtime = flashtime
    end

    local rangeTimer = self.rangeTimer
    if (rangeTimer) then
        rangeTimer = rangeTimer - elapsed
        if (rangeTimer <= 0.1) then
            local isInRange = false
            if (ActionHasRange(self.action) and IsActionInRange(self.action) == 0) then
                _G[self:GetName()..'Icon']:SetVertexColor(0.9, 0, 0)
                isInRange = true
            end

            if (self.isInRange ~= isInRange) then
                self.isInRange = isInRange
                ActionButton_UpdateUsable(self)
            end

            rangeTimer = TOOLTIP_UPDATE_TIME
        end

        self.rangeTimer = rangeTimer
    end
end
hooksecurefunc('ActionButton_OnUpdate', ActionButton_OnUpdate)

local f = CreateFrame('Frame', MainMenuBar)
f:RegisterEvent('ADDON_LOADED')
f:SetScript('OnEvent', function()
    if (IsAddOnLoaded('tullaRange')) then
        if (not tullaRange) then
            return
        end

        function tullaRange.SetButtonColor(button, colorType)
            if (button.tullaRangeColor ~= colorType) then
                button.tullaRangeColor = colorType

                local r, g, b = tullaRange:GetColor(colorType)

                local icon =  _G[button:GetName()..'Icon']
                icon:SetVertexColor(r, g, b)
            end
        end
    end
    
    if C.ActionBars.Bar3 then
        SetActionBarToggles(1, 1, 0, 0, 1)
        SHOW_MULTI_ACTIONBAR_1 = 1
        SHOW_MULTI_ACTIONBAR_2 = 1
        InterfaceOptionsActionBarsPanelBottomLeft:SetChecked(1)
        InterfaceOptionsActionBarsPanelBottomRight:SetChecked(1)
        
        MultiActionBar_Update()
        InterfaceOptions_UpdateMultiActionBars()
    elseif C.ActionBars.Bar2 then
        if C.ActionBars.Bar3 then return end
        
        SetActionBarToggles(1, 0, 0, 0, 1)
        SHOW_MULTI_ACTIONBAR_1 = 1
        SHOW_MULTI_ACTIONBAR_2 = 0
        InterfaceOptionsActionBarsPanelBottomLeft:SetChecked(1)
        InterfaceOptionsActionBarsPanelBottomRight:SetChecked(0)
        
        MultiActionBar_Update()
        InterfaceOptions_UpdateMultiActionBars()
    else
        SetActionBarToggles(0, 0, 0, 0, 1)
        SHOW_MULTI_ACTIONBAR_1 = 0
        SHOW_MULTI_ACTIONBAR_2 = 0
        InterfaceOptionsActionBarsPanelBottomLeft:SetChecked(0)
        InterfaceOptionsActionBarsPanelBottomRight:SetChecked(0)
        
        MultiActionBar_Update()
        InterfaceOptions_UpdateMultiActionBars()
    end
end)

-- Experience bar mouseover text

MainMenuBarExpText:SetFont(C.Media.Font, 14, 'THINOUTLINE')
MainMenuBarExpText:SetShadowOffset(0, 0)

MainMenuBarExpText:SetAlpha(0)

MainMenuExpBar:HookScript('OnEnter', function()
    securecall('UIFrameFadeIn', MainMenuBarExpText, 0.2, MainMenuBarExpText:GetAlpha(), 1)
end)

MainMenuExpBar:HookScript('OnLeave', function()
    securecall('UIFrameFadeOut', MainMenuBarExpText, 0.2, MainMenuBarExpText:GetAlpha(), 0) 
end)

-- Shorten Hotkey display

local gsub = string.gsub

hooksecurefunc('ActionButton_UpdateHotkeys', function(self)
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

-- Rep bar mouseover text

ReputationWatchStatusBarText:SetFont(C.Media.Font, 14, 'THINOUTLINE')
ReputationWatchStatusBarText:SetShadowOffset(0, 0)

ReputationWatchStatusBarText:SetAlpha(0)

ReputationWatchBar:HookScript('OnEnter', function()
    securecall('UIFrameFadeIn', ReputationWatchStatusBarText, 0.2, ReputationWatchStatusBarText:GetAlpha(), 1)
end)

ReputationWatchBar:HookScript('OnLeave', function()
    securecall('UIFrameFadeOut', ReputationWatchStatusBarText, 0.2, ReputationWatchStatusBarText:GetAlpha(), 0) 
end)


-- Reduce the size of some main menu bar objects

for _, object in pairs({
    _G['MainMenuBar'],
    _G['MainMenuExpBar'],
    _G['MainMenuBarMaxLevelBar'],

    _G['ReputationWatchBar'],
    _G['ReputationWatchStatusBar'],
}) do
    if C.Panels.ABPanel then
        object:SetWidth(ABPanel:GetWidth())
    else
        object:SetWidth(512)
    end
    
    object:StripTextures()
end

MainMenuExpBar:SetTemplate()
MainMenuExpBar:SetHeight(13)
select(6, MainMenuExpBar:GetRegions()):SetTexture(C.Media.StatusBar)

-- Remove XP divider

for i = 1, 19, 2 do
    for _, object in pairs({
        _G['MainMenuXPBarDiv'..i],
    }) do
        hooksecurefunc(object, 'Show', function(self)
            self:Hide()
        end)

        object:Hide()
    end
end

hooksecurefunc(_G['MainMenuXPBarDiv2'], 'Show', function(self)
    local divWidth = MainMenuExpBar:GetWidth() / 10
    local xpos = divWidth - 4.5

    for i = 2, 19, 2 do
        local texture = _G['MainMenuXPBarDiv'..i]
        local xalign = floor(xpos)
        texture:SetPoint('LEFT', xalign, 1)
        xpos = xpos + divWidth
    end
end)

_G['MainMenuXPBarDiv2']:Show()

-- Move AltPowerBar
PlayerPowerBarAlt:SetPoint('TOP', ABPanel, 'BOTTOM', 0, -2)