local F, C, G = unpack(select(2, ...))

local _G = _G
local select = select

local format = string.format

local UnitName = UnitName
local UnitLevel = UnitLevel
local UnitExists = UnitExists
local UnitIsDead = UnitIsDead
local UnitIsGhost = UnitIsGhost
local UnitFactionGroup = UnitFactionGroup
local UnitCreatureType = UnitCreatureType
local GetQuestDifficultyColor = GetQuestDifficultyColor

local tankIcon = '|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES.blp:13:13:0:0:64:64:0:19:22:41|t'
local healIcon = '|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES.blp:13:13:0:0:64:64:20:39:1:20|t'
local damagerIcon = '|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES.blp:13:13:0:0:64:64:20:39:22:41|t'

    -- Some tooltip changes

GameTooltipHeaderText:SetFont(C.Media.Font, 17)
GameTooltipText:SetFont(C.Media.Font, 15)
GameTooltipTextSmall:SetFont(C.Media.Font, 15)

GameTooltipStatusBar:SetHeight(7)
GameTooltipStatusBar:SetBackdrop({bgFile = C.Media.Backdrop})
GameTooltipStatusBar:SetBackdropColor(0, 0, 0, 0.5)

local function ApplyTooltipStyle(self)
    local bgsize, bsize
    if self == ConsolidatedBuffsTooltip then
        bgsize = 1
        bsize = 8
    elseif self == FriendsTooltip then
        FriendsTooltip:SetScale(1.1)

        bgsize = 1
        bsize = 9
    else
        bgsize = 3
        bsize = 12
    end
    
    self:SetBackdrop({
        bgFile = C.Media.Backdrop,
    })

    self:HookScript('OnShow', function(self)
        self:SetBackdropColor(0, 0, 0, 0.5)
    end)

    self:SetTemplate()
end

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

    -- Item quality border, we use our beautycase functions

for _, tooltip in pairs({
    GameTooltip,
    ItemRefTooltip,

    ShoppingTooltip1,
    ShoppingTooltip2,
    ShoppingTooltip3,
}) do
    if tooltip.beautyBorder then
        tooltip:HookScript('OnTooltipSetItem', function(self)
            local name, item = self:GetItem()
            if item then
                local quality = select(3, GetItemInfo(item))
                if quality then
                    local r, g, b = GetItemQualityColor(quality)
                    self:SetBeautyBorderTexture('white')
                    self:SetBeautyBorderColor(r, g, b)
                end
            end
        end)

        tooltip:HookScript('OnTooltipCleared', function(self)
            if C.Media.ClassColor then
                self:SetBeautyBorderTexture('white')
                self:SetBeautyBorderColor(unpack(F.PlayerColor))
            else
                self:SetBeautyBorderTexture('default')
                self:SetBeautyBorderColor(1, 1, 1)
            end
        end)
    end
end

    -- Itemlvl (by Gsuz) - http://www.tukui.org/forums/topic.php?id=10151

local function GetItemLevel(unit)
    local total, item = 0, 0
    for i, v in pairs({
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
    }) do
        local slot = GetInventoryItemLink(unit, GetInventorySlotInfo(v..'Slot'))
        if slot ~= nil then
            item = item + 1
            total = total + select(4, GetItemInfo(slot))
        end
    end

    if item > 0 then
        return floor(total / item + 0.5)
    end

    return 0
end

    -- Make sure we get a correct unit

local function GetRealUnit(self)
    if GetMouseFocus() and not GetMouseFocus():GetAttribute('unit') and GetMouseFocus() ~= WorldFrame then
        return select(2, self:GetUnit())
    elseif GetMouseFocus() and GetMouseFocus():GetAttribute('unit') then
        return GetMouseFocus():GetAttribute('unit')
    elseif select(2, self:GetUnit()) then
        return select(2, self:GetUnit())
    else
        return 'mouseover'
    end
end

local function GetFormattedUnitType(unit)
    local creaturetype = UnitCreatureType(unit)
    if creaturetype then
        return creaturetype
    else
        return ''
    end
end

local function GetFormattedUnitClassification(unit)
    local class = UnitClassification(unit)
    if class == 'worldboss' then
        return '|cffFF0000'..BOSS..'|r '
    elseif class == 'rareelite' then
        return '|cffFF66CCRare|r |cffFFFF00'..ELITE..'|r '
    elseif class == 'rare' then
        return '|cffFF66CCRare|r '
    elseif class == 'elite' then
        return '|cffFFFF00'..ELITE..'|r '
    else
        return ''
    end
