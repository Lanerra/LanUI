local F, C, G = unpack(select(2, ...))
local bc = C.Media.BorderColor
local _, ns = ...
local oUF = ns.oUF
local Interrupt = 'Interface\\Addons\\LanUI\\Media\\BorderInterrupt'
local objects = {}
local colors = oUF.colors
local isHealer = (F.MyClass == 'DRUID' or F.MyClass == 'PALADIN' or F.MyClass == 'PRIEST' or F.MyClass == 'SHAMAN')
local PlayerUnits = { player = true, pet = true, vehicle = true }
local fontstrings = {}
local PowerBarColor = PowerBarColor

-------------------------------------------------
-- Kill some unneeded settings
-------------------------------------------------

InterfaceOptionsFrameCategoriesButton11:SetScale(0.00001)
InterfaceOptionsFrameCategoriesButton11:SetAlpha(0)

-------------------------------------------------
-- Kill some unitframe stuff
-------------------------------------------------

for _, button in pairs({
    'CombatPanelTargetOfTarget',
    'CombatPanelEnemyCastBarsOnPortrait',
    'DisplayPanelShowAggroPercentage',
}) do
    _G['InterfaceOptions'..button]:SetAlpha(0.35)
    _G['InterfaceOptions'..button]:Disable()
    _G['InterfaceOptions'..button]:EnableMouse(false)
end

-------------------------------------------------
-- Lazy Stuff Goes Here!
-------------------------------------------------

do 
    for k, v in pairs(UnitPopupMenus) do
        for x, i in pairs(UnitPopupMenus[k]) do
            if (i == 'SET_FOCUS' or i == 'CLEAR_FOCUS') then
                table.remove(UnitPopupMenus[k],x)
            end
			
			if (i == 'PET_DISMISS') then
				table.remove(UnitPopupMenus[k],x)
			end
        end
    end
end

-------------------------------------------------
-- Variables for defining colors and appearance
-------------------------------------------------

local Loader = CreateFrame("Frame")
Loader:RegisterEvent("ADDON_LOADED")
Loader:SetScript("OnEvent", function(self, event, addon)
	if addon ~= "LanUI" then return end

	oUFLanAura = oUFLanAura or {}
	F.UpdateAuraList()
end)

-- A little backdrop local to save us some typing...because I'm lazy
local backdrop = {
	bgFile = C.Media.Backdrop,
	insets = {top = -1, left = -1, bottom = -1, right = -1},
}

-- Custom power colors

PowerBarColor['MANA'] = { r = 0/255, g = 0.55, b = 1 }
PowerBarColor['RAGE'] = { r = 240/255, g = 45/255, b = 75/255 }
PowerBarColor['FOCUS'] = { r = 255/255, g = 175/255, b = 0 }
PowerBarColor['ENERGY'] = { r = 1, g = 1, b = 35/255 }
PowerBarColor['RUNIC_POWER'] = { r = 0.45, g = 0.85, b = 1 }

-- Threat color handling
colors.threat = {}
for i = 1, 3 do
	local r, g, b = GetThreatStatusColor(i)
	oUF.colors.threat[i] = { r, g, b }
end

---- No More Lazy Stuff!

-- Border update function
local function UpdateBorder(self)
	local threat, debuff, dispellable = self.threatLevel, self.debuffType, self.debuffDispellable

	local color
	if debuff and dispellable then
		color = colors.debuff[debuff]
	elseif threat and threat > 1 then
		color = colors.threat[threat]
	elseif debuff then
		color = colors.debuff[debuff]
	elseif threat and threat > 0 then
		color = colors.threat[threat]
	end

	if color then
		self.Overlay:SetBeautyBorderColor(color[1], color[2], color[3])
		self.Overlay:SetBackdropBorderColor(color[1], color[2], color[3])
	else
		self.Overlay:SetBeautyBorderColor(bc.r, bc.g, bc.b)
		self.Overlay:SetBackdropBorderColor(bc.r, bc.g, bc.b)
	end
end

------------------------------------------
-- Functions used to build Unit Frames
------------------------------------------

-- Build dropdown menus
local dropdown = CreateFrame('Frame', 'oUF_LanerraDropDown', UIParent, 'UIDropDownMenuTemplate')

UIDropDownMenu_Initialize(dropdown, function(self)
	local unit = self:GetParent().unit
	if not unit then return end

	local menu, name, id
	if UnitIsUnit(unit, 'player') then
		menu = 'SELF'
	elseif UnitIsUnit(unit, 'vehicle') then
		menu = 'VEHICLE'
	elseif UnitIsUnit(unit, 'pet') then
		menu = 'PET'
	elseif UnitIsPlayer(unit) then
		id = UnitInRaid(unit)
		if id then
			menu = 'RAID_PLAYER'
			name = GetRaidRosterInfo(id)
		elseif UnitInParty(unit) then
			menu = 'PARTY'
		else
			menu = 'PLAYER'
		end
	else
		menu = 'TARGET'
		name = RAID_TARGET_ICON
	end
	if menu then
		UnitPopup_ShowMenu(self, menu, unit, name, id)
	end
end, 'MENU')

local function CreateDropDown(self)
	dropdown:SetParent(self)
    ToggleDropDownMenu(1, nil, dropdown, 'cursor', 15, -15)
end

local function PostCastStart(Castbar, unit)
    self.Castbar.SafeZone:SetDrawLayer('BORDER')
    self.Castbar.SafeZone:ClearAllPoints()
    self.Castbar.SafeZone:SetPoint('TOPRIGHT', self.Castbar)
    self.Castbar.SafeZone:SetPoint('BOTTOMRIGHT', self.Castbar)
    
    if (unit == 'target') then
        if (self.Castbar.interrupt) then
            self.Castbar.Borders:SetBeautyBorderTexture(Interrupt)
            self.Castbar.Borders:SetBeautyBorderColor(colors.uninterruptible[1], colors.uninterruptible[2], colors.uninterruptible[3])
        else
			if C.Media.ClassColor then
				self.Castbar.Borders:SetBeautyBorderTexture('white')
				self.Castbar.Borders:SetBeautyBorderColor(F.PlayerColor.r, F.PlayerColor.g, F.PlayerColor.b)
			else
				self.Castbar.Borders:SetBeautyBorderTexture('default')
				self.Castbar.Borders:SetBeautyBorderColor(C.Media.BorderColor)
			end
        end
    end
end

local function PostChannelStart(Castbar, unit)
    self.Castbar.SafeZone:SetDrawLayer('ARTWORK')
    self.Castbar.SafeZone:ClearAllPoints()
    self.Castbar.SafeZone:SetPoint('TOPLEFT', self.Castbar)
    self.Castbar.SafeZone:SetPoint('BOTTOMLEFT', self.Castbar)
    
    if (unit == 'target') then
        if (self.interrupt) then
			self.Castbar.Borders:SetBeautyBorderTexture(Interrupt)
            self.Castbar.Borders:SetBeautyBorderColor(colors.uninterruptible[1], colors.uninterruptible[2], colors.uninterruptible[3])
        else
			if C.Media.ClassColor then
				self.Castbar.Borders:SetBeautyBorderTexture('white')
				self.Castbar.Borders:SetBeautyBorderColor(F.PlayerColor.r, F.PlayerColor.g, F.PlayerColor.b)
			else
				self.Castbar.Borders:SetBeautyBorderTexture('default')
				self.Castbar.Borders:SetBeautyBorderColor(C.Media.BorderColor)
			end
        end
    end
end

-- Health update function of doom!
local function UpdateHealth(Health, unit, min, max)
    if (Health:GetParent().unit ~= unit) then
        return
	end
    
	if (not unit == 'pet' or unit == 'focus' or unit == 'targettarget' or unit == 'player') then
		if (UnitIsDead(unit) or UnitIsGhost(unit) or not UnitIsConnected(unit)) then
            Health:SetValue(0)
            Health:SetStatusBarColor(.5, .5, .5)
        end
	end
	
	if (unit == 'player') then
		if (C.UF.Units.Player.Health.Percent) then
			Health.Value:SetText((min / max * 100 and format('%d%%', min / max * 100)) or '')
		elseif (C.UF.Units.Player.Health.Deficit) then
			Health.Value:SetText((min ~= max) and format('%d', min - max) or '')
		elseif (C.UF.Units.Player.Health.Current) then
			Health.Value:SetText((min ~= max) and format('%d', min) or '')
		else
			Health.Value:SetText()
		end
	elseif (unit == 'target') then
		if (C.UF.Units.Target.Health.Percent) then
			Health.Value:SetText((min / max * 100 and format('%d%%', min / max * 100)) or '')
		elseif (C.UF.Units.Target.Health.Deficit) then
			Health.Value:SetText((min ~= max) and format('%d', min - max) or '')
		elseif (C.UF.Units.Target.Health.Current) then
			Health.Value:SetText(F.ShortValue(min))
		elseif (C.UF.Units.Target.Health.PerCur) then
            Health.Value:SetText((min/max * 100 and format('%s - %d%%', F.ShortValue(min), min/max * 100)))
        else
			Health.Value:SetText()
		end
	elseif (unit == 'targettarget') then
		if (C.UF.Units.ToT.Health.Percent) then
			Health.Value:SetText((min / max * 100 < 100 and format('%d%%', min / max * 100)) or '')
		elseif (C.UF.Units.ToT.Health.Deficit) then
			Health.Value:SetText((min ~= max) and format('%d', min - max) or '')
		elseif (C.UF.Units.ToT.Health.Current) then
			Health.Value:SetText((min ~= max) and format('%d', min) or '')
		else
			Health.Value:SetText()
		end
	elseif (unit == 'pet') then
		if (C.UF.Units.Pet.Health.Percent) then
			Health.Value:SetText((min / max * 100 < 100 and format('%d%%', min / max * 100)) or '')
		elseif (C.UF.Units.Pet.Health.Deficit) then
			Health.Value:SetText((min ~= max) and format('%d', min - max) or '')
		elseif (C.UF.Units.Pet.Health.Current) then
			Health.Value:SetText((min ~= max) and format('%d', min) or '')
		else
			Health.Value:SetText()
		end
	elseif (unit == 'focus') then
		if (C.UF.Units.Focus.Health.Percent) then
			Health.Value:SetText((min / max * 100 < 100 and format('%d%%', min / max * 100)) or '')
		elseif (C.UF.Units.Focus.Health.Deficit) then
			Health.Value:SetText((min ~= max) and format('%d', min - max) or '')
		elseif (C.UF.Units.Focus.Health.Current) then
			Health.Value:SetText((min ~= max) and format('%d', min) or '')
		else
			Health.Value:SetText()
		end
	end
	
	-- Bar Color Stuff	
	local color = RAID_CLASS_COLORS[select(2, UnitClass(unit))]
    if (C.UF.Show.ClassColorHealth) then
        Health.colorClass = true
    else
        Health:SetStatusBarColor(.25, .25, .25)
    end
