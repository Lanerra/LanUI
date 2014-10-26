local F, C, G = unpack(select(2, ...))

local gradientColor = {
    1, 0, 0, 
    1, 1, 0, 
    0, 1, 0
}

local slotInfo = {
	[1] = {1, 'Head'},
	[2] = {3, 'Shoulder'},
	[3] = {5, 'Chest'},
	[4] = {6, 'Waist'},
	[5] = {9, 'Wrist'},
	[6] = {10, 'Hands'},
	[7] = {7, 'Legs'},
	[8] = {8, 'Feet'},
	[9] = {16, 'MainHand'},
	[10] = {17, 'SecondaryHand'}
}

local f = CreateFrame('Frame', 'DuraFrame')
f:SetParent(CharacterFrame)
f:SetSize(42, 30)
f:SetFrameStrata('LOW')
f:EnableMouse(false)
f:SetPoint('LEFT', CharacterFrameTab4, 'RIGHT', 4, 0)
f:RegisterEvent('PLAYER_ENTERING_WORLD')
f:RegisterEvent('UPDATE_INVENTORY_DURABILITY')
f:RegisterEvent('MERCHANT_SHOW')
f:SetTemplate()

f.Text = f:CreateFontString(nil, 'OVERLAY')
f.Text:SetFont('Fonts\\ARIALN.ttf', 13)
f.Text:SetPoint('CENTER', f)
f.Text:SetParent(f)
f.Text:SetJustifyH('CENTER')

    -- create the head toggle button
    
f.Head = CreateFrame('Button', nil, CharacterHeadSlot)
f.Head:SetFrameStrata('HIGH')
f.Head:SetToplevel(true)
f.Head:SetSize(22, 22)
f.Head:SetPoint('CENTER', CharacterHeadSlot, 'TOPRIGHT', -2, -2)
f.Head:SetScript('OnClick', function() 
    ShowHelm(not ShowingHelm()) 
end)

f.Head:SetNormalTexture('Interface\\Minimap\\partyraidblips')
f.Head:GetNormalTexture():SetTexCoord(0.5 ,0.375 ,0.5 ,0.25)
f.Head:GetNormalTexture():SetVertexColor(1, 0, 1)

f.Head:SetPushedTexture('Interface\\Minimap\\partyraidblips')
f.Head:GetPushedTexture():SetTexCoord(0.5 ,0.375 ,0.5 ,0.25)
f.Head:GetPushedTexture():SetVertexColor(0, 0.5, 1)

    -- create the cloak toggle button
    
f.Cloak = CreateFrame('Button', nil, CharacterBackSlot)
f.Cloak:SetFrameStrata('HIGH')
f.Cloak:SetToplevel(true)
f.Cloak:SetSize(22, 22)
f.Cloak:SetPoint('CENTER', CharacterBackSlot, 'TOPRIGHT', -2, -2)
f.Cloak:SetScript('OnClick', function() 
    ShowCloak(not ShowingCloak()) 
end)

f.Cloak:SetNormalTexture('Interface\\MINIMAP\\partyraidblips')
f.Cloak:GetNormalTexture():SetTexCoord(0.5 ,0.375 ,0.5 ,0.25)
f.Cloak:GetNormalTexture():SetVertexColor(1, 0, 1)

f.Cloak:SetPushedTexture('Interface\\MINIMAP\\partyraidblips')
f.Cloak:GetPushedTexture():SetTexCoord(0.5 ,0.375 ,0.5 ,0.25)
f.Cloak:GetPushedTexture():SetVertexColor(0, 0.75, 1)

local function ColorGradient(perc, ...)
	if (perc >= 1) then
		local r, g, b = select(select('#', ...) - 2, ...) 
        return r, g, b
	elseif (perc < 0) then
		local r, g, b = ... return r, g, b
	end
	
	local num = select('#', ...) / 3

	local segment, relperc = math.modf(perc*(num-1))
	local r1, g1, b1, r2, g2, b2 = select((segment*3)+1, ...)

	return r1 + (r2-r1)*relperc, g1 + (g2-g1)*relperc, b1 + (b2-b1)*relperc
end

f:SetScript('OnEvent', function(event)
    local total = 0
    local overAll = 0
        
    for i = 1, #slotInfo do
        local id = GetInventorySlotInfo(slotInfo[i][2] .. 'Slot') 
        local curr, max = GetInventoryItemDurability(slotInfo[i][1])
        local itemSlot = _G['Character'..slotInfo[i][2]..'Slot']
        
		if (curr and max and max ~= 0) then
            if (not itemSlot.Text) then
                itemSlot.Text = itemSlot:CreateFontString(nil, 'OVERLAY')
                itemSlot.Text:SetFont(NumberFontNormal:GetFont(), 15, 'THINOUTLINE')
                itemSlot.Text:SetPoint('BOTTOM', itemSlot, 0, 1)
            end

            if (itemSlot.Text) then
                local avg = curr/max
                local r, g, b = ColorGradient(avg, unpack(gradientColor))
        
                itemSlot.Text:SetTextColor(r, g, b)
                itemSlot.Text:SetText(string.format('%d%%', avg * 100))
                
                overAll = overAll + avg
                total = total + 1
            end
		else
            if (itemSlot.Text) then
                itemSlot.Text:SetText('')
            end
		end

        local r, g, b
        if (overAll/total and overAll/total < 1) then
            r, g, b = ColorGradient(overAll/total, unpack(gradientColor))
        elseif (overAll/total <= 0) then
            r, g, b = 1, 0, 0
        else
            r, g, b = 0, 1, 0
        end
        
        f.Text:SetTextColor(r, g, b)
        f.Text:SetText(string.format('%d%%', (overAll/total)*100))
    end
end)