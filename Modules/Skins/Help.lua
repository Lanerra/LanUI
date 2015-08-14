local F, C, G = unpack(select(2, ...))
local bc = C.Media.BorderColor

local function LoadSkin()
	local frames = {
		"HelpFrameLeftInset",
		"HelpFrameMainInset",
		"HelpFrameKnowledgebase",
		"HelpFrameHeader",
		"HelpFrameKnowledgebaseErrorFrame",
	}

	local buttons = {
		--"HelpFrameOpenTicketHelpItemRestoration",
		"HelpFrameAccountSecurityOpenTicket",
		--"HelpFrameOpenTicketHelpTopIssues",
		"HelpFrameOpenTicketHelpOpenTicket",
		"HelpFrameKnowledgebaseSearchButton",
		"HelpFrameKnowledgebaseNavBarHomeButton",
		"HelpFrameCharacterStuckStuck",
		--"GMChatOpenLog",
		"HelpFrameTicketSubmit",
		"HelpFrameTicketCancel",
	}

	-- 4.3.4 patch
	if F.Build >= 15595 then
		tinsert(buttons, "HelpFrameButton16")
		tinsert(buttons, "HelpFrameSubmitSuggestionSubmit")
		tinsert(buttons, "HelpFrameReportBugSubmit")
	end

	-- skin main frames
	for i = 1, #frames do
		_G[frames[i]]:StripTextures(true)
		_G[frames[i]]:CreateBackdrop("Transparent")
	end

	HelpFrameHeader:SetFrameLevel(HelpFrameHeader:GetFrameLevel() + 2)
	HelpFrameKnowledgebaseErrorFrame:SetFrameLevel(HelpFrameKnowledgebaseErrorFrame:GetFrameLevel() + 2)

	HelpFrameReportBugScrollFrame:StripTextures()
	HelpFrameReportBugScrollFrame:CreateBackdrop("Transparent")
	HelpFrameReportBugScrollFrame.backdrop:Point("TOPLEFT", -4, 4)
	HelpFrameReportBugScrollFrame.backdrop:Point("BOTTOMRIGHT", 6, -4)
	for i=1, HelpFrameReportBug:GetNumChildren() do
		local child = select(i, HelpFrameReportBug:GetChildren())
		if not child:GetName() then
			child:StripTextures()
		end
	end

	HandleScrollBar(HelpFrameReportBugScrollFrameScrollBar)

	HelpFrameSubmitSuggestionScrollFrame:StripTextures()
	HelpFrameSubmitSuggestionScrollFrame:CreateBackdrop("Transparent")
	HelpFrameSubmitSuggestionScrollFrame.backdrop:Point("TOPLEFT", -4, 4)
	HelpFrameSubmitSuggestionScrollFrame.backdrop:Point("BOTTOMRIGHT", 6, -4)
	for i=1, HelpFrameSubmitSuggestion:GetNumChildren() do
		local child = select(i, HelpFrameSubmitSuggestion:GetChildren())
		if not child:GetName() then
			child:StripTextures()
		end
	end

	HandleScrollBar(HelpFrameSubmitSuggestionScrollFrameScrollBar)

	HelpFrameTicketScrollFrame:StripTextures()
	HelpFrameTicketScrollFrame:CreateBackdrop("Transparent")
	HelpFrameTicketScrollFrame.backdrop:Point("TOPLEFT", -4, 4)
	HelpFrameTicketScrollFrame.backdrop:Point("BOTTOMRIGHT", 6, -4)
	for i=1, HelpFrameTicket:GetNumChildren() do
		local child = select(i, HelpFrameTicket:GetChildren())
		if not child:GetName() then
			child:StripTextures()
		end
	end

	HandleScrollBar(HelpFrameKnowledgebaseScrollFrame2ScrollBar)

	-- skin sub buttons
	for i = 1, #buttons do
		_G[buttons[i]]:StripTextures(true)
		HandleButton(_G[buttons[i]], true)

		if _G[buttons[i]].text then
			_G[buttons[i]].text:ClearAllPoints()
			_G[buttons[i]].text:SetPoint("CENTER")
			_G[buttons[i]].text:SetJustifyH("CENTER")
		end
	end

	-- skin main buttons
	for i = 1, 6 do
		local b = _G["HelpFrameButton"..i]
		HandleButton(b, true)
		b.text:ClearAllPoints()
		b.text:SetPoint("CENTER")
		b.text:SetJustifyH("CENTER")
	end

	-- skin table options
	for i = 1, HelpFrameKnowledgebaseScrollFrameScrollChild:GetNumChildren() do
		local b = _G["HelpFrameKnowledgebaseScrollFrameButton"..i]
		b:StripTextures(true)
		HandleButton(b, true)
	end

	-- skin misc items
	HelpFrameKnowledgebaseSearchBox:ClearAllPoints()
	HelpFrameKnowledgebaseSearchBox:Point("TOPLEFT", HelpFrameMainInset, "TOPLEFT", 13, -10)
	HelpFrameKnowledgebaseNavBarOverlay:Kill()
	HelpFrameKnowledgebaseNavBar:StripTextures()

	HelpFrame:StripTextures(true)
	HelpFrame:CreateBackdrop("Transparent")
	HandleEditBox(HelpFrameKnowledgebaseSearchBox)
	HandleScrollBar(HelpFrameKnowledgebaseScrollFrameScrollBar, 5)
	HandleScrollBar(HelpFrameTicketScrollFrameScrollBar, 4)
	HandleCloseButton(HelpFrameCloseButton, HelpFrame.backdrop)
	HandleCloseButton(HelpFrameKnowledgebaseErrorFrameCloseButton, HelpFrameKnowledgebaseErrorFrame.backdrop)

	--Hearth Stone Button
	HelpFrameCharacterStuckHearthstone:StyleButton()
	HelpFrameCharacterStuckHearthstone:SetTemplate("Default", true)
	HelpFrameCharacterStuckHearthstone.IconTexture:SetInside()
	HelpFrameCharacterStuckHearthstone.IconTexture:SetTexCoord(unpack(F.TexCoords))

	hooksecurefunc("NavBar_AddButton", function(self, buttonData)
		local navButton = self.navList[#self.navList]


		if not navButton.skinned then
			HandleButton(navButton, true)

			if(navButton.MenuArrowButton) then
				HandleNextPrevButton(navButton.MenuArrowButton, true)
			end
			navButton.skinned = true
		end
	end)

	HandleButton(HelpFrameGM_ResponseNeedMoreHelp)
	HandleButton(HelpFrameGM_ResponseCancel)
	for i=1, HelpFrameGM_Response:GetNumChildren() do
		local child = select(i, HelpFrameGM_Response:GetChildren())
		if child and child:GetObjectType() == "Frame" and not child:GetName() then
			child:SetTemplate("Default")
		end
	end
end

tinsert(F.SkinFuncs['LanUI'], LoadSkin)