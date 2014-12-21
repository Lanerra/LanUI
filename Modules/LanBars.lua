local F, C, G = unpack(select(2, ...))

local _G = _G
local IsUsableAction = IsUsableAction
local IsActionInRange = IsActionInRange
local HasAction = HasAction
local bc = C.Media.BorderColor

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
frame:SetScale(1)

MainMenuBarArtFrame:SetParent(frame)
MainMenuBarArtFrame:EnableMouse(false)

for i = 1, num do
	local button = _G['ActionButton'..i]
	table.insert(buttonList, button)
	button:SetSize(C.ActionBars.ButtonSize, C.ActionBars.ButtonSize)
	button:ClearAllPoints()
    
	if not button.backdrop then
		button:CreateBD()
		button.icon:SetTexCoord(unpack(F.TexCoords))
		button.icon:SetInside()
		button.icon:SetDrawLayer('BACKGROUND', 7)
		--button.icon:SetParent(button.backdrop)
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
local bar2 = CreateFrame('Frame', 'LanBar2', UIParent, 'SecureHandlerStateTemplate') -- MultiBarBottomLeft
bar2:SetWidth(num * C.ActionBars.ButtonSize + (num - 1) * C.ActionBars.ButtonSpacing + 2 * C.ActionBars.ButtonSpacing)
bar2:SetHeight(C.ActionBars.ButtonSize + C.ActionBars.ButtonSpacing)
bar2:SetScale(1)

MultiBarBottomLeft:SetParent(bar2)
MultiBarBottomLeft:EnableMouse(false)

for i = 1, num do
    local button = _G['MultiBarBottomLeftButton'..i]
    table.insert(buttonList, button)
    button:SetSize(C.ActionBars.ButtonSize, C.ActionBars.ButtonSize)
    button:ClearAllPoints()
    
    if not button.backdrop then
        button:CreateBD()
		button.icon:SetTexCoord(unpack(F.TexCoords))
		button.icon:SetInside()
		button.icon:SetDrawLayer('BACKGROUND', 7)
		button.backdrop:SetFrameLevel(5)
		--button.icon:SetParent(button.backdrop)
        button:SetBeautyBorderPadding(2)
    end
    
    if i == 1 then
        button:SetPoint('BOTTOMLEFT', bar2, C.ActionBars.ButtonSpacing, C.ActionBars.ButtonSpacing)
    else
        local previous = _G['MultiBarBottomLeftButton'..i - 1]
        button:SetPoint('LEFT', previous, 'RIGHT', C.ActionBars.ButtonSpacing, 0)
    end
    
    button:StyleButton()
end

-- Show/Hide
RegisterStateDriver(bar2, 'visibility', '[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists] hide; show')

-- Bar 3
local bar3 = CreateFrame('Frame', 'LanBar3', UIParent, 'SecureHandlerStateTemplate') -- MultiBarBottomRight
bar3:SetWidth(num * C.ActionBars.ButtonSize + (num - 1) * C.ActionBars.ButtonSpacing + 2 * C.ActionBars.ButtonSpacing)
bar3:SetHeight(C.ActionBars.ButtonSize + C.ActionBars.ButtonSpacing)
bar3:SetScale(1)

MultiBarBottomRight:SetParent(bar3)
MultiBarBottomRight:EnableMouse(false)

for i = 1, num do
    local button = _G['MultiBarBottomRightButton'..i]
    table.insert(buttonList, button)
    button:SetSize(C.ActionBars.ButtonSize, C.ActionBars.ButtonSize)
    button:ClearAllPoints()
    
    if not button.backdrop then
        button:CreateBD()
		button.icon:SetTexCoord(unpack(F.TexCoords))
		button.icon:SetInside()
		button.icon:SetDrawLayer('BACKGROUND', 7)
		--button.icon:SetParent(button.backdrop)
        button:SetBeautyBorderPadding(2)
    end
    
    if i == 1 then
        button:SetPoint('BOTTOMLEFT', bar3, C.ActionBars.ButtonSpacing, C.ActionBars.ButtonSpacing)
    else
        local previous = _G['MultiBarBottomRightButton'..i - 1]
        button:SetPoint('LEFT', previous, 'RIGHT', C.ActionBars.ButtonSpacing, 0)
    end
    
    button:StyleButton()
