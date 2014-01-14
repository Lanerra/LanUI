local F, C, G = unpack(select(2, ...))

MainMenuBar:SetScale(1)
OverrideActionBar:SetScale(0.8)
MultiBarBottomLeft:SetAlpha(1)
MultiBarBottomRight:SetAlpha(1)
MultiBarLeft:SetAlpha(1)
MultiBarLeft:SetScale(1)
MultiBarLeft:SetParent(UIParent)
MultiBarRight:SetAlpha(1)
MultiBarRight:SetScale(1)

-- Kill Blizzard options for ActionBars
--[[InterfaceOptionsActionBarsPanelBottomLeft:Kill()
InterfaceOptionsActionBarsPanelBottomRight:Kill()
InterfaceOptionsActionBarsPanelRight:Kill()
InterfaceOptionsActionBarsPanelRightTwo:Kill()
InterfaceOptionsActionBarsPanelAlwaysShowActionBars:Kill()]]

local _G, pairs, unpack = _G, pairs, unpack
local path = 'Interface\\AddOns\\LanUI\\Media\\'

local function IsSpecificButton(self, name)
    local sbut = self:GetName():match(name)
    if (sbut) then
        return true
    else
        return false
    end
end

local function UpdateVehicleButton()
    if not InCombatLockdown() then
        for i = 1, NUM_OVERRIDE_BUTTONS do
            local hotkey = _G['OverrideActionBarButton'..i..'HotKey']
            if (C.ActionBars.Hotkey) then
                hotkey:SetFont(C.Media.Font, 21, 'OUTLINE')
            else
                hotkey:Hide()
            end
            
            _G['OverrideActionBarButton'..i]:SetSize(C.ActionBars.ButtonSize, C.ActionBars.ButtonSize)
            _G['OverrideActionBarButton'..i]:SetNormalTexture(nil)
        end
    end
end

PetActionBarFrame:EnableMouse(false)
PetActionBarFrame:UnregisterAllEvents()
PetActionBarFrame:Hide()
PetActionBarFrame:SetAlpha(0)

local petbaranchor = CreateFrame('Frame', 'PetActionBarAnchor', LanUIPetBattleHider)
petbaranchor:SetFrameStrata('BACKGROUND')
petbaranchor:SetSize((C.ActionBars.ButtonSize * 10) + (C.ActionBars.ButtonSpacing * 9), (C.ActionBars.ButtonSize + C.ActionBars.ButtonSpacing))

if C.Panels.ABPanel then
    petbaranchor:SetPoint('BOTTOM', ABPanel, 'TOP', 0, 2)
else
    petbaranchor:SetPoint('BOTTOMLEFT', ActionButton1, 'TOPRIGHT', 0, 5)
end

local bar = CreateFrame('Frame', 'LanPetHolder', UIParent, 'SecureHandlerStateTemplate')
bar:SetAllPoints(PetActionBarAnchor)

bar:RegisterEvent('PLAYER_LOGIN')
bar:RegisterEvent('PLAYER_CONTROL_LOST')
bar:RegisterEvent('PLAYER_CONTROL_GAINED')
bar:RegisterEvent('PLAYER_ENTERING_WORLD')
bar:RegisterEvent('PLAYER_FARSIGHT_FOCUS_CHANGED')
bar:RegisterEvent('PET_BAR_UPDATE')
bar:RegisterEvent('PET_BAR_UPDATE_USABLE')
bar:RegisterEvent('PET_BAR_UPDATE_COOLDOWN')
bar:RegisterEvent('PET_BAR_HIDE')
bar:RegisterEvent('UNIT_PET')
bar:RegisterEvent('UNIT_FLAGS')
bar:RegisterEvent('UNIT_AURA')
bar:SetScript('OnEvent', function(self, event, arg1)
	if event == 'PLAYER_LOGIN' then
		PetActionBarFrame.showgrid = 1
		
        for i = 1, 10 do
			local button = _G['PetActionButton'..i]
			button:ClearAllPoints()
			button:SetParent(LanPetHolder)
			button:SetSize(C.ActionBars.ButtonSize, C.ActionBars.ButtonSize)
			if i == 1 then
				button:SetPoint('BOTTOMLEFT', 0, 0)
			else
				button:SetPoint('LEFT', _G['PetActionButton'..i-1], 'RIGHT', C.ActionBars.ButtonSpacing, 0)
			end
		
            button:SetFrameStrata('BACKGROUND')
            
            button:Show()
            button:StyleButton()
            button:SetTemplate(true)
            button:SetBeautyBorderPadding(2)
            
			self:SetAttribute('addchild', button)
		end
        
		RegisterStateDriver(self, 'visibility', '[pet,novehicleui,nopossessbar,nopetbattle] show; hide')
        
        
		hooksecurefunc('PetActionBar_Update', F.PetBarUpdate)
	elseif event == 'PET_BAR_UPDATE' or event == 'PLAYER_CONTROL_LOST' or event == 'PLAYER_CONTROL_GAINED' or event == 'PLAYER_FARSIGHT_FOCUS_CHANGED' or event == 'UNIT_FLAGS' or (event == 'UNIT_PET' and arg1 == 'player') or (arg1 == 'pet' and event == 'UNIT_AURA') then
		F.PetBarUpdate()
	elseif event == 'PET_BAR_UPDATE_COOLDOWN' then
		PetActionBar_UpdateCooldowns()
	else
		F.StylePet()
	end
end)

