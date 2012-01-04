
    -- import globals for faster usage
    
local _G = _G
local select = select

    -- import functions for faster usage
    
local UnitName = UnitName
local UnitLevel = UnitLevel
local UnitExists = UnitExists
local UnitIsDead = UnitIsDead
local UnitIsGhost = UnitIsGhost
local UnitFactionGroup = UnitFactionGroup
local UnitCreatureType = UnitCreatureType
local GetQuestDifficultyColor = GetQuestDifficultyColor

    -- font settings
    
GameTooltipHeaderText:SetFont('Fonts\\ARIALN.ttf', 17)
GameTooltipText:SetFont('Fonts\\ARIALN.ttf', 15)
GameTooltipTextSmall:SetFont('Fonts\\ARIALN.ttf', 15)
    
    -- healthbar settings
    
GameTooltipStatusBar:SetHeight(7)
GameTooltipStatusBar:SetBackdrop({bgFile = 'Interface\\Buttons\\WHITE8x8'})
    
    -- load texture paths locally

local function ApplyTooltipStyle(self)
    local bgsize, bsize

    if (self == ConsolidatedBuffsTooltip) then
        bgsize = 1
        bsize = 8
    elseif (self == FriendsTooltip) then
        FriendsTooltip:SetScale(1.1)
        
        bgsize = 1
        bsize = 9
    else
        bgsize = 3
        bsize = 12
    end
    
    self:SetBackdrop({
        bgFile = LanConfig.Media.Backdrop,
        insets = {
            left = bgsize, 
            right = bgsize, 
            top = bgsize, 
            bottom = bgsize
        }
    })
    
    self:HookScript('OnShow', function(self)
        self:SetBackdropColor(unpack(LanConfig.Media.BackdropColor))
    end)
    
    self:CreateBeautyBorder(bsize)
end

hooksecurefunc('GameTooltip_ShowCompareItem', function(self)  
	if (not self) then
		self = GameTooltip
	end
    
    local shoppingTooltip1, shoppingTooltip2, shoppingTooltip3 = unpack(self.shoppingTooltips)
    
    if (not shoppingTooltip1.hasBorder) then
        ApplyTooltipStyle(shoppingTooltip1)
        shoppingTooltip1.hasBorder = true
    end
    
    if (not shoppingTooltip2.hasBorder) then
        ApplyTooltipStyle(shoppingTooltip2)
        shoppingTooltip2.hasBorder = true
    end
    
    if (not shoppingTooltip3.hasBorder) then
        ApplyTooltipStyle(shoppingTooltip3)
        shoppingTooltip3.hasBorder = true
    end
end)
    
    -- tooltips like cookies!
    
for _, tooltip in pairs({
    GameTooltip,
    ItemRefTooltip,
   
    ShoppingTooltip1,
    ShoppingTooltip2,
    ShoppingTooltip3,   
    
    WorldMapTooltip,
 
    DropDownList1MenuBackdrop,
    DropDownList2MenuBackdrop,
    
    ConsolidatedBuffsTooltip,
    
    ChatMenu,
    EmoteMenu,
    LanguageMenu,
    VoiceMacroMenu,
    
    FriendsTooltip,
}) do
    ApplyTooltipStyle(tooltip)
end

    -- itemquaility border, we use our beautycase functions
    
    for _, tooltip in pairs({
        GameTooltip,
        ItemRefTooltip,
       
        ShoppingTooltip1,
        ShoppingTooltip2,
        ShoppingTooltip3,   
    }) do
        tooltip:HookScript('OnTooltipSetItem', function(self)
            local name, item = self:GetItem()
                
            if (item) then
                local quality = select(3, GetItemInfo(item))
                    
                if (quality) then
                    local r, g, b = GetItemQualityColor(quality)
                    self:SetBeautyBorderTexture('white')
                    self:SetBeautyBorderColor(r, g, b)
                end
            end
        end)
        
        tooltip:HookScript('OnTooltipCleared', function(self)
            self:SetBeautyBorderTexture('default')
            self:SetBeautyBorderColor(1, 1, 1)
        end)
    end

    -- make sure we get a unit
    
