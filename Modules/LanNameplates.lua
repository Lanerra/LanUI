local F, C, G = unpack(select(2, ...))

-- Credit to Neav for this!

    -- Local stuff

local len = string.len
local find = string.find
local gsub = string.gsub

local select = select
local tonumber = tonumber

local UnitName = UnitName
local UnitCastingInfo = UnitCastingInfo
local UnitChannelInfo = UnitChannelInfo

local borderColor = {0.47, 0.47, 0.47}

local noThreatColor = {0, 1, 0}

local glowTexture = 'Interface\\AddOns\\LanUI\\Media\\textureNewGlow'
local overlayTexture = 'Interface\\AddOns\\LanUI\\Media\\textureOverlayPlate'
local whiteOverlay = 'Interface\\AddOns\\LanUI\\Media\\textureIconOverlay'

local f = CreateFrame('Frame', nil, UIParent)

f.elapsed = 0
f.elapsedLong = 0

    -- Totem data and functions

local function TotemName(SpellID)
    local name = GetSpellInfo(SpellID)
    return name
end

local function TotemIcon(SpellID)
    local _, _, icon = GetSpellInfo(SpellID)
    return icon
end

local totemData = {
    -- Air
    [TotemName(8177)] = {TotemIcon(8177)}, -- Grounding Totem
    [TotemName(108269)] = {TotemIcon(108269)}, -- Capacitor Totem
    [TotemName(120668)] = {TotemIcon(120668)}, -- Stormlash Totem
    [TotemName(98009)] = {TotemIcon(98008)}, -- Spirit Link Totem

    -- Earth
    [TotemName(2062)] = {TotemIcon(2062)}, -- Earth Elemental Totem
    [TotemName(2484)] = {TotemIcon(2484)}, -- Earthbind Totem
    [TotemName(8143)] = {TotemIcon(8143)}, -- Tremor Totem

    -- Fire
    [TotemName(2894)] = {TotemIcon(2894)}, -- Fire Elemental Totem
    [TotemName(8190)] = {TotemIcon(8190)}, -- Magma Totem
    [TotemName(3599)] = {TotemIcon(3599)}, -- Searing Totem

    -- Water
    [TotemName(16190)] = {TotemIcon(16190)}, -- Mana Tide Totem
    [TotemName(5394)] = {TotemIcon(5394)}, -- Healing Stream Totem
}

    -- Some general functions

local function FormatValue(number)
    if (number >= 1e6) then
        return tonumber(format('%.1f', number/1e6))..'m'
    elseif (number >= 1e3) then
        return tonumber(format('%.1f', number/1e3))..'k'
    else
        return number
    end
end

    -- The plate functions

local function GetUnitReaction(r, g, b)
    if (g + b == 0) then
        return true
    end

    return false
end

local function GetUnitCombatStatus(r, g, b)
    if (r >= 0.98) then
        return true
    end

    return false
end

local function IsTarget(self)
    local targetExists = UnitExists('target')
    if (not targetExists) then
        return false
    end

    local targetName = UnitName('target')
    if (targetName == self.Name:GetText() and self:GetAlpha() >= 0.99) then
        return true
    else
        return false
    end
end

local function CanHaveThreat(r, g, b)
    if (r < .01 and b < .01 and g > .99) then
        return false
    elseif (r < .01 and b > .99 and g < .01) then
        return false
    elseif (r > .99 and b < .01 and g > .99) then
        return false
    elseif (r > .99 and b < .01 and g < .01) then
        return true
    else
        return true
    end
end

local function UpdateTotemIcon(self)
    if (totemData[self.Name:GetText()]) then
        if (not self.Icon) then
            self.Icon = CreateFrame('Frame', nil, self)
            self.Icon:EnableMouse(false)
            self.Icon:SetSize(24, 24)
            self.Icon:SetPoint('BOTTOM', self.NewName, 'TOP', 0, 1)
        end

        local icon = totemData[self.Name:GetText()]
        self.Icon:SetBackdrop({
            bgFile = icon[1],
            edgeFile = 'Interface\\Buttons\\WHITE8x8',
            edgeSize = 1.5,
            insets = { top = -0, left = -0, bottom = -0, right = -0 },
        })

        local r, g, b = self.Health:GetStatusBarColor()
        self.Icon:SetBackdropBorderColor(r, g, b, 1)
        self.Icon:Show()
    else
        if (self.Icon) then
            self.Icon:SetBackdrop(nil)
            self.Icon:Hide()
            self.Icon = nil
        end
    end