end

-- Group update health function
local function UpdateGroupHealth(Health, unit, min, max)
	if (Health:GetParent().unit ~= unit) then
		return
	end
	
	if (UnitIsDead(unit) or UnitIsGhost(unit) or not UnitIsConnected(unit)) then
        Health:SetValue(0)
        Health:SetStatusBarColor(.5, .5, .5)
    end

    if (C.UF.Units.Party.Health.Percent) then
        Health.Value:SetText((min / max * 100 < 100 and format('%d%%', min / max * 100)) or '')
    elseif (C.UF.Units.Party.Health.Deficit) then
        Health.Value:SetText((min ~= max) and format('%d', min - max) or '')
    elseif (C.UF.Units.Party.Health.Current) then
        Health.Value:SetText((min ~= max) and format('%d', min) or '')
    else
        Health.Value:SetText()
    end
    
    local color = RAID_CLASS_COLORS[select(2, UnitClass(unit))]
    if (C.UF.Units.Party.Health.ClassColor) then
        Health.colorClass = true
    else
        Health:SetStatusBarColor(.25, .25, .25)
    end
end

-- Raid update health function
local function UpdateRaidHealth(Health, unit, min, max)
	if (Health:GetParent().unit ~= unit) then
		return
	end
	
	if (UnitIsDead(unit) or UnitIsGhost(unit) or not UnitIsConnected(unit)) then
		Health:SetValue(0)
        Health:SetStatusBarColor(.5, .5, .5)
	else
		if (C.UF.Units.Raid.Health.Percent) then
			Health.Value:SetText((min / max * 100 and format('%d%%', min / max * 100)) or '')
		elseif (C.UF.Units.Raid.Health.Deficit) then
			Health.Value:SetText((min ~= max) and format('%d', min - max) or '')
		elseif (C.UF.Units.Raid.Health.Current) then
			Health.Value:SetText((min ~= max) and format('%d', min) or '')
		else
			Health.Value:SetText()
		end
		
		local color = RAID_CLASS_COLORS[select(2, UnitClass(unit))]
		if (C.UF.Units.Raid.Health.ClassColor) then
			Health.colorClass = true
		else
			Health:SetStatusBarColor(.25, .25, .25)
		end
	end
end

-- Custom Power Updating Function
local function UpdatePower(Power, unit, min, max)
    local self = Power:GetParent()

	local _, PowerType, altR, altG, altB = UnitPowerType(unit)
	local UnitPower = PowerBarColor[PowerType]

    if (UnitIsDeadOrGhost(unit) or not UnitIsConnected(unit)) then
        Power:SetValue(0)
        Power.Value:SetText('')
    elseif (unit == 'player' and C.UF.Units.Player.ShowPowerText or unit == 'target' and C.UF.Units.Target.ShowPowerText) then
        if (unit == 'target' and max == 0) then
            Power.Value:SetText('')
        else
            Power.Value:SetText((min/max * 100 and format('%d%%', min/max * 100)))
        end
    else
        Power.Value:SetText()
    end

    if (UnitPower) then
        Power.Value:SetTextColor(UnitPower.r, UnitPower.g, UnitPower.b)
	else
        Power.Value:SetTextColor(altR, altG, altB)
	end
end

-- Add DruidPower support
local function UpdateDruidPower(self, event, unit)
    if (unit and unit ~= self.unit) then 
        return 
    end
    
	local unitPower = PowerBarColor['MANA']
    local mana = UnitPowerType('player') == 0
    local index = GetShapeshiftForm()

    if (index == 1 or index == 3) then
        if (unitPower) then
            self.Druid.Power:SetStatusBarColor(unitPower.r, unitPower.g, unitPower.b)
        end
        
        self.Druid.Power:SetAlpha(1)

        local min, max = UnitPower('player', 0), UnitPowerMax('player', 0)

        self.Druid.Power:SetMinMaxValues(0, max)
        self.Druid.Power:SetValue(min)
    else
        self.Druid.Power:SetAlpha(0)
    end
end

-- Runes, sucka!
if F.MyClass == 'DEATHKNIGHT' then
	-- Better unholy color:
	oUF.colors.runes[2][1] = 0.3
	oUF.colors.runes[2][2] = 0.9
	oUF.colors.runes[2][3] = 0

	-- Better frost color:
	oUF.colors.runes[3][1] = 0
	oUF.colors.runes[3][2] = 0.8
	oUF.colors.runes[3][3] = 1

	-- Better death color:
	oUF.colors.runes[4][1] = 0.8
	oUF.colors.runes[4][2] = 0.5
	oUF.colors.runes[4][3] = 1
end

-- Aura Icons for our unit frames
-- Aura Icon Show
local AuraIconCD_OnShow = function(cd)
	local button = cd:GetParent()
	button.count:SetParent(cd)
end

-- Aura Icon Hide
local AuraIconCD_OnHide = function(cd)
	local button = cd:GetParent()
	button.count:SetParent(button)
end

-- Aura Icon Overlay
local AuraIconOverlay_SetBorderColor = function(overlay, r, g, b)
	if not r or not g or not b then
		if C.Media.ClassColor then
			r, g, b = F.PlayerColor.r, F.PlayerColor.g, F.PlayerColor.b
		else
			r, g, b = unpack(C.Media.BorderColor)
		end
	end
	
	local over = overlay:GetParent()
	over.border:SetBeautyBorderColor(r, g, b)
end

-- Aura Icon Creation Function
local function PostCreateAuraIcon(iconframe, button)
	local border = CreateFrame('Frame', nil, button)
	border:SetAllPoints(button)
	border:SetTemplate()
	border:SetBeautyBorderPadding(2)
	border:SetBackdropColor(0, 0, 0, 0)
	button.border = border

	button.cd:SetReverse(true)
	button.cd:SetScript('OnHide', AuraIconCD_OnHide)
	button.cd:SetScript('OnShow', AuraIconCD_OnShow)
	if button.cd:IsShown() then
        AuraIconCD_OnShow(button.cd)
    end
    
	button.icon:SetTexCoord(0.03, 0.97, 0.03, 0.97)

	button.overlay:Hide()
	button.overlay.Hide = AuraIconOverlay_SetBorderColor
	button.overlay.SetVertexColor = AuraIconOverlay_SetBorderColor
	button.overlay.Show = F.Dummy
end

-- Aura Icon Update Function
local function PostUpdateAuraIcon(iconframe, unit, button, index, offset)
	local name, _, texture, count, type, duration, timeLeft, caster, isStealable, shouldConsolidate, spellID = UnitAura(unit, index, button.filter)

	if PlayerUnits[caster] then
		button.icon:SetDesaturated(false)
	else
		button.icon:SetDesaturated(true)
	end

	if button.timer then return end

	if OmniCC then
		for i = 1, button:GetNumChildren() do
			local child = select(i, button:GetChildren())
			if child.text and (child.icon == button.icon or child.cooldown == button.cd) then
				-- found it!
				child.SetAlpha = F.Dummy
				child.SetScale = F.Dummy

				child.text:ClearAllPoints()
				child.text:SetPoint('CENTER', button, 'TOP', 0, 2)

				child.text:SetFont(C.Media.Font, unit:match('^party') and 14 or 18)
				child.text.SetFont = F.Dummy

				child.text:SetTextColor(1, 0.8, 0)
                child.text:SetShadowOffset(1, -1)
				child.text.SetTextColor = F.Dummy
				child.text.SetVertexColor = F.Dummy

				tinsert(fontstrings, child.text)

				button.timer = child.text

				return
			end
		end
	else
		button.timer = true
	end
end

-- Dispel highlighting function
local function UpdateDispelHighlight(element, debuffType, canDispel)
	local frame = element.__owner

	if frame.debuffType == debuffType then return end

	frame.debuffType = debuffType
	frame.debuffDispellable = canDispel

	frame:UpdateBorder()