end

-- Show/Hide
RegisterStateDriver(frame, 'visibility', '[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists] hide; show')

local function PositionBars()
	if InCombatLockdown() then return end

	local leftShown, rightShown = MultiBarBottomLeft:IsShown(), MultiBarBottomRight:IsShown()

	if leftShown and rightShown then
		LanBar3:SetPoint('TOP', LanBar2, 'BOTTOM')
		LanBar2:SetPoint('TOP', LanBar1, 'BOTTOM')
        ABPanel:SetHeight((C.ActionBars.ButtonSize * 3) + (C.ActionBars.ButtonSpacing * 5))
		
        if C.Panels.ABPanel then
            LanBar1:SetPoint('TOPLEFT', ABPanel, 2, -2)
        else
            LanBar1:SetPoint('BOTTOM', UIParent, 0, 200)
        end
	elseif leftShown then
		LanBar2:SetPoint('TOP', LanBar1, 'BOTTOM')
        ABPanel:SetHeight((C.ActionBars.ButtonSize * 2) + (C.ActionBars.ButtonSpacing * 4))
		
        if C.Panels.ABPanel then
            LanBar1:SetPoint('TOPLEFT', ABPanel, 2, -2)
        else
            LanBar1:SetPoint('BOTTOM', UIParent, 0, 200)
        end
	elseif rightShown then
		LanBar3:SetPoint('TOP', LanBar1, 'BOTTOM')
        ABPanel:SetHeight((C.ActionBars.ButtonSize * 3) + (C.ActionBars.ButtonSpacing * 5))
		
        if C.Panels.ABPanel then
            LanBar1:SetPoint('TOPLEFT', ABPanel, 2, -2)
        else
            LanBar1:SetPoint('BOTTOM', UIParent, 0, 200)
        end
    else
        ABPanel:SetHeight(C.ActionBars.ButtonSize + (C.ActionBars.ButtonSpacing * 3))
        
        if C.Panels.ABPanel then
            LanBar1:SetPoint('TOPLEFT', ABPanel, 2, -2)
        else
            LanBar1:SetPoint('BOTTOM', UIParent, 0, 200)
        end
    end
end

hooksecurefunc("MultiActionBar_Update", PositionBars)

-- Right Bar 1

local bar4 = CreateFrame("Frame", "LanMultiBarRight", UIParent, "SecureHandlerStateTemplate")
bar4:SetHeight(num * C.ActionBars.ButtonSize + (num - 1) * C.ActionBars.ButtonSpacing + 2 * C.ActionBars.ButtonSpacing)
bar4:SetWidth(C.ActionBars.ButtonSize + C.ActionBars.ButtonSpacing)
bar4:SetScale(1)
bar4:SetPoint("RIGHT", -30, 0)

MultiBarRight:SetParent(bar4)
MultiBarRight:EnableMouse(false)

for i = 1, NUM_ACTIONBAR_BUTTONS do
	local button = _G["MultiBarRightButton"..i]
    table.insert(buttonList, button)
	button:SetSize(C.ActionBars.ButtonSize, C.ActionBars.ButtonSize)
    button:ClearAllPoints()
	
    if not button.backdrop then
        button:CreateBD()
		button.icon:SetTexCoord(unpack(F.TexCoords))
		button.icon:SetInside()
		button.icon:SetDrawLayer('BACKGROUND', 7)
		--button.icon:SetParent(button.backdrop)
        button:SetBeautyBorderPadding(2)
    end
    
    if i == 1 then
		button:SetPoint("TOPLEFT", bar4)
	else
		local previous = _G["MultiBarRightButton"..i - 1]
		button:SetPoint("TOP", previous, "BOTTOM", 0, -C.ActionBars.ButtonSpacing)
	end
    
    button:StyleButton()
end

-- Show/Hide
RegisterStateDriver(bar4, "visibility", "[petbattle][vehicleui][overridebar][possessbar,@vehicle,exists] hide; show")

-- Right Bar 2