end

local function UpdateThreatColor(self)
    local r, g, b
    local playerInfight = InCombatLockdown()
    local unitInfight = GetUnitCombatStatus(self.Name:GetTextColor())
    local lowThreat = unitInfight and playerInfight
    local isEnemy = GetUnitReaction(self.Health:GetStatusBarColor())

    if (self.Glow:IsVisible()) then
        r, g, b = self.Glow:GetVertexColor()
        self.NewGlow:SetVertexColor(r, g, b)

        if (not self.NewGlow:IsVisible()) then
            self.NewGlow:Show()
        end
    else
        if (self.NewGlow:IsVisible()) then
            self.NewGlow:Hide()
        end
    end
end

local function UpdateHealthText(self)
    local min, max = self.Health:GetMinMaxValues()
    local currentValue = self.Health:GetValue()
    local perc = (currentValue/max)*100

    if (perc < 100 and currentValue > 5) then
        self.Health.Value:SetFormattedText('%s - %.0f%%', FormatValue(currentValue), perc-0.5)
    else
        self.Health.Value:SetText('')
    end
end

local function UpdateHealthColor(self)
    local r, g, b = self.Health:GetStatusBarColor()
    if (r + g == 0) then
        self.Health:SetStatusBarColor(0, 0.35, 1)
        return
    end
end

local function UpdateCastbarValue(self, curValue)
    local _, maxValue = self:GetMinMaxValues()
    local cast = UnitCastingInfo('target')
    local channel = UnitChannelInfo('target')

    if (self.Shield:IsShown()) then
        self.Overlay:SetVertexColor(1, 0, 1, 1)
        self.Overlay:Show()
    else
        if C.Media.ClassColor then
            local r, g, b = F.PlayerColor.r, F.PlayerColor.g, F.PlayerColor.b
            self.Overlay:SetVertexColor(r, g, b, 1 )
        else
            local r, g, b = unpack(borderColor)
            self.Overlay:SetVertexColor(r, g, b, 1 )
        end
    end

    if (channel) then
        self.CastTime:SetFormattedText('%.1fs', curValue)
    else
        self.CastTime:SetFormattedText('%.1fs', maxValue - curValue)
    end

    self.Name:SetText(cast or channel)
end

local function UpdateNameL(self)
    local newName = self.Name:GetText()

    self.NewName:SetTextColor(1, 1, 1)
    
    local levelText = self.Level:GetText() or ''
    local levelColor = F.RGBToHex(self.Level:GetTextColor())
    local eliteTexture = self.EliteIcon:IsVisible()

    if (self.BossIcon:IsVisible()) then
        self.NewName:SetText('|cffff0000??|r '..newName)
    elseif (eliteTexture) then
        self.NewName:SetText('|cffffff00+|r'..levelColor..levelText..'|r '..newName)
    else
        self.NewName:SetText(levelColor..levelText..'|r '..newName)
    end
end

local function UpdateEliteTexture(self)
        if (self.BossIcon:IsVisible() or self.EliteIcon:IsVisible()) then
        local r, g, b = unpack(borderColor)
        self.Overlay:SetGradientAlpha('HORIZONTAL', r, g, b, 1, 1, 1, 0, 1)
    else
        local r, g, b = F.PlayerColor.r, F.PlayerColor.g, F.PlayerColor.b
        self.Overlay:SetVertexColor(r, g, b, 1)
    end
end

local function UpdatePlate(self)
    if (self.Level) then
        UpdateNameL(self)
    end

    UpdateEliteTexture(self)
    
    UpdateTotemIcon(self)
    
    UpdateHealthText(self)
    UpdateHealthColor(self)
    UpdateThreatColor(self)

    self.Highlight:ClearAllPoints()
    self.Highlight:SetAllPoints(self.Health)

    if (self.Castbar:IsVisible()) then
        self.Castbar:Hide()
    end

    local r, g, b = self.Health:GetStatusBarColor()
    self.Castbar.IconOverlay:SetVertexColor(r, g, b)
