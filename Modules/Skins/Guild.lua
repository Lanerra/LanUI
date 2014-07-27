local F, C, G = unpack(select(2, ...))
local bc = C.Media.BorderColor

local function LoadSkin()
	GuildFrame:StripTextures(true)
	GuildFrame:SetTemplate()
	GuildLevelFrame:Kill()
	
	GuildMemberDetailCloseButton:SkinCloseButton()
	GuildFrameCloseButton:SkinCloseButton()
	
	local striptextures = {
		'GuildNewPerksFrame',
		'GuildFrameInset',
		'GuildFrameBottomInset',
		'GuildAllPerksFrame',
		'GuildMemberDetailFrame',
		'GuildMemberNoteBackground',
		'GuildInfoFrameInfo',
		'GuildLogContainer',
		'GuildLogFrame',
		'GuildRewardsFrame',
		'GuildMemberOfficerNoteBackground',
		'GuildTextEditContainer',
		'GuildTextEditFrame',
		'GuildRecruitmentRolesFrame',
		'GuildRecruitmentAvailabilityFrame',
		'GuildRecruitmentInterestFrame',
		'GuildRecruitmentLevelFrame',
		'GuildRecruitmentCommentFrame',
		'GuildRecruitmentCommentInputFrame',
		'GuildInfoFrameApplicantsContainer',
		'GuildInfoFrameApplicants',
		'GuildNewsBossModel',
		'GuildNewsBossModelTextFrame',
		'GuildInfoFrameApplicantsContainerScrollBar',
	}
	GuildRewardsFrameVisitText:ClearAllPoints()
	GuildRewardsFrameVisitText:SetPoint('TOP', GuildRewardsFrame, 'TOP', 0, 30)
	for _, frame in pairs(striptextures) do
		_G[frame]:StripTextures()
	end
	
	GuildNewsBossModel:CreateBD(true)
	GuildNewsBossModelTextFrame:CreateBD(true)
	GuildNewsBossModelTextFrame.backdrop:Point('TOPLEFT', GuildNewsBossModel.backdrop, 'BOTTOMLEFT', 0, -1)
	GuildNewsBossModel:Point('TOPLEFT', GuildFrame, 'TOPRIGHT', 4, -43)
	
	local buttons = {
		'GuildMemberRemoveButton',
		'GuildMemberGroupInviteButton',
		'GuildAddMemberButton',
		'GuildViewLogButton',
		'GuildControlButton',
		'GuildRecruitmentListGuildButton',
		'GuildTextEditFrameAcceptButton',
		'GuildRecruitmentInviteButton',
		'GuildRecruitmentMessageButton',
		'GuildRecruitmentDeclineButton',
	}
	
	for i, button in pairs(buttons) do
		if i == 1 then
			_G[button]:SkinButton()
		else
			_G[button]:SkinButton(true)
		end
	end
	
	GuildPerksToggleButton:StripTextures()
	GuildPerksToggleButton:SkinButton()
	
	local checkbuttons = {
		'Quest', 
		'Dungeon',
		'Raid',
		'PvP',
		'RP',
		'Weekdays',
		'Weekends',
		'LevelAny',
		'LevelMax',
	}
	
	for _, frame in pairs(checkbuttons) do
		_G['GuildRecruitment'..frame..'Button']:SkinCheckBox()
	end
	
	GuildRecruitmentTankButton:GetChildren():SkinCheckBox()
	GuildRecruitmentHealerButton:GetChildren():SkinCheckBox()
	GuildRecruitmentDamagerButton:GetChildren():SkinCheckBox()
	
	GuildXPFrame:ClearAllPoints()
	GuildXPFrame:Point('TOP', GuildFrame, 'TOP', 0, -40)
	
	GuildPerksContainerScrollBar:SkinScrollBar()
	
	GuildFactionBar:StripTextures()
	GuildFactionBar.progress:SetTexture(C.Media.StatusBar)
	GuildFactionBar.progress:SetSize(180, 16)
	GuildFactionBar:CreateBD(true)
	GuildFactionBar.backdrop:SetOutside()
	GuildFactionBar.backdrop:SetBeautyBorderPadding(2)
	GuildFactionBar.backdrop:Point('TOPLEFT', GuildFactionBar, 'TOPLEFT', -1, -1)
	GuildFactionBar.backdrop:Point('BOTTOMRIGHT', GuildFactionBar, 'BOTTOMRIGHT', -1, -1)
	
	GuildXPBar:StripTextures()
	GuildXPBarLeft:Kill()
	GuildXPBarRight:Kill()
	GuildXPBarMiddle:Kill()
	GuildXPBarBG:Kill()
	GuildXPBarShadow:Kill()
	GuildXPBarCap:Kill()
	GuildXPBar.progress:SetTexture(C.Media.StatusBar)
	GuildXPBar:CreateBD(true)
	GuildXPBar.backdrop:Point('TOPLEFT', GuildXPBar.progress, 'TOPLEFT', -1, 2)
	GuildXPBar.backdrop:Point('BOTTOMRIGHT', GuildXPBar, 'BOTTOMRIGHT', -1, 0)
	
	GuildLatestPerkButton:StripTextures()
	GuildLatestPerkButtonIconTexture:SetTexCoord(.08, .92, .08, .92)
	GuildLatestPerkButtonIconTexture:ClearAllPoints()
	GuildLatestPerkButtonIconTexture:Point('TOPLEFT', 2, -2)
	GuildLatestPerkButton:CreateBD(true)
	GuildLatestPerkButton.backdrop:Point('TOPLEFT', GuildLatestPerkButtonIconTexture, 'TOPLEFT', -2, 2)
	GuildLatestPerkButton.backdrop:Point('BOTTOMRIGHT', GuildLatestPerkButtonIconTexture, 'BOTTOMRIGHT', 2, -2)
	
	GuildNextPerkButton:StripTextures()
	GuildNextPerkButtonIconTexture:SetTexCoord(.08, .92, .08, .92)
	GuildNextPerkButtonIconTexture:ClearAllPoints()
	GuildNextPerkButtonIconTexture:Point('TOPLEFT', 2, -2)
	GuildNextPerkButton:CreateBD(true)
	GuildNextPerkButton.backdrop:Point('TOPLEFT', GuildNextPerkButtonIconTexture, 'TOPLEFT', -2, 2)
	GuildNextPerkButton.backdrop:Point('BOTTOMRIGHT', GuildNextPerkButtonIconTexture, 'BOTTOMRIGHT', 2, -2)
	
	--Guild Perk buttons list
	for i=1, 8 do
		local button = _G['GuildPerksContainerButton'..i]
		button:StripTextures()
		
		if button.icon then
			button.icon:SetTexCoord(.08, .92, .08, .92)
			button.icon:ClearAllPoints()
			button.icon:Point('TOPLEFT', 2, -2)
			button:CreateBD(true)
			button.backdrop:Point('TOPLEFT', button.icon, 'TOPLEFT', -2, 2)
			button.backdrop:Point('BOTTOMRIGHT', button.icon, 'BOTTOMRIGHT', 2, -2)
			button.icon:SetParent(button.backdrop)
		end
	end
	
	--Roster
	GuildRosterContainerScrollBar:SkinScrollBar()
	GuildRosterShowOfflineButton:SkinCheckBox()
	
	
	for i=1, 4 do
		_G['GuildRosterColumnButton'..i]:StripTextures(true)
	end
	
	GuildRosterViewDropdown:SkinDropDownBox(200)
	
	for i=1, 14 do
		_G['GuildRosterContainerButton'..i..'HeaderButton']:SkinButton(true)
	end
	
	--Detail Frame
	GuildMemberDetailFrame:SetTemplate()
	GuildMemberNoteBackground:SetTemplate(true)
	GuildMemberOfficerNoteBackground:SetTemplate(true)
	GuildMemberRankDropdown:SetFrameLevel(GuildMemberRankDropdown:GetFrameLevel() + 5)
	GuildMemberRankDropdown:SkinDropDownBox(175)

	--News
	GuildNewsFrame:StripTextures()
	for i=1, 17 do
		_G['GuildNewsContainerButton'..i].header:Kill()
	end
	
	GuildNewsFiltersFrame:StripTextures()
	GuildNewsFiltersFrame:SetTemplate()
	GuildNewsFiltersFrameCloseButton:SkinCloseButton()
	
	for i=1, 7 do
		_G['GuildNewsFilterButton'..i]:SkinCheckBox()
	end
	
	GuildNewsFiltersFrame:Point('TOPLEFT', GuildFrame, 'TOPRIGHT', 4, -20)
	GuildNewsContainerScrollBar:SkinScrollBar()
	
	--Info Frame
	GuildInfoDetailsFrameScrollBar:SkinScrollBar()
	GuildInfoFrameApplicantsContainerScrollBar:SkinScrollBar()
	GuildInfoFrameInfoMOTDScrollFrameScrollBar:SkinScrollBar()
	
	for i=1, 3 do
		_G['GuildInfoFrameTab'..i]:StripTextures()
	end
		
	GuildRecruitmentCommentInputFrame:SetTemplate()
	
	for _, button in next, GuildInfoFrameApplicantsContainer.buttons do
		button.selectedTex:Kill()
		button:GetHighlightTexture():Kill()
		button:SetBackdrop(nil)
	end
	
	--Text Edit Frame
	GuildTextEditFrame:SetTemplate()
	GuildTextEditScrollFrameScrollBar:SkinScrollBar()
	GuildTextEditContainer:SetTemplate(true)
	for i = 1, GuildTextEditFrame:GetNumChildren() do
		local child = select(i, GuildTextEditFrame:GetChildren())
		local point = select(1, child:GetPoint())
		if point == 'TOPRIGHT' then
			child:SkinCloseButton()
		else
			child:SkinButton(true)
		end
	end

	--Guild Log
	GuildLogScrollFrameScrollBar:SkinScrollBar()
	GuildLogFrame:SetTemplate()

	for i = 1, GuildLogFrame:GetNumChildren() do
		local child = select(i, GuildLogFrame:GetChildren())
		local point = select(1, child:GetPoint())
		if point == 'TOPRIGHT' then
			child:SkinCloseButton()
		else
			child:SkinButton(true)
		end
	end
	
	--Rewards
	GuildRewardsContainerScrollBar:SkinScrollBar()
	
	for i=1, 8 do
		local button = _G['GuildRewardsContainerButton'..i]
		button:StripTextures()
		
		if button.icon then
			button.icon:SetTexCoord(.08, .92, .08, .92)
			button.icon:ClearAllPoints()
			button.icon:Point('TOPLEFT', 2, -2)
			button:CreateBD(true)
			button.backdrop:Point('TOPLEFT', button.icon, 'TOPLEFT', -2, 2)
			button.backdrop:Point('BOTTOMRIGHT', button.icon, 'BOTTOMRIGHT', 2, -2)
			button.icon:SetParent(button.backdrop)
		end
	end
	
	for i=1,5 do
		_G['GuildFrameTab'..i]:SkinTab()
		
		GuildFrameTab1:Point('BOTTOMLEFT', GuildFrame, 5, -29)
		if i ~= 1 then
			_G['GuildFrameTab'..i]:Point('LEFT', _G['GuildFrameTab'..i - 1], 'RIGHT', 4, 0)
		end
		_G['GuildFrameTab'..i].SetPoint = F.Dummy

		_G['GuildFrameTab'..i]:SetWidth(56)
		_G['GuildFrameTab'..i].SetWidth = F.Dummy
		_G['GuildFrameTab'..i].SetSize = F.Dummy
	end
end

F.SkinFuncs['Blizzard_GuildUI'] = LoadSkin

local function LoadSecondarySkin()
	GuildInviteFrame:StripTextures()
	GuildInviteFrame:SetTemplate()
	GuildInviteFrameDeclineButton:StripTextures()
	GuildInviteFrameDeclineButton:SkinButton()
	GuildInviteFrameJoinButton:StripTextures()
	GuildInviteFrameJoinButton:SkinButton()
end

tinsert(F.SkinFuncs['LanUI'], LoadSecondarySkin)