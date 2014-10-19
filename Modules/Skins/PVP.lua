local F, C, G = unpack(select(2, ...))
local bc = C.Media.BorderColor

local function LoadSkin()
	PVPUIFrame:StripTextures()
	--PVPUIFrame.Shadows:StripTextures()

	HonorFrame.RoleInset:StripTextures()
	
	HonorFrame.RoleInset.DPSIcon.checkButton:SkinCheckBox(true)
	HonorFrame.RoleInset.TankIcon.checkButton:SkinCheckBox(true)
	HonorFrame.RoleInset.HealerIcon.checkButton:SkinCheckBox(true)
	HonorFrame.RoleInset.DPSIcon.checkButton:SetFrameStrata('HIGH')
	HonorFrame.RoleInset.TankIcon.checkButton:SetFrameStrata('HIGH')
	HonorFrame.RoleInset.HealerIcon.checkButton:SetFrameStrata('HIGH')

	for i=1, 4 do
		local button = _G['PVPQueueFrameCategoryButton'..i]
		button.Background:Kill()
		button.Ring:Kill()
		button.Icon:Size(45)
		button.Icon:SetTexCoord(.15, .85, .15, .85)
		button:CreateBD()
		button.backdrop:SetOutside(button.Icon, 3)
		button.backdrop:SetFrameLevel(button:GetFrameLevel())
		button.Icon:SetParent(button.backdrop)
		button:SetBackdrop({
			bgFile = C.Media.Backdrop,
			edgeFile = C.Media.Backdrop,
			edgeSize = F.Mult,
		})
		button:SetBackdropColor(unpack(C.Media.BackdropColor))
		button:SetBackdropBorderColor(C.Media.BorderColor.r, C.Media.BorderColor.g, C.Media.BorderColor.b)
		button:StyleButton()
	end
	
	-->>>HONOR FRAME
	HonorFrameTypeDropDown:SkinDropDownBox()

	HonorFrame.Inset:StripTextures()

	HonorFrameSpecificFrameScrollBar:SkinScrollBar()
	HonorFrameSoloQueueButton:SkinButton(true)
	HonorFrameGroupQueueButton:SkinButton(true)
	HonorFrame.BonusFrame:StripTextures()
	HonorFrame.BonusFrame.ShadowOverlay:StripTextures()
	HonorFrame.BonusFrame.RandomBGButton:StripTextures()
	HonorFrame.BonusFrame.RandomBGButton:SkinButton()
	HonorFrame.BonusFrame.RandomBGButton.SelectedTexture:ClearAllPoints()
	HonorFrame.BonusFrame.RandomBGButton.SelectedTexture:SetAllPoints()
	HonorFrame.BonusFrame.RandomBGButton.SelectedTexture:SetTexture(0, 1, 0, 0.1)
	
	HonorFrame.BonusFrame.Arena1Button:StripTextures()
	HonorFrame.BonusFrame.Arena1Button:SetTemplate()
	HonorFrame.BonusFrame.Arena1Button:StyleButton()
	HonorFrame.BonusFrame.Arena1Button.SelectedTexture:SetInside()
	HonorFrame.BonusFrame.Arena1Button.SelectedTexture:SetTexture(1, 1, 0, 0.1)	

	HonorFrame.BonusFrame.Arena2Button:StripTextures()
	HonorFrame.BonusFrame.Arena2Button:SetTemplate()
	HonorFrame.BonusFrame.Arena2Button:StyleButton()
	HonorFrame.BonusFrame.Arena2Button.SelectedTexture:SetInside()
	HonorFrame.BonusFrame.Arena2Button.SelectedTexture:SetTexture(1, 1, 0, 0.1)
	
	-->>>CONQUEST FRAME
	ConquestFrame.Inset:StripTextures()

	ConquestPointsBarLeft:Kill()
	ConquestPointsBarRight:Kill()
	ConquestPointsBarMiddle:Kill()
	ConquestPointsBarBG:Kill()
	ConquestPointsBarShadow:Kill()
	ConquestPointsBar.progress:SetTexture(C.Media.StatusBar)
	ConquestPointsBar:CreateBD(true)
	ConquestPointsBar.backdrop:SetOutside(ConquestPointsBar, nil, -F.Mult)
	ConquestFrame:StripTextures()
	ConquestFrame.ShadowOverlay:StripTextures()
	ConquestFrame.RatedBG:StripTextures()
	ConquestFrame.RatedBG:SkinButton()
	ConquestFrame.RatedBG.SelectedTexture:ClearAllPoints()
	ConquestFrame.RatedBG.SelectedTexture:SetAllPoints()
	ConquestFrame.RatedBG.SelectedTexture:SetTexture(0, 1, 0, 0.1)	
	ConquestJoinButton:SkinButton(true)

	-->>>WARGRAMES FRAME
	WarGamesFrame:StripTextures()
	WarGamesFrame.RightInset:StripTextures()
	WarGameStartButton:SkinButton(true)
	WarGamesFrameScrollFrameScrollBar:SkinScrollBar()
	WarGamesFrame.HorizontalBar:StripTextures()

	-->>>ARENATEAMS
	ConquestFrame.Arena2v2:StripTextures()
	ConquestFrame.Arena2v2:SkinButton()
	ConquestFrame.Arena2v2.SelectedTexture:ClearAllPoints()
	ConquestFrame.Arena2v2.SelectedTexture:SetAllPoints()
	ConquestFrame.Arena2v2.SelectedTexture:SetTexture(0, 1, 0, 0.1)
	ConquestFrame.Arena2v2.SelectedTexture:ClearAllPoints()
	ConquestFrame.Arena2v2.SelectedTexture:SetAllPoints()
	ConquestFrame.Arena2v2.SelectedTexture:SetTexture(0, 1, 0, 0.1)	
	
	ConquestFrame.Arena3v3:StripTextures()
	ConquestFrame.Arena3v3:SkinButton()
	ConquestFrame.Arena3v3.SelectedTexture:ClearAllPoints()
	ConquestFrame.Arena3v3.SelectedTexture:SetAllPoints()
	ConquestFrame.Arena3v3.SelectedTexture:SetTexture(0, 1, 0, 0.1)
	ConquestFrame.Arena3v3.SelectedTexture:ClearAllPoints()
	ConquestFrame.Arena3v3.SelectedTexture:SetAllPoints()
	ConquestFrame.Arena3v3.SelectedTexture:SetTexture(0, 1, 0, 0.1)	

	ConquestFrame.Arena5v5:StripTextures()
	ConquestFrame.Arena5v5:SkinButton()
	ConquestFrame.Arena5v5.SelectedTexture:ClearAllPoints()
	ConquestFrame.Arena5v5.SelectedTexture:SetAllPoints()
	ConquestFrame.Arena5v5.SelectedTexture:SetTexture(0, 1, 0, 0.1)
	ConquestFrame.Arena5v5.SelectedTexture:ClearAllPoints()
	ConquestFrame.Arena5v5.SelectedTexture:SetAllPoints()
	ConquestFrame.Arena5v5.SelectedTexture:SetTexture(0, 1, 0, 0.1)
	SkinCheckBox(WarGameTournamentModeCheckButton)
	
	ConquestTooltip:SetTemplate()
	ConquestTooltip:SetScale(C.Tweaks.UIScale)
end

F.SkinFuncs['Blizzard_PVPUI'] = LoadSkin