end

-- Threat highlighting function
local function UpdateThreatHighlight(element, status)
	if not status then
		status = 0
	end

	local frame = element.__owner
	if frame.threatLevel == status then return end

	frame.threatLevel = status

	frame:UpdateBorder()
end

-- Time to give our solo unit frames some style!
local Stylish = function(self, unit, isSingle)
	self.menu = CreateDropDown
    
    self:SetScript('OnEnter', UnitFrame_OnEnter)
    self:SetScript('OnLeave', UnitFrame_OnLeave)
    
	self.ignoreHealComm = true
	
	tinsert(objects, self)
	
	self:EnableMouse(true)
	self:RegisterForClicks('AnyUp')
	
    -- Health Bar-specific stylings
	self.Health = CreateFrame('StatusBar', '$parentHealthBar', self)
	self.Health:SetHeight(C.UF.Units.Player.Height * .87)
	self.Health:SetStatusBarTexture(C.Media.StatusBar)
	
	-- Turn on the smoothness
	self.Health.Smooth = true
	
	self.Health.frequentUpdates = 0.2
	
	self.Health:SetParent(self)
	self.Health:SetPoint('TOP')
	self.Health:SetPoint('LEFT')
	self.Health:SetPoint('RIGHT')
	
	self:SetBackdrop(backdrop)
	self:SetBackdropColor(unpack(C.Media.BackdropColor))
	
	if (unit == 'player') then
		--local info = self.Health:CreateFontString('$parentInfo', 'OVERLAY', 'GameFontHighlightSmall')
		local info = self.Health:CreateFontString('$parentInfo', 'OVERLAY')
        info:SetFont(C.Media.Font, C.UF.Media.FontSize)
		info:SetPoint('CENTER', self.Health)
		info.frequentUpdates = .25
		self:Tag(info, '[LanThreat] |cffff0000[LanPvPTime]|r')
	end
	
	-- Setup our health text
	self.Health.Value = self.Health:CreateFontString('$parentHealthValue', 'OVERLAY')
	self.Health.Value:SetFont(C.Media.Font, C.UF.Media.FontSize)
	self.Health.Value:SetShadowOffset(1, -1)
	self.Health.Value:SetTextColor(1, 1, 1)
	
	self.Health.PostUpdate = UpdateHealth
	
	-- And now for the power bar and text stuff
	self.Power = CreateFrame('StatusBar', '$parentPowerBar', self)
	self.Power:SetHeight(C.UF.Units.Player.Height * .11)
	self.Power:SetStatusBarTexture(C.Media.StatusBar)
    
	self.Power.colorClass = true
	self.Power.colorTapping = true
    self.Power.colorReaction = true
    	
	-- We like to keep things smooth around here
    self.Power.frequentUpdates = 0.2
    self.Power.Smooth = true
    	
	self.Power:SetParent(self)
	self.Power:SetPoint('BOTTOM')
	self.Power:SetPoint('LEFT', .2, 0)
	self.Power:SetPoint('RIGHT', -.2, 0)
	
	-- Now, the power bar's text
	self.Power.Value = self.Power:CreateFontString('$parentPowerValue', 'OVERLAY')
	self.Power.Value:SetFont(C.Media.Font, C.UF.Media.FontSize)
	self.Power.Value:SetShadowOffset(1, -1)
    if (unit == 'target') then
        self.Power.Value:SetPoint('TOPRIGHT', self.Power, 'BOTTOMRIGHT', 0, -5)
    elseif (unit == 'player') then
        self.Power.Value:SetPoint('TOPLEFT', self.Power, 'BOTTOMLEFT', 0, -5)
    end
	
	self.Power.Value:SetTextColor(1, 1, 1)
    self.Power.Value:SetJustifyH('LEFT')
    self.Power.Value.frequentUpdates = 0.1
    
	if (unit == 'targettarget') then
		self.Power:Hide()
		self.Power.Show = self.Power.Hide
		self.Health:SetAllPoints(self)
	end
    
    if (unit == 'focus' and C.UF.Units.Focus.VerticalHealth) then
		self.Power:Hide()
		self.Power.Show = self.Power.Hide
		self.Health:SetAllPoints(self)
		self.Health:SetOrientation('VERTICAL')
	else
		self.Health:SetOrientation('HORIZONTAL')
	end
	
    self.Power.PostUpdate = UpdatePower
	
	-- Set this up now for our borders later
	self.Overlay = CreateFrame('Frame', nil, self)
    
	-- Now, to hammer out our castbars
	if (C.UF.Show.CastBars) then
        if (unit == 'player') then
			self.Castbar = CreateFrame('StatusBar', '$parentCastBar', self)
            self.Castbar:SetStatusBarTexture(C.Media.StatusBar)
			self.Castbar:SetScale(C.UF.CastBars.Player.Scale)
			self.Castbar:SetStatusBarColor(unpack(C.UF.CastBars.Player.Color))
            
            self.Castbar.Borders = CreateFrame('Frame', nil, self.Castbar)
            self.Castbar.Borders:SetPoint('TOPLEFT', 0, 1)
			self.Castbar.Borders:SetPoint('BOTTOMRIGHT', 1, 0)
            self.Castbar.Borders:SetFrameStrata('HIGH')
            
			self.Castbar.Borders:SetTemplate(true)
			self.Castbar.Borders:SetBeautyBorderPadding(3)
			self.Castbar.Borders:SetBackdropColor(0, 0, 0, 0)
			
			self.Castbar:SetHeight(C.UF.CastBars.Player.Height)
			self.Castbar:SetWidth(C.UF.CastBars.Player.Width)
			self.Castbar:SetParent(self)
			self.Castbar:SetPoint(unpack(C.UF.CastBars.Player.Position))
			
			self.Castbar.Bg = self.Castbar:CreateTexture('$parentCastBarBackground', 'BORDER')
			self.Castbar.Bg:SetAllPoints(self.Castbar)
			self.Castbar.Bg:SetTexture(unpack(C.Media.BackdropColor))
			
			self.Castbar.Text = self.Castbar:CreateFontString('$parentCastBarText', 'OVERLAY')
			self.Castbar.Text:SetFont(C.Media.Font, 13)
			self.Castbar.Text:SetShadowOffset(1, -1)
			self.Castbar.Text:SetPoint('LEFT', self.Castbar, 'LEFT', 2, 0)
			self.Castbar.Text:SetHeight(C.UF.Media.FontSize)
			self.Castbar.Text:SetWidth(130)
			self.Castbar.Text:SetJustifyH('LEFT')
			self.Castbar.Text:SetParent(self.Castbar)
			self.Castbar.CustomTimeText = function(self, duration)
				self.Time:SetFormattedText('%.1f/%.1f', duration, self.max)
			end
			
			self.Castbar.Time = self.Castbar:CreateFontString('$parentCastBarTime', 'OVERLAY')
			self.Castbar.Time:SetFont(C.Media.Font, 13)
			self.Castbar.Time:SetShadowOffset(1, -1)
			self.Castbar.Time:SetPoint('RIGHT', self.Castbar, 'RIGHT', -2, 0)
			self.Castbar.Time:SetParent(self.Castbar)
			self.Castbar.Time:SetJustifyH('RIGHT')
			self.Castbar.CustomDelayText = function(self, duration)
				self.Time:SetFormattedText('[|cffff0000-%.1f|r] %.1f/%.1f', self.delay, duration, self.max)
			end
			
			self.Castbar.SafeZone = self.Castbar:CreateTexture('$parentCastBarSafeZone', 'OVERLAY')
			self.Castbar.SafeZone:SetTexture(C.Media.Backdrop)
			self.Castbar.SafeZone:SetVertexColor(1, .5, 0, .25)
            
			self.PostChannelStart = UpdateChannelStart
			self.PostCastStart = UpdateCastStart
		elseif (unit == 'target') then
			self.Castbar = CreateFrame('StatusBar', '$parentCastBar', self)
			self.Castbar:SetStatusBarTexture(C.Media.StatusBar)
			self.Castbar:SetStatusBarColor(unpack(C.UF.CastBars.Target.Color))
			self.Castbar:SetWidth(C.UF.CastBars.Target.Width)
			self.Castbar:SetScale(C.UF.CastBars.Target.Scale)
			
            self.Castbar.Borders = CreateFrame('Frame', nil, self.Castbar)
            self.Castbar.Borders:SetPoint('TOPLEFT', 0, 1)
			self.Castbar.Borders:SetPoint('BOTTOMRIGHT', 1, 0)
            self.Castbar.Borders:SetFrameStrata('HIGH')
            
			self.Castbar.Borders:SetTemplate(true)
			self.Castbar.Borders:SetBeautyBorderPadding(3)
			self.Castbar.Borders:SetBackdropColor(0, 0, 0, 0)
			
			self.Castbar:SetHeight(C.UF.CastBars.Target.Height)
			self.Castbar:SetParent(self)
			self.Castbar:SetPoint(unpack(C.UF.CastBars.Target.Position))
			
			self.Castbar.Bg = self.Castbar:CreateTexture('$parentCastBarBackground', 'BORDER')
			self.Castbar.Bg:SetAllPoints(self.Castbar)
			self.Castbar.Bg:SetTexture(unpack(C.Media.BackdropColor))
			
			self.Castbar.Text = self.Castbar:CreateFontString('$parentCastBarText', 'OVERLAY')
			self.Castbar.Text:SetFont(C.Media.Font, 13)
			self.Castbar.Text:SetShadowOffset(1, -1)
			self.Castbar.Text:SetPoint('LEFT', self.Castbar, 'LEFT', 2, 0)
			self.Castbar.Text:SetHeight(C.UF.Media.FontSize)
			self.Castbar.Text:SetWidth(130)
			self.Castbar.Text:SetJustifyH('LEFT')
			
			self.Castbar.Time = self.Castbar:CreateFontString('$parentCastBarTime', 'OVERLAY')
			self.Castbar.Time:SetFont(C.Media.Font, 13)
			self.Castbar.Time:SetShadowOffset(1, -1)
			self.Castbar.Time:SetPoint('RIGHT', self.Castbar, 'RIGHT', -2, 0)
			self.Castbar.CustomTimeText = function(self, duration)
				if (self.casting) then
					self.Time:SetFormattedText('%.1f', self.max - duration)
				elseif (self.channeling) then
					self.Time:SetFormattedText('%.1f', duration)
				end
			end
			
			self.PostChannelStart = PostChannelStart
			self.PostCastStart = PostCastStart
		end
	end
	
	-- Now to skin and setup our Mirror Timers
	for _, bar in pairs({
		'MirrorTimer1',
		'MirrorTimer2',
		'MirrorTimer3',
	}) do
		for i, region in pairs({_G[bar]:GetRegions()}) do
			if (region.GetTexture and region:GetTexture() == 'SolidTexture') then
				region:Hide()
			end
		end
		
        MirrorBorder = CreateFrame('Frame', nil, _G[bar])
        MirrorBorder:SetAllPoints(_G[bar])
        MirrorBorder:SetFrameLevel(_G[bar]:GetFrameLevel() + 2)
		MirrorBorder:SetTemplate(true)
		MirrorBorder:SetBeautyBorderPadding(2)
		--MirrorBorder:SetBackdropColor(0, 0, 0, 0)
		
		_G[bar..'Border']:Hide()
		
		_G[bar]:SetParent(UIParent)
		_G[bar]:SetScale(1.135)
		_G[bar]:SetHeight(18)
		_G[bar]:SetWidth(200)
		
		_G[bar..'Background'] = _G[bar]:CreateTexture(bar..'Background', 'BACKGROUND', _G[bar])
		_G[bar..'Background']:SetTexture(C.Media.Backdrop)
		_G[bar..'Background']:SetAllPoints(bar)
		_G[bar..'Background']:SetVertexColor(unpack(C.Media.BackdropColor))
		
		_G[bar..'Text']:SetFont(CastingBarFrameText:GetFont(), 13)
		_G[bar..'Text']:ClearAllPoints()
		_G[bar..'Text']:SetPoint('CENTER', MirrorTimer1StatusBar)
		
		_G[bar..'StatusBar']:SetAllPoints(_G[bar])
		_G[bar..'StatusBar']:SetStatusBarTexture(C.Media.StatusBar)
	end
	
	-- Display the names
	if (unit ~= 'player') then
		local name = self.Health:CreateFontString('$parentName', 'OVERLAY')
		name:SetFont(C.Media.Font, C.UF.Media.FontSize)
		name:SetShadowOffset(1, -1)
		name:SetTextColor(1, 1, 1)
		name:SetWidth(130)
        name:SetParent(self.Overlay)
		name:SetHeight(C.UF.Media.FontSize)
        name.frequentUpdates = 0.2
        
        self.Health.Value:SetParent(self.Overlay)
        
        self.Info = name
        self:Tag(self.Info, '[LanShortName]')
        
        if (unit == 'targettarget') then
            self.Health.Value:SetPoint('BOTTOM', self.Health, 0, 1)
            self.Health.Value:Hide()
            
            if (C.UF.Units.ToT.Health.Percent or C.UF.Units.ToT.Health.Deficit or C.UF.Units.ToT.Health.Current) then
                name:SetPoint('TOP', self.Health, 0, -1)
                self.Health.Value:Show()
            else
                name:SetPoint('CENTER', self.Health)
                name:Show()
                self.Health.Value:Hide()
            end
		elseif (unit == 'pet' and C.UF.Units.Pet.ShowPowerText) then
            name:Hide()
            
            if (C.UF.Units.Pet.Health.Percent or C.UF.Units.Pet.Health.Deficit or C.UF.Units.Pet.Health.Current) then
                self.Power.Value:SetPoint('RIGHT', self.Health, -2, 0)
                self.Health.Value:SetPoint('LEFT', self.Health, 2, -1)
            end
        elseif (unit == 'pet' and not C.UF.Units.Pet.ShowPowerText) then
            name:SetPoint('CENTER', self.Health)
            self:Tag(self.Info, '[LanName]')
        elseif (unit == 'focus') then
            name:SetText()
        elseif (unit == 'target') then
            name:SetPoint('LEFT', self.Health, 'LEFT', 1, 0)
			name:SetJustifyH('LEFT')
            self:Tag(self.Info, '[LanLevel][LanClassification] [LanName]')
            self.Health.Value:SetPoint('RIGHT', self.Health, -2, -1)
        else
			name:SetPoint('LEFT', self.Health, 'LEFT', 1, 0)
			name:SetJustifyH('LEFT')
            self:Tag(self.Info, '[LanName]')
		end
    else
        self.Health.Value:SetPoint('RIGHT', self.Health, -2, -1)
    end
    
    if C.UF.Show.HealerOverride or isHealer then
        if (unit == 'target') then
            local MHPB = CreateFrame('StatusBar', nil, self.Health)
            MHPB:SetOrientation('HORIZONTAL')
            MHPB:SetPoint('LEFT', self.Health:GetStatusBarTexture(), 'RIGHT', 0, 0)
            MHPB:SetStatusBarTexture(C.Media.StatusBar)
            MHPB:SetWidth(self.Health:GetWidth())
            MHPB:SetHeight(self.Health:GetHeight())
            MHPB:SetStatusBarColor(0, 1, 0.5, 0.25)

            local OHPB = CreateFrame('StatusBar', nil, self.Health)
            OHPB:SetOrientation('HORIZONTAL')
            OHPB:SetPoint('LEFT', MHPB:GetStatusBarTexture(), 'RIGHT', 0, 0)
            OHPB:SetStatusBarTexture(C.Media.StatusBar)
            OHPB:SetWidth(self.Health:GetWidth())
            OHPB:SetHeight(self.Health:GetHeight())
            OHPB:SetStatusBarColor(0, 1, 0, 0.25)

            self.HealPrediction = {
                myBar = MHPB,
                otherBar = OHPB,
                maxOverflow = 1,
            }
        end
    end
    
	-- Display icons
	if (unit == 'player') then
		self.Status = self.Health:CreateFontString(nil, 'OVERLAY')
        self.Status:SetParent(self.Overlay)
        self.Status:SetFont(C.Media.Font, C.UF.Media.FontSize)
		self.Status:SetPoint('LEFT', self.Health, 'TOPLEFT', 2, 2)
		self.Status:SetDrawLayer('OVERLAY', 7)

		self:Tag(self.Status, '[LanLeader][LanMaster]')
        
        self.Resting = self.Overlay:CreateTexture(nil, 'OVERLAY')
        self.Resting:SetParent(self.Overlay)
		self.Resting:SetPoint('CENTER', self.Health, 'BOTTOMLEFT', 0, -4)
		self.Resting:SetSize(20, 20)
		self.Resting:SetDrawLayer('OVERLAY', 7)

		self.Combat = self.Health:CreateTexture(nil, 'OVERLAY')
        self.Combat:SetParent(self.Overlay)
		self.Combat:SetPoint('CENTER', self.Health, 'BOTTOMRIGHT', 0, -4)
		self.Combat:SetSize(24, 24)
		self.Combat:SetDrawLayer('OVERLAY', 7)
    end
    
    -- Aura/buff/debuff handling, update those suckers!
    if (unit == 'player' and C.UF.Units.Player.ShowBuffs) then
		local GAP = 4

		self.Buffs = CreateFrame('Frame', nil, self)
		self.Buffs:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 0, 10)
		self.Buffs:SetPoint('BOTTOMRIGHT', self, 'TOPRIGHT', 0, 10)
		self.Buffs:SetHeight(30)

		self.Buffs['growth-x'] = 'LEFT'
		self.Buffs['growth-y'] = 'UP'
		self.Buffs['initialAnchor'] = 'BOTTOMRIGHT'
		self.Buffs['num'] = math.floor((C.UF.Units.Player.Width - 4 + GAP) / (30 + GAP))
		self.Buffs['size'] = C.UF.Units.Player.Height - 6
		self.Buffs['spacing-x'] = GAP
		self.Buffs['spacing-y'] = GAP

		self.Buffs.CustomFilter   = F.CustomAuraFilters.player
		self.Buffs.PostCreateIcon = PostCreateAuraIcon
		self.Buffs.PostUpdateIcon = PostUpdateAuraIcon

		self.Buffs.parent = self
	elseif (unit == 'target') and C.UF.Units.Target.ShowBuffs then
		local GAP = 4

        local MAX_ICONS = math.floor((C.UF.Units.Target.Width + GAP) / (C.UF.Units.Target.Height + GAP)) - 1
        local NUM_BUFFS = math.max(1, math.floor(MAX_ICONS * 0.2))
        local NUM_DEBUFFS = math.min(MAX_ICONS - 1, math.floor(MAX_ICONS * 0.8))

		if (isHealer) then
            local debuff = NUM_DEBUFFS - 1
            local buff = NUM_BUFFS + 1
        else
            local debuff = NUM_DEBUFFS - 1
            local buff = NUM_BUFFS + 1
        end
        
        self.Debuffs = CreateFrame('Frame', nil, self)
        self.Debuffs:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', -2, 16)
		self.Debuffs:SetWidth((C.UF.Units.Target.Height * NUM_DEBUFFS - 1) + (GAP * (NUM_DEBUFFS - 1)))
		self.Debuffs:SetHeight((C.UF.Units.Target.Height * 2) + (GAP * 2))

		self.Debuffs['growth-x'] = 'RIGHT'
		self.Debuffs['growth-y'] = 'UP'
		self.Debuffs['initialAnchor'] = 'BOTTOMLEFT'
		self.Debuffs['num'] = debuffs
		self.Debuffs['showType'] = false
		self.Debuffs['size'] = C.UF.Units.Target.Height - 6
		self.Debuffs['spacing-x'] = GAP
		self.Debuffs['spacing-y'] = GAP * 2

		self.Debuffs.CustomFilter   = F.CustomAuraFilters.target
		self.Debuffs.PostCreateIcon = PostCreateAuraIcon
		self.Debuffs.PostUpdateIcon = PostUpdateAuraIcon

		self.Debuffs.parent = self

		self.Buffs = CreateFrame('Frame', nil, self)
        self.Buffs:SetPoint('BOTTOMRIGHT', self, 'TOPRIGHT', 2, 16)
		self.Buffs:SetWidth((C.UF.Units.Target.Height * NUM_BUFFS + 1) + (GAP * (NUM_BUFFS - 1)))
		self.Buffs:SetHeight((C.UF.Units.Target.Height * 2) + (GAP * 2))

		self.Buffs['growth-x'] = 'LEFT'
		self.Buffs['growth-y'] = 'UP'
		self.Buffs['initialAnchor'] = 'BOTTOMRIGHT'
		self.Buffs['num'] = buffs
		self.Buffs['showType'] = false
		self.Buffs['size'] = C.UF.Units.Target.Height - 6
		self.Buffs['spacing-x'] = GAP
		self.Buffs['spacing-y'] = GAP * 2

		

		self.Buffs.CustomFilter   = F.CustomAuraFilters.target
		self.Buffs.PostCreateIcon = PostCreateAuraIcon
		self.Buffs.PostUpdateIcon = PostUpdateAuraIcon

		self.Buffs.parent = self
	end
	
	-- Various oUF plugins support
	if (unit == 'player' and F.MyClass == 'DEATHKNIGHT') then
		local Runes = {}
		for index = 1, 6 do
			-- Position and size of the rune bar indicators
			local Rune = CreateFrame('StatusBar', nil, self)
			Rune:SetStatusBarTexture(C.Media.StatusBar)
			Rune:SetSize(C.UF.Units.Player.Width / F.Scale(6) - F.Mult + 0.35, 6)
			Runes[index] = Rune
			
			if index == 1 then
				Runes[index]:Point('BOTTOMLEFT', self, 'TOPLEFT', F.Scale(2), F.Mult)
				Runes[index]:CreateBD()
			else
				Runes[index]:Point('LEFT', Runes[index - 1], 'RIGHT', F.Mult, 0)
			end
		end
		
		Runes[1].backdrop:Point('TOPLEFT', Runes[1])
		Runes[1].backdrop:Point('BOTTOMRIGHT', Runes[6])
		-- Register with oUF
		self.Runes = Runes
    end

    -- DruidPower Support
    if (unit == 'player' and F.MyClass == 'DRUID') then    
        self.Druid = CreateFrame('Frame')
        self.Druid:SetParent(self) 
        self.Druid:SetFrameStrata('LOW')

        self.Druid.Power = CreateFrame('StatusBar', nil, self)
        self.Druid.Power:SetPoint('TOP', self.Power, 'BOTTOM', 0, -7)
        self.Druid.Power:SetStatusBarTexture(C.Media.StatusBar)
        self.Druid.Power:SetFrameStrata('LOW')
        self.Druid.Power:SetFrameLevel(self.Druid:GetFrameLevel() - 1)
        self.Druid.Power:SetHeight(self.Power:GetHeight())
        self.Druid.Power:SetWidth(self.Power:GetWidth())
        self.Druid.Power:SetBackdrop(backdrop)
        self.Druid.Power:SetBackdropColor(unpack(C.Media.BackdropColor))
        
        self.DruidBorder = CreateFrame('Frame', nil, self.Druid.Power)
        self.DruidBorder:SetAllPoints(self.Druid.Power)
        self.DruidBorder:SetFrameLevel(self.Druid.Power:GetFrameLevel() + 2)
        
        self.DruidBorder:SetTemplate()
        self.DruidBorder:SetBackdropColor(0, 0, 0, 0)
		
        table.insert(self.__elements, UpdateDruidPower)
        self:RegisterEvent('UNIT_MANA', UpdateDruidPower)
        self:RegisterEvent('UNIT_RAGE', UpdateDruidPower)
        self:RegisterEvent('UNIT_ENERGY', UpdateDruidPower)
        self:RegisterEvent('UPDATE_SHAPESHIFT_FORM', UpdateDruidPower)
    end
    
    -- Eclipse Bar Support
    if (F.MyClass == 'DRUID') then
        local EclipseBar = CreateFrame('Frame', nil, self)
        EclipseBar:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 0, -10)
        EclipseBar:SetPoint('TOPRIGHT', self, 'BOTTOMRIGHT', 0, -10)
        EclipseBar:SetSize(self.Power:GetWidth(), self.Power:GetHeight())
        EclipseBar:SetBackdrop(backdrop)
        EclipseBar:SetBackdropColor(unpack(C.Media.BackdropColor))
        
        local EclipseBarBorder = CreateFrame('Frame', nil, EclipseBar)
        EclipseBarBorder:SetAllPoints(EclipseBar)
        EclipseBarBorder:SetTemplate()
		EclipseBarBorder:SetBeautyBorderPadding(4)
		EclipseBarBorder:SetBackdropColor(0, 0, 0, 0)

        local LunarBar = CreateFrame('StatusBar', nil, EclipseBar)
        LunarBar:SetPoint('LEFT', EclipseBar, 'LEFT', 0, 0)
        LunarBar:SetSize(self.Power:GetWidth(), self.Power:GetHeight())
        LunarBar:SetStatusBarTexture(C.Media.StatusBar)
        LunarBar:SetStatusBarColor(1, 1, 1)
        EclipseBar.LunarBar = LunarBar

        local SolarBar = CreateFrame('StatusBar', nil, EclipseBar)
        SolarBar:SetPoint('LEFT', LunarBar:GetStatusBarTexture(), 'RIGHT', 0, 0)
        SolarBar:SetSize(self.Power:GetWidth(), self.Power:GetHeight())
        SolarBar:SetStatusBarTexture(C.Media.StatusBar)
        SolarBar:SetStatusBarColor(1, 3/5, 0)
        EclipseBar.SolarBar = SolarBar

        local EclipseBarText = EclipseBarBorder:CreateFontString(nil, 'OVERLAY')
        EclipseBarText:SetPoint('CENTER', EclipseBarBorder, 'CENTER', 0, 0)
        EclipseBarText:SetFont(C.Media.Font, C.UF.Media.FontSize, 'OUTLINE')
        self:Tag(EclipseBarText, '[pereclipse]%')

        self.EclipseBar = EclipseBar
    end
    
    -- Soul Shard Support
	if (F.MyClass == 'WARLOCK') then
        local Shards = self:CreateFontString(nil, 'OVERLAY')
        Shards:SetPoint('CENTER', self, 'RIGHT', 17, -2)
        Shards:SetFont(C.Media.Font, 24, 'OUTLINE')
        Shards:SetJustifyH('CENTER')
        self:Tag(Shards, '[LanShards]')
    end

    -- Holy Power Support
    if (F.MyClass == 'PALADIN') then
        local HolyPower = self:CreateFontString(nil, 'OVERLAY')
        HolyPower:SetPoint('CENTER', self, 'RIGHT', 17, -2)
        HolyPower:SetFont(C.Media.Font, 24, 'OUTLINE')
        HolyPower:SetJustifyH('CENTER')
        self:Tag(HolyPower, '[LanHolyPower]')
    end
    
    -- Combo points display
	if (F.MyClass == 'ROGUE') or (F.MyClass == 'DRUID') then
        local ComboPoints = self:CreateFontString(nil, 'OVERLAY')
        ComboPoints:SetPoint('CENTER', self, 'RIGHT', 17, -2)
        ComboPoints:SetFont(C.Media.Font, 24, 'OUTLINE')
        ComboPoints:SetJustifyH('CENTER')
        self:Tag(ComboPoints, '[LanCombo]')
    end
    
    -- Chi display
    if (F.MyClass == 'MONK') then
        local Chi = self:CreateFontString(nil, 'OVERLAY')
        Chi:SetPoint('CENTER', self, 'RIGHT', 17, 0)
        Chi:SetFont(C.Media.Font, 24, 'OUTLINE')
        Chi:SetJustifyH('CENTER')
        self:Tag(Chi, '[LanChi]')
    end
	
    -- Raid Icons
    if (unit == 'target') then
        self.RaidIcon = self.Overlay:CreateTexture('$parentRaidIcon', 'ARTWORK')
        self.RaidIcon:SetHeight(18)
        self.RaidIcon:SetWidth(18)
        self.RaidIcon:SetPoint('CENTER', self.Overlay, 'TOP')
		self.RaidIcon:SetDrawLayer('OVERLAY', 7)
    end
    
	-- Custom sizes for our frames
    if (isSingle) then
        if (unit == 'player') then
            self:SetSize(C.UF.Units.Player.Width, C.UF.Units.Player.Height)
        elseif (unit == 'target') then
            self:SetSize(C.UF.Units.Target.Width, C.UF.Units.Target.Height)
        elseif (unit == 'pet') then
            self:SetSize(C.UF.Units.Pet.Width, C.UF.Units.Pet.Height)
        end
        
        if (C.UF.Show.ToT) then
            if (unit == 'targettarget') then
                self:SetSize(C.UF.Units.ToT.Width, C.UF.Units.ToT.Height)
            end
        end
        
        if (C.UF.Show.Focus) then
            if (unit == 'focus') then
                self:SetSize(C.UF.Units.Focus.Width, C.UF.Units.Focus.Height)
            end
        end
    end
	
    -- Hardcore border action!	
	if unit == 'player' and F.MyClass == 'DEATHKNIGHT' then
		self.Overlay:Point('TOPLEFT', self.Runes[1])
		self.Overlay:Point('BOTTOMRIGHT', self)
	else
		self.Overlay:ClearAllPoints()
		self.Overlay:Point('TOPLEFT', self, 'TOPLEFT', -(F.Mult * 2), F.Mult * 2)
		self.Overlay:Point('BOTTOMRIGHT', self, 'BOTTOMRIGHT', F.Mult * 2, -(F.Mult * 2))
	end
	
	--self.Overlay:SetFrameLevel(self.Health:GetFrameLevel() + (self.Power and 3 or 2))
    self.Overlay:SetTemplate(true)
	self.Overlay:SetBeautyBorderPadding(2)
    
    self.UpdateBorder = UpdateBorder

    -- Dispel highlight support
    self.DispelHighlight = {
		Override = UpdateDispelHighlight,
		filter = true,
	}
    
    -- Threat highlight support
    self.threatLevel = 0
	self.ThreatHighlight = {
		Override = UpdateThreatHighlight,
	}
	
	self:CreateBD()
	self.backdrop:ClearAllPoints()
	self.backdrop:Point('TOPLEFT', self, 'TOPLEFT', -(F.Mult * 2), F.Mult * 2)
	self.backdrop:Point('BOTTOMRIGHT', self, 'BOTTOMRIGHT', F.Mult * 2, -(F.Mult * 2))
    return self
