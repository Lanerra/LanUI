local F, C, G = unpack(select(2, ...))
local bc = C.Media.BorderColor

--Tab Regions
local tabs = {
	"LeftDisabled",
	"MiddleDisabled",
	"RightDisabled",
	"Left",
	"Middle",
	"Right",
}

--Social Frame
local function SkinSocialHeaderTab(tab)
	if not tab then return end
	for _, object in pairs(tabs) do
		local tex = _G[tab:GetName()..object]
		tex:SetTexture(nil)
	end
	tab:GetHighlightTexture():SetTexture(nil)
	tab.backdrop = CreateFrame("Frame", nil, tab)
	tab.backdrop:SetTemplate("Default")
	tab.backdrop:SetFrameLevel(tab:GetFrameLevel() - 1)
	tab.backdrop:Point("TOPLEFT", 3, -8)
	tab.backdrop:Point("BOTTOMRIGHT", -6, 0)
end

local function LoadSkin()
	HandleScrollBar(FriendsFrameFriendsScrollFrameScrollBar, 5)
	HandleScrollBar(WhoListScrollFrameScrollBar, 5)
	HandleScrollBar(ChannelRosterScrollFrameScrollBar, 5)
	HandleScrollBar(FriendsFriendsScrollFrameScrollBar)

	local StripAllTextures = {
		"ScrollOfResurrectionSelectionFrame",
		"ScrollOfResurrectionSelectionFrameList",
		"FriendsListFrame",
		"FriendsTabHeader",
		"FriendsFrameFriendsScrollFrame",
		"WhoFrameColumnHeader1",
		"WhoFrameColumnHeader2",
		"WhoFrameColumnHeader3",
		"WhoFrameColumnHeader4",
		"ChannelListScrollFrame",
		"ChannelRoster",
		"FriendsFramePendingButton1",
		"FriendsFramePendingButton2",
		"FriendsFramePendingButton3",
		"FriendsFramePendingButton4",
		"ChannelFrameDaughterFrame",
		"AddFriendFrame",
		"AddFriendNoteFrame",
	}

	local KillTextures = {
		"FriendsFrameBroadcastInputLeft",
		"FriendsFrameBroadcastInputRight",
		"FriendsFrameBroadcastInputMiddle",
	}

	HandleEditBox(ChannelFrameDaughterFrameChannelName)
	HandleEditBox(ChannelFrameDaughterFrameChannelPassword)
	FriendsFrameInset:StripTextures()
	WhoFrameListInset:StripTextures()
	WhoFrameEditBoxInset:StripTextures()
	ChannelFrameRightInset:StripTextures()
	ChannelFrameLeftInset:StripTextures()
	LFRQueueFrameListInset:StripTextures()
	LFRQueueFrameRoleInset:StripTextures()
	LFRQueueFrameCommentInset:StripTextures()

	local buttons = {
		"FriendsFrameAddFriendButton",
		"FriendsFrameSendMessageButton",
		"WhoFrameWhoButton",
		"WhoFrameAddFriendButton",
		"WhoFrameGroupInviteButton",
		"ChannelFrameNewButton",
		"FriendsFrameIgnorePlayerButton",
		"FriendsFrameUnsquelchButton",
		"FriendsFramePendingButton1AcceptButton",
		"FriendsFramePendingButton1DeclineButton",
		"FriendsFramePendingButton2AcceptButton",
		"FriendsFramePendingButton2DeclineButton",
		"FriendsFramePendingButton3AcceptButton",
		"FriendsFramePendingButton3DeclineButton",
		"FriendsFramePendingButton4AcceptButton",
		"FriendsFramePendingButton4DeclineButton",
		"ChannelFrameDaughterFrameOkayButton",
		"ChannelFrameDaughterFrameCancelButton",
		"AddFriendEntryFrameAcceptButton",
		"AddFriendEntryFrameCancelButton",
		"AddFriendInfoFrameContinueButton",
		"ScrollOfResurrectionSelectionFrameAcceptButton",
		"ScrollOfResurrectionSelectionFrameCancelButton",
	}

	for _, button in pairs(buttons) do
		HandleButton(_G[button])
	end

	for _, texture in pairs(KillTextures) do
		_G[texture]:Kill()
	end

	for _, object in pairs(StripAllTextures) do
		_G[object]:StripTextures()
	end

	for i=1, FriendsFrame:GetNumRegions() do
		local region = select(i, FriendsFrame:GetRegions())
		if region:GetObjectType() == "Texture" then
			region:SetTexture(nil)
			region:SetAlpha(0)
		end
	end

	HandleDropDownBox(FriendsFrameStatusDropDown,70)

	FriendsFrameBattlenetFrame:StripTextures()

	FriendsFrameBattlenetFrame.BroadcastButton:CreateBackdrop()
	FriendsFrameBattlenetFrame.BroadcastButton:Size(17)
	FriendsFrameBattlenetFrame.BroadcastButton:ClearAllPoints()
	FriendsFrameBattlenetFrame.BroadcastButton:SetPoint('RIGHT', FriendsFrameStatusDropDown.backdrop, 'LEFT', -23, 0)
	FriendsFrameBattlenetFrame.BroadcastButton:GetNormalTexture():SetTexCoord(.28, .72, .28, .72)
	FriendsFrameBattlenetFrame.BroadcastButton:GetPushedTexture():SetTexCoord(.28, .72, .28, .72)
	FriendsFrameBattlenetFrame.BroadcastButton:GetHighlightTexture():SetTexCoord(.28, .72, .28, .72)
	--FriendsFrameBattlenetFrame.BroadcastButton:SetScript('OnClick', function() E:StaticPopup_Show("SET_BN_BROADCAST") end)

	HandleEditBox(AddFriendNameEditBox)
	AddFriendFrame:SetTemplate("Transparent")
	ScrollOfResurrectionSelectionFrame:SetTemplate('Transparent')
	ScrollOfResurrectionSelectionFrameList:SetTemplate('Default')
	HandleScrollBar(ScrollOfResurrectionSelectionFrameListScrollFrameScrollBar, 4)
	HandleEditBox(ScrollOfResurrectionSelectionFrameTargetEditBox)

	--Who Frame
	local function UpdateWhoSkins()
		WhoListScrollFrame:StripTextures()
	end
	--Channel Frame
	local function UpdateChannel()
		ChannelRosterScrollFrame:StripTextures()
	end
	--BNet Frame
	FriendsFrameBroadcastInput:CreateBackdrop("Default")
	ChannelFrameDaughterFrameChannelName:CreateBackdrop("Default")
	ChannelFrameDaughterFrameChannelPassword:CreateBackdrop("Default")

	ChannelFrame:HookScript("OnShow", UpdateChannel)
	hooksecurefunc("FriendsFrame_OnEvent", UpdateChannel)

	WhoFrame:HookScript("OnShow", UpdateWhoSkins)
	hooksecurefunc("FriendsFrame_OnEvent", UpdateWhoSkins)

	ChannelFrameDaughterFrame:CreateBackdrop("Transparent")

	FriendsFrame:SetTemplate('Transparent')

	HandleCloseButton(ChannelFrameDaughterFrameDetailCloseButton,ChannelFrameDaughterFrame)
	HandleCloseButton(FriendsFrameCloseButton,FriendsFrame.backdrop)
	HandleDropDownBox(WhoFrameDropDown,150)


	--Bottom Tabs
	for i=1, 4 do
		HandleTab(_G["FriendsFrameTab"..i])
	end

	for i=1, 3 do
		SkinSocialHeaderTab(_G["FriendsTabHeaderTab"..i])
	end

	local function Channel()
		for i=1, MAX_DISPLAY_CHANNEL_BUTTONS do
			local button = _G["ChannelButton"..i]
			if button then
				button:StripTextures()
				button:SetHighlightTexture("Interface\\PaperDollInfoFrame\\UI-Character-Tab-Highlight")

				_G["ChannelButton"..i.."Text"]:FontTemplate(nil, 12)
			end
		end
	end
	hooksecurefunc("ChannelList_Update", Channel)

	--View Friends BN Frame
	FriendsFriendsFrame:CreateBackdrop("Transparent")

	local StripAllTextures = {
		"FriendsFriendsFrame",
		"FriendsFriendsList",
		"FriendsFriendsNoteFrame",
	}

	local buttons = {
		"FriendsFriendsSendRequestButton",
		"FriendsFriendsCloseButton",
	}

	for _, object in pairs(StripAllTextures) do
		_G[object]:StripTextures()
	end

	for _, button in pairs(buttons) do
		HandleButton(_G[button])
	end

	HandleEditBox(FriendsFriendsList)
	HandleEditBox(FriendsFriendsNoteFrame)
	HandleDropDownBox(FriendsFriendsFrameDropDown,150)

	BNConversationInviteDialog:StripTextures()
	BNConversationInviteDialog:CreateBackdrop('Transparent')
	BNConversationInviteDialogList:StripTextures()
	BNConversationInviteDialogList:SetTemplate('Default')
	HandleButton(BNConversationInviteDialogInviteButton)
	HandleButton(BNConversationInviteDialogCancelButton)

	for i=1, BN_CONVERSATION_INVITE_NUM_DISPLAYED do
		HandleCheckBox(_G["BNConversationInviteDialogListFriend"..i].checkButton)
	end

	FriendsTabHeaderSoRButton:SetTemplate('Default')
	FriendsTabHeaderSoRButton:StyleButton()
	FriendsTabHeaderSoRButtonIcon:SetDrawLayer('OVERLAY')
	FriendsTabHeaderSoRButtonIcon:SetTexCoord(unpack(F.TexCoords))
	FriendsTabHeaderSoRButtonIcon:SetInside()
	FriendsTabHeaderSoRButton:Point('TOPRIGHT', FriendsTabHeader, 'TOPRIGHT', -8, -56)

	FriendsTabHeaderRecruitAFriendButton:SetTemplate('Default')
	FriendsTabHeaderRecruitAFriendButton:StyleButton()
	FriendsTabHeaderRecruitAFriendButtonIcon:SetDrawLayer("OVERLAY")
	FriendsTabHeaderRecruitAFriendButtonIcon:SetTexCoord(unpack(F.TexCoords))
	FriendsTabHeaderRecruitAFriendButtonIcon:SetInside()

	HandleScrollBar(FriendsFrameIgnoreScrollFrameScrollBar, 4)
	HandleScrollBar(FriendsFramePendingScrollFrameScrollBar, 4)

	IgnoreListFrame:StripTextures()
	PendingListFrame:StripTextures()

	ScrollOfResurrectionFrame:StripTextures()
	HandleButton(ScrollOfResurrectionFrameAcceptButton)
	HandleButton(ScrollOfResurrectionFrameCancelButton)

	ScrollOfResurrectionFrameTargetEditBoxLeft:SetTexture(nil)
	ScrollOfResurrectionFrameTargetEditBoxMiddle:SetTexture(nil)
	ScrollOfResurrectionFrameTargetEditBoxRight:SetTexture(nil)
	ScrollOfResurrectionFrameNoteFrame:StripTextures()
	ScrollOfResurrectionFrameNoteFrame:SetTemplate()
	ScrollOfResurrectionFrameTargetEditBox:SetTemplate()
	ScrollOfResurrectionFrame:SetTemplate('Transparent')

	RecruitAFriendFrame:StripTextures()
	RecruitAFriendFrame:SetTemplate("Transparent")
	HandleCloseButton(RecruitAFriendFrameCloseButton)
	HandleButton(RecruitAFriendFrameSendButton)
	HandleEditBox(RecruitAFriendNameEditBox)
	RecruitAFriendNoteFrame:StripTextures()
	HandleEditBox(RecruitAFriendNoteFrame)
end

tinsert(F.SkinFuncs['LanUI'], LoadSkin)