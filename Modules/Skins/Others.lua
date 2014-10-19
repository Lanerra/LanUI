local F, C, G = unpack(select(2, ...))
local bc = C.Media.BorderColor

local function LoadSkin()
	-- Others Blizzard frame we want to reskin
	GameMenuFrame:StripTextures()
	local skins = {
		'StaticPopup1',
		'StaticPopup2',
		'StaticPopup3',
		'StaticPopup4',
		'GameMenuFrame',
		'VideoOptionsFrame',
		'AudioOptionsFrame',
		'LFDDungeonReadyStatus',
		'TicketStatusFrameButton',
		'LFDSearchStatus',
		'AutoCompleteBox',
		'ConsolidatedBuffsTooltip',
		'ReadyCheckFrame',
		'StackSplitFrame',
		'CharacterFrame',
		'VoiceChatTalkers'
	}

	for i = 1, getn(skins) do
		if _G[skins[i]] then
			_G[skins[i]]:SetTemplate()
		end
	end
	
	InterfaceOptionsFrame:StripTextures()
	InterfaceOptionsFrame:CreateBD(true)
	--InterfaceOptionsFrame.backdrop:SetTemplate(true)

	--LFD Role Picker frame
	LFDRoleCheckPopup:StripTextures()
	LFDRoleCheckPopup:SetTemplate()
	LFDRoleCheckPopupAcceptButton:SkinButton()
	LFDRoleCheckPopupDeclineButton:SkinButton()
	LFDRoleCheckPopupRoleButtonTank:GetChildren():SkinCheckBox()
	LFDRoleCheckPopupRoleButtonDPS:GetChildren():SkinCheckBox()
	LFDRoleCheckPopupRoleButtonHealer:GetChildren():SkinCheckBox()
	LFDRoleCheckPopupRoleButtonTank:GetChildren():SetFrameLevel(LFDRoleCheckPopupRoleButtonTank:GetChildren():GetFrameLevel() + 1)
	LFDRoleCheckPopupRoleButtonDPS:GetChildren():SetFrameLevel(LFDRoleCheckPopupRoleButtonDPS:GetChildren():GetFrameLevel() + 1)
	LFDRoleCheckPopupRoleButtonHealer:GetChildren():SetFrameLevel(LFDRoleCheckPopupRoleButtonHealer:GetChildren():GetFrameLevel() + 1)

	-- Cinematic popup
	CinematicFrameCloseDialog:SetTemplate()
	CinematicFrameCloseDialog:SetScale(C.Tweaks.UIScale)
	CinematicFrameCloseDialogConfirmButton:SkinButton()
	CinematicFrameCloseDialogResumeButton:SkinButton()
	
	-- Report Cheats
	ReportCheatingDialog:StripTextures()
	ReportCheatingDialog:SetTemplate()
	ReportCheatingDialogReportButton:SkinButton()
	ReportCheatingDialogCancelButton:SkinButton()
	ReportCheatingDialogCommentFrame:StripTextures()
	ReportCheatingDialogCommentFrameEditBox:SkinEditBox()
	
	-- Report Name
	ReportPlayerNameDialog:StripTextures()
	ReportPlayerNameDialog:SetTemplate()
	ReportPlayerNameDialogReportButton:SkinButton()
	ReportPlayerNameDialogCancelButton:SkinButton()
	ReportPlayerNameDialogCommentFrame:StripTextures()
	ReportPlayerNameDialogCommentFrameEditBox:SkinEditBox()
	
	-- reskin popup buttons
	for i = 1, 4 do
		for j = 1, 3 do
			_G['StaticPopup'..i..'Button'..j]:SkinButton()
			_G['StaticPopup'..i..'EditBox']:SkinEditBox()
			_G['StaticPopup'..i..'MoneyInputFrameGold']:SkinEditBox()
			_G['StaticPopup'..i..'MoneyInputFrameSilver']:SkinEditBox()
			_G['StaticPopup'..i..'MoneyInputFrameCopper']:SkinEditBox()
			_G['StaticPopup'..i..'EditBox'].backdrop:Point('TOPLEFT', -2, -4)
			_G['StaticPopup'..i..'EditBox'].backdrop:Point('BOTTOMRIGHT', 2, 4)
			_G['StaticPopup'..i..'ItemFrameNameFrame']:Kill()
			_G['StaticPopup'..i..'ItemFrame']:GetNormalTexture():Kill()
			_G['StaticPopup'..i..'ItemFrame']:SetTemplate()
			_G['StaticPopup'..i..'ItemFrame']:StyleButton()
			_G['StaticPopup'..i..'ItemFrameIconTexture']:SetTexCoord(.08, .92, .08, .92)
			_G['StaticPopup'..i..'ItemFrameIconTexture']:ClearAllPoints()
			_G['StaticPopup'..i..'ItemFrameIconTexture']:Point('TOPLEFT', 2, -2)
			_G['StaticPopup'..i..'ItemFrameIconTexture']:Point('BOTTOMRIGHT', -2, 2)
		end
	end

	-- reskin all esc/menu buttons
	local BlizzardMenuButtons = {
		'Options',
		'SoundOptions',
		'UIOptions',
		'Keybindings',
		'Macros',
		'AddOns',
		'WhatsNew',
		'Ratings',
		'Addons',
		'Logout',
		'Quit',
		'Continue',
		'MacOptions',
		'Store',
		'Help'
	}

	for i = 1, getn(BlizzardMenuButtons) do
		local button = _G['GameMenuButton'..BlizzardMenuButtons[i]]
		
		GameMenuButtonHelp:Point('CENTER', GameMenuFrame, 'TOP', 0, -36)
		GameMenuButtonStore:Point('TOP', GameMenuButtonHelp, 'BOTTOM', 0, -4)
		GameMenuButtonWhatsNew:Point('TOP', GameMenuButtonStore, 'BOTTOM', 0, -4)
		GameMenuButtonOptions:Point('TOP', GameMenuButtonWhatsNew, 'BOTTOM', 0, -4)
		GameMenuButtonUIOptions:Point('TOP', GameMenuButtonOptions, 'BOTTOM', 0, -4)
		GameMenuButtonKeybindings:Point('TOP', GameMenuButtonUIOptions, 'BOTTOM', 0, -4)
		GameMenuButtonAddons:Point('TOP', GameMenuButtonKeybindings, 'BOTTOM', 0, -4)
		GameMenuButtonMacros:Point('TOP', GameMenuButtonAddons, 'BOTTOM', 0, -4)
		GameMenuButtonLogout:Point('TOP', GameMenuButtonMacros, 'BOTTOM', 0, -4)
		
		if button then
			button:Reskin()
			button.SetPoint = F.Dummy
		end
	end

	if IsAddOnLoaded('OptionHouse') then
		GameMenuButtonOptionHouse:SkinButton()
	end

	-- hide header textures and move text/buttons.
	local BlizzardHeader = {
		'GameMenuFrame', 
		'InterfaceOptionsFrame', 
		'AudioOptionsFrame', 
		'VideoOptionsFrame',
	}

	for i = 1, getn(BlizzardHeader) do
		local title = _G[BlizzardHeader[i]..'Header']			
		if title then
			title:SetTexture('')
			title:ClearAllPoints()
			if title == _G['GameMenuFrameHeader'] then
				title:SetPoint('TOP', GameMenuFrame, 0, 7)
			else
				title:SetPoint('TOP', BlizzardHeader[i], 0, 0)
			end
		end
	end

	-- here we reskin all 'normal' buttons
	local BlizzardButtons = {
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
		'ReadyCheckFrameYesButton',
		'ReadyCheckFrameNoButton',
		'StackSplitOkayButton',
		'StackSplitCancelButton',
		'RolePollPopupAcceptButton',
		'InterfaceOptionsHelpPanelResetTutorials',
		'CompactUnitFrameProfilesGeneralOptionsFrameResetPositionButton',
	}

	for i = 1, getn(BlizzardButtons) do
		local Buttons = _G[BlizzardButtons[i]]
		if Buttons then
			Buttons:SkinButton()
		end
	end

	-- if a button position is not really where we want, we move it here
	_G['VideoOptionsFrameCancel']:ClearAllPoints()
	_G['VideoOptionsFrameCancel']:SetPoint('RIGHT',_G['VideoOptionsFrameApply'],'LEFT',-4,0)		 
	_G['VideoOptionsFrameOkay']:ClearAllPoints()
	_G['VideoOptionsFrameOkay']:SetPoint('RIGHT',_G['VideoOptionsFrameCancel'],'LEFT',-4,0)	
	_G['AudioOptionsFrameOkay']:ClearAllPoints()
	_G['AudioOptionsFrameOkay']:SetPoint('RIGHT',_G['AudioOptionsFrameCancel'],'LEFT',-4,0)
	_G['InterfaceOptionsFrameOkay']:ClearAllPoints()
	_G['InterfaceOptionsFrameOkay']:SetPoint('RIGHT',_G['InterfaceOptionsFrameCancel'],'LEFT', -4,0)
	_G['ReadyCheckFrameYesButton']:SetParent(_G['ReadyCheckFrame'])
	_G['ReadyCheckFrameNoButton']:SetParent(_G['ReadyCheckFrame'])
	_G['ReadyCheckFrameYesButton']:ClearAllPoints()
	_G['ReadyCheckFrameNoButton']:ClearAllPoints()
	_G['ReadyCheckFrameYesButton']:SetPoint('RIGHT', _G['ReadyCheckFrame'], 'CENTER', -2, -20)
	_G['ReadyCheckFrameNoButton']:SetPoint('LEFT', _G['ReadyCheckFrameYesButton'], 'RIGHT', 3, 0)
	_G['ReadyCheckFrameText']:SetParent(_G['ReadyCheckFrame'])	
	_G['ReadyCheckFrameText']:ClearAllPoints()
	_G['ReadyCheckFrameText']:SetPoint('TOP', 0, -12)

	-- others
	_G['ReadyCheckListenerFrame']:SetAlpha(0)
	_G['ReadyCheckFrame']:HookScript('OnShow', function(self) if UnitIsUnit('player', self.initiator) then self:Hide() end end) -- bug fix, don't show it if initiator
	_G['StackSplitFrame']:GetRegions():Hide()
	_G['GeneralDockManagerOverflowButtonList']:SetTemplate()

	RolePollPopup:SetTemplate()
	RolePollPopupCloseButton:SkinCloseButton()
	
	BasicScriptErrors:StripTextures()
	BasicScriptErrors:SetTemplate()
	BasicScriptErrorsButton:SkinButton()
	BasicScriptErrors:SetScale(C.Tweaks.UIScale)
	
	for i = 1, 4 do
		local button = _G['StaticPopup'..i..'CloseButton']
		button:SetNormalTexture('')
		button.SetNormalTexture = F.Dummy
		button:SetPushedTexture('')
		button.SetPushedTexture = F.Dummy
		button:SkinCloseButton()
	end
    
	local frames = {
		'VideoOptionsFrameCategoryFrame',
		'VideoOptionsFramePanelContainer',
		'InterfaceOptionsFrameCategories',
		'InterfaceOptionsFramePanelContainer',
		'InterfaceOptionsFrameAddOns',
		'AudioOptionsSoundPanelPlayback',
		'AudioOptionsSoundPanelVolume',
		'AudioOptionsSoundPanelHardware',
		'AudioOptionsVoicePanelTalking',
		'AudioOptionsVoicePanelBinding',
		'AudioOptionsVoicePanelListening',
	}
		
	for i = 1, getn(frames) do
		local SkinFrames = _G[frames[i]]
		if SkinFrames then
			SkinFrames:StripTextures()
			SkinFrames:CreateBD(true)
			if SkinFrames ~= _G['VideoOptionsFramePanelContainer'] and SkinFrames ~= _G['InterfaceOptionsFramePanelContainer'] then
				SkinFrames.backdrop:Point('TOPLEFT',-1,0)
				SkinFrames.backdrop:Point('BOTTOMRIGHT',0,1)
			else
				SkinFrames.backdrop:Point('TOPLEFT', 0, 0)
				SkinFrames.backdrop:Point('BOTTOMRIGHT', 0, 0)
			end
		end
	end
	InterfaceOptionsFrameCategories:SetFrameLevel(3)
