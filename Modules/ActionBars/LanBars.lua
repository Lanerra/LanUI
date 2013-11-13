local F, C, G = unpack(select(2, ...))

if not C.ActionBars.Enabled == true then
    return
end

    -- Create our bars
local LanBar1 = CreateFrame("Frame", "LanBar1", UIParent, "SecureHandlerStateTemplate")

if C.ActionBars.Bar2 == false then
	LanBar1:SetTemplate()
end

LanBar1:SetWidth((C.ActionBars.ButtonSize * 12) + (C.ActionBars.ButtonSpacing * 13))
LanBar1:SetHeight((C.ActionBars.ButtonSize * 1) + (C.ActionBars.ButtonSpacing * 2))
LanBar1:SetPoint("BOTTOM", UIParent, 0, 64)
LanBar1:SetFrameStrata("BACKGROUND")
LanBar1:SetFrameLevel(1)
G.ActionBars.Bar1 = LanBar1

if C.ActionBars.Bar2 == true then
	local LanBar2 = CreateFrame("Frame", "LanBar2", UIParent, "SecureHandlerStateTemplate")
	LanBar2:SetWidth((C.ActionBars.ButtonSize * 12) + (C.ActionBars.ButtonSpacing * 13))
	LanBar2:SetHeight((C.ActionBars.ButtonSize * 1) + (C.ActionBars.ButtonSpacing * 2))
	LanBar2:SetPoint("TOP", LanBar1, "BOTTOM", 0, C.ActionBars.ButtonSpacing)
	LanBar2:SetFrameStrata("BACKGROUND")
	LanBar2:SetFrameLevel(2)
	LanBar2:SetAlpha(0)
	G.ActionBars.bar2 = LanBar2
	
	local bar2 = LanBar2
	bar2:SetAlpha(1)
	MultiBarBottomLeft:SetParent(bar2)

	for i=1, 12 do
		local b = _G["MultiBarBottomLeftButton"..i]
		local b2 = _G["MultiBarBottomLeftButton"..i-1]
		b:SetSize(C.ActionBars.ButtonSize, C.ActionBars.ButtonSize)
		b:ClearAllPoints()
		b:SetFrameStrata("BACKGROUND")
		b:SetFrameLevel(15)
		
		if i == 1 then
			b:SetPoint("TOPLEFT", bar2, C.ActionBars.ButtonSpacing, -C.ActionBars.ButtonSpacing)
		else
			b:SetPoint("LEFT", b2, "RIGHT", C.ActionBars.ButtonSpacing, 0)
		end
		
		b:SetTemplate()
		
		G.ActionBars.bar2["Button"..i] = b
	end

	RegisterStateDriver(bar2, "visibility", "[vehicleui][petbattle][overridebar] hide; show")
end

if C.ActionBars.Bar3 == true then
	local LanBar3 = CreateFrame("Frame", "LanBar3", UIParent, "SecureHandlerStateTemplate")
	LanBar3:SetTemplate()
	LanBar3:Point("BOTTOMLEFT", LanBar1, "BOTTOMRIGHT", 6, 0)
	LanBar3:SetWidth((C.ActionBars.ButtonSize * 6) + (C.ActionBars.ButtonSpacing * 7))
	LanBar3:SetHeight((C.ActionBars.ButtonSize * 2) + (C.ActionBars.ButtonSpacing * 3))
	LanBar3:SetFrameStrata("BACKGROUND")
	LanBar3:SetFrameLevel(3)
	G.ActionBars.Bar3 = LanBar3
	
	local bar3 = LanBar3
	MultiBarBottomRight:SetParent(bar3)

	for i= 1, 12 do
		local b = _G["MultiBarBottomRightButton"..i]
		local b2 = _G["MultiBarBottomRightButton"..i-1]
		b:SetSize(C.ActionBars.ButtonSize, C.ActionBars.ButtonSize)
		b:ClearAllPoints()
		b:SetFrameStrata("BACKGROUND")
		b:SetFrameLevel(15)
		
		if i == 1 then
			b:SetPoint("BOTTOMLEFT", bar3, C.ActionBars.ButtonSpacing, C.ActionBars.ButtonSpacing)
		elseif i == 7 then
			b:SetPoint("TOPLEFT", bar3, C.ActionBars.ButtonSpacing, -C.ActionBars.ButtonSpacing)
		else
			b:SetPoint("LEFT", b2, "RIGHT", C.ActionBars.ButtonSpacing, 0)
		end
		
		G.ActionBars.Bar3["Button"..i] = b
	end

	for i=7, 12 do
		local b = _G["MultiBarBottomRightButton"..i]
		local b2 = _G["MultiBarBottomRightButton1"]
		b:SetFrameLevel(b2:GetFrameLevel() - 2)
	end

	RegisterStateDriver(bar3, "visibility", "[vehicleui][petbattle][overridebar] hide; show")
