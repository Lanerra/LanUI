local F, C, G = unpack(select(2, ...))
local bc = C.Media.BorderColor

local function LoadSkin()
	-- always scale it at the same value as UIParent
	ScriptErrorsFrame:SetParent(UIParent)
	
	local noscalemult = F.Mult * C.Tweaks.UIScale
	local bg = {
	  bgFile = C.Media.Backdrop,
	  insets = { left = -noscalemult, right = -noscalemult, top = -noscalemult, bottom = -noscalemult}
	}
	
	ScriptErrorsFrame:SetBackdrop(bg)
	ScriptErrorsFrame:SetBackdropColor(unpack(C.Media.BackdropColor))
	ScriptErrorsFrame:SetBackdropBorderColor(bc.r, bc.g, bc.b)

	EventTraceFrame:SetTemplate()
	
	local texs = {
		"TopLeft",
		"TopRight",
		"Top",
		"BottomLeft",
		"BottomRight",
		"Bottom",
		"Left",
		"Right",
		"TitleBG",
		"DialogBG",
	}
	
	for i=1, #texs do
		_G["ScriptErrorsFrame"..texs[i]]:SetTexture(nil)
		_G["EventTraceFrame"..texs[i]]:SetTexture(nil)
	end
	
	local bg = {
	  bgFile = C.Media.Backdrop, 
	  insets = { left = -noscalemult, right = -noscalemult, top = -noscalemult, bottom = -noscalemult}
	}
	
	for i=1, ScriptErrorsFrame:GetNumChildren() do
		local child = select(i, ScriptErrorsFrame:GetChildren())
		if child:GetObjectType() == "Button" and not child:GetName() then
			
			child:SkinButton()
			child:SetBackdrop(bg)
			child:SetBackdropColor(unpack(C.Media.BackdropColor))
			child:SetBackdropBorderColor(bc.r, bc.g, bc.b)	
		end
	end
	
	ScriptErrorsFrameClose:SkinCloseButton()
	ScriptErrorsFrameScrollFrameScrollBar:SkinScrollBar()
	EventTraceFrameScrollBG:SetTexture(nil)
	ScriptErrorsFrameScrollFrameScrollBar:ClearAllPoints()
	ScriptErrorsFrameScrollFrameScrollBar:SetPoint("TOPRIGHT", 50, 14)
	ScriptErrorsFrameScrollFrameScrollBar:SetPoint("BOTTOMRIGHT", 50, -20)
	EventTraceFrameCloseButton:SkinCloseButton()
end

F.SkinFuncs["Blizzard_DebugTools"] = LoadSkin