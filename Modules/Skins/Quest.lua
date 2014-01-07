local F, C, G = unpack(select(2, ...))
local bc = C.Media.BorderColor

local function LoadSkin()
	QuestFrame:StripTextures(true)
	QuestFrameInset:StripTextures()
	QuestFrameDetailPanel:StripTextures(true)
	QuestDetailScrollFrame:StripTextures(true)
	QuestDetailScrollChildFrame:StripTextures(true)
	QuestRewardScrollFrame:StripTextures(true)
	QuestRewardScrollChildFrame:StripTextures(true)
	QuestFrameProgressPanel:StripTextures(true)
	QuestFrameRewardPanel:StripTextures(true)
	QuestFrame:CreateBD()
	QuestFrameAcceptButton:SkinButton(true)
	QuestFrameDeclineButton:SkinButton(true)
	QuestFrameCompleteButton:SkinButton(true)
	QuestFrameGoodbyeButton:SkinButton(true)
	QuestFrameCompleteQuestButton:SkinButton(true)
	QuestFrameCloseButton:SkinCloseButton(QuestFrame.backdrop)
	QuestLogScrollFrameScrollBar:SkinScrollBar()
	QuestDetailScrollFrameScrollBar:SkinScrollBar()
	QuestRewardScrollFrameScrollBar:SkinScrollBar()

	for i=1, 6 do
		local button = _G['QuestProgressItem'..i]
		local texture = _G['QuestProgressItem'..i..'IconTexture']
		button:StripTextures()
		button:StyleButton()
		button:Width(_G['QuestProgressItem'..i]:GetWidth() - 4)
		button:SetFrameLevel(button:GetFrameLevel() + 2)
		texture:SetTexCoord(.08, .92, .08, .92)
		texture:SetDrawLayer('OVERLAY')
		texture:Point('TOPLEFT', 2, -2)
		texture:Size(texture:GetWidth() - 2, texture:GetHeight() - 2)
		_G['QuestProgressItem'..i..'Count']:SetDrawLayer('OVERLAY')
		button:SetTemplate(true)				
	end

	hooksecurefunc('QuestFrameProgressItems_Update', function()
		QuestProgressTitleText:SetTextColor(1, 1, 0)
		QuestProgressText:SetTextColor(1, 1, 1)
		QuestProgressRequiredItemsText:SetTextColor(1, 1, 0)
		QuestProgressRequiredMoneyText:SetTextColor(1, 1, 0)
	end)
	
	QuestNPCModelTextScrollFrameScrollBar:SkinScrollBar()
	QuestGreetingScrollFrameScrollBar:SkinScrollBar()
	QuestProgressScrollFrameScrollBar:SkinScrollBar()
	QuestProgressScrollFrame:StripTextures()
	QuestNPCModel:StripTextures()
	QuestNPCModel:CreateBD(true)
	QuestNPCModel:Point('TOPLEFT', QuestLogDetailFrame, 'TOPRIGHT', 4, -34)
	QuestNPCModelTextFrame:StripTextures()
	QuestNPCModelTextFrame:CreateBD()
	QuestNPCModelTextFrame.backdrop:SetTemplate()
	QuestNPCModelTextFrame.backdrop:Point('TOPLEFT', QuestNPCModel.backdrop, 'BOTTOMLEFT', 0, -2)
	QuestLogDetailFrame:StripTextures()
	QuestLogDetailFrame:SetTemplate()
	QuestLogDetailScrollFrame:StripTextures()
	QuestLogDetailFrameCloseButton:SkinCloseButton()

	hooksecurefunc('QuestFrame_ShowQuestPortrait', function(parentFrame, portrait, text, name, x, y)
		QuestNPCModel:ClearAllPoints();
		QuestNPCModel:SetPoint('TOPLEFT', parentFrame, 'TOPRIGHT', x + 18, y);			
	end)
end

tinsert(F.SkinFuncs['LanUI'], LoadSkin)