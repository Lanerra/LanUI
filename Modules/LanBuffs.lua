local F, C, G = unpack(LanUI)

--[[

    nBuff
    Copyright (c) 2008-2010, Anton 'Neav' Ickert
    All rights reserved.

--]]

local classColor = F.RGBToHex(F.PlayerColor.r, F.PlayerColor.g, F.PlayerColor.b)

DAY_ONELETTER_ABBR    = '|cffffffff%d|r'..classColor..'d|r'
HOUR_ONELETTER_ABBR   = '|cffffffff%d|r'..classColor..'h|r'
MINUTE_ONELETTER_ABBR = '|cffffffff%d|r'..classColor..'m|r'
SECOND_ONELETTER_ABBR = '|cffffffff%d|r'

TemporaryEnchantFrame:ClearAllPoints()
TemporaryEnchantFrame:SetPoint('TOPRIGHT', Minimap, 'TOPLEFT', -15, 0)
TemporaryEnchantFrame.SetPoint = F.Dummy

TempEnchant2:ClearAllPoints()
TempEnchant2:SetPoint('TOPRIGHT', TempEnchant1, 'TOPLEFT', -C.Buffs.PadX, 0)

ConsolidatedBuffs:SetHeight(20)
ConsolidatedBuffs:SetWidth(20)

ConsolidatedBuffs:ClearAllPoints()
ConsolidatedBuffs:SetPoint('BOTTOM', TempEnchant1, 'TOP', 0, 5)
ConsolidatedBuffs.SetPoint = F.Dummy

ConsolidatedBuffsIcon:SetAlpha(0)
	
ConsolidatedBuffsCount:ClearAllPoints()
ConsolidatedBuffsCount:SetPoint('CENTER', ConsolidatedBuffsIcon)
ConsolidatedBuffsCount:SetFont(C.Media.Font, 16, 'OUTLINE')
ConsolidatedBuffsCount:SetShadowOffset(0, 0)

ConsolidatedBuffsTooltip:SetScale(1.2)

local BUFF_NEW_INDEX = 1

local function BuffFrame_SetPoint(self)
    local hasMainHandEnchant, _, _, hasOffHandEnchant, _, _, hasThrownEnchant = GetWeaponEnchantInfo()
    if (self and self:IsShown()) then
        self:ClearAllPoints()
        if (UnitHasVehicleUI('player')) then
            self:SetPoint('TOPRIGHT', TempEnchant1)
            return
        else
            if (hasMainHandEnchant and hasOffHandEnchant and hasThrownEnchant) then
                self:SetPoint('TOPRIGHT', TempEnchant3, 'TOPLEFT', -C.Buffs.PadX, 0)
                return
			elseif (hasMainHandEnchant and hasOffHandEnchant) or (hasMainHandEnchant and hasThrownEnchant) or (hasOffHandEnchant and hasThrownEnchant) then
				self:SetPoint('TOPRIGHT', TempEnchant2, 'TOPLEFT', -C.Buffs.PadX, 0)
				return
            elseif (hasMainHandEnchant or hasOffHandEnchant or hasThrownEnchant) then
                self:SetPoint('TOPRIGHT', TempEnchant1, 'TOPLEFT', -C.Buffs.PadX, 0)
                return
            elseif (not hasMainHandEnchant and not hasOffHandEnchant and not hasThrownEnchant) then
                self:SetPoint('TOPRIGHT', TempEnchant1)
                return
            end
        end
    end
end

hooksecurefunc('BuffFrame_UpdatePositions', function()
    if (CONSOLIDATED_BUFF_ROW_HEIGHT ~= 28) then
        CONSOLIDATED_BUFF_ROW_HEIGHT = 2
    end
end)

BuffFrame:SetScript('OnUpdate', function(self, elapsed)
    self.BuffFrameUpdateTime = self.BuffFrameUpdateTime + elapsed
    if (self.BuffFrameUpdateTime > TOOLTIP_UPDATE_TIME) then
        self.BuffFrameUpdateTime = 0
        if (BuffButton1) then
            if (not BuffButton1:GetParent() == ConsolidatedBuffsContainer) then
                BuffFrame_SetPoint(BuffButton1)
            end
        end
    end
end)

hooksecurefunc('BuffFrame_UpdateAllBuffAnchors', function()  
    local BUFF_PREVIOUS, BUFF_ABOVE
	local numBuffs = 0

	for i = 1, BUFF_ACTUAL_DISPLAY do
		local buff = _G['BuffButton'..i]
        local hasMainHandEnchant, _, _, hasOffHandEnchant, _, _, hasThrownEnchant = GetWeaponEnchantInfo()

		if (buff.consolidated) then
			if (buff.parent == BuffFrame) then
				buff:SetParent(ConsolidatedBuffsContainer)
				buff.parent = ConsolidatedBuffsContainer
			end
		else
			numBuffs = numBuffs + 1
            
			-- if (hasMainHandEnchant and hasOffHandEnchant and hasThrownEnchant) then
                -- index = index + 3
			-- elseif (hasMainHandEnchant and hasOffHandEnchant) or (hasMainHandEnchant and hasThrownEnchant) or (hasOffHandEnchant or hasThrownEnchant) then
				-- index = index + 2
            -- elseif (hasMainHandEnchant or hasOffHandEnchant or hasThrownEnchant) then            
                -- index = index + 1
            -- end
            
			if (buff.parent ~= BuffFrame) then
				buff:SetParent(BuffFrame)
                buff.parent = BuffFrame
			end
                
            buff:ClearAllPoints()
            if (numBuffs > 1 and mod(numBuffs, C.Buffs.PerRow) == 1) then
                if (numBuffs == C.Buffs.PerRow + 1) then
                    buff:SetPoint('TOP', TempEnchant1, 'BOTTOM', 0, -C.Buffs.PadY)
                else
                    buff:SetPoint('TOP', BUFF_ABOVE, 'BOTTOM', 0, -C.Buffs.PadY)
                end
                BUFF_ABOVE = buff
            elseif (numBuffs == 1) then
                BuffFrame_SetPoint(buff)
            else
                buff:SetPoint('RIGHT', BUFF_PREVIOUS, 'LEFT', -C.Buffs.PadX, 0)
            end
            
            BUFF_PREVIOUS = buff
            BUFF_NEW_INDEX = numBuffs
        end
	end
end)

