local F, C, G = unpack(select(2, ...))
local bc = C.Media.BorderColor

local function LoadSkin()
	ItemSocketingFrame:StripTextures()
	ItemSocketingFrame:SetTemplate("Transparent")
	ItemSocketingFrameInset:Kill()
	ItemSocketingScrollFrame:StripTextures()
	ItemSocketingScrollFrame:CreateBackdrop("Transparent")
	HandleScrollBar(ItemSocketingScrollFrameScrollBar, 2)
	for i = 1, MAX_NUM_SOCKETS  do
		local button = _G[("ItemSocketingSocket%d"):format(i)]
		local button_bracket = _G[("ItemSocketingSocket%dBracketFrame"):format(i)]
		local button_bg = _G[("ItemSocketingSocket%dBackground"):format(i)]
		local button_icon = _G[("ItemSocketingSocket%dIconTexture"):format(i)]
		button:StripTextures()
		button:StyleButton(false)
		button:SetTemplate("Default", true)
		button_bracket:Kill()
		button_bg:Kill()
		button_icon:SetTexCoord(unpack(F.TexCoords))
		button_icon:SetInside()
	end

	hooksecurefunc("ItemSocketingFrame_Update", function()
		local numSockets = GetNumSockets();
		for i=1, numSockets do
			local button = _G[("ItemSocketingSocket%d"):format(i)]
			local gemColor = GetSocketTypes(i)
			local color = GEM_TYPE_INFO[gemColor]
			button:SetBackdropColor(color.r, color.g, color.b, 0.15)
			button:SetBackdropBorderColor(color.r, color.g, color.b)
		end
	end)

	ItemSocketingFramePortrait:Kill()
	ItemSocketingSocketButton:ClearAllPoints()
	ItemSocketingSocketButton:Point("BOTTOMRIGHT", ItemSocketingFrame, "BOTTOMRIGHT", -5, 5)
	HandleButton(ItemSocketingSocketButton)
	HandleCloseButton(ItemSocketingFrameCloseButton)
end

F.SkinFuncs['Blizzard_ItemSocketingUI'] = LoadSkin