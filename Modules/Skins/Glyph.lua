local F, C, G = unpack(select(2, ...))
local bc = C.Media.BorderColor

local function LoadSkin()
	GlyphFrame.background:ClearAllPoints()
	GlyphFrame.background:SetAllPoints(PlayerTalentFrameInset)

	GlyphFrame:HookScript('OnShow', function()
		PlayerTalentFrameInset.backdrop:Show()
	end)

	GlyphFrame:HookScript('OnHide', function()
		PlayerTalentFrameInset.backdrop:Hide()
	end)

	GlyphFrameSideInset:StripTextures()

	GlyphFrameClearInfoFrame:CreateBackdrop('Default')
	GlyphFrameClearInfoFrame.icon:SetTexCoord(unpack(F.TexCoords))
	GlyphFrameClearInfoFrame:Width(GlyphFrameClearInfoFrame:GetWidth() - 2)
	GlyphFrameClearInfoFrame:Height(GlyphFrameClearInfoFrame:GetHeight() - 2)
	GlyphFrameClearInfoFrame.icon:Size(GlyphFrameClearInfoFrame:GetSize())
	GlyphFrameClearInfoFrame:Point('TOPLEFT', GlyphFrame, 'BOTTOMLEFT', 6, -10)

	HandleDropDownBox(GlyphFrameFilterDropDown, 212)
	HandleEditBox(GlyphFrameSearchBox)
	HandleScrollBar(GlyphFrameScrollFrameScrollBar, 5)

	for i=1, 10 do
		local button = _G["GlyphFrameScrollFrameButton"..i]
		local icon = _G["GlyphFrameScrollFrameButton"..i.."Icon"]

		button:StripTextures()
		HandleButton(button)
		icon:SetTexCoord(unpack(F.TexCoords))
	end

	GlyphFrameHeader1:StripTextures()
	GlyphFrameHeader2:StripTextures()
end

F.SkinFuncs['Blizzard_GlyphUI'] = LoadSkin