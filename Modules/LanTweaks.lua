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

    if F.MyLevel ~= MAX_PLAYER_LEVEL_TABLE[GetExpansionLevel()] then
        if event == 'QUEST_DETAIL' then
            AcceptQuest()
            CompleteQuest()
        elseif event == 'QUEST_COMPLETE' then
--~         if event == 'QUEST_COMPLETE' then
            if GetNumQuestChoices() and GetNumQuestChoices() <= 1 then
                GetQuestReward(1)
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

local tags = {Elite = '+', Group = 'G', Dungeon = 'D', Raid = 'R', PvP = 'P', Daily = '�', Heroic = 'H', Repeatable = '8'}

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

-- Auto-DE/Greed
if C.Tweaks.AutoDEGreed == true then
    if F.Level ~= MAX_PLAYER_LEVEL_TABLE[GetExpansionLevel()] then return end
    
    local greed = CreateFrame("Frame")
    greed:RegisterEvent("START_LOOT_ROLL")
    greed:SetScript("OnEvent", function(self, event, id)
        local _, name, _, quality, BoP = GetLootRollItemInfo(id)
        if id and quality == 2 and not BoP then
            if RollOnLoot(id, 3) then
                RollOnLoot(id, 3)
            else
                RollOnLoot(id, 2)
            end
        end
    end)
    
    local de = CreateFrame("Frame")
    de:RegisterEvent("CONFIRM_DISENCHANT_ROLL")
    de:RegisterEvent("CONFIRM_LOOT_ROLL")
    de:RegisterEvent("LOOT_BIND_CONFIRM")
    de:SetScript("OnEvent", function(self, event, id)
        for i = 1, STATICPOPUP_NUMDIALOGS do
            local frame = _G["StaticPopup"..i]
            if (frame.which == "CONFIRM_LOOT_ROLL" or frame.which == "LOOT_BIND") and frame:IsVisible() then StaticPopup_OnClick(frame, 1) end
        end
    end)
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

        InboxFrame:HookScript('OnUpdate', UpdateInbox)

        SendMailMoneyGold:HookScript('OnTextChanged', MoneySubject)
        SendMailMoneySilver:HookScript('OnTextChanged', MoneySubject)
        SendMailMoneyCopper:HookScript('OnTextChanged', MoneySubject)

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