end

-- First build the group style
local function StylishGroup(self, unit)
	self.menu = CreateDropDown
    
    self:SetScript('OnEnter', UnitFrame_OnEnter)
    self:SetScript('OnLeave', UnitFrame_OnLeave)
    
	self.ignoreHealComm = true
	
--    print('Spawn', self:GetName(), unit)
	tinsert(objects, self)
    
	self:EnableMouse(true)
	self:RegisterForClicks('AnyUp')
	
	if C.UF.Show.Party and not InCombatLockdown() then
		if C.UF.Units.Party.Healer then
			self:SetSize(100, 35)
		else
			self:SetSize(C.UF.Units.Party.Width, C.UF.Units.Party.Height)
		end
    else
        return
	end
	
	-- Health bar display for group frames
	self.Health = CreateFrame('StatusBar', '$parentHealthBar', self)
	self.Health:SetStatusBarTexture(C.Media.StatusBar, 'ARTWORK')
	
	self.Health:SetParent(self)
	self.Health:SetPoint('TOPRIGHT')
	self.Health:SetPoint('BOTTOMLEFT', 0, -1)
	
	self:SetBackdrop(backdrop)
	self:SetBackdropColor(0, 0, 0, .5)
	
	self.Health.PostUpdate = UpdateGroupHealth
	
	if (C.UF.Units.Party.Health.ClassColor) then
		self.Health.colorClass = true
	end
	
	self.Health.Smooth = true
    self.Health.frequentUpdates = 0.3
	
	-- Health bar background display for group frames
	self.Health.Background = self.Health:CreateTexture('$parentHealthBackground', 'BORDER')
	self.Health.Background:SetAllPoints(self.Health)
	
	-- Background Color
	self.Health.Background:SetTexture(.08, .08, .08)
	
	-- Health value settings
	self.Health.Value = self.Health:CreateFontString('$parentHealthValue', 'OVERLAY')
	self.Health.Value:SetFont(C.Media.Font, C.UF.Media.FontSize)
    
    -- Improve border drawing
    self.Overlay = CreateFrame('Frame', nil, self)
	self.Overlay:SetAllPoints(self)
	self.Overlay:SetTemplate(true)
	self.Overlay:SetBeautyBorderPadding(3)
	self.Overlay:SetFrameLevel(self.Health:GetFrameLevel() + (self.Power and 3 or 2))
	
	-- Display group names
	self.Name = self.Health:CreateFontString('$parentName', 'OVERLAY')
	self.Name:SetPoint('LEFT', self.Health, 5, 1)
	self.Name:SetFont(C.Media.Font, 13)
	self.Name:SetShadowOffset(1, -1)
    self.Name.frequentUpdates = 0.3
    
    self:Tag(self.Name, '|cffffffff[LanName]|r')
    	
	if (C.UF.Units.Party.Healer) then
		self.Name:SetPoint('CENTER', self.Health)
	end
    
    if C.UF.Show.HealerOverride or isHealer then
        local MHPB = CreateFrame('StatusBar', nil, self.Health)
		MHPB:SetPoint('TOP')
		MHPB:SetPoint('BOTTOM')
		MHPB:SetPoint('LEFT', self.Health:GetStatusBarTexture(), 'RIGHT')
		MHPB:SetStatusBarTexture(C.Media.StatusBar)
		MHPB:SetWidth(C.UF.Units.Party.Width)
		MHPB:SetStatusBarColor(0, 1, 0.5, 0.25)

		local OHPB = CreateFrame('StatusBar', nil, self.Health)
		OHPB:SetPoint('TOP')
		OHPB:SetPoint('BOTTOM')
		OHPB:SetPoint('LEFT', self.Health:GetStatusBarTexture(), 'RIGHT')
		OHPB:SetStatusBarTexture(C.Media.StatusBar)
		OHPB:SetWidth(C.UF.Units.Party.Width)
		OHPB:SetStatusBarColor(0, 1, 0, 0.25)

		self.HealPrediction = {
			myBar = MHPB,
			otherBar = OHPB,
			maxOverflow = 1.05,
			frequentUpdates = true,
		}
	end
	
	if unit == 'party' or unit == 'target' then
		self.Status = self.Overlay:CreateFontString(nil, 'OVERLAY')
        self.Status:SetFont(C.Media.Font, C.UF.Media.FontSize)
		self.Status:SetPoint('RIGHT', self.Health, 'BOTTOMRIGHT', -2, 0)
		self.Status:SetDrawLayer('OVERLAY', 7)

		self:Tag(self.Status, '[LanMaster][LanLeader]')
	end
	
	-- Raid Icons
	self.RaidIcon = self.Overlay:CreateTexture('$parentRaidIcon', 'ARTWORK')
	self.RaidIcon:SetHeight(18)
	self.RaidIcon:SetWidth(18)
	self.RaidIcon:SetPoint('CENTER', self.Overlay, 'TOP')
	self.RaidIcon:SetDrawLayer('OVERLAY', 7)
	
    -- LFD Role
    self.LFDRole = self.Overlay:CreateTexture(nil, 'OVERLAY')
    self.LFDRole:SetPoint('CENTER', self, 'RIGHT', 2, 0)
    self.LFDRole:SetSize(16, 16)
	self.LFDRole:SetDrawLayer('OVERLAY', 7)
    
    -- Buffs
	if C.UF.Units.Party.ShowBuffs then
		local GAP = 4
		
		if not NUM_DEBUFFS then NUM_DEBUFFS = 1 end
		
		self.Debuffs = CreateFrame('Frame', nil, self)
        self.Debuffs:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 0, 24)
		self.Debuffs:SetWidth((self:GetHeight() * NUM_DEBUFFS - 1) + (GAP * (NUM_DEBUFFS - 1)))
		self.Debuffs:SetHeight((self:GetHeight() * 2) + (GAP * 2))

		self.Debuffs['growth-x'] = 'RIGHT'
		self.Debuffs['growth-y'] = 'UP'
		self.Debuffs['initialAnchor'] = 'BOTTOMLEFT'
		self.Debuffs['num'] = debuffs
		self.Debuffs['showType'] = false
		self.Debuffs['size'] = self:GetHeight()
		self.Debuffs['spacing-x'] = GAP
		self.Debuffs['spacing-y'] = GAP * 2

		self.Debuffs.CustomFilter   = F.CustomAuraFilters.party
		self.Debuffs.PostCreateIcon = PostCreateAuraIcon
		self.Debuffs.PostUpdateIcon = PostUpdateAuraIcon

		self.Debuffs.parent = self

		self.Buffs = CreateFrame('Frame', nil, self)
		self.Buffs:SetPoint('BOTTOMRIGHT', self, 'TOPRIGHT', 0, 10)
		self.Buffs:SetHeight(self:GetHeight())
		self.Buffs:SetWidth((self:GetHeight() * 4) + (GAP * 3))

		self.Buffs['growth-x'] = 'LEFT'
		self.Buffs['growth-y'] = 'DOWN'
		self.Buffs['initialAnchor'] = 'TOPRIGHT'
		self.Buffs['num'] = 4
		self.Buffs['size'] = self:GetHeight()
		self.Buffs['spacing-x'] = GAP
		self.Buffs['spacing-y'] = GAP

		self.Buffs.CustomFilter   = F.CustomAuraFilters.party
		self.Buffs.PostCreateIcon = PostCreateAuraIcon
		self.Buffs.PostUpdateIcon = PostUpdateAuraIcon

		self.Buffs.parent = self
	end
    
	-- Range-finding support
	self.Range = {
		insideAlpha = 1,
		outsideAlpha = .3,
	}
	
	self.SpellRange = true
    
    -- Hardcore border action!
	--self.Overlay:SetFrameLevel(self.Health:GetFrameLevel() + (self.Power and 3 or 2))
    self.Overlay:SetTemplate()
	self.Overlay:SetBeautyBorderPadding(4)
    
    self.UpdateBorder = UpdateBorder

    -- Dispel highlight support
    self.DispelHighlight = {
		Override = UpdateDispelHighlight,
		filter = true,
	}
    
    -- Threat highlight support
    self.threatLevel = 0
	self.ThreatHighlight = {
		Override = UpdateThreatHighlight,
	}
    
	--self:CreateBD()
    return self
