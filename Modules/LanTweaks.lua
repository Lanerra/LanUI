local F, C, G = unpack(select(2, ...))

local dummy = F.Dummy

-- Quest modification

local eventFrame = CreateFrame('Frame')

local questIndex

local QuestCompleted = ERR_QUEST_OBJECTIVE_COMPLETE_S
local ObjCompPattern = QuestCompleted:gsub('[()]', '%%%1'):gsub('%%s', '(%.%-)')

local UIErrorsFrame_OldOnEvent = UIErrorsFrame:GetScript('OnEvent')
UIErrorsFrame:SetScript('OnEvent', function(self, event, msg, ...)
    if event == 'UI_INFO_MESSAGE' then
        if msg:find('(.-): (.-)/(.+)') or msg:find(ObjCompPattern) or msg:find('Objective Complete.') then
            return
        end
    end

    return UIErrorsFrame_OldOnEvent(self, event, msg, ...)
end)

local MostValuable = function()
    local bestPrice, bestItem = 0

    for i = 1, GetNumQuestChoices() do
        local link = GetQuestItemLink('choice', i)
        local quality = select(4, GetQuestItemInfo('choice', i))
        local price = link and select(11, GetItemInfo(link))

        if not price then
            return
        elseif (price * (quality or 1)) > bestPrice then
            bestPrice, bestItem = (price * (quality or 1)), i
        end
    end

    if bestItem then
        local button = _G['QuestInfoItem'..bestItem]
        if (button.type == 'choice') then
            button:Click()
        end
    end
end

eventFrame:RegisterEvent('QUEST_DETAIL')
eventFrame:RegisterEvent('QUEST_COMPLETE')
eventFrame:RegisterEvent('QUEST_WATCH_UPDATE')
eventFrame:RegisterEvent('QUEST_ACCEPT_CONFIRM')
eventFrame:RegisterEvent('UNIT_QUEST_LOG_CHANGED')
eventFrame:SetScript('OnEvent', function(self, event, ...)
    if event == 'QUEST_WATCH_UPDATE' then
        questIndex = ...
    end

    if event == 'UNIT_QUEST_LOG_CHANGED' then
        if questIndex then
            local description, finished, completed = nil, nil, 0

            for objective = 1, GetNumQuestLeaderBoards(questIndex) do
                description, _, finished = GetQuestLogLeaderBoard(objective, questIndex)
                copmpleted = completed + (finished or 0)
            end

            if completed == GetNumQuestLeaderBoards(questIndex) then
                if description then
                    RaidNotice_AddMessage(RaidWarningFrame, string.format('%s: Objective Complete'):format(description), ChatTypeInfo['SYSTEM'])
                    PlaySoundFile([[Sound\Creature\Peon\PeonBuildingComplete1.wav]])
                end
            else
                local _, _, itemName, numCurrent, numTotal = strfind(description, '(.*):%s*([%d]+)%s*/%s*([%d]+)')

                if numCurrent == numTotal then
                    if itemName then
                        RaidNotice_AddMessage(RaidWarningFrame, string.format('%s: Objective Complete', itemName), ChatTypeInfo['SYSTEM'])
                    else
                        RaidNotice_AddMessage(RaidWarningFrame, 'Objective Complete', ChatTypeInfo['SYSTEM'])
                    end
                    PlaySoundFile([[Sound\Creature\Peon\PeonReady1.wav]])
                else
                    RaidNotice_AddMessage(RaidWarningFrame, string.format('%s: %s/%s', itemName, numCurrent, numTotal), ChatTypeInfo['SYSTEM'])
                end
            end
        end

        questIndex = nil

    end

    if C.Tweaks.PowerLevel then
        if event == 'QUEST_DETAIL' then
            AcceptQuest()
            CompleteQuest()
        elseif event == 'QUEST_COMPLETE' then
            if GetNumQuestChoices() and GetNumQuestChoices() < 1 then
                GetQuestReward()
            else
                MostValuable()
            end
        elseif event == 'QUEST_ACCEPT_CONFIRM' then
            ConfirmAcceptQuest()
        end
    else
        if (event == 'QUEST_DETAIL') then
            return
        elseif (event == 'QUEST_COMPLETE') then
            MostValuable()
        elseif (event == 'QUEST_ACCEPT_CONFIRM') then
            return
        end
    end
end)

------------------------------------------------------------------------
-- QuestLog display customization
------------------------------------------------------------------------

-- Get quest title info

local questtags, tags = {}, {Elite = '+', Group = 'G', Dungeon = 'D', Raid = 'R', PvP = 'P', Daily = '*', Heroic = 'H', Repeatable = '?', Legendary = 'L'}

local function GetTaggedTitle(i)
    local name, level, tag, group, header, _, complete, daily = GetQuestLogTitle(i)
    if header or not name then
        return
    end

    if not group or group == 0 then
        group = nil
    end
    
    return string.format('[%s%s%s%s] %s', level, tag and tags[tag] or '', daily and tags.Daily or '',group or '', name), tag, daily, complete
end

------------------------------------------------------------------------
-- Add info to the quest log
------------------------------------------------------------------------
local function QuestLog_Update()
    for i,butt in pairs(QuestLogScrollFrame.buttons) do
        local qi = butt:GetID()
        local title, tag, daily, complete = GetTaggedTitle(qi)
        if title then
            butt:SetText('  '..title)
        end
        
        if (tag or daily) and not complete then
            butt.tag:SetText('')
        end
        
        QuestLogTitleButton_Resize(butt)
    end
end
hooksecurefunc('QuestLog_Update', QuestLog_Update)
hooksecurefunc(QuestLogScrollFrame, 'update', QuestLog_Update)

-- Add tags to the quest watcher
hooksecurefunc('WatchFrame_Update', function()
    local questWatchMaxWidth, watchTextIndex = 0, 1

    for i=1,GetNumQuestWatches() do
        local qi = GetQuestIndexForWatch(i)
        if qi then
            local numObjectives = GetNumQuestLeaderBoards(qi)

            if numObjectives > 0 then
                for bi,butt in pairs(WATCHFRAME_QUESTLINES) do
                    if butt.text:GetText() == GetQuestLogTitle(qi) then butt.text:SetText(GetTaggedTitle(qi)) end
                end
            end
        end
    end
end)


-- Add tags to quest links in chat
local function filter(self, event, msg, ...)
    if msg then
        return false, msg:gsub('(|c%x+|Hquest:%d+:(%d+))', '(%2) %1'), ...
    end
end
for _,event in pairs{'SAY', 'GUILD', 'GUILD_OFFICER', 'WHISPER', 'WHISPER_INFORM', 'PARTY', 'RAID', 'RAID_LEADER', 'BATTLEGROUND', 'BATTLEGROUND_LEADER'} do ChatFrame_AddMessageEventFilter('CHAT_MSG_'..event, filter) end