local bar5 = CreateFrame("Frame", "LanMultiBarLeft", UIParent, "SecureHandlerStateTemplate")
bar5:SetHeight(num * C.ActionBars.ButtonSize + (num - 1) * C.ActionBars.ButtonSpacing + 2 * C.ActionBars.ButtonSpacing)
bar5:SetWidth(C.ActionBars.ButtonSize + C.ActionBars.ButtonSpacing)
bar5:SetScale(1)
bar5:SetPoint("RIGHT", -57 - C.ActionBars.ButtonSpacing, 0)

MultiBarLeft:SetParent(bar5)
MultiBarLeft:EnableMouse(false)

for i = 1, NUM_ACTIONBAR_BUTTONS do
	local button = _G["MultiBarLeftButton"..i]
    table.insert(buttonList, button)
	button:SetSize(C.ActionBars.ButtonSize, C.ActionBars.ButtonSize)
	button:ClearAllPoints()
    
    if not button.backdrop then
        button:CreateBD()
		button.icon:SetTexCoord(unpack(F.TexCoords))
		button.icon:SetInside()
		button.icon:SetDrawLayer('BACKGROUND', 7)
		--button.icon:SetParent(button.backdrop)
        button:SetBeautyBorderPadding(2)
    end
    
	if i == 1 then
		button:SetPoint("TOPLEFT", bar5)
	else
		local previous = _G["MultiBarLeftButton"..i-1]
		button:SetPoint("TOP", previous, "BOTTOM", 0, -C.ActionBars.ButtonSpacing)
	end
    
    button:StyleButton()
end

-- Show/Hide
RegisterStateDriver(bar5, "visibility", "[petbattle][vehicleui][overridebar][possessbar,@vehicle,exists] hide; show")

-- LeaveVehicle Button
--[[local button = CreateFrame('BUTTON', 'LanLeave', ABPanel or ChatFrame1, 'SecureHandlerClickTemplate, SecureHandlerStateTemplate');
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

if not button.backdrop then
	button:CreateBD()
    button:SetBackdropColor(1, 0, 0, 0.5)
end]]

-- Show/Hide
--RegisterStateDriver(button, 'visibility', '[petbattle][overridebar][vehicleui] hide; [possessbar][@vehicle,exists] show; hide')

-- Override Bar
local override = CreateFrame('Frame', 'LanOverride', UIParent, 'SecureHandlerStateTemplate')
override:SetWidth(num * C.ActionBars.ButtonSize + (num - 1) * C.ActionBars.ButtonSpacing + 2 * C.ActionBars.ButtonSpacing)
override:SetHeight(C.ActionBars.ButtonSize + 2 * C.ActionBars.ButtonSpacing)
override:SetPoint('BOTTOM', LanBar2, 'TOP')

override:SetScale(0.8)

OverrideActionBar:SetParent(override)
OverrideActionBar:EnableMouse(false)
OverrideActionBar:SetScript('OnShow', nil) -- Kill OnShow

local leaveButtonPlaced = false

for i = 1, 7 do
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
    
	if not button.backdrop then
		button:CreateBD()
		--button.icon:SetTexCoord(unpack(F.TexCoords))
		--button.icon:SetInside()
		--button.icon:SetDrawLayer('BACKGROUND', 7)
		--button.icon:SetParent(button.backdrop)
        button:SetBeautyBorderPadding(2)
	end
    
	if i == 1 then
		button:SetPoint('BOTTOMLEFT', override, C.ActionBars.ButtonSpacing, C.ActionBars.ButtonSpacing)
	else
		local previous = _G['OverrideActionBarButton'..i - 1]
		button:SetPoint('LEFT', previous, 'RIGHT', C.ActionBars.ButtonSpacing, 0)
	end
    
    button:StyleButton()
end

-- Show/Hide
RegisterStateDriver(override, 'visibility', '[petbattle] hide; [overridebar][vehicleui][possessbar,@vehicle,exists] show; hide')
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

_G['ExtraActionButton1']:CreateBD()
_G['ExtraActionButton1']:SetBeautyBorderPadding(2)
_G['ExtraActionButton1']:StyleButton()
_G['ExtraActionButton1HotKey']:Hide()

