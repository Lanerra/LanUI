local _, LanQuest = ...

local dummy = LanFunc.dummy

-------------------
-- Setup WatchFrame
-------------------

local height = GetScreenHeight() / 1.6

local watchFrame = _G['WatchFrame']
watchFrame:SetHeight(height)
watchFrame:ClearAllPoints()	
watchFrame.ClearAllPoints = LanFunc.dummy
watchFrame:SetPoint('TOP', Minimap, 'BOTTOM', 0, -30)
watchFrame.SetPoint = LanFunc.dummy
watchFrame:SetScale(1.01)
LanFunc.Skin(watchFrame, 12, 1)

local watchHead = _G['WatchFrameHeader']
local p1, frame, p2, x, y = watchHead:GetPoint()
watchHead:SetPoint(p1, frame, p2, x + 6, y)

local p1, frame, p2, x, y = nil

local watchLines = _G['WatchFrameLines']
local p1, frame, p2, x, y = watchLines:GetPoint()
watchLines:SetPoint(p1, frame, p2, x + 6, y)

local watchHeadTitle = _G['WatchFrameTitle']
watchHeadTitle:SetFont('Fonts\\ARIALN.ttf', 15)
watchHeadTitle:SetTextColor(LanFunc.playerColor.r, LanFunc.playerColor.g, LanFunc.playerColor.b)

local collapseButton = _G['WatchFrameCollapseExpandButton']
collapseButton:ClearAllPoints()
collapseButton:SetPoint('TOPRIGHT', watchFrame, -6, -6)

collapseButton:HookScript('OnClick', function()
    if watchFrame.collapsed then
        watchFrame:SetHeight(25)
    else
        watchFrame:SetHeight(height)
    end
end)

---------------------
-- Quest modification
---------------------

LanQuest.eventFrame = CreateFrame('Frame')

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

function MostValuable ()
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

LanQuest.eventFrame:RegisterEvent('QUEST_DETAIL')
LanQuest.eventFrame:RegisterEvent('QUEST_COMPLETE')
LanQuest.eventFrame:RegisterEvent('QUEST_WATCH_UPDATE')
LanQuest.eventFrame:RegisterEvent('QUEST_ACCEPT_CONFIRM')
LanQuest.eventFrame:RegisterEvent('UNIT_QUEST_LOG_CHANGED')
LanQuest.eventFrame:SetScript('OnEvent', function(self, event, ...)
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
                    RaidNotice_AddMessage(RaidWarningFrame, string.format('%s Complete', description), ChatTypeInfo['SYSTEM'])
                    PlaySoundFile([[Sound\Creature\Peon\PeonBuildingComplete1.wav]])
                end
            else
                local _, _, itemName, numCurrent, numTotal = strfind(description, '(.*):%s*([%d]+)%s*/%s*([%d]+)')

                if numCurrent == numTotal then
                    RaidNotice_AddMessage(RaidWarningFrame, string.format('%s: Objective Complete', itemName), ChatTypeInfo['SYSTEM'])
                    PlaySoundFile([[Sound\Creature\Peon\PeonReady1.wav]])
                else
                    RaidNotice_AddMessage(RaidWarningFrame, string.format('%s: %s/%s', itemName, numCurrent, numTotal), ChatTypeInfo['SYSTEM'])
                end
            end
        end

        questIndex = nil

    end

    if (UnitLevel('player') == 85) then
--~         if event == 'QUEST_DETAIL' then
--~             AcceptQuest()
--~             CompleteQuest()
--~         elseif event == 'QUEST_COMPLETE' then
        if event == 'QUEST_COMPLETE' then
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

local tags = {Elite = '+', Group = 'G', Dungeon = 'D', Raid = 'R', PvP = 'P', Daily = '•', Heroic = 'H', Repeatable = '8'}

local function GetTaggedTitle(i)
    local name, level, tag, group, header, _, complete, daily = GetQuestLogTitle(i)
    if header or not name then return end

    if not group or group == 0 then
        group = nil
    end

    return string.format('[%s%s%s%s] %s', level, tag and tags[tag] or '', daily and tags.Daily or '',group or '', name), tag, daily, complete
end

local QuestLog_Update = function()
    for i, button in pairs(QuestLogScrollFrame.buttons) do
        local QuestIndex = button:GetID()
        local title, tag, daily, complete = GetTaggedTitle(QuestIndex)

        if title then
            button:SetText('  '..title)
        end

        if (tag or daily) and not complete then
            button.tag:SetText('')
        end

        QuestLogTitleButton_Resize(button)
    end
end

hooksecurefunc('QuestLog_Update', QuestLog_Update)
hooksecurefunc(QuestLogScrollFrame, 'update', QuestLog_Update)

-------------------------
-- Auto repair/Sell greys
-------------------------

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
            if GuildWealth then
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