end

if C.ActionBars.Bar4 == true then
	local LanBar4 = CreateFrame("Frame", "LanBar4", UIParent, "SecureHandlerStateTemplate")
	LanBar4:SetTemplate()
	LanBar4:Point("BOTTOM", UIParent, "BOTTOM", 0, 42)
	LanBar4:SetWidth((C.ActionBars.ButtonSize * 12) + (C.ActionBars.ButtonSpacing * 13))
	LanBar4:SetHeight((C.ActionBars.ButtonSize * 2) + (C.ActionBars.ButtonSpacing * 3))
	LanBar4:SetFrameStrata("BACKGROUND")
	LanBar4:SetFrameLevel(3)
	G.ActionBars.Bar4 = LanBar4
	
	local bar4 = LanBar4
	bar4:SetAlpha(1)
	MultiBarLeft:SetParent(bar4)

	for i= 1, 12 do
		local b = _G["MultiBarLeftButton"..i]
		local b2 = _G["MultiBarLeftButton"..i-1]
		b:SetSize(C.ActionBars.ButtonSize, C.ActionBars.ButtonSize)
		b:ClearAllPoints()
		b:SetFrameStrata("BACKGROUND")
		b:SetFrameLevel(15)
		
		if i == 1 then
			b:SetPoint("TOPLEFT", bar4, C.ActionBars.ButtonSpacing, -C.ActionBars.ButtonSpacing)
		else
			b:SetPoint("LEFT", b2, "RIGHT", C.ActionBars.ButtonSpacing, 0)
		end
		
		G.ActionBars.Bar4["Button"..i] = b
	end

	RegisterStateDriver(bar4, "visibility", "[vehicleui][petbattle][overridebar] hide; show")
end

if C.ActionBars.Bar5 == true then
	local LanBar5 = CreateFrame("Frame", "LanBar5", UIParent, "SecureHandlerStateTemplate")
	LanBar5:SetTemplate()
	LanBar5:SetPoint("RIGHT", UIParent, "RIGHT", -23, -14)
	LanBar5:SetHeight((C.ActionBars.ButtonSize * 12) + (C.ActionBars.ButtonSpacing * 13))
	LanBar5:SetWidth((C.ActionBars.ButtonSize * 1) + (C.ActionBars.ButtonSpacing * 2))
	LanBar5:SetFrameStrata("BACKGROUND")
	LanBar5:SetFrameLevel(2)
	LanBar5:SetAlpha(0)
	G.ActionBars.Bar5 = LanBar5
	
	local bar5 = LanBar5
	bar5:SetAlpha(1)
	MultiBarRight:SetParent(bar5)

	for i= 1, 12 do
		local b = _G["MultiBarRightButton"..i]
		local b2 = _G["MultiBarRightButton"..i-1]
		b:SetSize(C.ActionBars.ButtonSize, C.ActionBars.ButtonSize)
		b:ClearAllPoints()
		b:SetFrameStrata("BACKGROUND")
		b:SetFrameLevel(15)
		
		if i == 1 then
			b:SetPoint("TOPRIGHT", bar5, -C.ActionBars.ButtonSpacing, -C.ActionBars.ButtonSpacing)
		else
			b:SetPoint("TOP", b2, "BOTTOM", 0, -C.ActionBars.ButtonSpacing)
		end
		
		G.ActionBars.Bar5["Button"..i] = b
	end

	RegisterStateDriver(bar5, "visibility", "[vehicleui][petbattle][overridebar] hide; show")

	LanBar5:SetWidth((C.ActionBars.ButtonSize * 3) + (C.ActionBars.ButtonSpacing * 4))