-- Add tags to gossip frame
local i
local TRIVIAL, NORMAL = '|cff%02x%02x%02x[%d%s%s]|r '..TRIVIAL_QUEST_DISPLAY, '|cff%02x%02x%02x[%d%s%s]|r '.. NORMAL_QUEST_DISPLAY
local function helper(isActive, ...)
    local num = select('#', ...)
    if num == 0 then return end

    local skip = isActive and 4 or 5

    for j=1,num,skip do
        local title, level, isTrivial, daily, repeatable = select(j, ...)
        if isActive then daily, repeatable = nil end
        if title and level and level ~= -1 then
            local color = GetQuestDifficultyColor(level)
            _G['GossipTitleButton'..i]:SetFormattedText(isActive and isTrivial and TRIVIAL or NORMAL, color.r*255, color.g*255, color.b*255, level, repeatable and tags.Repeatable or '', daily and tags.Daily or '', title)
        end
        i = i + 1
    end
    i = i + 1
end

local function GossipUpdate()
    i = 1
    helper(false, GetGossipAvailableQuests()) -- name, level, trivial, daily, repeatable
    helper(true, GetGossipActiveQuests()) -- name, level, trivial, complete
end
hooksecurefunc('GossipFrameUpdate', GossipUpdate)
if GossipFrame:IsShown() then GossipUpdate() end

-- Auto-DE/Greed
if C.Tweaks.AutoDEGreed and F.Level == MAX_PLAYER_LEVEL_TABLE[GetExpansionLevel()] then
    local greed = CreateFrame('Frame')
    greed:RegisterEvent('START_LOOT_ROLL')
    greed:SetScript('OnEvent', function(self, event, id)
        local _, name, _, quality, BoP = GetLootRollItemInfo(id)
        if id and quality == 2 and not BoP then
            if RollOnLoot(id, 3) then
                RollOnLoot(id, 3)
            else
                RollOnLoot(id, 2)
            end
        end
    end)
    
    local de = CreateFrame('Frame')
    de:RegisterEvent('CONFIRM_DISENCHANT_ROLL')
    de:RegisterEvent('CONFIRM_LOOT_ROLL')
    de:RegisterEvent('LOOT_BIND_CONFIRM')
    de:SetScript('OnEvent', function(self, event, id)
        for i = 1, STATICPOPUP_NUMDIALOGS do
            local frame = _G['StaticPopup'..i]
            if (frame.which == 'CONFIRM_LOOT_ROLL' or frame.which == 'LOOT_BIND') and frame:IsVisible() then StaticPopup_OnClick(frame, 1) end
        end
    end)
end

-- We automatically confirm loot if we are not in a party or raid.
StaticPopupDialogs['LOOT_BIND'].OnCancel = function(_, slot)
    if GetNumPartyMembers() == 0 and GetNumRaidMembers() == 0 then
        ConfirmLootSlot(slot)
    end
end

-- Auto repair/Sell greys

local format = string.format

local formatMoney = function(value)
    if value >= 1e4 then
        return format('|cffffd700%dg |r|cffc7c7cf%ds |r|cffeda55f%dc|r', value/1e4, strsub(value, -4) / 1e2, strsub(value, -2))
    elseif value >= 1e2 then
        return format('|cffc7c7cf%ds |r|cffeda55f%dc|r', strsub(value, -4) / 1e2, strsub(value, -2))
    else
        return format('|cffeda55f%dc|r', strsub(value, -2))
    end
end

local itemCount, sellValue = 0, 0

local merchant = CreateFrame('frame')
merchant:RegisterEvent('MERCHANT_SHOW')
merchant:SetScript('OnEvent', function(self, event)
    for bag = 0, 4 do
        for slot = 1, GetContainerNumSlots(bag) do
            local item = GetContainerItemLink(bag, slot)
            if item then
                local itemValue = select(11, GetItemInfo(item)) * GetItemCount(item)

                if select(3, GetItemInfo(item)) == 0 then
                    ShowMerchantSellCursor(1)
                    UseContainerItem(bag, slot)

                    itemCount = itemCount + GetItemCount(item)
                    sellValue = sellValue + itemValue
                end
            end
        end
    end

    if sellValue > 0 then
        print(format('|cff0099ffLan|rUI: Sold %d trash item%s for %s', itemCount, itemCount ~= 1 and 's' or '', formatMoney(sellValue)))
        itemCount, sellValue = 0, 0
    end

    if CanMerchantRepair() then
        local cost, needed = GetRepairAllCost()
        if needed then
            local GuildWealth = CanGuildBankRepair() and GetGuildBankWithdrawMoney() > cost
            if GuildWealth and GetNumGroupMembers() > 5 then
                RepairAllItems(1)
                print(format('|cff0099ffLan|rUI: Guild bank repaired for %s.', formatMoney(cost)))
            elseif cost < GetMoney() then
                RepairAllItems()
                print(format('|cff0099ffLan|rUI: Repaired for %s.', formatMoney(cost)))
            else
                print('|cff0099ffLan|rUI: Repairs were unaffordable.')
            end
        end
    end
end)

-- xMerchant by Nils Ruesch
-- http://www.curse.com/addons/wow/xmerchant

local buttons = {}
local knowns = {}
local errors = {}

-- DONEY
local factions = {}
local currencies = {}
local searching = ''
local RECIPE = select(7, GetAuctionItemClasses()) --tested API 5.0
local REQUIRES_LEVEL = 'Requires Level (%d+)'
local LEVEL = 'Level %d'
local REQUIRES_REPUTATION = 'Requires .+ %- (.+)'

-- DONEY
local REQUIRES_REPUTATION_NAME = 'Requires (.+) %- .+'
local REQUIRES_SKILL = 'Requires (.+) %((%d+)%)'
local SKILL = '%1$s (%2$d)'
local REQUIRES = 'Requires (.+)'
local tooltip = CreateFrame('GameTooltip', 'LanMerchantTooltip', UIParent, 'GameTooltipTemplate')

-- DONEY
local ENABLE_DEBUG_DONEY = false


-- DONEY
local XMERCHANT_DEBUG_TAGS = {}
XMERCHANT_DEBUG_TAGS['GetError'] = 0
XMERCHANT_DEBUG_TAGS['GetKnown'] = 0
XMERCHANT_DEBUG_TAGS['AltCurrency'] = 0
XMERCHANT_DEBUG_TAGS['CurrencyUpdate'] = 0
XMERCHANT_DEBUG_TAGS['FactionsUpdate'] = 1
XMERCHANT_DEBUG_TAGS['Faction'] = 1
XMERCHANT_DEBUG_TAGS['MerchantItemInfo'] = 1

