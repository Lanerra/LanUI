local F, C, G = unpack(select(2, ...))
local bc = C.Media.BorderColor

local function LoadSkin()
	local buttons = {
		'PlayerTalentFrameTalentsLearnButton',
		'PlayerTalentFrameActivateButton',
		'PlayerTalentFramePetSpecializationLearnButton',
		'PlayerTalentFrameSpecializationLearnButton'
	}

	for i = 1, #buttons do
		_G[buttons[i]]:StripTextures()
		_G[buttons[i]]:SkinButton()
	end

	PlayerTalentFrameTalentsTutorialButton.Ring:Hide()
	PlayerTalentFrameTalentsTutorialButton:Point('TOPLEFT', PlayerTalentFrame, 'TOPLEFT', -12, 12)
	PlayerTalentFrameSpecializationTutorialButton.Ring:Hide()
	PlayerTalentFrameSpecializationTutorialButton:Point('TOPLEFT', PlayerTalentFrame, 'TOPLEFT', -12, 12)
	PlayerTalentFramePetSpecializationTutorialButton.Ring:Hide()
	PlayerTalentFramePetSpecializationTutorialButton:Point('TOPLEFT', PlayerTalentFrame, 'TOPLEFT', -12, 12)

	PlayerTalentFrame:StripTextures()
	PlayerTalentFrameInset:StripTextures()
	PlayerTalentFrame:CreateBD(true)
	PlayerTalentFrame.backdrop:Point('TOPLEFT', 0, 0)
	PlayerTalentFrame.backdrop:Point('BOTTOMRIGHT', 0, -1)

	PlayerTalentFrameTalentsBg:Hide()
	PlayerTalentFrameTalents:DisableDrawLayer('BORDER')

	PlayerTalentFrameCloseButton:SkinCloseButton()

	for i = 1, 6 do
		select(i, PlayerTalentFrameSpecialization:GetRegions()):Hide()
	end

	select(7, PlayerTalentFrameSpecialization:GetChildren()):DisableDrawLayer('OVERLAY')

	for i = 1, 5 do
		select(i, PlayerTalentFrameSpecializationSpellScrollFrameScrollChild:GetRegions()):Hide()
	end

	PlayerTalentFrameTalentsClearInfoFrame:SetTemplate()
	PlayerTalentFrameTalentsClearInfoFrameIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	PlayerTalentFrameTalentsClearInfoFrameIcon:Point('TOPLEFT', 2, -2)
	PlayerTalentFrameTalentsClearInfoFrameIcon:Point('BOTTOMRIGHT', -2, 2)

	PlayerTalentFrameSpecializationSpellScrollFrameScrollChild.Seperator:SetTexture(1, 1, 1)
	PlayerTalentFrameSpecializationSpellScrollFrameScrollChild.Seperator:SetAlpha(0.2)

	if F.MyClass == 'HUNTER' then
		for i = 1, 6 do
			select(i, PlayerTalentFramePetSpecialization:GetRegions()):Hide()
		end

		select(7, PlayerTalentFramePetSpecialization:GetChildren()):DisableDrawLayer('OVERLAY')

		for i = 1, 5 do
			select(i, PlayerTalentFramePetSpecializationSpellScrollFrameScrollChild:GetRegions()):Hide()
		end

		PlayerTalentFramePetSpecializationSpellScrollFrameScrollChild.Seperator:SetTexture(1, 1, 1)
		PlayerTalentFramePetSpecializationSpellScrollFrameScrollChild.Seperator:SetAlpha(0.2)

		for i = 1, GetNumSpecializations(false, true) do
			local bu = PlayerTalentFramePetSpecialization['specButton'..i]
			local _, _, _, icon = GetSpecializationInfo(i, false, true)

			bu.ring:Hide()
			bu.specIcon:SetTexture(icon)
			bu.specIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			bu.specIcon:SetSize(50, 50)
			bu.specIcon:Point('LEFT', bu, 'LEFT', 15, 0)
		end
	end

	for i = 1, NUM_TALENT_FRAME_TABS do
		_G['PlayerTalentFrameTab'..i]:SkinTab()
		
		PlayerTalentFrameTab1:SetPoint('TOPLEFT', PlayerTalentFrame, 'BOTTOMLEFT', 15, 1)
		
		if i ~= 1 then
			_G['PlayerTalentFrameTab'..i]:ClearAllPoints()
			_G['PlayerTalentFrameTab'..i].ClearAllPoints = F.Dummy
			_G['PlayerTalentFrameTab'..i]:Point('LEFT', _G['PlayerTalentFrameTab'..i - 1], 'RIGHT', 4, 0)
			_G['PlayerTalentFrameTab'..i].SetPoint = F.Dummy
		end
	end

	local pspecspell = _G['PlayerTalentFrameSpecializationSpellScrollFrameScrollChild']
	pspecspell.ring:Hide()
	pspecspell:CreateBD(true)
	pspecspell.backdrop:Point('TOPLEFT', pspecspell.specIcon, -2, 2)
	pspecspell.backdrop:Point('BOTTOMRIGHT', pspecspell.specIcon, 2, -2)
	pspecspell.specIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	pspecspell.specIcon:SetParent(pspecspell.backdrop)

	local specspell2 = _G['PlayerTalentFramePetSpecializationSpellScrollFrameScrollChild']
	specspell2.ring:Hide()
	specspell2:CreateBD(true)
	specspell2.backdrop:Point('TOPLEFT', specspell2.specIcon, -2, 2)
	specspell2.backdrop:Point('BOTTOMRIGHT', specspell2.specIcon, 2, -2)
	specspell2.specIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	specspell2.specIcon:SetParent(specspell2.backdrop)

	hooksecurefunc('PlayerTalentFrame_UpdateSpecFrame', function(self, spec)
		local playerTalentSpec = GetSpecialization(nil, self.isPet, PlayerSpecTab2:GetChecked() and 2 or 1)
		local shownSpec = spec or playerTalentSpec or 1

		local id, _, _, icon = GetSpecializationInfo(shownSpec, nil, self.isPet)
		local scrollChild = self.spellsScroll.child

		scrollChild.specIcon:SetTexture(icon)

		local index = 1
		local bonuses
		if self.isPet then
			bonuses = {GetSpecializationSpells(shownSpec, nil, self.isPet)}
		else
			bonuses = SPEC_SPELLS_DISPLAY[id]
		end
		for i = 1, #bonuses, 2 do
			local frame = scrollChild['abilityButton'..index]
			local _, icon = GetSpellTexture(bonuses[i])
			frame.icon:SetTexture(icon)
			if not frame.reskinned then
				frame.reskinned = true
				frame:Size(30, 30)
				frame.ring:Hide()
				frame:SetTemplate(true)
				frame.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
				frame.icon:Point('TOPLEFT', 2, -2)
				frame.icon:Point('BOTTOMRIGHT', -2, 2)				
			end
			

			index = index + 1
		end

		for i = 1, GetNumSpecializations(nil, self.isPet) do
			local bu = self['specButton'..i]
			if bu.selected then
				bu.backdrop:SetBeautyBorderColor(1, 0.82, 0, 1)
			else
				bu.backdrop:SetBackdropBorderColor(bc.r, bc.g, bc.b)
			end
		end
	end)

	for i = 1, GetNumSpecializations(false, nil) do
		local bu = PlayerTalentFrameSpecialization['specButton'..i]
		local _, _, _, icon = GetSpecializationInfo(i, false, nil)

		bu.ring:Hide()

		bu.specIcon:SetTexture(icon)
		bu.specIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		bu.specIcon:SetSize(50, 50)
		bu.specIcon:Point('LEFT', bu, 'LEFT', 15, 0)
	end

	local buttons = {'PlayerTalentFrameSpecializationSpecButton', 'PlayerTalentFramePetSpecializationSpecButton'}

	for _, name in pairs(buttons) do
		for i = 1, 4 do
			local bu = _G[name..i]
			_G['PlayerTalentFrameSpecializationSpecButton'..i..'Glow']:Hide()
			_G['PlayerTalentFrameSpecializationSpecButton'..i..'Glow'].Show = F.Dummy

			bu:SetHighlightTexture('')
			bu.bg:SetAlpha(0)
			bu.learnedTex:SetAlpha(0)
			bu.selectedTex:SetAlpha(0)

			bu:CreateBD(true)
			bu.backdrop:Point('TOPLEFT', 8, 2)
			bu.backdrop:Point('BOTTOMRIGHT', 10, -2)

			--[[bu.border = CreateFrame('Frame', nil, bu)
			bu.border:CreateBD()
			bu.border.backdrop:Point('TOPLEFT', bu.specIcon, -2, 2)
			bu.border.backdrop:Point('BOTTOMRIGHT', bu.specIcon, 2, -2)]]
		end
	end

	for i = 1, MAX_NUM_TALENT_TIERS do
		local row = _G['PlayerTalentFrameTalentsTalentRow'..i]
		_G['PlayerTalentFrameTalentsTalentRow'..i..'Bg']:Hide()
		row:DisableDrawLayer('BORDER')
		row:StripTextures()

		row.TopLine:Point('TOP', 0, 4)
		row.BottomLine:Point('BOTTOM', 0, -4)

		for j = 1, NUM_TALENT_COLUMNS do
			local bu = _G['PlayerTalentFrameTalentsTalentRow'..i..'Talent'..j]
			local ic = _G['PlayerTalentFrameTalentsTalentRow'..i..'Talent'..j..'IconTexture']

			bu:StripTextures()
			bu:SetFrameLevel(bu:GetFrameLevel() + 2)
			bu:CreateBD(true)
			bu.backdrop:Point('TOPLEFT', ic, -2, 2)
			bu.backdrop:Point('BOTTOMRIGHT', ic, 2, -2)

			ic:SetDrawLayer('ARTWORK')
			ic:SetTexCoord(0.1, 0.9, 0.1, 0.9)

			bu.bg = CreateFrame('Frame', nil, bu)
			bu.bg:CreateBD(true)
			bu.bg:SetFrameLevel(bu:GetFrameLevel() - 1)
			bu.bg:Point('TOPLEFT', 15, -1)
			bu.bg:Point('BOTTOMRIGHT', -10, 1)
		end
	end

	hooksecurefunc('TalentFrame_Update', function()
		for i = 1, MAX_NUM_TALENT_TIERS do
			for j = 1, NUM_TALENT_COLUMNS do
				local bu = _G['PlayerTalentFrameTalentsTalentRow'..i..'Talent'..j]
				if bu.knownSelection:IsShown() then
					bu.backdrop:SetBeautyBorderColor(0, 1, 0, 1)
					bu.bg.backdrop:SetBackdropColor(0, .2, 0, 1)
				else
					bu.backdrop:SetBeautyBorderColor(bc.r, bc.g, bc.b)
					bu.bg.backdrop:SetBackdropColor(unpack(C.Media.BackdropColor))
				end
				if bu.learnSelection:IsShown() then
					bu.backdrop:SetBeautyBorderColor(1, 0.82, 0, 1)
					bu.bg.backdrop:SetBackdropColor(.2, .2, 0, 1)
				end
			end
		end
	end)

	for i = 1, 2 do
		local tab = _G['PlayerSpecTab'..i]
		_G['PlayerSpecTab'..i..'Background']:Hide()

		tab:StripTextures()
		tab:GetNormalTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)
		tab:GetNormalTexture():ClearAllPoints()
		tab:GetNormalTexture():Point('TOPLEFT', 3, -3)
		tab:GetNormalTexture():Point('BOTTOMRIGHT', -3, 3)

		tab:CreateBD(true)
		tab.backdrop:SetAllPoints()
		tab:StyleButton()
		tab:SetFrameStrata('LOW')
	end

	-- Reposition tabs
	hooksecurefunc('PlayerTalentFrame_UpdateSpecs', function()
		PlayerSpecTab1:Point('TOPLEFT', PlayerTalentFrame, 'TOPRIGHT', -1, -10)
		PlayerSpecTab2:Point('TOP', PlayerSpecTab1, 'BOTTOM')
	end)
	
	TalentMicroButtonAlert:StripTextures()
	TalentMicroButtonAlert:SetTemplate()
	TalentMicroButtonAlert:SetBeautyBorderColor(1, 1, 0)
	TalentMicroButtonAlert.CloseButton:SkinCloseButton()
	TalentMicroButtonAlert.CloseButton:ClearAllPoints()
	TalentMicroButtonAlert.CloseButton:SetPoint('TOPRIGHT', 6, 1)
	TalentMicroButtonAlert.CloseButton.t:SetTextColor(1, 1, 0)
	TalentMicroButtonAlert.Text:SetTextColor(1, 1, 0)
	TalentMicroButtonAlert:ClearAllPoints()
	if oUF_Lanerra_Player then
		TalentMicroButtonAlert:SetPoint('BOTTOM', oUF_Lanerra_Player, 'TOP', 0, -2)
	else
		TalentMicroButtonAlert:SetPoint('BOTTOM', UIPARENT, 'BOTTOM', 0, -6)
	end
end

F.SkinFuncs['Blizzard_TalentUI'] = LoadSkin