end

local function SkinPlate(self, nameFrame)
    self.Health, self.Castbar = self:GetChildren()
    self.Castbar.Overlay, self.Castbar.Shield, self.Castbar.Icon = select(2, self.Castbar:GetRegions())
    self.Glow, self.Overlay, self.Highlight, self.Level, self.BossIcon, self.RaidIcon, self.EliteIcon = self:GetRegions()
    self.Name = nameFrame:GetRegions()

        -- Hide some nameplate objects

    self.Glow:SetTexCoord(0, 0, 0, 0)
    self.BossIcon:SetTexCoord(0, 0, 0, 0)
    self.EliteIcon:SetTexCoord(0, 0, 0, 0)
    self.Castbar.Shield:SetTexCoord(0, 0, 0, 0)

    self.Name:SetWidth(0.001)
    self.Level:SetWidth(0.0001)

        -- Modify the overlay

    self.Overlay:SetTexCoord(0, 1, 0, 1)
    self.Overlay:ClearAllPoints()
    self.Overlay:SetPoint('TOPRIGHT', self.Health, 35.66666667, 5)
    self.Overlay:SetPoint('BOTTOMLEFT', self.Health, -37.66666667, -4.5)
    self.Overlay:SetDrawLayer('BORDER')
    self.Overlay:SetTexture(overlayTexture)

        -- Healtbar and background

    self.Health:SetBackdrop({
        bgFile = 'Interface\\Buttons\\WHITE8x8',
        insets = { left = -1, right = -1, top = -1, bottom = -1 }
    })
    self.Health:SetBackdropColor(0, 0, 0, 0.55)
    
    self.Health:SetStatusBarTexture('Interface\\Addons\\LanUI\\Media\\StatusBar.tga')

    self.Health:SetScript('OnValueChanged', function()
        UpdateHealthText(self)
        UpdateHealthColor(self)
    end)

        -- Create health value font string

    if (not self.Health.Value) then
        self.Health.Value = self.Health:CreateFontString(nil, 'OVERLAY')
        self.Health.Value:SetPoint('CENTER', self.Health, 0, 0)
        self.Health.Value:SetFont(C.Media.Font, 9)
        self.Health.Value:SetShadowOffset(1, -1)
    end

    if (not self.NewName) then
        self.NewName = self:CreateFontString(nil, 'ARTWORK')
        self.NewName:SetFont(C.Media.Font, 11, 'THINOUTLINE')
        self.NewName:SetShadowOffset(0, 0)
        self.NewName:SetPoint('BOTTOM', self.Health, 'TOP', 0, 2)
        self.NewName:SetSize(110, 13)
    end

    if (not self.NewGlow) then
        self.NewGlow = self.Health:CreateTexture(nil, 'BACKGROUND')
        self.NewGlow:SetTexture(glowTexture)
        self.NewGlow:SetAllPoints(self.Overlay)
        self.NewGlow:Hide()
    end

        -- Castbar

    self.Castbar:SetBackdrop({
        bgFile = 'Interface\\Buttons\\WHITE8x8',
        insets = { left = -1, right = -1, top = -1, bottom = -1 }
    })
    self.Castbar:SetBackdropColor(0.2, 0.2, 0.2, 0.5)

    self.Castbar:ClearAllPoints()
    self.Castbar:SetPoint('TOPRIGHT', self.Health, 'BOTTOMRIGHT', 0, -9)
    self.Castbar:SetPoint('BOTTOMLEFT', self.Health, 'BOTTOMLEFT', 0, -20)

    self.Castbar:HookScript('OnValueChanged', UpdateCastbarValue)

    self.Castbar.Overlay:SetTexCoord(0, 1, 0, 1)
    self.Castbar.Overlay:SetDrawLayer('BORDER')
    self.Castbar.Overlay:SetTexture(overlayTexture)
    self.Castbar.Overlay:ClearAllPoints()
    self.Castbar.Overlay:SetPoint('TOPRIGHT', self.Castbar, 35.66666667, 5.66666667)
    self.Castbar.Overlay:SetPoint('BOTTOMLEFT', self.Castbar, -36.66666667, -5.66666667)

        -- Castbar casttime font string

    if (not self.Castbar.CastTime) then
        self.Castbar.CastTime = self.Castbar:CreateFontString(nil, 'OVERLAY')
        self.Castbar.CastTime:SetPoint('RIGHT', self.Castbar, 1.6666667, 0)
        self.Castbar.CastTime:SetFont('Fonts\\ARIALN.ttf', 16)   -- , 'THINOUTLINE')
        self.Castbar.CastTime:SetTextColor(1, 1, 1)
        self.Castbar.CastTime:SetShadowOffset(1, -1)
    end

        -- Castbar castname font string

    if (not self.Castbar.Name) then
        self.Castbar.Name = self.Castbar:CreateFontString(nil, 'OVERLAY')
        self.Castbar.Name:SetPoint('LEFT', self.Castbar, 1.5, 0)
        self.Castbar.Name:SetPoint('RIGHT', self.Castbar.CastTime, 'LEFT', -6, 0)
        self.Castbar.Name:SetFont('Fonts\\ARIALN.ttf', 10)
        self.Castbar.Name:SetTextColor(1, 1, 1)
        self.Castbar.Name:SetShadowOffset(1, -1)
        self.Castbar.Name:SetJustifyH('LEFT')
    end

        -- Castbar spellicon and overlay

    self.Castbar.Icon:SetParent(self.Castbar)
    self.Castbar.Icon:ClearAllPoints()
    self.Castbar.Icon:SetPoint('BOTTOMLEFT', self.Castbar, 'BOTTOMRIGHT', 7, 3)
    self.Castbar.Icon:SetSize(24, 24)
    self.Castbar.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    self.Castbar.Icon:SetDrawLayer('BACKGROUND')

    if (not self.Castbar.IconOverlay) then
        self.Castbar.IconOverlay = self.Castbar:CreateTexture(nil, 'OVERLAY')
        self.Castbar.IconOverlay:SetPoint('TOPLEFT', self.Castbar.Icon, -1, 1)
        self.Castbar.IconOverlay:SetPoint('BOTTOMRIGHT', self.Castbar.Icon, 1, -1)
        self.Castbar.IconOverlay:SetTexture(whiteOverlay)
    end

        -- Mouseover highlight

    self.Highlight:SetTexture(1, 1, 1, 0.2)

        -- Raidicons

    self.RaidIcon:ClearAllPoints()
    self.RaidIcon:SetDrawLayer('OVERLAY')
    self.RaidIcon:SetPoint('CENTER', self.Health, 'TOP', 0, 12)
    self.RaidIcon:SetSize(16, 16)

        -- Nameplates like cookies

    UpdatePlate(self)

    self:SetScript('OnUpdate', nil)
    self:SetScript('OnShow', UpdatePlate)

    self:SetScript('OnHide', function(self)
        self.Highlight:Hide()
    end)

    self:SetScript('OnUpdate', function(_, elapsed)
        f.elapsed = f.elapsed + elapsed
        if (f.elapsed >= 0.1) then
            if ((CanHaveThreat(self.Health:GetStatusBarColor()) and InCombatLockdown()) or self.NewGlow:IsShown()) then
                UpdateThreatColor(self)
            end

            f.elapsed = 0
        end

        f.elapsedLong = f.elapsedLong + elapsed
        if (f.elapsedLong >= 0.49) then
            UpdateHealthColor(self)

            f.elapsedLong = 0
        end

    end)
end

    -- Scan the worldframe for nameplates

local numFrames = 0
local lastUpdate = 0
local index = 1
f:SetScript('OnUpdate', function(self, elapsed)
    lastUpdate = lastUpdate + elapsed

    if (lastUpdate > 0.1) then
        local newNumFrames = WorldFrame:GetNumChildren()

        if (newNumFrames ~= numFrames) then
            numFrames = newNumFrames

            for i = index, numFrames do
                local frame = select(i, WorldFrame:GetChildren())
                local frameName = frame:GetName()

                if (frameName and frameName:find('NamePlate') and not frame.NewName) then
                    SkinPlate(frame:GetChildren())
                    index = i
                end
            end
        end

        lastUpdate = 0
    end
end)