local normal = ExtraActionButton1NormalTexture
local normal2 = ExtraActionButton1NormalTexture2
hooksecurefunc(ExtraActionButton1, 'SetNormalTexture', function()
	if normal then
		ExtraActionButton1NormalTexture:SetTexture(nil)
	elseif normal2 then
		ExtraActionButton1NormalTexture2:SetTexture(nil)
	end
end)


local button = DraenorZoneAbilityFrame.SpellButton
if button then
	button:SetNormalTexture('')
	button:StyleButton()
	button:CreateBD()
	button.backdrop:SetOutside(button)
	button.Icon:SetDrawLayer('ARTWORK')
	button.Icon:SetTexCoord(unpack(F.TexCoords))
	button.Icon:SetInside()
	select(2, select(1, DraenorZoneAbilityFrame:GetChildren()):GetRegions()):Hide()
	--select(1, select(1, DraenorZoneAbilityFrame:GetChildren()):GetRegions()):CreateBD()
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
    
	if not button.backdrop then
		button:CreateBD()
		button.icon:SetTexCoord(unpack(F.TexCoords))
		button.icon:SetInside()
		button.icon:SetDrawLayer('BACKGROUND', 7)
		--button.icon:SetParent(button.backdrop)
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
    
	if not button.backdrop then
		button:CreateBD()
		button.icon:SetTexCoord(unpack(F.TexCoords))
		button.icon:SetInside()
		button.icon:SetDrawLayer('BACKGROUND', 7)
		--button.icon:SetParent(button.backdrop)
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
local petbar = CreateFrame('Frame', 'LanPet', UIParent, 'SecureHandlerStateTemplate')
petbar:SetWidth(num * C.ActionBars.ButtonSize + (num - 1) * C.ActionBars.ButtonSpacing + 2 * C.ActionBars.ButtonSpacing)
petbar:SetHeight(C.ActionBars.ButtonSize + 2 * C.ActionBars.ButtonSpacing)

if C.Panels.ABPanel then
    petbar:SetPoint('BOTTOM', ABPanel, 'TOP')
else
    petbar:SetPoint('BOTTOMLEFT', ActionButton1, 'TOPRIGHT', 0, 5)
end

petbar:SetScale(1)

PetActionBarFrame:SetParent(petbar)
PetActionBarFrame:EnableMouse(false)
PetActionBarFrame:SetHeight(0.001)

for i = 1, NUM_PET_ACTION_SLOTS do
	local button = _G['PetActionButton'..i]
    local cd = _G["PetActionButton"..i.."Cooldown"]
    
	table.insert(buttonList, button)
	button:SetSize(C.ActionBars.ButtonSize, C.ActionBars.ButtonSize)
	button:ClearAllPoints()
    
	if not button.backdrop then
		button:CreateBD()
		button.icon:SetTexCoord(unpack(F.TexCoords))
		button.icon:SetInside()
		button.icon:SetDrawLayer('BACKGROUND', 7)
		button.backdrop:SetOutside()
		--button.icon:SetParent(button.backdrop)
        button:SetBeautyBorderPadding(2)
	end
    
	if i == 1 then
		button:SetPoint('LEFT', petbar, C.ActionBars.ButtonSpacing, 0)
	else
		local previous = _G['PetActionButton'..i - 1]
		button:SetPoint('LEFT', previous, 'RIGHT', C.ActionBars.ButtonSpacing, 0)
	end
    
	-- Cooldown fix
	local cd = _G['PetActionButton'..i..'Cooldown']
	cd:SetAllPoints(button)
    
    _G['PetActionButton'..i..'HotKey']:Hide()
    
    F.StylePet()
    hooksecurefunc('PetActionBar_Update', F.PetBarUpdate)
end

