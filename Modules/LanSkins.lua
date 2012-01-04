local c = RAID_CLASS_COLORS[select(2, UnitClass('player'))]

LanSkin = {
	['Backdrop'] = LanConfig.Media.Backdrop,
	['Glow'] = 'Interface\\AddOns\\LanUI\\Media\\glowTex',
}

LanSkin.CreateBD = function(f, a)
	f:SetBackdrop({
		bgFile = LanSkin.Backdrop,
    })
	f:SetBackdropColor(0, 0, 0, a or .75)
	f:SetBackdropBorderColor(0, 0, 0)
	
	CreateBeautyBorder(f, 12, 1, 1, 1, 1, 2, 2, 2, 1, 1, 2, 1)
end

LanSkin.CreateSD = function(parent, size, r, g, b, alpha, offset)
	local sd = CreateFrame('Frame', nil, parent)
	sd:SetBackdrop({
		edgeFile = LanSkin.Glow,
	})
	sd:SetBackdropBorderColor(0, 0, 0)
	sd:SetAlpha(0)
	
	CreateBeautyBorder(sd, 12, 1, 1, 1, 1, 2, 2, 2, 1, 1, 2, 1)
end

LanSkin.CreateTab = function(f)
	local sd = CreateFrame('Frame', nil, f)
	sd:SetBackdrop({
		bgFile = LanSkin.Backdrop,
	})
	sd:SetPoint('TOPLEFT', 13, 0)
	sd:SetPoint('BOTTOMRIGHT', -10, 0)
	sd:SetBackdropColor(unpack(LanConfig.Media.BackdropColor)
	sd:SetBackdropBorderColor(0, 0, 0)
	sd:SetFrameStrata('LOW')
	
	CreateBeautyBorder(sd, 12, 1, 1, 1, 1, 1, 1, 1, 1, -1, 1, -1)
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
	
	ColorBorder(glow, r, g, b)
	
	ColorBorder(f, r, g, b)
	
	CreateBeautyBorder(f, 12, r, g, b)
	
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
        self:SetBackdropColor(unpack(LanConfig.Media.BackdropColor)
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
            'LFDSearchStatus',
            'FriendsTooltip',
            'GhostFrame',
            'GhostFrameContentsFrame'
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
            'LFDDungeonReadyStatus',
            'ChatConfigFrame',
            'AutoCompleteBox',
            'SpellBookFrame',
            'CharacterFrame',
            'PVPFrame',
            'GearManagerDialog',
            'WorldStateScoreFrame',
            'GearManagerDialogPopup',
            'StackSplitFrame',
            'AddFriendFrame',
            'FriendsFriendsFrame',
            'ColorPickerFrame',
            'ReadyCheckFrame',
            'PetStableFrame',
            'LFDDungeonReadyDialog',
            'ReputationDetailFrame',
            'LFDRoleCheckPopup',
            "RaidInfoFrame"
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
            'FriendsFriendsList'
        }
		
		for i = 1, getn(simplebds) do
			local simplebd = _G[simplebds[i]]
			if simplebd then LanSkin.CreateBD(simplebd, .25) end
		end
		
		-- [[ Backdrop frames ]]

		FriendsBD = CreateFrame('Frame', nil, FriendsFrame)
		FriendsBD:SetPoint('TOPLEFT', 10, -30)
		FriendsBD:SetPoint('BOTTOMRIGHT', -34, 76)

		QuestBD = CreateFrame('Frame', nil, QuestLogFrame)
		QuestBD:SetPoint('TOPLEFT', 6, -9)
		QuestBD:SetPoint('BOTTOMRIGHT', -2, 6)
		QuestBD:SetFrameLevel(QuestLogFrame:GetFrameLevel()-1)

		QFBD = CreateFrame('Frame', nil, QuestFrame)
		QFBD:SetPoint('TOPLEFT', 6, -15)
		QFBD:SetPoint('BOTTOMRIGHT', -26, 64)
		QFBD:SetFrameLevel(QuestFrame:GetFrameLevel()-1)

		QDBD = CreateFrame('Frame', nil, QuestLogDetailFrame)
		QDBD:SetPoint('TOPLEFT', 6, -9)
		QDBD:SetPoint('BOTTOMRIGHT', 0, 0)
		QDBD:SetFrameLevel(QuestLogDetailFrame:GetFrameLevel()-1)

		GossipBD = CreateFrame('Frame', nil, GossipFrame)
		GossipBD:SetPoint('TOPLEFT', 6, -15)
		GossipBD:SetPoint('BOTTOMRIGHT', -26, 64)

		LFDBD = CreateFrame('Frame', nil, LFDParentFrame)
		LFDBD:SetPoint('TOPLEFT', 10, -10)
		LFDBD:SetPoint('BOTTOMRIGHT', 0, 0)

		LFRBD = CreateFrame('Frame', nil, LFRParentFrame)
		LFRBD:SetPoint('TOPLEFT', 10, -10)
		LFRBD:SetPoint('BOTTOMRIGHT', 0, 4)

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

		NPCBD = CreateFrame('Frame', nil, QuestNPCModel)
		NPCBD:SetPoint('TOPLEFT', 9, -6)
		NPCBD:SetPoint('BOTTOMRIGHT', 4, -66)
		NPCBD:SetFrameLevel(QuestNPCModel:GetFrameLevel()-1)

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

		local FrameBDs = {
            'FriendsBD',
            'QuestBD',
            'QFBD',
            'QDBD',
            'GossipBD',
            'LFDBD',
            'LFRBD',
            'MerchBD',
            'MailBD',
            'OMailBD',
            'DressBD',
            'TaxiBD',
            'TradeBD',
            'ItemBD',
            'TabardBD'
        }
        
		for i = 1, getn(FrameBDs) do
			FrameBD = _G[FrameBDs[i]]
			if FrameBD then
				LanSkin.CreateBD(FrameBD)
				LanSkin.CreateSD(FrameBD)
			end
		end

		LanSkin.CreateBD(NPCBD)

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
			PetPaperDollFrameExpBar:GetRegions():Hide()
			select(2, PetPaperDollFrameExpBar:GetRegions()):Hide()

			local bbg = CreateFrame('Frame', nil, PetPaperDollFrameExpBar)
			bbg:SetPoint('TOPLEFT', -1, 1)
			bbg:SetPoint('BOTTOMRIGHT', 1, -1)
			bbg:SetFrameLevel(PetPaperDollFrameExpBar:GetFrameLevel()-1)
			LanSkin.CreateBD(bbg, .25)
		end
		
		for i = 1, 5 do
			local tab = _G['SpellBookSkillLineTab'..i]
			local a1, p, a2, x, y = tab:GetPoint()
			local bg = CreateFrame('Frame', nil, tab)
			bg:SetPoint('TOPLEFT', -1, 1)
			bg:SetPoint('BOTTOMRIGHT', 1, -1)
			bg:SetFrameLevel(tab:GetFrameLevel()-1)
			
			tab:SetPoint(a1, p, a2, x + 11, y)
			
			select(3, tab:GetRegions()):SetTexCoord(.08, .92, .08, .92)
			select(4, tab:GetRegions()):SetTexCoord(.08, .92, .08, .92)
		end

		-- [[ Hide regions ]]

		select(3, CharacterFrame:GetRegions()):Hide()
		for i = 1, 5 do
			select(i, CharacterModelFrame:GetRegions()):Hide()
		end
		for i = 1, 3 do
			select(i, QuestLogFrame:GetRegions()):Hide()
		end
		QuestLogDetailFrame:GetRegions():Hide()
		QuestFrame:GetRegions():Hide()
		GossipFrame:GetRegions():Hide()
		for i = 1, 6 do
			for j = 1, 3 do
				select(i, _G['FriendsTabHeaderTab'..j]:GetRegions()):Hide()
				select(i, _G['FriendsTabHeaderTab'..j]:GetRegions()).Show = LanFunc.dummy
			end
		end
		select(6, FriendsFrame:GetRegions()):Hide()
		select(3, SpellBookFrame:GetRegions()):Hide()
		SpellBookCompanionModelFrameShadowOverlay:Hide()
		select(3, PVPFrame:GetRegions()):Hide()
		LFRParentFrame:GetRegions():Hide()
		for i = 1, 5 do
			select(i, MailFrame:GetRegions()):Hide()
		end
		OpenMailFrame:GetRegions():Hide()
		select(12, OpenMailFrame:GetRegions()):Hide()
		select(13, OpenMailFrame:GetRegions()):Hide()
		for i = 4, 7 do
			select(i, SendMailFrame:GetRegions()):Hide()
		end
		MerchantFrame:GetRegions():Hide()
		DressUpFrame:GetRegions():Hide()
		select(2, DressUpFrame:GetRegions()):Hide()
		for i = 8, 11 do
			select(i, DressUpFrame:GetRegions()):Hide()
		end
		select(6, TaxiFrame:GetRegions()):Hide()
		TradeFrame:GetRegions():Hide()
		select(2, TradeFrame:GetRegions()):Hide()
		for i = 1, 4 do
			select(i, GearManagerDialogPopup:GetRegions()):Hide()
		end
		StackSplitFrame:GetRegions():Hide()
		ItemTextFrame:GetRegions():Hide()
		select(3, ItemTextScrollFrame:GetRegions()):Hide()
		select(3, PetStableFrame:GetRegions()):Hide()
		select(4, ReputationDetailFrame:GetRegions()):Hide()
		select(5, ReputationDetailFrame:GetRegions()):Hide()
		select(2, QuestNPCModel:GetRegions()):Hide()
		TabardFrame:GetRegions():Hide()
		BNToastFrameCloseButton:SetAlpha(0)
		PetStableModelShadow:Hide()
		LFDParentFramePortrait:Hide()
		select(2, RaidInfoFrame:GetRegions()):Hide()
		select(4, RaidInfoFrame:GetRegions()):Hide()
		select(3, RaidInfoFrame:GetRegions()):Hide()

		local slots = {
			'Head', 'Neck', 'Shoulder', 'Shirt', 'Chest', 'Waist', 'Legs', 'Feet', 'Wrist',
			'Hands', 'Finger0', 'Finger1', 'Trinket0', 'Trinket1', 'Back', 'MainHand',
			'SecondaryHand', 'Ranged', 'Tabard',
		}

		for i = 1, getn(slots) do
			_G['Character'..slots[i]..'Slot']:SetNormalTexture('')
			local bd = CreateFrame('Frame', nil, _G['Character'..slots[i]..'Slot'])
			bd:SetPoint('TOPLEFT', -1, 1)
			bd:SetPoint('BOTTOMRIGHT', 1, -1)
			
			CreateBeautyBorder(bd, 12, 1, 1, 1)
			
			bd:SetBackdropColor(0, 0, 0, 0)
		end	

		NORMAL_QUEST_DISPLAY = '|cffffffff%s|r'
		TRIVIAL_QUEST_DISPLAY = '|cffffffff%s (Low Level)|r'

		local newquestcolor = function(template, parentFrame, acceptButton, material)
			QuestInfoTitleHeader:SetTextColor(0.95, 0.95, 0);
			QuestInfoDescriptionHeader:SetTextColor(0.95, 0.95, 0);
			QuestInfoObjectivesHeader:SetTextColor(0.95, 0.95, 0);
			QuestInfoRewardsHeader:SetTextColor(0.95, 0.95, 0);
            
			-- other text
			QuestInfoDescriptionText:SetTextColor(1, 1, 1);
			QuestInfoObjectivesText:SetTextColor(1, 1, 1);
			QuestInfoGroupSize:SetTextColor(1, 1, 1);
			QuestInfoRewardText:SetTextColor(1, 1, 1);
            
			-- reward frame text
			QuestInfoItemChooseText:SetTextColor(1, 1, 1);
			QuestInfoItemReceiveText:SetTextColor(1, 1, 1);
			QuestInfoSpellLearnText:SetTextColor(1, 1, 1);		
			QuestInfoXPFrameReceiveText:SetTextColor(1, 1, 1);

			local numObjectives = GetNumQuestLeaderBoards();
			local objective;
			local text, type, finished;
			local numVisibleObjectives = 0;
			for i = 1, numObjectives do
				text, type, finished = GetQuestLogLeaderBoard(i);
				if (type ~= 'spell') then
					numVisibleObjectives = numVisibleObjectives+1;
					objective = _G['QuestInfoObjective'..numVisibleObjectives];
					objective:SetTextColor(1, 1, 1);
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
			fontString:SetTextColor(1, 1, 1);
		end

		function GossipFrameOptionsUpdate(...)
			local titleButton;
			local titleIndex = 1;
			local titleButtonIcon;
			for i=1, select('#', ...), 2 do
				if ( GossipFrame.buttonIndex > NUMGOSSIPBUTTONS ) then
					message('This NPC has too many quests and/or gossip options.');
				end
				titleButton = _G['GossipTitleButton' .. GossipFrame.buttonIndex];
				titleButton:SetFormattedText('|cffffffff%s|r', select(i, ...));
				GossipResize(titleButton);
				titleButton:SetID(titleIndex);
				titleButton.type='Gossip';
				titleButtonIcon = _G[titleButton:GetName() .. 'GossipIcon'];
				titleButtonIcon:SetTexture('Interface\\GossipFrame\\' .. select(i+1, ...) .. 'GossipIcon');
				titleButtonIcon:SetVertexColor(1, 1, 1, 1);
				GossipFrame.buttonIndex = GossipFrame.buttonIndex + 1;
				titleIndex = titleIndex + 1;
				titleButton:Show();
			end
		end

		local newspellbookcolor = function(self)
			local slot, slotType = SpellBook_GetSpellBookSlot(self);
			local name = self:GetName();
			-- local spellString = _G[name..'SpellName'];
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
			self.spellString:SetTextColor(1, 1, 1);	
			self.subSpellString:SetTextColor(1, 1, 1)
		end	
	
		function PaperDollFrame_SetLevel()
			local primaryTalentTree = GetPrimaryTalentTree()
			local classDisplayName, class = UnitClass('player')
			local classColorString = format('ff%.2x%.2x%.2x', c.r * 255, c.g * 255, c.b * 255)
			local specName

			if (primaryTalentTree) then
				_, specName = GetTalentTabInfo(primaryTalentTree);
			end

			if (specName and specName ~= '') then
				CharacterLevelText:SetFormattedText(PLAYER_LEVEL, UnitLevel('player'), classColorString, specName, classDisplayName);
			else
				CharacterLevelText:SetFormattedText(PLAYER_LEVEL_NO_SPEC, UnitLevel('player'), classColorString, classDisplayName);
			end
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
		
        hooksecurefunc('QuestInfo_Display', newquestcolor)
		hooksecurefunc('GossipFrameUpdate', newgossipcolor)
		hooksecurefunc('SpellButton_UpdateButton', newspellbookcolor)
		hooksecurefunc('FormatProfession', newprofcolor)
		hooksecurefunc('UpdateProfessionButton', newprofbuttoncolor)
		

		_G['ReadyCheckFrame']:HookScript('OnShow', function(self) if UnitIsUnit('player', self.initiator) then self:Hide() end end)

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

		GearManagerDialog:ClearAllPoints()
		GearManagerDialog:SetPoint('TOPLEFT', PaperDollFrame, 'TOPRIGHT', 10, 0)

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

		TaxiFrameCloseButton:ClearAllPoints()
		TaxiFrameCloseButton:SetPoint('TOPRIGHT', TaxiRouteMap, 'TOPRIGHT')

		local a1, p, a2, x, y = ReputationDetailFrame:GetPoint()
		ReputationDetailFrame:SetPoint(a1, p, a2, x + 10, y)

		-- [[ Tabs ]]

		for i = 1, 5 do
			LanSkin.CreateTab(_G['SpellBookFrameTabButton'..i])
		end

		for i = 1, 4 do
			LanSkin.CreateTab(_G['FriendsFrameTab'..i])
            _G['FriendsFrameTab'..i..'HighlightTexture']:SetTexture(nil)
			if _G['CharacterFrameTab'..i] then
				LanSkin.CreateTab(_G['CharacterFrameTab'..i])
			end
		end

		for i = 1, 3 do
			LanSkin.CreateTab(_G['PVPFrameTab'..i])
			LanSkin.CreateTab(_G['WorldStateScoreFrameTab'..i])
		end

		for i = 1, 2 do
			LanSkin.CreateTab(_G['LFRParentFrameTab'..i])
			LanSkin.CreateTab(_G['MerchantFrameTab'..i])
			LanSkin.CreateTab(_G['MailFrameTab'..i])
		end

		-- [[ Buttons ]]

		for i = 1, 2 do
			for j = 1, 2 do
				LanSkin.Reskin(_G['StaticPopup'..i..'Button'..j])
			end
		end

		local buttons = {'VideoOptionsFrameOkay', 'VideoOptionsFrameCancel', 'VideoOptionsFrameDefaults', 'VideoOptionsFrameApply', 'AudioOptionsFrameOkay', 'AudioOptionsFrameCancel', 'AudioOptionsFrameDefaults', 'InterfaceOptionsFrameDefaults', 'InterfaceOptionsFrameOkay', 'InterfaceOptionsFrameCancel', 'ChatConfigFrameOkayButton', 'ChatConfigFrameDefaultButton', 'DressUpFrameCancelButton', 'DressUpFrameResetButton', 'WhoFrameWhoButton', 'WhoFrameAddFriendButton', 'WhoFrameGroupInviteButton', 'GearManagerDialogDeleteSet', 'GearManagerDialogEquipSet', 'GearManagerDialogSaveSet', 'SendMailMailButton', 'SendMailCancelButton', 'OpenMailReplyButton', 'OpenMailDeleteButton', 'OpenMailCancelButton', 'OpenMailReportSpamButton', 'aMailButton', 'QuestLogFrameAbandonButton', 'QuestLogFramePushQuestButton', 'QuestLogFrameTrackButton', 'QuestLogFrameCancelButton', 'QuestFrameAcceptButton', 'QuestFrameDeclineButton', 'QuestFrameCompleteQuestButton', 'QuestFrameCompleteButton', 'QuestFrameGoodbyeButton', 'GossipFrameGreetingGoodbyeButton', 'QuestFrameGreetingGoodbyeButton', 'ChannelFrameNewButton', 'RaidFrameRaidInfoButton', 'RaidFrameConvertToRaidButton', 'TradeFrameTradeButton', 'TradeFrameCancelButton', 'GearManagerDialogPopupOkay', 'GearManagerDialogPopupCancel', 'StackSplitOkayButton', 'StackSplitCancelButton', 'TabardFrameAcceptButton', 'TabardFrameCancelButton', 'GameMenuButtonOptions', 'GameMenuButtonSoundOptions', 'GameMenuButtonUIOptions', 'GameMenuButtonKeybindings', 'GameMenuButtonMacros', 'GameMenuButtonAddOns', 'GameMenuButtonLogout', 'GameMenuButtonQuit', 'GameMenuButtonContinue', 'GameMenuButtonMacOptions', 'FriendsFrameAddFriendButton', 'FriendsFrameSendMessageButton', 'LFDQueueFrameFindGroupButton', 'LFDQueueFrameCancelButton', 'LFRQueueFrameFindGroupButton', 'LFRQueueFrameAcceptCommentButton', 'PVPFrameLeftButton', 'PVPHonorFrameWarGameButton', 'PVPFrameRightButton', 'RaidFrameNotInRaidRaidBrowserButton', 'WorldStateScoreFrameLeaveButton', 'SpellBookCompanionSummonButton', 'AddFriendEntryFrameAcceptButton', 'AddFriendEntryFrameCancelButton', 'FriendsFriendsSendRequestButton', 'FriendsFriendsCloseButton', 'ColorPickerOkayButton', 'ColorPickerCancelButton', 'FriendsFrameIgnorePlayerButton', 'FriendsFrameUnsquelchButton', 'LFDDungeonReadyDialogEnterDungeonButton', 'LFDDungeonReadyDialogLeaveQueueButton', 'LFRBrowseFrameSendMessageButton', 'LFRBrowseFrameInviteButton', 'LFRBrowseFrameRefreshButton', 'LFDRoleCheckPopupAcceptButton', 'LFDRoleCheckPopupDeclineButton', 'GuildInviteFrameJoinButton', 'GuildInviteFrameDeclineButton', 'FriendsFramePendingButton1AcceptButton', 'FriendsFramePendingButton1DeclineButton'}
		for i = 1, getn(buttons) do
		local reskinbutton = _G[buttons[i]]
			if reskinbutton then
				LanSkin.Reskin(reskinbutton)
			end
		end

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
		AuctionDressUpFrame:ClearAllPoints()
		AuctionDressUpFrame:SetPoint('LEFT', AuctionFrame, 'RIGHT', 10, 0)
		LanSkin.CreateBD(AuctionDressUpFrame)
		LanSkin.CreateSD(AuctionDressUpFrame)

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
        
		for i = 1, 4 do
			select(i, AuctionDressUpFrame:GetRegions()):Hide()
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
            'AuctionDressUpFrameResetButton',
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
					select(j, _G['AchievementFrameTab'..i]:GetRegions()).Show = LanSkin.dummy
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
				sd:SetBackdropColor(unpack(LanConfig.Media.BackdropColor)
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
			CreateBeautyBorder(_G['CalendarDayButton'..i], 12, R, G, B, 1, 1, 1, 1, 1,1, 1, 1) -- But i had one =)
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
		GlyphFrame:GetRegions():Hide()
	elseif addon == 'Blizzard_GuildBankUI' then
		LanSkin.CreateBD(GuildBankFrame)
		LanSkin.CreateSD(GuildBankFrame)
        
		for i = 1, 4 do
			LanSkin.CreateTab(_G['GuildBankFrameTab'..i])
		end
        
		LanSkin.Reskin(GuildBankFrameWithdrawButton)
		LanSkin.Reskin(GuildBankFrameDepositButton)
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
		select(5, GuildInfoFrame:GetRegions()):Hide()
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
		GuildNewsFiltersFrame:ClearAllPoints()
		GuildNewsFiltersFrame:SetPoint('TOPLEFT', GuildFrame, 'TOPRIGHT', 10, -10)
		GuildMemberDetailFrame:ClearAllPoints()
		GuildMemberDetailFrame:SetPoint('TOPLEFT', GuildFrame, 'TOPRIGHT', 10, -10)
		GuildLevelFrame:SetAlpha(0)
		LanSkin.Reskin(GuildMemberGroupInviteButton)
		LanSkin.Reskin(GuildMemberRemoveButton)
		local closebutton = select(4, GuildTextEditFrame:GetChildren())
		LanSkin.Reskin(closebutton)
		local logbutton = select(3, GuildLogFrame:GetChildren())
		LanSkin.Reskin(logbutton)
		local gbuttons = {
            'GuildAddMemberButton',
            'GuildViewLogButton',
            'GuildControlButton',
            'GuildTextEditFrameAcceptButton'
        }
        
		for i = 1, getn(gbuttons) do
            local gbutton = _G[gbuttons[i]]
			if gbutton then
				LanSkin.Reskin(gbutton)
			end
		end
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
			bd:SetBackdropColor(0, 0, 0, 0)
			
			CreateBeautyBorder(bd, 12, 1, 1, 1)
			
			_G['Inspect'..slots[i]..'Slot']:SetNormalTexture('')
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
				select(j, _G['InspectTalentFrameTab'..i]:GetRegions()).Show = LanSkin.dummy
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
			select(i, MacroFrameTab1:GetRegions()).Show = LanSkin.dummy
			select(i, MacroFrameTab2:GetRegions()).Show = LanSkin.dummy
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
	elseif addon == 'Blizzard_RaidUI' then
		for i = 1, 5 do
			if i ~= 3 and i ~= 2 then select(i, CompactRaidFrameManagerDisplayFrame:GetRegions()):Hide() end
		end
        
		for i = 1, 8 do
			select(i, CompactRaidFrameManager:GetRegions()):Hide()
		end
        
		LanSkin.CreateBD(CompactRaidFrameManagerDisplayFrame)
		LanSkin.CreateSD(CompactRaidFrameManagerDisplayFrame)
		local rbuttons = {'CompactRaidFrameManagerToggleButton', 'CompactRaidFrameManagerDisplayFrameFilterRoleTank', 'CompactRaidFrameManagerDisplayFrameFilterRoleHealer', 'CompactRaidFrameManagerDisplayFrameFilterRoleDamager', 'CompactRaidFrameManagerDisplayFrameFilterGroup1', 'CompactRaidFrameManagerDisplayFrameFilterGroup2', 'CompactRaidFrameManagerDisplayFrameFilterGroup3', 'CompactRaidFrameManagerDisplayFrameFilterGroup4', 'CompactRaidFrameManagerDisplayFrameFilterGroup5', 'CompactRaidFrameManagerDisplayFrameFilterGroup6', 'CompactRaidFrameManagerDisplayFrameFilterGroup7', 'CompactRaidFrameManagerDisplayFrameFilterGroup8', 'CompactRaidFrameManagerDisplayFrameLockedModeToggle', 'CompactRaidFrameManagerDisplayFrameHiddenModeToggle', 'CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateRolePoll', 'CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateReadyCheck', 'CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton', 'RaidFrameRaidBrowserButton'}
		
        for i = 1, getn(rbuttons) do
			local rbutton = _G[rbuttons[i]]
			if rbutton then
				LanSkin.Reskin(rbutton)
			end
		end
		
        CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:SetText('Mark') -- because the texture is hidden, don't want an empty button
		CompactRaidFrameManagerDisplayFrameOptionsButton:Hide()
		local a1, p, a2, x, y = CompactRaidFrameManagerToggleButton:GetPoint()
		CompactRaidFrameManagerToggleButton:SetPoint(a1, p, a2, x + 5, y)
	elseif addon == 'Blizzard_ReforgingUI' then
		LanSkin.CreateBD(ReforgingFrame)
		LanSkin.CreateSD(ReforgingFrame)
		select(3, ReforgingFrame:GetRegions()):Hide()
		LanSkin.Reskin(ReforgingFrameRestoreButton)
		LanSkin.Reskin(ReforgingFrameReforgeButton)
	elseif addon == 'Blizzard_TalentUI' then
		LanSkin.CreateBD(PlayerTalentFrame)
		LanSkin.CreateSD(PlayerTalentFrame)
		local talentbuttons = { 'PlayerTalentFrameToggleSummariesButton', 'PlayerTalentFrameLearnButton', 'PlayerTalentFrameResetButton' }
		
        for i = 1, getn(talentbuttons) do
            local reskinbutton = _G[talentbuttons[i]]
			if reskinbutton then
				LanSkin.Reskin(reskinbutton)
			end
		end
        
		select(3, PlayerTalentFrame:GetRegions()):Hide()
		
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
                   
				CreateBeautyBorder(tab, 12, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2)
			select(2, tab:GetRegions()):SetTexCoord(.08, .92, .08, .92)
		end
	elseif addon == 'Blizzard_TradeSkillUI' then
		LanSkin.CreateBD(TradeSkillFrame)
		LanSkin.CreateSD(TradeSkillFrame)
		select(3, TradeSkillFrame:GetRegions()):Hide()
		select(3, TradeSkillFrame:GetRegions()).Show = LanFunc.dummy
		select(21, TradeSkillFrame:GetRegions()):Hide()
		select(22, TradeSkillFrame:GetRegions()):Hide()
		local tradeskillbuttons = {
            'TradeSkillCreateButton',
            'TradeSkillCreateAllButton',
            'TradeSkillCancelButton'
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