-- DONEY
local function XMERCHANT_LOG_DEBUG(msg)
	if (ENABLE_DEBUG_DONEY) then
		local pos = strfind(msg, ' ')
		local tag = pos and pos > 0 and strsub(msg, 0, pos-1) or ''
		--DEFAULT_CHAT_FRAME:AddMessage('[xMerchant][Debug] pos: '..(pos or 'nil')..'  tag: ['..(tag or 'nil')..']  TAGS: '..(XMERCHANT_DEBUG_TAGS[tag] or 'nil'))
		
		if not tag 
		or tag and not XMERCHANT_DEBUG_TAGS[tag] 
		or tag and XMERCHANT_DEBUG_TAGS[tag] and XMERCHANT_DEBUG_TAGS[tag] == 1 then
			DEFAULT_CHAT_FRAME:AddMessage('[xMerchant][Debug] '..msg)
		end
	end
end

local function GetError(link, isRecipe)
	--XMERCHANT_LOG_DEBUG('==== GetError ====   link: '..link)
	if ( not link ) then
		return false
	end
	
	local id = link:match('item:(%d+)')
	if ( errors[id] ) then
		XMERCHANT_LOG_DEBUG('GetError  '..link..'  @return errors[id]: '..errors[id])
		return errors[id]
	end
	
	tooltip:SetOwner(UIParent, 'ANCHOR_NONE')
	tooltip:SetHyperlink(link)
	
	local errormsg = ''
	for i=2, tooltip:NumLines() do
		local text = _G['LanMerchantTooltipTextLeft'..i]
		local r, g, b = text:GetTextColor()
		local gettext = text:GetText()
		if ( gettext and r >= 0.9 and g <= 0.2 and b <= 0.2 and gettext ~= RETRIEVING_ITEM_INFO ) then
			if ( errormsg ~= '' ) then
				errormsg = errormsg..', '
			end
			
			local level = gettext:match(REQUIRES_LEVEL)
			if ( level ) then
				errormsg = errormsg..LEVEL:format(level)
			end
			
			local reputation = gettext:match(REQUIRES_REPUTATION)
			if ( reputation ) then
				errormsg = errormsg..reputation
				-- DONEY
				local factionName = gettext:match(REQUIRES_REPUTATION_NAME)
				if ( factionName ) then
					local standingLabel = factions[factionName]
					if ( standingLabel ) then
						errormsg = errormsg..' ('..standingLabel..') - '..factionName
					else
						errormsg = errormsg..' ('..factionName..')'
					end
				end
				XMERCHANT_LOG_DEBUG('RequireFaction  '..'  : '..(reputation or '')..'  : '..(factionName or ''))
			end
			
			local skill, slevel = gettext:match(REQUIRES_SKILL)
			if ( skill and slevel ) then
				errormsg = errormsg..SKILL:format(skill, slevel)
			end
			
			local requires = gettext:match(REQUIRES)
			if ( not level and not reputation and not skill and requires ) then
				XMERCHANT_LOG_DEBUG('GetError  Line: '..i..'   REQUIRES: '..(requires or ''))
				errormsg = errormsg..requires
			end
			
			if ( not level and not reputation and not skill and not requires ) then
				if ( errormsg ~= '' ) then
					errormsg = gettext..', '..errormsg
				else
					errormsg = errormsg..gettext
				end
			end
		end
		
		local text = _G['LanMerchantTooltipTextRight'..i]
		local r, g, b = text:GetTextColor()
		local gettext = text:GetText()
		if ( gettext and r >= 0.9 and g <= 0.2 and b <= 0.2 ) then
			if ( errormsg ~= '' ) then
				errormsg = errormsg..', '
			end
			errormsg = errormsg..gettext
		end
		
		XMERCHANT_LOG_DEBUG('GetError  Line: '..i..'   TooltipTextLeft: '..(_G['LanMerchantTooltipTextLeft'..i]:GetText() or ''))
		XMERCHANT_LOG_DEBUG('GetError  Line: '..i..'   TooltipTextRight: '..(_G['LanMerchantTooltipTextRight'..i]:GetText() or ''))
		
		if ( isRecipe and i == 5 ) then
			XMERCHANT_LOG_DEBUG('GetError  Line: '..i..'   isRecipe detail line')
			break
		end
	end
	
	if ( errormsg == '' ) then
		return false
	end
	
	errors[id] = errormsg
	return errormsg
end

local function GetKnown(link)
	--XMERCHANT_LOG_DEBUG('==== GetKnown ====   link: '..link)
	if ( not link ) then
		--XMERCHANT_LOG_DEBUG('GetKnown  not link   @return false')
		return false
	end
	
	local id = link:match('item:(%d+)')
	if ( knowns[id] ) then
		XMERCHANT_LOG_DEBUG('GetKnown  '..link..'  @return true')
		return true
	end
	
	tooltip:SetOwner(UIParent, 'ANCHOR_NONE')
	tooltip:SetHyperlink(link)
	
	for i=1, tooltip:NumLines() do
		if ( _G['LanMerchantTooltipTextLeft'..i]:GetText() == ITEM_SPELL_KNOWN ) then
			knowns[id] = true
			--XMERCHANT_LOG_DEBUG('GetKnown  Line: '..i..'  '.._G['LanMerchantTooltipTextLeft'..i]:GetText())
			return true
		end
	end
	
	return false
end

-- DONEY
local function FactionsUpdate()
	wipe(factions)
	
	for factionIndex = 1, GetNumFactions() do
		-- Patch 5.0.4 Added new return value: factionID
		local name, description, standingId, bottomValue, topValue, earnedValue, atWarWith,
			canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild, factionID = GetFactionInfo(factionIndex)
		-- Patch 5.1.0 Added API GetFriendshipReputation
		local friendID, friendRep, friendMaxRep, friendName, friendText, friendTexture, friendTextLevel = GetFriendshipReputation(factionID)
		
		if isHeader == nil then
			-- ## thanks to SSJNinjaMonkey @ curse ##
			-- << debug code
			--[[ if standingId == 1 then
				standingId = 10
			end
			if standingId == 2 then
				standingId = 9
			end
			--]]
			-- debug code >>
			local standingLabel
			if friendID ~= nil then
				standingLabel = friendTextLevel or 'unkown'
			else
				standingLabel = _G['FACTION_STANDING_LABEL'..tostring(standingId)] or 'unkown'
			end
			factions[name] = standingLabel
			
			if friendID ~= nil then
				XMERCHANT_LOG_DEBUG('FactionsUpdate  ' .. name .. ' - ' .. earnedValue .. ' - ' .. bottomValue .. ' - ' .. topValue
					.. ' - ' .. tostring(standingId) .. ' ' .. standingLabel)
			end
	  end
	end
end

