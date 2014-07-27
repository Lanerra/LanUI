local F, C, G = unpack(select(2, ...))
local bc = C.Media.BorderColor

local function LoadSkin()
	GMSurveyHeader:StripTextures()
	GMSurveyFrame:StripTextures()
	GMSurveyFrame:CreateBD(true)
	GMSurveyFrame.backdrop:Point('TOPLEFT', 0, 0)
	GMSurveyFrame.backdrop:Point('BOTTOMRIGHT', -44, 10)

	GMSurveyCommentFrame:StripTextures()
	GMSurveyCommentFrame:SetTemplate()

	GMSurveySubmitButton:SkinButton()
	GMSurveyCancelButton:SkinButton()
	
	
	GMSurveyCloseButton:SkinCloseButton()
	GMSurveyScrollFrame:SkinScrollBar()
	GMSurveyScrollFrameScrollBar:SkinScrollBar()

	for i = 1, 11 do
		_G['GMSurveyQuestion'..i]:StripTextures()
	end
end

F.SkinFuncs['Blizzard_GMSurveyUI'] = LoadSkin