local function GameTooltip_GetUnit(self)
    if (GetMouseFocus() and not GetMouseFocus():GetAttribute('unit') and GetMouseFocus() ~= WorldFrame) then
        return select(2, self:GetUnit())
	elseif (GetMouseFocus() and GetMouseFocus():GetAttribute('unit')) then
		return GetMouseFocus():GetAttribute('unit')
    else
        return select(2, self:GetUnit())  
	end
end

local function GameTooltip_UnitCreatureType(unit)
    local creaturetype = UnitCreatureType(unit)
    
    if (creaturetype) then
        return creaturetype
    else
        return ''
    end
end

local function GameTooltip_UnitClassification(unit)
    local class = UnitClassification(unit)
    
    if (class == 'worldboss') then
        return '|cffFF0000'..BOSS..'|r '
    elseif (class == 'rareelite') then
        return '|cffFF66CCRare|r |cffFFFF00'..ELITE..'|r '
    elseif (class == 'rare') then 
        return '|cffFF66CCRare|r '
    elseif (class == 'elite') then
        return '|cffFFFF00'..ELITE..'|r '
    else
        return ''
    end
end

local function GameTooltip_UnitLevel(unit)
    local diff = GetQuestDifficultyColor(UnitLevel(unit))
    if (UnitLevel(unit) == -1) then
        return '|cffff0000??|r '
    elseif (UnitLevel(unit) == 0) then
        return '? '
    else
        return format('|cff%02x%02x%02x%s|r ', diff.r*255, diff.g*255, diff.b*255, UnitLevel(unit))    
    end
end

local function GameTooltip_UnitClass(unit)
    local color = RAID_CLASS_COLORS[select(2, UnitClass(unit))]
    if (color) then
        return format(' |cff%02x%02x%02x%s|r', color.r*255, color.g*255, color.b*255, UnitClass(unit))
    end
end

local function GameTooltip_UnitType(unit) 
    if (UnitIsPlayer(unit)) then
        return GameTooltip_UnitLevel(unit)..UnitRace(unit)..GameTooltip_UnitClass(unit)
    else
        return GameTooltip_UnitLevel(unit)..GameTooltip_UnitClassification(unit)..GameTooltip_UnitCreatureType(unit)
    end
end

    -- tooltip position
    
hooksecurefunc('GameTooltip_SetDefaultAnchor', function(self)
	if (not ChatFrame3:IsShown()) then
        self:SetPoint('BOTTOMRIGHT', UIParent, 'BOTTOMRIGHT', -27.35, 27.35)
    else
        self:SetPoint('BOTTOMRIGHT', ChatFrame3, 'TOPRIGHT', 0, 5)
    end
end)

    -- set all to the defaults if tooltip hides
    
GameTooltip:HookScript('OnTooltipCleared', function(self)
    GameTooltipStatusBar:ClearAllPoints()
    GameTooltipStatusBar:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 2, -2)
    GameTooltipStatusBar:SetPoint('TOPRIGHT', self, 'BOTTOMRIGHT', -2, -2)
    
    if (GameTooltip.PVPIcon) then
        GameTooltip.PVPIcon:SetTexture(nil)
    end
end)

    -- healthbar coloring funtion
    
local function HealthBarColor(unit)
    local r, g, b

    r, g, b = 0, 1, 0
    
    GameTooltipStatusBar:SetStatusBarColor(r, g, b)
    GameTooltipStatusBar:SetBackdropColor(r, g, b, 0.3)
end

    -- itemlvl (by Gsuz) - http://www.tukui.org/forums/topic.php?id=10151

local SlotName = {
        'Head',
        'Neck',
        'Shoulder',
        'Back',
        'Chest',
        'Wrist',
        'Hands',
        'Waist',
        'Legs',
        'Feet',
        'Finger0',
        'Finger1',
        'Trinket0',
        'Trinket1',
        'MainHand',
        'SecondaryHand',
        'Ranged',
        'Ammo'
    }

