local F, C, G = unpack(select(2, ...))
local bc = C.Media.BorderColor

local function LoadSkin()
	-- mac menu/option panel, made by affli.
	if IsMacClient() then
		-- Skin main frame and reposition the header
		MovieRecordingOptionsFrameResolutionDropDown:SkinDropDownBox()
		MovieRecordingOptionsFrameFramerateDropDown:SkinDropDownBox()
		MovieRecordingOptionsFrameCodecDropDown:SkinDropDownBox()
		
		MovieRecordingOptionsButtonCompress:SkinButton()
		MovieRecordingOptionsFrameQualitySlider:SkinSlideBar()
		
		for i = 1, 6 do
			_G['MovieRecordingOptionsFrameCheckButton'..i]:SkinCheckBox()
		end
		
		iTunesRemoteOptionsFrameCheckButton7:SkinCheckBox()
		iTunesRemoteOptionsFrameCheckButton8:SkinCheckBox()
		
		MacKeyboardOptionsFrameCheckButton9:SkinCheckBox()
		MacKeyboardOptionsFrameCheckButton10:SkinCheckBox()
		MacKeyboardOptionsFrameCheckButton11:SkinCheckBox()
	end
end

tinsert(F.SkinFuncs['LanUI'], LoadSkin)