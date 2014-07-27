local F, C, G = unpack(select(2, ...))
local bc = C.Media.BorderColor

local function LoadSkin()
	TaxiFrame:StripTextures()
	TaxiFrame.TitleText:SetAlpha(0)
	TaxiRouteMap:CreateBD(true)
	TaxiFrame.CloseButton:SkinCloseButton()
	TaxiFrame.CloseButton:ClearAllPoints()
	TaxiFrame.CloseButton:SetPoint('TOPRIGHT', 0, -20)
end

tinsert(F.SkinFuncs['LanUI'], LoadSkin)