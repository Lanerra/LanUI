local F, C, G = unpack(select(2, ...))
local bc = C.Media.BorderColor

ColorPickerFrame:SetParent(nil)
ColorPickerFrame:SetScale(C.Tweaks.UIScale)

local function LoadSkin()
	ColorPickerFrame:SetTemplate()
	ColorPickerOkayButton:SkinButton()
	ColorPickerCancelButton:SkinButton()
	ColorPickerOkayButton:ClearAllPoints()
	ColorPickerOkayButton:Point('RIGHT', ColorPickerCancelButton,'LEFT', -2, 0)
	ColorPickerFrameHeader:ClearAllPoints()
end

tinsert(F.SkinFuncs['LanUI'], LoadSkin)