local function CurrencyUpdate()
	wipe(currencies)
	
	for i=1, GetCurrencyListSize(), 1 do
		local name, isHeader, _, _, _, count, _, _, itemID = GetCurrencyListInfo(i)
		if ( not isHeader and itemID ) then
			currencies[tonumber(itemID)] = count
			-- DONEY fix for 5.0 points
			if ( not isHeader and itemID and tonumber(itemID) <= 9 ) then
				currencies[name] = count
			end
			XMERCHANT_LOG_DEBUG('CurrencyUpdate  '..'  name: '..(name or 'nil')..'  count: '..(count or 'nil')..'  itemID: '..(itemID or 'nil'))
		elseif ( not isHeader and not itemID ) then
			currencies[name] = count
			XMERCHANT_LOG_DEBUG('CurrencyUpdate  '..'  name: '..(name or 'nil')..'  count: '..(count or 'nil')..'  not itemID: '..(itemID or 'nil'))
		end
	end
	
	XMERCHANT_DEBUG_TAGS['CurrencyUpdate'] = 0
	
	for i=INVSLOT_FIRST_EQUIPPED, INVSLOT_LAST_EQUIPPED, 1 do
		local itemID = GetInventoryItemID('player', i)
		if ( itemID ) then
			currencies[tonumber(itemID)] = 1
		end
	end
	
	for bagID=0, NUM_BAG_SLOTS, 1 do
		local numSlots = GetContainerNumSlots(bagID)
		for slotID=1, numSlots, 1 do
			local itemID = GetContainerItemID(bagID, slotID)
			if ( itemID ) then
				local count = select(2, GetContainerItemInfo(bagID, slotID))
				itemID = tonumber(itemID)
				local currency = currencies[itemID]
				if ( currency ) then
					currencies[itemID] = currency+count
				else
					currencies[itemID] = count
				end
			end
		end
	end
end

local function AltCurrencyFrame_Update(item, texture, cost, itemID, currencyName)
	if ( itemID ~= 0 or currencyName) then
		local currency = currencies[itemID] or currencies[currencyName]
		if ( currency and currency < cost or not currency ) then
			-- DONEY
			XMERCHANT_LOG_DEBUG('AltCurrency  currency: '..(currency or 'nil')..'  cost: '..(cost or 'nil')..'  itemID: '..(itemID or 'nil')..'  currencyName: '..(currencyName or 'nil'))
			item.count:SetTextColor(1, 0, 0)
		else
			item.count:SetTextColor(1, 1, 1)
		end
	end
	
	item.count:SetText(cost)
	item.icon:SetTexture(texture)
	if ( item.pointType == HONOR_POINTS ) then
		item.count:SetPoint('RIGHT', item.icon, 'LEFT', 1, 0)
		item.icon:SetTexCoord(0.03125, 0.59375, 0.03125, 0.59375)
	else
		item.count:SetPoint('RIGHT', item.icon, 'LEFT', -2, 0)
		item.icon:SetTexCoord(0, 1, 0, 1)
	end
	local iconWidth = 17
	item.icon:SetWidth(iconWidth)
	item.icon:SetHeight(iconWidth)
	item:SetWidth(item.count:GetWidth() + iconWidth + 4)
	item:SetHeight(item.count:GetHeight() + 4)
end

local function UpdateAltCurrency(button, index, i)
	local lastFrame
	local honorPoints, arenaPoints, itemCount = GetMerchantItemCostInfo(index)
	
	if ( select(4, GetBuildInfo()) >= 40000 ) then
		itemCount, honorPoints, arenaPoints = honorPoints, 0, 0
	end
	
	if ( itemCount > 0 ) then
		for i=1, MAX_ITEM_COST, 1 do
			local itemTexture, itemValue, itemLink, currencyName = GetMerchantItemCostItem(index, i)
			local item = button.item[i]
			item.index = index
			item.item = i
			if( currencyName ) then
				item.pointType = 'Beta'
				item.itemLink = currencyName
			else
				item.pointType = nil
				item.itemLink = itemLink
			end
			
			-- DONEY
			if i == 1 then
				XMERCHANT_LOG_DEBUG('AltCurrency  '..'  index: '..(index or 'nil')..'  itemLink: '..(itemLink or 'nil')..'  i: '..(i or 'nil'))
			end
			local itemID = tonumber((itemLink or 'item:0'):match('item:(%d+)'))
			AltCurrencyFrame_Update(item, itemTexture, itemValue, itemID, currencyName)

			if ( not itemTexture ) then
				item:Hide()
			else
				lastFrame = item
				item:Show()
			end
		end
	else
		for i=1, MAX_ITEM_COST, 1 do
			button.item[i]:Hide()
		end
	end
	
	local arena = button.arena
	if ( arenaPoints > 0 ) then
		arena.pointType = ARENA_POINTS
		
		AltCurrencyFrame_Update(arena, 'Interface\\PVPFrame\\PVP-ArenaPoints-Icon', arenaPoints)
		
		if ( GetArenaCurrency() < arenaPoints ) then
			arena.count:SetTextColor(1, 0, 0)
		else
			arena.count:SetTextColor(1, 1, 1)
		end
		
		if ( lastFrame ) then
			arena:SetPoint('RIGHT', lastFrame, 'LEFT', -2, 0)
		else
			arena:SetPoint('RIGHT', -2, 0)
		end
		lastFrame = arena
		arena:Show()
	else
		arena:Hide()
	end
	
	local honor = button.honor
	if ( honorPoints > 0 ) then
		honor.pointType = HONOR_POINTS
		
		local factionGroup = UnitFactionGroup('player')
		local honorTexture = 'Interface\\TargetingFrame\\UI-PVP-Horde'
		if ( factionGroup ) then
			honorTexture = 'Interface\\TargetingFrame\\UI-PVP-'..factionGroup
		end
		
		AltCurrencyFrame_Update(honor, honorTexture, honorPoints)
		
		if ( GetHonorCurrency() < honorPoints ) then
			honor.count:SetTextColor(1, 0, 0)
		else
			honor.count:SetTextColor(1, 1, 1)
		end
		
		if ( lastFrame ) then
			honor:SetPoint('RIGHT', lastFrame, 'LEFT', -2, 0)
		else
			honor:SetPoint('RIGHT', -2, 0)
		end
		lastFrame = honor
		honor:Show()
	else
		honor:Hide()
	end
	
	if ( lastFrame ) then
		button.money:SetPoint('RIGHT', lastFrame, 'LEFT', -2, 0)
	else
		button.money:SetPoint('RIGHT', -2, 0)
	end
end

