local F, C, G = unpack(select(2, ...))
local bc = C.Media.BorderColor

local function LoadSkin()
	-- Glyph Tab
	GlyphFrame:CreateBD()
	GlyphFrame.backdrop:SetTemplate(true)
	GlyphFrame.backdrop:Point('TOPLEFT', GlyphFrame, 'TOPLEFT', 3, 2)
	GlyphFrame.backdrop:Point('BOTTOMRIGHT', GlyphFrame, 'BOTTOMRIGHT', -3, 0)
	GlyphFrameSearchBox:SkinEditBox()
	GlyphFrameFilterDropDown:SkinDropDownBox(212)

	GlyphFrameBackground:SetPoint('TOPLEFT', 5, 0)
	GlyphFrameBackground:SetPoint('BOTTOMRIGHT', -5, 2)

	for i = 1, 6 do
		_G['GlyphFrameGlyph'..i]:SetFrameLevel(_G['GlyphFrameGlyph'..i]:GetFrameLevel() + 5)
	end

	for i = 1, 2 do
		_G['GlyphFrameHeader'..i]:StripTextures()
	end

	local function Glyphs(self, first, i)
		local button = _G['GlyphFrameScrollFrameButton'..i]
		local icon = _G['GlyphFrameScrollFrameButton'..i..'Icon']

		if first then
			button:StripTextures()
		end

		if icon then
			icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			button:SkinButton()
		end
	end

	for i = 1, 10 do
		Glyphs(nil, true, i)
	end

	GlyphFrameClearInfoFrame:SetTemplate()
	GlyphFrameClearInfoFrameIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	GlyphFrameClearInfoFrameIcon:Point('TOPLEFT', 2, -2)
	GlyphFrameClearInfoFrameIcon:Point('BOTTOMRIGHT', -2, 2)

	GlyphFrameLevelOverlay1:SetParent(GlyphFrame.backdrop)
	GlyphFrameLevelOverlayText1:SetParent(GlyphFrame.backdrop)
	GlyphFrameLevelOverlay2:SetParent(GlyphFrame.backdrop)
	GlyphFrameLevelOverlayText2:SetParent(GlyphFrame.backdrop)

	GlyphFrameScrollFrameScrollBar:SkinScrollBar()

	local StripAllTextures = {
		'GlyphFrameScrollFrame',
		'GlyphFrameSideInset',
		'GlyphFrameScrollFrameScrollChild'
	}

	for _, object in pairs(StripAllTextures) do
		_G[object]:StripTextures()
	end
end

F.SkinFuncs['Blizzard_GlyphUI'] = LoadSkin