local F, C, G = unpack(select(2, ...))
local bc = C.Media.BorderColor

local function LoadSkin()
	EncounterJournal:StripTextures(true)
	EncounterJournal:CreateBackdrop('Transparent')

	EncounterJournalNavBar:StripTextures(true)
	EncounterJournalNavBarOverlay:StripTextures(true)

	EncounterJournalNavBar:CreateBackdrop("Default")
	EncounterJournalNavBar.backdrop:Point("TOPLEFT", -2, 0)
	EncounterJournalNavBar.backdrop:SetPoint("BOTTOMRIGHT")
	HandleButton(EncounterJournalNavBarHomeButton, true)

	HandleEditBox(EncounterJournalSearchBox)
	HandleCloseButton(EncounterJournalCloseButton)
	HandleDropDownBox(EncounterJournalInstanceSelectTierDropDown)

	EncounterJournalInset:StripTextures(true)
	
	EncounterJournalInstanceSelect:CreateBackdrop('Default')
	EncounterJournalEncounterFrameInfo:CreateBackdrop('Default')

	HandleScrollBar(EncounterJournalInstanceSelectScrollFrameScrollBar, 4)
	HandleScrollBar(EncounterJournalEncounterFrameInfoDetailsScrollFrameScrollBar, 4)
	HandleScrollBar(EncounterJournalEncounterFrameInfoLootScrollFrameScrollBar, 4)
	HandleScrollBar(EncounterJournalEncounterFrameInstanceFrameLoreScrollFrameScrollBar, 4)
	HandleScrollBar(EncounterJournalEncounterFrameInfoBossesScrollFrameScrollBar, 4)

	EncounterJournalEncounterFrameInfoBossTab:GetNormalTexture():SetTexture(nil)
	EncounterJournalEncounterFrameInfoBossTab:GetPushedTexture():SetTexture(nil)
	EncounterJournalEncounterFrameInfoBossTab:GetDisabledTexture():SetTexture(nil)
	EncounterJournalEncounterFrameInfoBossTab:GetHighlightTexture():SetTexture(nil)

	EncounterJournalEncounterFrameInfoLootTab:GetNormalTexture():SetTexture(nil)
	EncounterJournalEncounterFrameInfoLootTab:GetPushedTexture():SetTexture(nil)
	EncounterJournalEncounterFrameInfoLootTab:GetDisabledTexture():SetTexture(nil)
	EncounterJournalEncounterFrameInfoLootTab:GetHighlightTexture():SetTexture(nil)

	EncounterJournalEncounterFrameInfoModelTab:GetNormalTexture():SetTexture(nil)
	EncounterJournalEncounterFrameInfoModelTab:GetPushedTexture():SetTexture(nil)
	EncounterJournalEncounterFrameInfoModelTab:GetDisabledTexture():SetTexture(nil)
	EncounterJournalEncounterFrameInfoModelTab:GetHighlightTexture():SetTexture(nil)

	EncounterJournalEncounterFrameInfoOverviewTab:GetNormalTexture():SetTexture(nil)
	EncounterJournalEncounterFrameInfoOverviewTab:GetPushedTexture():SetTexture(nil)
	EncounterJournalEncounterFrameInfoOverviewTab:GetDisabledTexture():SetTexture(nil)
	EncounterJournalEncounterFrameInfoOverviewTab:GetHighlightTexture():SetTexture(nil)

	EncounterJournalEncounterFrameInfoOverviewTab:Point('TOPLEFT', EncounterJournalEncounterFrameInfo, 'TOPRIGHT', C.Media.PixelPerfect and -3 or 0, -35)
	EncounterJournalEncounterFrameInfoOverviewTab.SetPoint = F.Dummy

	EncounterJournalEncounterFrameInfoBossTab:CreateBackdrop('Default')
	EncounterJournalEncounterFrameInfoBossTab.backdrop:Point('TOPLEFT', 11, -8)
	EncounterJournalEncounterFrameInfoBossTab.backdrop:Point('BOTTOMRIGHT', -6, 8)
	EncounterJournalEncounterFrameInfoLootTab:CreateBackdrop('Default')
	EncounterJournalEncounterFrameInfoLootTab.backdrop:Point('TOPLEFT', 11, -8)
	EncounterJournalEncounterFrameInfoLootTab.backdrop:Point('BOTTOMRIGHT', -6, 8)
	EncounterJournalEncounterFrameInfoModelTab:CreateBackdrop('Default')
	EncounterJournalEncounterFrameInfoModelTab.backdrop:Point('TOPLEFT', 11, -8)
	EncounterJournalEncounterFrameInfoModelTab.backdrop:Point('BOTTOMRIGHT', -6, 8)
	EncounterJournalEncounterFrameInfoOverviewTab:CreateBackdrop('Default')
	EncounterJournalEncounterFrameInfoOverviewTab.backdrop:Point('TOPLEFT', 11, -8)
	EncounterJournalEncounterFrameInfoOverviewTab.backdrop:Point('BOTTOMRIGHT', -6, 8)

	EncounterJournalEncounterFrameInfoBossTab.backdrop.backdropTexture:SetVertexColor(189/255, 159/255, 88/255)
	EncounterJournalEncounterFrameInfoLootTab.backdrop.backdropTexture:SetVertexColor(189/255, 159/255, 88/255)
	EncounterJournalEncounterFrameInfoModelTab.backdrop.backdropTexture:SetVertexColor(189/255, 159/255, 88/255)
	EncounterJournalEncounterFrameInfoOverviewTab.backdrop.backdropTexture:SetVertexColor(189/255, 159/255, 88/255)
	
	--Suggestions
	for i = 1, AJ_MAX_NUM_SUGGESTIONS do
		local suggestion = EncounterJournal.suggestFrame["Suggestion"..i];

		if i == 1 then
			HandleButton(suggestion.button)
			HandleNextPrevButton(suggestion.prevButton)
			HandleNextPrevButton(suggestion.nextButton)
		else
			HandleButton(suggestion.centerDisplay.button)
		end
	end

	--Suggestion Reward Tooltips

	local tooltip = EncounterJournalTooltip
	local item1 = tooltip.Item1
	local item2 = tooltip.Item2

	EncounterJournalTooltip:SetTemplate("Transparent")
	HandleIcon(item1.icon)
	HandleIcon(item2.icon)
	item1.IconBorder:SetTexture(nil)
	item2.IconBorder:SetTexture(nil)
end

F.SkinFuncs['Blizzard_EncounterJournal'] = LoadSkin