end

if C.ActionBars.Bar6 == true then
	local LanBar6 = CreateFrame("Frame", "LanBar6", UIParent, "SecureHandlerStateTemplate")
	LanBar6:SetTemplate()
	LanBar6:Point("BOTTOMRIGHT", LanBar1, "BOTTOMLEFT", -6, 0)
	LanBar6:SetWidth((C.ActionBars.ButtonSize * 6) + (C.ActionBars.ButtonSpacing * 7))
	LanBar6:SetHeight((C.ActionBars.ButtonSize * 2) + (C.ActionBars.ButtonSpacing * 3))
	LanBar6:SetFrameStrata("BACKGROUND")
	LanBar6:SetFrameLevel(3)
	LanBar6:SetAlpha(0)
	G.ActionBars.bar6 = LanBar6
	
	local bar6 = LanBar6
	MultiBarBottomLeft:SetParent(bar6)

	for i=1, 12 do
		local b = _G["MultiBarBottomLeftButton"..i]
		local b2 = _G["MultiBarBottomLeftButton"..i-1]
		b:SetSize(C.ActionBars.ButtonSize, C.ActionBars.ButtonSize)
		b:ClearAllPoints()
		b:SetFrameStrata("BACKGROUND")
		b:SetFrameLevel(15)
		
		if i == 1 then
			b:SetPoint("BOTTOMLEFT", bar6, C.ActionBars.ButtonSpacing, C.ActionBars.ButtonSpacing)
		elseif i == 7 then
			b:SetPoint("TOPLEFT", bar6, C.ActionBars.ButtonSpacing, -C.ActionBars.ButtonSpacing)
		else
			b:SetPoint("LEFT", b2, "RIGHT", C.ActionBars.ButtonSpacing, 0)
		end
		
		G.ActionBars.bar6["Button"..i] = b
	end

	for i=7, 12 do
		local b = _G["MultiBarBottomLeftButton"..i]
		local b2 = _G["MultiBarBottomLeftButton1"]
		b:SetFrameLevel(b2:GetFrameLevel() - 2)
	end

	RegisterStateDriver(bar6, "visibility", "[vehicleui][petbattle][overridebar] hide; show")
end

if C.ActionBars.Bar7 == true then
	local LanBar7 = CreateFrame("Frame", "LanBar7", UIParent, "SecureHandlerStateTemplate")
	LanBar7:SetWidth((C.ActionBars.ButtonSize * 1) + (C.ActionBars.ButtonSpacing * 2))
	LanBar7:SetHeight((C.ActionBars.ButtonSize * 12) + (C.ActionBars.ButtonSpacing * 13))
	LanBar7:SetPoint("TOP", LanBar5, "TOP", 0 , 0)
	LanBar7:SetFrameStrata("BACKGROUND")
	LanBar7:SetFrameLevel(2)
	LanBar7:SetAlpha(0)
	G.ActionBars.Bar7 = LanBar7
	
	local bar7 = LanBar7
	bar7:SetAlpha(1)
	MultiBarBottomRight:SetParent(bar7)

	for i= 1, 12 do
		local b = _G["MultiBarBottomRightButton"..i]
		local b2 = _G["MultiBarBottomRightButton"..i-1]
		b:SetSize(C.ActionBars.ButtonSize, C.ActionBars.ButtonSize)
		b:ClearAllPoints()
		b:SetFrameStrata("BACKGROUND")
		b:SetFrameLevel(15)
		
		if i == 1 then
			b:SetPoint("TOP", bar7, 0, -C.ActionBars.ButtonSpacing)
		else
			b:SetPoint("TOP", b2, "BOTTOM", 0, -C.ActionBars.ButtonSpacing)
		end
		
		G.ActionBars.Bar7["Button"..i] = b
	end

	RegisterStateDriver(bar7, "visibility", "[vehicleui][petbattle][overridebar] hide; show")