end

local function GetFormattedUnitLevel(unit)
    local diff = GetQuestDifficultyColor(UnitLevel(unit))
    if UnitLevel(unit) == -1 then
        return '|cffff0000??|r '
    elseif UnitLevel(unit) == 0 then
        return '? '
    else
        return format('|cff%02x%02x%02x%s|r ', diff.r*255, diff.g*255, diff.b*255, UnitLevel(unit))
    end
end

local function GetFormattedUnitClass(unit)
    local color = RAID_CLASS_COLORS[select(2, UnitClass(unit))]
    if color then
        return format(' |cff%02x%02x%02x%s|r', color.r*255, color.g*255, color.b*255, UnitClass(unit))
    end
end

local function GetFormattedUnitString(unit, specIcon)
    if UnitIsPlayer(unit) then
        if (not UnitRace(unit)) then
            return nil
        end
        
        return GetFormattedUnitLevel(unit)..UnitRace(unit)..GetFormattedUnitClass(unit)..specIcon or ''
    else
        return GetFormattedUnitLevel(unit)..GetFormattedUnitClassification(unit)..GetFormattedUnitType(unit)
    end
end

local function GetUnitRoleString(unit)
    local role = UnitGroupRolesAssigned(unit)
    local roleList = nil

    if role == 'TANK' then
        roleList = '   '..tankIcon..' '..TANK
    elseif role == 'HEALER' then
        roleList = '   '..healIcon..' '..HEALER
    elseif role == 'DAMAGER' then
        roleList = '   '..damagerIcon..' '..DAMAGER
    end

    return roleList
end

    -- Healthbar coloring function

local function SetHealthBarColor(unit)
    local r, g, b
    if unit then
        r, g, b = UnitSelectionColor(unit)
	else
		r, g, b = 0, 1, 0
    end

    GameTooltipStatusBar:SetStatusBarColor(r, g, b)
    GameTooltipStatusBar:SetBackdropColor(r, g, b, 0.3)
end

local function GetUnitRaidIcon(unit)
    local index = GetRaidTargetIndex(unit)

    if index then
        if UnitIsPVP(unit) then
            return ICON_LIST[index]..'11|t'
        else
            return ICON_LIST[index]..'11|t '
        end
    else
        return ''
    end
end

local function GetUnitPVPIcon(unit)
    local factionGroup = UnitFactionGroup(unit)

    if UnitIsPVPFreeForAll(unit) then
        return '|TInterface\\AddOns\\LanUI\\Media\\UI-PVP-FFA:12|t'
    elseif factionGroup and UnitIsPVP(unit) then
        return '|TInterface\\AddOns\\LanUI\\Media\\UI-PVP-'..factionGroup..':12|t'
    else
        return ''
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

    if UnitExists(unit..'target') then
        if UnitName('player') == unitTargetName then
            self:AddLine(format('   '..GetUnitRaidIcon(unit..'target')..'|cffff00ff%s|r', string.upper(YOU)), 1, 1, 1)
        else
            if UnitIsPlayer(unit..'target') then
                self:AddLine(format('   '..GetUnitRaidIcon(unit..'target')..'|cff%02x%02x%02x%s|r', unitTargetClassColor.r*255, unitTargetClassColor.g*255, unitTargetClassColor.b*255, unitTargetName:sub(1, 40)), 1, 1, 1)
            else
                self:AddLine(format('   '..GetUnitRaidIcon(unit..'target')..'|cff%02x%02x%02x%s|r', unitTargetReactionColor.r*255, unitTargetReactionColor.g*255, unitTargetReactionColor.b*255, unitTargetName:sub(1, 40)), 1, 1, 1)
            end
        end
    end
end

GameTooltip.inspectCache = {}