local function MerchantUpdate()
	local self = LanMerchantFrame
	local numMerchantItems = GetMerchantNumItems()
	
	--[[
	if (ENABLE_DEBUG_DONEY) then
		local itemClasses = { GetAuctionItemClasses() }
			if #itemClasses > 0 then
			local itemClass
			for _, itemClass in pairs(itemClasses) do
			DEFAULT_CHAT_FRAME:AddMessage(itemClass)
			end
		end
	end
	]]--
	
	FauxScrollFrame_Update(self.scrollframe, numMerchantItems, 10, 29.4, nil, nil, nil, nil, nil, nil, 1)
	for i=1, 10, 1 do
		local offset = i+FauxScrollFrame_GetOffset(self.scrollframe)
		local button = buttons[i]
		button.hover = nil
		if ( offset <= numMerchantItems ) then
			--API name, texture, price, quantity, numAvailable, isUsable, extendedCost = GetMerchantItemInfo(index)
			local name, texture, price, quantity, numAvailable, isUsable, extendedCost = GetMerchantItemInfo(offset)
			local link = GetMerchantItemLink(offset)
			-- DONEY
			local subtext = ''
			local r, g, b = 0.5, 0.5, 0.5
			local _, itemRarity, itemType, itemSubType
			local iLevel, iLevelText
			if ( link ) then
				--API name, link, quality, iLevel, reqLevel, class, subclass, maxStack, equipSlot, texture, vendorPrice = GetItemInfo(itemID) or GetItemInfo('itemName') or GetItemInfo('itemLink')
				_, _, itemRarity, iLevel, _, itemType, itemSubType = GetItemInfo(link)
				r, g, b = GetItemQualityColor(itemRarity)
				button.itemname:SetTextColor(r, g, b)
				-- DONEY
				subtext = itemSubType:gsub('%(OBSOLETE%)', '')
				if true and iLevel > 1 then
					iLevelText = tostring(iLevel)
					subtext = subtext..' - '..iLevelText
				end
				button.iteminfo:SetText(subtext)
				
				local alpha = 0.3
				if ( searching == '' or searching == SEARCH:lower() or name:lower():match(searching) or tostring(itemRarity):lower():match(searching) or _G['ITEM_QUALITY'..tostring(itemRarity)..'_DESC']:lower():match(searching) or itemType:lower():match(searching) or itemSubType:lower():match(searching)) then
					alpha = 1
				elseif ( self.tooltipsearching ) then
					tooltip:SetOwner(UIParent, 'ANCHOR_NONE')
					tooltip:SetHyperlink(link)
					for i=1, tooltip:NumLines() do
						if ( _G['LanMerchantTooltipTextLeft'..i]:GetText():lower():match(searching) ) then
							alpha = 1
							break
						end
					end
				end
				button:SetAlpha(alpha)
			else
				-- TODO: feature of currencies player have
				-- if currencies[name] then
					-- subtext = 'You have: ' .. tostring(currencies[name])
				-- end
				button.iteminfo:SetText(subtext)
			end
			
			-- XMERCHANT_LOG_DEBUG('MerchantItemInfo  '..' - '..(name or '')
				-- ..' - quantity '..(quantity and tostring(quantity) or '')
				-- ..' - numAvailable '..(numAvailable and tostring(numAvailable) or '')
				-- ..' - isUsable '..(isUsable and tostring(isUsable) or '')
				-- ..' - extendedCost '..(extendedCost and tostring(extendedCost) or ''))
			
			button.itemname:SetText((numAvailable >= 0 and '|cffffffff['..numAvailable..']|r ' or '')..(quantity > 1 and '|cffffffff'..quantity..'x|r ' or '')..(name or '|cffff0000'..RETRIEVING_ITEM_INFO))
			-- button.itemlevel:SetText(iLevelText or '')
			button.icon:SetTexture(texture)
			
			UpdateAltCurrency(button, offset, i)
			if ( extendedCost and price <= 0 ) then
				button.price = nil
				button.extendedCost = true
				button.money:SetText('')
			elseif ( extendedCost and price > 0 ) then
				button.price = price
				button.extendedCost = true
				button.money:SetText(GetCoinTextureString(price))
			else
				button.price = price
				button.extendedCost = nil
				button.money:SetText(GetCoinTextureString(price))
			end
			
			if ( GetMoney() < price ) then
				button.money:SetTextColor(1, 0, 0)
			else
				button.money:SetTextColor(1, 1, 1)
			end
			
			if ( numAvailable == 0 ) then
				button.highlight:SetVertexColor(0.5, 0.5, 0.5, 0.5)
				button.highlight:Show()
				button.isShown = 1
			elseif ( not isUsable ) then
				button.highlight:SetVertexColor(1, 0.2, 0.2, 0.5)
				button.highlight:Show()
				button.isShown = 1
				
				local errors = GetError(link, itemType and itemType == RECIPE)
				if ( errors ) then
					-- DONEY
					button.iteminfo:SetText('|cffd00000'..subtext..' - '..errors..'|r')
				end
			elseif ( itemType and itemType == RECIPE and not GetKnown(link) ) then
				button.highlight:SetVertexColor(0.2, 1, 0.2, 0.5)
				button.highlight:Show()
				button.isShown = 1
			else
				button.highlight:SetVertexColor(r, g, b, 0.5)
				button.highlight:Hide()
				button.isShown = nil
				-- DONEY
				local errors = GetError(link, itemType and itemType == RECIPE)
				if ( errors ) then
					button.iteminfo:SetText('|cffd00000'..subtext..' - '..errors..'|r')
				end
			end
			
			button.r = r
			button.g = g
			button.b = b
			button.link = GetMerchantItemLink(offset)
			button.hasItem = true
			button.texture = texture
			button:SetID(offset)
			button:Show()
		else
			button.price = nil
			button.hasItem = nil
			button:Hide()
		end
		if ( button.hasStackSplit == 1 ) then
			StackSplitFrame:Hide()
		end
	end
end

local function OnVerticalScroll(self, offset)
	FauxScrollFrame_OnVerticalScroll(self, offset, 29.4, MerchantUpdate)
end

local function OnClick(self, button)
	if ( IsModifiedClick() ) then
		MerchantItemButton_OnModifiedClick(self, button)
	else
		MerchantItemButton_OnClick(self, button)
	end
end

local function OnEnter(self)
	if ( self.isShown and not self.hover ) then
		self.oldr, self.oldg, self.oldb, self.olda = self.highlight:GetVertexColor()
		self.highlight:SetVertexColor(self.r, self.g, self.b, self.olda)
		self.hover = 1
	else
		self.highlight:Show()
	end
	MerchantItemButton_OnEnter(self)
end

local function OnLeave(self)
	if ( self.isShown ) then
		self.highlight:SetVertexColor(self.oldr, self.oldg, self.oldb, self.olda)
		self.hover = nil
	else
		self.highlight:Hide()
	end
	GameTooltip:Hide()
	ResetCursor()
	MerchantFrame.itemHover = nil
end

local function SplitStack(button, split)
	if ( button.extendedCost ) then
		MerchantFrame_ConfirmExtendedItemCost(button, split)
	elseif ( split > 0 ) then
		BuyMerchantItem(button:GetID(), split)
	end
end

local function Item_OnClick(self)
	HandleModifiedItemClick(self.itemLink)
end

