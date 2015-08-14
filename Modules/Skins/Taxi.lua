local F, C, G = unpack(select(2, ...))
local bc = C.Media.BorderColor

local function LoadSkin()
	TaxiFrame:StripTextures()
	TaxiFrame:CreateBackdrop("Transparent")
	TaxiRouteMap:CreateBackdrop("Default")
	TaxiRouteMap.backdrop.backdropTexture:Hide()

	HandleCloseButton(TaxiFrame.CloseButton)
end

tinsert(F.SkinFuncs['LanUI'], LoadSkin)