local F, C, G = unpack(select(2, ...))

local _G = _G
local media = C.Media
local securehandler = CreateFrame("Frame", nil, nil, "SecureHandlerBaseTemplate")
local replace = string.gsub

function F.StyleActionBarButton(self)
	local name = self:GetName()
	local action = self.action
	local Button = self
	local Icon = _G[name.."Icon"]
	local Count = _G[name.."Count"]
	local Flash	 = _G[name.."Flash"]
	local HotKey = _G[name.."HotKey"]
	local Border  = _G[name.."Border"]
	local Btname = _G[name.."Name"]
	local normal  = _G[name.."NormalTexture"]
	local BtnBG = _G[name..'FloatingBG']
 
	Flash:SetTexture("")
	Button:SetNormalTexture("")
 
	Count:ClearAllPoints()
	Count:Point("BOTTOMRIGHT", 0, 2)
	
	HotKey:ClearAllPoints()
	HotKey:Point("TOPRIGHT", 0, -3)
	
	if Border and Border:IsShown() then
		Border:Hide()
		Border = F.Dummy
	end
	
	if Btname and normal and C.ActionBars.Macro then
		local query = GetActionText(action)
		if query then
			local text = string.sub(query,1,5)
			Btname:SetText(text)
		end
	end
	
	if Button.isSkinned then
		return
	end
	
	Count:SetFont(C.Media.Font, 12)
	
	if Btname then
		if C.ActionBars.Macro then
			Btname:SetFont(C.Media.Font, 10)
			Btname:ClearAllPoints()
			Btname:SetPoint("BOTTOM", 1, 1)
		else
			Btname:SetText("")
			Btname:Kill()
		end
	end
	
	if BtnBG then
		BtnBG:Kill()
	end
 
	if not C.ActionBars.Hotkey == true then
		HotKey:SetText("")
		HotKey:Kill()
	else
		HotKey:SetFont(C.Media.Font, 10)
		HotKey.ClearAllPoints = F.Dummy
		HotKey.SetPoint = F.Dummy
	end
	
	if name:match("Extra") then
		Button:SetTemplate()
		Button.pushed = true
		Icon:SetDrawLayer('ARTWORK')
	else
		Button:CreateBackdrop()
		Button.backdrop:SetOutside(Button, 0, 0)	
		Button:UnregisterEvent("ACTIONBAR_SHOWGRID")
		Button:UnregisterEvent("ACTIONBAR_HIDEGRID")			
	end
	
	Icon:SetTexCoord(.08, .92, .08, .92)
	Icon:SetInside()
	
	-- bug, some buttons are checked in a /rl or login, even if they shouldn`t be, double check
	if normal and Button:GetChecked() then
		ActionButton_UpdateState(Button)
	end
	
	if normal then
		normal:ClearAllPoints()
		normal:SetPoint("TOPLEFT")
		normal:SetPoint("BOTTOMRIGHT")
	end
	
	Button:StyleButton()
	Button.isSkinned = true
end

function F.StyleActionBarPetAndShiftButton(normal, button, icon, name, pet)
	if button.isSkinned then
		return
	end
	
	button:SetWidth(C.ActionBars.ButtonSize)
	button:SetHeight(C.ActionBars.ButtonSize)
	button:CreateBackdrop()
	button.backdrop:SetOutside(button, 0, 0)
	icon:SetTexCoord(.08, .92, .08, .92)
	icon:ClearAllPoints()
	icon:SetInside()
	if pet then			
		if C.ActionBars.ButtonSize < 30 then
			local autocast = _G[name.."AutoCastable"]
			autocast:SetAlpha(0)
		end
		local shine = _G[name.."Shine"]
		shine:Size(C.ActionBars.ButtonSize, C.ActionBars.ButtonSize)
		shine:ClearAllPoints()
		shine:SetPoint("CENTER", button, 0, 0)
		icon:Point("TOPLEFT", button, 2, -2)
		icon:Point("BOTTOMRIGHT", button, -2, 2)
	end
	
	button:SetNormalTexture("")
	button.SetNormalTexture = F.Dummy
	
	local Flash	 = _G[name.."Flash"]
	Flash:SetTexture("")
	
	if normal then
		normal:ClearAllPoints()
		normal:SetPoint("TOPLEFT")
		normal:SetPoint("BOTTOMRIGHT")
	end
	
	button:StyleButton()
	button.isSkinned = true
end

function F.StyleShift()
	for i=1, NUM_STANCE_SLOTS do
		local name = "StanceButton"..i
		local button  = _G[name]
		local icon  = _G[name.."Icon"]
		local normal  = _G[name.."NormalTexture"]
		F.StyleActionBarPetAndShiftButton(normal, button, icon, name)
	end
end

function F.StylePet()
	for i=1, NUM_PET_ACTION_SLOTS do
		local name = "PetActionButton"..i
		local button  = _G[name]
		local icon  = _G[name.."Icon"]
		local normal  = _G[name.."NormalTexture2"]
		F.StyleActionBarPetAndShiftButton(normal, button, icon, name, true)
	end
end

function F.UpdateActionBarHotKey(self, actionButtonType)
	local hotkey = _G[self:GetName() .. 'HotKey']
	local text = hotkey:GetText()
	
	text = replace(text, '(s%-)', 'S')
	text = replace(text, '(a%-)', 'A')
	text = replace(text, '(c%-)', 'C')
	text = replace(text, '(Mouse Button )', 'M')
	text = replace(text, '(Middle Mouse)', 'M3')
	text = replace(text, '(Mouse Wheel Up)', 'MU')
	text = replace(text, '(Mouse Wheel Down)', 'MD')
	text = replace(text, '(Num Pad )', 'N')
	text = replace(text, '(Page Up)', 'PU')
	text = replace(text, '(Page Down)', 'PD')
	text = replace(text, '(Spacebar)', 'SpB')
	text = replace(text, '(Insert)', 'Ins')
	text = replace(text, '(Home)', 'Hm')
	text = replace(text, '(Delete)', 'Del')
	
	if hotkey:GetText() == _G['RANGE_INDICATOR'] then
		hotkey:SetText('')
	else
		hotkey:SetText(text)
	end
end

local buttons = 0
local function SetupFlyoutButton()
	for i=1, buttons do
		if _G["SpellFlyoutButton"..i] then
			F.StyleActionBarButton(_G["SpellFlyoutButton"..i])
					
			if _G["SpellFlyoutButton"..i]:GetChecked() then
				_G["SpellFlyoutButton"..i]:SetChecked(nil)
			end
		end
	end
end
SpellFlyout:HookScript("OnShow", SetupFlyoutButton)

function F.StyleActionBarFlyout(self)
	if not self.FlyoutArrow then return end
	
	self.FlyoutBorder:SetAlpha(0)
	self.FlyoutBorderShadow:SetAlpha(0)
	
	SpellFlyoutHorizontalBackground:SetAlpha(0)
	SpellFlyoutVerticalBackground:SetAlpha(0)
	SpellFlyoutBackgroundEnd:SetAlpha(0)
	
	for i=1, GetNumFlyouts() do
		local x = GetFlyoutID(i)
		local _, _, numSlots, isKnown = GetFlyoutInfo(x)
		if isKnown then
			buttons = numSlots
			break
		end
	end
	
	--Change arrow direction depending on what bar the button is on
	local arrowDistance
	if ((SpellFlyout and SpellFlyout:IsShown() and SpellFlyout:GetParent() == self) or GetMouseFocus() == self) then
		arrowDistance = 5
	else
		arrowDistance = 2
	end
	
	if self:GetParent():GetParent():GetName() == "SpellBookSpellIconsFrame" then return end
	
	if self:GetAttribute("flyoutDirection") ~= nil then
		local point, _, _, _, _ = self:GetParent():GetParent():GetPoint()
		
		if strfind(point, "BOTTOM") then
			self.FlyoutArrow:ClearAllPoints()
			self.FlyoutArrow:SetPoint("TOP", self, "TOP", 0, arrowDistance)
			SetClampedTextureRotation(self.FlyoutArrow, 0)
			if not InCombatLockdown() then self:SetAttribute("flyoutDirection", "UP") end
		else
			self.FlyoutArrow:ClearAllPoints()
			self.FlyoutArrow:SetPoint("LEFT", self, "LEFT", -arrowDistance, 0)
			SetClampedTextureRotation(self.FlyoutArrow, 270)
			if not InCombatLockdown() then self:SetAttribute("flyoutDirection", "LEFT") end
		end
	end
end

local ProcBackdrop = {
	edgeFile = C.Media.Backdrop, edgeSize = F.Mult,
	insets = {left = F.Mult, right = F.Mult, top = F.Mult, bottom = F.Mult},
}

F.ShowHighlightActionButton = function(self)
	if self.overlay then
		self.overlay:Hide()
		ActionButton_HideOverlayGlow(self)
	end

	if not self.Animation then
		local NewProc = CreateFrame("Frame", nil, self)
		NewProc:SetBackdrop(ProcBackdrop)
		NewProc:SetBackdropBorderColor(1, 1, 0)
		NewProc:SetAllPoints(self)

		self.NewProc = NewProc

		local Animation = self.NewProc:CreateAnimationGroup()
		Animation:SetLooping("BOUNCE")

		local FadeOut = Animation:CreateAnimation("Alpha")
		FadeOut:SetChange(-1)
		FadeOut:SetDuration(0.40)
		FadeOut:SetSmoothing("IN_OUT")

		self.Animation = Animation
	end

	if not self.Animation:IsPlaying() then self.Animation:Play() self.NewProc:Show() end
end

F.HideHighlightActionButton = function(self)
	if self.Animation and self.Animation:IsPlaying() then self.Animation:Stop() self.NewProc:Hide() end
end

hooksecurefunc("ActionButton_ShowOverlayGlow", F.ShowHighlightActionButton)
hooksecurefunc("ActionButton_HideOverlayGlow", F.HideHighlightActionButton)
hooksecurefunc("ActionButton_Update", F.StyleActionBarButton)
hooksecurefunc("ActionButton_UpdateHotkeys", F.UpdateActionBarHotKey)
hooksecurefunc("ActionButton_UpdateFlyout", F.StyleActionBarFlyout)

-- Hide/disable all Blizzard stuff that we don't need

local hide = LanUIHider
local frames = {
	MainMenuBar, MainMenuBarArtFrame, OverrideActionBar,
	PossessBarFrame, PetActionBarFrame, IconIntroTracker,
	ShapeshiftBarLeft, ShapeshiftBarMiddle, ShapeshiftBarRight,
}

for i, f in pairs(frames) do
	f:UnregisterAllEvents()
	f.ignoreFramePositionManager = true
	f:SetParent(hide)
end

IconIntroTracker:UnregisterAllEvents()
IconIntroTracker:SetParent(hide)

MainMenuBar.slideOut.IsPlaying = function() return true end

SetCVar("alwaysShowActionBars", 1)

OverrideActionBar:UnregisterAllEvents()
for i = 1, 6 do
	local b = _G["OverrideActionBarButton"..i]
	b:UnregisterAllEvents()
	b:SetAttribute("statehidden", true)
end

-- Fix broken hotkeys on talent switch
hooksecurefunc('TalentFrame_LoadUI', function()
	PlayerTalentFrame:UnregisterEvent('ACTIVE_TALENT_GROUP_CHANGED')
end)

-- Unregister unneeded events on action buttons when entering world
hooksecurefunc("ActionButton_OnEvent", function(self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		self:UnregisterEvent("ACTIONBAR_SHOWGRID")
		self:UnregisterEvent("ACTIONBAR_HIDEGRID")
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	end
end)