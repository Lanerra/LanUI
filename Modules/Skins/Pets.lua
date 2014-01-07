local F, C, G = unpack(select(2, ...))
local bc = C.Media.BorderColor

local function LoadSkin()
	-- global
	PetJournalParent:StripTextures()
	PetJournalParent:SetTemplate()
	PetJournalParentPortrait:Hide()
	PetJournalParentTab1:SkinTab()
	PetJournalParentTab2:SkinTab()
	PetJournalParentTab2:Point('LEFT', PetJournalParentTab1, 'RIGHT', 4, 0)
	PetJournalParentCloseButton:SkinCloseButton()

	-------------------------------
	--[[ mount journal (tab 1) ]]--
	-------------------------------

	MountJournal:StripTextures()
	MountJournal.LeftInset:StripTextures()
	MountJournal.RightInset:StripTextures()
	MountJournal.MountDisplay:StripTextures()
	MountJournal.MountDisplay.ShadowOverlay:StripTextures()
	MountJournal.MountCount:StripTextures()
	MountJournalMountButton:SkinButton(true)
	MountJournalListScrollFrameScrollBar:SkinScrollBar()
	MountJournal.MountDisplay.ModelFrame.RotateLeftButton:SkinCloseButton()
	MountJournal.MountDisplay.ModelFrame.RotateRightButton:SkinCloseButton()
	MountJournal.MountDisplay.ModelFrame.RotateLeftButton.t:SetText('<')
	MountJournal.MountDisplay.ModelFrame.RotateRightButton.t:SetText('>')
	MountJournalSearchBox:SkinEditBox()
	
	for i = 1, #MountJournal.ListScrollFrame.buttons do
		local b = _G['MountJournalListScrollFrameButton'..i]
		if not b.isSkinned then
			-- reskin mounts icons
			b:StripTextures()
			b:StyleButton()
			b:SetBackdropBorderColor(0,0,0,0)
			b:HideInsets()
			b.icon:SetTexCoord(.08, .92, .08, .92)
			b.DragButton:StyleButton()
			b.DragButton.hover:SetAllPoints(b.DragButton)
			b.DragButton.ActiveTexture:SetAlpha(0)
			
			-- create a backdrop around the icon
			b:CreateBD()
			b.backdrop:SetTemplate(true)
			b.backdrop:Point('TOPLEFT', b.icon, -2, 2)
			b.backdrop:Point('BOTTOMRIGHT', b.icon, 2, -2)
			b.backdrop:SetBackdropColor(0, 0, 0, 0)
			
			b.isSkinned = true
		end
	end

	-- Color in green icon border on selected mount
	local function ColorSelectedMount()
		for i = 1, #MountJournal.ListScrollFrame.buttons do
			local b = _G['MountJournalListScrollFrameButton'..i]
			local t = _G['MountJournalListScrollFrameButton'..i..'Name']
			if b.DragButton.ActiveTexture:IsShown() then
				t:SetTextColor(1,1,0)
				b.backdrop:SetBeautyBorderColor(1, 1, 0)
			else
				t:SetTextColor(1, 1, 1)
				b.backdrop:SetBeautyBorderColor(bc.r, bc.g, bc.b)
			end
		end
	end
	hooksecurefunc('MountJournal_UpdateMountList', ColorSelectedMount)

	-- bug fix when we scroll
	MountJournalListScrollFrame:HookScript('OnVerticalScroll', ColorSelectedMount)
	MountJournalListScrollFrame:HookScript('OnMouseWheel', ColorSelectedMount)

	-----------------------------
	--[[ pet journal (tab 2) ]]--
	-----------------------------

	PetJournalSummonButton:StripTextures()
	PetJournalFindBattle:StripTextures()
	PetJournalSummonButton:SkinButton()
	PetJournalFindBattle:SkinButton()
	PetJournalRightInset:StripTextures()
	PetJournalLeftInset:StripTextures()

	PetJournal.PetCount:StripTextures()
	PetJournalSearchBox:SkinEditBox()
	PetJournalFilterButton:StripTextures(true)
	PetJournalFilterButton:SkinButton()
	PetJournalListScrollFrame:StripTextures()
	PetJournalListScrollFrameScrollBar:SkinScrollBar()
	
	for i = 1, #PetJournal.listScroll.buttons do
		local b = _G['PetJournalListScrollFrameButton'..i]
		local z = _G['PetJournalListScrollFrameButton'..i..'LevelBG']
		if not b.isSkinned then
			-- reskin mounts icons
			b:StripTextures()
			b:StyleButton()
			b:SetBackdropBorderColor(0,0,0,0)
			b:HideInsets()
			b.icon:SetTexCoord(.08, .92, .08, .92)
			b.dragButton:StyleButton()
			b.dragButton.hover:SetAllPoints(b.dragButton)
			b.dragButton.ActiveTexture:SetAlpha(0)

			-- create a backdrop around the icon
			b:CreateBD()
			b.backdrop:SetTemplate(true)
			b.backdrop:Point('TOPLEFT', b.icon, -2, 2)
			b.backdrop:Point('BOTTOMRIGHT', b.icon, 2, -2)
			b.backdrop:SetBackdropColor(0, 0, 0, 0)
			z:SetTexture(nil)
			b.isSkinned = true
		end
	end

	local function UpdatePetCardQuality()
		if PetJournalPetCard.petID  then
			local speciesID, customName, level, xp, maxXp, displayID, name, icon, petType, creatureID, sourceText, description, isWild, canBattle, tradable = C_PetJournal.GetPetInfoByPetID(PetJournalPetCard.petID)
			if canBattle then
				local health, maxHealth, power, speed, rarity = C_PetJournal.GetPetStats(PetJournalPetCard.petID)
				PetJournalPetCard.QualityFrame.quality:SetText(_G['BATTLE_PET_BREED_QUALITY'..rarity])
				local color = ITEM_QUALITY_COLORS[rarity-1]
				PetJournalPetCard.QualityFrame.quality:SetVertexColor(color.r, color.g, color.b)
				PetJournalPetCard.QualityFrame:Show()
			else
				PetJournalPetCard.QualityFrame:Hide()
			end
		end
	end
	hooksecurefunc('PetJournal_UpdatePetCard', UpdatePetCardQuality)

	local function ColorSelectedPet()
		local petButtons = PetJournal.listScroll.buttons
		if petButtons then
			for i = 1, #petButtons do
				local index = petButtons[i].index
				if index then
					local b = _G['PetJournalListScrollFrameButton'..i]
					local t = _G['PetJournalListScrollFrameButton'..i..'Name']
					local petID, speciesID, isOwned, customName, level, favorite, isRevoked, name, icon, petType, creatureID, sourceText, description, isWildPet, canBattle = C_PetJournal.GetPetInfoByIndex(index)
					
					if petID then
						local health, maxHealth, attack, speed, rarity = C_PetJournal.GetPetStats(petID)
						
						if b.dragButton.ActiveTexture:IsShown() then
							t:SetTextColor(1,1,0)
						else
							t:SetTextColor(1, 1, 1)
						end
						
						if rarity then
							local color = ITEM_QUALITY_COLORS[rarity-1]
							b.backdrop:SetBeautyBorderColor(color.r, color.g, color.b)
						else
							b.backdrop:SetBeautyBorderColor(1, 1, 0)
						end
					end
				end
			end
		end
	end
	hooksecurefunc('PetJournal_UpdatePetList', ColorSelectedPet)
	PetJournalListScrollFrame:HookScript('OnVerticalScroll', ColorSelectedPet)
	PetJournalListScrollFrame:HookScript('OnMouseWheel', ColorSelectedPet)

	PetJournalAchievementStatus:DisableDrawLayer('BACKGROUND')

	PetJournalHealPetButton:StripTextures()
	PetJournalHealPetButton:CreateBD(true)
	PetJournalHealPetButton:StyleButton()
	PetJournalHealPetButton.texture:SetTexture([[Interface\Icons\spell_magic_polymorphrabbit]])
	PetJournalHealPetButton.texture:SetTexCoord(.08, .88, .08, .88)
	PetJournalLoadoutBorder:StripTextures()
	for i=1, 3 do
		_G['PetJournalLoadoutPet'..i..'HelpFrame']:StripTextures()
		_G['PetJournalLoadoutPet'..i]:StripTextures()
		_G['PetJournalLoadoutPet'..i]:CreateBD(true)
		_G['PetJournalLoadoutPet'..i].backdrop:SetAllPoints()
		_G['PetJournalLoadoutPet'..i].petTypeIcon:SetPoint('BOTTOMLEFT', 2, 2)
		_G['PetJournalLoadoutPet'..i]:StyleButton()

		_G['PetJournalLoadoutPet'..i].dragButton:StyleButton()
		_G['PetJournalLoadoutPet'..i].dragButton:SetOutside(_G['PetJournalLoadoutPet'..i..'Icon'])
		_G['PetJournalLoadoutPet'..i].dragButton:SetFrameLevel(_G['PetJournalLoadoutPet'..i].dragButton:GetFrameLevel() + 1)
		_G['PetJournalLoadoutPet'..i]:SkinIconButton()
		_G['PetJournalLoadoutPet'..i].backdrop:SetFrameLevel(_G['PetJournalLoadoutPet'..i].backdrop:GetFrameLevel() + 1)

		_G['PetJournalLoadoutPet'..i].setButton:StripTextures()
		_G['PetJournalLoadoutPet'..i..'HealthFrame'].healthBar:StripTextures()
		_G['PetJournalLoadoutPet'..i..'HealthFrame'].healthBar:CreateBD()
		_G['PetJournalLoadoutPet'..i..'HealthFrame'].healthBar:SetStatusBarTexture(C.Media.StatusBar)
		_G['PetJournalLoadoutPet'..i..'XPBar']:StripTextures()
		_G['PetJournalLoadoutPet'..i..'XPBar']:CreateBD(true)
		_G['PetJournalLoadoutPet'..i..'XPBar']:SetStatusBarTexture(C.Media.StatusBar)
		_G['PetJournalLoadoutPet'..i..'XPBar']:SetFrameLevel(_G['PetJournalLoadoutPet'..i..'XPBar']:GetFrameLevel() + 2)

		for index = 1, 3 do
			local f = _G['PetJournalLoadoutPet'..i..'Spell'..index]
			f:SkinIconButton()
			f.FlyoutArrow:SetTexture([[Interface\Buttons\ActionBarFlyoutButton]])
			_G['PetJournalLoadoutPet'..i..'Spell'..index..'Icon']:SetInside(f)
		end
	end

	PetJournalSpellSelect:StripTextures()
	for i=1, 2 do
		local btn = _G['PetJournalSpellSelectSpell'..i]
		btn:SkinButton()
		_G['PetJournalSpellSelectSpell'..i..'Icon']:SetInside(btn)
		_G['PetJournalSpellSelectSpell'..i..'Icon']:SetDrawLayer('BORDER')
	end

	PetJournalPetCard:StripTextures()
	PetJournalPetCardInset:StripTextures()
	
	PetJournalTutorialButton.Ring:SetAlpha(0)
	PetJournalTutorialButton:ClearAllPoints()
	PetJournalTutorialButton:SetPoint('TOPLEFT', PetJournalParent, 0, 0)

	PetJournalPetCardPetInfo.levelBG:SetTexture(nil)
	PetJournalPetCardPetInfoIcon:SetTexCoord(.1,.9,.1,.9)
	PetJournalPetCardPetInfo:CreateBD()
	PetJournalPetCardPetInfo.backdrop:SetOutside(PetJournalPetCardPetInfoIcon)
	PetJournalPetCardPetInfoIcon:SetParent(PetJournalPetCardPetInfo.backdrop)
	PetJournalPetCardPetInfo.backdrop:SetFrameLevel(PetJournalPetCardPetInfo.backdrop:GetFrameLevel() + 2)
	PetJournalPetCardPetInfo.level:SetParent(PetJournalPetCardPetInfo.backdrop)

	local tt = PetJournalPrimaryAbilityTooltip
	tt.Background:SetTexture(nil)
	if tt.Delimiter1 then
		tt.Delimiter1:SetTexture(nil)
		tt.Delimiter2:SetTexture(nil)
	end
	tt.BorderTop:SetTexture(nil)
	tt.BorderTopLeft:SetTexture(nil)
	tt.BorderTopRight:SetTexture(nil)
	tt.BorderLeft:SetTexture(nil)
	tt.BorderRight:SetTexture(nil)
	tt.BorderBottom:SetTexture(nil)
	tt.BorderBottomRight:SetTexture(nil)
	tt.BorderBottomLeft:SetTexture(nil)
	tt:SetTemplate()

	for i=1, 6 do
		local frame = _G['PetJournalPetCardSpell'..i]
		frame:SetFrameLevel(frame:GetFrameLevel() + 2)
		frame:DisableDrawLayer('BACKGROUND')
		frame:CreateBD(true)
		frame.backdrop:SetAllPoints()
		frame.icon:SetTexCoord(.1,.9,.1,.9)
		frame.icon:SetInside(frame.backdrop)
	end

	PetJournalPetCardHealthFrame.healthBar:StripTextures()
	PetJournalPetCardHealthFrame.healthBar:CreateBD(true)
	PetJournalPetCardHealthFrame.healthBar:SetStatusBarTexture(C.Media.StatusBar)
	PetJournalPetCardXPBar:StripTextures()
	PetJournalPetCardXPBar:CreateBD(true)
	PetJournalPetCardXPBar:SetStatusBarTexture(C.Media.StatusBar)
	PetJournalLoadoutBorder:Height(350)
end

if PetJournalParent then
	tinsert(F.SkinFuncs['LanUI'], LoadSkin)
else
	F.SkinFuncs['Blizzard_PetJournal'] = LoadSkin
end

local function LoadPetStableSkin()
	PetStableFrame:StripTextures()
	PetStableFrame:SetTemplate()
	PetStableFrameInset:StripTextures()
	PetStableLeftInset:StripTextures()
	PetStableBottomInset:StripTextures()
	PetStableFrameCloseButton:SkinCloseButton()
	PetStablePrevPageButton:SkinNextPrevButton()
	PetStableNextPageButton:SkinNextPrevButton()
	
	for i = 1, 5 do
		local b = _G['PetStableActivePet'..i]
		b.Border:Hide()
		b.Background:Hide()
		b:SkinButton()
	end
	
	for i = 1, 10 do
		local b = _G['PetStableStabledPet'..i]
		b.Background:Hide()
		b:SkinButton()
		b:StyleButton()
	end
end
tinsert(F.SkinFuncs['LanUI'], LoadPetStableSkin)
