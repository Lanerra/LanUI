local F, C, G = unpack(select(2, ...))
local bc = C.Media.BorderColor

local function LoadSkin()
	QuestFrameGreetingPanel:HookScript("OnShow", function()
		QuestFrameGreetingPanel:StripTextures()
		HandleButton(QuestFrameGreetingGoodbyeButton, true)
		QuestGreetingFrameHorizontalBreak:Kill()
	end)
end

tinsert(F.SkinFuncs['LanUI'], LoadSkin)