--[[	InterfaceOptionsFrameCategories.backdrop:SetTemplate(true)
	InterfaceOptionsFrameAddOns.backdrop:SetTemplate(true)
	InterfaceOptionsFramePanelContainer.backdrop:SetTemplate(true)]]

	local interfacetab = {
		'InterfaceOptionsFrameTab1',
		'InterfaceOptionsFrameTab2',
	}
	
	for i = 1, getn(interfacetab) do
		local itab = _G[interfacetab[i]]
		if itab then
			itab:StripTextures()
			itab:SkinTab()
			itab:SetFrameStrata('HIGH')
			itab:SetFrameLevel(InterfaceOptionsFrameCategories:GetFrameLevel() - 1)
		end
	end
	
	InterfaceOptionsFrameTab1:ClearAllPoints()
	InterfaceOptionsFrameTab1:SetPoint('BOTTOMLEFT',InterfaceOptionsFrameCategories,'TOPLEFT', 0, -2)
	InterfaceOptionsFrameTab2:ClearAllPoints()
	InterfaceOptionsFrameTab2:Point('LEFT', InterfaceOptionsFrameTab1, 'RIGHT', 4, 0)

	VideoOptionsFrameDefaults:ClearAllPoints()
	InterfaceOptionsFrameDefaults:ClearAllPoints()
	InterfaceOptionsFrameCancel:ClearAllPoints()
	VideoOptionsFrameDefaults:SetPoint('TOPLEFT',VideoOptionsFrameCategoryFrame,'BOTTOMLEFT',-1,-5)
	InterfaceOptionsFrameDefaults:SetPoint('TOPLEFT',InterfaceOptionsFrameCategories,'BOTTOMLEFT',-1,-5)
	InterfaceOptionsFrameCancel:SetPoint('TOPRIGHT',InterfaceOptionsFramePanelContainer,'BOTTOMRIGHT',0,-6)
	
	local interfacecheckbox = {
		-- Controls
		'ControlsPanelStickyTargeting',
		'ControlsPanelAutoDismount',
		'ControlsPanelAutoClearAFK',
		'ControlsPanelBlockTrades',
		'ControlsPanelBlockGuildInvites',
		'ControlsPanelLootAtMouse',
		'ControlsPanelAutoLootCorpse',
		'ControlsPanelAutoOpenLootHistory',
		'ControlsPanelInteractOnLeftClick',
		'ControlsPanelBlockChatChannelInvites',
		'ControlsPanelReverseCleanUpBags',
		'ControlsPanelReverseNewLoot',
		-- Combat
		'CombatPanelAttackOnAssist',
		'CombatPanelStopAutoAttack',
		'CombatPanelTargetOfTarget',
		'CombatPanelShowSpellAlerts',
		'CombatPanelReducedLagTolerance',
		'CombatPanelActionButtonUseKeyDown',
		'CombatPanelLossOfControl',
		'CombatPanelEnemyCastBarsOnPortrait',
		'CombatPanelEnemyCastBarsOnNameplates',
		'CombatPanelAutoSelfCast',
		-- Display
		'DisplayPanelShowCloak',
		'DisplayPanelShowHelm',
		'DisplayPanelShowAggroPercentage',
		'DisplayPanelPlayAggroSounds',
		'DisplayPanelShowSpellPointsAvg',
		'DisplayPanelShowFreeBagSpace',
		'DisplayPanelCinematicSubtitles',
		'DisplayPanelRotateMinimap',
		'DisplayPanelShowAccountAchievments',
		--Objectives
		'ObjectivesPanelAutoQuestTracking',
		'ObjectivesPanelMapFade',
		-- Social
		'SocialPanelProfanityFilter',
		'SocialPanelSpamFilter',
		'SocialPanelChatBubbles',
		'SocialPanelPartyChat',
		'SocialPanelChatHoverDelay',
		'SocialPanelGuildMemberAlert',
		'SocialPanelChatMouseScroll',
		'SocialPanelWholeChatWindowClickable',
		-- Action bars
		'ActionBarsPanelBottomLeft',
		'ActionBarsPanelBottomRight',
		'ActionBarsPanelRight',
		'ActionBarsPanelRightTwo',
		'ActionBarsPanelLockActionBars',
		'ActionBarsPanelAlwaysShowActionBars',
		'ActionBarsPanelSecureAbilityToggle',
		'ActionBarsPanelCountdownCooldowns',
		-- Names
		'NamesPanelMyName',
		'NamesPanelFriendlyPlayerNames',
		'NamesPanelFriendlyPets',
		'NamesPanelFriendlyGuardians',
		'NamesPanelFriendlyTotems',
		'NamesPanelUnitNameplatesFriends',
		'NamesPanelUnitNameplatesFriendlyGuardians',
		'NamesPanelUnitNameplatesFriendlyPets',
		'NamesPanelUnitNameplatesFriendlyTotems',
		'NamesPanelGuilds',
		'NamesPanelGuildTitles',
		'NamesPanelTitles',
		'NamesPanelNonCombatCreature',
		'NamesPanelEnemyPlayerNames',
		'NamesPanelEnemyPets',
		'NamesPanelEnemyGuardians',
		'NamesPanelEnemyTotems',
		'NamesPanelUnitNameplatesEnemyPets',
		'NamesPanelUnitNameplatesEnemies',
		'NamesPanelUnitNameplatesEnemyGuardians',
		'NamesPanelUnitNameplatesEnemyTotems',
		'NamesPanelMinus',
		'NamesPanelUnitNameplatesEnemyMinus',
		-- Combat Text
		'CombatTextPanelTargetDamage',
		'CombatTextPanelPeriodicDamage',
		'CombatTextPanelPetDamage',
		'CombatTextPanelHealing',
		'CombatTextPanelTargetEffects',
		'CombatTextPanelOtherTargetEffects',
		'CombatTextPanelEnableFCT',
		'CombatTextPanelDodgeParryMiss',
		'CombatTextPanelDamageReduction',
		'CombatTextPanelRepChanges',
		'CombatTextPanelReactiveAbilities',
		'CombatTextPanelFriendlyHealerNames',
		'CombatTextPanelCombatState',
		'CombatTextPanelComboPoints',
		'CombatTextPanelLowManaHealth',
		'CombatTextPanelEnergyGains',
		'CombatTextPanelPeriodicEnergyGains',
		'CombatTextPanelHonorGains',
		'CombatTextPanelAuras',
		'CombatTextPanelAutoSelfCast',
		'CombatTextPanelPetBattle',
		-- Status Text
		'StatusTextPanelPlayer',
		'StatusTextPanelPet',
		'StatusTextPanelParty',
		'StatusTextPanelTarget',
		'StatusTextPanelAlternateResource',
		'StatusTextPanelXP',
		-- Unit Frames
		'UnitFramePanelPartyPets',
		'UnitFramePanelArenaEnemyFrames',
		'UnitFramePanelArenaEnemyCastBar',
		'UnitFramePanelArenaEnemyPets',
		'UnitFramePanelFullSizeFocusFrame',
		-- Buffs & Debuffs
		'BuffsPanelDispellableDebuffs',
		'BuffsPanelCastableBuffs',
		'BuffsPanelConsolidateBuffs',
		'BuffsPanelShowAllEnemyDebuffs',
		--Battle net
		'BattlenetPanelOnlineFriends',
		'BattlenetPanelOfflineFriends',
		'BattlenetPanelBroadcasts',
		'BattlenetPanelFriendRequests',
		'BattlenetPanelConversations',
		'BattlenetPanelShowToastWindow',
		-- Camera
		'CameraPanelFollowTerrain',
		'CameraPanelHeadBob',
		'CameraPanelWaterCollision',
		'CameraPanelSmartPivot',
		-- Mouse
		'MousePanelInvertMouse',
		'MousePanelClickToMove',
		'MousePanelWoWMouse',
		-- Help
		'HelpPanelShowTutorials',
		'HelpPanelEnhancedTooltips',
		'HelpPanelShowLuaErrors',
		'HelpPanelColorblindMode',
		'HelpPanelMovePad',
		
		'DisplayPanelShowAccountAchievments',
	}
	
	for i = 1, getn(interfacecheckbox) do
		local icheckbox = _G['InterfaceOptions'..interfacecheckbox[i]]
		if icheckbox then
			icheckbox:SkinCheckBox()
		else
			print(interfacecheckbox[i])
		end
	end
	
	local interfacedropdown ={
		-- Controls
		'ControlsPanelAutoLootKeyDropDown',
		-- Combat
		'CombatPanelTOTDropDown',
		'CombatPanelFocusCastKeyDropDown',
		'CombatPanelSelfCastKeyDropDown',
		'CombatPanelLossOfControlFullDropDown',
		'CombatPanelLossOfControlSilenceDropDown',
		'CombatPanelLossOfControlInterruptDropDown',
		'CombatPanelLossOfControlDisarmDropDown',
		'CombatPanelLossOfControlRootDropDown',
		-- Display
		'DisplayPanelOutlineDropDown',
		-- Objectives
		'ObjectivesPanelQuestSorting',
		-- Social
		'SocialPanelChatStyle',
		'SocialPanelWhisperMode',
		'SocialPanelTimestamps',
		'SocialPanelBnWhisperMode',
		'SocialPanelConversationMode',
		-- Action bars
		'ActionBarsPanelPickupActionKeyDropDown',
		-- Names
		'NamesPanelNPCNamesDropDown',
		'NamesPanelUnitNameplatesMotionDropDown',
		-- Combat Text
		'CombatTextPanelFCTDropDown',
		'CombatTextPanelTargetModeDropDown',
		-- Camera
		'CameraPanelStyleDropDown',
		-- Mouse
		'MousePanelClickMoveStyleDropDown',
		'LanguagesPanelLocaleDropDown',
	}
	
	for i = 1, getn(interfacedropdown) do
		local idropdown = _G['InterfaceOptions'..interfacedropdown[i]]
		if idropdown then
			idropdown:SkinDropDownBox()
			DropDownList1:SetTemplate()
		end
	end
	InterfaceOptionsHelpPanelResetTutorials:SkinButton()
	
	local optioncheckbox = {
		-- Advanced
		'Advanced_MaxFPSCheckBox',
		'Advanced_MaxFPSBKCheckBox',
		'Advanced_UseUIScale',
		'Advanced_ShowHDModels',
		-- Audio
		'AudioOptionsSoundPanelEnableSound',
		'AudioOptionsSoundPanelSoundEffects',
		'AudioOptionsSoundPanelErrorSpeech',
		'AudioOptionsSoundPanelEmoteSounds',
		'AudioOptionsSoundPanelPetSounds',
		'AudioOptionsSoundPanelMusic',
		'AudioOptionsSoundPanelLoopMusic',
		'AudioOptionsSoundPanelPetBattleMusic',
		'AudioOptionsSoundPanelAmbientSounds',
		'AudioOptionsSoundPanelSoundInBG',
		'AudioOptionsSoundPanelReverb',
		'AudioOptionsSoundPanelHRTF',
		'AudioOptionsSoundPanelEnableDSPs',
		'AudioOptionsSoundPanelUseHardware',
		'AudioOptionsVoicePanelEnableVoice',
		'AudioOptionsVoicePanelEnableMicrophone',
		'AudioOptionsVoicePanelPushToTalkSound',
		-- Network
		'NetworkOptionsPanelOptimizeSpeed',
		'NetworkOptionsPanelUseIPv6',
	}
	
	for i = 1, getn(optioncheckbox) do
		local ocheckbox = _G[optioncheckbox[i]]
		if ocheckbox then
			ocheckbox:SkinCheckBox()
		end
	end

	local optiondropdown = {
		-- Graphics
		'Display_DisplayModeDropDown',
		'Display_ResolutionDropDown',
		'Display_RefreshDropDown',
		'Display_PrimaryMonitorDropDown',
		'Display_AntiAliasingDropDown',
		'Display_VerticalSyncDropDown',
		'Graphics_TextureResolutionDropDown',
		'Graphics_FilteringDropDown',
		'Graphics_ProjectedTexturesDropDown',
		'Graphics_ViewDistanceDropDown',
		'Graphics_EnvironmentalDetailDropDown',
		'Graphics_GroundClutterDropDown',
		'Graphics_ShadowsDropDown',
		'Graphics_LiquidDetailDropDown',
		'Graphics_SunshaftsDropDown',
		'Graphics_ParticleDensityDropDown',
		'Graphics_SSAODropDown',
		'Graphics_RefractionDropDown',

        'RaidGraphics_TextureResolutionDropDown',
        'RaidGraphics_FilteringDropDown',
        'RaidGraphics_ProjectedTexturesDropDown',
        'RaidGraphics_ViewDistanceDropDown',
        'RaidGraphics_EnvironmentalDetailDropDown',
        'RaidGraphics_GroundClutterDropDown',
        'RaidGraphics_ShadowsDropDown',
        'RaidGraphics_LiquidDetailDropDown',
        'RaidGraphics_SunshaftsDropDown',
        'RaidGraphics_ParticleDensityDropDown',
        'RaidGraphics_SSAODropDown',
        'RaidGraphics_RefractionDropDown',
		-- Advanced
		'Advanced_BufferingDropDown',
		'Advanced_LagDropDown',
		'Advanced_HardwareCursorDropDown',
		'Advanced_GraphicsAPIDropDown',
		-- Audio
		'AudioOptionsSoundPanelHardwareDropDown',
		'AudioOptionsSoundPanelSoundChannelsDropDown',
		'AudioOptionsVoicePanelInputDeviceDropDown',
		'AudioOptionsVoicePanelChatModeDropDown',
		'AudioOptionsVoicePanelOutputDeviceDropDown',
		-- Raid Profiles
        'CompactUnitFrameProfilesProfileSelector',
        'CompactUnitFrameProfilesGeneralOptionsFrameHealthTextDropdown',
        'CompactUnitFrameProfilesGeneralOptionsFrameSortByDropdown',
	}
	for i = 1, getn(optiondropdown) do
		local odropdown = _G[optiondropdown[i]]
		if odropdown then
			odropdown:SkinDropDownBox(165)
			DropDownList1:CreateBD()
		end
	end
			
	local buttons = {
	    'RecordLoopbackSoundButton',
	    'PlayLoopbackSoundButton',
	    'AudioOptionsVoicePanelChatMode1KeyBindingButton',
		'CompactUnitFrameProfilesSaveButton',
		'CompactUnitFrameProfilesDeleteButton',
	}

	for _, button in pairs(buttons) do
		_G[button]:SkinButton()
	end	
	InterfaceOptionsFrameAddOnsListScrollBar:SkinScrollBar()
	AudioOptionsVoicePanelChatMode1KeyBindingButton:ClearAllPoints()
	AudioOptionsVoicePanelChatMode1KeyBindingButton:Point('CENTER', AudioOptionsVoicePanelBinding, 'CENTER', 0, -10)
	SkinCheckBox(CompactUnitFrameProfilesRaidStylePartyFrames)
	SkinButton(CompactUnitFrameProfilesGeneralOptionsFrameResetPositionButton)
	GraphicsButton:StripTextures()
	RaidButton:StripTextures()

	local raidcheckbox = {
        'KeepGroupsTogether',
        'DisplayIncomingHeals',
        'DisplayPowerBar',
        'DisplayAggroHighlight',
        'UseClassColors',
        'DisplayPets',
        'DisplayMainTankAndAssist',
        'DisplayBorder',
        'ShowDebuffs',
        'DisplayOnlyDispellableDebuffs',
        'AutoActivate2Players',
        'AutoActivate3Players',
        'AutoActivate5Players',
        'AutoActivate10Players',
        'AutoActivate15Players',
        'AutoActivate25Players',
        'AutoActivate40Players',
        'AutoActivateSpec1',
        'AutoActivateSpec2',
        'AutoActivatePvP',
        'AutoActivatePvE',
    }
    for i = 1, getn(raidcheckbox) do
        local icheckbox = _G['CompactUnitFrameProfilesGeneralOptionsFrame'..raidcheckbox[i]]
        if icheckbox then
            SkinCheckBox(icheckbox)
            icheckbox:SetFrameLevel(40)
        end
    end	
	
	local sliders = {
		'Graphics_Quality',
		'RaidGraphics_Quality',
		'Advanced_UIScaleSlider',
		'Advanced_MaxFPSSlider',
		'Advanced_MaxFPSBKSlider',
		'AudioOptionsSoundPanelMasterVolume',
		'AudioOptionsSoundPanelSoundVolume',
		'AudioOptionsSoundPanelMusicVolume',
		'AudioOptionsSoundPanelAmbienceVolume',
		'AudioOptionsVoicePanelMicrophoneVolume',
		'AudioOptionsVoicePanelSpeakerVolume',
		'AudioOptionsVoicePanelSoundFade',
		'AudioOptionsVoicePanelMusicFade',
		'AudioOptionsVoicePanelAmbienceFade',
		'AudioOptionsSoundPanelDialogVolume',
		'InterfaceOptionsCombatPanelSpellAlertOpacitySlider',
		'InterfaceOptionsCombatPanelMaxSpellStartRecoveryOffset',
		'InterfaceOptionsBattlenetPanelToastDurationSlider',
		'InterfaceOptionsCameraPanelMaxDistanceSlider',
		'InterfaceOptionsCameraPanelFollowSpeedSlider',
		'InterfaceOptionsMousePanelMouseSensitivitySlider',
		'InterfaceOptionsMousePanelMouseLookSpeedSlider',
		'OpacityFrameSlider',
	}
	Graphics_RightQuality:Kill()
	RaidGraphics_RightQuality:Kill()
	for _, slider in pairs(sliders) do
		_G[slider]:SkinSlideBar()
	end
	
	-- mac option 
	MacOptionsFrame:StripTextures()
	MacOptionsFrame:SetTemplate()
	MacOptionsButtonCompress:SkinButton()
	MacOptionsButtonKeybindings:SkinButton()
	MacOptionsFrameDefaults:SkinButton()
	MacOptionsFrameOkay:SkinButton()
	MacOptionsFrameCancel:SkinButton()
	MacOptionsFrameMovieRecording:StripTextures()
	MacOptionsITunesRemote:StripTextures()
	MacOptionsFrameMisc:StripTextures()

	MacOptionsFrameResolutionDropDown:SkinDropDownBox()
	MacOptionsFrameFramerateDropDown:SkinDropDownBox()
	MacOptionsFrameCodecDropDown:SkinDropDownBox()
	MacOptionsFrameQualitySlider:SkinSlideBar(10)

	for i = 1, 11 do
		local b = _G['MacOptionsFrameCheckButton'..i]
		b:SkinCheckBox()
	end

	MacOptionsButtonKeybindings:ClearAllPoints()
	MacOptionsButtonKeybindings:SetPoint('LEFT', MacOptionsFrameDefaults, 'RIGHT', 2, 0)
	MacOptionsFrameOkay:ClearAllPoints()
	MacOptionsFrameOkay:SetPoint('LEFT', MacOptionsButtonKeybindings, 'RIGHT', 2, 0)
	MacOptionsFrameCancel:ClearAllPoints()
	MacOptionsFrameCancel:SetPoint('LEFT', MacOptionsFrameOkay, 'RIGHT', 2, 0)
	MacOptionsFrameCancel:SetWidth(MacOptionsFrameCancel:GetWidth() - 6)
	
	--Addon List
	AddonList:StripTextures()
	AddonList:SetTemplate()
	AddonListInset:StripTextures()

	SkinButton(AddonListEnableAllButton, true)
	SkinButton(AddonListDisableAllButton, true)
	SkinButton(AddonListOkayButton, true)
	SkinButton(AddonListCancelButton, true)

	SkinCheckBox(AddonListForceLoad)
	AddonListForceLoad:SetSize(26, 26)
	SkinDropDownBox(AddonCharacterDropDown)

	SkinCloseButton(AddonListCloseButton)

	for i=1, MAX_ADDONS_DISPLAYED do
		SkinCheckBox(_G["AddonListEntry"..i.."Enabled"])
	end
end

tinsert(F.SkinFuncs['LanUI'], LoadSkin)