-- Force an update for StanceButton for those who doesn't have pet bar
securecall('PetActionBar_Update')

hooksecurefunc('ActionButton_Update', function(self)
    if (IsSpecificButton(self, 'MultiCast')) then
        for _, icon in pairs({
            self:GetName(),
            'MultiCastRecallSpellButton',
            'MultiCastSummonSpellButton',
        }) do
            local button = _G[icon]
            
            if (not button.Shadow) then
                local icon = _G[self:GetName()..'Icon']
                icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)

                button.Shadow = button:CreateTexture(nil, 'BACKGROUND')
                button.Shadow:SetParent(button)  
                button.Shadow:SetPoint('TOPRIGHT', button, 4.5, 4.5)
                button.Shadow:SetPoint('BOTTOMLEFT', button, -4.5, -4.5)
                button.Shadow:SetVertexColor(0, 0, 0, 0)
            end
        end
    elseif (not IsSpecificButton(self, 'ExtraActionButton')) then
        local button = _G[self:GetName()]
        
        if (not button.Background) then
            local icon = _G[self:GetName()..'Icon']
            icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)

            local count = _G[self:GetName()..'Count']
            if (count) then
                count:SetPoint('BOTTOMRIGHT', button, 0, 1)
                count:SetFont(C.Media.Font, 15, 'OUTLINE')
            end

            local macroname = _G[self:GetName()..'Name']
            if (macroname) then
                if not C.ActionBars.Macro then
                    macroname:SetAlpha(0)
                else
                    macroname:SetWidth(button:GetWidth() + 15)
                    macroname:SetFont(C.Media.Font, 17, 'OUTLINE')
                end
            end

            local buttonBg = _G[self:GetName()..'FloatingBG']
            if (buttonBg) then
                buttonBg:ClearAllPoints()
                buttonBg:SetPoint('TOPRIGHT', button, 5, 5)
                buttonBg:SetPoint('BOTTOMLEFT', button, -5, -5)
                buttonBg:SetVertexColor(0, 0, 0, 0)
            end

            button.Background = button:CreateTexture(nil, 'BACKGROUND', nil, -8)
            button.Background:SetTexture(path..'textureBackground')
            button.Background:SetPoint('TOPRIGHT', button, 14, 12)
            button.Background:SetPoint('BOTTOMLEFT', button, -14, -16)
            
            button:StyleButton()
            button:SetTemplate(true)
            button:SetBeautyBorderPadding(2)
        end

        local border = _G[self:GetName()..'Border']
        if (border) then
            if (IsEquippedAction(self.action)) then
                _G[self:GetName()..'Border']:SetAlpha(1)
            else
                _G[self:GetName()..'Border']:SetAlpha(0)
            end
        end
    end
end)

hooksecurefunc('ActionButton_ShowGrid', function(self)
    local normal = _G[self:GetName()..'NormalTexture']
    
    if normal then
        normal:SetVertexColor(0, 0, 0, 0)
    end
end)

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

hooksecurefunc('ActionButton_UpdateHotkeys', function(self)
    local hotkey = _G[self:GetName()..'HotKey']

    if (not IsSpecificButton(self, 'OverrideActionBarButton')) then
        if (C.ActionBars.Hotkey) then
            hotkey:ClearAllPoints()
            hotkey:SetPoint('TOPRIGHT', self, 0, -3)
            hotkey:SetFont(C.Media.Font, 18, 'OUTLINE')
        else
            hotkey:Hide()    
        end
    else
        UpdateVehicleButton()
    end
end)

function ActionButton_OnUpdate(self, elapsed)
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

PetActionBarFrame:SetScale(1)
PetActionBarFrame:SetAlpha(1)

PossessBarFrame:SetScale(1)
PossessBarFrame:SetAlpha(1)

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

StanceBarFrame:SetFrameStrata('BACKGROUND')

StanceBarFrame:SetScale(1)
StanceBarFrame:SetAlpha(1)

-- Disable automatic frame position