end

oUF:RegisterStyle('oUF_Lanerra_Group', StylishGroup)

-- Now the raid style
local function StylishRaid(self, unit)
	self.menu = CreateDropDown
	local HealW = 75
	local HealH = 30
    
    self:SetScript('OnEnter', UnitFrame_OnEnter)
    self:SetScript('OnLeave', UnitFrame_OnLeave)
    
	self.ignoreHealComm = true
	
--    print('Spawn', self:GetName(), unit)
	tinsert(objects, self)
    
	self:EnableMouse(true)
	self:RegisterForClicks('AnyUp')
	
	if C.UF.Show.Raid and not InCombatLockdown() then
		if C.UF.Units.Raid.Healer then
			self:SetSize(HealW, HealH)
		else
			self:SetSize(C.UF.Units.Raid.Width, C.UF.Units.Raid.Height)
		end
    else
        return
	end
	
	-- Health bar display for group frames
	self.Health = CreateFrame('StatusBar', '$parentHealthBar', self)
	self.Health:SetStatusBarTexture(C.Media.StatusBar, 'ARTWORK')
	
	self.Health:SetParent(self)
	self.Health:SetPoint('TOPRIGHT')
	self.Health:SetPoint('BOTTOMLEFT', 0, -1)
	
	self:SetBackdrop(backdrop)
	self:SetBackdropColor(unpack(C.Media.BackdropColor))
	
	self.Health.PostUpdate = UpdateRaidHealth
	
	if (C.UF.Units.Raid.Health.ClassColor) then
		self.Health.colorClass = true
	end
	
	self.Health.Smooth = true
    self.Health.frequentUpdates = 0.3
	
	-- Health bar background display for group frames
	self.Health.Background = self.Health:CreateTexture('$parentHealthBackground', 'BORDER')
	self.Health.Background:SetAllPoints(self.Health)
	
	-- Background Color
	self.Health.Background:SetTexture(.08, .08, .08)
	
	-- Health value settings
	self.Health.Value = self.Health:CreateFontString('$parentHealthValue', 'OVERLAY')
	self.Health.Value:SetFont(C.Media.Font, C.UF.Media.FontSize)
    
    -- Improve border drawing
    self.Overlay = CreateFrame('Frame', nil, self)
	self.Overlay:SetPoint('TOPLEFT')
	self.Overlay:SetPoint('BOTTOMRIGHT', -1, -0.5)
	self.Overlay:SetTemplate(true)
	self.Overlay:SetBeautyBorderPadding(3)
	self.Overlay:SetFrameLevel(self.Health:GetFrameLevel() + (self.Power and 3 or 2))
		
	-- Display group names
    if (C.UF.Units.Raid.Healer) then
		self.Name = self.Health:CreateFontString('$parentName', 'OVERLAY')
		self.Name:SetPoint('CENTER')
		self.Name:SetFont(C.Media.Font, 13)
		self.Name:SetShadowOffset(1, -1)
		self.Name:SetJustifyH('CENTER')
		self:Tag(self.Name, '|cffffffff[LanRaidName]|r')
	else
		self.Name = self.Health:CreateFontString('$parentName', 'OVERLAY')
		self.Name:SetPoint('CENTER')
		self.Name:SetFont(C.Media.Font, 13)
		self.Name:SetShadowOffset(1, -1)
		self:Tag(self.Name, '|cffffffff[LanName]|r')
		self.Health:SetOrientation('HORIZONTAL')
	end
    
    self.Name.frequentUpdates = 0.3
    
    if C.UF.Show.HealerOverride or isHealer then
        local MHPB = CreateFrame('StatusBar', nil, self.Health)
		MHPB:SetPoint('TOP')
		MHPB:SetPoint('BOTTOM')
		MHPB:SetPoint('LEFT', self.Health:GetStatusBarTexture(), 'RIGHT')
		MHPB:SetStatusBarTexture(C.Media.StatusBar)
		MHPB:SetWidth(HealW)
		MHPB:SetStatusBarColor(0, 1, 0.5, 0.25)

		local OHPB = CreateFrame('StatusBar', nil, self.Health)
		OHPB:SetPoint('TOP')
		OHPB:SetPoint('BOTTOM')
		OHPB:SetPoint('LEFT', self.Health:GetStatusBarTexture(), 'RIGHT')
		OHPB:SetStatusBarTexture(C.Media.StatusBar)
		OHPB:SetWidth(HealW)
		OHPB:SetStatusBarColor(0, 1, 0, 0.25)

		self.HealPrediction = {
			myBar = MHPB,
			otherBar = OHPB,
			maxOverflow = 1.05,
			frequentUpdates = true,
		}
	end
	
	-- Status Icons Display
    self.Status = self.Overlay:CreateFontString(nil, 'OVERLAY')
    self.Status:SetFont(C.Media.Font, C.UF.Media.FontSize)
    self.Status:SetPoint('RIGHT', self.Health, 'BOTTOMRIGHT', -2, 0)
	self.Status:SetDrawLayer('OVERLAY', 7)

    self:Tag(self.Status, '[LanMaster][LanLeader]')
	
	-- Raid Icons
	self.RaidIcon = self.Overlay:CreateTexture('$parentRaidIcon', 'ARTWORK')
	self.RaidIcon:SetHeight(18)
	self.RaidIcon:SetWidth(18)
	self.RaidIcon:SetPoint('RIGHT', self.Name, 'LEFT', -2, 0)
	self.RaidIcon:SetDrawLayer('OVERLAY', 7)
	
    -- Range-finding support
	self.Range = {
		insideAlpha = 1,
		outsideAlpha = .3,
	}
	
	self.SpellRange = true
	
    -- Hardcore border action!
    self.Overlay:SetTemplate()
	--self.Overlay:SetBackdropColor(0, 0, 0, 0)
	self.Overlay:SetBeautyBorderPadding(4)
    
    self.UpdateBorder = UpdateBorder

    -- Dispel highlight support
    self.DispelHighlight = {
		Override = UpdateDispelHighlight,
		filter = true,
	}
    
    -- Threat highlight support
    self.threatLevel = 0
	self.ThreatHighlight = {
		Override = UpdateThreatHighlight,
	}
    
	--self:CreateBD()
    return self
