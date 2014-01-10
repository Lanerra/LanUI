--[[local F, C, G = unpack(select(2, ...))

if select(2, UnitClass('player')) ~= 'DEATHKNIGHT' then
    return
end

for i = 1, 6 do 
    RuneFrame:UnregisterAllEvents()
    _G['RuneButtonIndividual'..i]:Hide()
end

RuneColor = {}
RuneColor[1] = {r = 0.7, g = 0.1, b = 0.1}
RuneColor[2] = {r = 0.7, g = 0.1, b = 0.1}
RuneColor[3] = {r = 0.4, g = 0.8, b = 0.2}
RuneColor[4] = {r = 0.4, g = 0.8, b = 0.2}
RuneColor[5] = {r = 0.0, g = 0.6, b = 0.8}
RuneColor[6] = {r = 0.0, g = 0.6, b = 0.8}

local Rune = CreateFrame('Frame', nil, UIParent)
Rune:SetScale(1.4)
Rune:SetWidth(18)
Rune:SetHeight(18)
Rune:SetPoint('CENTER', UIParent, 0, -223)
Rune:EnableMouse(false)

Rune:RegisterEvent('RUNE_TYPE_UPDATE')
Rune:RegisterEvent('PLAYER_REGEN_ENABLED')
Rune:RegisterEvent('PLAYER_REGEN_DISABLED')
Rune:RegisterEvent('PLAYER_LOGIN')

Rune.Rune = {}

for i = 1, 6 do
    Rune.Rune[i] = Rune:CreateFontString(nil, 'ARTWORK')
    Rune.Rune[i]:SetFont('Fonts\\ARIALN.ttf', 16, 'OUTLINE')
    Rune.Rune[i]:SetShadowOffset(0, 0)
    Rune.Rune[i]:SetParent(Rune)
end

Rune.Rune[1]:SetPoint('CENTER', -65, 0)
Rune.Rune[2]:SetPoint('CENTER', -39, 0)
Rune.Rune[3]:SetPoint('CENTER', 39, 0)
Rune.Rune[4]:SetPoint('CENTER', 65, 0)
Rune.Rune[5]:SetPoint('CENTER', -13, 0)
Rune.Rune[6]:SetPoint('CENTER', 13, 0)

Rune.Power = CreateFrame('StatusBar', nil, UIParent)
Rune.Power:SetHeight(3)
Rune.Power:SetWidth(198)
Rune.Power:SetPoint('TOP', Rune, 'BOTTOM', 0, -7)
Rune.Power:SetStatusBarTexture(C.Media.StatusBar)
Rune.Power:SetStatusBarColor(0.45, 0.85, 1, 1)
Rune.Power:SetAlpha(0)

Rune.Power.Value = Rune.Power:CreateFontString(nil, 'ARTWORK')
Rune.Power.Value:SetFont(C.Media.Font, 20, 'OUTLINE')
Rune.Power.Value:SetPoint('CENTER', Rune.Power, 0, 1.5)
Rune.Power.Value:SetVertexColor(0.45, 0.85, 1)

Rune.Power.Background = Rune.Power:CreateTexture(nil, 'BACKGROUND')
Rune.Power.Background:SetAllPoints(Rune.Power)
Rune.Power.Background:SetTexture(C.Media.StatusBar)
Rune.Power.Background:SetVertexColor(0.25, 0.25, 0.25, 1)

Rune.Power.Background.Shadow = CreateFrame('Frame', nil, Rune.Power)
Rune.Power.Background.Shadow:SetFrameStrata('BACKGROUND')
Rune.Power.Background.Shadow:SetPoint('TOPLEFT', -4, 4)
Rune.Power.Background.Shadow:SetPoint('BOTTOMRIGHT', 4, -4)
Rune.Power.Background.Shadow:SetBackdrop({
	BgFile = C.Media.Backdrop,
	edgeFile = 'Interface\\Addons\\LanUI\\media\\glowTex', edgeSize = 4,
	insets = {left = 3, right = 3, top = 3, bottom = 3}
})
Rune.Power.Background.Shadow:SetBackdropColor(0.15, 0.15, 0.15, 1)
Rune.Power.Background.Shadow:SetBackdropBorderColor(0, 0, 0)

Rune.Power.Below = Rune.Power:CreateTexture(nil, 'BACKGROUND')
Rune.Power.Below:SetHeight(14)
Rune.Power.Below:SetWidth(14)
Rune.Power.Below:SetTexture('Interface\\AddOns\\LanUI\\media\\textureArrowBelow')

Rune.Power.Above = Rune.Power:CreateTexture(nil, 'BACKGROUND')
Rune.Power.Above:SetHeight(14)
Rune.Power.Above:SetWidth(14)
Rune.Power.Above:SetTexture('Interface\\AddOns\\LanUI\\media\\textureArrowAbove')

local function GetCooldown(self)
    local start, duration, runeReady = GetRuneCooldown(self)
    local time = floor(GetTime() - start)
	local cooldown = ceil(duration - time)
    
	if (runeReady or UnitIsDeadOrGhost('player')) then
        return '#'
	elseif (not UnitIsDeadOrGhost('player') and cooldown) then
        return cooldown
    end
end

local function SetRuneColor(i)
	if (Rune.Rune[i].type == 4) then
		return 1, 0, 1
	else
		return RuneColor[i].r, RuneColor[i].g, RuneColor[i].b
	end
end

Rune:SetScript('OnEvent', function(self, event, arg1)
    if (event == 'RUNE_TYPE_UPDATE') then
		Rune.Rune[arg1].type = GetRuneType(arg1)
	end
    
    if (event == 'PLAYER_LOGIN') then
        Rune:SetAlpha(0.35)
    elseif (event == 'PLAYER_REGEN_ENABLED') then
        UIFrameFadeOut(Rune, 0.35, Rune:GetAlpha(), 0.35)
    elseif (event == 'PLAYER_REGEN_DISABLED') then
        UIFrameFadeIn(Rune, 0.35, Rune:GetAlpha(), 1)
    end
end)

local updateTimer = 0
Rune:SetScript('OnUpdate', function(self, elapsed)
	updateTimer = updateTimer + elapsed
	if (updateTimer > 0.25) then
		for i = 1, 6 do
            Rune.Rune[i]:SetText(GetCooldown(i))
            Rune.Rune[i]:SetTextColor(SetRuneColor(i))
		end
        
        Rune.Power:SetMinMaxValues(0, UnitPowerMax('player'))
        Rune.Power:SetValue(UnitPower('player'))
        
        Rune.Power.Value:SetText(UnitPower('player') > 0 and UnitPower('player') or '')

        local newPosition = UnitPower('player') / UnitPowerMax('player') * Rune.Power:GetWidth() - 7
        Rune.Power.Below:SetPoint('LEFT', Rune.Power, 'LEFT', newPosition, -8)
        Rune.Power.Above:SetPoint('LEFT', Rune.Power, 'LEFT', newPosition, 8)
        
        if (UnitPower('player') >= 1) then
           UIFrameFadeIn(Rune.Power, 0.35, Rune.Power:GetAlpha(), 0.8)
        else
           UIFrameFadeOut(Rune.Power, 0.35, Rune.Power:GetAlpha(), 0)
        end
        
		updateTimer   = 0
	end
end)]]