do
    for _, frame in pairs({
        'MultiBarLeft',
        'MultiBarRight',
        'MultiBarBottomRight',
        'PossessBarFrame',
        'MULTICASTACTIONBAR_YPOS',
        'MultiCastActionBarFrame',
        'PETACTIONBAR_YPOS',
    }) do
        UIPARENT_MANAGED_FRAME_POSITIONS[frame] = nil
    end
end

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

-- Move BottomRight bar underneath BottomLeft

MultiBarBottomRight:EnableMouse(false)

MultiBarBottomRightButton1:ClearAllPoints()

if C.Panels.ABPanel then
    MultiBarBottomRight:SetPoint('TOP', ABPanel, 'BOTTOM', 0, -6)
    MainMenuExpBar:SetPoint('TOP', ABPanel, 'BOTTOM', 0, -2)
    
    OverrideActionBar:SetAllPoints(ABPanel)
    
    for i = 1, 6 do
        local over = _G['OverrideActionBarButton'..i]
        local lastover = _G['OverrideActionBarButton'..i-1]
        
        if i == 1 then
            over:SetPoint('CENTER', ABPanel, -((C.ActionBars.ButtonSize * 3) - C.ActionBars.ButtonSpacing), 0)
        else
            over:SetPoint('LEFT', lastover, 'RIGHT', C.ActionBars.ButtonSpacing, 0)
        end
        
        over:SetSize(C.ActionBars.ButtonSize, C.ActionBars.ButtonSize)
        over:SetScale(2)
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

                if button then
                    button:SetSize(C.ActionBars.ButtonSize, C.ActionBars.ButtonSize)
                    button:SetFrameStrata('BACKGROUND')
                    button:StyleButton()
                    button:SetTemplate(true)
                    button:SetBeautyBorderPadding(2)
                end
            end
            
            for i = 2, 12 do
                local action = _G['ActionButton'..i]
                local lastact = _G['ActionButton'..i-1]
                local left = _G['MultiBarBottomLeftButton'..i]
                local lastleft = _G['MultiBarBottomLeftButton'..i-1]
                local right = _G['MultiBarBottomRightButton'..i]
                local lastright = _G['MultiBarBottomRightButton'..i-1]
                
                ActionButton1:ClearAllPoints()
                ActionButton1:SetPoint('TOPLEFT', ABPanel, 6, -6)
                MultiBarBottomLeftButton1:ClearAllPoints()
                MultiBarBottomLeftButton1:SetPoint('TOPLEFT', ActionButton1, 'BOTTOMLEFT', 0, -C.ActionBars.ButtonSpacing)
                
                action:SetPoint('LEFT', lastact, 'RIGHT', C.ActionBars.ButtonSpacing, 0)
                left:SetPoint('LEFT', lastleft, 'RIGHT', C.ActionBars.ButtonSpacing, 0)
                right:SetPoint('LEFT', lastright, 'RIGHT', C.ActionBars.ButtonSpacing, 0)
            end
        end
    end
else
    MultiBarBottomRightButton1:SetPoint('BOTTOMLEFT', MultiBarBottomLeftButton1, 'TOPLEFT', 0, 6)
end

-- Move and skin the vehicle button
local VB = MainMenuBarVehicleLeaveButton

VB:ClearAllPoints()
if C.Panels.ABPanel then
    VB:SetParent(ABPanel)
    VB:SetPoint('TOPRIGHT', ABPanel, 'TOPLEFT', -1, -1)
else
    VB:SetPoint('LEFT', MainMenuBar, 'RIGHT', 10, 75)
end
VB.SetPoint = F.Dummy

VB:StripTextures()

VB:SetTemplate()
VB:SetBackdropColor(1, 0, 0, 0.5)
VB:SetSize(C.Media.FontSize, C.Media.FontSize)

-- Strip and skin the ExtraActionButton
local button = ExtraActionButton1
local texture = button.style

local disableTexture = function(style, texture)
    if texture then
        style:SetTexture(nil)
    end
end

button.style:SetTexture(nil)
ExtraActionButton1Icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)

local normal = ExtraActionButton1NormalTexture2 or ExtraActionButton1NormalTexture
normal:SetVertexColor(0, 0, 0, 0)

button:GetParent():ClearAllPoints()
button:GetParent():SetPoint('BOTTOM', PetActionBarAnchor, 'TOP')
button:GetParent().ClearAllPoints = F.Dummy
button:GetParent().SetPoint = F.Dummy
button:SetPoint('BOTTOM', button:GetParent())
button:SetSize(32, 32)

hooksecurefunc(texture, 'SetTexture', disableTexture)

button:StyleButton()
button:SetTemplate(true)
button:SetBeautyBorderPadding(2)

-- Position and skin StanceBarFrame

-- Move AltPowerBar
PlayerPowerBarAlt:SetPoint('TOP', ABPanel, 'BOTTOM', 0, -2)