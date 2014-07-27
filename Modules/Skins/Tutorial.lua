local F, C, G = unpack(select(2, ...))
local bc = C.Media.BorderColor

local function LoadSkin()
	TutorialFrame:StripTextures()
	TutorialFrame:CreateBD(true)
	TutorialFrame.backdrop:Point('TOPLEFT', 6, 0)
	TutorialFrame.backdrop:Point('BOTTOMRIGHT', 6, -6)
	TutorialFrameCloseButton:SkinCloseButton(TutorialFrameCloseButton.backdrop)
	TutorialFramePrevButton:SkinNextPrevButton()
	TutorialFrameNextButton:SkinNextPrevButton()
	TutorialFrameOkayButton:SkinButton()
	TutorialFrameOkayButton:ClearAllPoints()
	TutorialFrameOkayButton:Point('LEFT', TutorialFrameNextButton,'RIGHT', 10, 0)	
end

tinsert(F.SkinFuncs['LanUI'], LoadSkin)