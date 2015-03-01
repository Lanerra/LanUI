local F, C, G = unpack(select(2, ...))
local bc = C.Media.BorderColor

local function LoadSkin()
	SkinCloseButton(CharacterFrameCloseButton)
	SkinScrollBar(CharacterStatsPaneScrollBar)
	SkinScrollBar(ReputationListScrollFrameScrollBar)
	SkinScrollBar(TokenFrameContainerScrollBar)
	SkinScrollBar(GearManagerDialogPopupScrollFrameScrollBar)
	
	local slots = {
		"HeadSlot",
		"NeckSlot",
		"ShoulderSlot",
		"BackSlot",
		"ChestSlot",
		"ShirtSlot",
		"TabardSlot",
		"WristSlot",
		"HandsSlot",
		"WaistSlot",
		"LegsSlot",
		"FeetSlot",
		"Finger0Slot",
		"Finger1Slot",
		"Trinket0Slot",
		"Trinket1Slot",
		"MainHandSlot",
		"SecondaryHandSlot",
	}
	for _, slot in pairs(slots) do
		local icon = _G["Character"..slot.."IconTexture"]
		local cooldown = _G["Character"..slot.."Cooldown"]
		slot = _G["Character"..slot]
		slot:StripTextures()
		slot:StyleButton(false)
		slot.ignoreTexture:SetTexture([[Interface\PaperDollInfoFrame\UI-GearManager-LeaveItem-Transparent]])
		slot:CreateBD()
		slot.backdrop:SetOutside(icon)
		icon:SetTexCoord(unpack(F.TexCoords))
		icon:SetInside()
	end	
	
	-- a request by diftraku to color item by rarity on character frame.
	local function ColorItemBorder()
		for _, slot in pairs(slots) do
			-- Colour the equipment slots by rarity
			local target = _G["Character"..slot]
			local slotId, _, _ = GetInventorySlotInfo(slot)
			local itemId = GetInventoryItemID("player", slotId)

			if itemId then
				local rarity = GetInventoryItemQuality('player', slotId)
				if rarity and rarity > 1 then
					target.backdrop:SetBackdropBorderColor(GetItemQualityColor(rarity))
				else
					target.backdrop:SetBackdropBorderColor(bc.r, bc.g, bc.b)
				end
			else
				target.backdrop:SetBackdropBorderColor(bc.r, bc.g, bc.b)
			end
		end
	end

	local CheckItemBorderColor = CreateFrame("Frame")
	CheckItemBorderColor:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
	CheckItemBorderColor:SetScript("OnEvent", ColorItemBorder)	
	CharacterFrame:HookScript("OnShow", ColorItemBorder)
	ColorItemBorder()
	
	--Strip Textures
	local charframe = {
		"CharacterFrame",
		"CharacterModelFrame",
		"CharacterFrameInset", 
		"CharacterStatsPane",
		"CharacterFrameInsetRight",
		"PaperDollSidebarTabs",
		"PaperDollEquipmentManagerPane",
	}

	
	CharacterFrameExpandButton:Size(CharacterFrameExpandButton:GetWidth() - 7, CharacterFrameExpandButton:GetHeight() - 7)
	SkinNextPrevButton(CharacterFrameExpandButton)
	
	hooksecurefunc('CharacterFrame_Collapse', function()
		CharacterFrameExpandButton:SetNormalTexture(nil);
		CharacterFrameExpandButton:SetPushedTexture(nil);
		CharacterFrameExpandButton:SetDisabledTexture(nil);
		SquareButton_SetIcon(CharacterFrameExpandButton, 'RIGHT')
	end)
	
	hooksecurefunc('CharacterFrame_Expand', function()
		CharacterFrameExpandButton:SetNormalTexture(nil);
		CharacterFrameExpandButton:SetPushedTexture(nil);
		CharacterFrameExpandButton:SetDisabledTexture(nil);
		SquareButton_SetIcon(CharacterFrameExpandButton, 'LEFT');
	end)

	if (GetCVar("characterFrameCollapsed") ~= "0") then
		SquareButton_SetIcon(CharacterFrameExpandButton, 'RIGHT')
	else
		SquareButton_SetIcon(CharacterFrameExpandButton, 'LEFT');
	end	

	SkinCloseButton(ReputationDetailCloseButton)
	SkinCloseButton(TokenFramePopupCloseButton)

	SkinCheckBox(ReputationDetailAtWarCheckBox)
	SkinCheckBox(ReputationDetailMainScreenCheckBox)
	SkinCheckBox(ReputationDetailInactiveCheckBox)
	SkinCheckBox(ReputationDetailLFGBonusReputationCheckBox)
	SkinCheckBox(TokenFramePopupInactiveCheckBox)
	SkinCheckBox(TokenFramePopupBackpackCheckBox)

	EquipmentFlyoutFrameHighlight:Kill()
	local function SkinItemFlyouts()
		EquipmentFlyoutFrameButtons:StripTextures()

		local i = 1
		local button = _G["EquipmentFlyoutFrameButton"..i]
		
		while button do
			local icon = _G["EquipmentFlyoutFrameButton"..i.."IconTexture"]
			button:StyleButton(false)
			
			icon:SetTexCoord(unpack(F.TexCoords))
			button:GetNormalTexture():SetTexture(nil)

			icon:SetInside()
			button:SetFrameLevel(button:GetFrameLevel() + 2)
			if not button.backdrop then
				button:CreateBD()
				button.backdrop:SetAllPoints()			
			end
			i = i + 1
			button = _G["EquipmentFlyoutFrameButton"..i]
		end	
	end
	
	--Swap item flyout frame (shown when holding alt over a slot)
	EquipmentFlyoutFrame:HookScript("OnShow", SkinItemFlyouts)
	hooksecurefunc("EquipmentFlyout_Show", SkinItemFlyouts)	
	
	--Icon in upper right corner of character frame
	CharacterFramePortrait:Kill()

	local scrollbars = {
		"PaperDollTitlesPaneScrollBar",
		"PaperDollEquipmentManagerPaneScrollBar",
	}
	
	for _, scrollbar in pairs(scrollbars) do
		SkinScrollBar(_G[scrollbar], 5)
	end
	
	for _, object in pairs(charframe) do
		_G[object]:StripTextures()
	end
	
	CharacterFrame:SetTemplate()
	
	--Titles
	PaperDollTitlesPane:HookScript("OnShow", function(self)
		for x, object in pairs(PaperDollTitlesPane.buttons) do
			object.BgTop:SetTexture(nil)
			object.BgBottom:SetTexture(nil)
			object.BgMiddle:SetTexture(nil)

			--object.Check:SetTexture(nil)
			object.text:FontTemplate()
			hooksecurefunc(object.text, "SetFont", function(self, font, fontSize, fontStyle)
				if font ~= C.Media.Font then
					self:FontTemplate()
				end
			end)
		end
	end)
	
	--Equipement Manager
	SkinButton(PaperDollEquipmentManagerPaneEquipSet)
	SkinButton(PaperDollEquipmentManagerPaneSaveSet)
	PaperDollEquipmentManagerPaneEquipSet:Width(PaperDollEquipmentManagerPaneEquipSet:GetWidth() - 8)
	PaperDollEquipmentManagerPaneSaveSet:Width(PaperDollEquipmentManagerPaneSaveSet:GetWidth() - 8)
	PaperDollEquipmentManagerPaneEquipSet:Point("TOPLEFT", PaperDollEquipmentManagerPane, "TOPLEFT", 8, 0)
	PaperDollEquipmentManagerPaneSaveSet:Point("LEFT", PaperDollEquipmentManagerPaneEquipSet, "RIGHT", 4, 0)
	PaperDollEquipmentManagerPaneEquipSet.ButtonBackground:SetTexture(nil)
	PaperDollEquipmentManagerPane:HookScript("OnShow", function(self)
		for x, object in pairs(PaperDollEquipmentManagerPane.buttons) do
			object.BgTop:SetTexture(nil)
			object.BgBottom:SetTexture(nil)
			object.BgMiddle:SetTexture(nil)
			object.icon:Size(36, 36)
			--object.Check:SetTexture(nil)
			object.icon:SetTexCoord(unpack(F.TexCoords))

			--Making all icons the same size and position because otherwise BlizzardUI tries to attach itself to itself when it refreshes
			object.icon:SetPoint("LEFT", object, "LEFT", 4, 0)
			hooksecurefunc(object.icon, "SetPoint", function(self, point, attachTo, anchorPoint, xOffset, yOffset, isForced)
				if isForced ~= true then
					self:SetPoint("LEFT", object, "LEFT", 4, 0, true)
				end
			end)
			
			
			hooksecurefunc(object.icon, "SetSize", function(self, width, height)
				if width == 30 or height == 30 then
					self:Size(36, 36)
				end
			end)
		end
		GearManagerDialogPopup:StripTextures()
		GearManagerDialogPopup:SetTemplate()
		GearManagerDialogPopup:Point("LEFT", PaperDollFrame, "RIGHT", 4, 0)
		GearManagerDialogPopupScrollFrame:StripTextures()
		GearManagerDialogPopupEditBox:StripTextures()
		GearManagerDialogPopupEditBox:CreateBD()
		SkinButton(GearManagerDialogPopupOkay)
		SkinButton(GearManagerDialogPopupCancel)
		
		for i=1, NUM_GEARSET_ICONS_SHOWN do
			local button = _G["GearManagerDialogPopupButton"..i]
			local icon = button.icon
			
			if button then
				button:StripTextures()
				button:StyleButton(true)
				
				icon:SetTexCoord(unpack(F.TexCoords))
				_G["GearManagerDialogPopupButton"..i.."Icon"]:SetTexture(nil)

				icon:SetInside()
				button:SetFrameLevel(button:GetFrameLevel() + 2)
				if not button.backdrop then
					button:CreateBD()
					button.backdrop:SetAllPoints()			
				end
			end
		end
	end)
	
	--Handle Tabs at bottom of character frame
	for i=1, 4 do
		SkinTab(_G["CharacterFrameTab"..i])
	end
	CharacterFrameTab1:Point('TOPLEFT', CharacterFrame, 'BOTTOMLEFT', 11, 0)
		
	--Buttons used to toggle between equipment manager, titles, and character stats
	local function FixSidebarTabCoords()
		for i=1, #PAPERDOLL_SIDEBARS do
			local tab = _G["PaperDollSidebarTab"..i]
			if tab and not tab.backdrop then
				tab.Highlight:SetTexture(1, 1, 1, 0.3)
				tab.Highlight:Point("TOPLEFT", 3, -4)
				tab.Highlight:Point("BOTTOMRIGHT", -1, 0)
				tab.Hider:SetTexture(0.4,0.4,0.4,0.4)
				tab.Hider:Point("TOPLEFT", 3, -4)
				tab.Hider:Point("BOTTOMRIGHT", -1, 0)
				tab.TabBg:Kill()
				
				if i == 1 then
					for i=1, tab:GetNumRegions() do
						local region = select(i, tab:GetRegions())
						region:SetTexCoord(0.16, 0.86, 0.16, 0.86)
						hooksecurefunc(region, "SetTexCoord", function(self, x1, y1, x2, y2)
							if x1 ~= 0.16001 then
								self:SetTexCoord(0.16001, 0.86, 0.16, 0.86)
							end
						end)
					end
				end
				tab:CreateBD()
				tab.backdrop:Point("TOPLEFT", 1, -2)
				tab.backdrop:Point("BOTTOMRIGHT", 1, -2)	
			end
		end
	end
	hooksecurefunc("PaperDollFrame_UpdateSidebarTabs", FixSidebarTabCoords)
	
	--Stat panels, atm it looks like 7 is the max
	for i=1, 7 do
		_G["CharacterStatsPaneCategory"..i]:StripTextures()
	end
	
	--Reputation
	local function UpdateFactionSkins()
		ReputationListScrollFrame:StripTextures()
		ReputationFrame:StripTextures(true)
		for i=1, GetNumFactions() do
			local statusbar = _G["ReputationBar"..i.."ReputationBar"]

			if statusbar then
				statusbar:SetStatusBarTexture(C.Media.StatusBar)
				
				if not statusbar.backdrop then
					statusbar:CreateBD()
					statusbar.backdrop:SetOutside()
				end
				
				_G["ReputationBar"..i.."Background"]:SetTexture(nil)
				--_G["ReputationBar"..i.."LeftLine"]:Kill()
				--_G["ReputationBar"..i.."BottomLine"]:Kill()
				_G["ReputationBar"..i.."ReputationBarHighlight1"]:SetTexture(nil)
				_G["ReputationBar"..i.."ReputationBarHighlight2"]:SetTexture(nil)	
				_G["ReputationBar"..i.."ReputationBarAtWarHighlight1"]:SetTexture(nil)
				_G["ReputationBar"..i.."ReputationBarAtWarHighlight2"]:SetTexture(nil)
				_G["ReputationBar"..i.."ReputationBarLeftTexture"]:SetTexture(nil)
				_G["ReputationBar"..i.."ReputationBarRightTexture"]:SetTexture(nil)
				
			end		
		end
		ReputationDetailFrame:StripTextures()
		ReputationDetailFrame:SetTemplate()
		ReputationDetailFrame:Point("TOPLEFT", ReputationFrame, "TOPRIGHT", 4, -28)			
	end	
	ReputationFrame:HookScript("OnShow", UpdateFactionSkins)
	hooksecurefunc("ExpandFactionHeader", UpdateFactionSkins)
	hooksecurefunc("CollapseFactionHeader", UpdateFactionSkins)
	
	--Currency
	TokenFrame:HookScript("OnShow", function()
		for i=1, GetCurrencyListSize() do
			local button = _G["TokenFrameContainerButton"..i]
			
			if button then
				button.highlight:Kill()
				button.categoryMiddle:Kill()	
				button.categoryLeft:Kill()	
				button.categoryRight:Kill()
				
				if button.icon then
					button.icon:SetTexCoord(unpack(F.TexCoords))
				end
			end
		end
		TokenFramePopup:StripTextures()
		TokenFramePopup:SetTemplate()
		TokenFramePopup:Point("TOPLEFT", TokenFrame, "TOPRIGHT", 4, -28)				
	end)
	
	--Pet
	PetModelFrame:CreateBD()
	PetModelFrameRotateRightButton:SkinRotateButton()
	PetModelFrameRotateLeftButton:SkinRotateButton()
	PetModelFrameRotateRightButton:ClearAllPoints()
	PetModelFrameRotateRightButton:Point("LEFT", PetModelFrameRotateLeftButton, "RIGHT", 4, 0)
	
	local xtex = PetPaperDollPetInfo:GetRegions()
	xtex:SetTexCoord(.12, .63, .15, .55)
	PetPaperDollPetInfo:CreateBD()
	PetPaperDollPetInfo:Size(24, 24)
end

tinsert(F.SkinFuncs['LanUI'], LoadSkin)