GameTooltip:HookScript('OnTooltipSetUnit', function(self, ...)
    local unit = GetRealUnit(self)

    if UnitExists(unit) and UnitName(unit) ~= UNKNOWN then

        local ilvl = 0
        local specIcon = ''
        local lastUpdate = 30
        for index, _ in pairs(self.inspectCache) do
            local inspectCache = self.inspectCache[index]
            if inspectCache.GUID == UnitGUID(unit) then
                ilvl = inspectCache.itemLevel or 0
                specIcon = inspectCache.specIcon or ''
                lastUpdate = inspectCache.lastUpdate and math.abs(inspectCache.lastUpdate - math.floor(GetTime())) or 30
            end
        end

            -- Fetch inspect information (ilvl and spec)

        if unit and CanInspect(unit) then
            if not self.inspectRefresh and lastUpdate >= 30 and not self.blockInspectRequests then
                if not self.blockInspectRequests then
                    self.inspectRequestSent = true
                    NotifyInspect(unit)
                end
            end
        end

        self.inspectRefresh = false

        local name, realm = UnitName(unit)

        GameTooltipTextLeft1:SetText(name)

            -- Color guildnames

        if GetGuildInfo(unit) then
            if GetGuildInfo(unit) == GetGuildInfo('player') and IsInGuild('player') then
               GameTooltipTextLeft2:SetText('|cffFF66CC'..GameTooltipTextLeft2:GetText()..'|r')
            end
        end

            -- Tooltip level text

        for i = 2, GameTooltip:NumLines() do
            if _G['GameTooltipTextLeft'..i]:GetText():find('^'..TOOLTIP_UNIT_LEVEL:gsub('%%s', '.+')) then
                _G['GameTooltipTextLeft'..i]:SetText(GetFormattedUnitString(unit, specIcon))
            end
        end

            -- Role text

        self:AddLine(GetUnitRoleString(unit), 1, 1, 1)

            -- Mouse over target with raidicon support

        if C.Tooltip.TTMouse then
            AddMouseoverTarget(self, unit)
        end

            -- Pvp flag prefix

        for i = 3, GameTooltip:NumLines() do
            if _G['GameTooltipTextLeft'..i]:GetText():find(PVP_ENABLED) then
                _G['GameTooltipTextLeft'..i]:SetText(nil)
                GameTooltipTextLeft1:SetText(GetUnitPVPIcon(unit)..GameTooltipTextLeft1:GetText())
            end
        end

            -- Raid icon, want to see the raidicon on the left

        GameTooltipTextLeft1:SetText(GetUnitRaidIcon(unit)..GameTooltipTextLeft1:GetText())

            -- Afk and dnd prefix

        if UnitIsAFK(unit) then
            self:AppendText('|cff00ff00 <AFK>|r')
        elseif UnitIsDND(unit) then
            self:AppendText('|cff00ff00 <DND>|r')
        end

            -- Player realm names

        if realm and realm ~= '' then
            self:AppendText(' (*)')
        end

            -- Unit Health
        
        GameTooltipStatusBarTexture:SetTexture('Interface\\AddOns\\LanUI\\Media\\StatusBar')
        
            -- Move the healthbar inside the tooltip

        self:AddLine(' ')
        GameTooltipStatusBar:ClearAllPoints()
        GameTooltipStatusBar:SetPoint('LEFT', self:GetName()..'TextLeft'..self:NumLines(), 1, -3)
        GameTooltipStatusBar:SetPoint('RIGHT', self, -10, 0)
        
            -- Border coloring

        if self.beautyBorder then
            local r, g, b = UnitSelectionColor(unit)

            self:SetBeautyBorderTexture('white')
            self:SetBeautyBorderColor(r, g, b)
        end

            -- Dead or ghost recoloring

        if UnitIsDead(unit) or UnitIsGhost(unit) then
            GameTooltipStatusBar:SetBackdropColor(0.5, 0.5, 0.5, 0.3)
        else
            --SetHealthBarColor(unit)
			GameTooltipStatusBar:SetBackdropColor(27/255, 243/255, 27/255, 0.3)
        end

            -- Show player item lvl

        if ilvl > 1 then
            GameTooltip:AddLine(STAT_AVERAGE_ITEM_LEVEL .. ': ' .. '|cffFFFFFF'..ilvl..'|r')
        end
    end
end)

GameTooltip:HookScript('OnTooltipCleared', function(self)
    GameTooltipStatusBar:ClearAllPoints()
    GameTooltipStatusBar:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 0.5, 3)
    GameTooltipStatusBar:SetPoint('BOTTOMRIGHT', self, 'TOPRIGHT', -1, 3)
    GameTooltipStatusBar:SetBackdropColor(0, 1, 0, 0.3)

    if self.beautyBorder then
        if C.Media.ClassColor then
            self:SetBeautyBorderTexture('white')
            self:SetBeautyBorderColor(unpack(F.PlayerColor))
        else
            self:SetBeautyBorderTexture('default')
            self:SetBeautyBorderColor(1, 1, 1)
        end
    end
