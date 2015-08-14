local F, C, G = unpack(select(2, ...))
local bc = C.Media.BorderColor

-- Currently not working. TODO later

local function LoadSkin()
	TimeManagerFrame:StripTextures()
	TimeManagerFrame:SetTemplate("Transparent")

	HandleCloseButton(TimeManagerFrameCloseButton)
	TimeManagerFrameInset:Kill()
	HandleDropDownBox(TimeManagerAlarmHourDropDown, 80)
	HandleDropDownBox(TimeManagerAlarmMinuteDropDown, 80)
	HandleDropDownBox(TimeManagerAlarmAMPMDropDown, 80)

	HandleEditBox(TimeManagerAlarmMessageEditBox)

	HandleCheckBox(TimeManagerAlarmEnabledButton)

	HandleCheckBox(TimeManagerMilitaryTimeCheck)
	HandleCheckBox(TimeManagerLocalTimeCheck)

	TimeManagerStopwatchFrame:StripTextures()
	TimeManagerStopwatchCheck:SetTemplate("Default")
	TimeManagerStopwatchCheck:GetNormalTexture():SetTexCoord(unpack(E.TexCoords))
	TimeManagerStopwatchCheck:GetNormalTexture():SetInside()
	
	local hover = TimeManagerStopwatchCheck:CreateTexture() -- hover
	hover:SetTexture(1,1,1,0.3)
	hover:Point("TOPLEFT",TimeManagerStopwatchCheck,2,-2)
	hover:Point("BOTTOMRIGHT",TimeManagerStopwatchCheck,-2,2)
	TimeManagerStopwatchCheck:SetHighlightTexture(hover)

	StopwatchFrame:StripTextures()
	StopwatchFrame:CreateBackdrop("Transparent")
	StopwatchFrame.backdrop:Point("TOPLEFT", 0, -17)
	StopwatchFrame.backdrop:Point("BOTTOMRIGHT", 0, 2)

	StopwatchTabFrame:StripTextures()
	HandleCloseButton(StopwatchCloseButton)
	HandleNextPrevButton(StopwatchPlayPauseButton)
	HandleNextPrevButton(StopwatchResetButton)
	StopwatchPlayPauseButton:Point("RIGHT", StopwatchResetButton, "LEFT", -4, 0)
	StopwatchResetButton:Point("BOTTOMRIGHT", StopwatchFrame, "BOTTOMRIGHT", -4, 6)
end

F.SkinFuncs['Blizzard_TimeManager'] = LoadSkin