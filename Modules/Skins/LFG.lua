local F, C, G = unpack(select(2, ...))
local bc = C.Media.BorderColor

local function LoadSkin()
	PVEFrame:StripTextures()
	PVEFrame:StripTextures()
	PVEFrameLeftInset:StripTextures()
	RaidFinderQueueFrame:StripTextures(true)
	PVEFrameBg:Hide()
	PVEFrameTitleBg:Hide()
	PVEFramePortrait:Hide()
	PVEFramePortraitFrame:Hide()
	PVEFrameTopRightCorner:Hide()
	PVEFrameTopBorder:Hide()
	PVEFrameLeftInsetBg:Hide()
	PVEFrame.shadows:Hide()
	HandleButton(LFDQueueFramePartyBackfillBackfillButton)
	HandleButton(LFDQueueFramePartyBackfillNoBackfillButton)
	HandleButton(LFDQueueFrameRandomScrollFrameChildFrameBonusRepFrame.ChooseButton)
	HandleButton(ScenarioQueueFrameRandomScrollFrameChildFrameBonusRepFrame.ChooseButton)
	HandleScrollBar(ScenarioQueueFrameRandomScrollFrameScrollBar);

	GroupFinderFrameGroupButton1.icon:SetTexture("Interface\\Icons\\INV_Helmet_08")
	GroupFinderFrameGroupButton2.icon:SetTexture("Interface\\Icons\\inv_helmet_06")
	GroupFinderFrameGroupButton3.icon:SetTexture("Interface\\Icons\\Icon_Scenarios")

	LFGDungeonReadyDialogBackground:Kill()
	HandleButton(LFGDungeonReadyDialogEnterDungeonButton)
	HandleButton(LFGDungeonReadyDialogLeaveQueueButton)
	HandleCloseButton(LFGDungeonReadyDialogCloseButton)
	LFGDungeonReadyDialog:StripTextures()
	LFGDungeonReadyDialog:SetTemplate("Transparent")
	LFGDungeonReadyStatus:StripTextures()
	LFGDungeonReadyStatus:SetTemplate("Transparent")
	LFGDungeonReadyDialogRoleIconTexture:SetTexture("Interface\\LFGFrame\\UI-LFG-ICONS-ROLEBACKGROUNDS")
	LFGDungeonReadyDialogRoleIconTexture:SetAlpha(0.5)
	hooksecurefunc("LFGDungeonReadyPopup_Update", function()
		local proposalExists, id, typeID, subtypeID, name, texture, role, hasResponded, totalEncounters, completedEncounters, numMembers, isLeader = GetLFGProposal();
		if LFGDungeonReadyDialogRoleIcon:IsShown() then
			if role == "DAMAGER" then
				LFGDungeonReadyDialogRoleIconTexture:SetTexCoord(LFDQueueFrameRoleButtonDPS.background:GetTexCoord())
			elseif role == "TANK" then
				LFGDungeonReadyDialogRoleIconTexture:SetTexCoord(LFDQueueFrameRoleButtonTank.background:GetTexCoord())
			elseif role == "HEALER" then
				LFGDungeonReadyDialogRoleIconTexture:SetTexCoord(LFDQueueFrameRoleButtonHealer.background:GetTexCoord())
			end
		end
	end)

	hooksecurefunc(LFGDungeonReadyDialog, "SetBackdrop", function(self, backdrop)
		if backdrop.bgFile ~= C.Media.Backdrop then
			self:SetTemplate("Transparent")
		end
	end)

	LFDQueueFrameRoleButtonTankIncentiveIcon:SetAlpha(0)
	LFDQueueFrameRoleButtonHealerIncentiveIcon:SetAlpha(0)
	LFDQueueFrameRoleButtonDPSIncentiveIcon:SetAlpha(0)

	local function OnShow(self)
		ActionButton_ShowOverlayGlow(self:GetParent().checkButton)
	end
	local function OnHide(self)
		ActionButton_HideOverlayGlow(self:GetParent().checkButton)
	end
	LFDQueueFrameRoleButtonTankIncentiveIcon:HookScript("OnShow", OnShow)
	LFDQueueFrameRoleButtonHealerIncentiveIcon:HookScript("OnShow", OnShow)
	LFDQueueFrameRoleButtonDPSIncentiveIcon:HookScript("OnShow", OnShow)
	LFDQueueFrameRoleButtonTankIncentiveIcon:HookScript("OnHide", OnHide)
	LFDQueueFrameRoleButtonHealerIncentiveIcon:HookScript("OnHide", OnHide)
	LFDQueueFrameRoleButtonDPSIncentiveIcon:HookScript("OnHide", OnHide)
	LFDQueueFrameRoleButtonTank.shortageBorder:Kill()
	LFDQueueFrameRoleButtonDPS.shortageBorder:Kill()
	LFDQueueFrameRoleButtonHealer.shortageBorder:Kill()
	LFGDungeonReadyDialog.filigree:SetAlpha(0)
	LFGDungeonReadyDialog.bottomArt:SetAlpha(0)
	HandleCloseButton(LFGDungeonReadyStatusCloseButton)

	local roleButtons = {
		LFDQueueFrameRoleButtonHealer,
		LFDQueueFrameRoleButtonDPS,
		LFDQueueFrameRoleButtonLeader,
		LFDQueueFrameRoleButtonTank,
		RaidFinderQueueFrameRoleButtonHealer,
		RaidFinderQueueFrameRoleButtonDPS,
		RaidFinderQueueFrameRoleButtonLeader,
		RaidFinderQueueFrameRoleButtonTank,
		LFGInvitePopupRoleButtonTank,
		LFGInvitePopupRoleButtonHealer,
		LFGInvitePopupRoleButtonDPS,
		LFGListApplicationDialog.TankButton,
		LFGListApplicationDialog.HealerButton,
		LFGListApplicationDialog.DamagerButton,
	}

	for _, roleButton in pairs(roleButtons) do
		HandleCheckBox(roleButton.checkButton or roleButton.CheckButton, true)
		roleButton:DisableDrawLayer("ARTWORK")
		roleButton:DisableDrawLayer("OVERLAY")

		if(not roleButton.background) then
			local isLeader = roleButton:GetName() ~= nil and roleButton:GetName():find("Leader") or false
			if(not isLeader) then
				roleButton.background = roleButton:CreateTexture(nil, "BACKGROUND")
				roleButton.background:SetSize(80, 80)
				roleButton.background:SetPoint("CENTER")
				roleButton.background:SetTexture("Interface\\LFGFrame\\UI-LFG-ICONS-ROLEBACKGROUNDS")
				roleButton.background:SetAlpha(0.65)

				local buttonName = roleButton:GetName() ~= nil and roleButton:GetName() or roleButton.role
				roleButton.background:SetTexCoord(GetBackgroundTexCoordsForRole((lower(buttonName):find("tank") and "TANK") or (lower(buttonName):find("healer") and "HEALER") or "DAMAGER"))
			end
		end
	end

	LFDQueueFrameRoleButtonLeader.leadIcon = LFDQueueFrameRoleButtonLeader:CreateTexture(nil, 'BACKGROUND')
	LFDQueueFrameRoleButtonLeader.leadIcon:SetTexture([[Interface\GroupFrame\UI-Group-LeaderIcon]])
	LFDQueueFrameRoleButtonLeader.leadIcon:SetPoint(LFDQueueFrameRoleButtonLeader:GetNormalTexture():GetPoint())
	LFDQueueFrameRoleButtonLeader.leadIcon:Size(50)
	LFDQueueFrameRoleButtonLeader.leadIcon:SetAlpha(0.4)

	RaidFinderQueueFrameRoleButtonLeader.leadIcon = RaidFinderQueueFrameRoleButtonLeader:CreateTexture(nil, 'BACKGROUND')
	RaidFinderQueueFrameRoleButtonLeader.leadIcon:SetTexture([[Interface\GroupFrame\UI-Group-LeaderIcon]])
	RaidFinderQueueFrameRoleButtonLeader.leadIcon:SetPoint(RaidFinderQueueFrameRoleButtonLeader:GetNormalTexture():GetPoint())
	RaidFinderQueueFrameRoleButtonLeader.leadIcon:Size(50)
	RaidFinderQueueFrameRoleButtonLeader.leadIcon:SetAlpha(0.4)

	hooksecurefunc('LFG_DisableRoleButton', function(button)
		if button.checkButton:GetChecked() then
			button.checkButton:SetAlpha(1)
		else
			button.checkButton:SetAlpha(0)
		end

		if button.background then
			button.background:Show()
		end
	end)

	hooksecurefunc('LFG_EnableRoleButton', function(button)
		button.checkButton:SetAlpha(1)
	end)


	hooksecurefunc("LFG_PermanentlyDisableRoleButton", function(self)
		if self.background then
			self.background:Show()
			self.background:SetDesaturated(true)
		end
	end)

	for i = 1, 4 do
		local bu = GroupFinderFrame["groupButton"..i]

		bu.ring:Hide()
		bu.bg:SetTexture("")
		bu.bg:SetAllPoints()

		bu:SetTemplate()
		bu:StyleButton()

		bu.icon:SetTexCoord(unpack(F.TexCoords))
		bu.icon:SetPoint("LEFT", bu, "LEFT")
		bu.icon:SetDrawLayer("OVERLAY")
		bu.icon:Size(40)
		bu.icon:ClearAllPoints()
		bu.icon:SetPoint("LEFT", 10, 0)
		bu.border = CreateFrame("Frame", nil, bu)
		bu.border:SetTemplate('Default')
		bu.border:SetOutside(bu.icon)
		bu.icon:SetParent(bu.border)
	end

	PVEFrame:CreateBackdrop("Transparent")
	for i=1, 3 do
		HandleTab(_G['PVEFrameTab'..i])
	end
	PVEFrameTab1:SetPoint('BOTTOMLEFT', PVEFrame, 'BOTTOMLEFT', 19, C.Media.PixelPerfect and -31 or -32)

	HandleCloseButton(PVEFrameCloseButton)

	-- raid finder
	HandleButton(LFDQueueFrameFindGroupButton, true)

	LFDParentFrame:StripTextures()
	LFDParentFrameInset:StripTextures()



	local function ReskinRewards()
		LFDQueueFrame:StripTextures()

		for i = 1, LFD_MAX_REWARDS do
			local button = _G["LFDQueueFrameRandomScrollFrameChildFrameItem"..i]
			local icon = _G["LFDQueueFrameRandomScrollFrameChildFrameItem"..i.."IconTexture"]

			if button then
				if not button.reskinned then
					local cta = _G["LFDQueueFrameRandomScrollFrameChildFrameItem"..i.."ShortageBorder"]
					local count = _G["LFDQueueFrameRandomScrollFrameChildFrameItem"..i.."Count"]
					local na = _G["LFDQueueFrameRandomScrollFrameChildFrameItem"..i.."NameFrame"]

					icon:SetTexCoord(unpack(F.TexCoords))
					icon:SetDrawLayer("OVERLAY")
					count:SetDrawLayer("OVERLAY")
					na:SetTexture()
					na:SetSize(118, 39)
					cta:SetAlpha(0)

					button.border = CreateFrame("Frame", nil, button)
					button.border:SetTemplate()
					button.border:SetOutside(icon)
					icon:SetParent(button.border)
					count:SetParent(button.border)
					button.reskinned = true

					for j=1, 3 do
						local roleIcon = _G["LFDQueueFrameRandomScrollFrameChildFrameItem"..i.."RoleIcon"..j]
						if roleIcon then
							roleIcon:SetParent(button.border)
						end
					end
				end
			end
		end
	end

	hooksecurefunc("LFDQueueFrameRandom_UpdateFrame", ReskinRewards)

	local function HandleGoldIcon(button)
		_G[button.."IconTexture"]:SetTexCoord(unpack(F.TexCoords))
		_G[button.."IconTexture"]:SetDrawLayer("OVERLAY")
		_G[button.."Count"]:SetDrawLayer("OVERLAY")
		_G[button.."NameFrame"]:SetTexture()
		_G[button.."NameFrame"]:SetSize(118, 39)

		_G[button].border = CreateFrame("Frame", nil, _G[button])
		_G[button].border:SetTemplate()
		_G[button].border:SetOutside(_G[button.."IconTexture"])
		_G[button.."IconTexture"]:SetParent(_G[button].border)
		_G[button.."Count"]:SetParent(_G[button].border)
	end
	HandleGoldIcon("LFDQueueFrameRandomScrollFrameChildFrameMoneyReward")
	HandleGoldIcon("RaidFinderQueueFrameScrollFrameChildFrameMoneyReward")
	HandleGoldIcon("ScenarioQueueFrameRandomScrollFrameChildFrameMoneyReward")

	for i = 1, NUM_LFD_CHOICE_BUTTONS do
		HandleCheckBox(_G["LFDQueueFrameSpecificListButton"..i].enableButton)
	end

	hooksecurefunc("ScenarioQueueFrameSpecific_Update", function()

		for i = 1, NUM_SCENARIO_CHOICE_BUTTONS do
			local button = _G["ScenarioQueueFrameSpecificButton"..i]

			if button and not button.skinned then
				HandleCheckBox(button.enableButton)
				button.skinned = true;
			end
		end
	end)

	for i = 1, NUM_LFR_CHOICE_BUTTONS do
		local bu = _G["LFRQueueFrameSpecificListButton"..i].enableButton
		HandleCheckBox(bu)
	end

	HandleDropDownBox(LFDQueueFrameTypeDropDown)
	ScenarioQueueFrame:StripTextures()
	ScenarioFinderFrameInset:StripTextures()
	HandleButton(ScenarioQueueFrameFindGroupButton)


	-- Raid Finder
	RaidFinderFrame:StripTextures()
	RaidFinderFrameBottomInset:StripTextures()
	RaidFinderFrameRoleInset:StripTextures()
	RaidFinderFrameBottomInsetBg:Hide()
	RaidFinderFrameBtnCornerRight:Hide()
	RaidFinderFrameButtonBottomBorder:Hide()
	HandleDropDownBox(RaidFinderQueueFrameSelectionDropDown)
	RaidFinderFrameFindRaidButton:StripTextures()
	HandleButton(RaidFinderFrameFindRaidButton)
	RaidFinderQueueFrame:StripTextures()

	for i = 1, LFD_MAX_REWARDS do
		local button = _G["RaidFinderQueueFrameScrollFrameChildFrameItem"..i]
		local icon = _G["RaidFinderQueueFrameScrollFrameChildFrameItem"..i.."IconTexture"]

		if button then
			if not button.reskinned then
				local cta = _G["RaidFinderQueueFrameScrollFrameChildFrameItem"..i.."ShortageBorder"]
				local count = _G["RaidFinderQueueFrameScrollFrameChildFrameItem"..i.."Count"]
				local na = _G["RaidFinderQueueFrameScrollFrameChildFrameItem"..i.."NameFrame"]
				button:StripTextures()

				icon:SetTexCoord(unpack(F.TexCoords))
				icon:SetDrawLayer("OVERLAY")
				count:SetDrawLayer("OVERLAY")
				na:SetTexture()
				na:SetSize(118, 39)
				cta:SetAlpha(0)

				button.border = CreateFrame("Frame", nil, button)
				button.border:SetTemplate()
				button.border:SetOutside(icon)
				icon:SetParent(button.border)
				count:SetParent(button.border)
				button.reskinned = true
			end
		end
	end

	-- Scenario finder
	ScenarioFinderFrameInset:DisableDrawLayer("BORDER")
	ScenarioFinderFrame.TopTileStreaks:Hide()
	ScenarioFinderFrameBtnCornerRight:Hide()
	ScenarioFinderFrameButtonBottomBorder:Hide()
	ScenarioQueueFrame.Bg:Hide()
	ScenarioFinderFrameInset:GetRegions():Hide()

	local function ReskinRewards()
		LFDQueueFrame:StripTextures()

		for i = 1, LFD_MAX_REWARDS do
			local button = _G["ScenarioQueueFrameRandomScrollFrameChildFrameItem"..i]
			local icon = _G["ScenarioQueueFrameRandomScrollFrameChildFrameItem"..i.."IconTexture"]

			if button then
				if not button.reskinned then
					local cta = _G["ScenarioQueueFrameRandomScrollFrameChildFrameItem"..i.."ShortageBorder"]
					local count = _G["ScenarioQueueFrameRandomScrollFrameChildFrameItem"..i.."Count"]
					local na = _G["ScenarioQueueFrameRandomScrollFrameChildFrameItem"..i.."NameFrame"]

					icon:SetTexCoord(unpack(F.TexCoords))
					icon:SetDrawLayer("OVERLAY")
					count:SetDrawLayer("OVERLAY")
					na:SetTexture()
					na:SetSize(118, 39)
					cta:SetAlpha(0)

					button.border = CreateFrame("Frame", nil, button)
					button.border:SetTemplate()
					button.border:SetOutside(icon)
					icon:SetParent(button.border)
					count:SetParent(button.border)
					button.reskinned = true
				end
			end
		end
	end

	hooksecurefunc("ScenarioQueueFrameRandom_UpdateFrame", ReskinRewards)

	ScenarioQueueFrameFindGroupButton:StripTextures()
	HandleButton(ScenarioQueueFrameFindGroupButton)


	HandleDropDownBox(ScenarioQueueFrameTypeDropDown)

	-- Looking for raid
	LFRBrowseFrameListScrollFrame:StripTextures()

	LFRBrowseFrame:HookScript('OnShow', function()
		if not LFRBrowseFrameListScrollFrameScrollBar.skinned then
			HandleScrollBar(LFRBrowseFrameListScrollFrameScrollBar)
			LFRBrowseFrameListScrollFrameScrollBar.skinned = true
		end
	end)

	LFRBrowseFrameRoleInset:DisableDrawLayer("BORDER")
	RaidBrowserFrameBg:Hide()
	LFRQueueFrameSpecificListScrollFrameScrollBackgroundTopLeft:Hide()
	LFRQueueFrameSpecificListScrollFrameScrollBackgroundBottomRight:Hide()
	LFRBrowseFrameRoleInsetBg:Hide()
	LFRQueueFrameCommentScrollFrame:CreateBackdrop()
	LFRBrowseFrameColumnHeader1:SetWidth(88) --Fix the columns being slightly off

	for i = 1, 14 do
		if i ~= 6 and i ~= 8 then
			select(i, RaidBrowserFrame:GetRegions()):Hide()
		end
	end

	RaidBrowserFrame:CreateBackdrop('Transparent')
	HandleCloseButton(RaidBrowserFrameCloseButton)
	HandleButton(LFRQueueFrameFindGroupButton)
	HandleButton(LFRQueueFrameAcceptCommentButton)

	HandleScrollBar(LFRQueueFrameCommentScrollFrameScrollBar)
	HandleScrollBar(LFDQueueFrameSpecificListScrollFrameScrollBar)
	LFDQueueFrameSpecificListScrollFrame:StripTextures()
	RaidBrowserFrame:HookScript('OnShow', function()
		if not LFRQueueFrameSpecificListScrollFrameScrollBar.skinned then
			HandleScrollBar(LFRQueueFrameSpecificListScrollFrameScrollBar)

			local roleButtons = {
				LFRQueueFrameRoleButtonHealer,
				LFRQueueFrameRoleButtonDPS,
				LFRQueueFrameRoleButtonTank,
			}

			LFRBrowseFrame:StripTextures()
			for _, roleButton in pairs(roleButtons) do
				roleButton:SetNormalTexture("")
				HandleCheckBox(roleButton.checkButton)
				roleButton:GetChildren():SetFrameLevel(roleButton:GetChildren():GetFrameLevel() + 1)
			end

			for i=1, 2 do
				local tab = _G['LFRParentFrameSideTab'..i]
				tab:DisableDrawLayer('BACKGROUND')

				tab:GetNormalTexture():SetTexCoord(unpack(F.TexCoords))
				tab:GetNormalTexture():SetInside()

				tab.pushed = true;
				tab:CreateBackdrop("Default")
				tab.backdrop:SetAllPoints()
				tab:StyleButton(true)
				hooksecurefunc(tab:GetHighlightTexture(), "SetTexture", function(self, texPath)
					if texPath ~= nil then
						self:SetTexture(nil);
					end
				end)

				hooksecurefunc(tab:GetCheckedTexture(), "SetTexture", function(self, texPath)
					if texPath ~= nil then
						self:SetTexture(nil);
					end
				end	)
			end

			for i=1, 7 do
				local tab = _G['LFRBrowseFrameColumnHeader'..i]
				tab:DisableDrawLayer('BACKGROUND')
			end

			HandleDropDownBox(LFRBrowseFrameRaidDropDown)
			HandleButton(LFRBrowseFrameRefreshButton)
			HandleButton(LFRBrowseFrameInviteButton)
			HandleButton(LFRBrowseFrameSendMessageButton)
			LFRQueueFrameSpecificListScrollFrameScrollBar.skinned = true
		end
	end)

	--[[LFGInvitePopup_Update("Elvz", true, true, true)
	StaticPopupSpecial_Show(LFGInvitePopup);]]
	LFGInvitePopup:StripTextures()
	LFGInvitePopup:SetTemplate("Transparent")
	HandleButton(LFGInvitePopupAcceptButton)
	HandleButton(LFGInvitePopupDeclineButton)

	HandleButton(_G[LFDQueueFrame.PartyBackfill:GetName().."BackfillButton"])
	HandleButton(_G[LFDQueueFrame.PartyBackfill:GetName().."NoBackfillButton"])
	HandleButton(_G[RaidFinderQueueFrame.PartyBackfill:GetName().."BackfillButton"])
	HandleButton(_G[RaidFinderQueueFrame.PartyBackfill:GetName().."NoBackfillButton"])
	HandleButton(_G[ScenarioQueueFrame.PartyBackfill:GetName().."BackfillButton"])
	HandleButton(_G[ScenarioQueueFrame.PartyBackfill:GetName().."NoBackfillButton"])
	LFDQueueFrameRandomScrollFrameScrollBar:StripTextures()
	ScenarioQueueFrameSpecificScrollFrame:StripTextures()
	HandleScrollBar(LFDQueueFrameRandomScrollFrameScrollBar)
	HandleScrollBar(ScenarioQueueFrameSpecificScrollFrameScrollBar)


	--LFGListFrame
	LFGListFrame.CategorySelection.Inset:StripTextures()
	HandleButton(LFGListFrame.CategorySelection.StartGroupButton, true)
	HandleButton(LFGListFrame.CategorySelection.FindGroupButton, true)

	LFGListFrame.EntryCreation.Inset:StripTextures()
	HandleButton(LFGListFrame.EntryCreation.CancelButton, true)
	HandleButton(LFGListFrame.EntryCreation.ListGroupButton, true)
	HandleEditBox(LFGListEntryCreationDescription)

	HandleEditBox(LFGListFrame.EntryCreation.Name)
	HandleEditBox(LFGListFrame.EntryCreation.ItemLevel.EditBox)
	HandleEditBox(LFGListFrame.EntryCreation.VoiceChat.EditBox)

	HandleDropDownBox(LFGListEntryCreationActivityDropDown)
	HandleDropDownBox(LFGListEntryCreationGroupDropDown)
	HandleDropDownBox(LFGListEntryCreationCategoryDropDown, 330)

	HandleCheckBox(LFGListFrame.EntryCreation.ItemLevel.CheckButton)
	HandleCheckBox(LFGListFrame.EntryCreation.VoiceChat.CheckButton)

	LFGListFrame.EntryCreation.ActivityFinder.Dialog:StripTextures()
	LFGListFrame.EntryCreation.ActivityFinder.Dialog:SetTemplate("Transparent")
	LFGListFrame.EntryCreation.ActivityFinder.Dialog.BorderFrame:StripTextures()
	LFGListFrame.EntryCreation.ActivityFinder.Dialog.BorderFrame:SetTemplate("Transparent")

	HandleEditBox(LFGListFrame.EntryCreation.ActivityFinder.Dialog.EntryBox)
	HandleScrollBar(LFGListEntryCreationSearchScrollFrameScrollBar)
	HandleButton(LFGListFrame.EntryCreation.ActivityFinder.Dialog.SelectButton)
	HandleButton(LFGListFrame.EntryCreation.ActivityFinder.Dialog.CancelButton)

	LFGListApplicationDialog:StripTextures()
	LFGListApplicationDialog:SetTemplate("Transparent")
	HandleButton(LFGListApplicationDialog.SignUpButton)
	HandleButton(LFGListApplicationDialog.CancelButton)
	HandleEditBox(LFGListApplicationDialogDescription)

	-- LFGListInviteDialog:StripTextures() -- Removes role icon, need to find a way to skin role icon the way it's done everywhere else
	LFGListInviteDialog:SetTemplate("Transparent")
	HandleButton(LFGListInviteDialog.AcknowledgeButton)
	HandleButton(LFGListInviteDialog.AcceptButton)
	HandleButton(LFGListInviteDialog.DeclineButton)


	HandleEditBox(LFGListFrame.SearchPanel.SearchBox)

	--[[local columns = {
		['Name'] = true,
		['Tank'] = true,
		['Healer'] = true,
		['Damager'] = true
	}

	for x, _ in pairs(columns) do
		LFGListFrame.SearchPanel[x.."ColumnHeader"].Left:Hide()
		LFGListFrame.SearchPanel[x.."ColumnHeader"].Middle:Hide()
		LFGListFrame.SearchPanel[x.."ColumnHeader"].Right:Hide()
	end]]

	HandleButton(LFGListFrame.SearchPanel.BackButton, true)
	HandleButton(LFGListFrame.SearchPanel.SignUpButton, true)
	HandleButton(LFGListSearchPanelScrollFrame.StartGroupButton,  true)
	LFGListFrame.SearchPanel.ResultsInset:StripTextures()
	HandleScrollBar(LFGListSearchPanelScrollFrameScrollBar)
	LFGListFrame.SearchPanel.AutoCompleteFrame:StripTextures()
	LFGListFrame.SearchPanel.AutoCompleteFrame:SetTemplate("Transparent")

	HandleButton(LFGListFrame.SearchPanel.RefreshButton)
	LFGListFrame.SearchPanel.RefreshButton:Size(26)


	--ApplicationViewer (Custom Groups)
	LFGListFrame.ApplicationViewer.InfoBackground:SetTexCoord(unpack(F.TexCoords))
	HandleCheckBox(LFGListFrame.ApplicationViewer.AutoAcceptButton)

	LFGListFrame.ApplicationViewer.Inset:StripTextures()
	LFGListFrame.ApplicationViewer.Inset:SetTemplate("Transparent")

	HandleButton(LFGListFrame.ApplicationViewer.NameColumnHeader, true)
	HandleButton(LFGListFrame.ApplicationViewer.RoleColumnHeader, true)
	HandleButton(LFGListFrame.ApplicationViewer.ItemLevelColumnHeader, true)
	LFGListFrame.ApplicationViewer.NameColumnHeader:ClearAllPoints()
	LFGListFrame.ApplicationViewer.NameColumnHeader:SetPoint("BOTTOMLEFT", LFGListFrame.ApplicationViewer.Inset, "TOPLEFT", 0, 1)
	LFGListFrame.ApplicationViewer.RoleColumnHeader:ClearAllPoints()
	LFGListFrame.ApplicationViewer.RoleColumnHeader:SetPoint("LEFT", LFGListFrame.ApplicationViewer.NameColumnHeader, "RIGHT", 1, 0)
	LFGListFrame.ApplicationViewer.ItemLevelColumnHeader:ClearAllPoints()
	LFGListFrame.ApplicationViewer.ItemLevelColumnHeader:SetPoint("LEFT", LFGListFrame.ApplicationViewer.RoleColumnHeader, "RIGHT", 1, 0)

	HandleButton(LFGListFrame.ApplicationViewer.RefreshButton)
	LFGListFrame.ApplicationViewer.RefreshButton:SetSize(24,24)
	LFGListFrame.ApplicationViewer.RefreshButton:ClearAllPoints()
	LFGListFrame.ApplicationViewer.RefreshButton:SetPoint("BOTTOMRIGHT", LFGListFrame.ApplicationViewer.Inset, "TOPRIGHT", 16, 4)

	HandleButton(LFGListFrame.ApplicationViewer.RemoveEntryButton, true)
	HandleButton(LFGListFrame.ApplicationViewer.EditButton, true)
	LFGListFrame.ApplicationViewer.RemoveEntryButton:ClearAllPoints()
	LFGListFrame.ApplicationViewer.RemoveEntryButton:SetPoint("BOTTOMLEFT", -1, 3)
	LFGListFrame.ApplicationViewer.EditButton:ClearAllPoints()
	LFGListFrame.ApplicationViewer.EditButton:SetPoint("BOTTOMRIGHT", -6, 3)

	HandleScrollBar(LFGListApplicationViewerScrollFrameScrollBar)
	LFGListApplicationViewerScrollFrameScrollBar:ClearAllPoints()
	LFGListApplicationViewerScrollFrameScrollBar:SetPoint("TOPLEFT", LFGListFrame.ApplicationViewer.Inset, "TOPRIGHT", 0, -14)
	LFGListApplicationViewerScrollFrameScrollBar:SetPoint("BOTTOMLEFT", LFGListFrame.ApplicationViewer.Inset, "BOTTOMRIGHT", 0, 14)
end

F.SkinFuncs['Blizzard_LookingForGuildUI'] = LoadSkin