local function GetItemLVL(unit)
    local total, item = 0, 0
    for i, v in pairs(SlotName) do
        local slot = GetInventoryItemLink(unit, GetInventorySlotInfo(SlotName[i] .. 'Slot'))
        if (slot ~= nil) then
            item = item + 1
            total = total + select(4, GetItemInfo(slot))
        end
    end
        
    if (item > 0) then
        return floor(total / item)
    end
    
    return 0
end

local function GetUnitRaidIcon(unit)
    local index = GetRaidTargetIndex(unit)

    if (index) then
        if (UnitIsPVP(unit)) then
            return ICON_LIST[index]..'11|t'
        else
            return ICON_LIST[index]..'11|t '
        end
    else
        return ''
    end
end

local function GameTooltip_GetUnitPVPIcon(unit) 
    local factionGroup = UnitFactionGroup(unit)
    
    if (UnitIsPVPFreeForAll(unit)) then
        return '|TInterface\\AddOns\\nTooltip\\media\\UI-PVP-FFA:12|t'
    elseif (factionGroup and UnitIsPVP(unit)) then
        return '|TInterface\\AddOns\\nTooltip\\media\\UI-PVP-'..factionGroup..':12|t'
    else
        return ''
    end
end

    -- function to short-display HP value on StatusBar
    
local function ShortValue(value)
	if (value >= 1e7) then
		return ('%.1fm'):format(value / 1e6):gsub('%.?0+([km])$', '%1')
	elseif (value >= 1e6) then
		return ('%.2fm'):format(value / 1e6):gsub('%.?0+([km])$', '%1')
	elseif (value >= 1e5) then
		return ('%.0fk'):format(value / 1e3)
	elseif (value >= 1e3) then
		return ('%.1fk'):format(value / 1e3):gsub('%.?0+([km])$', '%1')
	else
		return value
	end
end

local function AddMouseoverTarget(self, unit)
    local unitTargetName = UnitName(unit..'target')
    local unitTargetClassColor = RAID_CLASS_COLORS[select(2, UnitClass(unit..'target'))] or { r = 1, g = 0, b = 1 }
    local unitTargetReactionColor = { 
        r = select(1, UnitSelectionColor(unit..'target')), 
        g = select(2, UnitSelectionColor(unit..'target')), 
        b = select(3, UnitSelectionColor(unit..'target')) 
    }
        
    if (UnitExists(unit..'target')) then
        if (UnitName('player') == unitTargetName) then   
            self:AddLine(format('  '..GetUnitRaidIcon(unit..'target')..'|cffff00ff%s|r', string.upper(YOU)), 1, 1, 1)
        else
            if (UnitIsPlayer(unit..'target')) then
                self:AddLine(format('  '..GetUnitRaidIcon(unit..'target')..'|cff%02x%02x%02x%s|r', unitTargetClassColor.r*255, unitTargetClassColor.g*255, unitTargetClassColor.b*255, unitTargetName:sub(1, 40)), 1, 1, 1)
            else
                self:AddLine(format('  '..GetUnitRaidIcon(unit..'target')..'|cff%02x%02x%02x%s|r', unitTargetReactionColor.r*255, unitTargetReactionColor.g*255, unitTargetReactionColor.b*255, unitTargetName:sub(1, 40)), 1, 1, 1)                 
            end
        end
    end
end

