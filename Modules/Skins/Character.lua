local F, C, G = unpack(select(2, ...))
local bc = C.Media.BorderColor

local function LoadSkin()
	CharacterFrameCloseButton:SkinCloseButton()

	local slots = {
		'HeadSlot',
		'NeckSlot',
		'ShoulderSlot',
		'BackSlot',
		'ChestSlot',
		'ShirtSlot',
		'TabardSlot',
		'WristSlot',
		'HandsSlot',
		'WaistSlot',
		'LegsSlot',
		'FeetSlot',
		'Finger0Slot',
		'Finger1Slot',
		'Trinket0Slot',
		'Trinket1Slot',
		'MainHandSlot',
		'SecondaryHandSlot',
	}
	
	for _, slot in pairs(slots) do
		local icon = _G['Character'..slot..'IconTexture']
		local slot = _G['Character'..slot]
		slot:StripTextures()
		slot:StyleButton(false)
		icon:SetTexCoord(.08, .92, .08, .92)
		icon:ClearAllPoints()
		icon:Point('TOPLEFT', 2, -2)
		icon:Point('BOTTOMRIGHT', -2, 2)
		
		slot.ignoreTexture = slot:CreateTexture(nil, 'OVERLAY')
		slot.ignoreTexture:SetTexture('Interface\\PaperDollInfoFrame\\UI-GearManager-LeaveItem-Transparent')
		slot.ignoreTexture:SetSize(40, 40)
		slot.ignoreTexture:SetPoint('CENTER', slot)
		
		slot:SetFrameLevel(slot:GetFrameLevel() + 2)
		slot:CreateBD(true)
		slot.backdrop:SetAllPoints()
	end

	--Strip Textures
	local charframe = {
		'CharacterFrame',
		'CharacterModelFrame',
		'CharacterFrameInset', 
		'CharacterStatsPane',
		'CharacterFrameInsetRight',
		'PaperDollSidebarTabs',
		'PaperDollEquipmentManagerPane',
		'PaperDollFrameItemFlyout',
	}

	CharacterFrameExpandButton:Size(CharacterFrameExpandButton:GetWidth() - 7, CharacterFrameExpandButton:GetHeight() - 7)
	CharacterFrameExpandButton:SkinNextPrevButton()


	EquipmentFlyoutFrameHighlight:Kill()
	local function SkinItemFlyouts()
		EquipmentFlyoutFrameButtons:StripTextures()

		local i = 1
		local button = _G['EquipmentFlyoutFrameButton'..i]

		while button do
			local icon = _G['EquipmentFlyoutFrameButton'..i..'IconTexture']
			button:StyleButton(false)

			icon:SetTexCoord(.1, .9, .1, .9)
			button:GetNormalTexture():SetTexture(nil)

			icon:SetInside()
			button:SetFrameLevel(button:GetFrameLevel() + 2)
			if not button.backdrop then
				button:CreateBD(true)
				button.backdrop:SetAllPoints()
			end
			
			i = i + 1
			button = _G['EquipmentFlyoutFrameButton'..i]
		end
	end

	-- Swap item flyout frame (shown when holding alt over a slot)
	EquipmentFlyoutFrame:HookScript('OnShow', SkinItemFlyouts)
	hooksecurefunc('EquipmentFlyout_Show', SkinItemFlyouts)

	--Icon in upper right corner of character frame
	CharacterFramePortrait:Kill()

	local scrollbars = {
		'PaperDollTitlesPaneScrollBar',
		'PaperDollEquipmentManagerPaneScrollBar',
		'CharacterStatsPaneScrollBar',
		'ReputationListScrollFrameScrollBar',
	}

	for _, scrollbar in pairs(scrollbars) do
		_G[scrollbar]:SkinScrollBar()
	end

	for _, object in pairs(charframe) do
		if _G[object] then
			_G[object]:StripTextures()
		end
	end

	--Titles
	PaperDollTitlesPane:HookScript('OnShow', function(self)
		for x, object in pairs(PaperDollTitlesPane.buttons) do
			object.BgTop:SetTexture(nil)
			object.BgBottom:SetTexture(nil)
			object.BgMiddle:SetTexture(nil)

			object.Check:SetTexture(nil)
			object.text:SetFont(C.Media.Font, 12)
			object.text.SetFont = F.Dummy
		end
	end)

	--Equipement Manager
	PaperDollEquipmentManagerPaneEquipSet:SkinButton()
	PaperDollEquipmentManagerPaneSaveSet:SkinButton()
	GearManagerDialogPopupScrollFrameScrollBar:SkinScrollBar()
	PaperDollEquipmentManagerPaneEquipSet:Width(PaperDollEquipmentManagerPaneEquipSet:GetWidth() - 8)
	PaperDollEquipmentManagerPaneSaveSet:Width(PaperDollEquipmentManagerPaneSaveSet:GetWidth() - 8)
	PaperDollEquipmentManagerPaneEquipSet:Point('TOPLEFT', PaperDollEquipmentManagerPane, 'TOPLEFT', 8, 0)
	PaperDollEquipmentManagerPaneSaveSet:Point('LEFT', PaperDollEquipmentManagerPaneEquipSet, 'RIGHT', 4, 0)
	PaperDollEquipmentManagerPaneEquipSet.ButtonBackground:SetTexture(nil)
	PaperDollEquipmentManagerPane:HookScript('OnShow', function(self)
		for x, object in pairs(PaperDollEquipmentManagerPane.buttons) do
			object.BgTop:SetTexture(nil)
			object.BgBottom:SetTexture(nil)
			object.BgMiddle:SetTexture(nil)

			object.icon:SetTexCoord(.08, .92, .08, .92)
			object:SetTemplate()
		end
		GearManagerDialogPopup:StripTextures()
		GearManagerDialogPopup:SetTemplate()
		GearManagerDialogPopup:Point('LEFT', PaperDollFrame, 'RIGHT', 4, 0)
		GearManagerDialogPopupScrollFrame:StripTextures()
		GearManagerDialogPopupEditBox:StripTextures()
		GearManagerDialogPopupEditBox:SetTemplate(true)
		GearManagerDialogPopupOkay:SkinButton()
		GearManagerDialogPopupCancel:SkinButton()
		
		for i=1, NUM_GEARSET_ICONS_SHOWN do
			local button = _G['GearManagerDialogPopupButton'..i]
			local icon = button.icon
			
			if button then
				button:StripTextures()
				button:StyleButton()
				
				icon:SetTexCoord(.08, .92, .08, .92)
				_G['GearManagerDialogPopupButton'..i..'Icon']:SetTexture(nil)
				
				icon:ClearAllPoints()
				icon:Point('TOPLEFT', 2, -2)
				icon:Point('BOTTOMRIGHT', -2, 2)	
				button:SetFrameLevel(button:GetFrameLevel() + 2)
				if not button.backdrop then
					button:CreateBD(true)
					button.backdrop:SetAllPoints()			
				end
			end
		end
	end)

	--Handle Tabs at bottom of character frame
	for i=1, 4 do
		_G['CharacterFrameTab'..i]:SkinTab()
		
		if i == 1 then
			_G['CharacterFrameTab'..i]:Point('TOPLEFT', CharacterFrame, 'BOTTOMLEFT', 5, 2)
		else
			_G['CharacterFrameTab'..i]:Point('LEFT', _G['CharacterFrameTab'..i - 1], 'RIGHT', 4, 0)
		end
	end

	--Buttons used to toggle between equipment manager, titles, and character stats
	local function FixSidebarTabCoords()
		for i=1, #PAPERDOLL_SIDEBARS do
			local tab = _G['PaperDollSidebarTab'..i]
			if tab then
				tab.Highlight:SetTexture(1, 1, 1, 0.3)
				tab.Highlight:Point('TOPLEFT', 3, -4)
				tab.Highlight:Point('BOTTOMRIGHT', -1, 0)
				tab.Hider:SetTexture(0.4,0.4,0.4,0.4)
				tab.Hider:Point('TOPLEFT', 3, -4)
				tab.Hider:Point('BOTTOMRIGHT', -1, 0)
				tab.TabBg:Kill()
				
				if i == 1 then
					for i=1, tab:GetNumRegions() do
						local region = select(i, tab:GetRegions())
						region:SetTexCoord(0.16, 0.86, 0.16, 0.86)
						region.SetTexCoord = F.Dummy
					end
				end
				tab:CreateBD(true)
				tab.backdrop:Point('TOPLEFT', 1, -2)
				tab.backdrop:Point('BOTTOMRIGHT', 1, -2)	
			end
		end
	end
	hooksecurefunc('PaperDollFrame_UpdateSidebarTabs', FixSidebarTabCoords)

	--Stat panels, atm it looks like 7 is the max
	for i=1, 7 do
		_G['CharacterStatsPaneCategory'..i]:StripTextures()
	end

	--Reputation
	local function UpdateFactionSkins()
		for i=1, GetNumFactions() do
			local statusbar = _G['ReputationBar'..i..'ReputationBar']
			
			if statusbar then
				statusbar:SetStatusBarTexture(C.Media.StatusBar)
				
				if not statusbar.backdrop then
					statusbar:CreateBD(true)
					statusbar.backdrop:Point('TOPLEFT', statusbar, -1, 2)
					statusbar.backdrop:Point('BOTTOMRIGHT', statusbar, 1, -1)
					statusbar.backdrop:SetBeautyBorderPadding(2)
				end
				
				_G['ReputationBar'..i..'Background']:SetTexture(nil)
				_G['ReputationBar'..i..'ReputationBarHighlight1']:SetTexture(nil)
				_G['ReputationBar'..i..'ReputationBarHighlight2']:SetTexture(nil)	
				_G['ReputationBar'..i..'ReputationBarAtWarHighlight1']:SetTexture(nil)
				_G['ReputationBar'..i..'ReputationBarAtWarHighlight2']:SetTexture(nil)
				_G['ReputationBar'..i..'ReputationBarLeftTexture']:SetTexture(nil)
				_G['ReputationBar'..i..'ReputationBarRightTexture']:SetTexture(nil)
				
			end		
		end
		ReputationListScrollFrame:StripTextures()
		ReputationFrame:StripTextures(true)
		ReputationDetailFrame:StripTextures()
		ReputationDetailFrame:SetTemplate()
		ReputationDetailFrame:Point('TOPLEFT', ReputationFrame, 'TOPRIGHT', 4, -28)
	end	
	ReputationFrame:HookScript('OnShow', UpdateFactionSkins)
	hooksecurefunc('ReputationFrame_OnEvent', UpdateFactionSkins)
	ReputationDetailInactiveCheckBox:HookScript('OnClick', UpdateFactionSkins)
	ReputationDetailCloseButton:SkinCloseButton()
	ReputationDetailAtWarCheckBox:SkinCheckBox()
	ReputationDetailAtWarCheckBox:SetCheckedTexture('Interface\\Buttons\\UI-CheckBox-SwordCheck')
	ReputationDetailLFGBonusReputationCheckBox:SkinCheckBox()
	ReputationDetailInactiveCheckBox:SkinCheckBox()
	ReputationDetailMainScreenCheckBox:SkinCheckBox()
	
	local function UpdateReputationExpand()
		-- Skin Expand Buttons
		for i=1, NUM_FACTIONS_DISPLAYED do
			local bar = _G['ReputationBar'..i]
			local button = _G['ReputationBar'..i..'ExpandOrCollapseButton']
			if not bar.isSkinned then
				button:StripTextures()
				button.SetNormalTexture = F.Dummy
				button:SkinCloseButton()
				bar.isSkinned = true
			end
			
			-- set the X or V texture
			if bar.isCollapsed then
				button.t:SetText('V')
			else
				button.t:SetText('X')
			end
			
			UpdateFactionSkins()
		end
	end
	hooksecurefunc('ReputationFrame_Update', UpdateReputationExpand)
	
	--Currency
	TokenFrame:HookScript('OnShow', function()
		for i=1, GetCurrencyListSize() do
			local button = _G['TokenFrameContainerButton'..i]
			
			if button then
				button.highlight:Kill()
				button.categoryMiddle:Kill()	
				button.categoryLeft:Kill()	
				button.categoryRight:Kill()
				
				if button.icon then
					button.icon:SetTexCoord(.08, .92, .08, .92)
				end
			end
		end
		TokenFramePopup:StripTextures()
		TokenFramePopup:SetTemplate()
		TokenFramePopup:Point('TOPLEFT', TokenFrame, 'TOPRIGHT', 4, -28)				
	end)
	TokenFrameContainerScrollBar:SkinScrollBar()
	TokenFramePopupCloseButton:SkinCloseButton()
	TokenFramePopupInactiveCheckBox:SkinCheckBox()
	TokenFramePopupBackpackCheckBox:SkinCheckBox()

	--Pet
	PetModelFrame:CreateBD(true)

	PetModelFrameRotateRightButton:SkinRotateButton()
	PetModelFrameRotateLeftButton:SkinRotateButton()
	PetModelFrameRotateRightButton:ClearAllPoints()
	PetModelFrameRotateRightButton:Point('LEFT', PetModelFrameRotateLeftButton, 'RIGHT', 4, 0)

	local xtex = PetPaperDollPetInfo:GetRegions()
	xtex:SetTexCoord(.12, .63, .15, .55)
	PetPaperDollPetInfo:CreateBD(true)
	PetPaperDollPetInfo:Size(24, 24)
	
	-- a request to color item by rarity on character frame.
	local function ColorItemBorder()
		for _, slot in pairs(slots) do
			-- Colour the equipment slots by rarity
			local target = _G['Character'..slot]
			local slotId, _, _ = GetInventorySlotInfo(slot)
			local itemId = GetInventoryItemID('player', slotId)
			
			if itemId then
				local _, _, rarity, _, _, _, _, _, _, _, _ = GetItemInfo(itemId)
				if rarity then				
					target:SetBeautyBorderColor(GetItemQualityColor(rarity))
				end
			else
				target:SetBeautyBorderColor(bc.r, bc.g, bc.b)
			end
		end
	end
	
	-- execute item coloring everytime we open character frame
	CharacterFrame:HookScript('OnShow', ColorItemBorder)
	
	-- execute item coloring everytime an item is changed
	local CheckItemBorderColor = CreateFrame('Frame')
	CheckItemBorderColor:RegisterEvent('PLAYER_EQUIPMENT_CHANGED')
	CheckItemBorderColor:SetScript('OnEvent', ColorItemBorder)
	
	CharacterFrame:SetTemplate()
end

tinsert(F.SkinFuncs['LanUI'], LoadSkin)