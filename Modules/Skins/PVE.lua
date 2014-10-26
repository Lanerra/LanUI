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
	SkinButton(LFDQueueFramePartyBackfillBackfillButton)
	SkinButton(LFDQueueFramePartyBackfillNoBackfillButton)
	SkinButton(LFDQueueFrameRandomScrollFrameChildFrameBonusRepFrame.ChooseButton)
	SkinButton(ScenarioQueueFrameRandomScrollFrameChildFrameBonusRepFrame.ChooseButton)
	SkinScrollBar(ScenarioQueueFrameRandomScrollFrameScrollBar);
	
	GroupFinderFrameGroupButton1.icon:SetTexture("Interface\\Icons\\INV_Helmet_08")
	GroupFinderFrameGroupButton2.icon:SetTexture("Interface\\Icons\\inv_helmet_06")
	GroupFinderFrameGroupButton3.icon:SetTexture("Interface\\Icons\\Icon_Scenarios")
	
	LFGDungeonReadyDialogBackground:Kill()
	SkinButton(LFGDungeonReadyDialogEnterDungeonButton)
	SkinButton(LFGDungeonReadyDialogLeaveQueueButton)
	SkinCloseButton(LFGDungeonReadyDialogCloseButton)
	LFGDungeonReadyDialog:StripTextures()
	LFGDungeonReadyDialog:CreateBD()
	LFGDungeonReadyStatus:StripTextures()
	LFGDungeonReadyStatus:CreateBD()
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
			self:CreateBD()
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
	SkinCloseButton(LFGDungeonReadyStatusCloseButton)
	
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
		LFGInvitePopupRoleButtonDPS		
	}


	
	for _, roleButton in pairs(roleButtons) do
		SkinCheckBox(roleButton.checkButton, true)
		roleButton:DisableDrawLayer("ARTWORK")
		roleButton:DisableDrawLayer("OVERLAY")

		if(not roleButton.background and not roleButton:GetName():find("Leader")) then
			roleButton.background = roleButton:CreateTexture(nil, "BACKGROUND")
			roleButton.background:SetSize(80, 80)
			roleButton.background:SetPoint("CENTER")
			roleButton.background:SetTexture("Interface\\LFGFrame\\UI-LFG-ICONS-ROLEBACKGROUNDS")
			roleButton.background:SetAlpha(0.65)

			local buttonName = roleButton:GetName()
			roleButton.background:SetTexCoord(GetBackgroundTexCoordsForRole((buttonName:find("Tank") and "TANK") or (buttonName:find("Healer") and "HEALER") or "DAMAGER"))
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
		bu.border:CreateBD()
		bu.border.backdrop:SetOutside(bu.icon, 1, 1)
		bu.icon:SetParent(bu.border)
	end

	PVEFrame:SetTemplate()
	for i=1, 3 do
		SkinTab(_G['PVEFrameTab'..i])
	end
	PVEFrameTab1:SetPoint('BOTTOMLEFT', PVEFrame, 'BOTTOMLEFT', 19, -27)
	
	SkinCloseButton(PVEFrameCloseButton)

	-- raid finder
	SkinButton(LFDQueueFrameFindGroupButton, true)
	
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

	function HandleGoldIcon(button)
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
		SkinCheckBox(_G["LFDQueueFrameSpecificListButton"..i].enableButton)
	end
	
	hooksecurefunc("ScenarioQueueFrameSpecific_Update", function()
		
		for i = 1, NUM_SCENARIO_CHOICE_BUTTONS do
			local button = _G["ScenarioQueueFrameSpecificButton"..i]
			
			if button and not button.skinned then
				SkinCheckBox(button.enableButton)
				button.skinned = true;
			end
		end
	end)

	for i = 1, NUM_LFR_CHOICE_BUTTONS do
		local bu = _G["LFRQueueFrameSpecificListButton"..i].enableButton
		SkinCheckBox(bu)
	end

	SkinDropDownBox(LFDQueueFrameTypeDropDown)
	ScenarioQueueFrame:StripTextures()
	ScenarioFinderFrameInset:StripTextures()
	SkinButton(ScenarioQueueFrameFindGroupButton)


	-- Raid Finder
	RaidFinderFrame:StripTextures()
	RaidFinderFrameBottomInset:StripTextures()
	RaidFinderFrameRoleInset:StripTextures()
	RaidFinderFrameBottomInsetBg:Hide()
	RaidFinderFrameBtnCornerRight:Hide()
	RaidFinderFrameButtonBottomBorder:Hide()
	SkinDropDownBox(RaidFinderQueueFrameSelectionDropDown)
	RaidFinderFrameFindRaidButton:StripTextures()
	SkinButton(RaidFinderFrameFindRaidButton)
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
	SkinButton(ScenarioQueueFrameFindGroupButton)

	
	SkinDropDownBox(ScenarioQueueFrameTypeDropDown)

	-- Looking for raid
	LFRBrowseFrameListScrollFrame:StripTextures()

	LFRBrowseFrame:HookScript('OnShow', function()
		if not LFRBrowseFrameListScrollFrameScrollBar.skinned then
			SkinScrollBar(LFRBrowseFrameListScrollFrameScrollBar)
			LFRBrowseFrameListScrollFrameScrollBar.skinned = true
		end
	end)

	LFRBrowseFrameRoleInset:DisableDrawLayer("BORDER")
	RaidBrowserFrameBg:Hide()
	LFRQueueFrameSpecificListScrollFrameScrollBackgroundTopLeft:Hide()
	LFRQueueFrameSpecificListScrollFrameScrollBackgroundBottomRight:Hide()
	LFRBrowseFrameRoleInsetBg:Hide()
	LFRQueueFrameCommentScrollFrame:CreateBD()
	LFRBrowseFrameColumnHeader1:SetWidth(88) --Fix the columns being slightly off

	for i = 1, 14 do
		if i ~= 6 and i ~= 8 then
			select(i, RaidBrowserFrame:GetRegions()):Hide()
		end
	end

	RaidBrowserFrame:CreateBD()
	SkinCloseButton(RaidBrowserFrameCloseButton)
	SkinButton(LFRQueueFrameFindGroupButton)
	SkinButton(LFRQueueFrameAcceptCommentButton)
	
	SkinScrollBar(LFRQueueFrameCommentScrollFrameScrollBar)
	SkinScrollBar(LFDQueueFrameSpecificListScrollFrameScrollBar)
	LFDQueueFrameSpecificListScrollFrame:StripTextures()
	RaidBrowserFrame:HookScript('OnShow', function()
		if not LFRQueueFrameSpecificListScrollFrameScrollBar.skinned then
			SkinScrollBar(LFRQueueFrameSpecificListScrollFrameScrollBar)
			
			local roleButtons = {
				LFRQueueFrameRoleButtonHealer,
				LFRQueueFrameRoleButtonDPS,
				LFRQueueFrameRoleButtonTank,
			}
			
			LFRBrowseFrame:StripTextures()			
			for _, roleButton in pairs(roleButtons) do
				roleButton:SetNormalTexture("")
				SkinCheckBox(roleButton.checkButton)
				roleButton:GetChildren():SetFrameLevel(roleButton:GetChildren():GetFrameLevel() + 1)
			end
	
			for i=1, 2 do
				local tab = _G['LFRParentFrameSideTab'..i]		
				tab:DisableDrawLayer('BACKGROUND')
				
				tab:GetNormalTexture():SetTexCoord(unpack(F.TexCoords))
				tab:GetNormalTexture():SetInside()
				
				tab.pushed = true;
				tab:CreateBD()
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
			
			SkinDropDownBox(LFRBrowseFrameRaidDropDown)
			SkinButton(LFRBrowseFrameRefreshButton)
			SkinButton(LFRBrowseFrameInviteButton)
			SkinButton(LFRBrowseFrameSendMessageButton)
			LFRQueueFrameSpecificListScrollFrameScrollBar.skinned = true
		end
	end)
	
	--[[LFGInvitePopup_Update("Elvz", true, true, true)
	StaticPopupSpecial_Show(LFGInvitePopup);]]
	LFGInvitePopup:StripTextures()
	LFGInvitePopup:CreateBD()
	SkinButton(LFGInvitePopupAcceptButton)
	SkinButton(LFGInvitePopupDeclineButton)
	
	SkinButton(_G[LFDQueueFrame.PartyBackfill:GetName().."BackfillButton"])
	SkinButton(_G[LFDQueueFrame.PartyBackfill:GetName().."NoBackfillButton"])
	SkinButton(_G[RaidFinderQueueFrame.PartyBackfill:GetName().."BackfillButton"])
	SkinButton(_G[RaidFinderQueueFrame.PartyBackfill:GetName().."NoBackfillButton"])
	SkinButton(_G[ScenarioQueueFrame.PartyBackfill:GetName().."BackfillButton"])
	SkinButton(_G[ScenarioQueueFrame.PartyBackfill:GetName().."NoBackfillButton"])
	LFDQueueFrameRandomScrollFrameScrollBar:StripTextures()
	ScenarioQueueFrameSpecificScrollFrame:StripTextures()
	SkinScrollBar(LFDQueueFrameRandomScrollFrameScrollBar)
	SkinScrollBar(ScenarioQueueFrameSpecificScrollFrameScrollBar)


	--LFGListFrame
	LFGListFrame.CategorySelection.Inset:StripTextures()
	SkinButton(LFGListFrame.CategorySelection.StartGroupButton, true)
	SkinButton(LFGListFrame.CategorySelection.FindGroupButton, true)

	LFGListFrame.EntryCreation.Inset:StripTextures()
	SkinButton(LFGListFrame.EntryCreation.CancelButton, true)
	SkinButton(LFGListFrame.EntryCreation.ListGroupButton, true)
	SkinEditBox(LFGListEntryCreationDescription)

	SkinEditBox(LFGListFrame.EntryCreation.Name)
	SkinEditBox(LFGListFrame.EntryCreation.ItemLevel.EditBox)
	SkinEditBox(LFGListFrame.EntryCreation.VoiceChat.EditBox)

	SkinDropDownBox(LFGListEntryCreationActivityDropDown)
	SkinDropDownBox(LFGListEntryCreationGroupDropDown)
	SkinDropDownBox(LFGListEntryCreationCategoryDropDown, 330)

	SkinCheckBox(LFGListFrame.EntryCreation.ItemLevel.CheckButton)
	SkinCheckBox(LFGListFrame.EntryCreation.VoiceChat.CheckButton)

	LFGListFrame.EntryCreation.ActivityFinder.Dialog:StripTextures()
	LFGListFrame.EntryCreation.ActivityFinder.Dialog:CreateBD()
	LFGListFrame.EntryCreation.ActivityFinder.Dialog.BorderFrame:StripTextures()
	LFGListFrame.EntryCreation.ActivityFinder.Dialog.BorderFrame:CreateBD()

	SkinEditBox(LFGListFrame.EntryCreation.ActivityFinder.Dialog.EntryBox)
	SkinScrollBar(LFGListEntryCreationSearchScrollFrameScrollBar)
	SkinButton(LFGListFrame.EntryCreation.ActivityFinder.Dialog.SelectButton)
	SkinButton(LFGListFrame.EntryCreation.ActivityFinder.Dialog.CancelButton)

	SkinEditBox(LFGListFrame.SearchPanel.SearchBox)

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

	SkinButton(LFGListFrame.SearchPanel.BackButton, true)
	SkinButton(LFGListFrame.SearchPanel.SignUpButton, true)
	LFGListFrame.SearchPanel.ResultsInset:StripTextures()
	SkinScrollBar(LFGListSearchPanelScrollFrameScrollBar)
	LFGListFrame.SearchPanel.AutoCompleteFrame:StripTextures()
	LFGListFrame.SearchPanel.AutoCompleteFrame:CreateBD()

	SkinButton(LFGListFrame.SearchPanel.RefreshButton)
	LFGListFrame.SearchPanel.RefreshButton:Size(26)