end

oUF:RegisterStyle('oUF_Lanerra_Raid', StylishRaid)

-- Now, actually bring it all together by actually spawning the frames

-- First spawn the solo stuff
oUF:RegisterStyle('oUF_Lanerra', Stylish)
oUF:Factory(function(self)
	self:SetActiveStyle('oUF_Lanerra')
	self:Spawn('player', 'oUF_Lanerra_Player'):SetPoint(unpack(C.UF.Units.Player.Position))
	self:Spawn('target', 'oUF_Lanerra_Target'):SetPoint(unpack(C.UF.Units.Target.Position))
	self:Spawn('targettarget', 'oUF_Lanerra_ToT'):SetPoint(unpack(C.UF.Units.ToT.Position))
	self:Spawn('pet', 'oUF_Lanerra_Pet'):SetPoint(unpack(C.UF.Units.Pet.Position))
	self:Spawn('focus', 'oUF_Lanerra_Focus'):SetPoint(unpack(C.UF.Units.Focus.Position))
end)

-- Next spawn the group stuff
oUF:Factory(function(self)
	self:SetActiveStyle('oUF_Lanerra_Group')
	
	if (C.UF.Units.Party.Healer) then
		local group = oUF:SpawnHeader(
			'oUF_Lanerra_Group',
			nil,
			'party',
			'showParty', true,
			'columnSpacing', 10,
			'unitsPerColumn', 1,
			'maxColumns', 5,
			'columnAnchorPoint', 'LEFT'
		)
		group:SetPoint('CENTER', UIParent, 0, -240)
	else
		local group = oUF:SpawnHeader(
			'oUF_Lanerra_Group',
			nil,
			'party',
			'showParty', true,
			'showPlayer', true,
			'yOffset', -10
		)
		group:SetPoint(unpack(C.UF.Units.Party.Position))
	end
end)

