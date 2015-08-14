local F, C, G = unpack(select(2, ...))
local bc = C.Media.BorderColor

local function LoadSkin()
	CalendarFrame:StripTextures()
	CalendarFrame:SetTemplate("Transparent")
	HandleCloseButton(CalendarCloseButton)
	CalendarCloseButton:Point("TOPRIGHT", CalendarFrame, "TOPRIGHT", -4, -4)

	HandleNextPrevButton(CalendarPrevMonthButton)
	HandleNextPrevButton(CalendarNextMonthButton)

	CalendarFilterFrame:StripTextures()
	CalendarFilterFrame:Width(155)
	
	CalendarFilterFrameText:ClearAllPoints()
	CalendarFilterFrameText:Point("RIGHT", CalendarFilterButton, "LEFT", -2, 0)

	CalendarFilterButton:ClearAllPoints()
	CalendarFilterButton:Point("RIGHT", CalendarFilterFrame, "RIGHT", -10, 3)
	CalendarFilterButton.SetPoint = F.Dummy

	HandleNextPrevButton(CalendarFilterButton, true)

	CalendarFilterFrame:CreateBackdrop("Default")
	CalendarFilterFrame.backdrop:Point("TOPLEFT", 20, 2)
	CalendarFilterFrame.backdrop:Point("BOTTOMRIGHT", CalendarFilterButton, "BOTTOMRIGHT", 2, -2)

	CalendarContextMenu:SetTemplate("Default")
	CalendarContextMenu.SetBackdropColor = F.Dummy
	CalendarContextMenu.SetBackdropBorderColor = F.Dummy

	CalendarInviteStatusContextMenu:SetTemplate("Default")
	CalendarInviteStatusContextMenu.SetBackdropColor = F.Dummy
	CalendarInviteStatusContextMenu.SetBackdropBorderColor = F.Dummy

	--Boost frame levels
	for i=1, 42 do
		_G["CalendarDayButton"..i]:SetFrameLevel(_G["CalendarDayButton"..i]:GetFrameLevel() + 1)
	end

	--CreateEventFrame
	CalendarCreateEventFrame:StripTextures()
	CalendarCreateEventFrame:SetTemplate("Transparent")
	CalendarCreateEventFrame:Point("TOPLEFT", CalendarFrame, "TOPRIGHT", 3, -24)
	CalendarCreateEventTitleFrame:StripTextures()

	HandleButton(CalendarCreateEventCreateButton, true)
	HandleButton(CalendarCreateEventMassInviteButton, true)
	HandleButton(CalendarCreateEventInviteButton, true)
	CalendarCreateEventInviteButton:Point("TOPLEFT", CalendarCreateEventInviteEdit, "TOPRIGHT", 4, 1)
	CalendarCreateEventInviteEdit:Width(CalendarCreateEventInviteEdit:GetWidth() - 2)

	CalendarCreateEventInviteList:StripTextures()
	CalendarCreateEventInviteList:SetTemplate("Default")

	HandleEditBox(CalendarCreateEventInviteEdit)
	HandleEditBox(CalendarCreateEventTitleEdit)
	HandleDropDownBox(CalendarCreateEventTypeDropDown, 120)

	CalendarCreateEventDescriptionContainer:StripTextures()
	CalendarCreateEventDescriptionContainer:SetTemplate("Default")

	HandleCloseButton(CalendarCreateEventCloseButton)

	HandleCheckBox(CalendarCreateEventLockEventCheck)

	HandleDropDownBox(CalendarCreateEventHourDropDown, 68)
	HandleDropDownBox(CalendarCreateEventMinuteDropDown, 68)
	HandleDropDownBox(CalendarCreateEventAMPMDropDown, 68)
	--HandleDropDownBox(CalendarCreateEventRepeatOptionDropDown, 120)
	CalendarCreateEventIcon:SetTexCoord(unpack(F.TexCoords))
	CalendarCreateEventIcon.SetTexCoord = F.Dummy

	CalendarCreateEventInviteListSection:StripTextures()

	CalendarClassButtonContainer:HookScript("OnShow", function()
		for i, class in ipairs(CLASS_SORT_ORDER) do
			local button = _G["CalendarClassButton"..i]
			local tcoords = CLASS_ICON_TCOORDS[class]
			local buttonIcon = button:GetNormalTexture()
			buttonIcon:SetTexture("Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes")
			buttonIcon:SetTexCoord(tcoords[1] + 0.015, tcoords[2] - 0.02, tcoords[3] + 0.018, tcoords[4] - 0.02) --F U C K I N G H A X
		end
	end)
	
	CalendarClassButton1:Point("TOPLEFT", CalendarClassButtonContainer, "TOPLEFT", 5, 0)

	for i = 1, #CLASS_SORT_ORDER do
		local button = _G["CalendarClassButton"..i]
		button:StripTextures()
		button:CreateBackdrop("Default")
		button:Size(24)
	end
	
	CalendarClassTotalsButton:StripTextures()
	CalendarClassTotalsButton:CreateBackdrop("Default")
	CalendarClassTotalsButton:Width(24)

	--Texture Picker Frame
	CalendarTexturePickerFrame:StripTextures()
	CalendarTexturePickerTitleFrame:StripTextures()
	CalendarTexturePickerFrame:SetTemplate("Transparent")

	HandleScrollBar(CalendarTexturePickerScrollBar)
	HandleButton(CalendarTexturePickerAcceptButton, true)
	HandleButton(CalendarTexturePickerCancelButton, true)
	HandleButton(CalendarCreateEventInviteButton, true)
	HandleButton(CalendarCreateEventRaidInviteButton, true)

	--Mass Invite Frame
	CalendarMassInviteFrame:StripTextures()
	CalendarMassInviteFrame:SetTemplate("Transparent")
	CalendarMassInviteTitleFrame:StripTextures()

	HandleCloseButton(CalendarMassInviteCloseButton)
	HandleButton(CalendarMassInviteGuildAcceptButton)
	HandleDropDownBox(CalendarMassInviteGuildRankMenu, 130)

	HandleEditBox(CalendarMassInviteGuildMinLevelEdit)
	HandleEditBox(CalendarMassInviteGuildMaxLevelEdit)

	--Raid View
	CalendarViewRaidFrame:StripTextures()
	CalendarViewRaidFrame:SetTemplate("Transparent")
	CalendarViewRaidFrame:Point("TOPLEFT", CalendarFrame, "TOPRIGHT", 3, -24)
	CalendarViewRaidTitleFrame:StripTextures()
	HandleCloseButton(CalendarViewRaidCloseButton)

	--Holiday View
	CalendarViewHolidayFrame:StripTextures(true)
	CalendarViewHolidayFrame:SetTemplate("Transparent")
	CalendarViewHolidayFrame:Point("TOPLEFT", CalendarFrame, "TOPRIGHT", 3, -24)
	CalendarViewHolidayTitleFrame:StripTextures()
	HandleCloseButton(CalendarViewHolidayCloseButton)

	-- Event View
	CalendarViewEventFrame:StripTextures()
	CalendarViewEventFrame:SetTemplate("Transparent")
	CalendarViewEventFrame:Point("TOPLEFT", CalendarFrame, "TOPRIGHT", 3, -24)
	CalendarViewEventTitleFrame:StripTextures()
	CalendarViewEventDescriptionContainer:StripTextures()
	CalendarViewEventDescriptionContainer:SetTemplate("Transparent")
	CalendarViewEventInviteList:StripTextures()
	CalendarViewEventInviteList:SetTemplate("Transparent")
	CalendarViewEventInviteListSection:StripTextures()
	HandleCloseButton(CalendarViewEventCloseButton)
	HandleScrollBar(CalendarViewEventInviteListScrollFrameScrollBar)

	HandleButton(CalendarViewEventAcceptButton)
	HandleButton(CalendarViewEventTentativeButton)
	HandleButton(CalendarViewEventRemoveButton)
	HandleButton(CalendarViewEventDeclineButton)

	--Event Picker Frame
	CalendarEventPickerFrame:StripTextures()
	CalendarEventPickerTitleFrame:StripTextures()
	CalendarEventPickerFrame:SetTemplate("Transparent")

	HandleScrollBar(CalendarEventPickerScrollBar)
	HandleButton(CalendarEventPickerCloseButton, true)

	HandleScrollBar(CalendarCreateEventDescriptionScrollFrameScrollBar)
	HandleScrollBar(CalendarCreateEventInviteListScrollFrameScrollBar)
	HandleScrollBar(CalendarViewEventDescriptionScrollFrameScrollBar)
end

F.SkinFuncs['Blizzard_Calendar'] = LoadSkin