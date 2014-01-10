local F, C, G = unpack(select(2, ...))
local bc = C.Media.BorderColor

local function ReforgenatorSkin()
	ReforgenatorPanel:StripTextures()
	ReforgenatorPanel:SetTemplate()
	
	ReforgenatorPanel_CloseButton:SkinCloseButton()
	DropDownList1:StripTextures()
	ReforgenatorMessageFrame:StripTextures()
	ReforgenatorMessageFrame:SetTemplate()
	ReforgenatorMessageTextFrame:StripTextures()
	ReforgenatorMessageTextFrame:Point('CENTER', ReforgenatorMessageFrame)
	ReforgenatorMessageYesButton:SkinButton()
	ReforgenatorMessageYesButton:Point('BOTTOM', ReforgenatorMessageFrame, 0, 2)
	ReforgenatorPortrait:Kill()
	ReforgenatorPanel_ModelSelection:SkinDropDownBox()
	ReforgenatorPanel_SandboxSelection:SkinDropDownBox()
	ReforgenatorPanel_TargetLevelSelection:SkinDropDownBox()
end	
F.SkinFuncs['Reforgenator'] = ReforgenatorSkin

local function WoWProSkin()
	WoWPro.MainFrame:CreateBD()
	WoWPro.MainFrame.backdrop:Point('TOPLEFT', WoWPro.MainFrame, -2, 2)
	WoWPro.MainFrame.backdrop:Point('BOTTOMRIGHT', WoWPro.MainFrame, 2, -2)
	WoWPro.MainFrame.backdrop:SetTemplate(true)
end
F.SkinFuncs['WoWPro'] = WoWProSkin