-- And finally, the raid stuff
oUF:Factory(function(self)
	local raid
	self:SetActiveStyle('oUF_Lanerra_Raid')

	CompactUnitFrameProfiles:UnregisterAllEvents()	
	CompactRaidFrameManager:SetParent(LanUIHider)
	CompactRaidFrameManager:UnregisterAllEvents()
	CompactRaidFrameContainer:SetParent(LanUIHider)
	CompactRaidFrameContainer:UnregisterAllEvents()
	
    if (C.UF.Units.Raid.Healer) then
        raid = oUF:SpawnHeader(
			'oUF_Lanerra_Raid',
			nil,
			'raid',
			'showPlayer', true,
			'showRaid', true,
			--'showSolo', true,
			'xOffset', 10,
			'yOffset', -5,
			'point', 'LEFT',
			'groupFilter', '1,2,3,4,5',
			'groupingOrder', '1,2,3,4,5',
			'groupBy', 'GROUP',
			'maxColumns', 10,
			'unitsPerColumn', 5,
			'columnSpacing', 10,
			'columnAnchorPoint', 'TOP',
			'oUF-initialConfigFunction', [[
				self:SetAttribute('initial-width', 75)
				self:SetAttribute('initial-height', 30)
				self:SetWidth(75)
				self:SetHeight(30)
			]]
		)
        raid:SetPoint('CENTER', UIParent, 0, -300)

        if (C.UF.Units.Raid.Healer) then
            local RaidShift, raid = false
            do
                local UpdateRaid = CreateFrame('Frame')
                UpdateRaid:RegisterEvent('RAID_ROSTER_UPDATE')
                UpdateRaid:SetScript('OnEvent', function(self)
                    if RaidShift == false then return end
                    if(InCombatLockdown()) then
                        self:RegisterEvent('PLAYER_REGEN_ENABLED')
                    else
                        self:UnregisterEvent('PLAYER_REGEN_ENABLED')
                        if (GetNumGroupMembers() < 26 and GetNumGroupMembers() > 10) then
                            raid:SetPoint('CENTER', UIParent, -105, -300)
                        elseif (GetNumGroupMembers() < 11) then
                            raid:SetPoint('CENTER', UIParent, -21, -240)
                        end
                    end
                end)
            end
        end
    else
        raid = oUF:SpawnHeader(
			'oUF_Lanerra_Raid',
			nil,
			'raid',
			'showRaid', true,
			'showPlayer', true,
			'yOffset', -10
		)
		raid:SetPoint(unpack(C.UF.Units.Raid.Position))
    end
end)

