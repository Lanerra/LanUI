--[[
Contains changes to the default appearance of Blizzard Frames. This could get pretty nasty...
--]]


-- Functions all up in this mother fucker!

local c = LanFunc.playerColor

LanSkin = {
	['Backdrop'] = LanConfig.Media.Backdrop,
	['Glow'] = 'Interface\\AddOns\\LanUI\\Media\\glowTex',
}

LanSkin.CreateBD = function(f, a)
    if not f then
        if f.SetBackdrop then
            f:SetBackdrop({
                bgFile = LanSkin.Backdrop,
            })
            f:SetBackdropColor(0, 0, 0, a or .75)
            f:SetBackdropBorderColor(0, 0, 0)
            
            f:CreateBeautyBorder(12, 1, 1, 1, 1, 2, 2, 2, 1, 1, 2, 1)
        else
            return
        end
    end
end

LanSkin.CreateSD = function(parent, size, r, g, b, alpha, offset)
	local sd = CreateFrame('Frame', nil, parent)
	sd:SetBackdrop({
		edgeFile = LanSkin.Glow,
	})
	sd:SetBackdropBorderColor(0, 0, 0)
	sd:SetAlpha(0)
	
    sd:CreateBeautyBorder(12, 1, 1, 1, 1, 2, 2, 2, 1, 1, 2, 1)
end

LanSkin.CreatePulse = function(frame, speed, mult, alpha) -- pulse function originally by nightcracker
	frame.speed = speed or .05
	frame.mult = mult or 1
	frame.alpha = alpha or 1
	frame.tslu = 0 -- time since last update
	frame:SetScript('OnUpdate', function(self, elapsed)
		self.tslu = self.tslu + elapsed
		if self.tslu > self.speed then
			self.tslu = 0
			self:SetAlpha(self.alpha)
		end
		self.alpha = self.alpha - elapsed*self.mult
		if self.alpha < 0 and self.mult > 0 then
			self.mult = self.mult*-1
			self.alpha = 0
		elseif self.alpha > 1 and self.mult < 0 then
			self.mult = self.mult*-1
		end
	end)
end

LanSkin.CreateTab = function(f)
	local sd = CreateFrame('Frame', nil, f)
	sd:SetBackdrop({
		bgFile = LanSkin.Backdrop,
	})
	sd:SetPoint('TOPLEFT', 13, 0)
	sd:SetPoint('BOTTOMRIGHT', -10, 0)
	sd:SetBackdropColor(unpack(LanConfig.Media.BackdropColor))
	sd:SetBackdropBorderColor(0, 0, 0)
	sd:SetFrameStrata('LOW')
	
	sd:CreateBeautyBorder(12, 1, 1, 1, 1, 1, 1, 1, 1, -1, 1, -1)
end

LanSkin.Reskin = function(f)
	local glow = CreateFrame('Frame', nil, f)
	
	glow:SetBackdrop({
		edgeFile = LanSkin.Glow,
		edgeSize = 9,
	})
	glow:SetPoint('TOPLEFT', f, -6, 6)
	glow:SetPoint('BOTTOMRIGHT', f, 6, -6)
	glow:SetBackdropBorderColor(c.r, c.g, c.b)
	glow:SetAlpha(0)
	
    f:CreateBeautyBorder(12, r, g, b)
	
	f:SetBeautyBorderColor(1, 1, 1)
	
	f:SetNormalTexture('')
	f:SetHighlightTexture('')
	f:SetPushedTexture('')
	f:SetDisabledTexture('')

	LanSkin.CreateBD(f, .25)

	f:HookScript('OnEnter', function(self)
        self:SetBackdropBorderColor(c.r, c.g, c.b)
        self:SetBackdropColor(c.r*0.5, c.g*0.5, c.b*0.5, 0.8)
        LanSkin.CreatePulse(glow)
    end)
 	
    f:HookScript('OnLeave', function(self)
        self:SetBackdropBorderColor(0, 0, 0)
        self:SetBackdropColor(unpack(LanConfig.Media.BackdropColor))
        glow:SetScript('OnUpdate', nil)
        glow:SetAlpha(0)
    end)
end

local Skin = CreateFrame('Frame', nil, UIParent)
local _, class = UnitClass('player')

