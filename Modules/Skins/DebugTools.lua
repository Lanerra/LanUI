local F, C, G = unpack(select(2, ...))
local bc = C.Media.BorderColor

local function LoadSkin()
	local noscalemult = F.Mult * GetCVar('uiScale')

	ScriptErrorsFrame:SetParent(UIParent)
	ScriptErrorsFrame:SetTemplate('Transparent')
	HandleScrollBar(ScriptErrorsFrameScrollFrameScrollBar)
	HandleCloseButton(ScriptErrorsFrameClose)
	ScriptErrorsFrameScrollFrameText:FontTemplate(nil, 13)
	ScriptErrorsFrameScrollFrame:CreateBackdrop('Default')
	ScriptErrorsFrameScrollFrame:SetFrameLevel(ScriptErrorsFrameScrollFrame:GetFrameLevel() + 2)
	EventTraceFrame:SetTemplate("Transparent")
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
	  edgeFile = C.Media.Backdrop,
	  tile = false, tileSize = 0, edgeSize = noscalemult,
	  insets = { left = -noscalemult, right = -noscalemult, top = -noscalemult, bottom = -noscalemult}
	}

	for i=1, ScriptErrorsFrame:GetNumChildren() do
		local child = select(i, ScriptErrorsFrame:GetChildren())
		if child:GetObjectType() == "Button" and not child:GetName() then
			HandleButton(child)
		end
	end

	FrameStackTooltip:HookScript("OnShow", function(self)
		local noscalemult = F.Mult * GetCVar('uiScale')
		self:SetBackdrop({
		  bgFile = C.Media.Backdrop,
		  edgeFile = C.Media.Backdrop,
		  tile = false, tileSize = 0, edgeSize = noscalemult,
		  insets = { left = -noscalemult, right = -noscalemult, top = -noscalemult, bottom = -noscalemult}
		})
		self:SetBackdropColor(unpack(C.Media.BackdropFadeColor))
		self:SetBackdropBorderColor(bc.r, bc.g, bc.b)
	end)

	EventTraceTooltip:HookScript("OnShow", function(self)
		self:SetTemplate("Transparent")
	end)

	HandleCloseButton(EventTraceFrameCloseButton)
end

F.SkinFuncs["Blizzard_DebugTools"] = LoadSkin