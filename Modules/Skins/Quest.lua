local F, C, G = unpack(select(2, ...))
local bc = C.Media.BorderColor

local function StyleScrollFrame(scrollFrame, widthOverride, heightOverride, inset)
	scrollFrame:SetTemplate()
	scrollFrame.spellTex = scrollFrame:CreateTexture(nil, 'ARTWORK')
	scrollFrame.spellTex:SetTexture([[Interface\QuestFrame\QuestBG]])
	if inset then
		scrollFrame.spellTex:SetPoint("TOPLEFT", 2, -2)
	else
		scrollFrame.spellTex:SetPoint("TOPLEFT")
	end
	scrollFrame.spellTex:Size(widthOverride or 506, heightOverride or 615)
	scrollFrame.spellTex:SetTexCoord(0, 1, 0.02, 1)
end

local function LoadSkin()
	HandleScrollBar(QuestProgressScrollFrameScrollBar)
	HandleScrollBar(QuestRewardScrollFrameScrollBar)


	HandleScrollBar(QuestDetailScrollFrameScrollBar)
	QuestProgressScrollFrame:StripTextures()

	QuestGreetingScrollFrame:StripTextures()
	HandleScrollBar(QuestGreetingScrollFrameScrollBar)


	QuestInfoSkillPointFrame:StripTextures()
	QuestInfoSkillPointFrame:StyleButton()
	QuestInfoSkillPointFrame:Width(QuestInfoSkillPointFrame:GetWidth() - 4)
	QuestInfoSkillPointFrame:SetFrameLevel(QuestInfoSkillPointFrame:GetFrameLevel() + 2)
	QuestInfoSkillPointFrameIconTexture:SetTexCoord(unpack(F.TexCoords))
	QuestInfoSkillPointFrameIconTexture:SetDrawLayer("OVERLAY")
	QuestInfoSkillPointFrameIconTexture:Point("TOPLEFT", 2, -2)
	QuestInfoSkillPointFrameIconTexture:Size(QuestInfoSkillPointFrameIconTexture:GetWidth() - 2, QuestInfoSkillPointFrameIconTexture:GetHeight() - 2)
	QuestInfoSkillPointFrame:SetTemplate("Default")
	QuestInfoSkillPointFrameCount:SetDrawLayer("OVERLAY")

	QuestInfoItemHighlight:StripTextures()
	QuestInfoItemHighlight:SetTemplate("Default", nil, true)
	QuestInfoItemHighlight:SetBackdropBorderColor(1, 1, 0)
	QuestInfoItemHighlight:SetBackdropColor(0, 0, 0, 0)
	QuestInfoItemHighlight.backdropTexture:SetAlpha(0)
	QuestInfoItemHighlight:Size(142, 40)

	hooksecurefunc("QuestInfoItem_OnClick", function(self)
		QuestInfoItemHighlight:ClearAllPoints()
		QuestInfoItemHighlight:SetOutside(self.Icon)

		self.Name:SetTextColor(1, 1, 0)

		local parent = self:GetParent()
		for i=1, #parent.RewardButtons do
			local questItem = QuestInfoRewardsFrame.RewardButtons[i]
			if(questItem ~= self) then
				questItem.Name:SetTextColor(1, 1, 1)
			end
		end
	end)

	QuestRewardScrollFrame:HookScript('OnShow', function(self)
		if not self.backdrop then
			self:CreateBackdrop("Default")
			StyleScrollFrame(self, 509, 630, false)
			self:Height(self:GetHeight() - 2)
		end
		self.spellTex:Height(self:GetHeight() + 217)
	end)

	hooksecurefunc("QuestInfo_Display", function(template, parentFrame)
	  for i = 1, #QuestInfoRewardsFrame.RewardButtons do
		local questItem = QuestInfoRewardsFrame.RewardButtons[i]
		if not questItem:IsShown() then break end

		local point, relativeTo, relativePoint, x, y = questItem:GetPoint()
		if point and relativeTo and relativePoint then
			if i == 1 then
			    questItem:Point(point, relativeTo, relativePoint, 0, y)
			elseif relativePoint == "BOTTOMLEFT" then
			    questItem:Point(point, relativeTo, relativePoint, 0, -4)
			else
			    questItem:Point(point, relativeTo, relativePoint, 4, 0)
			end
		end

		questItem.Name:SetTextColor(1, 1, 1)
	  end
    end)

    hooksecurefunc("QuestInfo_GetRewardButton", function(rewardsFrame, index)
    	local rewardButton = rewardsFrame.RewardButtons[index];
    	if(not rewardButton.skinned) then
    		rewardButton.NameFrame:Hide()
    		rewardButton.Icon:SetTexCoord(unpack(F.TexCoords))
    		rewardButton:CreateBackdrop("Default")
    		rewardButton.backdrop:SetOutside(rewardButton.Icon)
    		rewardButton.Icon:SetDrawLayer("OVERLAY")
    		rewardButton.Count:SetDrawLayer("OVERLAY")
    	end
    end)


	--Quest Frame
	QuestFrame:StripTextures(true)
	QuestFrameInset:Kill()
	QuestFrameDetailPanel:StripTextures(true)
	QuestDetailScrollFrame:StripTextures(true)
	QuestDetailScrollFrame:SetTemplate()
	StyleScrollFrame(QuestDetailScrollFrame, 506, 615, true)

	QuestProgressScrollFrame:SetTemplate()
	StyleScrollFrame(QuestProgressScrollFrame, 506, 615, true)

	QuestGreetingScrollFrame:SetTemplate()
	StyleScrollFrame(QuestGreetingScrollFrame, 506, 615, true)

	QuestDetailScrollChildFrame:StripTextures(true)
	QuestRewardScrollFrame:StripTextures(true)
	QuestRewardScrollChildFrame:StripTextures(true)
	QuestFrameProgressPanel:StripTextures(true)
	QuestFrameRewardPanel:StripTextures(true)
	QuestFrame:CreateBackdrop("Transparent")
	HandleButton(QuestFrameAcceptButton, true)
	HandleButton(QuestFrameDeclineButton, true)
	HandleButton(QuestFrameCompleteButton, true)
	HandleButton(QuestFrameGoodbyeButton, true)
	HandleButton(QuestFrameCompleteQuestButton, true)
	HandleCloseButton(QuestFrameCloseButton, QuestFrame.backdrop)

	for i=1, 6 do
		local button = _G["QuestProgressItem"..i]
		local texture = _G["QuestProgressItem"..i.."IconTexture"]
		button:StripTextures()
		button:StyleButton()
		button:Width(_G["QuestProgressItem"..i]:GetWidth() - 4)
		button:SetFrameLevel(button:GetFrameLevel() + 2)
		texture:SetTexCoord(unpack(F.TexCoords))
		texture:SetDrawLayer("OVERLAY")
		texture:Point("TOPLEFT", 2, -2)
		texture:Size(texture:GetWidth() - 2, texture:GetHeight() - 2)
		_G["QuestProgressItem"..i.."Count"]:SetDrawLayer("OVERLAY")
		button:SetTemplate("Default")
	end

	QuestNPCModel:StripTextures()
	QuestNPCModel:CreateBackdrop("Transparent")
	QuestNPCModel:Point("TOPLEFT", QuestLogDetailFrame, "TOPRIGHT", 4, -34)
	QuestNPCModelTextFrame:StripTextures()
	QuestNPCModelTextFrame:CreateBackdrop("Default")
	QuestNPCModelTextFrame.backdrop:Point("TOPLEFT", QuestNPCModel.backdrop, "BOTTOMLEFT", 0, -2)
	--QuestLogDetailFrame:StripTextures()
	--QuestLogDetailFrame:SetTemplate("Transparent")
	--QuestLogDetailScrollFrame:StripTextures()
	--HandleCloseButton(QuestLogDetailFrameCloseButton)

	hooksecurefunc("QuestFrame_ShowQuestPortrait", function(parentFrame, portrait, text, name, x, y)
		QuestNPCModel:ClearAllPoints();
		QuestNPCModel:SetPoint("TOPLEFT", parentFrame, "TOPRIGHT", x + 18, y);
	end)

	QuestLogPopupDetailFrame:StripTextures()
	QuestLogPopupDetailFrameInset:StripTextures()
	HandleButton(QuestLogPopupDetailFrameAbandonButton)
	HandleButton(QuestLogPopupDetailFrameShareButton)
	HandleButton(QuestLogPopupDetailFrameTrackButton)
	QuestLogPopupDetailFrameScrollFrame:StripTextures()
	HandleScrollBar(QuestLogPopupDetailFrameScrollFrameScrollBar)
	QuestLogPopupDetailFrame:SetTemplate("Transparent")

	QuestLogPopupDetailFrameScrollFrame:HookScript('OnShow', function(self)
		if not QuestLogPopupDetailFrameScrollFrame.backdrop then
			QuestLogPopupDetailFrameScrollFrame:CreateBackdrop("Default")
			StyleScrollFrame(QuestLogPopupDetailFrameScrollFrame, 509, 630, false)
			QuestLogPopupDetailFrameScrollFrame:Height(self:GetHeight() - 2)
		end
		QuestLogPopupDetailFrameScrollFrame.spellTex:Height(self:GetHeight() + 217)
	end)

	HandleCloseButton(QuestLogPopupDetailFrameCloseButton)

	QuestLogPopupDetailFrame.ShowMapButton:StripTextures()
	HandleButton(QuestLogPopupDetailFrame.ShowMapButton)
	QuestLogPopupDetailFrame.ShowMapButton.Text:ClearAllPoints()
	QuestLogPopupDetailFrame.ShowMapButton.Text:SetPoint("CENTER")
	QuestLogPopupDetailFrame.ShowMapButton:Size(QuestLogPopupDetailFrame.ShowMapButton:GetWidth() - 30, QuestLogPopupDetailFrame.ShowMapButton:GetHeight(), - 40)
end

tinsert(F.SkinFuncs['LanUI'], LoadSkin)

local function LoadSecondarySkin()
    for i = 1, 2 do
        local option = QuestChoiceFrame["Option"..i]
        local rewards = option.Rewards
        local icon = rewards.Item.Icon
        local currencies = rewards.Currencies

		HandleIcon(icon)

        for j = 1, 3 do
            local cu = currencies["Currency"..j]
			HandleIcon(cu.Icon)
        end
    end

	QuestChoiceFrame:CreateBackdrop("Transparent")
    HandleButton(QuestChoiceFrame.Option1.OptionButton)
    HandleButton(QuestChoiceFrame.Option2.OptionButton)
    HandleCloseButton(QuestChoiceFrame.CloseButton)
	QuestChoiceFrame.CloseButton:SetFrameLevel(10)
end

F.SkinFuncs['Blizzard_QuestChoice'] = LoadSecondarySkin