end

local petbg = CreateFrame("Frame", "LanPetBar", UIParent, "SecureHandlerStateTemplate")
petbg:SetTemplate()
petbg:SetSize((C.ActionBars.ButtonSize * 10) + (C.ActionBars.ButtonSpacing * 11), C.ActionBars.ButtonSize + (C.ActionBars.ButtonSpacing * 2))
petbg:SetPoint('BOTTOM', MainMenuExpBar, 'TOP', 0, C.ActionBars.ButtonSpacing)
G.ActionBars.Pet = petbg

local stance = CreateFrame("Frame", "LanStance", UIParent, "SecureHandlerStateTemplate")
stance:SetPoint("TOPLEFT", 4, -46)
stance:SetWidth((C.ActionBars.ButtonSize * 5) + (C.ActionBars.ButtonSize * 4))
stance:SetHeight(10)
stance:SetFrameStrata("MEDIUM")
stance:SetMovable(true)
stance:SetClampedToScreen(true)
G.ActionBars.Stance = stance

-- Warrior custom paging
local Warrior = ""
if C.ActionBars.OwnStance then
    Warrior = "[stance:1] 7; [stance:2] 8; [stance:3] 9;"
end

-- Rogue custom paging
local Rogue = ""
if C.ActionBars.OwnShadow then
    Rogue = "[stance:3] 10; "
end

-- Warlock custom paging
local Warlock = ""
if C.ActionBars.OwnMeta then
    Warlock = "[stance:1] 10; "
end

local Page = {
	["DRUID"] = "[bonusbar:1,nostealth] 7; [bonusbar:1,stealth] 8; [bonusbar:2] 8; [bonusbar:3] 9; [bonusbar:4] 10;",
	["WARRIOR"] = Warrior,
	["PRIEST"] = "[bonusbar:1] 7;",
	["ROGUE"] = Rogue.."[bonusbar:1] 7;",
	["WARLOCK"] = Warlock,
	["MONK"] = "[bonusbar:1] 7; [bonusbar:2] 8; [bonusbar:3] 9;",
	["DEFAULT"] = "[vehicleui:12] 12; [possessbar] 12; [overridebar] 14; [bar:2] 2; [bar:3] 3; [bar:4] 4; [bar:5] 5; [bar:6] 6;",
}

local function GetBar()
	local condition = Page["DEFAULT"]
	local class = F.MyClass
	local page = Page[class]
	local more = ""
	
	if page then
		condition = condition.." "..page
	end
	
	condition = condition.." [form] 1; 1"

	return condition
end

local bar = LanBar1

bar:RegisterEvent("PLAYER_LOGIN")
bar:RegisterEvent("PLAYER_ENTERING_WORLD")
bar:RegisterEvent("KNOWN_CURRENCY_TYPES_UPDATE")
bar:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
bar:RegisterEvent("BAG_UPDATE")
bar:RegisterEvent("UPDATE_VEHICLE_ACTIONBAR")
bar:RegisterEvent("UPDATE_OVERRIDE_ACTIONBAR")
bar:SetScript("OnEvent", function(self, event, unit, ...)
	if event == "PLAYER_LOGIN" or event == "ACTIVE_TALENT_GROUP_CHANGED" then
		local button
		for i = 1, NUM_ACTIONBAR_BUTTONS do
			button = _G["ActionButton"..i]
			self:SetFrameRef("ActionButton"..i, button)
			G.ActionBars.Bar1["Button"..i] = button
		end	

		self:Execute([[
			buttons = table.new()
			for i = 1, 12 do
				table.insert(buttons, self:GetFrameRef("ActionButton"..i))
			end
		]])

		self:SetAttribute("_onstate-page", [[ 
			if HasTempShapeshiftActionBar() then
				newstate = GetTempShapeshiftBarIndex() or newstate
			end
			
			for i, button in ipairs(buttons) do
				button:SetAttribute("actionpage", tonumber(newstate))
			end
		]])
		
		RegisterStateDriver(self, "page", GetBar())	
	elseif event == "PLAYER_ENTERING_WORLD" then
		local button
		for i = 1, 12 do
			button = _G["ActionButton"..i]
			button:SetSize(C.ActionBars.ButtonSize, C.ActionBars.ButtonSize)
			button:ClearAllPoints()
			button:SetParent(bar)
			button:SetFrameStrata("BACKGROUND")
			button:SetFrameLevel(15)
			if i == 1 then
				button:SetPoint("BOTTOMLEFT", C.ActionBars.ButtonSpacing, C.ActionBars.ButtonSpacing)
			else
				local previous = _G["ActionButton"..i-1]
				button:SetPoint("LEFT", previous, "RIGHT", C.ActionBars.ButtonSpacing, 0)
			end
		end
	elseif event == "UPDATE_VEHICLE_ACTIONBAR" or event == "UPDATE_OVERRIDE_ACTIONBAR" then
		if HasVehicleActionBar() or HasOverrideActionBar() then
			if not self.inVehicle then
				LanBar2Button:Hide()
				LanBar3Button:Hide()
				LanBar4Button:Hide()
				LanBar5ButtonTop:Hide()
				LanBar5ButtonBottom:Hide()
				
				self.inVehicle = true
			end
		else
			if self.inVehicle then
				LanBar2Button:Show()
				LanBar3Button:Show()
				LanBar4Button:Show()
				LanBar5ButtonTop:Show()
				LanBar5ButtonBottom:Show()
				
				self.inVehicle = false
			end
		end
	else
		MainMenuBar_OnEvent(self, event, ...)
	end
end)

    -- Pet bar

