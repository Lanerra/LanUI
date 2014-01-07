local F, C, G = unpack(select(2, ...))
local bc = C.Media.BorderColor

-- Bags & Bank
local function LoadSkin()
	-- BAGS
	for i = 1, 5 do
		local bag = _G['ContainerFrame'..i]
		if bag then
			bag:StripTextures(true)
			bag:CreateBD()

			bag.backdrop:Point('TOPLEFT', 4, -2)
			bag.backdrop:Point('BOTTOMRIGHT', 1, 1)
			_G['ContainerFrame'..i..'CloseButton']:SkinCloseButton(_G['ContainerFrame'..i..'CloseButton'].backdrop)

			--Slots
			for j = 1, 36 do
				local icon = _G['ContainerFrame'..i..'Item'..j..'IconTexture']
				local slots = _G['ContainerFrame'..i..'Item'..j]

				slots:SkinButton()
				icon:SetTexCoord(.08, .92, .08, .92)
				icon:ClearAllPoints()
				icon:SetAllPoints()
				icon:Point('TOPLEFT', slots, 2, -2)
				icon:Point('BOTTOMRIGHT', slots, -2, 2)
			end
		end
		
		BackpackTokenFrame:StripTextures()
	end
	
	BagItemSearchBox:Size(159, 15)
	BagItemSearchBox:ClearAllPoints()
	BagItemSearchBox:Point('TOPLEFT', 19, -29)
	BagItemSearchBox.ClearAllPoints = F.Dummy
	BagItemSearchBox.SetPoint = F.Dummy
	BagItemSearchBox:SkinEditBox()

	-- BANK
	local bank = BankFrame
	if bank then
		bank:StripTextures(true)
		bank:CreateBD()
		BankFrameCloseButton:SkinCloseButton(BankFrameCloseButton.backdrop)
		BankFrameMoneyFrameBorder:StripTextures()
		BankFrameMoneyFrameInset:StripTextures()

		BankFramePurchaseButton:SkinButton()
		BankFramePurchaseButton:Height(22)
		
		BankItemSearchBox:Size(159, 15)
		BankItemSearchBox:ClearAllPoints()
		BankItemSearchBox:Point('BOTTOMRIGHT', -29, 70)
		BankItemSearchBox.ClearAllPoints = F.Dummy
		BankItemSearchBox.SetPoint = F.Dummy
		BankItemSearchBox:SkinEditBox()

		-- Bank Bags
		for i = 1, 7 do
			local bankbags = _G['BankFrameBag'..i]
			local highlight = _G['BankFrameBag'..i..'HighlightFrameTexture'];
			local icon = _G['BankFrameBag'..i..'IconTexture']

			bankbags:SkinButton()
			bankbags:StyleButton()
			highlight:Kill()
			icon:SetTexCoord(.08, .92, .08, .92)
			icon:ClearAllPoints()
			icon:SetAllPoints()
			icon:Point('TOPLEFT', bankbags, 2, -2)
			icon:Point('BOTTOMRIGHT', bankbags, -2, 2)
		end

		-- Bank Slots
		for i = 1, 28 do
			local slots = _G['BankFrameItem'..i]
			local icon = _G['BankFrameItem'..i..'IconTexture']
			slots:SkinButton()
			icon:SetTexCoord(.08, .92, .08, .92)
			icon:ClearAllPoints()
			icon:SetAllPoints()
			icon:Point('TOPLEFT', slots, 2, -2)
			icon:Point('BOTTOMRIGHT', slots, -2, 2)
		end

		-- Bank Bags Frame
		for i = 6, 12 do
			local bag = _G['ContainerFrame'..i]
			if bag then
				bag:StripTextures(true)
				bag:CreateBD()
				bag.backdrop:Point('TOPLEFT', 4, -2)
				bag.backdrop:Point('BOTTOMRIGHT', 1, 1)
				_G['ContainerFrame'..i..'CloseButton']:SkinCloseButton(_G['ContainerFrame'..i..'CloseButton'].backdrop)

				--Slots
				for j = 1, 36 do
					local icon = _G['ContainerFrame'..i..'Item'..j..'IconTexture']
					local slots = _G['ContainerFrame'..i..'Item'..j]

					slots:SkinButton()
					icon:SetTexCoord(.08, .92, .08, .92)
					icon:ClearAllPoints()
					icon:SetAllPoints()
					icon:Point('TOPLEFT', slots, 2, -2)
					icon:Point('BOTTOMRIGHT', slots, -2, 2)
				end
			end
		end
	end
end

tinsert(F.SkinFuncs['LanUI'], LoadSkin)