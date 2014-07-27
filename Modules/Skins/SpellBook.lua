local F, C, G = unpack(select(2, ...))
local bc = C.Media.BorderColor

local function LoadSkin()
	local StripAllTextures = {
		'SpellBookFrame',
		'SpellBookFrameInset',
		'SpellBookSpellIconsFrame',
		'SpellBookSideTabsFrame',
		'SpellBookPageNavigationFrame'
	}

	local KillTextures = {
		'SpellBookFrameTutorialButton',
		'SpellBookPage1',
		'SpellBookPage2'
	}

	for _, object in pairs(StripAllTextures) do
		_G[object]:StripTextures()
	end

	for _, texture in pairs(KillTextures) do
		_G[texture]:Kill()
	end
	
	local pagebackdrop = CreateFrame("Frame", nil, SpellBookFrame)
	pagebackdrop:SetTemplate()
	pagebackdrop:Point("TOPLEFT", SpellBookPage1, "TOPLEFT", -2, 2)
	pagebackdrop:Point("BOTTOMRIGHT", SpellBookFrame, "BOTTOMRIGHT", -8, 4)
	
	for i=1, 2 do
		_G['SpellBookPage'..i]:SetParent(pagebackdrop)
		_G['SpellBookPage'..i]:SetDrawLayer('BACKGROUND', 3)
	end

	SpellBookPrevPageButton:SkinNextPrevButton()
	SpellBookNextPageButton:SkinNextPrevButton()

	-- Skin SpellButtons
	local function SpellButtons(self, first)
		for i = 1, SPELLS_PER_PAGE do
			local button = _G['SpellButton'..i]
			local icon = _G['SpellButton'..i..'IconTexture']

			--[[if not InCombatLockdown() then
				button:SetFrameLevel(SpellBookFrame:GetFrameLevel() + 5)
			end]]
			
			if first then
				for i = 1, button:GetNumRegions() do
					local region = select(i, button:GetRegions())
					if region:GetObjectType() == 'Texture' then
						if region ~= button.FlyoutArrow then
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
			
			if button.shine then
				button.shine:ClearAllPoints()
				button.shine:SetPoint('TOPLEFT', button, 'TOPLEFT', -3, 3)
				button.shine:SetPoint('BOTTOMRIGHT', button, 'BOTTOMRIGHT', 3, -3)
			end

			if icon then
				icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
				icon:ClearAllPoints()
				icon:SetAllPoints()

				if not button.backdrop then
					button:CreateBD(true)
					button.backdrop:SetOutside()
					button.backdrop:SetBeautyBorderPadding(2)
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
	
	SpellButtons(nil, true)
	hooksecurefunc('SpellButton_UpdateButton', SpellButtons)

	local function CoreAbilities(i)
		local button = SpellBookCoreAbilitiesFrame.Abilities[i];
		if button.skinned then return; end
		
		local icon = button.iconTexture
		
		if not InCombatLockdown() then
			if not button.properFrameLevel then
				button.properFrameLevel = button:GetFrameLevel() + 1
			end
			button:SetFrameLevel(button.properFrameLevel)
		end
		
		if not button.isSkinned then
			for i=1, button:GetNumRegions() do
				local region = select(i, button:GetRegions())
				if region:GetObjectType() == 'Texture' then
					if region:GetTexture() ~= 'Interface\\Buttons\\ActionBarFlyoutButton' then
						region:SetTexture(nil)
					end
				end
			end
			if button.highlightTexture then
				hooksecurefunc(button.highlightTexture,'SetTexture',function(self, texOrR, G, B)
					if texOrR == [[Interface\Buttons\ButtonHilight-Square]] then
						button.highlightTexture:SetTexture(1, 1, 1, 0.3)
					end
				end)		
			end
			button.isSkinned = true
		end
		
		if icon then
			icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			icon:ClearAllPoints()
			icon:SetAllPoints()

			if not button.backdrop then
				button:CreateBD(true)
			end
		end		
			
		button.isSkinned = true;
	end
	hooksecurefunc('SpellBook_GetCoreAbilityButton', CoreAbilities)
	
	local function SkinTab(tab)
		tab:StripTextures()
		tab:GetNormalTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)
		tab:GetNormalTexture():SetInside()
		
		tab.pushed = true;
		tab:CreateBD(true)
		tab.backdrop:SetAllPoints()
		--tab:StyleButton(true)
		hooksecurefunc(tab:GetHighlightTexture(), 'SetTexture', function(self, texPath)
			if texPath ~= nil then
				self:SetPushedTexture(nil);
			end
		end)	

		hooksecurefunc(tab:GetCheckedTexture(), 'SetTexture', function(self, texPath)
			if texPath ~= nil then
				self:SetHighlightTexture(nil);
			end
		end)		
	
		local point, relatedTo, point2, x, y = tab:GetPoint()
		tab:Point(point, relatedTo, point2, 1, y)
	end	
	
	SpellBookPageText:SetTextColor(0.6, 0.6, 0.6)

	-- Skill Line Tabs
	for i = 1, MAX_SKILLLINE_TABS do
		local tab = _G['SpellBookSkillLineTab'..i]
		_G['SpellBookSkillLineTab'..i..'Flash']:Kill()
		SkinTab(tab)
	end
	
	local function SkinCoreTabs(index)
		local button = SpellBookCoreAbilitiesFrame.SpecTabs[index]
		SkinTab(button)
		
		if index > 1 then
			local point, attachTo, anchorPoint, _, _ = button:GetPoint()
			button:ClearAllPoints()
			button:SetPoint(point, attachTo, anchorPoint, 0, -10)
		else
			button:ClearAllPoints()
			button:SetPoint('TOPLEFT', SpellBookFrame, 'TOPRIGHT', -8, -32)
		end
	end
	
	hooksecurefunc('SpellBook_GetCoreAbilitySpecTab', SkinCoreTabs)

	for i = 1, 4 do
		local tab = _G['SpellBookSkillLineTab'..i]
		local prev =_G['SpellBookSkillLineTab'..i-1]

		tab:ClearAllPoints()
		tab.ClearAllPoints = function() return end
		if i == 1 then
			tab:SetPoint('TOPLEFT', SpellBookFrame, 'TOPRIGHT', -8, -32)
		else
			tab:SetPoint('TOP', prev, 'BOTTOM', 0, -10)
		end

		tab.SetPoint = function() return end
	end
	
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

	SpellBookFrameCloseButton:SkinCloseButton()
	SpellBookFrameCloseButton:SetPoint('TOPRIGHT', SpellBookFrame, -5, -20)
	SpellBookFrameTitleText:Kill()

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
		'SecondaryProfession4SpellButtonRight',
	}

	local professionheaders = {
		'PrimaryProfession1',
		'PrimaryProfession2',
		'SecondaryProfession1',
		'SecondaryProfession2',
		'SecondaryProfession3',
		'SecondaryProfession4',
	}

	for _, header in pairs(professionheaders) do
		_G[header..'Missing']:SetTextColor(1, 0.8, 0)
		_G[header].missingText:SetTextColor(0.6, 0.6, 0.6)
	end
	
	for _, button in pairs(professionbuttons) do
		local icon = _G[button..'IconTexture']
		local button = _G[button]
		button:StripTextures()

		if icon then
			icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			--icon:SetInside()
			icon:ClearAllPoints()
			icon:Point('TOPLEFT', 4, -4)
			icon:Point('BOTTOMRIGHT', -4, 4)

			button:SetFrameLevel(button:GetFrameLevel() + 2)
			if not button.isSkinned then
				button:SetTemplate()
				button.isSkinned = true
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
		statusbar.backdrop:SetOutside()
		statusbar.backdrop:SetBeautyBorderPadding(2)
		
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
	_G['SpellBookFrameTabButton1']:Point('TOPLEFT', _G['SpellBookFrame'], 'BOTTOMLEFT', 10, 7)
end

tinsert(F.SkinFuncs['LanUI'], LoadSkin)