local F, C, G = unpack(select(2, ...))
local bc = C.Media.BorderColor

local function LoadSkin()
	QuestFrameGreetingPanel:StripTextures()
	QuestGreetingScrollFrame:StripTextures()
	QuestFrameGreetingGoodbyeButton:SkinButton(true)
	QuestGreetingFrameHorizontalBreak:Kill()
	GreetingText:SetTextColor(1, 1, 1)
	GreetingText.SetTextColor = F.Dummy
	CurrentQuestsText:SetTextColor(1, 1, 0)
	CurrentQuestsText.SetTextColor = F.Dummy
	AvailableQuestsText:SetTextColor(1, 1, 0)
	AvailableQuestsText.SetTextColor = F.Dummy
	for i = 1, MAX_NUM_QUESTS do
		local button = _G['QuestTitleButton'..i]
		if button then
			hooksecurefunc(button, 'SetFormattedText', function()
				if button:GetFontString() then
					if button:GetFontString():GetText() and button:GetFontString():GetText():find('|cff000000') then
						button:GetFontString():SetText(string.gsub(button:GetFontString():GetText(), '|cff000000', '|cffFFFF00'))
					end
				end
			end)
		end
	end
end

tinsert(F.SkinFuncs['LanUI'], LoadSkin)