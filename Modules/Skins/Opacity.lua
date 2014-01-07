local F, C, G = unpack(select(2, ...))
local bc = C.Media.BorderColor

local function LoadSkin()
	OpacityFrame:StripTextures()
	OpacityFrame:SetTemplate()
end

tinsert(F.SkinFuncs['LanUI'], LoadSkin)