local F, C, G = unpack(select(2, ...))
local bc = C.Media.BorderColor

local function LoadSkin()
	GuildFrame:StripTextures(true)
	GuildFrame:SetTemplate("Transparent")
	--GuildLevelFrame:Kill()

	HandleCloseButton(GuildMemberDetailCloseButton)
	HandleCloseButton(GuildFrameCloseButton)
	HandleScrollBar(GuildInfoFrameApplicantsContainerScrollBar)
	local striptextures = {
		"GuildFrameInset",
		"GuildFrameBottomInset",
		"GuildAllPerksFrame",
		"GuildMemberDetailFrame",
		"GuildMemberNoteBackground",
		"GuildInfoFrameInfo",
		"GuildLogContainer",
		"GuildLogFrame",
		"GuildRewardsFrame",
		"GuildMemberOfficerNoteBackground",
		"GuildTextEditContainer",
		"GuildTextEditFrame",
		"GuildRecruitmentRolesFrame",
		"GuildRecruitmentAvailabilityFrame",
		"GuildRecruitmentInterestFrame",
		"GuildRecruitmentLevelFrame",
		"GuildRecruitmentCommentFrame",
		"GuildRecruitmentCommentInputFrame",
		"GuildInfoFrameApplicantsContainer",
		"GuildInfoFrameApplicants",
		"GuildNewsBossModel",
		"GuildNewsBossModelTextFrame",
	}
	GuildRewardsFrameVisitText:ClearAllPoints()
	GuildRewardsFrameVisitText:SetPoint("TOP", GuildRewardsFrame, "TOP", 0, 30)
	for _, frame in pairs(striptextures) do
		_G[frame]:StripTextures()
	end

	GuildNewsBossModel:CreateBackdrop("Transparent")
	GuildNewsBossModelTextFrame:CreateBackdrop("Default")
	GuildNewsBossModelTextFrame.backdrop:Point("TOPLEFT", GuildNewsBossModel.backdrop, "BOTTOMLEFT", 0, -1)
	GuildNewsBossModel:Point("TOPLEFT", GuildFrame, "TOPRIGHT", 4, -43)

	local buttons = {
		"GuildMemberRemoveButton",
		"GuildMemberGroupInviteButton",
		"GuildAddMemberButton",
		"GuildViewLogButton",
		"GuildControlButton",
		"GuildRecruitmentListGuildButton",
		"GuildTextEditFrameAcceptButton",
		"GuildRecruitmentInviteButton",
		"GuildRecruitmentMessageButton",
		"GuildRecruitmentDeclineButton",
	}

	for i, button in pairs(buttons) do
		if i == 1 then
			HandleButton(_G[button])
		else
			HandleButton(_G[button], true)
		end
	end

	local checkbuttons = {
		"Quest",
		"Dungeon",
		"Raid",
		"PvP",
		"RP",
		"Weekdays",
		"Weekends",
		"LevelAny",
		"LevelMax",
	}

	for _, frame in pairs(checkbuttons) do
		HandleCheckBox(_G["GuildRecruitment"..frame.."Button"])
	end

	HandleCheckBox(GuildRecruitmentTankButton:GetChildren())
	HandleCheckBox(GuildRecruitmentHealerButton:GetChildren())
	HandleCheckBox(GuildRecruitmentDamagerButton:GetChildren())

	for i=1,5 do
		HandleTab(_G["GuildFrameTab"..i])
	end

	HandleScrollBar(GuildPerksContainerScrollBar, 4)

	GuildFactionBar:StripTextures()
	GuildFactionBar.progress:SetTexture(C.Media.StatusBar)
	GuildFactionBar:CreateBackdrop("Default")
	GuildFactionBar.backdrop:Point("TOPLEFT", GuildFactionBar.progress, "TOPLEFT", -2, 2)
	GuildFactionBar.backdrop:Point("BOTTOMRIGHT", GuildFactionBar, "BOTTOMRIGHT", 1, C.Media.PixelPerfect and 1 or 0)


	--Roster
	HandleScrollBar(GuildRosterContainerScrollBar, 5)
	HandleCheckBox(GuildRosterShowOfflineButton)


	for i=1, 4 do
		_G["GuildRosterColumnButton"..i]:StripTextures(true)
	end

	HandleDropDownBox(GuildRosterViewDropdown, 200)

	for i=1, 14 do
		HandleButton(_G["GuildRosterContainerButton"..i.."HeaderButton"], true)
	end

	--Detail Frame
	GuildMemberDetailFrame:SetTemplate("Transparent")
	GuildMemberNoteBackground:SetTemplate("Transparent")
	GuildMemberOfficerNoteBackground:SetTemplate("Transparent")
	GuildMemberRankDropdown:SetFrameLevel(GuildMemberRankDropdown:GetFrameLevel() + 5)
	HandleDropDownBox(GuildMemberRankDropdown, 175)

	--News
	GuildNewsFrame:StripTextures()
	for i=1, 17 do
		if _G["GuildNewsContainerButton"..i] then
			_G["GuildNewsContainerButton"..i].header:Kill()
		end
	end

	GuildNewsFiltersFrame:StripTextures()
	GuildNewsFiltersFrame:SetTemplate("Transparent")
	HandleCloseButton(GuildNewsFiltersFrameCloseButton)

	for i=1, 6 do
		HandleCheckBox(_G["GuildNewsFilterButton"..i])
	end

	GuildNewsFiltersFrame:Point("TOPLEFT", GuildFrame, "TOPRIGHT", 4, -20)
	HandleScrollBar(GuildNewsContainerScrollBar, 4)

	--Info Frame
	HandleScrollBar(GuildInfoDetailsFrameScrollBar, 4)

	for i=1, 3 do
		_G["GuildInfoFrameTab"..i]:StripTextures()
	end

	local backdrop1 = CreateFrame("Frame", nil, GuildInfoFrameInfo)
	backdrop1:SetTemplate("Transparent")
	backdrop1:SetFrameLevel(GuildInfoFrameInfo:GetFrameLevel() - 1)
	backdrop1:Point("TOPLEFT", GuildInfoFrameInfo, "TOPLEFT", 2, -22)
	backdrop1:Point("BOTTOMRIGHT", GuildInfoFrameInfo, "BOTTOMRIGHT", 0, 200)

	local backdrop2 = CreateFrame("Frame", nil, GuildInfoFrameInfo)
	backdrop2:SetTemplate("Transparent")
	backdrop2:SetFrameLevel(GuildInfoFrameInfo:GetFrameLevel() - 1)
	backdrop2:Point("TOPLEFT", GuildInfoFrameInfo, "TOPLEFT", 2, -158)
	backdrop2:Point("BOTTOMRIGHT", GuildInfoFrameInfo, "BOTTOMRIGHT", 0, 118)

	local backdrop3 = CreateFrame("Frame", nil, GuildInfoFrameInfo)
	backdrop3:SetTemplate("Transparent")
	backdrop3:SetFrameLevel(GuildInfoFrameInfo:GetFrameLevel() - 1)
	backdrop3:Point("TOPLEFT", GuildInfoFrameInfo, "TOPLEFT", 2, -233)
	backdrop3:Point("BOTTOMRIGHT", GuildInfoFrameInfo, "BOTTOMRIGHT", 0, 3)

	GuildRecruitmentCommentInputFrame:SetTemplate("Transparent")

	for _, button in next, GuildInfoFrameApplicantsContainer.buttons do
		button.selectedTex:Kill()
		button:GetHighlightTexture():Kill()
		button:SetBackdrop(nil)
	end

	--Text Edit Frame
	GuildTextEditFrame:SetTemplate("Transparent")
	HandleScrollBar(GuildTextEditScrollFrameScrollBar, 5)
	GuildTextEditContainer:SetTemplate("Transparent")
	for i=1, GuildTextEditFrame:GetNumChildren() do
		local child = select(i, GuildTextEditFrame:GetChildren())
		if child:GetName() == "GuildTextEditFrameCloseButton" and child:GetWidth() < 33 then
			HandleCloseButton(child)
		elseif child:GetName() == "GuildTextEditFrameCloseButton" then
			HandleButton(child, true)
		end
	end

	--Guild Log
	HandleScrollBar(GuildLogScrollFrameScrollBar, 4)
	GuildLogFrame:SetTemplate("Transparent")

	--Blizzard has two buttons with the same name, this is a fucked up way of determining that it isn't the other button
	for i=1, GuildLogFrame:GetNumChildren() do
		local child = select(i, GuildLogFrame:GetChildren())
		if child:GetName() == "GuildLogFrameCloseButton" and child:GetWidth() < 33 then
			HandleCloseButton(child)
		elseif child:GetName() == "GuildLogFrameCloseButton" then
			HandleButton(child, true)
		end
	end

	--Perks
	for i=1, 9 do
		local button = _G["GuildPerksContainerButton"..i]
		button:DisableDrawLayer("BACKGROUND")
		button:DisableDrawLayer("BORDER")

		button.icon:SetTexCoord(unpack(F.TexCoords))
		button:CreateBackdrop()
		button.backdrop:SetOutside(button.icon)
	end

	--Rewards
	HandleScrollBar(GuildRewardsContainerScrollBar, 5)

	for i=1, 8 do
		local button = _G["GuildRewardsContainerButton"..i]
		button:StripTextures()

		if button.icon then
			button.icon:SetTexCoord(unpack(F.TexCoords))
			button.icon:ClearAllPoints()
			button.icon:Point("TOPLEFT", 2, -2)
			button:CreateBackdrop("Default")
			button.backdrop:SetOutside(button.icon)
			button.icon:SetParent(button.backdrop)
		end
	end
end

F.SkinFuncs['Blizzard_GuildUI'] = LoadSkin