Skin:RegisterEvent('ADDON_LOADED')
Skin:SetScript('OnEvent', function(self, event, addon)	
	if addon == 'LanUI' then
		-- [[ Headers ]]
		
		local header = {
            'GameMenuFrame',
            'InterfaceOptionsFrame',
            'AudioOptionsFrame',
            'VideoOptionsFrame',
            'ChatConfigFrame',
            'ColorPickerFrame'
        }
        
		for i = 1, getn(header) do
            local title = _G[header[i]..'Header']
			if title then
				title:SetTexture('')
				title:ClearAllPoints()
				if title == _G['GameMenuFrameHeader'] then
					title:SetPoint('TOP', GameMenuFrame, 0, 7)
				else
					title:SetPoint('TOP', header[i], 0, 0)
				end
			end
		end

		-- [[ Simple backdrops ]]

		local skins = {
            'AutoCompleteBox',
            'BNToastFrame',
            'TicketStatusFrameButton',
            'DropDownList1Backdrop',
            'DropDownList2Backdrop',
            'DropDownList1MenuBackdrop',
            'DropDownList2MenuBackdrop',
            'FriendsTooltip',
            'GhostFrame',
            'GhostFrameContentsFrame',
            'DropDownList1MenuBackdrop',
            'DropDownList2MenuBackdrop',
            'DropDownList1Backdrop',
            'DropDownList2Backdrop',
            'GearManagerDialogPopup'
        }

		for i = 1, getn(skins) do
			LanSkin.CreateBD(_G[skins[i]])
		end

		local shadowskins = {
            'StaticPopup1',
            'StaticPopup2',
            'GameMenuFrame',
            'InterfaceOptionsFrame',
            'VideoOptionsFrame',
            'AudioOptionsFrame',
            'ChatConfigFrame',
            'SpellBookFrame',
            'CharacterFrame',
            'WorldStateScoreFrame',
            'StackSplitFrame',
            'AddFriendFrame',
            'FriendsFriendsFrame',
            'ColorPickerFrame',
            'ReadyCheckFrame',
            'PetStableFrame',
            'ReputationDetailFrame',
            'LFDRoleCheckPopup',
            'RaidInfoFrame',
            'RolePollPopup',
            'LFDParentFrame'
        }

		for i = 1, getn(shadowskins) do
			LanSkin.CreateBD(_G[shadowskins[i]])
			LanSkin.CreateSD(_G[shadowskins[i]])
		end

		local simplebds = {
            'SpellBookCompanionModelFrame',
            'ChatConfigCategoryFrame',
            'ChatConfigBackgroundFrame',
            'ChatConfigChatSettingsLeft',
            'ChatConfigChatSettingsClassColorLegend',
            'ChatConfigChannelSettingsLeft',
            'ChatConfigChannelSettingsClassColorLegend',
            'FriendsFriendsList',
            'QuestLogCount',
            'FriendsFrameBroadcastInput',
            'HelpFrameKnowledgebaseSearchBox',
            'HelpFrameTicketScrollFrame'
        }
		
		for i = 1, getn(simplebds) do
			local simplebd = _G[simplebds[i]]
			if simplebd then LanSkin.CreateBD(simplebd, .25) end
		end
		
        for i = 1, 5 do
			local tab = _G['SpellBookSkillLineTab'..i]
			local a1, p, a2, x, y = tab:GetPoint()
			local bg = CreateFrame('Frame', nil, tab)
			bg:SetPoint('TOPLEFT', -1, 1)
			bg:SetPoint('BOTTOMRIGHT', 1, -1)
			bg:SetFrameLevel(tab:GetFrameLevel()-1)
			tab:SetPoint(a1, p, a2, x + 11, y)
			LanSkin.CreateSD(tab, 5, 0, 0, 0, 1, 1)
			LanSkin.CreateBD(bg, 1)
			
			select(3, tab:GetRegions()):SetTexCoord(.08, .92, .08, .92)
			select(4, tab:GetRegions()):SetTexCoord(.08, .92, .08, .92)
		end
    
		-- [[ Backdrop frames ]]

		FriendsBD = CreateFrame('Frame', nil, FriendsFrame)
		FriendsBD:SetPoint('TOPLEFT', 10, -30)
		FriendsBD:SetPoint('BOTTOMRIGHT', -34, 76)

		QFBD = CreateFrame('Frame', nil, QuestFrame)
		QFBD:SetPoint('TOPLEFT', 6, -15)
		QFBD:SetPoint('BOTTOMRIGHT', -26, 64)
		QFBD:SetFrameLevel(QuestFrame:GetFrameLevel()-1)
        
        QNBD = CreateFrame('Frame', nil, QuestNPCModel)
        QNBD:SetPoint('TOPLEFT', QuestNPCModel, -4, 4)
        QNBD:SetPoint('BOTTOMRIGHT', QuestNPCModelTextFrame, 4, 0)
        QNBD:SetFrameLevel(QuestNPCModel:GetFrameLevel()-1)

		GossipBD = CreateFrame('Frame', nil, GossipFrame)
		GossipBD:SetPoint('TOPLEFT', 6, -15)
		GossipBD:SetPoint('BOTTOMRIGHT', -26, 64)

		MerchBD = CreateFrame('Frame', nil, MerchantFrame)
		MerchBD:SetPoint('TOPLEFT', 10, -10)
		MerchBD:SetPoint('BOTTOMRIGHT', -34, 61)
		MerchBD:SetFrameLevel(MerchantFrame:GetFrameLevel()-1)

		MailBD = CreateFrame('Frame', nil, MailFrame)
		MailBD:SetPoint('TOPLEFT', 10, -12)
		MailBD:SetPoint('BOTTOMRIGHT', -34, 73)

		OMailBD = CreateFrame('Frame', nil, OpenMailFrame)
		OMailBD:SetPoint('TOPLEFT', 10, -12)
		OMailBD:SetPoint('BOTTOMRIGHT', -34, 73)
		OMailBD:SetFrameLevel(OpenMailFrame:GetFrameLevel()-1)

		DressBD = CreateFrame('Frame', nil, DressUpFrame)
		DressBD:SetPoint('TOPLEFT', 10, -10)
		DressBD:SetPoint('BOTTOMRIGHT', -30, 72)
		DressBD:SetFrameLevel(DressUpFrame:GetFrameLevel()-1)

		TaxiBD = CreateFrame('Frame', nil, TaxiFrame)
		TaxiBD:SetPoint('TOPLEFT', 3, -23)
		TaxiBD:SetPoint('BOTTOMRIGHT', -5, 3)
		TaxiBD:SetFrameStrata('LOW')
		TaxiBD:SetFrameLevel(TaxiFrame:GetFrameLevel()-1)

		TradeBD = CreateFrame('Frame', nil, TradeFrame)
		TradeBD:SetPoint('TOPLEFT', 10, -12)
		TradeBD:SetPoint('BOTTOMRIGHT', -30, 52)
		TradeBD:SetFrameLevel(TradeFrame:GetFrameLevel()-1)

		ItemBD = CreateFrame('Frame', nil, ItemTextFrame)
		ItemBD:SetPoint('TOPLEFT', 16, -8)
		ItemBD:SetPoint('BOTTOMRIGHT', -28, 62)
		ItemBD:SetFrameLevel(ItemTextFrame:GetFrameLevel()-1)

		TabardBD = CreateFrame('Frame', nil, TabardFrame)
		TabardBD:SetPoint('TOPLEFT', 16, -8)
		TabardBD:SetPoint('BOTTOMRIGHT', -28, 76)
		TabardBD:SetFrameLevel(TabardFrame:GetFrameLevel()-1)
        
        GMBD = CreateFrame('Frame', nil, HelpFrame)
		GMBD:SetPoint('TOPLEFT')
		GMBD:SetPoint('BOTTOMRIGHT')
		GMBD:SetFrameLevel(HelpFrame:GetFrameLevel()-1)

		local FrameBDs = {
            'FriendsBD',
            'QFBD',
            'QNBD',
            'GossipBD',
            'MerchBD',
            'MailBD',
            'OMailBD',
            'DressBD',
            'TaxiBD',
            'TradeBD',
            'ItemBD',
            'TabardBD',
            'GMBD',
        }
        
		for i = 1, getn(FrameBDs) do
			FrameBD = _G[FrameBDs[i]]
			if FrameBD then
				LanSkin.CreateBD(FrameBD)
				LanSkin.CreateSD(FrameBD)
			end
		end

        local line = CreateFrame('Frame', nil, QuestNPCModel)
		line:SetPoint('BOTTOMLEFT', 0, -1)
		line:SetPoint('BOTTOMRIGHT', 0, -1)
		line:SetHeight(1)
		line:SetFrameLevel(QuestNPCModel:GetFrameLevel()-1)
		LanSkin.CreateBD(line, 0)

		if class == 'HUNTER' or class == 'MAGE' or class == 'DEATHKNIGHT' or class == 'WARLOCK' then
			if class == 'HUNTER' then
				for i = 1, 10 do
					local bd = CreateFrame('Frame', nil, _G['PetStableStabledPet'..i])
					bd:SetPoint('TOPLEFT', -1, 1)
					bd:SetPoint('BOTTOMRIGHT', 1, -1)
					LanSkin.CreateBD(bd)
					bd:SetBackdropColor(0, 0, 0, 0)
					_G['PetStableStabledPet'..i]:SetNormalTexture('')
					_G['PetStableStabledPet'..i]:GetRegions():SetTexCoord(.08, .92, .08, .92)
				end
			end

			PetModelFrameShadowOverlay:Hide()
		end
		
        PaperDollSidebarTab3:HookScript('OnClick', function()
			for i = 1, 8 do
				local bu = _G['PaperDollEquipmentManagerPaneButton'..i]
				local bd = select(4, bu:GetRegions())
				local ic = select(9, bu:GetRegions())

				bd:Hide()
				bd.Show = LanFunc.dummy
				ic:SetTexCoord(.08, .92, .08, .92)

				local f = CreateFrame('Frame', nil, bu)
				f:SetPoint('TOPLEFT', ic, -1, 1)
				f:SetPoint('BOTTOMRIGHT', ic, 1, -1)
				f:SetFrameLevel(bu:GetFrameLevel()-1)
				LanSkin.CreateBD(f, 0)
			end
		end)

		GhostFrameContentsFrameIcon:SetTexCoord(.08, .92, .08, .92)

		local GhostBD = CreateFrame('Frame', nil, GhostFrameContentsFrame)
		GhostBD:SetPoint('TOPLEFT', GhostFrameContentsFrameIcon, -1, 1)
		GhostBD:SetPoint('BOTTOMRIGHT', GhostFrameContentsFrameIcon, 1, -1)
		LanSkin.CreateBD(GhostBD, 0)

		-- [[ Hide regions ]]

		CharacterFramePortrait:Hide()
		for i = 1, 5 do
			select(i, CharacterModelFrame:GetRegions()):Hide()
		end
		for i = 1, 3 do
			select(i, QuestLogFrame:GetRegions()):Hide()
		end
		QuestLogDetailFrame:GetRegions():Hide()
		QuestFramePortrait:Hide()
		GossipFramePortrait:Hide()

        LanFunc.StripTextures(QuestLogDetailFrame)
        QuestLogDetailFrameInset:Hide()
        LanFunc.Skin(QuestLogDetailFrame, 12)
        
		LanFunc.Skin(QuestLogFrame, 12)
        LanFunc.StripTextures(QuestLogScrollFrame)
        LanFunc.StripTextures(QuestLogDetailScrollFrame)
        LanFunc.StripTextures(QuestLogFrameInset)
        LanFunc.StripTextures(QuestNPCModel)
        LanFunc.StripTextures(QuestNPCModelTextFrame)
        LanFunc.Skin(QNBD, 12)
		--GossipFrame:GetRegions():Hide()
		for i = 1, 6 do
			for j = 1, 3 do
				select(i, _G['FriendsTabHeaderTab'..j]:GetRegions()):Hide()
				select(i, _G['FriendsTabHeaderTab'..j]:GetRegions()).Show = LanFunc.dummy
			end
		end
		FriendsFrameTitleText:Hide()
		SpellBookFramePortrait:Hide()
-- 		LanFunc.Skin(PVPUIFrame, 12)

		for i = 1, 5 do
			select(i, MailFrame:GetRegions()):Hide()
		end
		OpenMailFrameIcon:Hide()
		OpenMailHorizontalBarLeft:Hide()

		--OpenMailFrame:GetRegions():Hide()
		--select(12, OpenMailFrame:GetRegions()):Hide()
		select(13, OpenMailFrame:GetRegions()):Hide()
		OpenStationeryBackgroundLeft:Hide()
		OpenStationeryBackgroundRight:Hide()
		for i = 4, 7 do
			select(i, SendMailFrame:GetRegions()):Hide()
		end
		SendStationeryBackgroundLeft:Hide()
		SendStationeryBackgroundRight:Hide()
		MerchantFramePortrait:Hide()
		DressUpFramePortrait:Hide()

		--MerchantFrame:GetRegions():Hide()
		--DressUpFrame:GetRegions():Hide()
		select(2, DressUpFrame:GetRegions()):Hide()
		for i = 8, 11 do
			select(i, DressUpFrame:GetRegions()):Hide()
		end
		TradeFrameRecipientPortrait:Hide()
		TradeFramePlayerPortrait:Hide()
		--TradeFrame:GetRegions():Hide()

		for i = 1, 4 do
			select(i, GearManagerDialogPopup:GetRegions()):Hide()
		end
		StackSplitFrame:GetRegions():Hide()
		ItemTextFrame:GetRegions():Hide()
		ItemTextScrollFrameMiddle:Hide()
		PetStableFramePortrait:Hide()
		ReputationDetailCorner:Hide()
		ReputationDetailDivider:Hide()
		QuestNPCModelShadowOverlay:Hide()
		TabardFrame:GetRegions():Hide()
		BNToastFrameCloseButton:SetAlpha(0)
		PetStableModelShadow:Hide()
		RaidInfoFrame:GetRegions():Hide()
		RaidInfoDetailFooter:Hide()
		RaidInfoDetailHeader:Hide()
		RaidInfoDetailCorner:Hide()
		for i = 1, 9 do
			select(i, QuestLogCount:GetRegions()):Hide()
		end
		for i = 4, 8 do
			select(i, FriendsFrameBroadcastInput:GetRegions()):Hide()
			select(i, HelpFrameKnowledgebaseSearchBox:GetRegions()):Hide()
		end
-- 		select(3, PVPBannerFrame:GetRegions()):Hide()
		for i = 1, 9 do
			select(i, HelpFrame:GetRegions()):Hide()
		end
		HelpFrameHeader:Hide()
		ReadyCheckListenerFrame:GetRegions():SetAlpha(0)
		HelpFrameLeftInset:GetRegions():Hide()
		for i = 10, 13 do
			select(i, HelpFrameLeftInset:GetRegions()):Hide()
		end
		LFDParentFrameRoleBackground:Hide()
		LFDQueueFrameBackground:Hide()
		select(4, HelpFrameTicket:GetChildren()):Hide()
		HelpFrameKnowledgebaseStoneTex:Hide()
		HelpFrameKnowledgebaseNavBarOverlay:Hide()
		GhostFrameLeft:Hide()
		GhostFrameRight:Hide()
		GhostFrameMiddle:Hide()
		for i = 3, 6 do
			select(i, GhostFrame:GetRegions()):Hide()
		end
		PaperDollSidebarTabs:GetRegions():Hide()
		select(2, PaperDollSidebarTabs:GetRegions()):Hide()
		select(6, PaperDollEquipmentManagerPaneEquipSet:GetRegions()):Hide()

		local slots = {
			'Head', 'Neck', 'Shoulder', 'Shirt', 'Chest', 'Waist', 'Legs', 'Feet', 'Wrist',
			'Hands', 'Finger0', 'Finger1', 'Trinket0', 'Trinket1', 'Back', 'MainHand',
			'SecondaryHand', 'Tabard',
		}

		for i = 1, getn(slots) do
			_G['Character'..slots[i]..'Slot']:SetNormalTexture('')
			_G['Character'..slots[i]..'Slot']:GetRegions():SetTexCoord(.08, .92, .08, .92)
			local bd = CreateFrame('Frame', nil, _G['Character'..slots[i]..'Slot'])
			bd:SetPoint('TOPLEFT', -1, 1)
			bd:SetPoint('BOTTOMRIGHT', 1, -1)
			LanSkin.CreateBD(bd)			

			bd:SetBackdropColor(0, 0, 0, 0)
		end	

		_G['ReadyCheckFrame']:HookScript('OnShow', function(self) if UnitIsUnit('player', self.initiator) then self:Hide() end end)
    
		-- [[ Loot ]]

		if not IsAddOnLoaded('Butsu') and not IsAddOnLoaded('XLoot') and not IsAddOnLoaded('Tukui') then
			LootFramePortraitOverlay:Hide()
			select(3, LootFrame:GetRegions()):Hide()

			-- LootFrame:SetWidth(190)
			LootFrame:SetHeight(.001)
			LootFrame:SetHeight(.001)

			local reskinned = 1

			LootFrame:HookScript('OnShow', function()
				for i = reskinned, GetNumLootItems() do
					local bu = _G['LootButton'..i]
					local qu = _G['LootButton'..i..'IconQuestTexture']
					if not bu then return end
					local _, _, _, _, _, _, _, bg, na = bu:GetRegions()

					-- LootFrame:SetHeight(100 + 37 * i)

					local LootBD = CreateFrame('Frame', nil, bu)
					LootBD:SetFrameLevel(LootFrame:GetFrameLevel()-1)
					LootBD:SetPoint('TOPLEFT', 38, -1)
					LootBD:SetPoint('BOTTOMRIGHT', bu, 170, 1)

					LanSkin.CreateBD(LootBD)
					LanSkin.CreateBD(bu)

					bu:SetNormalTexture('')
					bu:GetRegions():SetTexCoord(.08, .92, .08, .92)
					bu:GetRegions():SetPoint('TOPLEFT', 1, -1)
					bu:GetRegions():SetPoint('BOTTOMRIGHT', -1, 1)
					bg:Hide()
					qu:SetTexture('Interface\\AddOns\\Aurora\\quest')
					qu:SetVertexColor(1, 0, 0)
					qu:SetTexCoord(.03, .97, .03, .995)
					qu.SetTexture = LanFunc.dummy
					na:SetWidth(174)

					reskinned = i + 1
				end
			end)
		end

		NORMAL_QUEST_DISPLAY = '|cffffffff%s|r'
		TRIVIAL_QUEST_DISPLAY = '|cffffffff%s (Low Level)|r'

		GameFontBlackMedium:SetTextColor(1, 1, 1)
		QuestFont:SetTextColor(1, 1, 1)
		MailTextFontNormal:SetTextColor(1, 1, 1)
		InvoiceTextFontNormal:SetTextColor(1, 1, 1)
		InvoiceTextFontSmall:SetTextColor(1, 1, 1)

		local newquestcolor = function(template, parentFrame, acceptButton, material)
			QuestInfoTitleHeader:SetTextColor(1, 1, 1)
			QuestInfoDescriptionHeader:SetTextColor(1, 1, 1)
			QuestInfoObjectivesHeader:SetTextColor(1, 1, 1)
			QuestInfoRewardsHeader:SetTextColor(1, 1, 1)
			-- other text
			QuestInfoDescriptionText:SetTextColor(1, 1, 1)
			QuestInfoObjectivesText:SetTextColor(1, 1, 1)
			QuestInfoGroupSize:SetTextColor(1, 1, 1)
			QuestInfoRewardText:SetTextColor(1, 1, 1)
            
			-- reward frame text
			QuestInfoItemChooseText:SetTextColor(1, 1, 1)
			QuestInfoItemReceiveText:SetTextColor(1, 1, 1)
			QuestInfoSpellLearnText:SetTextColor(1, 1, 1)		
			QuestInfoXPFrameReceiveText:SetTextColor(1, 1, 1)

			local numObjectives = GetNumQuestLeaderBoards()
			local objective
			local text, type, finished
			local numVisibleObjectives = 0
			for i = 1, numObjectives do
				text, type, finished = GetQuestLogLeaderBoard(i)
				if (type ~= 'spell') then
					numVisibleObjectives = numVisibleObjectives+1
					objective = _G['QuestInfoObjective'..numVisibleObjectives]
					objective:SetTextColor(1, 1, 1)
				end
			end
		end

		local newgossipcolor = function()
			GossipGreetingText:SetTextColor(1, 1, 1)
		end
		function QuestFrame_SetTitleTextColor(fontString)
			fontString:SetTextColor(1, 1, 1)
		end

		function QuestFrame_SetTextColor(fontString)
			fontString:SetTextColor(1, 1, 1)
		end

		function GossipFrameOptionsUpdate(...)
			local titleButton
			local titleIndex = 1
			local titleButtonIcon
			for i=1, select('#', ...), 2 do
				if ( GossipFrame.buttonIndex > NUMGOSSIPBUTTONS ) then
					message('This NPC has too many quests and/or gossip options.')
				end
				titleButton = _G['GossipTitleButton' .. GossipFrame.buttonIndex]
				titleButton:SetFormattedText('|cffffffff%s|r', select(i, ...))
				GossipResize(titleButton)
				titleButton:SetID(titleIndex)
				titleButton.type='Gossip'
				titleButtonIcon = _G[titleButton:GetName() .. 'GossipIcon']
				titleButtonIcon:SetTexture('Interface\\GossipFrame\\' .. select(i+1, ...) .. 'GossipIcon')
				titleButtonIcon:SetVertexColor(1, 1, 1, 1)
				GossipFrame.buttonIndex = GossipFrame.buttonIndex + 1
				titleIndex = titleIndex + 1
				titleButton:Show()
			end
		end

		local newspellbookcolor = function(self)
			local slot, slotType = SpellBook_GetSpellBookSlot(self)
			local name = self:GetName()
			-- local spellString = _G[name..'SpellName']
			local subSpellString = _G[name..'SubSpellName']

			-- spellString:SetTextColor(1, 1, 1)
			subSpellString:SetTextColor(1, 1, 1)
			if slotType == 'FUTURESPELL' then
				local level = GetSpellAvailableLevel(slot, SpellBookFrame.bookType)
				if (level and level > UnitLevel('player')) then
					self.RequiredLevelString:SetTextColor(.7, .7, .7)
					self.SpellName:SetTextColor(.7, .7, .7)
					subSpellString:SetTextColor(.7, .7, .7)
				end
			end
		end

		local newprofcolor = function(frame, index)
			if index then
				local rank = GetProfessionInfo(index)
				-- frame.rank:SetTextColor(1, 1, 1)
				frame.professionName:SetTextColor(1, 1, 1)
			else
				frame.missingText:SetTextColor(1, 1, 1)
				frame.missingHeader:SetTextColor(1, 1, 1)
			end
		end

		local newprofbuttoncolor = function(self)
			self.spellString:SetTextColor(1, 1, 1)	
			self.subSpellString:SetTextColor(1, 1, 1)
		end	
	
		ItemTextFrame:HookScript('OnEvent', function(self, event, ...)
			if event == 'ITEM_TEXT_BEGIN' then
				ItemTextTitleText:SetText(ItemTextGetItem())
				ItemTextScrollFrame:Hide()
				ItemTextCurrentPage:Hide()
				ItemTextStatusBar:Hide()
				ItemTextPrevPageButton:Hide()
				ItemTextNextPageButton:Hide()
				ItemTextPageText:SetTextColor(1, 1, 1)
				return
			end
		end)
		function PaperDollFrame_SetLevel()
			local primaryTalentTree = GetSpecialization('player')
			local classDisplayName, class = UnitClass('player')
			local classColorString = format('ff%.2x%.2x%.2x', c.r * 255, c.g * 255, c.b * 255)
			local specName

			if (primaryTalentTree) then
				_, specName = GetSpecializationInfo(primaryTalentTree)
			end

			if (specName and specName ~= '') then
				CharacterLevelText:SetFormattedText(PLAYER_LEVEL, UnitLevel('player'), classColorString, specName, classDisplayName)
			else
				CharacterLevelText:SetFormattedText(PLAYER_LEVEL_NO_SPEC, UnitLevel('player'), classColorString, classDisplayName)
			end
		end

		hooksecurefunc('QuestInfo_Display', newquestcolor)
		hooksecurefunc('GossipFrameUpdate', newgossipcolor)
		hooksecurefunc('SpellButton_UpdateButton', newspellbookcolor)
		hooksecurefunc('FormatProfession', newprofcolor)
		hooksecurefunc('UpdateProfessionButton', newprofbuttoncolor)
	
		-- [[ Change positions ]]

		ChatConfigFrameDefaultButton:SetWidth(125)
		ChatConfigFrameDefaultButton:ClearAllPoints()
		ChatConfigFrameDefaultButton:SetPoint('TOP', ChatConfigCategoryFrame, 'BOTTOM', 0, -4)
		ChatConfigFrameOkayButton:ClearAllPoints()
		ChatConfigFrameOkayButton:SetPoint('TOPRIGHT', ChatConfigBackgroundFrame, 'BOTTOMRIGHT', 0, -4)

		_G['VideoOptionsFrameCancel']:ClearAllPoints()
		_G['VideoOptionsFrameCancel']:SetPoint('RIGHT',_G['VideoOptionsFrameApply'],'LEFT',-4,0)		 
		_G['VideoOptionsFrameOkay']:ClearAllPoints()
		_G['VideoOptionsFrameOkay']:SetPoint('RIGHT',_G['VideoOptionsFrameCancel'],'LEFT',-4,0)	
		_G['AudioOptionsFrameOkay']:ClearAllPoints()
		_G['AudioOptionsFrameOkay']:SetPoint('RIGHT',_G['AudioOptionsFrameCancel'],'LEFT',-4,0)		 	 
		_G['InterfaceOptionsFrameOkay']:ClearAllPoints()
		_G['InterfaceOptionsFrameOkay']:SetPoint('RIGHT',_G['InterfaceOptionsFrameCancel'],'LEFT', -4,0)

		QuestLogFrameShowMapButton:Hide()
		QuestLogFrameShowMapButton.Show = LanFunc.dummy

		local questlogcontrolpanel = function()
			local parent
			if QuestLogFrame:IsShown() then
				parent = QuestLogFrame
				QuestLogControlPanel:SetPoint('BOTTOMLEFT', parent, 'BOTTOMLEFT', 9, 6)
			elseif QuestLogDetailFrame:IsShown() then
				parent = QuestLogDetailFrame
				QuestLogControlPanel:SetPoint('BOTTOMLEFT', parent, 'BOTTOMLEFT', 9, 0)
			end
		end

		hooksecurefunc('QuestLogControlPanel_UpdatePosition', questlogcontrolpanel)

		QuestLogFramePushQuestButton:ClearAllPoints()
		QuestLogFramePushQuestButton:SetPoint('LEFT', QuestLogFrameAbandonButton, 'RIGHT', 1, 0)
		QuestLogFramePushQuestButton:SetWidth(100)
		QuestLogFrameTrackButton:ClearAllPoints()
		QuestLogFrameTrackButton:SetPoint('LEFT', QuestLogFramePushQuestButton, 'RIGHT', 1, 0)

		FriendsFrameStatusDropDown:ClearAllPoints()
		FriendsFrameStatusDropDown:SetPoint('TOPLEFT', FriendsFrame, 'TOPLEFT', 10, -40)
		FriendsFrameCloseButton:ClearAllPoints()
		FriendsFrameCloseButton:SetPoint('LEFT', FriendsFrameBroadcastInput, 'RIGHT', 20, 0)

		RaidFrameConvertToRaidButton:ClearAllPoints()
		RaidFrameConvertToRaidButton:SetPoint('TOPLEFT', FriendsFrame, 'TOPLEFT', 30, -44)
		RaidFrameRaidInfoButton:ClearAllPoints()
		RaidFrameRaidInfoButton:SetPoint('TOPRIGHT', FriendsFrame, 'TOPRIGHT', -70, -44)

		local a1, p, a2, x, y = ReputationDetailFrame:GetPoint()
		ReputationDetailFrame:SetPoint(a1, p, a2, x + 10, y)

		hooksecurefunc('QuestFrame_ShowQuestPortrait', function(parentFrame, portrait, text, name, x, y)
			QuestNPCModel:SetPoint('TOPLEFT', parentFrame, 'TOPRIGHT', x+8, y)
		end)

		PaperDollEquipmentManagerPaneEquipSet:SetWidth(PaperDollEquipmentManagerPaneEquipSet:GetWidth()-1)

		local a3, p2, a4, x2, y2 = PaperDollEquipmentManagerPaneSaveSet:GetPoint()
		PaperDollEquipmentManagerPaneSaveSet:SetPoint(a3, p2, a4, x2 + 1, y2)

		local a5, p3, a6, x3, y3 = GearManagerDialogPopup:GetPoint()
		GearManagerDialogPopup:SetPoint(a5, p3, a6, x3+1, y3)

		DressUpFrameResetButton:ClearAllPoints()
		DressUpFrameResetButton:SetPoint('RIGHT', DressUpFrameCancelButton, 'LEFT', -1, 0)

		SendMailMailButton:ClearAllPoints()
		SendMailMailButton:SetPoint('RIGHT', SendMailCancelButton, 'LEFT', -1, 0)

		OpenMailDeleteButton:ClearAllPoints()
		OpenMailDeleteButton:SetPoint('RIGHT', OpenMailCancelButton, 'LEFT', -1, 0)

		OpenMailReplyButton:ClearAllPoints()
		OpenMailReplyButton:SetPoint('RIGHT', OpenMailDeleteButton, 'LEFT', -1, 0)
    
		-- [[ Tabs ]]

		for i = 1, 5 do
			LanSkin.CreateTab(_G['SpellBookFrameTabButton'..i])
		end

		for i = 1, 4 do
			LanSkin.CreateTab(_G['FriendsFrameTab'..i])
			if _G['CharacterFrameTab'..i] then
				LanSkin.CreateTab(_G['CharacterFrameTab'..i])
			end
		end

		for i = 1, 3 do
			LanSkin.CreateTab(_G['WorldStateScoreFrameTab'..i])
		end

		for i = 1, 2 do
			LanSkin.CreateTab(_G['MerchantFrameTab'..i])
			LanSkin.CreateTab(_G['MailFrameTab'..i])
		end

		-- [[ Buttons ]]

		for i = 1, 2 do
			for j = 1, 2 do
				LanSkin.Reskin(_G['StaticPopup'..i..'Button'..j])
			end
		end

		local buttons = {
            'VideoOptionsFrameOkay',
            'VideoOptionsFrameCancel',
            'VideoOptionsFrameDefaults',
            'VideoOptionsFrameApply',
            'AudioOptionsFrameOkay',
            'AudioOptionsFrameCancel',
            'AudioOptionsFrameDefaults',
            'InterfaceOptionsFrameDefaults',
            'InterfaceOptionsFrameOkay',
            'InterfaceOptionsFrameCancel',
            'ChatConfigFrameOkayButton',
            'ChatConfigFrameDefaultButton',
            'DressUpFrameCancelButton',
            'DressUpFrameResetButton',
            'WhoFrameWhoButton',
            'WhoFrameAddFriendButton',
            'WhoFrameGroupInviteButton',
            'SendMailMailButton',
            'SendMailCancelButton',
            'OpenMailReplyButton',
            'OpenMailDeleteButton',
            'OpenMailCancelButton',
            'OpenMailReportSpamButton',
            'aMailButton',
            'QuestLogFrameAbandonButton',
            'QuestLogFramePushQuestButton',
            'QuestLogFrameTrackButton',
            'QuestLogFrameCancelButton',
            'QuestFrameAcceptButton',
            'QuestFrameDeclineButton',
            'QuestFrameCompleteQuestButton',
            'QuestFrameCompleteButton',
            'QuestFrameGoodbyeButton',
            'GossipFrameGreetingGoodbyeButton',
            'QuestFrameGreetingGoodbyeButton',
            'ChannelFrameNewButton',
            'RaidFrameRaidInfoButton',
            'RaidFrameConvertToRaidButton',
            'TradeFrameTradeButton',
            'TradeFrameCancelButton',
            'StackSplitOkayButton',
            'StackSplitCancelButton',
            'TabardFrameAcceptButton',
            'TabardFrameCancelButton',
            'GameMenuButtonHelp',
            'GameMenuButtonOptions',
            'GameMenuButtonSoundOptions',
            'GameMenuButtonUIOptions',
            'GameMenuButtonKeybindings',
            'GameMenuButtonMacros',
            'GameMenuButtonAddOns',
            'GameMenuButtonLogout',
            'GameMenuButtonQuit',
            'GameMenuButtonContinue',
            'GameMenuButtonMacOptions',
            'FriendsFrameAddFriendButton',
            'FriendsFrameSendMessageButton',
            'LFDQueueFrameFindGroupButton',
            'LFDQueueFrameCancelButton',
            'LFRQueueFrameFindGroupButton',
            'LFRQueueFrameAcceptCommentButton',
            'PVPFrameLeftButton',
            'PVPHonorFrameWarGameButton',
            'PVPFrameRightButton',
            'RaidFrameNotInRaidRaidBrowserButton',
            'WorldStateScoreFrameLeaveButton',
            'SpellBookCompanionSummonButton',
            'AddFriendEntryFrameAcceptButton',
            'AddFriendEntryFrameCancelButton',
            'FriendsFriendsSendRequestButton',
            'FriendsFriendsCloseButton',
            'ColorPickerOkayButton',
            'ColorPickerCancelButton',
            'FriendsFrameIgnorePlayerButton',
            'FriendsFrameUnsquelchButton',
            'LFDDungeonReadyDialogEnterDungeonButton',
            'LFDDungeonReadyDialogLeaveQueueButton',
            'LFRBrowseFrameSendMessageButton',
            'LFRBrowseFrameInviteButton',
            'LFRBrowseFrameRefreshButton',
            'LFDRoleCheckPopupAcceptButton',
            'LFDRoleCheckPopupDeclineButton',
            'GuildInviteFrameJoinButton',
            'GuildInviteFrameDeclineButton',
            'FriendsFramePendingButton1AcceptButton',
            'FriendsFramePendingButton1DeclineButton'
        }
            
		for i = 1, getn(buttons) do
		local reskinbutton = _G[buttons[i]]
			if reskinbutton then
				LanSkin.Reskin(reskinbutton)
			else
				print('Button '..i..' was not found.')
			end
		end
-- 		LanSkin.Reskin(select(6, PVPBannerFrame:GetChildren()))

	-- [[ Load on Demand Addons ]]

	elseif addon == 'Blizzard_ArchaeologyUI' then
		LanSkin.CreateBD(ArchaeologyFrame)
		LanSkin.CreateSD(ArchaeologyFrame)
		LanSkin.Reskin(ArchaeologyFrameArtifactPageSolveFrameSolveButton)
		LanSkin.Reskin(ArchaeologyFrameArtifactPageBackButton)
		select(3, ArchaeologyFrame:GetRegions()):Hide()
		ArchaeologyFrameSummaryPage:GetRegions():SetTextColor(1, 1, 1)
		ArchaeologyFrameArtifactPage:GetRegions():SetTextColor(1, 1, 1)
		ArchaeologyFrameArtifactPageHistoryScrollChild:GetRegions():SetTextColor(1, 1, 1)
		ArchaeologyFrameHelpPage:GetRegions():SetTextColor(1, 1, 1)
		select(5, ArchaeologyFrameHelpPage:GetRegions()):SetTextColor(1, 1, 1)
		ArchaeologyFrameHelpPageHelpScrollHelpText:SetTextColor(1, 1, 1)
		ArchaeologyFrameCompletedPage:GetRegions():SetTextColor(1, 1, 1)
		select(2, ArchaeologyFrameCompletedPage:GetRegions()):SetTextColor(1, 1, 1)
		select(5, ArchaeologyFrameCompletedPage:GetRegions()):SetTextColor(1, 1, 1)
		select(8, ArchaeologyFrameCompletedPage:GetRegions()):SetTextColor(1, 1, 1)
		select(11, ArchaeologyFrameCompletedPage:GetRegions()):SetTextColor(1, 1, 1)
		for i = 1, 10 do
			_G['ArchaeologyFrameSummaryPageRace'..i]:GetRegions():SetTextColor(1, 1, 1)
		end
		for i = 1, ARCHAEOLOGY_MAX_COMPLETED_SHOWN do
			local bu = _G['ArchaeologyFrameCompletedPageArtifact'..i]
			bu:GetRegions():Hide()
			select(2, bu:GetRegions()):Hide()
			select(3, bu:GetRegions()):SetTexCoord(.08, .92, .08, .92)
			select(4, bu:GetRegions()):SetTextColor(1, 1, 1)
			select(5, bu:GetRegions()):SetTextColor(1, 1, 1)
			local bg = CreateFrame('Frame', nil, bu)
			bg:SetPoint('TOPLEFT', -1, 1)
			bg:SetPoint('BOTTOMRIGHT', 1, -1)
			bg:SetFrameLevel(bu:GetFrameLevel()-1)
			LanSkin.CreateBD(bg, .25)
			local vline = CreateFrame('Frame', nil, bu)
			vline:SetPoint('LEFT', 44, 0)
			vline:SetSize(1, 44)
			LanSkin.CreateBD(vline)
		end
	elseif addon == 'Blizzard_AuctionUI' then
		local AuctionBD = CreateFrame('Frame', nil, AuctionFrame)
		AuctionBD:SetPoint('TOPLEFT', 2, -10)
		AuctionBD:SetPoint('BOTTOMRIGHT', 0, 10)
		AuctionBD:SetFrameStrata('MEDIUM')
		LanSkin.CreateBD(AuctionBD)
		LanSkin.CreateSD(AuctionBD)
		LanSkin.CreateBD(AuctionProgressFrame)
		LanSkin.CreateSD(AuctionProgressFrame)
		LanSkin.CreateBD(BrowseName, .25)

		local ABBD = CreateFrame('Frame', nil, AuctionProgressBar)

		ABBD:SetPoint('TOPLEFT', -1, 1)
		ABBD:SetPoint('BOTTOMRIGHT', 1, -1)
		
		ABBD:SetFrameLevel(AuctionProgressBar:GetFrameLevel()-1)
		LanSkin.CreateBD(ABBD, .25)

		AuctionFrame:GetRegions():Hide()
        
		for i = 1, 4 do
			select(i, AuctionProgressFrame:GetRegions()):Hide()
		end
        
		select(2, AuctionProgressBar:GetRegions()):Hide()
        
		for i = 4, 8 do
			select(i, BrowseName:GetRegions()):Hide()
		end

		for i = 1, 3 do
			LanSkin.CreateTab(_G['AuctionFrameTab'..i])
		end
        
		local abuttons = {
            'BrowseBidButton',
            'BrowseBuyoutButton',
            'BrowseCloseButton',
            'BrowseSearchButton',
            'BrowseResetButton',
            'BidBidButton',
            'BidBuyoutButton',
            'BidCloseButton',
            'AuctionsCloseButton',
            'AuctionsCancelAuctionButton',
            'AuctionsCreateAuctionButton',
            'AuctionsNumStacksMaxButton',
            'AuctionsStackSizeMaxButton'
        }
        
		for i = 1, getn(abuttons) do
			local reskinbutton = _G[abuttons[i]]
			if reskinbutton then
				LanSkin.Reskin(reskinbutton)
			end
		end

		BrowseBuyoutButton:ClearAllPoints()
		BrowseBuyoutButton:SetPoint('RIGHT', BrowseCloseButton, 'LEFT', -1, 0)
		BrowseBidButton:ClearAllPoints()
		BrowseBidButton:SetPoint('RIGHT', BrowseBuyoutButton, 'LEFT', -1, 0)
		BidBuyoutButton:ClearAllPoints()
		BidBuyoutButton:SetPoint('RIGHT', BidCloseButton, 'LEFT', -1, 0)
		BidBidButton:ClearAllPoints()
		BidBidButton:SetPoint('RIGHT', BidBuyoutButton, 'LEFT', -1, 0)
		AuctionsCancelAuctionButton:ClearAllPoints()
		AuctionsCancelAuctionButton:SetPoint('RIGHT', AuctionsCloseButton, 'LEFT', -1, 0)

		for i = 1, 8 do
			local bu = _G['BrowseButton'..i]
			local it = _G['BrowseButton'..i..'Item']
			local ic = _G['BrowseButton'..i..'ItemIconTexture']

			it:SetNormalTexture('')
			ic:SetTexCoord(.08, .92, .08, .92)

			local bg = CreateFrame('Frame', nil, it)
			bg:SetPoint('TOPLEFT', -1, 1)
			bg:SetPoint('BOTTOMRIGHT', 1, -1)
			bg:SetFrameLevel(it:GetFrameLevel()-1)
			LanSkin.CreateBD(bg, 0)

			_G['BrowseButton'..i..'Left']:Hide()
			select(6, _G['BrowseButton'..i]:GetRegions()):Hide()
			_G['BrowseButton'..i..'Right']:Hide()

			local bd = CreateFrame('Frame', nil, bu)
			bd:SetPoint('TOPLEFT')
			bd:SetPoint('BOTTOMRIGHT', 0, 5)
			bd:SetFrameLevel(bu:GetFrameLevel()-1)
			LanSkin.CreateBD(bd, .25)

			bu:SetHighlightTexture('Interface\\ChatFrame\\ChatFrameBackground')
			local hl = bu:GetHighlightTexture()
			hl:SetVertexColor(r, g, b, .2)
			hl:ClearAllPoints()
			hl:SetPoint('TOPLEFT', 0, -1)
			hl:SetPoint('BOTTOMRIGHT', -1, 6)
		end
	elseif addon == 'Blizzard_AchievementUI' then
		LanSkin.CreateBD(AchievementFrame)
		LanSkin.CreateSD(AchievementFrame)
        
		for i = 1, 13 do
			select(i, AchievementFrame:GetRegions()):Hide()
		end
        
		AchievementFrameSummary:GetRegions():Hide()
        
		for i = 1, 4 do
			select(i, AchievementFrameHeader:GetRegions()):Hide()
		end
        
		AchievementFrameHeader:ClearAllPoints()
		AchievementFrameHeader:SetPoint('TOP', AchievementFrame, 'TOP', 0, 40)
		AchievementFrameFilterDropDown:ClearAllPoints()
		AchievementFrameFilterDropDown:SetPoint('RIGHT', AchievementFrameHeader, 'RIGHT', -120, -1)
        
		for i = 1, 3 do
			if _G['AchievementFrameTab'..i] then
				for j = 1, 6 do
					select(j, _G['AchievementFrameTab'..i]:GetRegions()):Hide()
					select(j, _G['AchievementFrameTab'..i]:GetRegions()).Show = LanFunc.dummy
				end
				local sd = CreateFrame('Frame', nil, _G['AchievementFrameTab'..i])
				sd:SetPoint('TOPLEFT', 6, -4)
				sd:SetPoint('BOTTOMRIGHT', -6, -2)
				sd:SetFrameStrata('LOW')
					sd:SetBackdrop({
						bgFile = LanSkin.Backdrop,
						edgeFile = LanSkin.Glow,
						edgeSize = 5,
						insets = {
                            left = 5,
                            right = 5,
                            top = 5,
                            bottom = 5
                        },
					})
				sd:SetBackdropColor(unpack(LanConfig.Media.BackdropColor))
				sd:SetBackdropBorderColor(0, 0, 0)
			end
		end
	elseif addon == 'Blizzard_BindingUI' then
		local BindingBD = CreateFrame('Frame', nil, KeyBindingFrame)
		BindingBD:SetPoint('TOPLEFT', 2, 0)
		BindingBD:SetPoint('BOTTOMRIGHT', -38, 10)
		BindingBD:SetFrameLevel(KeyBindingFrame:GetFrameLevel()-1)
		LanSkin.CreateBD(BindingBD)
		LanSkin.CreateSD(BindingBD)
		KeyBindingFrameHeader:SetTexture('')
		LanSkin.Reskin(KeyBindingFrameDefaultButton)
		LanSkin.Reskin(KeyBindingFrameUnbindButton)
		LanSkin.Reskin(KeyBindingFrameOkayButton)
		LanSkin.Reskin(KeyBindingFrameCancelButton)
		KeyBindingFrameOkayButton:ClearAllPoints()
		KeyBindingFrameOkayButton:SetPoint('RIGHT', KeyBindingFrameCancelButton, 'LEFT', -1, 0)
		KeyBindingFrameUnbindButton:ClearAllPoints()
		KeyBindingFrameUnbindButton:SetPoint('RIGHT', KeyBindingFrameOkayButton, 'LEFT', -1, 0)
	elseif addon == 'Blizzard_Calendar' then
		for i = 1, 15 do
			if i ~= 10 and i ~= 11 and i ~= 12 and i ~= 13 and i ~= 14 then select(i, CalendarViewEventFrame:GetRegions()):Hide() end
		end
        
		for i = 1, 9 do
			select(i, CalendarViewHolidayFrame:GetRegions()):Hide()
			select(i, CalendarViewRaidFrame:GetRegions()):Hide()
		end
		
        for i = 1, 3 do
			select(i, CalendarViewEventTitleFrame:GetRegions()):Hide()
			select(i, CalendarViewHolidayTitleFrame:GetRegions()):Hide()
			select(i, CalendarViewRaidTitleFrame:GetRegions()):Hide()
		end
		
        CalendarViewEventInviteListSection:GetRegions():Hide()
		CalendarViewEventInviteList:GetRegions():Hide()
		CalendarViewEventDescriptionContainer:GetRegions():Hide()
		select(5, CalendarViewEventCloseButton:GetRegions()):Hide()
		select(5, CalendarViewHolidayCloseButton:GetRegions()):Hide()
		select(5, CalendarViewRaidCloseButton:GetRegions()):Hide()
		local CalBD = CreateFrame('Frame', nil, CalendarFrame)
		CalBD:SetPoint('TOPLEFT', 11, 0)
		CalBD:SetPoint('BOTTOMRIGHT', -9, 3)
		CalBD:SetFrameStrata('MEDIUM')
		LanSkin.CreateBD(CalBD)
		LanSkin.CreateSD(CalBD)
		LanSkin.CreateBD(CalendarViewEventFrame)
		LanSkin.CreateSD(CalendarViewEventFrame)
		LanSkin.CreateBD(CalendarViewHolidayFrame)
		LanSkin.CreateSD(CalendarViewHolidayFrame)
		LanSkin.CreateBD(CalendarViewRaidFrame)
		LanSkin.CreateSD(CalendarViewRaidFrame)
		LanSkin.CreateBD(CalendarViewEventInviteList, .25)
		LanSkin.CreateBD(CalendarViewEventDescriptionContainer, .25)
        
		for i = 1, 42 do
			_G['CalendarDayButton'..i]:CreateBeautyBorder(12, R, G, B, 1, 1, 1, 1, 1,1, 1, 1) -- But i had one =)
		end
        
		local cbuttons = {
            'CalendarViewEventAcceptButton',
            'CalendarViewEventTentativeButton',
            'CalendarViewEventDeclineButton',
            'CalendarViewEventRemoveButton'
        }
        
		for i = 1, getn(cbuttons) do
            local cbutton = _G[cbuttons[i]]
			if cbutton then
				LanSkin.Reskin(cbutton)
			end
		end
        
		CalendarCloseButton:ClearAllPoints()
		CalendarCloseButton:SetPoint('TOPRIGHT', CalBD, 'TOPRIGHT')
	elseif addon == 'Blizzard_GlyphUI' then
		LanSkin.CreateBD(GlyphFrameSearchBox, .25)
		GlyphFrame:GetRegions():Hide()
		select(10, GlyphFrameSideInset:GetRegions()):Hide()
		for i = 4, 8 do
			select(i, GlyphFrameSearchBox:GetRegions()):Hide()
		end
	elseif addon == 'Blizzard_GMSurveyUI' then
		local f = CreateFrame('Frame', nil, GMSurveyFrame)
		f:SetPoint('TOPLEFT')
		f:SetPoint('BOTTOMRIGHT', -32, 4)
		f:SetFrameLevel(GMSurveyFrame:GetFrameLevel()-1)
		LanSkin.CreateBD(f)
		LanSkin.CreateSD(f)

		LanSkin.CreateBD(GMSurveyCommentFrame, .25)

		for i = 1, 11 do
			select(i, GMSurveyFrame:GetRegions()):Hide()
		end
		for i = 1, 10 do
			Aurora.CreateBD(_G['GMSurveyQuestion'..i], .25)
		end
		for i = 1, 3 do
			select(i, GMSurveyHeader:GetRegions()):Hide()
		end

		LanSkin.Reskin(GMSurveySubmitButton)
		LanSkin.Reskin(GMSurveyCancelButton)
	elseif addon == 'Blizzard_GuildBankUI' then
		local f = CreateFrame('Frame', nil, GuildBankFrame)
		f:SetPoint('TOPLEFT', 10, -8)
		f:SetPoint('BOTTOMRIGHT', 0, 6)
		f:SetFrameLevel(GuildBankFrame:GetFrameLevel()-1)
		LanSkin.CreateBD(f)
		LanSkin.CreateSD(f)

		GuildBankEmblemFrame:Hide()
        
		for i = 1, 4 do
			LanSkin.CreateTab(_G['GuildBankFrameTab'..i])
		end
        
		LanSkin.Reskin(GuildBankFrameWithdrawButton)
		LanSkin.Reskin(GuildBankFrameDepositButton)

		GuildBankFrameWithdrawButton:ClearAllPoints()
		GuildBankFrameWithdrawButton:SetPoint('RIGHT', GuildBankFrameDepositButton, 'LEFT', -1, 0)

		for i = 1, 7 do
			for j = 1, 14 do
				local co = _G['GuildBankColumn'..i]
				local bu = _G['GuildBankColumn'..i..'Button'..j]
				local ic = _G['GuildBankColumn'..i..'Button'..j..'IconTexture']
				local nt = _G['GuildBankColumn'..i..'Button'..j..'NormalTexture']

				co:GetRegions():Hide()
				ic:SetTexCoord(.08, .92, .08, .92)
				nt:SetAlpha(0)

				local bg = CreateFrame('Frame', nil, bu)
				bg:SetPoint('TOPLEFT', -1, 1)
				bg:SetPoint('BOTTOMRIGHT', 1, -1)
				bg:SetFrameLevel(bu:GetFrameLevel()-1)
				LanSkin.CreateBD(bg, 0)
			end
		end

		for i = 1, 8 do
			local tb = _G['GuildBankTab'..i]
			local bu = _G['GuildBankTab'..i..'Button']
			local ic = _G['GuildBankTab'..i..'ButtonIconTexture']
			local nt = _G['GuildBankTab'..i..'ButtonNormalTexture']

			local bg = CreateFrame('Frame', nil, bu)
			bg:SetPoint('TOPLEFT', -1, 1)
			bg:SetPoint('BOTTOMRIGHT', 1, -1)
			bg:SetFrameLevel(bu:GetFrameLevel()-1)
			LanSkin.CreateBD(bg, 1)
			LanSkin.CreateSD(bu, 5, 0, 0, 0, 1, 1)

			local a1, p, a2, x, y = bu:GetPoint()
			bu:SetPoint(a1, p, a2, x + 11, y)

			ic:SetTexCoord(.08, .92, .08, .92)
			tb:GetRegions():Hide()
			nt:Hide()
		end
	elseif addon == 'Blizzard_GuildUI' then
		LanSkin.CreateBD(GuildFrame)
		LanSkin.CreateSD(GuildFrame)
		LanSkin.CreateBD(GuildMemberDetailFrame)
		LanSkin.CreateSD(GuildMemberDetailFrame)
		LanSkin.CreateBD(GuildMemberNoteBackground, .25)
		LanSkin.CreateBD(GuildMemberOfficerNoteBackground, .25)
		LanSkin.CreateBD(GuildLogFrame)
		LanSkin.CreateSD(GuildLogFrame)
		LanSkin.CreateBD(GuildLogContainer, .25)
		LanSkin.CreateBD(GuildNewsFiltersFrame)
		LanSkin.CreateSD(GuildNewsFiltersFrame)
		LanSkin.CreateBD(GuildTextEditFrame)
		LanSkin.CreateSD(GuildTextEditFrame)
		LanSkin.CreateBD(GuildTextEditContainer)
        
		for i = 1, 5 do
			LanSkin.CreateTab(_G['GuildFrameTab'..i])
		end
        
		select(18, GuildFrame:GetRegions()):Hide()
		select(21, GuildFrame:GetRegions()):Hide()
		select(22, GuildFrame:GetRegions()):Hide()
		select(5, GuildInfoFrameInfo:GetRegions()):Hide()
		select(11, GuildMemberDetailFrame:GetRegions()):Hide()
		select(12, GuildMemberDetailFrame:GetRegions()):Hide()
        
		for i = 1, 9 do
			select(i, GuildLogFrame:GetRegions()):Hide()
			select(i, GuildNewsFiltersFrame:GetRegions()):Hide()
			select(i, GuildTextEditFrame:GetRegions()):Hide()
		end
        
		select(2, GuildNewPerksFrame:GetRegions()):Hide()
		select(3, GuildNewPerksFrame:GetRegions()):Hide()
		GuildAllPerksFrame:GetRegions():Hide()
		GuildNewsFrame:GetRegions():Hide()
		GuildRewardsFrame:GetRegions():Hide()
		select(2, GuildNewsBossModel:GetRegions()):Hide()

		local a1, p, a2, x, y = GuildNewsBossModel:GetPoint()
		GuildNewsBossModel:ClearAllPoints()
		GuildNewsBossModel:SetPoint(a1, p, a2, x+5, y)

		local f = CreateFrame('Frame', nil, GuildNewsBossModel)
		f:SetPoint('TOPLEFT')
		f:SetPoint('BOTTOMRIGHT', 0, -52)
		f:SetFrameLevel(GuildNewsBossModel:GetFrameLevel()-1)
		LanSkin.CreateBD(f)

		local line = CreateFrame('Frame', nil, GuildNewsBossModel)
		line:SetPoint('BOTTOMLEFT', 0, -1)
		line:SetPoint('BOTTOMRIGHT', 0, -1)
		line:SetHeight(1)
		line:SetFrameLevel(GuildNewsBossModel:GetFrameLevel()-1)
		LanSkin.CreateBD(line, 0)

		GuildNewsFiltersFrame:ClearAllPoints()
		GuildNewsFiltersFrame:SetPoint('TOPLEFT', GuildFrame, 'TOPRIGHT', 10, -10)
		GuildMemberDetailFrame:ClearAllPoints()
		GuildMemberDetailFrame:SetPoint('TOPLEFT', GuildFrame, 'TOPRIGHT', 10, -10)
		GuildLevelFrame:SetAlpha(0)

		local closebutton = select(4, GuildTextEditFrame:GetChildren())
		LanSkin.Reskin(closebutton)
		local logbutton = select(3, GuildLogFrame:GetChildren())
		LanSkin.Reskin(logbutton)
		local gbuttons = {
            'GuildAddMemberButton',
            'GuildViewLogButton',
            'GuildControlButton',
            'GuildTextEditFrameAcceptButton',
            'GuildMemberGroupInviteButton',
            'GuildMemberRemoveButton'
        }
        
		for i = 1, getn(gbuttons) do
            local gbutton = _G[gbuttons[i]]
			if gbutton then
				LanSkin.Reskin(gbutton)
			end
		end

		for i = 1, 3 do
			for j = 1, 6 do
				select(j, _G['GuildInfoFrameTab'..i]:GetRegions()):Hide()
				select(j, _G['GuildInfoFrameTab'..i]:GetRegions()).Show = LanFunc.dummy
			end
		end
        
        GuildFrameTabardEmblem:Show()
        
        local GuildKill = {
            _G['GuildXPBarLeft'],
            _G['GuildXPBarRight'],
            _G['GuildXPBarMiddle'],
            _G['GuildXPBarBG'],
            _G['GuildXPBarShadow'],
            _G['GuildXPBarCap'],
            _G['GuildXPBarDivider1'],
            _G['GuildXPBarDivider2'],
            _G['GuildXPBarDivider3'],
            _G['GuildXPBarDivider4'],
            _G['GuildFactionBarLeft'],
            _G['GuildFactionBarRight'],
            _G['GuildFactionBarMiddle'],
            _G['GuildFactionBarBG'],
            _G['GuildFactionBarShadow'],
            _G['GuildFactionBarCap']
        }

        for _, kill in pairs(GuildKill) do
            LanFunc.Kill(kill)
        end
        
        GuildXPBar.progress:SetTexture(LanConfig.Media.StatusBar)
        GuildXPBar:CreateBeautyBorder(12)
        GuildXPBar:SetBeautyBorderPadding(1, 2, 1, 2, 1, -3, 1, -3)
        GuildFactionBar.progress:SetTexture(LanConfig.Media.StatusBar)
        GuildFactionBar:CreateBeautyBorder(12)
        
        local factionHeader = _G['GuildFactionFrameHeader']
        local p1, frame, p2, x, y = factionHeader:GetPoint()
        factionHeader:SetPoint(p1, frame, p2, x, y + 2)
	elseif addon == 'Blizzard_InspectUI' then
		LanSkin.CreateBD(InspectFrame)
		LanSkin.CreateSD(InspectFrame)

		local slots = {
			'Head', 'Neck', 'Shoulder', 'Shirt', 'Chest', 'Waist', 'Legs', 'Feet', 'Wrist',
			'Hands', 'Finger0', 'Finger1', 'Trinket0', 'Trinket1', 'Back', 'MainHand',
			'SecondaryHand', 'Ranged', 'Tabard',
		}

		for i = 1, getn(slots) do
			local bd = CreateFrame('Frame', nil, _G['Inspect'..slots[i]..'Slot'])
			bd:SetPoint('TOPLEFT', -1, 1)
			bd:SetPoint('BOTTOMRIGHT', 1, -1)
			LanSkin.CreateBD(bd)

			bd:SetBackdropColor(0, 0, 0, 0)
			_G['Inspect'..slots[i]..'Slot']:SetNormalTexture('')
			_G['Inspect'..slots[i]..'Slot']:GetRegions():SetTexCoord(.08, .92, .08, .92)
		end

		for i = 1, 4 do
			LanSkin.CreateTab(_G['InspectFrameTab'..i])
		end
        
		select(3, InspectFrame:GetRegions()):Hide()
		InspectGuildFrame:GetRegions():Hide()
        
		for i = 1, 5 do
			select(i, InspectModelFrame:GetRegions()):Hide()
		end
        
		for i = 1, 4 do
			select(i, InspectTalentFrame:GetRegions()):Hide()
		end
        
		for i = 1, 3 do
			for j = 1, 6 do
				select(j, _G['InspectTalentFrameTab'..i]:GetRegions()):Hide()
				select(j, _G['InspectTalentFrameTab'..i]:GetRegions()).Show = LanFunc.dummy
			end
		end
	elseif addon == 'Blizzard_ItemSocketingUI' then
		local SocketBD = CreateFrame('Frame', nil, ItemSocketingFrame)
		SocketBD:SetPoint('TOPLEFT', 12, -8)
		SocketBD:SetPoint('BOTTOMRIGHT', -2, 24)
		SocketBD:SetFrameLevel(ItemSocketingFrame:GetFrameLevel()-1)
		LanSkin.CreateBD(SocketBD)
		LanSkin.CreateSD(SocketBD)
		ItemSocketingFrame:GetRegions():Hide()
		LanSkin.Reskin(ItemSocketingSocketButton)
		ItemSocketingSocketButton:ClearAllPoints()
		ItemSocketingSocketButton:SetPoint('BOTTOMRIGHT', ItemSocketingFrame, 'BOTTOMRIGHT', -10, 28)
	elseif addon == 'Blizzard_LookingForGuildUI' then
		LanSkin.CreateBD(LookingForGuildFrame)
		LanSkin.CreateSD(LookingForGuildFrame)
		LanSkin.CreateBD(LookingForGuildInterestFrame, .25)
		LookingForGuildInterestFrame:GetRegions():Hide()
		LanSkin.CreateBD(LookingForGuildAvailabilityFrame, .25)
		LookingForGuildAvailabilityFrame:GetRegions():Hide()
		LanSkin.CreateBD(LookingForGuildRolesFrame, .25)
		LookingForGuildRolesFrame:GetRegions():Hide()
		LanSkin.CreateBD(LookingForGuildCommentFrame, .25)
		LookingForGuildCommentFrame:GetRegions():Hide()
		LanSkin.CreateBD(LookingForGuildCommentInputFrame, .12)
		for i = 1, 5 do
			LanSkin.CreateBD(_G['LookingForGuildBrowseFrameContainerButton'..i], .25)
		end
		for i = 1, 9 do
			select(i, LookingForGuildCommentInputFrame:GetRegions()):Hide()
		end
		for i = 1, 3 do
			for j = 1, 6 do
				select(j, _G['LookingForGuildFrameTab'..i]:GetRegions()):Hide()
				select(j, _G['LookingForGuildFrameTab'..i]:GetRegions()).Show = Aurora.dummy
			end
		end
		for i = 18, 20 do
			select(i, LookingForGuildFrame:GetRegions()):Hide()
		end
		LanSkin.Reskin(LookingForGuildBrowseButton)
		LanSkin.Reskin(LookingForGuildRequestButton)
	elseif addon == 'Blizzard_MacroUI' then
		local MacroBD = CreateFrame('Frame', nil, MacroFrame)
		MacroBD:SetPoint('TOPLEFT', 12, -10)
		MacroBD:SetPoint('BOTTOMRIGHT', -33, 68)
		MacroBD:SetFrameLevel(MacroFrame:GetFrameLevel()-1)
		LanSkin.CreateBD(MacroBD)
		LanSkin.CreateSD(MacroBD)
		LanSkin.CreateBD(MacroFrameTextBackground, .25)
		LanSkin.CreateBD(MacroPopupFrame)
		LanSkin.CreateSD(MacroPopupFrame)
        
		for i = 1, 6 do
			select(i, MacroFrameTab1:GetRegions()):Hide()
			select(i, MacroFrameTab2:GetRegions()):Hide()
			select(i, MacroFrameTab1:GetRegions()).Show = LanFunc.dummy
			select(i, MacroFrameTab2:GetRegions()).Show = LanFunc.dummy
		end
        
		for i = 1, 8 do
			if i ~= 6 then select(i, MacroFrame:GetRegions()):Hide() end
		end
		
        for i = 1, 5 do
			select(i, MacroPopupFrame:GetRegions()):Hide()
		end
		
        LanSkin.Reskin(MacroDeleteButton)
		LanSkin.Reskin(MacroNewButton)
		LanSkin.Reskin(MacroExitButton)
		LanSkin.Reskin(MacroEditButton)
		LanSkin.Reskin(MacroPopupOkayButton)
		LanSkin.Reskin(MacroPopupCancelButton)
		MacroPopupFrame:ClearAllPoints()
		MacroPopupFrame:SetPoint('LEFT', MacroFrame, 'RIGHT', -14, 16)
	elseif addon == 'Blizzard_ReforgingUI' then
		LanSkin.CreateBD(ReforgingFrame)
		LanSkin.CreateSD(ReforgingFrame)
		select(3, ReforgingFrame:GetRegions()):Hide()
		LanSkin.Reskin(ReforgingFrameRestoreButton)
		LanSkin.Reskin(ReforgingFrameReforgeButton)
	elseif addon == 'Blizzard_TalentUI' then
		LanSkin.CreateBD(PlayerTalentFrame)
		LanSkin.CreateSD(PlayerTalentFrame)
		local talentbuttons = {
            'PlayerTalentFrameToggleSummariesButton',
            'PlayerTalentFrameLearnButton',
            'PlayerTalentFrameResetButton',
            'PlayerTalentFrameActivateButton'
        }
		
        for i = 1, getn(talentbuttons) do
            local reskinbutton = _G[talentbuttons[i]]
			if reskinbutton then
				LanSkin.Reskin(reskinbutton)
			end
		end
		PlayerTalentFramePortrait:Hide()
		PlayerTalentFrameTitleGlowLeft:SetAlpha(0)
		PlayerTalentFrameTitleGlowRight:SetAlpha(0)
		PlayerTalentFrameTitleGlowCenter:SetAlpha(0)
		
        for i = 1, 3 do
			if _G['PlayerTalentFrameTab'..i] then
				LanSkin.CreateTab(_G['PlayerTalentFrameTab'..i])
			end
		end
		
        for i = 1, 2 do
			local tab = _G['PlayerSpecTab'..i]
			local a1, p, a2, x, y = PlayerSpecTab1:GetPoint()
			local bg = CreateFrame('Frame', nil, tab)
			bg:SetPoint('TOPLEFT', -1, 1)
			bg:SetPoint('BOTTOMRIGHT', 1, -1)
			bg:SetFrameLevel(tab:GetFrameLevel()-1)
				hooksecurefunc('PlayerTalentFrame_UpdateTabs', function()
					PlayerSpecTab1:SetPoint(a1, p, a2, x + 11, y + 10)
					PlayerSpecTab2:SetPoint('TOP', PlayerSpecTab1, 'BOTTOM')
				end)
                   
				LanSkin.CreateSD(tab, 5, 0, 0, 0, 1, 1)
				LanSkin.CreateBD(bg, 1)
			select(2, tab:GetRegions()):SetTexCoord(.08, .92, .08, .92)
		end
	elseif addon == 'Blizzard_TradeSkillUI' then
		LanSkin.CreateBD(TradeSkillFrame)
		LanSkin.CreateSD(TradeSkillFrame)
		LanSkin.CreateBD(TradeSkillGuildFrame)
		LanSkin.CreateSD(TradeSkillGuildFrame)
		LanSkin.CreateBD(TradeSkillFrameSearchBox, .25)
		LanSkin.CreateBD(TradeSkillGuildFrameContainer, .25)

		select(3, TradeSkillFrame:GetRegions()):Hide()
		select(3, TradeSkillFrame:GetRegions()).Show = LanFunc.dummy
		for i = 18, 20 do
			select(i, TradeSkillFrame:GetRegions()):Hide()
			select(i, TradeSkillFrame:GetRegions()).Show = LanFunc.dummy
		end
		select(21, TradeSkillFrame:GetRegions()):Hide()
		select(22, TradeSkillFrame:GetRegions()):Hide()

		for i = 1, 3 do
			select(i, TradeSkillExpandButtonFrame:GetRegions()):Hide()
			select(i, TradeSkillFilterButton:GetRegions()):Hide()
		end
		for i = 1, 9 do
			select(i, TradeSkillGuildFrame:GetRegions()):Hide()
		end
		for i = 4, 8 do
			select(i, TradeSkillFrameSearchBox:GetRegions()):Hide()
		end

		local a1, p, a2, x, y = TradeSkillGuildFrame:GetPoint()
		TradeSkillGuildFrame:ClearAllPoints()
		TradeSkillGuildFrame:SetPoint(a1, p, a2, x + 16, y)

		local tradeskillbuttons = {
            'TradeSkillCreateButton',
            'TradeSkillCreateAllButton',
            'TradeSkillCancelButton',
            'TradeSkillViewGuildCraftersButton',
            'TradeSkillFilterButton'
        }
        
		for i = 1, getn(tradeskillbuttons) do
            local button = _G[tradeskillbuttons[i]]
			if button then
				LanSkin.Reskin(button)
			end
		end
	elseif addon == 'Blizzard_TrainerUI' then
		LanSkin.CreateBD(ClassTrainerFrame)
		LanSkin.CreateSD(ClassTrainerFrame)
		select(3, ClassTrainerFrame:GetRegions()):Hide()
		select(19, ClassTrainerFrame:GetRegions()):Hide()
		LanSkin.Reskin(ClassTrainerTrainButton)
    elseif addon == 'spew' then
        LanFunc.Skin(SpewPanel, 12, 1)
	end
	
	if IsMacClient() then
		LanSkin.CreateBD(MacOptionsFrame)
		MacOptionsFrameHeader:SetTexture('')
		MacOptionsFrameHeader:ClearAllPoints()
		MacOptionsFrameHeader:SetPoint('TOP', MacOptionsFrame, 0, 0)
 
		LanSkin.CreateBD(MacOptionsFrameMovieRecording, .25)
		LanSkin.CreateBD(MacOptionsITunesRemote, .25)

		local macbuttons = {'MacOptionsButtonKeybindings', 'MacOptionsButtonCompress', 'MacOptionsFrameCancel', 'MacOptionsFrameOkay', 'MacOptionsFrameDefaults'}
		for i = 1, getn(macbuttons) do
		local button = _G[macbuttons[i]]
			if button then
				LanSkin.Reskin(button)
			end
		end
 
		_G['MacOptionsButtonCompress']:SetWidth(136)
 
		_G['MacOptionsFrameCancel']:SetWidth(96)
		_G['MacOptionsFrameCancel']:SetHeight(22)
		_G['MacOptionsFrameCancel']:ClearAllPoints()
		_G['MacOptionsFrameCancel']:SetPoint('LEFT', _G['MacOptionsButtonKeybindings'], 'RIGHT', 107, 0)
 
		_G['MacOptionsFrameOkay']:SetWidth(96)
		_G['MacOptionsFrameOkay']:SetHeight(22)
		_G['MacOptionsFrameOkay']:ClearAllPoints()
		_G['MacOptionsFrameOkay']:SetPoint('LEFT', _G['MacOptionsButtonKeybindings'], 'RIGHT', 5, 0)
 
		_G['MacOptionsButtonKeybindings']:SetWidth(96)
		_G['MacOptionsButtonKeybindings']:SetHeight(22)
		_G['MacOptionsButtonKeybindings']:ClearAllPoints()
		_G['MacOptionsButtonKeybindings']:SetPoint('LEFT', _G['MacOptionsFrameDefaults'], 'RIGHT', 5, 0)
 
		_G['MacOptionsFrameDefaults']:SetWidth(96)
		_G['MacOptionsFrameDefaults']:SetHeight(22)
 
	end