local HandleFrame = function(baseName)
	local frame
	if(type(baseName) == 'string') then
		frame = _G[baseName]
	else
		frame = baseName
	end

	if(frame) then
		frame:UnregisterAllEvents()
		frame:Hide()

		-- Keep frame hidden without causing taint
		frame:SetParent(LanUIHider)

		local health = frame.healthbar
		if(health) then
			health:UnregisterAllEvents()
		end

		local power = frame.manabar
		if(power) then
			power:UnregisterAllEvents()
		end

		local spell = frame.spellbar
		if(spell) then
			spell:UnregisterAllEvents()
		end

		local altpowerbar = frame.powerBarAlt
		if(altpowerbar) then
			altpowerbar:UnregisterAllEvents()
		end
	end
end

function oUF:DisableBlizzard(unit)
	if(not unit) then return end

	if(unit == 'player') then
		HandleFrame(PlayerFrame)

		-- For the damn vehicle support:
		PlayerFrame:RegisterEvent('PLAYER_ENTERING_WORLD')
		PlayerFrame:RegisterEvent('UNIT_ENTERING_VEHICLE')
		PlayerFrame:RegisterEvent('UNIT_ENTERED_VEHICLE')
		PlayerFrame:RegisterEvent('UNIT_EXITING_VEHICLE')
		PlayerFrame:RegisterEvent('UNIT_EXITED_VEHICLE')

		-- User placed frames don't animate
		PlayerFrame:SetUserPlaced(true)
		PlayerFrame:SetDontSavePosition(true)
	elseif(unit == 'pet') then
		HandleFrame(PetFrame)
	elseif(unit == 'target') then
		HandleFrame(TargetFrame)
		HandleFrame(ComboFrame)
	elseif(unit == 'focus') then
		HandleFrame(FocusFrame)
		HandleFrame(TargetofFocusFrame)
	elseif(unit == 'targettarget') then
		HandleFrame(TargetFrameToT)
	elseif(unit:match'(boss)%d?$' == 'boss') then
		local id = unit:match'boss(%d)'
		if(id) then
			HandleFrame('Boss' .. id .. 'TargetFrame')
		else
			for i=1, 4 do
				HandleFrame(('Boss%dTargetFrame'):format(i))
			end
		end
	elseif(unit:match'(party)%d?$' == 'party') then
		local id = unit:match'party(%d)'
		if(id) then
			HandleFrame('PartyMemberFrame' .. id)
		else
			for i=1, 4 do
				HandleFrame(('PartyMemberFrame%d'):format(i))
			end
		end
	elseif(unit:match'(arena)%d?$' == 'arena') then
		local id = unit:match'arena(%d)'
		if(id) then
			HandleFrame('ArenaEnemyFrame' .. id)
		else
			for i=1, 4 do
				HandleFrame(('ArenaEnemyFrame%d'):format(i))
			end
		end

		-- Blizzard_ArenaUI should not be loaded
		Arena_LoadUI = function() end
		SetCVar('showArenaEnemyFrames', '0', 'SHOW_ARENA_ENEMY_FRAMES_TEXT')
	end
end

-- Role Checker

local CURRENT_ROLE = "DAMAGER"
local getRole, updateEvents

function GetPlayerRole()
	return CURRENT_ROLE
end

if F.MyClass == "DEATHKNIGHT" then
	updateEvents = "UPDATE_SHAPESHIFT_FORM"
	function getRole()
		if GetSpecialization() == 1 then -- Blood 1, Frost 2, Unholy 3
			return "TANK"
		end
	end
elseif F.MyClass == "DRUID" then
	updateEvents = "UPDATE_SHAPESHIFT_FORM"
	function getRole()
		local form = GetShapeshiftFormID() -- Aquatic 4, Bear 5, Cat 1, Flight 29, Moonkin 31, Swift Flight 27, Travel 3, Tree 2
		if form == 5 then
			return "TANK"
		elseif GetSpecialization() == 4 then -- Balance 1, Feral 2, Guardian 3, Restoration 4
			return "HEALER"
		end
	end
elseif F.MyClass == "MONK" then
	updateEvents = "UPDATE_SHAPESHIFT_FORM"
	function getRole()
		local form = GetShapeshiftFormID() -- Tiger 24, Ox 23, Serpent 20
		if form == 23 then
			return "TANK"
		elseif form == 20 then
			return "HEALER"
		end
	end
elseif F.MyClass == "PALADIN" then
	local RIGHTEOUS_FURY = GetSpellInfo(25780)
	updateEvents = "PLAYER_REGEN_DISABLED"
	function getRole()
		if UnitAura("player", RIGHTEOUS_FURY, "HELPFUL") then
			return "TANK"
		elseif GetSpecialization() == 1 then -- Holy 1, Protection 2, Retribution 3
			return "HEALER"
		end
	end
elseif F.MyClass == "PRIEST" then
	function getRole()
		if GetSpecialization() ~= 3 then -- Discipline 1, Holy 2, Shadow 3
			return "HEALER"
		end
	end
elseif F.MyClass == "SHAMAN" then
	function getRole()
		if GetSpecialization() == 3 then -- Elemental 1, Enhancement 2, Restoration 3
			return "HEALER"
		end
	end
elseif F.MyClass == "WARRIOR" then
	updateEvents = "UPDATE_SHAPESHIFT_FORM"
	function getRole()
		if GetSpecialization() == 3 and GetShapeshiftFormID() == 18 then -- Battle 17, Berserker 19, Defensive 18
			return "TANK"
		end
	end
end

if getRole then
	local eventFrame = CreateFrame("Frame")
	eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	eventFrame:RegisterEvent("PLAYER_TALENT_UPDATE")
	if updateEvents then
		for event in gmatch(updateEvents, "%S+") do
			eventFrame:RegisterEvent(event)
		end
	end
	eventFrame:SetScript("OnEvent", function(_, event, ...)
		local role = getRole() or "DAMAGER"
		if role ~= CURRENT_ROLE then
			CURRENT_ROLE = role
			F.UpdateAuraList()
			for _, frame in pairs(objects) do
				if frame.updateOnRoleChange then
					for _, func in pairs(frame.updateOnRoleChange) do
						func(frame, role)
					end
				end
			end
		end
	end)
end

function hideBossFrames()
	for i = 1, 4 do
		local frame = _G["Boss"..i.."TargetFrame"]
		
		if frame then
			frame:UnregisterAllEvents()
			frame:Hide()
			frame.Show = function () end
		end
	end
end
-- Call the hide function
hideBossFrames()