local function Item_OnEnter(self)
	local parent = self:GetParent()
	if ( parent.isShown and not parent.hover ) then
		parent.oldr, parent.oldg, parent.oldb, parent.olda = parent.highlight:GetVertexColor()
		parent.highlight:SetVertexColor(parent.r, parent.g, parent.b, parent.olda)
		parent.hover = 1
	else
		parent.highlight:Show()
	end
	
	GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
	if ( self.pointType == ARENA_POINTS ) then
		GameTooltip:SetText(ARENA_POINTS, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
		GameTooltip:AddLine(TOOLTIP_ARENA_POINTS, nil, nil, nil, 1)
		GameTooltip:Show()
	elseif ( self.pointType == HONOR_POINTS ) then
		GameTooltip:SetText(HONOR_POINTS, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
		GameTooltip:AddLine(TOOLTIP_HONOR_POINTS, nil, nil, nil, 1)
		GameTooltip:Show()
	elseif ( self.pointType == 'Beta' ) then
		GameTooltip:SetText(self.itemLink, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
		GameTooltip:Show()
	else
		GameTooltip:SetHyperlink(self.itemLink)
	end
	if ( IsModifiedClick('DRESSUP') ) then
		ShowInspectCursor()
	else
		ResetCursor()
	end
end

local function Item_OnLeave(self)
	local parent = self:GetParent()
	if ( parent.isShown ) then
		parent.highlight:SetVertexColor(parent.oldr, parent.oldg, parent.oldb, parent.olda)
		parent.hover = nil
	else
		parent.highlight:Hide()
	end
	GameTooltip:Hide()
	ResetCursor()
end

local function OnEvent(self, event, ...)
	if ( addonName == select(1, ...) ) then
		self:UnregisterEvent('ADDON_LOADED')
		
		local x = 0
		if ( IsAddOnLoaded('SellOMatic') ) then
			x = 20
		elseif ( IsAddOnLoaded('DropTheCheapestThing') ) then
			x = 14
		end
		if ( x ~= 0 ) then
			-- DONEY
			self.search:SetWidth(92-x)
			self.search:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 50-x, 9)
		end
		return
	end
end

local frame = CreateFrame('Frame', 'LanMerchantFrame', MerchantFrame)
frame:RegisterEvent('ADDON_LOADED')
frame:SetScript('OnEvent', OnEvent)
frame:SetWidth(295)
frame:SetHeight(294)
-- DONEY
-- frame:SetPoint('TOPLEFT', 21, -76)
frame:SetPoint('TOPLEFT', 10, -65)

local function OnTextChanged(self)
	searching = self:GetText():trim():lower()
	MerchantUpdate()
end

local function OnShow(self)
	self:SetText(SEARCH)
	searching = ''
end

local function OnEnterPressed(self)
	self:ClearFocus()
end

local function OnEscapePressed(self)
	self:ClearFocus()
	self:SetText(SEARCH)
	searching = ''
end

local function OnEditFocusLost(self)
	self:HighlightText(0, 0)
	if ( strtrim(self:GetText()) == '' ) then
		self:SetText(SEARCH)
		searching = ''
	end
end

local function OnEditFocusGained(self)
	self:HighlightText()
	if ( self:GetText():trim():lower() == SEARCH:lower() ) then
		self:SetText('')
	end
end

local search = CreateFrame('EditBox', '$parentSearch', frame, 'InputBoxTemplate')
frame.search = search
-- DONEY
search:SetWidth(92)
search:SetHeight(24)
-- DONEY
search:SetPoint('BOTTOMLEFT', frame, 'TOPLEFT', 50, 9)
search:SetAutoFocus(false)
search:SetFontObject(ChatFontSmall)
search:SetScript('OnTextChanged', OnTextChanged)
search:SetScript('OnShow', OnShow)
search:SetScript('OnEnterPressed', OnEnterPressed)
search:SetScript('OnEscapePressed', OnEscapePressed)
search:SetScript('OnEditFocusLost', OnEditFocusLost)
search:SetScript('OnEditFocusGained', OnEditFocusGained)
search:SetText(SEARCH)

local function Search_OnClick(self)
	if ( self:GetChecked() ) then
		PlaySound('igMainMenuOptionCheckBoxOn')
		frame.tooltipsearching = 1
	else
		PlaySound('igMainMenuOptionCheckBoxOff')
		frame.tooltipsearching = nil
	end
	if ( searching ~= '' and searching ~= SEARCH:lower() ) then
		MerchantUpdate()
	end
end

local function Search_OnEnter(self)
	GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
	GameTooltip:SetText('To browse item tooltips, too')
end

local tooltipsearching = CreateFrame('CheckButton', '$parentTooltipSearching', frame, 'InterfaceOptionsSmallCheckButtonTemplate')
search.tooltipsearching = tooltipsearching
tooltipsearching:SetWidth(21)
tooltipsearching:SetHeight(21)
tooltipsearching:SetPoint('LEFT', search, 'RIGHT', -1, 0)
tooltipsearching:SetHitRectInsets(0, 0, 0, 0)
tooltipsearching:SetScript('OnClick', Search_OnClick)
tooltipsearching:SetScript('OnEnter', Search_OnEnter)
tooltipsearching:SetScript('OnLeave', GameTooltip_Hide)
tooltipsearching:SetChecked(false)

local scrollframe = CreateFrame('ScrollFrame', 'LanMerchantScrollFrame', frame, 'FauxScrollFrameTemplate')
frame.scrollframe = scrollframe
-- DONEY
-- scrollframe:SetWidth(295)
scrollframe:SetWidth(284)
scrollframe:SetHeight(298)
-- DONEY
-- scrollframe:SetPoint('TOPLEFT', MerchantFrame, 22, -74)
scrollframe:SetPoint('TOPLEFT', MerchantFrame, 22, -65)
scrollframe:SetScript('OnVerticalScroll', OnVerticalScroll)

local top = frame:CreateTexture('$parentTop', 'ARTWORK')
frame.top = top
top:SetWidth(31)
top:SetHeight(256)
top:SetPoint('TOPRIGHT', 30, 6)
top:SetTexture('Interface\\PaperDollInfoFrame\\UI-Character-ScrollBar')
top:SetTexCoord(0, 0.484375, 0, 1)

local bottom = frame:CreateTexture('$parentBottom', 'ARTWORK')
frame.bottom = bottom
bottom:SetWidth(31)
bottom:SetHeight(108)
bottom:SetPoint('BOTTOMRIGHT', 30, -6)
bottom:SetTexture('Interface\\PaperDollInfoFrame\\UI-Character-ScrollBar')
bottom:SetTexCoord(0.515625, 1, 0, 0.421875)

for i=1, 10, 1 do
	local button = CreateFrame('Button', 'LanMerchantFrame'..i, frame)
	button:SetWidth(frame:GetWidth())
	button:SetHeight(29.4)
	if ( i == 1 ) then
		button:SetPoint('TOPLEFT', 0, -1)
	else
		button:SetPoint('TOP', buttons[i-1], 'BOTTOM')
	end
	button:RegisterForClicks('LeftButtonUp','RightButtonUp')
	button:RegisterForDrag('LeftButton')
	button.UpdateTooltip = OnEnter
	button.SplitStack = SplitStack
	button:SetScript('OnClick', OnClick)
	button:SetScript('OnDragStart', MerchantItemButton_OnClick)
	button:SetScript('OnEnter', OnEnter)
	button:SetScript('OnLeave', OnLeave)
	button:SetScript('OnHide', OnHide)
	
	local highlight = button:CreateTexture('$parentHighlight', 'BACKGROUND') -- better highlight
	button.highlight = highlight
	highlight:SetAllPoints()
	highlight:SetBlendMode('ADD')
	highlight:SetTexture('Interface\\Buttons\\UI-Listbox-Highlight2')
	highlight:Hide()
	
	local itemname = button:CreateFontString('ARTWORK', '$parentItemName', 'GameFontHighlightSmall')
	button.itemname = itemname
	itemname:SetPoint('TOPLEFT', 30.4, -3)
	-- DONEY
	itemname:SetPoint('TOPLEFT', 30.4, 0)
	itemname:SetJustifyH('LEFT')
	
	local iteminfo = button:CreateFontString('ARTWORK', '$parentItemInfo', 'GameFontDisableSmall')
	button.iteminfo = iteminfo
	iteminfo:SetPoint('BOTTOMLEFT', 30.4, 3)
	iteminfo:SetJustifyH('LEFT')
	-- DONEY
	iteminfo:SetPoint('BOTTOMLEFT', 35.4, 0)
	iteminfo:SetTextHeight(14)
	
	local icon = button:CreateTexture('$parentIcon', 'BORDER')
	button.icon = icon
	icon:SetWidth(25.4)
	icon:SetHeight(25.4)
	icon:SetPoint('LEFT', 2, 0)
	icon:SetTexture('Interface\\Icons\\temp')
    
    local bd = CreateFrame('Frame', nil, button)
    bd:SetWidth(26.4)
    bd:SetHeight(26.4)
    bd:SetPoint('LEFT', 2, 0)
    bd:SetTemplate(true)
	
	-- DONEY todo?
	-- local itemlevel = button:CreateFontString('ARTWORK', '$parentItemName', 'GameFontNormalSmall')
	-- button.itemlevel = itemlevel
	-- itemlevel:SetPoint('BOTTOMLEFT', 1.0, -3)
	-- itemlevel:SetJustifyH('LEFT')
	
	local money = button:CreateFontString('ARTWORK', '$parentMoney', 'GameFontHighlight')
	button.money = money
	money:SetPoint('RIGHT', -2, 0)
	money:SetJustifyH('RIGHT')
	itemname:SetPoint('RIGHT', money, 'LEFT', -2, 0)
	iteminfo:SetPoint('RIGHT', money, 'LEFT', -2, 0)
	
	button.item = {}
	for j=1, MAX_ITEM_COST, 1 do
		local item = CreateFrame('Button', '$parentItem'..j, button)
		button.item[j] = item
		item:SetWidth(17)
		item:SetHeight(17)
		if ( j == 1 ) then
			item:SetPoint('RIGHT', -2, 0)
		else
			item:SetPoint('RIGHT', button.item[j-1], 'LEFT', -2, 0)
		end
		item:RegisterForClicks('LeftButtonUp','RightButtonUp')
		item:SetScript('OnClick', Item_OnClick)
		item:SetScript('OnEnter', Item_OnEnter)
		item:SetScript('OnLeave', Item_OnLeave)
		item.hasItem = true
		item.UpdateTooltip = Item_OnEnter
		
		local icon = item:CreateTexture('$parentIcon', 'BORDER')
		item.icon = icon
		icon:SetWidth(17)
		icon:SetHeight(17)
		icon:SetPoint('RIGHT')
		
		local count = item:CreateFontString('ARTWORK', '$parentCount', 'GameFontHighlight')
		item.count = count
		count:SetPoint('RIGHT', icon, 'LEFT', -2, 0)
	end
	
	local honor = CreateFrame('Button', '$parentHonor', button)
	button.honor = honor
	honor.itemLink = select(2, GetItemInfo(43308)) or '\124cffffffff\124Hitem:43308:0:0:0:0:0:0:0:0\124h[Ehrenpunkte]\124h\124r'
	honor:SetWidth(17)
	honor:SetHeight(17)
	honor:SetPoint('RIGHT', -2, 0)
	honor:RegisterForClicks('LeftButtonUp','RightButtonUp')
	honor:SetScript('OnClick', Item_OnClick)
	honor:SetScript('OnEnter', Item_OnEnter)
	honor:SetScript('OnLeave', Item_OnLeave)
	honor.hasItem = true
	honor.UpdateTooltip = Item_OnEnter
	
	local icon = honor:CreateTexture('$parentIcon', 'BORDER')
	honor.icon = icon
	icon:SetWidth(17)
	icon:SetHeight(17)
	icon:SetPoint('RIGHT')
	
	local count = honor:CreateFontString('ARTWORK', '$parentCount', 'GameFontHighlight')
	honor.count = count
	count:SetPoint('RIGHT', icon, 'LEFT', -2, 0)
	
	local arena = CreateFrame('Button', '$parentArena', button)
	button.arena = arena
	arena.itemLink = select(2, GetItemInfo(43307)) or '\124cffffffff\124Hitem:43307:0:0:0:0:0:0:0:0\124h[Arenapunkte]\124h\124r'
	arena:SetWidth(17)
	arena:SetHeight(17)
	arena:SetPoint('RIGHT', -2, 0)
	arena:RegisterForClicks('LeftButtonUp','RightButtonUp')
	arena:SetScript('OnClick', Item_OnClick)
	arena:SetScript('OnEnter', Item_OnEnter)
	arena:SetScript('OnLeave', Item_OnLeave)
	arena.hasItem = true
	arena.UpdateTooltip = Item_OnEnter
	
	local icon = arena:CreateTexture('$parentIcon', 'BORDER')
	arena.icon = icon
	icon:SetWidth(17)
	icon:SetHeight(17)
	icon:SetPoint('RIGHT')
	
	local count = arena:CreateFontString('ARTWORK', '$parentCount', 'GameFontHighlight')
	arena.count = count
	count:SetPoint('RIGHT', icon, 'LEFT', -2, 0)
	
	buttons[i] = button
end

local function Update()
	if ( MerchantFrame.selectedTab == 1 ) then
		for i=1, 12, 1 do
			_G['MerchantItem'..i]:Hide()
		end
		frame:Show()
		CurrencyUpdate()
		-- DONEY
		FactionsUpdate()
		MerchantUpdate()
	else
		frame:Hide()
		for i=1, 12, 1 do
			_G['MerchantItem'..i]:Show()
		end
		if ( StackSplitFrame:IsShown() ) then
			StackSplitFrame:Hide()
		end
	end
end
hooksecurefunc('MerchantFrame_Update', Update)

local function OnHide()
	wipe(errors)
	wipe(currencies)
end
hooksecurefunc('MerchantFrame_OnHide', OnHide)


MerchantBuyBackItem:ClearAllPoints()
-- DONEY
-- MerchantBuyBackItem:SetPoint('BOTTOMLEFT', 189, 90)
MerchantBuyBackItem:SetPoint('BOTTOMLEFT', 175, 32)

for _, frame in next, { MerchantNextPageButton, MerchantPrevPageButton, MerchantPageText } do
	frame:Hide()
	frame.Show = function() end
end


-- Mail handling

do
    local lastReceipient
    F.RegisterEvent('MAIL_SEND_SUCCESS', function()
        if(lastReceipient) then
            SendMailNameEditBox:SetText(lastReceipient)
            SendMailNameEditBox:ClearFocus()
        end
    end)

    hooksecurefunc('SendMail', function(name)
        lastReceipient = name
    end)
end

F.RegisterEvent('UPDATE_PENDING_MAIL', function()
    for index = 1, GetNumTrackingTypes() do
        local name, texture, active = GetTrackingInfo(index)
        if(name == MINIMAP_TRACKING_MAILBOX) then
            if(HasNewMail() and not active) then
                return SetTracking(index, true)
            elseif(not HasNewMail() and active) then
                return SetTracking(index, false)
            end
        end
    end
end)

F.RegisterEvent('UI_ERROR_MESSAGE', function(msg)
    if(msg == ERR_MAIL_INVALID_ATTACHMENT_SLOT) then
        SendMailMailButton:Click()
    end
end)

do
    local button = CreateFrame('Button', nil, InboxFrame, 'UIPanelButtonTemplate')

    local totalElapsed = 0
    local function UpdateInbox(self, elapsed)
        if(totalElapsed < 10) then
            totalElapsed = totalElapsed + elapsed
        else
            totalElapsed = 0

            CheckInbox()
        end
    end

    local function MoneySubject(self)
        if(self:GetText() ~= '' and SendMailSubjectEditBox:GetText() == '') then
            SendMailSubjectEditBox:SetText(MONEY)
        end
    end

    local function GetFreeSlots()
        local slots = 0
        for bag = BACKPACK_CONTAINER, NUM_BAG_SLOTS do
            local free, family = GetContainerNumFreeSlots(bag)
            if(family == 0) then
                slots = slots + free
            end
        end

        return slots
    end

    local skipNum, lastNum, cashOnly, unreadOnly
    local function GetMail()
        if(GetInboxNumItems() - skipNum <= 0) then
            button:Enable()
            button:UnregisterEvent('MAIL_INBOX_UPDATE')
            return
        end

        local index = 1 + skipNum
        local __, __, __, __, money, cod, __, multiple, read, __, __, __, __, single = GetInboxHeaderInfo(index)

        if(cod > 0 or (cashOnly and multiple) or (unreadOnly and read)) then
            skipNum = skipNum + 1
            GetMail()
        elseif(money > 0) then
            TakeInboxMoney(index)
        elseif(single and (GetFreeSlots() > 6)) then
            AutoLootMailItem(index)
        elseif(multiple and (GetFreeSlots() + multiple > 6)) then
            AutoLootMailItem(index)
        end
    end

    button:SetScript('OnEvent', function(self)
        local num = GetInboxNumItems()
        if(lastNum ~= num) then
            lastNum = num
        else
            return
        end

        GetMail()
    end)

    button:SetScript('OnClick', function(self)
        self:RegisterEvent('MAIL_INBOX_UPDATE')
        self:Disable()

        cashOnly = IsShiftKeyDown()
        unreadOnly = IsControlKeyDown()
        lastNum = 0
        skipNum = 0

        GetMail()
    end)

    local initialized
    F.RegisterEvent('MAIL_SHOW', function()
        if(initialized) then
            button:Enable()
            button:SetText(QUICKBUTTON_NAME_EVERYTHING)
            return
        end

        button:SetPoint('BOTTOM', -28, 100)
        button:SetSize(90, 25)
        button:SetText(QUICKBUTTON_NAME_EVERYTHING)
        button:SetTemplate()
        button:SkinButton()

        InboxFrame:HookScript('OnUpdate', UpdateInbox)

        SendMailMoneyGold:HookScript('OnTextChanged', MoneySubject)
        SendMailMoneySilver:HookScript('OnTextChanged', MoneySubject)
        SendMailMoneyCopper:HookScript('OnTextChanged', MoneySubject)
        
        MiniMapMailFrame:Hide()

        initialized = true
    end)

    F.RegisterEvent('MODIFIER_STATE_CHANGED', function()
        if(not InboxFrame:IsShown()) then return end

        if(IsShiftKeyDown()) then
            button:SetText('Money')
        elseif(IsControlKeyDown()) then
            button:SetText('Unread')
        else
            button:SetText('Everything')
        end
    end)
end

-- UIScaler by Haleth
local scaler = CreateFrame('Frame')
scaler:RegisterEvent('VARIABLES_LOADED')
scaler:RegisterEvent('UI_SCALE_CHANGED')
scaler:SetScript('OnEvent', function(self, event)
	if not InCombatLockdown() then
		local scale = 768/string.match(({GetScreenResolutions()})[GetCurrentResolution()], '%d+x(%d+)')
		if scale < .64 then
			UIParent:SetScale(scale)
		else
			self:UnregisterEvent('UI_SCALE_CHANGED')
			SetCVar('uiScale', scale)
		end
	else
		self:RegisterEvent('PLAYER_REGEN_ENABLED')
	end

	if event == 'PLAYER_REGEN_ENABLED' then
		self:UnregisterEvent('PLAYER_REGEN_ENABLED')
	end
end)

-- RareAlert by Haleth
local f = CreateFrame('Frame')
f:RegisterEvent('VIGNETTE_ADDED')
f:SetScript('OnEvent', function()
	PlaySoundFile('Sound\\Interface\\RaidWarning.wav')
	RaidNotice_AddMessage(RaidWarningFrame, 'Rare spotted!', ChatTypeInfo['RAID_WARNING'])
end)

-- Cinematic Handling
F.RegisterEvent('CINEMATIC_START', function(boolean)
    SetCVar('Sound_EnableMusic', 1)
    SetCVar('Sound_EnableAmbience', 1)
    SetCVar('Sound_EnableSFX', 1)
end)

F.RegisterEvent('CINEMATIC_STOP', function()
    SetCVar('Sound_EnableMusic', 0)
    SetCVar('Sound_EnableAmbience', 1)
    SetCVar('Sound_EnableSFX', 1)
end)