local petbar = LanPetBar
	
petbar:RegisterEvent("PLAYER_LOGIN")
petbar:RegisterEvent("PLAYER_CONTROL_LOST")
petbar:RegisterEvent("PLAYER_CONTROL_GAINED")
petbar:RegisterEvent("PLAYER_ENTERING_WORLD")
petbar:RegisterEvent("PLAYER_FARSIGHT_FOCUS_CHANGED")
petbar:RegisterEvent("PET_BAR_UPDATE")
petbar:RegisterEvent("PET_BAR_UPDATE_USABLE")
petbar:RegisterEvent("PET_BAR_UPDATE_COOLDOWN")
petbar:RegisterEvent("PET_BAR_HIDE")
petbar:RegisterEvent("UNIT_PET")
petbar:RegisterEvent("UNIT_FLAGS")
petbar:RegisterEvent("UNIT_AURA")
petbar:SetScript("OnEvent", function(self, event, arg1)
	if event == "PLAYER_LOGIN" then	
		PetActionBarFrame:UnregisterEvent("PET_BAR_SHOWGRID")
		PetActionBarFrame:UnregisterEvent("PET_BAR_HIDEGRID")
		PetActionBarFrame.showgrid = 1
		
		local button		
		for i = 1, 10 do
			button = _G["PetActionButton"..i]
			button:ClearAllPoints()
			button:SetParent(LanPetBar)

			button:SetSize(C.ActionBars.ButtonSize, C.ActionBars.ButtonSize)
			if i == 1 then
				button:SetPoint("LEFT", C.ActionBars.ButtonSpacing, 0)
			else
				button:SetPoint("LEFT", _G["PetActionButton"..(i - 1)], "RIGHT", C.ActionBars.ButtonSpacing, 0)
			end
			button:Show()
			self:SetAttribute("addchild", button)
			
			G.ActionBars.Pet["Button"..i] = button
		end
		RegisterStateDriver(self, "visibility", "[pet,nopetbattle,novehicleui,nooverridebar] show; hide")
		
		hooksecurefunc("PetActionBar_Update", F.PetBarUpdate)
	elseif event == "PET_BAR_UPDATE" or event == "UNIT_PET" and arg1 == "player" 
	or event == "PLAYER_CONTROL_LOST" or event == "PLAYER_CONTROL_GAINED" or event == "PLAYER_FARSIGHT_FOCUS_CHANGED" or event == "UNIT_FLAGS"
	or arg1 == "pet" and (event == "UNIT_AURA") then
		F.PetBarUpdate()
	elseif event == "PET_BAR_UPDATE_COOLDOWN" then
		PetActionBar_UpdateCooldowns()
	else
		F.StylePet()
	end
end)

    -- Stance Bar