GameTooltip:HookScript('OnTooltipSetUnit', function(self, ...)
    local unit = GameTooltip_GetUnit(self)
            
	if (UnitExists(unit) and UnitName(unit) ~= UNKNOWN) then
        local name, realm = UnitName(unit)
        
            -- hide player titles
            
        GameTooltipTextLeft1:SetText(name)
        
            -- color guildnames
            
        if (GetGuildInfo(unit)) then
            if (GetGuildInfo(unit) == GetGuildInfo('player') and IsInGuild('player')) then
               GameTooltipTextLeft2:SetText('|cffFF66CC'..GameTooltipTextLeft2:GetText()..'|r')
            end
        end
            
            -- tooltip level text
            
        for i = 2, GameTooltip:NumLines() do
            if (_G['GameTooltipTextLeft'..i]:GetText():find('^'..TOOLTIP_UNIT_LEVEL:gsub('%%s', '.+'))) then
                _G['GameTooltipTextLeft'..i]:SetText(GameTooltip_UnitType(unit))
            end
        end
        
            -- mouse over target with raidicon support
            
        AddMouseoverTarget(self, unit)
          
            -- pvp flag prefix 

		for i = 3, GameTooltip:NumLines() do
			if (_G['GameTooltipTextLeft'..i]:GetText():find(PVP_ENABLED)) then
				_G['GameTooltipTextLeft'..i]:SetText(nil)
                GameTooltipTextLeft1:SetText(GameTooltip_GetUnitPVPIcon(unit)..GameTooltipTextLeft1:GetText())
			end
		end
        
            -- raid icon, want to see the raidicon on the left
            
        GameTooltipTextLeft1:SetText(GetUnitRaidIcon(unit)..GameTooltipTextLeft1:GetText())

            -- afk and dnd prefix

        if (UnitIsAFK(unit)) then 
            self:AppendText(' |cff00ff00[AFK]|r')   
            -- self:AppendText(' |cff00ff00<AFK>|r')  
        elseif (UnitIsDND(unit)) then
            self:AppendText(' |cff00ff00[DND]|r')
        end

            -- player realm names
            
        if (realm and realm ~= '') then
           self:AppendText(' (*)')
        end

            -- move the healthbar inside the tooltip
            
        self:AddLine(' ')
        GameTooltipStatusBar:ClearAllPoints()
        GameTooltipStatusBar:SetPoint('LEFT', self:GetName()..'TextLeft'..self:NumLines(), 1, -3)
        GameTooltipStatusBar:SetPoint('RIGHT', self, -10, 0)
        
            -- show player item lvl
            
        if (unit and CanInspect(unit)) then
            if (not ((InspectFrame and InspectFrame:IsShown()) or (Examiner and Examiner:IsShown()))) then
                NotifyInspect(unit)
                GameTooltip:AddLine('Item Level: ' .. GetItemLVL(unit))
                ClearInspectPlayer(unit)
            end
        end
        
            -- dead or ghost recoloring
            
        if (UnitIsDead(unit) or UnitIsGhost(unit)) then
            GameTooltipStatusBar:SetBackdropColor(0.5, 0.5, 0.5, 0.3)
        else
            HealthBarColor(unit)
        end

            -- tooltip HP bar & value
            
        if (not GameTooltipStatusBar.hasHealthText) then
            GameTooltipStatusBar:SetScript('OnValueChanged', function(self, value)
                if (not value) then
                    return
                end
                
                local min, max = self:GetMinMaxValues()
                
                if (value < min) or (value > max) then
                    return
                end
                
                local _, unit = GameTooltip:GetUnit()

                if (not unit) then
                    unit = GetMouseFocus() and GetMouseFocus():GetAttribute('unit')
                end
                
                    -- custom healthbar coloring
                    
                HealthBarColor(unit)
                
                if (not self.text) then
                    self.text = self:CreateFontString(nil, 'MEDIUM')
                    
                
	                self.text:SetPoint('RIGHT', GameTooltipStatusBar, 'BOTTOMRIGHT', -10, 1)
					self.text:SetPoint('LEFT', GameTooltipStatusBar, 'BOTTOMLEFT', 10, 1)
                else
                    self.text:SetPoint('RIGHT', GameTooltipStatusBar, 'RIGHT', -10, 1)
 	                self.text:SetPoint('LEFT', GameTooltipStatusBar, 'LEFT', 10, 1)
                end
                    
                self.text:SetFont(LanConfig.Media.Font, LanConfig.Media.FontSize)
                self.text:SetShadowOffset(1, -1)
                    
                self.text:Show()
                    
                if (unit and self.text) then
                    min = UnitHealth(unit)
                    max = UnitHealthMax(unit)
                    local hp = ShortValue(min)..' / '..ShortValue(max)
                        
                    if (UnitIsGhost(unit)) then
                        self.text:SetText('Ghost')
                    elseif (min == 0 or UnitIsDead(unit) or UnitIsGhost(unit)) then
                        self.text:SetText('Dead')
                    else
                        self.text:SetText(hp)
                    end
                end
                
                self.hasHealthText = true
            end)
        end
    end
end)