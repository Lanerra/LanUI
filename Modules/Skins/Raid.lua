local F, C, G = unpack(select(2, ...))
local bc = C.Media.BorderColor

local function LoadSkin()
	local groups = {
		'RaidGroup1',
		'RaidGroup2',
		'RaidGroup3',
		'RaidGroup4',
		'RaidGroup5',
		'RaidGroup6',
		'RaidGroup7',
		'RaidGroup8',
	}

	for _, object in pairs(groups) do
		_G[object]:StripTextures()
	end
	
	for i=1,8 do
		for j=1,5 do
			_G['RaidGroup'..i..'Slot'..j]:StripTextures()
		end
	end
	
	for i=1,40 do
		_G['RaidGroupButton'..i]:StripTextures()
		_G['RaidGroupButton'..i]:SkinButton()
	end
end

F.SkinFuncs['Blizzard_RaidUI'] = LoadSkin

local function LoadSecondarySkin()
	local StripAllTextures = {
		'RaidInfoFrame',
		'RaidInfoInstanceLabel',
		'RaidInfoIDLabel',
	}

	local KillTextures = {
		'RaidInfoScrollFrameScrollBarBG',
		'RaidInfoScrollFrameScrollBarTop',
		'RaidInfoScrollFrameScrollBarBottom',
		'RaidInfoScrollFrameScrollBarMiddle',
	}
	local buttons = {
		'RaidFrameConvertToRaidButton',
		'RaidFrameRaidInfoButton',
		'RaidInfoExtendButton',
		'RaidInfoCancelButton',
		'RaidFrameNotInRaidRaidBrowserButton',
	}

	for _, object in pairs(StripAllTextures) do
		_G[object]:StripTextures()
	end

	for _, texture in pairs(KillTextures) do
		_G[texture]:Kill()
	end

	for i = 1, #buttons do
		if _G[buttons[i]] then _G[buttons[i]]:SkinButton() end
	end
	RaidInfoScrollFrame:StripTextures()
	RaidInfoFrame:CreateBD()
	RaidInfoFrame.backdrop:SetTemplate(true)
	RaidInfoFrame.backdrop:Point( 'TOPLEFT', RaidInfoFrame, 'TOPLEFT')
	RaidInfoFrame.backdrop:Point( 'BOTTOMRIGHT', RaidInfoFrame, 'BOTTOMRIGHT')
	RaidInfoCloseButton:SkinCloseButton(RaidInfoFrame)
	RaidInfoScrollFrameScrollBar:SkinScrollBar()
end

tinsert(F.SkinFuncs['LanUI'], LoadSecondarySkin)