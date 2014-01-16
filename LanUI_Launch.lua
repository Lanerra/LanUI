local F, C, G = unpack(LanUI)

local f = CreateFrame('Frame')
f:RegisterEvent('PLAYER_LOGIN')
f:SetScript('OnEvent', function(_, event, ...)
    if (event == 'PLAYER_LOGIN') then
	    if C.FirstTime == true then
	        print('|cff0099ffWelcome to LanUI|r')
		    print('|cff0099ffIf you find a bug, please let me know via GitHub|r')
		    print('|cff0099ffFor UI usage info type in /UIHelp|r')
		    print('|cff0099ffEnjoy!|r')
        end

		SetCVar('useUiScale', 1) -- Use custom UI scale

		if C.Tweaks.AutoScale then
			C.Tweaks.UIScale = 768/string.match(F.Resolution, "%d+x(%d+)")
		end

		SetCVar('uiScale', C.Tweaks.UIScale) -- DO NOT MODIFY UNLESS YOU UNDERSTAND THE EFFECT THIS WILL HAVE ON THE UI
		
        SetCVar('chatStyle', 'classic') -- No IM Style

        SetCVar('ScreenshotQuality', 10)

        --[[
        ProcessAffinityMask:
        Dual Core = 3
        Triple Core = 7
        Quad Core/i5 = 15
        i7 = 255
        16 core/8 core with hyperthreading = 65535 (Untested)
        ]]

        SetCVar('ProcessAffinityMask', 85)

		SetCVar('consolidateBuffs', 0) -- Disable Consolidated Buffs

		SetCVar('ShowClassColorInNameplate', 1) -- Class color the statusbar on nameplates
		SetCVar('autoSelfCast', 0) -- Do not automatically cast on self if we have no target
	    SetCVar('buffDurations', 1) -- Show buff durations
		
		SetCVar('cameraDistanceMax', 50) -- Increase max camera distance
	    SetCVar('cameraDistanceMaxFactor', 3.4) -- More increasing
		SetCVar('cameraViewBlendStyle', 0) -- Don't smooth camera changes (Don't think anyone uses this)
		
		SetCVar('scriptErrors', 1) -- Display Lua errors
		
		SetCVar('M2Faster', 3) -- Increase number of threads available to WoW for rendering
		
	    SetCVar('chatBubblesParty', 1) -- Show party chat bubbles
	    SetCVar('chatBubbles', 1) -- Show standard chat bubbles
		
		SetCVar('UberTooltips', 1) -- Über Tooltips! Wunderbar!
		SetCVar('showTutorials', 0) -- Not a n00b. Don't show tutorials
	    		
	    SetCVar('bloatthreat', 0) -- Don't make nameplates larger or smaller as threat changes
		
		if C.Tweaks.Sticky == true then
		    SetCVar('deselectOnClick', 1) -- Allow clearing of our target by clicking on the world
		end

		if C.Tweaks.LanNames == true then -- Personal name display preferences
		    SetCVar('UnitNameOwn', 0) -- I know my own name, thanks
	        SetCVar('UnitNameNPC', 0) -- Don't show NPC names
	        SetCVar('UnitNameNonCombatCreatureName', 0) -- Don't need to know critter names, either
	        SetCVar('UnitNamePlayerGuild', 1) -- Show guild member names
	        SetCVar('UnitNamePlayerPVPTitle', 0) -- Don't care about your epeen
	        SetCVar('UnitNameFriendlyPlayerName', 0) -- Makes major cities much cleaner
	        SetCVar('UnitNameFriendlyPetName', 0) -- No pet names, either
	        SetCVar('UnitNameFriendlyGuardianName', 0) -- Or guardians...
	        SetCVar('UnitNameFriendlyTotemName', 0) -- Pfft, silly shamans
	        SetCVar('UnitNameEnemyPlayerName', 1) -- I like to know who I'm killin'
	        SetCVar('UnitNameEnemyPetName', 0) -- Except when it's your pet
	        SetCVar('UnitNameEnemyGuardianName', 0) -- Or your guardians...
	        SetCVar('UnitNameEnemyTotemName', 0) -- Or your totems :P
		end
		
		if C.Tweaks.LanNameplates == true then -- Personal nameplate display preferences
	        SetCVar('nameplateShowFriends', 0) -- Don't display for friends
	        SetCVar('nameplateShowFriendlyPets', 0) -- Or friends' pets
	        SetCVar('nameplateShowFriendlyGuardians', 0) -- Or guardians
	        SetCVar('nameplateShowFriendlyTotems', 0) -- Or totems
	        SetCVar('nameplateShowEnemies', 1) -- Show me the bad guys, though!
	        SetCVar('nameplateShowEnemyPets', 1) -- And their pet, 'Mittens'
	        SetCVar('nameplateShowEnemyGuardians', 0) -- Don't show their guardian
	        SetCVar('nameplateShowEnemyTotems', 0) -- Or totems
		end

		if C.Tweaks.ChatSetup == true then -- Auto configure chat frames when you make a new character/make sure chat frames don't get messed up
		    ChatFrame1:ClearAllPoints()
	        ChatFrame1:SetPoint('BOTTOMLEFT', UIParent, 33, 59)
	        ChatFrame1:SetHeight(200)
            ChatFrame1:SetWidth(425)
	        ChatFrame1:SetUserPlaced(true)
            ChatFrame3:SetPoint('BOTTOMRIGHT', UIParent, -33, 59)
            ChatFrame3:SetHeight(200)
            ChatFrame3:SetWidth(425)
            ChatFrame3:SetUserPlaced(true)
            
            FCF_SetWindowName(ChatFrame1, 'General')
			FCF_SetWindowName(ChatFrame3, 'Guild')
			
			-- Save what we've done
			
	        FCF_SavePositionAndDimensions(ChatFrame1)
	        FCF_SavePositionAndDimensions(ChatFrame3)
			
			-- Lock chatframes
			
			FCF_SetLocked(ChatFrame1, true)
			FCF_SetLocked(ChatFrame3, true)
			
			-- Remove clutter from our chatframes
			
 	        ChatFrame_RemoveChannel(ChatFrame1, 'GuildRecruitment')
	        ChatFrame_RemoveChannel(ChatFrame1, 'LookingForGroup')
            ChatFrame_RemoveChannel(ChatFrame3, 'GuildRecruitment')
	        ChatFrame_RemoveChannel(ChatFrame3, 'LookingForGroup')
			
			-- Setup our Chatframe 1
			
            ChatFrame_RemoveAllMessageGroups(ChatFrame1)
			
            ChatFrame_AddChannel(ChatFrame1, 'General') 
		    ChatFrame_AddChannel(ChatFrame1, 'Trade')
		    ChatFrame_AddChannel(ChatFrame1, 'LocalDefense')
            
            ChatFrame_AddMessageGroup(ChatFrame1, 'WHISPER')
		    ChatFrame_AddMessageGroup(ChatFrame1, 'SAY')
		    ChatFrame_AddMessageGroup(ChatFrame1, 'EMOTE')
		    ChatFrame_AddMessageGroup(ChatFrame1, 'YELL')
			ChatFrame_AddMessageGroup(ChatFrame1, 'PARTY')
		    ChatFrame_AddMessageGroup(ChatFrame1, 'INSTANCE')
		    ChatFrame_AddMessageGroup(ChatFrame1, 'INSTANCE_LEADER')
		    ChatFrame_AddMessageGroup(ChatFrame1, 'PARTY_LEADER')
		    ChatFrame_AddMessageGroup(ChatFrame1, 'RAID')
		    ChatFrame_AddMessageGroup(ChatFrame1, 'RAID_LEADER')
		    ChatFrame_AddMessageGroup(ChatFrame1, 'RAID_WARNING')
			ChatFrame_AddMessageGroup(ChatFrame1, 'BN_WHISPER')
		    ChatFrame_AddMessageGroup(ChatFrame1, 'BN_CONVERSATION')
			ChatFrame_AddMessageGroup(ChatFrame1, 'BN_INLINE_TOAST_ALERT')
			ChatFrame_AddMessageGroup(ChatFrame1, 'SKILL')
			ChatFrame_AddMessageGroup(ChatFrame1, 'MONEY')
			ChatFrame_AddMessageGroup(ChatFrame1, 'SYSTEM')
	 	    ChatFrame_AddMessageGroup(ChatFrame1, 'ERRORS')
			ChatFrame_AddMessageGroup(ChatFrame1, 'AFK')
		    ChatFrame_AddMessageGroup(ChatFrame1, 'DND')
		    ChatFrame_AddMessageGroup(ChatFrame1, 'IGNORED')
			ChatFrame_AddMessageGroup(ChatFrame1, 'ACHIEVEMENT')
		    ChatFrame_AddMessageGroup(ChatFrame1, 'GUILD_ACHIEVEMENT')
		    ChatFrame_AddMessageGroup(ChatFrame1, 'MONSTER_SAY')
		    ChatFrame_AddMessageGroup(ChatFrame1, 'MONSTER_EMOTE')
		    ChatFrame_AddMessageGroup(ChatFrame1, 'MONSTER_YELL')
		    ChatFrame_AddMessageGroup(ChatFrame1, 'MONSTER_WHISPER')
		    ChatFrame_AddMessageGroup(ChatFrame1, 'MONSTER_BOSS_EMOTE')
		    ChatFrame_AddMessageGroup(ChatFrame1, 'MONSTER_BOSS_WHISPER')
		    ChatFrame_AddMessageGroup(ChatFrame1, 'BATTLEGROUND')
		    ChatFrame_AddMessageGroup(ChatFrame1, 'BATTLEGROUND_LEADER')
		    ChatFrame_AddMessageGroup(ChatFrame1, 'BG_HORDE')
		    ChatFrame_AddMessageGroup(ChatFrame1, 'BG_ALLIANCE')
		    ChatFrame_AddMessageGroup(ChatFrame1, 'BG_NEUTRAL')
            ChatFrame_AddMessageGroup(ChatFrame1, 'LOOT')
            ChatFrame_AddMessageGroup(ChatFrame1, 'COMBAT_XP_GAIN')
			ChatFrame_AddMessageGroup(ChatFrame1, 'COMBAT_HONOR_GAIN')
			ChatFrame_AddMessageGroup(ChatFrame1, 'COMBAT_GUILD_XP_GAIN')
			ChatFrame_AddMessageGroup(ChatFrame1, 'REPUTATION_GAIN')

			-- Setup our Chatframe 3
			
			ChatFrame_RemoveAllMessageGroups(ChatFrame3)
			
		    ChatFrame_AddMessageGroup(ChatFrame3, 'GUILD')
		    ChatFrame_AddMessageGroup(ChatFrame3, 'OFFICER')
			
			-- Class color names in our Chatframes
			
			ToggleChatColorNamesByClassGroup(true, 'SAY')
		    ToggleChatColorNamesByClassGroup(true, 'EMOTE')
		    ToggleChatColorNamesByClassGroup(true, 'YELL')
	 	    ToggleChatColorNamesByClassGroup(true, 'GUILD')
		    ToggleChatColorNamesByClassGroup(true, 'OFFICER')
		    ToggleChatColorNamesByClassGroup(true, 'GUILD_ACHIEVEMENT')
		    ToggleChatColorNamesByClassGroup(true, 'ACHIEVEMENT')
		    ToggleChatColorNamesByClassGroup(true, 'WHISPER')
		    ToggleChatColorNamesByClassGroup(true, 'PARTY')
		    ToggleChatColorNamesByClassGroup(true, 'PARTY_LEADER')
		    ToggleChatColorNamesByClassGroup(true, 'RAID')
		    ToggleChatColorNamesByClassGroup(true, 'RAID_LEADER')
		    ToggleChatColorNamesByClassGroup(true, 'RAID_WARNING')
		    ToggleChatColorNamesByClassGroup(true, 'BATTLEGROUND')
		    ToggleChatColorNamesByClassGroup(true, 'BATTLEGROUND_LEADER')	
		    ToggleChatColorNamesByClassGroup(true, 'CHANNEL1')
		    ToggleChatColorNamesByClassGroup(true, 'CHANNEL2')
		    ToggleChatColorNamesByClassGroup(true, 'CHANNEL3')
		    ToggleChatColorNamesByClassGroup(true, 'CHANNEL4')
		    ToggleChatColorNamesByClassGroup(true, 'CHANNEL5')
			
