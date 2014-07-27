local F, C, G = unpack(select(2, ...))
local bc = C.Media.BorderColor

local function LoadSkin()
	PVPUIFrame:StripTextures()
	PVPUIFrame:SetTemplate()
	PVPUIFrame.LeftInset:StripTextures()
	PVPUIFrame.Shadows:StripTextures()

	PVPUIFrameCloseButton:SkinCloseButton()
	
	HonorFrame.RoleInset:StripTextures()
	
	HonorFrame.RoleInset.DPSIcon.checkButton:SkinCheckBox(true)
	HonorFrame.RoleInset.TankIcon.checkButton:SkinCheckBox(true)
	HonorFrame.RoleInset.HealerIcon.checkButton:SkinCheckBox(true)
	HonorFrame.RoleInset.DPSIcon.checkButton:SetFrameStrata('HIGH')
	HonorFrame.RoleInset.TankIcon.checkButton:SetFrameStrata('HIGH')
	HonorFrame.RoleInset.HealerIcon.checkButton:SetFrameStrata('HIGH')

	for i=1, 3 do
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
	HonorFrame.BonusFrame.CallToArmsButton:StripTextures()
	HonorFrame.BonusFrame.CallToArmsButton:SkinButton()
	HonorFrame.BonusFrame.CallToArmsButton.SelectedTexture:ClearAllPoints()
	HonorFrame.BonusFrame.CallToArmsButton.SelectedTexture:SetAllPoints()
	HonorFrame.BonusFrame.CallToArmsButton.SelectedTexture:SetTexture(0, 1, 0, 0.1)
	
	for i = 1, 2 do
		local b = HonorFrame.BonusFrame['WorldPVP'..i..'Button']
		b:StripTextures()
		b:SkinButton()
		b.SelectedTexture:ClearAllPoints()
		b.SelectedTexture:SetAllPoints()
		b.SelectedTexture:SetTexture(0, 1, 0, 0.1)
	end
	
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
	
	ConquestTooltip:SetTemplate()
	ConquestTooltip:SetScale(C.Tweaks.UIScale)
end

F.SkinFuncs['Blizzard_PVPUI'] = LoadSkin