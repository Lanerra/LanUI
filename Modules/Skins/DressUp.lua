local F, C, G = unpack(select(2, ...))
local bc = C.Media.BorderColor

local function LoadSkin()
	DressUpFrame:StripTextures(true)
	DressUpFrame:CreateBackdrop("Transparent")
	DressUpFrame.backdrop:Point("TOPLEFT", 6, 0)
	DressUpFrame.backdrop:Point("BOTTOMRIGHT", -32, 70)

	HandleButton(DressUpFrameResetButton)
	HandleButton(DressUpFrameCancelButton)
	HandleCloseButton(DressUpFrameCloseButton, DressUpFrame.backdrop)

	DressUpFrameResetButton:Point("RIGHT", DressUpFrameCancelButton, "LEFT", -2, 0)
end

tinsert(F.SkinFuncs['LanUI'], LoadSkin)