local F, C, G = unpack(select(2, ...))
local bc = C.Media.BorderColor

local function LoadSkin()
	if InCombatLockdown() then return end
	local StripAllTextures = {
		'SpellBookFrame',
		'SpellBookFrameInset',
		'SpellBookSpellIconsFrame',
		'SpellBookSideTabsFrame',
		'SpellBookPageNavigationFrame'
	}

	local KillTextures = {
		'SpellBookPage1',
		'SpellBookPage2'
	}

	for _, object in pairs(StripAllTextures) do
		_G[object]:StripTextures()
	end

	for _, texture in pairs(KillTextures) do
		_G[texture]:Kill()
	end

	SpellBookPrevPageButton:SkinNextPrevButton()
	SpellBookNextPageButton:SkinNextPrevButton()
	SpellBookNextPageButton:Point('BOTTOMRIGHT', SpellBookFrame, 'BOTTOMRIGHT', -15, 10)
	SpellBookPrevPageButton:Point('BOTTOMRIGHT', SpellBookNextPageButton, 'BOTTOMLEFT', -6, 0)

	SpellBookFrameTutorialButton.Ring:Hide()
	SpellBookFrameTutorialButton:SetPoint('TOPLEFT', SpellBookFrame, 'TOPLEFT', -5, 10)

	-- Skin SpellButtons
	local function SpellButtons(self, first)
		if not InCombatLockdown() then
			for i = 1, SPELLS_PER_PAGE do
				local button = _G['SpellButton'..i]
				local icon = _G['SpellButton'..i..'IconTexture']

				if first then
					for i = 1, button:GetNumRegions() do
						local region = select(i, button:GetRegions())
						if region:GetObjectType() == 'Texture' then
							if region:GetTexture() ~= 'Interface\\Buttons\\ActionBarFlyoutButton' then
								region:SetTexture(nil)
							end
						end
					end
				end

				if _G['SpellButton'..i..'Highlight'] then
					_G['SpellButton'..i..'Highlight']:SetTexture(1, 1, 1, 0.3)
					_G['SpellButton'..i..'Highlight']:ClearAllPoints()
					_G['SpellButton'..i..'Highlight']:SetAllPoints(icon)
				end

				if icon then
					icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
					icon:ClearAllPoints()
					icon:SetAllPoints()

					if not button.backdrop then
						button:SetFrameLevel(button:GetFrameLevel() + 1)
						button:CreateBD()
						button.backdrop:SetTemplate(true)
					end
				end

				local r, g, b = _G['SpellButton'..i..'SpellName']:GetTextColor()

				if r < 0.8 then
					_G['SpellButton'..i..'SpellName']:SetTextColor(0.6, 0.6, 0.6)
				end
				_G['SpellButton'..i..'SubSpellName']:SetTextColor(0.6, 0.6, 0.6)
				_G['SpellButton'..i..'RequiredLevelString']:SetTextColor(0.6, 0.6, 0.6)
			end
		end
	end
	if not InCombatLockdown() then SpellButtons(nil, true) end
	hooksecurefunc('SpellButton_UpdateButton', SpellButtons)

	SpellBookPageText:SetTextColor(0.6, 0.6, 0.6)

	-- Skill Line Tabs
	for i = 1, MAX_SKILLLINE_TABS do
		local tab = _G['SpellBookSkillLineTab'..i]
		_G['SpellBookSkillLineTab'..i..'Flash']:Kill()
		if tab then
			tab:StripTextures()
			tab:GetNormalTexture():ClearAllPoints()
			tab:GetNormalTexture():Point('TOPLEFT', 3, -3)
			tab:GetNormalTexture():Point('BOTTOMRIGHT', -3, 3)
			tab:GetNormalTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)

			tab:CreateBD()
			tab.backdrop:SetTemplate(true)
			tab:SetFrameStrata('LOW')
			tab.backdrop:SetAllPoints()
			tab:StyleButton()

			local point, relatedTo, point2, x, y = tab:GetPoint()
			tab:Point(point, relatedTo, point2, 16, -1)
		end
	end

	SpellBookSkillLineTab1:SetPoint('TOPLEFT', SpellBookSideTabsFrame, 'TOPRIGHT', 14, -10)
	
	local function SkinSkillLine()
		for i = 1, MAX_SKILLLINE_TABS do
			local tab = _G['SpellBookSkillLineTab'..i]
			local _, _, _, _, isGuild = GetSpellTabInfo(i)
			if isGuild then
				tab:GetNormalTexture():ClearAllPoints()
				tab:GetNormalTexture():Point('TOPLEFT', 2, -2)
				tab:GetNormalTexture():Point('BOTTOMRIGHT', -2, 2)
				tab:GetNormalTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)
			end
		end
	end
	hooksecurefunc('SpellBookFrame_UpdateSkillLineTabs', SkinSkillLine)

	SpellBookFrame:CreateBD()
	SpellBookFrame.backdrop:SetTemplate(true)
	SpellBookFrame.backdrop:Point('TOPLEFT', 5, -1)
	SpellBookFrame.backdrop:Point('BOTTOMRIGHT', 15, -1)

	SpellBookFrameCloseButton:SkinCloseButton(SpellBookFrame.backdrop)

	-- Profession Tab
	local professionbuttons = {
		'PrimaryProfession1SpellButtonTop',
		'PrimaryProfession1SpellButtonBottom',
		'PrimaryProfession2SpellButtonTop',
		'PrimaryProfession2SpellButtonBottom',
		'SecondaryProfession1SpellButtonLeft',
		'SecondaryProfession1SpellButtonRight',
		'SecondaryProfession2SpellButtonLeft',
		'SecondaryProfession2SpellButtonRight',
		'SecondaryProfession3SpellButtonLeft',
		'SecondaryProfession3SpellButtonRight',
		'SecondaryProfession4SpellButtonLeft',
		'SecondaryProfession4SpellButtonRight'
	}

	local professionheaders = {
		'PrimaryProfession1',
		'PrimaryProfession2',
		'SecondaryProfession1',
		'SecondaryProfession2',
		'SecondaryProfession3',
		'SecondaryProfession4'
	}

	if not InCombatLockdown() then
		for _, header in pairs(professionheaders) do
			_G[header..'Missing']:SetTextColor(1, 0.8, 0)
			_G[header..'Missing']:SetShadowColor(0, 0, 0)
			_G[header..'Missing']:SetShadowOffset(1, -1)
			_G[header].missingText:SetTextColor(0.6, 0.6, 0.6)
		end

		for _, button in pairs(professionbuttons) do
			local icon = _G[button..'IconTexture']
			local rank = _G[button..'SubSpellName']
			local button = _G[button]
			button:StripTextures()

			if rank then
				rank:SetTextColor(1, 1, 1)
			end

			if icon then
				icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
				icon:ClearAllPoints()
				icon:Point('TOPLEFT', 4, -4)
				icon:Point('BOTTOMRIGHT', -4, 4)

				button:SetFrameLevel(button:GetFrameLevel() + 2)
				if not button.backdrop then
					button:CreateBD()
					button.backdrop:SetTemplate(true)
					button.backdrop:Point('TOPLEFT', 2, -2)
					button.backdrop:Point('BOTTOMRIGHT', -2, 2)
				end
			end
		end
	end

	local professionstatusbars = {
		'PrimaryProfession1StatusBar',
		'PrimaryProfession2StatusBar',
		'SecondaryProfession1StatusBar',
		'SecondaryProfession2StatusBar',
		'SecondaryProfession3StatusBar',
		'SecondaryProfession4StatusBar'
	}

	for _, statusbar in pairs(professionstatusbars) do
		local statusbar = _G[statusbar]
		statusbar:StripTextures()
		statusbar:SetStatusBarTexture(C.Media.StatusBar)
		statusbar:SetStatusBarColor(0, 0.3, 0)
		statusbar:CreateBD(true)

		statusbar.rankText:ClearAllPoints()
		statusbar.rankText:SetPoint('CENTER')
	end

	-- Bottom Tabs
	for i = 1, 5 do
		_G['SpellBookFrameTabButton'..i]:SkinTab()
		
		if i ~= 1 then
			_G['SpellBookFrameTabButton'..i]:Point('LEFT', _G['SpellBookFrameTabButton'..i - 1], 'RIGHT', 4, 0)
		end
	end
	_G['SpellBookFrameTabButton1']:ClearAllPoints()
	_G['SpellBookFrameTabButton1']:Point('TOPLEFT', _G['SpellBookFrame'], 'BOTTOMLEFT', 10, 1)

	-- Core Ability Tab
	local function SkinCoreTabs()
		for i = 1, 4 do
			local tab = SpellBookCoreAbilitiesFrame.SpecTabs[i]
			if tab and tab.isSkinned ~= true then
				local id, name, description, icon = GetSpecializationInfo(i)
				
				tab:StripTextures()
				tab:SetNormalTexture(icon)
				tab:GetNormalTexture():ClearAllPoints()
				tab:GetNormalTexture():SetInside()
				tab:GetNormalTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)

				tab:CreateBD()
				tab.backdrop:SetAllPoints()

				tab:StyleButton()

				if i == 1 then
					tab:SetPoint('TOPLEFT', SpellBookFrame.backdrop, 'TOPRIGHT', 1, 0)
				end
				
				tab.isSkinned = true
			end
		end
	end

	hooksecurefunc('SpellBook_UpdateCoreAbilitiesTab', function()
		for i = 1, #SpellBookCoreAbilitiesFrame.Abilities do
			local button = SpellBookCoreAbilitiesFrame.Abilities[i]
			if button and button.isSkinned ~= true then
				button:SetTemplate(true)

				button.EmptySlot:SetAlpha(0)
				button.ActiveTexture:SetAlpha(0)
				button.FutureTexture:SetAlpha(0)

				button.iconTexture:SetTexCoord(0.1, 0.9, 0.1, 0.9)
				button.iconTexture:SetInside()

				if button.FutureTexture:IsShown() then
					button.iconTexture:SetDesaturated(true)
					button.Name:SetTextColor(0.6, 0.6, 0.6)
					button.InfoText:SetTextColor(0.6, 0.6, 0.6)
				else
					button.Name:SetTextColor(1, 0.82, 0)
					button.InfoText:SetTextColor(0.8, 0.8, 0.8)
				end
				
				button:StyleButton()
				button.isSkinned = true
			end
		end
		SkinCoreTabs()
	end)

	-- What Has Changed Tab
	hooksecurefunc('SpellBook_UpdateWhatHasChangedTab', function()
		for i = 1, #SpellBookWhatHasChanged.ChangedItems do
			local button = SpellBook_GetWhatChangedItem(i)
			button.Ring:Hide()
			select(2, button:GetRegions()):Hide()
			button:SetTextColor(0.8, 0.8, 0.8)
			button.Title:SetTextColor(1, 0.82, 0)
		end
	end)
end

tinsert(F.SkinFuncs['LanUI'], LoadSkin)