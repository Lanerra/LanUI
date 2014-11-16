local F, C, G = unpack(select(2, ...))
local bc = C.Media.BorderColor

local function LoadSkin()
	WorldMapFrame.BorderFrame.Inset:StripTextures()
	WorldMapFrame.BorderFrame:StripTextures()
	WorldMapFrameNavBar:StripTextures()
	WorldMapFrameNavBarOverlay:StripTextures()

	WorldMapFrameNavBarHomeButton:StripTextures()
	WorldMapFrameNavBarHomeButton:SetTemplate()
	WorldMapFrameNavBarHomeButton:SetFrameLevel(1)
	WorldMapFrameNavBarHomeButton.text:SetFont(C.Media.Font, C.Media.FontSize)

	SkinDropDownBox(WorldMapLevelDropDown)
	WorldMapLevelDropDown:SetPoint("TOPLEFT", -17, 0)

	WorldMapFrame.BorderFrame:SetTemplate()
	WorldMapFrame.BorderFrame.Inset:CreateBD()
	WorldMapFrame.BorderFrame.Inset.backdrop:SetPoint("TOPLEFT", WorldMapFrame.BorderFrame.Inset, "TOPLEFT", 3, -3)
	WorldMapFrame.BorderFrame.Inset.backdrop:SetPoint("BOTTOMRIGHT", WorldMapFrame.BorderFrame.Inset, "BOTTOMRIGHT", -3, 2)

	SkinScrollBar(QuestScrollFrameScrollBar)
	StyleButton(QuestScrollFrame.ViewAll)

	WorldMapFrameTutorialButton:Kill()

	StyleButton(QuestMapFrame.DetailsFrame.BackButton)
	StyleButton(QuestMapFrame.DetailsFrame.AbandonButton)	
	StyleButton(QuestMapFrame.DetailsFrame.ShareButton, true)	
	StyleButton(QuestMapFrame.DetailsFrame.TrackButton)

	SkinCloseButton(WorldMapFrameCloseButton)
	StyleButton(WorldMapFrameSizeDownButton, true)
	WorldMapFrameSizeDownButton:SetSize(16, 16)
	WorldMapFrameSizeDownButton:SetPoint("RIGHT", WorldMapFrameCloseButton, "LEFT", 4, 0)
	WorldMapFrameSizeDownButton:SetNormalTexture("Interface\\AddOns\\ElvUI\\media\\textures\\vehicleexit")
	WorldMapFrameSizeDownButton:SetPushedTexture("Interface\\AddOns\\ElvUI\\media\\textures\\vehicleexit")
	WorldMapFrameSizeDownButton:SetHighlightTexture("Interface\\AddOns\\ElvUI\\media\\textures\\vehicleexit")

	StyleButton(WorldMapFrameSizeUpButton, true)
	WorldMapFrameSizeUpButton:SetSize(16, 16)
	WorldMapFrameSizeUpButton:SetPoint("RIGHT", WorldMapFrameCloseButton, "LEFT", 4, 0)
	WorldMapFrameSizeUpButton:SetNormalTexture("Interface\\AddOns\\ElvUI\\media\\textures\\vehicleexit")
	WorldMapFrameSizeUpButton:SetPushedTexture("Interface\\AddOns\\ElvUI\\media\\textures\\vehicleexit")
	WorldMapFrameSizeUpButton:SetHighlightTexture("Interface\\AddOns\\ElvUI\\media\\textures\\vehicleexit")
	WorldMapFrameSizeUpButton:GetNormalTexture():SetTexCoord(1, 1, 1, -1.2246467991474e-016, 1.1102230246252e-016, 1, 0, -1.144237745222e-017)
	WorldMapFrameSizeUpButton:GetPushedTexture():SetTexCoord(1, 1, 1, -1.2246467991474e-016, 1.1102230246252e-016, 1, 0, -1.144237745222e-017)
	WorldMapFrameSizeUpButton:GetHighlightTexture():SetTexCoord(1, 1, 1, -1.2246467991474e-016, 1.1102230246252e-016, 1, 0, -1.144237745222e-017)


	local rewardFrames = {
		['MoneyFrame'] = true,
		['XPFrame'] = true,
		['SpellFrame'] = true,
		['SkillPointFrame'] = true, -- this may have extra textures.. need to check on it when possible
	}

	local function HandleReward(frame)
		frame.NameFrame:SetAlpha(0)
		frame.Icon:SetTexCoord(unpack(F.TexCoords))
		frame:CreateBD()
		frame.backdrop:SetOutside(frame.Icon)
		frame.Name:SetFont(C.Media.Font, C.Media.FontSize)
		frame.Count:ClearAllPoints()
		frame.Count:SetPoint("BOTTOMRIGHT", frame.Icon, "BOTTOMRIGHT", 2, 0)
		if(frame.CircleBackground) then
			frame.CircleBackground:SetAlpha(0)
			frame.CircleBackgroundGlow:SetAlpha(0)
		end
	end

	for frame, _ in pairs(rewardFrames) do
		HandleReward(MapQuestInfoRewardsFrame[frame])
	end


	hooksecurefunc('QuestInfo_GetRewardButton', function(rewardsFrame, index)
		local button = MapQuestInfoRewardsFrame.RewardButtons[index]
		if(button) then
			HandleReward(button)
		end
	end)

	SkinNextPrevButton(WorldMapFrame.UIElementsFrame.OpenQuestPanelButton)
	SkinNextPrevButton(WorldMapFrame.UIElementsFrame.CloseQuestPanelButton)
	SquareButton_SetIcon(WorldMapFrame.UIElementsFrame.CloseQuestPanelButton, 'LEFT')
end

tinsert(F.SkinFuncs['LanUI'], LoadSkin)