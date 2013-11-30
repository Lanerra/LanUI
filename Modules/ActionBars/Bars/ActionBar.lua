local F, C, G = unpack(select(2, ...))

local actionButtons = G.ActionBars.ActionButtons
local SkinAB = F.SkinAB

local Parent = CreateFrame('Frame', 'LanActionBar', UIParent, 'SecureHandlerStateTemplate')
Parent:SetPoint('BOTTOM', 0, 50)
Parent:SetSize((C.ActionBars.ButtonSize * 12) + (C.ActionBars.ButtonSpacing * 13), (C.ActionBars.ButtonSize * 1) + (C.ActionBars.ButtonSpacing * 2))

RegisterStateDriver(Parent, 'visibility', '[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists] hide; show')

local visibleButtons = {}
for _, button in pairs(actionButtons) do
	visibleButtons[button] = true
end

local function UpdatePosition()
	local barIndex = 1
	for _, buttonName in pairs(actionButtons) do
		if(visibleButtons[buttonName]) then
			for index = 1, NUM_ACTIONBAR_BUTTONS do
				local Button = _G[buttonName .. index]
				Button:ClearAllPoints()

				if(index == 1) then
					Button:SetPoint('BOTTOMLEFT', Parent, 2, 33 * (barIndex - 1))
				else
					Button:SetPoint('LEFT', _G[buttonName .. index - 1], 'RIGHT', 5, 0)
				end

				if(not Button.Skinned) then
					SkinAB(buttonName .. index)
				end
			end

			Parent:SetHeight(33 * barIndex)
			barIndex = barIndex + 1
		end
	end
end

for _, frame in pairs({
	'MainMenuBarArtFrame',
	'MultiBarBottomLeft',
	'MultiBarBottomRight',
	'MultiBarRight',
	'MultiBarLeft',
}) do
	_G[frame]:SetParent(Parent)
	_G[frame]:EnableMouse(false)
end

hooksecurefunc('SetActionBarToggles', function(bar2, bar3, bar4, bar5)
	visibleButtons.MultiBarBottomLeftButton = bar2 == '1'
	visibleButtons.MultiBarBottomRightButton = bar3 == '0'
	visibleButtons.MultiBarRightButton = bar4 == '0'
	visibleButtons.MultiBarLeftButton = bar5 == '0' and bar4 == '0'

	UpdatePosition()
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

local f = CreateFrame('Frame', nil, LanActionBar)
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