local F, C, G = unpack(select(2, ...))
local bc = C.Media.BorderColor

local function LoadSkin()
	ItemTextFrame:StripTextures(true)
	ItemTextFrameInset:StripTextures()
	ItemTextScrollFrame:StripTextures()
	ItemTextFrame:SetTemplate()
	ItemTextScrollFrameScrollBar:SkinScrollBar()
	ItemTextFrameCloseButton:SkinCloseButton()
	ItemTextPrevPageButton:SkinNextPrevButton()
	ItemTextNextPageButton:SkinNextPrevButton()
	ItemTextPageText:SetTextColor(1, 1, 1)
	ItemTextPageText.SetTextColor = F.Dummy
end

tinsert(F.SkinFuncs['LanUI'], LoadSkin)