-- Show/Hide
RegisterStateDriver(petbar, 'visibility', '[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists] hide; [@pet,exists,nomounted] show; hide')

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
    
	local Button = self
    local Name = self:GetName()
	local Icon = self.icon
    local NormalTexture = self.normalTexture
	local Flash	 = _G[Name.."Flash"]
    local ID = self.action
    local IsUsable, NotEnoughMana = IsUsableAction(ID)
	local HasRange = ActionHasRange(ID)
	local InRange = IsActionInRange(ID)
	local Border  = _G[Name.."Border"]
	local Normal  = _G[Name.."NormalTexture"]
	local BtnBG = _G[Name.."FloatingBG"]
	
	Flash:SetTexture("")
	Button:SetNormalTexture("")
	
	if Button.backdrop then
		Button.backdrop:SetOutside()
	end
	
	if Border and Button.isSkinned then
		Border:SetTexture('')
		if Border:IsShown() then
			Button:SetBackdropBorderColor(.08, .70, 0)
		else
			Button:SetBackdropBorderColor(bc.r, bc.g, bc.b)
		end
	end
	
	if Button.isSkinned then
		return
	end
	
	if BtnBG then
		BtnBG:Kill()
	end
	
	Icon:SetTexCoord(unpack(F.TexCoords))
	Icon:SetInside()
	Icon:SetDrawLayer('BACKGROUND', 7)
	
	--[[if (Normal) then
		Normal:ClearAllPoints()
		Normal:SetPoint("TOPLEFT", 1, -1)
		Normal:SetPoint("BOTTOMRIGHT", -1, 1)
		
		if (Button:GetChecked()) then
			ActionButton_UpdateState(Button)
		end
	end]]

    if (not NormalTexture) or Name == 'OverrideActionBarButton1' then
        return
    end
    
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
	
	Button.isSkinned = true
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

local Experience = CreateFrame("Frame", nil, UIParent)
local HideTooltip = GameTooltip_Hide
local Bars = 20

Experience.NumBars = 1
Experience.RestedColor = {75/255, 175/255, 76/255}
Experience.XPColor = {0/255, 144/255, 255/255}

function Experience:SetTooltip()
	local Current, Max = Experience:GetExperience()
	local Rested = GetXPExhaustion()
	
	GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT", 0, 5)
	
	GameTooltip:AddLine(string.format("|cff0090FF"..XP..": %d / %d (%d%% - %d/%d)|r", Current, Max, Current / Max * 100, Bars - (Bars * (Max - Current) / Max), Bars))
	
	if Rested then
		GameTooltip:AddLine(string.format("|cff4BAF4C"..TUTORIAL_TITLE26..": +%d (%d%%)|r", Rested, Rested / Max * 100))
	end
	
	GameTooltip:Show()
end

function Experience:GetExperience()
	return UnitXP("player"), UnitXPMax("player")
end

function Experience:Update(event, owner)
	if F.Level == MAX_PLAYER_LEVEL then
		self:Disable()
		
		return
	else
        self:UnregisterEvent("UPDATE_EXPANSION_LEVEL")
		self:Enable()
	end
	
	local Current, Max = self:GetExperience()
	local Rested = GetXPExhaustion()
	local IsRested = GetRestState()
	
	for i = 1, self.NumBars do
		self["XPBar"..i]:SetMinMaxValues(0, Max)
		self["XPBar"..i]:SetValue(Current)
		
		if (IsRested == 1 and Rested) then
			self["RestedBar"..i]:SetMinMaxValues(0, Max)
			self["RestedBar"..i]:SetValue(Rested + Current)
		else
            self["RestedBar"..i]:SetMinMaxValues(0, 1)
			self["RestedBar"..i]:SetValue(0)
		end
	end
end