end

tinsert(F.SkinFuncs['LanUI'], LoadSkin)

local function LoadSecondarySkin()
	ChallengesFrameInset:StripTextures()
	ChallengesFrameInsetBg:Hide()
	ChallengesFrameDetails.bg:Hide()

	SkinButton(ChallengesFrameLeaderboard, true)
	select(2, ChallengesFrameDetails:GetRegions()):Hide()
	select(9, ChallengesFrameDetails:GetRegions()):Hide()
	select(10, ChallengesFrameDetails:GetRegions()):Hide()
	select(11, ChallengesFrameDetails:GetRegions()):Hide()
	ChallengesFrameDungeonButton1:SetPoint("TOPLEFT", ChallengesFrame, "TOPLEFT", 8, -83)

	for i = 1, 8 do
		local bu = ChallengesFrame["button"..i]
		SkinButton(bu)
		bu:StyleButton()
		bu:SetHighlightTexture("")
		bu.selectedTex:SetAlpha(.2)
		bu.selectedTex:SetPoint("TOPLEFT", 1, -1)
		bu.selectedTex:SetPoint("BOTTOMRIGHT", -1, 1)
		bu.NoMedal:Kill()
	end

	for i = 1, 3 do
		local rewardsRow = ChallengesFrame["RewardRow"..i]
		for j = 1, 2 do
			local bu = rewardsRow["Reward"..j]
			bu:CreateBD()
			bu.Icon:SetTexCoord(unpack(F.TexCoords))
		end
	end
end

F.SkinFuncs['Blizzard_ChallengesUI'] = LoadSecondarySkin