hooksecurefunc('DebuffButton_UpdateAnchors', function(self, index)
    local BUFF_NEW_SPACE, BUFF_NEW_ROW, BUFF_NUM_ROWS, BUFF_NUM_BUFFS

    BUFF_NEW_SPACE = 31 + C.Buffs.PadY
    BUFF_NUM_BUFFS = (BUFF_NEW_INDEX > 0 and BUFF_NEW_INDEX) or 1
    BUFF_NUM_ROWS  = ceil(BUFF_NUM_BUFFS/C.Buffs.PerRow)
    
    if (BUFF_NUM_ROWS and BUFF_NUM_ROWS > 1) then
        BUFF_NEW_ROW = -BUFF_NUM_ROWS * BUFF_NEW_SPACE
    else
        BUFF_NEW_ROW = -BUFF_NEW_SPACE
    end
    
    local buff = _G[self..index]
    buff:ClearAllPoints()
    if (index == 1) then
        buff:SetPoint('TOP', TempEnchant1, 'BOTTOM', 0, BUFF_NEW_ROW)
	elseif (index >= 2 and mod(index, C.Buffs.PerRow) == 1) then
		buff:SetPoint('TOP', _G[self..(index-C.Buffs.PerRow)], 'BOTTOM', 0, -C.Buffs.PadY)
	else
		buff:SetPoint('RIGHT', _G[self..(index-1)], 'LEFT', -C.Buffs.PadX, 0)
	end
end)

for i = 1, 3 do
    local button = _G['TempEnchant'..i]
    button:SetScale(C.Buffs.Scale)
    button:SetWidth(C.Buffs.Size)
    button:SetHeight(C.Buffs.Size)

    local icon = _G['TempEnchant'..i..'Icon']
    icon:SetTexCoord(0.03, 0.97, 0.03, 0.97)

    local duration = _G['TempEnchant'..i..'Duration']
    duration:ClearAllPoints()
    duration:SetPoint('BOTTOM', button, 'BOTTOM', 0, -2)
    duration:SetFont(C.Media.Font, C.Buffs.DurationSize,'OUTLINE')
    duration:SetShadowOffset(0, 0)
    duration:SetDrawLayer('OVERLAY')

    local border = _G['TempEnchant'..i..'Border']
    border:ClearAllPoints()
    border:SetPoint('TOPRIGHT', button, 1, 1)
    border:SetPoint('BOTTOMLEFT', button, -1, -1)    
    border:SetTexture(C.Media.DebuffBorder)
    border:SetTexCoord(0, 1, 0, 1)
    border:SetVertexColor(0.9, 0.25, 0.9)
end

hooksecurefunc('AuraButton_Update', function(self, index)
    local button = _G[self..index]
    if (button) then
        button:SetWidth(C.Buffs.Size)
        button:SetHeight(C.Buffs.Size)
        button:SetScale(C.Buffs.Scale)
    end
        
    local icon = _G[self..index..'Icon']
    if (icon) then
        icon:SetTexCoord(0.03, 0.97, 0.03, 0.97)
    end
        
    local duration = _G[self..index..'Duration']
    if (duration) then
        duration:ClearAllPoints()
        duration:SetPoint('BOTTOM', button, 'BOTTOM', 0, -2)
        duration:SetFont(C.Media.Font, C.Buffs.DurationSize,'OUTLINE')
        duration:SetShadowOffset(0, 0)
        duration:SetDrawLayer('OVERLAY')
    end

    local count = _G[self..index..'Count']
    if (count) then
        count:ClearAllPoints()
        count:SetPoint('TOPRIGHT', button)
        count:SetFont(C.Media.Font, C.Buffs.CountSize, 'OUTLINE')
        count:SetShadowOffset(0, 0)
        count:SetDrawLayer('OVERLAY')
    end
        
    local border = _G[self..index..'Border']
    if (border) then
        border:SetTexture(C.Media.DebuffBorder)
        border:SetPoint('TOPRIGHT', button, 1, 1)
        border:SetPoint('BOTTOMLEFT', button, -1, -1)
        border:SetTexCoord(0, 1, 0, 1)
    end
    
    if (button and not border) then
        if (not button.texture) then
            button:SetTemplate()
        end
    end
end)

--function UnitAura() return 'TestAura', nil, 'Interface\\Icons\\Spell_Nature_RavenForm', 9, nil, 120, 120, 1, 0 end