--			INTERFACE_ACTION_BLOCKED = ''
	    end
    end
end)

UIErrorsFrame:UnregisterEvent('UI_ERROR_MESSAGE')
UIErrorsFrame:SetTimeVisible(1)
UIErrorsFrame:SetFadeDuration(0.75)

local ignoreList = {
    [ERR_SPELL_COOLDOWN] = true,
    [ERR_ABILITY_COOLDOWN] = true,

    [OUT_OF_ENERGY] = true,

    [SPELL_FAILED_NO_COMBO_POINTS] = true,

    [SPELL_FAILED_MOVING] = true,
    [ERR_NO_ATTACK_TARGET] = true,
    [SPELL_FAILED_SPELL_IN_PROGRESS] = true,

    [ERR_NO_ATTACK_TARGET] = true,
    [ERR_INVALID_ATTACK_TARGET] = true,
    [SPELL_FAILED_BAD_TARGETS] = true,
}

local event = CreateFrame('Frame')
event:SetScript('OnEvent', function(self, event, error)
    if (not ignoreList[error]) then
        UIErrorsFrame:AddMessage(error, 1, .1, .1)
    end
end)

event:RegisterEvent('UI_ERROR_MESSAGE')

local Events = CreateFrame('Frame')
Events:SetScript('OnEvent', function(self, event, ...) self[event](...) end)

local metatable = {
	__call = function(funcs, self, ...)
		for __, func in pairs(funcs) do
			func(self, ...)
		end
	end
}

G.Initialize = {}
F.RegisterEvent = function(event, method)
	local current = Events[event]
	if(current and method) then
		if(type(current) == 'function') then
			Events[event] = setmetatable({current, method}, metatable)
		else
			for __, func in pairs(current) do
				if(func == method) then return end
			end

			table.insert(current, method)
		end
	else
		Events[event] = method
		Events:RegisterEvent(event)
	end
end

function init()
	for type, func in pairs(G.Initialize) do
		func()
	end

	print('|cff0099ffLan|rUI '..GetAddOnMetadata('LanUI', 'Version')..' successfully initiliazed.')
end

init()