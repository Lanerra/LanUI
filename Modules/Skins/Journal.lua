local F, C, G = unpack(select(2, ...))
local bc = C.Media.BorderColor

local function LoadSkin()
	EncounterJournal:StripTextures(true)
	
	EncounterJournal.backdrop = EncounterJournal:CreateTexture(nil, 'BACKGROUND')
	EncounterJournal.backdrop:SetDrawLayer('BACKGROUND', -7)
	EncounterJournal.backdrop:SetTexture(0, 0, 0, 0.5)
	EncounterJournal.backdrop:Point('TOPLEFT', EncounterJournal, 'TOPLEFT')
	EncounterJournal.backdrop:Point('BOTTOMRIGHT', EncounterJournal, 'BOTTOMRIGHT')
	EncounterJournal:SetTemplate(true)
	
	EncounterJournalNavBar:StripTextures(true)
	EncounterJournalNavBar:SetPoint('TOPLEFT', EncounterJournal, 7, -22)
	EncounterJournalNavBarOverlay:StripTextures(true)
	
	EncounterJournalNavBarHomeButton:SkinButton(true)
	EncounterJournalNavBarHomeButton:ClearAllPoints()
	EncounterJournalNavBarHomeButton:Point('LEFT', EncounterJournalNavBar)
	
	if EncounterJournalNavBarButton2 then
		EncounterJournalNavBarButton2:Point('LEFT', EncounterJournalNavBarHomeButton, 'RIGHT', 4, 0)
	end
	
	EncounterJournalSearchBox:SkinEditBox()
	EncounterJournalCloseButton:SkinCloseButton()
	
	EncounterJournalInset:StripTextures(true)
	EncounterJournal:HookScript('OnShow', function()
		if not EncounterJournalEncounterFrameInfo.backdrop then									
			EncounterJournalEncounterFrameInfo:CreateBD(true)
			EncounterJournalEncounterFrameInfo.backdrop:SetFrameStrata('BACKGROUND')
			EncounterJournalEncounterFrameInfo.backdrop:SetFrameLevel(0)
		end
		
		EncounterJournalEncounterFrameInfoBossTab:SetTemplate()
		EncounterJournalEncounterFrameInfoBossTab:ClearAllPoints()
		EncounterJournalEncounterFrameInfoBossTab:Point('TOPRIGHT', EncounterJournalEncounterFrame, 'TOPRIGHT', 69, 20)
		
		EncounterJournalEncounterFrameInfoLootTab:SetTemplate()
		EncounterJournalEncounterFrameInfoLootTab:ClearAllPoints()
		EncounterJournalEncounterFrameInfoLootTab:Point('TOP', EncounterJournalEncounterFrameInfoBossTab, 'BOTTOM', 0, -4)
		

		EncounterJournalEncounterFrameInfoModelTab:SetTemplate()
		EncounterJournalEncounterFrameInfoModelTab:ClearAllPoints()
		EncounterJournalEncounterFrameInfoModelTab:Point('TOP', EncounterJournalEncounterFrameInfoLootTab, 'BOTTOM', 0, -4)		
	end)
	
	EncounterJournalInstanceSelectScrollFrameScrollBar:SkinScrollBar()

	EncounterJournalEncounterFrameInfoBossTab:GetNormalTexture():SetTexture(nil)
	EncounterJournalEncounterFrameInfoBossTab:GetPushedTexture():SetTexture(nil)
	EncounterJournalEncounterFrameInfoBossTab:GetDisabledTexture():SetTexture(nil)
	EncounterJournalEncounterFrameInfoBossTab:GetHighlightTexture():SetTexture(nil)

	EncounterJournalEncounterFrameInfoLootTab:GetNormalTexture():SetTexture(nil)
	EncounterJournalEncounterFrameInfoLootTab:GetPushedTexture():SetTexture(nil)
	EncounterJournalEncounterFrameInfoLootTab:GetDisabledTexture():SetTexture(nil)
	EncounterJournalEncounterFrameInfoLootTab:GetHighlightTexture():SetTexture(nil)	
	
	EncounterJournalInstanceSelect:StripTextures()
	EncounterJournalInstanceSelectDungeonTab:SkinTab()
	EncounterJournalInstanceSelectDungeonTab:SetFrameStrata('HIGH')
	EncounterJournalInstanceSelectRaidTab.grayBox:StripTextures()
	EncounterJournalInstanceSelectRaidTab:SkinTab()
	EncounterJournalInstanceSelectRaidTab:Enable()
	EncounterJournalInstanceSelectRaidTab:SetFrameStrata('HIGH')
	EncounterJournal.instanceSelect.bg:SetAlpha(0)
	EncounterJournalInstanceSelectScrollDownButton:SkinCloseButton()
	EncounterJournalInstanceSelectScrollDownButton.t:SetText(' V')
	EncounterJournalInstanceSelectScrollDownButton.t:SetPoint('CENTER')
	EncounterJournalInstanceSelectScrollDownButton:SetTemplate()
	EncounterJournalInstanceSelectScrollDownButton:Size(18,21)
	
	local function SkinDungeons()
		-- why the fuck button 1 is not named the same as 2+
		local b1 = EncounterJournalInstanceSelectScrollFrameScrollChildInstanceButton1
		if b1 and not b1.isSkinned then 
			b1:CreateBD()
			b1.backdrop:SetBackdropColor(0,0,0,0)
			b1:StyleButton()
			b1.isSkinned = true
			b1.bgImage:SetTexCoord(0.08,.6,0.08,.6)
			b1.bgImage:SetDrawLayer('OVERLAY')
			
			b1:HookScript('OnClick', function()
				EncounterJournalNavBarButton2:Point('LEFT', EncounterJournalNavBarHomeButton, 'RIGHT', 4, 0)
			end)
		end

		for i = 1, 100 do
			local b = _G['EncounterJournalInstanceSelectScrollFrameinstance'..i]
			if b and not b.isSkinned then
				b:CreateBD()
				b.backdrop:SetBackdropColor(0,0,0,0)
				b:StyleButton()
				b.isSkinned = true
				b.bgImage:SetTexCoord(0.08,.6,0.08,.6)
				b.bgImage:SetDrawLayer('OVERLAY')
			end
			
			if b then
				b:HookScript('OnClick', function()
					EncounterJournalNavBarButton2:Point('LEFT', EncounterJournalNavBarHomeButton, 'RIGHT', 4, 0)
				end)
			end
		end
	end
	SkinDungeons()
	hooksecurefunc('EncounterJournal_ListInstances', SkinDungeons)
end

F.SkinFuncs['Blizzard_EncounterJournal'] = LoadSkin