end)

-- RepBar/ExpBar Skinning

for i = 1, 15 do
    local f = _G['ReputationBar'..i]
    local f2 = _G['ReputationBar'..i..'ReputationBar']
    LanFunc.RemoveRegions(f, {1})
    LanFunc.RemoveRegions(f2, {3, 4})
    f2:CreateBeautyBorder(12, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1)
    f2:SetHeight(18)
end

for i = 1, 19 do
   local XP = _G['MainMenuXPBarDiv'..i]
   XP:Hide()
   XP:SetAlpha(0)
--   XP.Hide = XP.Show
   XP.Show = XP.Hide
   XP.SetAlpha = LanFunc.dummy
end

-- Bars
MainMenuExpBar:SetPoint('TOP', ActionButton6, 21, 20)
ExhaustionTick:SetFrameLevel('3')
MainMenuExpBar:SetWidth(511)
MainMenuExpBar.SetWidth = LanFunc.dummy
MainMenuExpBar.SetPoint = LanFunc.dummy

MainMenuExpBar:CreateBeautyBorder(12, 1, 1, 1, 1)

local buttons = {
    BlackoutWorld,
}

for i in pairs(buttons) do
    buttons[i]:Hide()
    buttons[i].Show = LanFunc.dummy
end

buttons = nil

-- Font changes
local font = LanConfig.Media.Font

GameFontNormalHuge:SetFont(font, 20, 'OUTLINE')
GameFontNormalHuge:SetShadowOffset(0, 0)

GameTooltipHeaderText:SetFont(font, 17)
GameTooltipText:SetFont(font, 15)
GameTooltipTextSmall:SetFont(font, 15)

for _, font in pairs({
    _G['GameFontHighlight'],
    
    _G['GameFontDisable'],

    _G['GameFontHighlightExtraSmall'],
    _G['GameFontHighlightMedium'],
    
    _G['GameFontNormal'],
    _G['GameFontNormalSmall'],
    _G['GameFontNormalLarge'],
    _G['GameFontNormalHuge'],
    
    _G['TextStatusBarText'],
    
    _G['GameFontDisableSmall'],
    _G['GameFontHighlightSmall'],
}) do
    font:SetFont(LanConfig.Media.Font, 13)
end

for _, font in pairs({
    _G['AchievementPointsFont'],
    _G['AchievementPointsFontSmall'],
    _G['AchievementDescriptionFont'],
    _G['AchievementCriteriaFont'],
    _G['AchievementDateFont'],
}) do
    font:SetFont(LanConfig.Media.Font, 12)
end