end)

hooksecurefunc('GameTooltip_SetDefaultAnchor', function(self, parent)
    if C.Tooltip.TTMouse then
        self:SetOwner(parent, 'ANCHOR_CURSOR')
    else
        self:SetOwner(parent, 'ANCHOR_NONE')
        
        if (not ChatFrame3:IsShown()) then
            self:SetPoint('BOTTOMRIGHT', UIParent, 'BOTTOMRIGHT', -5.35, 27.35)
        else
            self:SetPoint('BOTTOMRIGHT', ChatFrame3, 'TOPRIGHT', 4, 7)
        end
    end
end)


GameTooltip:RegisterEvent('INSPECT_READY')
GameTooltip:SetScript('OnEvent', function(self, event, GUID)
    if not self:IsShown() then
        return
    end

    local _, unit = self:GetUnit()

    if not unit then
        return
    end

    if self.blockInspectRequests then
        self.inspectRequestSent = false
    end

    if UnitGUID(unit) ~= GUID or not self.inspectRequestSent then
        if not self.blockInspectRequests then
            ClearInspectPlayer()
        end
        return
    end

    local ilvl = GetItemLevel(unit)
    local now = GetTime()

    local matchFound
    for index, _ in pairs(self.inspectCache) do
        local inspectCache = self.inspectCache[index]
        if inspectCache.GUID == GUID then
            inspectCache.itemLevel = ilvl
            inspectCache.lastUpdate = math.floor(now)
            matchFound = true
        end
    end

    if not matchFound then
        local GUIDInfo = {
            ['GUID'] = GUID,
            ['itemLevel'] = ilvl,
            ['specIcon'] = icon and ' |T'..icon..':0|t' or '',
            ['lastUpdate'] = math.floor(now)
        }
        table.insert(self.inspectCache, GUIDInfo)
    end

    if #self.inspectCache > 30 then
        table.remove(self.inspectCache, 1)
    end

    self.inspectRefresh = true
    GameTooltip:SetUnit('mouseover')

    if not self.blockInspectRequests then
        ClearInspectPlayer()
    end
    self.inspectRequestSent = false
end)

local f = CreateFrame('Frame')
f:RegisterEvent('ADDON_LOADED')
f:SetScript('OnEvent', function(self, event)
    if IsAddOnLoaded('Blizzard_InspectUI') then
        hooksecurefunc('InspectFrame_Show', function(unit)
            GameTooltip.blockInspectRequests = true
        end)

        InspectFrame:HookScript('OnHide', function()
            GameTooltip.blockInspectRequests = false
        end)

        self:UnregisterEvent('ADDON_LOADED')
    end
end)

local bar = GameTooltipStatusBar
bar.Text = bar:CreateFontString(nil, 'OVERLAY')
bar.Text:SetPoint('CENTER', bar, 0, 1)
bar.Text:SetFont(C.Media.Font, C.Media.FontSize, 'THINOUTLINE')
bar.Text:SetShadowOffset(0, 0)

local function GetHealthTag(text, cur, max)
    local perc = format('%d', (cur/max)*100)

    if (max == 1) then
        return perc
    end

    text = gsub(text, '$cur', format('%s', F.ShortValue(cur)))
    text = gsub(text, '$max', format('%s', F.ShortValue(max)))

    return text
end

GameTooltipStatusBar:HookScript('OnValueChanged', function(self, value)
    if (GameTooltipStatusBar.Text) then
        self.Text:SetText('')
    end

    if (not value) then
        return
    end

    local min, max = self:GetMinMaxValues()

    if ((value < min) or (value > max) or (value == 0) or (value == 1)) then
        return
    end

    if (not self.Text) then
        CreateHealthString(self)
    end

    local fullString = GetHealthTag('$cur', value, max)
    local normalString = GetHealthTag('$cur / $max', value, max)

    local perc = (value/max)*100 
    if (perc >= 100 and currentValue ~= 1) then
        self.Text:SetText(fullString)
    elseif (perc < 100 and currentValue ~= 1) then
        self.Text:SetText(normalString)
    else
        self.Text:SetText('')
    end
end)