if C.ActionBars.HideShapeshift then
    LanStance:Hide()
    return
end

local States = {
	["DRUID"] = "show",
	["WARRIOR"] = "show",
	["PALADIN"] = "show",
	["DEATHKNIGHT"] = "show",
	["ROGUE"] = "show,",
	["PRIEST"] = "show,",
	["HUNTER"] = "show,",
	["WARLOCK"] = "show,",
	["MONK"] = "show,",
}

stance:RegisterEvent("PLAYER_LOGIN")
stance:RegisterEvent("PLAYER_ENTERING_WORLD")
stance:RegisterEvent("UPDATE_SHAPESHIFT_FORMS")
stance:RegisterEvent("UPDATE_SHAPESHIFT_USABLE")
stance:RegisterEvent("UPDATE_SHAPESHIFT_COOLDOWN")
stance:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
stance:RegisterEvent("ACTIONBAR_PAGE_CHANGED")
stance:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" then
		StanceBarFrame.ignoreFramePositionManager = true
		StanceBarFrame:StripTextures()
		StanceBarFrame:SetParent(stance)
		StanceBarFrame:ClearAllPoints()
		StanceBarFrame:SetPoint("BOTTOMLEFT", stance, "TOPLEFT", -11, 4)
		StanceBarFrame:EnableMouse(false)
		
		for i = 1, NUM_STANCE_SLOTS do
			local button = _G["StanceButton"..i]
			button:SetFrameStrata("LOW")
			if i ~= 1 then
				button:ClearAllPoints()				
				local previous = _G["StanceButton"..i-1]
				button:Point("LEFT", previous, "RIGHT", C.ActionBars.ButtonSpacing, 0)
			end
			local _, name = GetShapeshiftFormInfo(i)
			if name then
				button:Show()
			else
				button:Hide()
			end
			
			G.ActionBars.Stance["Button"..i] = button
		end
		RegisterStateDriver(bar, "visibility", "[vehicleui][petbattle] hide; show")
		
		if F.MyClass == 'HUNTER' then
			stance:Hide()
		end
	elseif event == "UPDATE_SHAPESHIFT_FORMS" then
		-- Update Shapeshift Bar Button Visibility
		-- I seriously don't know if it's the best way to do it on spec changes or when we learn a new stance.
		if InCombatLockdown() then return end -- > just to be safe ;p
		for i = 1, NUM_STANCE_SLOTS do
			local button = _G["StanceButton"..i]
			local _, name = GetShapeshiftFormInfo(i)
			if name then
				button:Show()
			else
				button:Hide()
			end
		end
	elseif event == "PLAYER_ENTERING_WORLD" then
		F.ShiftBarUpdate(self)
		F.StyleShift(self)
	else
		F.ShiftBarUpdate(self)
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

local f = CreateFrame('Frame', LanBar1)
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

for i = 1, 15 do
    local f = _G['ReputationBar'..i]
    local f2 = _G['ReputationBar'..i..'ReputationBar']
    
    F.RemoveRegions(f, {1})
    F.RemoveRegions(f2, {3, 4})
	
    f2:SetTemplate()
    f2:SetHeight(18)
end

MainMenuExpBar:SetParent(UIParent)

for i = 1, 19 do
   local XP = _G['MainMenuXPBarDiv'..i]
   XP:Hide()
   XP:SetAlpha(0)
--   XP.Hide = XP.Show
   XP.Show = XP.Hide
   XP.SetAlpha = F.Dummy
end

-- Bars
MainMenuExpBar:SetPoint('TOP', ActionButton6, 16, 20)
ExhaustionTick:SetFrameLevel('3')
MainMenuExpBar:SetWidth(380)
MainMenuExpBar:SetHeight(14)
MainMenuExpBar.SetWidth = F.Dummy
MainMenuExpBar.SetPoint = F.Dummy

MainMenuXPBarTextureLeftCap:Kill()
MainMenuXPBarTextureRightCap:Kill()
MainMenuXPBarTextureMid:Kill()

MainMenuExpBar:SetTemplate()