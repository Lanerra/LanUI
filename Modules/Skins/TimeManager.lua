local F, C, G = unpack(select(2, ...))
local bc = C.Media.BorderColor

-- Currently not working. TODO later

local function LoadSkin()
	TimeManagerFrame:StripTextures()
	TimeManagerFrame:SetTemplate()
	TimeManagerFrameInset:StripTextures()

	TimeManagerFrameCloseButton:SkinCloseButton()

	TimeManagerAlarmHourDropDown:SkinDropDownBox(80)
	TimeManagerAlarmMinuteDropDown:SkinDropDownBox(80)
	TimeManagerAlarmAMPMDropDown:SkinDropDownBox(80)
	
	TimeManagerAlarmMessageEditBox:SkinEditBox()
	
	TimeManagerAlarmEnabledButton:SkinButton()
	TimeManagerAlarmEnabledButton:Size(16)
	TimeManagerAlarmEnabledButtonText:SetPoint('RIGHT', 76, 0)
	
	TimeManagerMilitaryTimeCheck:SkinCheckBox()
	TimeManagerLocalTimeCheck:SkinCheckBox()
	
	TimeManagerStopwatchFrame:StripTextures()
	TimeManagerStopwatchCheck:SetTemplate()
	TimeManagerStopwatchCheck:GetNormalTexture():SetTexCoord(.08, .92, .08, .92)
	TimeManagerStopwatchCheck:GetNormalTexture():ClearAllPoints()
	TimeManagerStopwatchCheck:GetNormalTexture():Point('TOPLEFT', 2, -2)
	TimeManagerStopwatchCheck:GetNormalTexture():Point('BOTTOMRIGHT', -2, 2)
	TimeManagerStopwatchCheck:StyleButton()
	local hover = TimeManagerStopwatchCheck:CreateTexture('frame', nil, TimeManagerStopwatchCheck) -- hover
	hover:SetTexture(1,1,1,0.3)
	hover:Point('TOPLEFT',TimeManagerStopwatchCheck,2,-2)
	hover:Point('BOTTOMRIGHT',TimeManagerStopwatchCheck,-2,2)
	TimeManagerStopwatchCheck:SetHighlightTexture(hover)
	
	StopwatchFrame:StripTextures()
	StopwatchFrame:CreateBD()
	StopwatchFrame.backdrop:SetTemplate(true)
	StopwatchFrame.backdrop:Point('TOPLEFT', 0, -17)
	StopwatchFrame.backdrop:Point('BOTTOMRIGHT', 0, 2)
	
	StopwatchTabFrame:StripTextures()
	StopwatchCloseButton:SkinCloseButton()
	StopwatchPlayPauseButton:SkinNextPrevButton()
	StopwatchResetButton:SkinNextPrevButton()
	StopwatchPlayPauseButton:Point('RIGHT', StopwatchResetButton, 'LEFT', -4, 0)
	StopwatchResetButton:Point('BOTTOMRIGHT', StopwatchFrame, 'BOTTOMRIGHT', -4, 6)
end

F.SkinFuncs['Blizzard_TimeManager'] = LoadSkin