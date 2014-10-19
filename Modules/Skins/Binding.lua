local F, C, G = unpack(select(2, ...))
local bc = C.Media.BorderColor

local function LoadSkin()
	local buttons = {
		'defaultsButton',
		'unbindButton',
		'okayButton',
		'cancelButton',
	}
	
	for _, v in pairs(buttons) do
		KeyBindingFrame[v]:StripTextures()
		KeyBindingFrame[v]:SkinButton()
	end
	
	KeyBindingFrame.header:StripTextures()
	KeyBindingFrameScrollFrame:StripTextures()
	KeyBindingFrameScrollFrameScrollBar:SkinScrollBar()
	
	KeyBindingFrame.characterSpecificButton:SkinCheckBox()
	KeyBindingFrame.header:ClearAllPoints()
	KeyBindingFrame.header:Point('TOP', KeyBindingFrame, 'TOP', 0, -4)
	KeyBindingFrame:StripTextures()
	KeyBindingFrame:SetTemplate()
	
	KeyBindingFrameCategoryList:StripTextures()
	KeyBindingFrameCategoryList:CreateBD()
	KeyBindingFrame.bindingsContainer:StripTextures()
	KeyBindingFrame.bindingsContainer:CreateBD()
	
	for i = 1, KEY_BINDINGS_DISPLAYED  do
		local button1 = _G['KeyBindingFrameKeyBinding'..i..'Key1Button']
		local button2 = _G['KeyBindingFrameKeyBinding'..i..'Key2Button']
		button1:StripTextures(true)
		button1:StyleButton(false)
		--button1:SetTemplate(true)
		button2:StripTextures(true)
		button2:StyleButton(false)
		--button2:SetTemplate(true)
	end
	
	KeyBindingFrame.okayButton:SetPoint('BOTTOMLEFT', KeyBindingFrame.unbindButton, 'BOTTOMRIGHT', 3, 0)
	KeyBindingFrame.cancelButton:SetPoint('BOTTOMLEFT', KeyBindingFrame.okayButton, 'BOTTOMRIGHT', 3, 0)
	KeyBindingFrame.unbindButton:SetPoint('BOTTOMRIGHT', KeyBindingFrame, 'BOTTOMRIGHT', -211, 16)
end

F.SkinFuncs['Blizzard_BindingUI'] = LoadSkin