function Experience:Create()
	for i = 1, self.NumBars do
		local XPBar = CreateFrame("StatusBar", nil, UIParent)
		local RestedBar = CreateFrame("StatusBar", nil, UIParent)
		
		XPBar:SetStatusBarTexture(C.Media.StatusBar)
		XPBar:SetStatusBarColor(bc.r, bc.g, bc.b)
		XPBar:EnableMouse()
        XPBar:SetFrameStrata("MEDIUM")
        XPBar:SetFrameLevel(4)
		XPBar:CreateBD()
		XPBar:SetScript("OnEnter", Experience.SetTooltip)
		XPBar:SetScript("OnLeave", HideTooltip)
		
		RestedBar:SetStatusBarTexture(C.Media.StatusBar)
		RestedBar:SetStatusBarColor(unpack(self.RestedColor))
		RestedBar:SetAllPoints(XPBar)
		RestedBar:SetFrameLevel(XPBar:GetFrameLevel() - 1)
		RestedBar:SetAlpha(.5)
		
        XPBar:Size(512, 10)
        XPBar:Point('BOTTOM', BottomPanel, 'TOP', 0, 4)
		XPBar.backdrop:ClearAllPoints()
		XPBar.backdrop:Point('TOPLEFT', XPBar, -3, 2)
		XPBar.backdrop:Point('BOTTOMRIGHT', XPBar, 3, -3)
		
		self["XPBar"..i] = XPBar
		self["RestedBar"..i] = RestedBar
	end
	
	self:RegisterEvent("PLAYER_XP_UPDATE")
	self:RegisterEvent("PLAYER_LEVEL_UP")
	self:RegisterEvent("UPDATE_EXHAUSTION")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("PLAYER_UPDATE_RESTING")
    self:RegisterEvent("UPDATE_EXPANSION_LEVEL")
	
	self:SetScript("OnEvent", self.Update)
end

function Experience:Enable()
	if not self.IsCreated then
		self:Create()
		
		self.IsCreated = true
	end
	
	for i = 1, self.NumBars do
		if not self["XPBar"..i]:IsShown() then
			self["XPBar"..i]:Show()
		end
		
		if not self["RestedBar"..i]:IsShown() then
			self["RestedBar"..i]:Show()
		end
	end	
end

function Experience:Disable()
	for i = 1, self.NumBars do
		if self["XPBar"..i]:IsShown() then
			self["XPBar"..i]:Hide()
		end
		
		if self["RestedBar"..i]:IsShown() then
			self["RestedBar"..i]:Hide()
		end
	end
end

Experience:Enable()

--[[local XP = CreateFrame('Frame', 'LanXP', BottomPanel)
XP:SetPoint('BOTTOM', BottomPanel, 'TOP', 0, 2)
XP:SetWidth(512)
XP:SetHeight(13)

XP:CreateBD()

local font = CreateFont('LanXPFont')
font:SetFontObject(GameFontHighlightSmall)
font:SetTextColor(bc.r, bc.g, bc.b)

local indicator = XP:CreateTexture(nil, 'OVERLAY')
indicator:SetWidth(1)
indicator:SetTexture(bc.r, bc.g, bc.b)
indicator:SetHeight(11)
indicator:SetParent(XP.backdrop)

local textMain = XP:CreateFontString(nil, 'OVERLAY')
textMain:SetPoint('LEFT', XP, 'RIGHT', 10, 0)
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
    if F.Level == MAX_PLAYER_LEVEL then
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

    self:Move(indicator, min/max)
end
XP.PLAYER_LEVEL_UP = XP.PLAYER_XP_UPDATE

function XP:UPDATE_FACTION()
    if F.Level == MAX_PLAYER_LEVEL then
        local name, standing, min, max, value = GetWatchedFactionInfo()

        if(not name) then return nil end
        max, min = (max-min), (value-min)

        textMain:SetFormattedText('|cffffffff%.1f|r%%', min/max*100)
        textTL:SetFormattedText('|cffffffff%s|r (|cffffffff%s|r)', name, _G['FACTION_STANDING_LABEL'..standing])
        textTR:SetFormattedText('|cffffffff%s|r / |cffffffff%s|r', min, max)
        textBL:SetFormattedText('')
        textBR:SetFormattedText('')
        self:Move(indicator, min/max)
    end	
end

-- RegisterEvents
XP:SetScript('OnEvent', function(self, event, ...) self[event](self, event, ...)
end)
XP:RegisterEvent('PLAYER_XP_UPDATE')
XP:RegisterEvent('UPDATE_FACTION')
XP:RegisterEvent('PLAYER_LEVEL_UP')
XP:RegisterEvent('PLAYER_ENTERING_WORLD')]]

-- Move AltPowerBar
PlayerPowerBarAlt:SetPoint('TOP', ABPanel, 'BOTTOM', 0, -2)