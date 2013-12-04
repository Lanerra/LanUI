local F, C, G = unpack(select(2, ...))

if C.ActionBars.Bar2 == true then
    if C.Panels.ABPanel == true then
        local ABPanel = CreateFrame('Frame', 'ABPanel', UIParent)
    
        ABPanel:SetPoint('BOTTOM', UIParent, 0, 50)
        --ABPanel:SetSize((C.ActionBars.ButtonSize * 12) + (C.ActionBars.ButtonSpacing * 13), (C.ActionBars.ButtonSize * 1) + (C.ActionBars.ButtonSpacing * 2))
        ABPanel:SetWidth((C.ActionBars.ButtonSize * 12) + (C.ActionBars.ButtonSpacing * 14))
        ABPanel:SetHeight((C.ActionBars.ButtonSize * 2) + (C.ActionBars.ButtonSpacing * 4))
        ABPanel:SetFrameStrata('BACKGROUND')
        
        ABPanel:SetTemplate()
        
        for i = 1, 12 do
            _G['ActionButton'..i]:SetFrameStrata('HIGH')
            _G['MultiBarBottomLeftButton'..i]:SetFrameStrata('HIGH')
        end
    end
else
    return
end

MainMenuBar:SetScale(1)
OverrideActionBar:SetScale(0.8)
MultiBarBottomLeft:SetAlpha(1)
MultiBarBottomRight:SetAlpha(1)
MultiBarLeft:SetAlpha(1)
MultiBarLeft:SetScale(1)
MultiBarLeft:SetParent(UIParent)
MultiBarRight:SetAlpha(1)
MultiBarRight:SetScale(1)

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
    for i = 1, NUM_OVERRIDE_BUTTONS do
        local hotkey = _G['OverrideActionBarButton'..i..'HotKey']
        if (C.ActionBars.Hotkey) then
            hotkey:SetFont(C.Media.Font, 21, 'OUTLINE')
        else
            hotkey:Hide()
        end
        
        _G['OverrideActionBarButton'..i]:SetSize(C.ActionBars.ButtonSize, C.ActionBars.ButtonSize)
    end
end

hooksecurefunc('PetActionBar_Update', function()    
    for _, name in pairs({
        'PetActionButton',
        'PossessButton',    
        'StanceButton', 
    }) do
        for i = 1, 12 do
            local button = _G[name..i]
            local cast = _G[name..i..'AutoCastable']
            if (button) then
                if cast then
                    cast:SetAlpha(0)
                    cast.SetAlpha = F.Dummy
                end

                if (not button.Shadow) then
                    local normal = _G[name..i..'NormalTexture2'] or _G[name..i..'NormalTexture']
                    normal:ClearAllPoints()
                    normal:SetPoint('TOPRIGHT', button, 1, 1)
                    normal:SetPoint('BOTTOMLEFT', button, -1, -1)
                    normal:SetVertexColor(0, 0, 0, 0)
                    
                    local icon = _G[name..i..'Icon']
                    icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
                    icon:SetPoint('TOPRIGHT', button, 1, 1)
                    icon:SetPoint('BOTTOMLEFT', button, -1, -1)

                    local flash = _G[name..i..'Flash']
                    flash:SetTexture(flashtex)

                    local buttonBg = _G[name..i..'FloatingBG']
                    if (buttonBg) then
                        buttonBg:ClearAllPoints()
                        buttonBg:SetPoint('TOPRIGHT', button, 5, 5)
                        buttonBg:SetPoint('BOTTOMLEFT', button, -5, -5)
                        buttonBg:SetVertexColor(0, 0, 0, 0.5)
                        button.Shadow = true
                    else
                        button.Shadow = button:CreateTexture(nil, 'BACKGROUND')
                        button.Shadow:SetParent(button) 
                        button.Shadow:SetPoint('TOPRIGHT', normal, 4, 4)
                        button.Shadow:SetPoint('BOTTOMLEFT', normal, -4, -4)
                        button.Shadow:SetVertexColor(0, 0, 0, 0.5)
                    end
                end
            end
        end
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

StanceBarFrame:SetFrameStrata('HIGH')

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

local safety = CreateFrame('Frame')
safety:RegisterEvent('PLAYER_REGEN_ENABLED')
safety:RegisterEvent('PLAYER_LOGIN')
safety:SetScript('OnEvent', function()
    if C.Panels.ABPanel then
        PetActionBarFrame:SetWidth(ABPanel:GetWidth())
        PetActionBarFrame:SetHeight(C.ActionBars.ButtonSize + (C.ActionBars.ButtonSpacing * 2))
        PetActionBarFrame:ClearAllPoints()
        PetActionBarFrame:SetPoint('BOTTOM', ABPanel, 'TOP')
        PetActionBarFrame.ClearAllPoints = F.Dummy
        PetActionBarFrame.SetPoint = F.Dummy
        PetActionBarFrame:SetFrameStrata('HIGH')
    end
end)

if C.Panels.ABPanel then
    MultiBarBottomRight:SetPoint('TOP', ABPanel, 'BOTTOM', 0, -6)
    MainMenuExpBar:SetPoint('TOP', ABPanel, 'BOTTOM')
    
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
                    button:StyleButton()
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

-- Move the vehicle button

MainMenuBarVehicleLeaveButton:HookScript('OnShow', function(self)
    self:StripTextures()
    
    local x = self:CreateFontString(nil, 'ARTWORK')
    x:SetFont(C.Media.Font, C.Media.FontSize)
    x:SetText('X')
    
    self:SetTemplate()
    
    if C.Panels.ABPanel then
        self:SetPoint('TOPRIGHT', ABPanel, 'TOPLEFT', 5, 0)
    else
        self:SetPoint('LEFT', MainMenuBar, 'RIGHT', 10, 75)
    end
end)

local function hookPet()
    if C.Panels.ABPanel then
        if not InCombatLockdown() then
            for i = 1, 12 do
                local button = _G['PetActionButton'..i]

                if button then
                    button:SetSize(C.ActionBars.ButtonSize, C.ActionBars.ButtonSize)
                    button:StyleButton()
                end
            end
            
            for i = 2, 12 do
                local pet = _G['PetActionButton'..i]
                local lastpet = _G['PetActionButton'..i-1]
                
                if pet then
                    pet:SetPoint('LEFT', lastpet, 'RIGHT', C.ActionBars.ButtonSpacing, 0)
                end
            end
        end
    end
end

for i = 1, 10 do
    local pet = _G['PetActionButton'..i]
    hooksecurefunc(pet, 'Show', hookPet)
end

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
button:GetParent():SetPoint('BOTTOM', PetActionBarFrame, 'TOP')
button:GetParent().ClearAllPoints = F.Dummy
button:GetParent().SetPoint = F.Dummy

hooksecurefunc(texture, 'SetTexture', disableTexture)

button:StyleButton()