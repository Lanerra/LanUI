local F, C, G = unpack(select(2, ...))
local bc = C.Media.BorderColor

local function LoadSkin()
	MerchantFrame:StripTextures(true)
	MerchantFrame:SetTemplate()

	MerchantFrameInset:StripTextures()
	MerchantMoneyBg:StripTextures()
	MerchantMoneyInset:StripTextures()
	MerchantFrameLootFilter:SkinDropDownBox()
	
	MerchantExtraCurrencyBg:StripTextures()
	MerchantExtraCurrencyInset:StripTextures()

	-- skin tabs
	for i= 1, 2 do
		_G['MerchantFrameTab'..i]:SkinTab()
		
		if i ~= 1 then
			_G['MerchantFrameTab'..i]:Point('LEFT', _G['MerchantFrameTab'..i - 1], 'RIGHT', 4, 0)
		end
	end

	-- skin icons / merchant slots
	for i = 1, 12 do
		local b = _G['MerchantItem'..i..'ItemButton']
		local t = _G['MerchantItem'..i..'ItemButtonIconTexture']
		local item_bar = _G['MerchantItem'..i]
		item_bar:StripTextures(true)
		
		b:StripTextures()
		b:StyleButton(false)
		b:SetTemplate(true)
		b:Point('TOPLEFT', item_bar, 'TOPLEFT', 4, -4)
		t:SetTexCoord(.08, .92, .08, .92)
		t:ClearAllPoints()
		t:Point('TOPLEFT', 2, -2)
		t:Point('BOTTOMRIGHT', -2, 2)
		
		_G['MerchantItem'..i..'MoneyFrame']:ClearAllPoints()
		_G['MerchantItem'..i..'MoneyFrame']:Point('BOTTOMLEFT', b, 'BOTTOMRIGHT', 3, 0)
		
	end

	-- Skin buyback item frame + icon
	MerchantBuyBackItem:StripTextures()
	MerchantBuyBackItemItemButton:StripTextures()
	MerchantBuyBackItemItemButton:StyleButton(false)
	MerchantBuyBackItemItemButton:SetTemplate(true)
	MerchantBuyBackItemItemButtonIconTexture:SetTexCoord(.08, .92, .08, .92)
	MerchantBuyBackItemItemButtonIconTexture:ClearAllPoints()
	MerchantBuyBackItemItemButtonIconTexture:Point('TOPLEFT', 2, -2)
	MerchantBuyBackItemItemButtonIconTexture:Point('BOTTOMRIGHT', -2, 2)

	MerchantRepairItemButton:StyleButton()
	MerchantRepairItemButton:SetTemplate(true)
	MerchantRepairItemButton:GetRegions():SetTexCoord(0.04, 0.24, 0.06, 0.5)
	MerchantRepairItemButton:GetRegions():ClearAllPoints()
	MerchantRepairItemButton:GetRegions():Point('TOPLEFT', 2, -2)
	MerchantRepairItemButton:GetRegions():Point('BOTTOMRIGHT', -2, 2)

	MerchantGuildBankRepairButton:StyleButton()
	MerchantGuildBankRepairButton:SetTemplate(true)
	MerchantGuildBankRepairButtonIcon:SetTexCoord(0.61, 0.82, 0.1, 0.52)
	MerchantGuildBankRepairButtonIcon:ClearAllPoints()
	MerchantGuildBankRepairButtonIcon:Point('TOPLEFT', 2, -2)
	MerchantGuildBankRepairButtonIcon:Point('BOTTOMRIGHT', -2, 2)

	MerchantRepairAllButton:StyleButton(false)
	MerchantRepairAllButton:SetTemplate(true)
	MerchantRepairAllIcon:SetTexCoord(0.34, 0.1, 0.34, 0.535, 0.535, 0.1, 0.535, 0.535)
	MerchantRepairAllIcon:ClearAllPoints()
	MerchantRepairAllIcon:Point('TOPLEFT', 2, -2)
	MerchantRepairAllIcon:Point('BOTTOMRIGHT', -2, 2)

	-- Skin misc frames
	MerchantFrame:Width(360)
	MerchantFrameCloseButton:SkinCloseButton(MerchantFrame.backdrop)
	
	for i = 1, MerchantNextPageButton:GetNumRegions() do
		local region = select(i, MerchantNextPageButton:GetRegions())
		if region:GetObjectType() == 'Texture' and region ~= MerchantNextPageButton:GetNormalTexture() and region ~= MerchantNextPageButton:GetPushedTexture() and region ~= MerchantNextPageButton:GetHighlightTexture() then
			region:Kill()
		end
	end
	
	for i = 1, MerchantPrevPageButton:GetNumRegions() do
		local region = select(i, MerchantPrevPageButton:GetRegions())
		if region:GetObjectType() == 'Texture' and region ~= MerchantPrevPageButton:GetNormalTexture() and region ~= MerchantPrevPageButton:GetPushedTexture() and region ~= MerchantPrevPageButton:GetHighlightTexture() then
			region:Kill()
		end
	end
	
	MerchantNextPageButton:SkinNextPrevButton()
	MerchantPrevPageButton:SkinNextPrevButton()
end

tinsert(F.SkinFuncs['LanUI'], LoadSkin)