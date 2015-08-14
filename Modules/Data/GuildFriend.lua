local F, C, G = unpack(select(2, ...))

local cfg = C.Minimap

if (not cfg.Tab.Show) then
    return
end

-- Locals

-- Universal locals

local tthead, ttsubh, ttoff = {r=0.4, g=0.78, b=1}, {r=0.75, g=0.9, b=1}, {r=.3,g=1,b=.3}
local activezone, inactivezone = {r=0.3, g=1.0, b=0.3}, {r=0.65, g=0.65, b=0.65}

local class = F.MyClass
local select = select
local tostring = tostring
local ceil = math.ceil
local modf = math.modf
local sort = table.sort
local format = string.format

-- Guild Locals

local guildInfoString = "%s"
local guildInfoString2 = "%s: %d/%d"
local guildMotDString = "  %s |cffaaaaaa- |cffffffff%s"
local levelNameString = "|cff%02x%02x%02x%d|r |cff%02x%02x%02x%s|r %s"
local levelNameStatusString = "|cff%02x%02x%02x%d|r %s %s"
local nameRankString = "%s |cff999999-|cffffffff %s"
local noteString = "  '%s'"
local officerNoteString = "  o: '%s'"
local guildTable, guildMotD = {}, ""
local totalGuildOnline = 0

-- Friend Locals

local levelNameString = "|cff%02x%02x%02x%d|r |cff%02x%02x%02x%s|r"
local clientLevelNameString = "%s (|cff%02x%02x%02x%d|r |cff%02x%02x%02x%s|r%s) |cff%02x%02x%02x%s|r"
local levelNameClassString = "|cff%02x%02x%02x%d|r %s%s%s"
local battleNetString = "B.NET"
local wowString = "WoW"
local totalOnlineString = 'Online: ' .. "%s/%s"

local statusTable = { "|cffff0000[AFK]|r", "|cffff0000[DND]|r", "" }
local groupedTable = { "|cffaaaaaa*|r", "" } 
local friendTable, BNTable = {}, {}
local totalFriendOnline, BNTotalOnline = 0, 0

-- Performance Locals

local entry, total
local addonTable = {}

-- Icons

local guildIcon = '|TInterface\\GossipFrame\\TabardGossipIcon:13|t'
local friendIcon = '|TInterface\\FriendsFrame\\PlusManz-BattleNet:13|t'
local performanceIcon = '|TInterface\\AddOns\\LanUI\\Media\\texturePerformance:10|t'

-- Pretty colors

local gradientColor = {
    0, 1, 0,
    1, 1, 0,
    1, 0, 0
}

-- Functions to be called later

local function GetTableIndex(table, fieldIndex, value)
	for k,v in ipairs(table) do
		if v[fieldIndex] == value then return k end
	end
	return -1
end

-- Menu handler

local menuFrame = CreateFrame('Frame', 'ContactDropDownMenu', UIParent, 'UIDropDownMenuTemplate')
local menuList = {
    {
        text = OPTIONS_MENU,
        isTitle = true,
        notCheckable = true
    },
    {
        text = INVITE,
        hasArrow = true,
        notCheckable = true,
    },
    {
        text = CHAT_MSG_WHISPER_INFORM,
        hasArrow = true,
        notCheckable = true,
    }
}

local function inviteClick(self, arg1, arg2, checked)
	menuFrame:Hide()
	if type(arg1) ~= 'number' then
		InviteUnit(arg1)
	else
		BNInviteFriend(arg1);
	end
end

local function whisperClick(self,name,bnet)
	menuFrame:Hide()
	if bnet then
		ChatFrame_SendSmartTell(name)
	else
		SetItemRef( "player:"..name, ("|Hplayer:%1$s|h[%1$s]|h"):format(name), "LeftButton" )
	end
end

local function FormatMemoryValue(i)
    if (i > 1024) then
        return format('%.2f |cffffffffMB|r', i/1024)
    else
        return format('%.2f |cffffffffkB|r', i)
    end
end

local function ColorGradient(perc, ...)
    --[[if (perc > 1) then
        local r, g, b = select(select('#', ...) - 2, ...) return r, g, b
    elseif (perc < 0) then
        local r, g, b = ... return r, g, b
    end

    local num = select('#', ...) / 3

    local segment, relperc = modf(perc*(num-1))
    local r1, g1, b1, r2, g2, b2 = select((segment*3)+1, ...)

    return r1 + (r2-r1)*relperc, g1 + (g2-g1)*relperc, b1 + (b2-b1)*relperc]]
	return
end

local function RGBGradient(num)
    --local r, g, b = ColorGradient(num, unpack(gradientColor))
    --return r, g, b
	return
end

-- Create the tab frame

local f = CreateFrame('Frame', nil, Minimap)
f:SetFrameStrata('BACKGROUND')
f:SetFrameLevel(Minimap:GetFrameLevel() - 1)
f:Height(30)
f:SetAlpha(cfg.Tab.AlphaNoMouseover)
f:SetTemplate()
f.parent = Minimap

-- The guild button

f.Left = CreateFrame('Button', nil, f)
f.Left:RegisterForClicks('anyup')
f.Left:RegisterEvent('PLAYER_ENTERING_WORLD')
f.Left:RegisterEvent('PLAYER_GUILD_UPDATE')
f.Left:RegisterEvent('GUILD_ROSTER_SHOW')
f.Left:RegisterEvent('GUILD_ROSTER_UPDATE')
f.Left:RegisterEvent('GUILD_MOTD')

f.Left.Text = f.Left:CreateFontString(nil, 'BACKGROUND')
f.Left.Text:FontTemplate(C.Media.Font, 12)
f.Left.Text:SetShadowColor(0, 0, 0)
f.Left.Text:SetShadowOffset(1, -1)
f.Left:SetAllPoints(f.Left.Text)

-- The performance button

f.Right = CreateFrame('Button', nil, f)
f.Right:RegisterEvent('MODIFIER_STATE_CHANGED')

f.Right.Text = f.Right:CreateFontString(nil, 'BACKGROUND')
f.Right.Text:FontTemplate(C.Media.Font, 12)
f.Right.Text:SetShadowColor(0, 0, 0)
f.Right.Text:SetShadowOffset(1, -1)
f.Right.Text:SetText(performanceIcon..select(3, GetNetStats()))
f.Right:SetAllPoints(f.Right.Text)

local last = 0
f.Right:SetScript('OnUpdate', function(_, elapsed)
    last = last + elapsed

    if (last > 5) then
        f.Right.Text:SetText(performanceIcon..select(3, GetNetStats()))
        last = 0
    end
end)

-- The friend button

f.Center = CreateFrame('Button', nil, f)
f.Center:RegisterForClicks('anyup')
f.Center:RegisterEvent('BN_FRIEND_ACCOUNT_ONLINE')
f.Center:RegisterEvent('BN_FRIEND_ACCOUNT_OFFLINE')
f.Center:RegisterEvent('BN_FRIEND_INFO_CHANGED')
f.Center:RegisterEvent('BN_FRIEND_TOON_ONLINE')
f.Center:RegisterEvent('BN_FRIEND_TOON_OFFLINE')
f.Center:RegisterEvent('BN_TOON_NAME_UPDATED')
f.Center:RegisterEvent('FRIENDLIST_UPDATE')
f.Center:RegisterEvent('PLAYER_ENTERING_WORLD')

f.Center.Text = f.Center:CreateFontString(nil, 'BACKGROUND')
f.Center.Text:FontTemplate(C.Media.Font, 12)
f.Center.Text:SetShadowColor(0, 0, 0)
f.Center.Text:SetShadowOffset(1, -1)
f.Center:SetAllPoints(f.Center.Text)
f.Center.Text:SetPoint('TOPLEFT', f.Left, 'TOPRIGHT', 12, 0)
f.Center.Text:SetPoint('TOPRIGHT', f.Right, 'TOPLEFT', -12, 0)

-- Setup the animations of the datatext drawer

local function HideTab()
    GameTooltip:Hide()

    if (cfg.Tab.ShowAlways) then
        return
    end

    securecall('UIFrameFadeOut', f.Left, 0.15, f.Left:GetAlpha(), 0)
    securecall('UIFrameFadeOut', f.Right, 0.15, f.Right:GetAlpha(), 0)
    securecall('UIFrameFadeOut', f.Center, 0.15, f.Center:GetAlpha(), 0)
    securecall('UIFrameFadeOut', f, 0.15, f:GetAlpha(), cfg.Tab.AlphaNoMouseover)
end

local function ShowTab()
    securecall('UIFrameFadeIn', f.Left, 0.15, f.Left:GetAlpha(), 1)
    securecall('UIFrameFadeIn', f.Right, 0.15, f.Right:GetAlpha(), 1)
    securecall('UIFrameFadeIn', f.Center, 0.15, f.Center:GetAlpha(), 1)
    securecall('UIFrameFadeIn', f, 0.15, f:GetAlpha(), cfg.Tab.AlphaMouseover)
end

if (cfg.Tab.ShowBelowMinimap) then
    f.Left.Text:SetPoint('BOTTOMLEFT', f, 6, 5)
    f.Right.Text:SetPoint('BOTTOMRIGHT', f, -6, 5)

    if (cfg.Tab.ShowAlways) then
        ShowTab()

        f:SetPoint('LEFT', Minimap, 'BOTTOMLEFT', 10, -6)
        f:SetPoint('RIGHT', Minimap, 'BOTTOMRIGHT', -10, -6)
    else
        f:SetPoint('LEFT', Minimap, 'BOTTOMLEFT', 10, 9)
        f:SetPoint('RIGHT', Minimap, 'BOTTOMRIGHT', -10, 9)
    end
else
    f.Left.Text:SetPoint('TOPLEFT', f, 6, -5)
    f.Right.Text:SetPoint('TOPRIGHT', f, -6, -5)

    if (cfg.Tab.ShowAlways) then
        ShowTab()

        f:SetPoint('LEFT', Minimap, 'TOPLEFT', 10, 6)
        f:SetPoint('RIGHT', Minimap, 'TOPRIGHT', -10, 6)
    else
        f:SetPoint('LEFT', Minimap, 'TOPLEFT', 10, -9)
        f:SetPoint('RIGHT', Minimap, 'TOPRIGHT', -10, -9)
    end
end

local function SlideFrame(self, t)
    self.pos = self.pos + t * self.speed
    self:SetPoint(self.point, self.parent, self.point, 0, self.pos or 0)

    if (self.pos * self.mod >= self.limit * self.mod) then
        self:SetPoint(self.point, self.parent, self.point, 0, self.limit or 0)
        self.pos = self.limit
        self:SetScript('OnUpdate', nil)

        if (self.finish_hide) then
            self:Hide()
        end

        if (self.finish_function) then
            self:finish_function()
        end
    end
end

if (cfg.Tab.ShowBelowMinimap) then
    f.point = 'BOTTOM'
    f.pos = -6
else
    f.point = 'TOP'
    f.pos = 6
end

local function SlideUp()
    f.mod = 1
    f.limit = cfg.Tab.ShowBelowMinimap and -6 or 22
    f.speed = 200
    f:SetScript('OnUpdate', SlideFrame)
end

local function SlideDown()
    f.mod = -1
    f.limit = cfg.Tab.ShowBelowMinimap and -22 or 6
    f.speed = -200
    f:SetScript('OnUpdate', SlideFrame)
end

-- Performance datatext

local function AddonMem()
    total = 0
    collectgarbage()
    UpdateAddOnMemoryUsage()
    wipe(addonTable)

    for i = 1, GetNumAddOns() do
        if (IsAddOnLoaded(i)) then
            local memory = GetAddOnMemoryUsage(i)
            total = total + memory

            entry = {
                name = select(2, GetAddOnInfo(i)),
                memory = GetAddOnMemoryUsage(i)
            }

            tinsert(addonTable, entry)

            if (IsShiftKeyDown()) then
                sort(addonTable, function(a, b)
                    return a.memory > b.memory
                end)
            end
        end
    end
end

local function ShowMemoryTip(self)
    GameTooltip:ClearLines()
    GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMLEFT')

    AddonMem()

    GameTooltip:AddLine(COMBAT_MISC_INFO)
    GameTooltip:AddLine(' ')

    local _, _, lagHome, lagWorld = GetNetStats()
    GameTooltip:AddLine('|cffffffffHome:|r '..format('%d ms', lagHome), RGBGradient(select(3, GetNetStats()) / 100))
    GameTooltip:AddLine('|cffffffff'..CHANNEL_CATEGORY_WORLD..':|r '..format('%d ms', lagWorld), RGBGradient(select(4, GetNetStats()) / 100))

    GameTooltip:AddLine(' ')

    for _, table in pairs(addonTable) do
        GameTooltip:AddDoubleLine(table.name, FormatMemoryValue(table.memory), 1, 1, 1, RGBGradient(table.memory / 800))
    end

    GameTooltip:AddLine(' ')
    GameTooltip:AddDoubleLine(ALL, FormatMemoryValue(total), nil, nil, nil, RGBGradient(total / (1024*10)))

    if (SHOW_NEWBIE_TIPS == '1') then
        GameTooltip:AddLine(' ')
        GameTooltip:AddLine(NEWBIE_TOOLTIP_MEMORY, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1)
    end

    GameTooltip:Show()
end

local function InfoOnEvent(self)
    if (IsShiftKeyDown()) then
        if (self:IsMouseOver() and not DropDownList1:IsShown()) then
            GameTooltip:Hide()
            ShowMemoryTip(self)
        end
    else
        if (self:IsMouseOver() and not DropDownList1:IsShown()) then
            GameTooltip:Hide()
            ShowMemoryTip(self)
        end
    end
end

-- Guild datatext

local function BuildGuildTable()
	totalGuildOnline = 0
	wipe(guildTable)
	local _, name, rank, level, zone, note, officernote, connected, status, class, isMobile
	
    for i = 1, GetNumGuildMembers() do
		name, rank, _, level, _, zone, note, officernote, connected, status, class, _, _, isMobile = GetGuildRosterInfo(i)
		
        name = string.gsub(name, "-.*", "")
        
		if status == 1 then
			status = "|cffff0000["..AFK.."]|r"
		elseif status == 2 then
			status = "|cffff0000["..DND.."]|r" 
		else
			status = ""
		end
		
		guildTable[i] = { name, rank, level, zone, note, officernote, connected, status, class, isMobile }
		
        if connected then
            totalGuildOnline = totalGuildOnline + 1
        end
	end
    
	table.sort(guildTable, function(a, b)
		if a and b then
			return a[1] < b[1]
		end
	end)
end

local function UpdateGuildMessage()
	guildMotD = GetGuildRosterMOTD()
end

local function GuildUpdate(self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
        
		if IsInGuild() and not GuildFrame then
            LoadAddOn("Blizzard_GuildUI")
        end
	end
	
	if IsInGuild() then
		GuildRoster() -- 5.4 Fix
		totalGuildOnline = select(3, GetNumGuildMembers())
        
		f.Left.Text:SetFormattedText(format('%s|cffffffff%d|r ', guildIcon, (totalGuildOnline == 1 and 0) or totalGuildOnline))
	else
		f.Left.Text:SetText(guildIcon..' -')
    end
end

local function ToggleGuildFrame()
	if IsInGuild() then 
		if not GuildFrame then
            GuildFrame_LoadUI()
        end
        
		GuildFrame_Toggle()
	else 
		if not LookingForGuildFrame then
            LookingForGuildFrame_LoadUI()
        end
        
		if LookingForGuildFrame then
			LookingForGuildFrame_Toggle()
		end
	end
end

f.Left:SetScript("OnMouseUp", function(self, btn)
	if btn ~= "RightButton" or not IsInGuild() then
        return
    end
	
	GameTooltip:Hide()

	local classc, levelc, grouped
	local menuCountWhispers = 0
	local menuCountInvites = 0

	menuList[2].menuList = {}
	menuList[3].menuList = {}

	for i = 1, #guildTable do
		if (guildTable[i][7] and guildTable[i][1] ~= F.MyName) then
			local classc, levelc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[guildTable[i][9]], GetQuestDifficultyColor(guildTable[i][3])

			if UnitInParty(guildTable[i][1]) or UnitInRaid(guildTable[i][1]) then
				grouped = "|cffaaaaaa*|r"
			else
				grouped = ""
				if not guildTable[i][10] then
					menuCountInvites = menuCountInvites + 1
					menuList[2].menuList[menuCountInvites] = {text = string.format(levelNameString, levelc.r*255,levelc.g*255,levelc.b*255, guildTable[i][3], classc.r*255,classc.g*255,classc.b*255, guildTable[i][1], ""), arg1 = guildTable[i][1],notCheckable=true, func = inviteClick}
				end
			end
            
			menuCountWhispers = menuCountWhispers + 1
			menuList[3].menuList[menuCountWhispers] = {text = string.format(levelNameString, levelc.r*255,levelc.g*255,levelc.b*255, guildTable[i][3], classc.r*255,classc.g*255,classc.b*255, guildTable[i][1], grouped), arg1 = guildTable[i][1],notCheckable=true, func = whisperClick}
		end
	end

	EasyMenu(menuList, menuFrame, "cursor", 0, 0, "MENU", 2)
end)

f.Left:SetScript("OnMouseDown", function(self, btn)
	if btn ~= "LeftButton" then
        return
    end
	
    ToggleGuildFrame()
end)

f.Left:SetScript("OnEnter", function(self)
	if InCombatLockdown() or not IsInGuild() then return end
	
	GuildRoster()
	UpdateGuildMessage()
	BuildGuildTable()
		
	local name, rank, level, zone, note, officernote, connected, status, class, isMobile
	local zonec, classc, levelc
	local online = totalGuildOnline
	local GuildInfo = GetGuildInfo('player')
		
	local anchor, panel, xoff, yoff = 'ANCHOR_TOP', f.Left, 0, 5
	GameTooltip:SetOwner(panel, anchor, xoff, yoff)
	GameTooltip:ClearLines()
	if GuildInfo then
		GameTooltip:AddDoubleLine(string.format(guildInfoString, GuildInfo), string.format(guildInfoString2, 'Guild:', online, #guildTable),tthead.r,tthead.g,tthead.b,tthead.r,tthead.g,tthead.b)
	end
	
	if guildMotD ~= "" then GameTooltip:AddLine(' ') GameTooltip:AddLine(string.format(guildMotDString, GUILD_MOTD, guildMotD), ttsubh.r, ttsubh.g, ttsubh.b, 1) end
	
	local col = F.RGBToHex(ttsubh.r, ttsubh.g, ttsubh.b)
	GameTooltip:AddLine' '
		
	local _, _, standingID, barMin, barMax, barValue = GetGuildFactionInfo()
	if standingID ~= 8 then -- Not Max Rep
		barMax = barMax - barMin
		barValue = barValue - barMin
		barMin = 0
		GameTooltip:AddLine(string.format("%s:|r |cFFFFFFFF%s/%s (%s%%)",col..COMBAT_FACTION_CHANGE, F.ShortValue(barValue), F.ShortValue(barMax), math.ceil((barValue / barMax) * 100)))
	end
	
	if online > 1 then
		GameTooltip:AddLine(' ')
		for i = 1, #guildTable do
			if online <= 1 then
				if online > 1 then GameTooltip:AddLine(format("+ %d More...", online - modules.Guild.maxguild),ttsubh.r,ttsubh.g,ttsubh.b) end
				break
			end

			name, rank, level, zone, note, officernote, connected, status, class, isMobile = unpack(guildTable[i])
			if connected then
				if GetRealZoneText() == zone then zonec = activezone else zonec = inactivezone end
				classc, levelc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class], GetQuestDifficultyColor(level)
				
				if isMobile then zone = "" end
				
				if IsShiftKeyDown() then
					GameTooltip:AddDoubleLine(string.format(nameRankString, name, rank), zone, classc.r, classc.g, classc.b, zonec.r, zonec.g, zonec.b)
					if note ~= "" then GameTooltip:AddLine(string.format(noteString, note), ttsubh.r, ttsubh.g, ttsubh.b, 1) end
					if officernote ~= "" then GameTooltip:AddLine(string.format(officerNoteString, officernote), ttoff.r, ttoff.g, ttoff.b ,1) end
				else
					GameTooltip:AddDoubleLine(string.format(levelNameStatusString, levelc.r*255, levelc.g*255, levelc.b*255, level, name, status), zone, classc.r,classc.g,classc.b, zonec.r,zonec.g,zonec.b)
				end
			end
		end
	end
	GameTooltip:Show()
    
    if (not cfg.Tab.ShowAlways) then
        ShowTab()
        if (cfg.Tab.ShowBelowMinimap) then
            SlideDown()
        else
            SlideUp()
        end
    end
end)

f.Left:RegisterEvent("GUILD_ROSTER_SHOW")
f.Left:RegisterEvent("PLAYER_ENTERING_WORLD")
f.Left:RegisterEvent("GUILD_ROSTER_UPDATE")
f.Left:RegisterEvent("PLAYER_GUILD_UPDATE")

f.Left:SetScript("OnEvent", GuildUpdate)

-- Friend Datatext

local function BuildFriendTable(total)
	totalFriendOnline = 0
	wipe(friendTable)
	local name, level, class, area, connected, status, note
    
	for i = 1, total do
		name, level, class, area, connected, status, note = GetFriendInfo(i)
		
        for k,v in pairs(LOCALIZED_CLASS_NAMES_MALE) do
            if class == v then
                class = k
            end
        end
		
		if status == "<"..AFK..">" then
			status = "|cffff0000[AFK]|r"
		elseif status == "<"..DND..">" then
			status = "|cffff0000[DND]|r"
		end
		
		friendTable[i] = { name, level, class, area, connected, status, note }
		
        if connected then
            totalFriendOnline = totalFriendOnline + 1
        end
	end
end

local function UpdateFriendTable(total)
	totalFriendOnline = 0
	local name, level, class, area, connected, status, note
    
	for i = 1, #friendTable do
		name, level, class, area, connected, status, note = GetFriendInfo(i)
		for k,v in pairs(LOCALIZED_CLASS_NAMES_MALE) do
            if class == v then
                class = k
            end
        end
		
		-- get the correct index in our table		
		local index = GetTableIndex(friendTable, 1, name)
        
		-- we cannot find a friend in our table, so rebuild it
		if index == -1 then
			BuildFriendTable(total)
			break
		end
        
		-- update on-line status for all members
		friendTable[index][5] = connected
		
        -- update information only for on-line members
		if connected then
			friendTable[index][2] = level
			friendTable[index][3] = class
			friendTable[index][4] = area
			friendTable[index][6] = status
			friendTable[index][7] = note
			totalFriendOnline = totalFriendOnline + 1
		end
	end
end

local function BuildBNTable(total)
	BNTotalOnline = 0
	wipe(BNTable)
	
	for i = 1, total do
		local presenceID, presenceName, battleTag, isBattleTagPresence, toonName, toonID, client, isOnline, lastOnline, isAFK, isDND, messageText, noteText, isRIDFriend, messageTime, canSoR = BNGetFriendInfo(i)
		local hasFocus, _, _, realmName, realmID, faction, race, class, guild, zoneName, level, gameText = BNGetToonInfo(toonID or presenceID)

		for k,v in pairs(LOCALIZED_CLASS_NAMES_MALE) do if class == v then class = k end end
		
		BNTable[i] = { presenceID, presenceName, battleTag, toonName, toonID, client, isOnline, isAFK, isDND, noteText, realmName, faction, race, class, zoneName, level }
		if isOnline then
            BNTotalOnline = BNTotalOnline + 1
        end
	end
end

local function UpdateBNTable(total)
	BNTotalOnline = 0
    
	for i = 1, #BNTable do
		-- get guild roster information
		local presenceID, presenceName, battleTag, isBattleTagPresence, toonName, toonID, client, isOnline, lastOnline, isAFK, isDND, messageText, noteText, isRIDFriend, messageTime, canSoR = BNGetFriendInfo(i)
		local hasFocus, _, _, realmName, realmID, faction, race, class, guild, zoneName, level, gameText = BNGetToonInfo(toonID or presenceID)
		
		for k,v in pairs(LOCALIZED_CLASS_NAMES_MALE) do
            if class == v then
                class = k
            end
        end
		
		-- get the correct index in our table		
		local index = GetTableIndex(BNTable, 1, presenceID)
        
		-- we cannot find a BN member in our table, so rebuild it
		if index == -1 then
			BuildBNTable(total)
			return
		end
        
		-- update on-line status for all members
		BNTable[index][7] = isOnline
        
		-- update information only for on-line members
		if isOnline then
			BNTable[index][2] = presenceName
			BNTable[index][3] = battleTag
			BNTable[index][4] = toonName
			BNTable[index][5] = toonID
			BNTable[index][6] = client
			BNTable[index][8] = isAFK
			BNTable[index][9] = isDND
			BNTable[index][10] = noteText
			BNTable[index][11] = realmName
			BNTable[index][12] = faction
			BNTable[index][13] = race
			BNTable[index][14] = class
			BNTable[index][15] = zoneName
			BNTable[index][16] = level
			
			BNTotalOnline = BNTotalOnline + 1
		end
	end
end

f.Center:SetScript("OnMouseUp", function(self, btn)
	if btn ~= "RightButton" then
        return
    end
	
	GameTooltip:Hide()
	
	local menuCountWhispers = 0
	local menuCountInvites = 0
	local classc, levelc
	
	menuList[2].menuList = {}
	menuList[3].menuList = {}
	
	if totalFriendOnline > 0 then
		for i = 1, #friendTable do
			if (friendTable[i][5]) then
				menuCountInvites = menuCountInvites + 1
				menuCountWhispers = menuCountWhispers + 1

				classc, levelc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[friendTable[i][3]], GetQuestDifficultyColor(friendTable[i][2])
				if classc == nil then classc = GetQuestDifficultyColor(friendTable[i][2]) end

				menuList[2].menuList[menuCountInvites] = {text = format(levelNameString,levelc.r*255,levelc.g*255,levelc.b*255,friendTable[i][2],classc.r*255,classc.g*255,classc.b*255,friendTable[i][1]), arg1 = friendTable[i][1],notCheckable=true, func = inviteClick}
				menuList[3].menuList[menuCountWhispers] = {text = format(levelNameString,levelc.r*255,levelc.g*255,levelc.b*255,friendTable[i][2],classc.r*255,classc.g*255,classc.b*255,friendTable[i][1]), arg1 = friendTable[i][1],notCheckable=true, func = whisperClick}
			end
		end
	end
	
	if BNTotalOnline > 0 then
		local realID, grouped
		for i = 1, #BNTable do
			if (BNTable[i][7]) then
				realID = BNTable[i][2]
				menuCountWhispers = menuCountWhispers + 1
				menuList[3].menuList[menuCountWhispers] = {text = realID, arg1 = realID, arg2 = true, notCheckable=true, func = whisperClick}

				if BNTable[i][6] == wowString and UnitFactionGroup("player") == BNTable[i][12] then
					classc, levelc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[BNTable[i][14]], GetQuestDifficultyColor(BNTable[i][16])
					if classc == nil then classc = GetQuestDifficultyColor(BNTable[i][16]) end

					if UnitInParty(BNTable[i][4]) or UnitInRaid(BNTable[i][4]) then grouped = 1 else grouped = 2 end
					menuCountInvites = menuCountInvites + 1
					menuList[2].menuList[menuCountInvites] = {text = format(levelNameString,levelc.r*255,levelc.g*255,levelc.b*255,BNTable[i][16],classc.r*255,classc.g*255,classc.b*255,BNTable[i][4]), arg1 = BNTable[i][5],notCheckable=true, func = inviteClick}
				end
			end
		end
	end

	EasyMenu(menuList, menuFrame, "cursor", 0, 0, "MENU", 2)
end)

local function FriendUpdate(self, event)
	if event == "BN_FRIEND_INFO_CHANGED" or "BN_FRIEND_ACCOUNT_ONLINE" or "BN_FRIEND_ACCOUNT_OFFLINE" or "BN_TOON_NAME_UPDATED"
			or "BN_FRIEND_TOON_ONLINE" or "BN_FRIEND_TOON_OFFLINE" or "PLAYER_ENTERING_WORLD" then
		local BNTotal = BNGetNumFriends()
        
		if BNTotal == #BNTable then
			UpdateBNTable(BNTotal)
		else
			BuildBNTable(BNTotal)
		end
	end
	
	if event == "FRIENDLIST_UPDATE" or "PLAYER_ENTERING_WORLD" then
		local total = GetNumFriends()
        
		if total == #friendTable then
			UpdateFriendTable(total)
		else
			BuildFriendTable(total)
		end
	end

	f.Center.Text:SetFormattedText(format('%s|cffffffff%d|r ', friendIcon, totalFriendOnline + BNTotalOnline))
end

f.Center:SetScript("OnMouseDown", function(self, btn) if btn == "LeftButton" then ToggleFriendsFrame() end end)
f.Center:SetScript("OnEnter", function(self)
	if InCombatLockdown() then return end
		
	local totalonline = totalFriendOnline + BNTotalOnline
	local totalfriends = #friendTable + #BNTable
	local zonec, classc, levelc, realmc, grouped
	if totalonline > 0 then
		local anchor, panel, xoff, yoff = 'ANCHOR_TOP', f.Center, 0, 5
		GameTooltip:SetOwner(panel, anchor, xoff, yoff)
		GameTooltip:ClearLines()
		GameTooltip:AddDoubleLine('Friends list:', format(totalOnlineString, totalonline, totalfriends),tthead.r,tthead.g,tthead.b,tthead.r,tthead.g,tthead.b)
		if totalFriendOnline > 0 then
			GameTooltip:AddLine(' ')
			GameTooltip:AddLine(wowString)
			for i = 1, #friendTable do
				if friendTable[i][5] then
					if GetRealZoneText() == friendTable[i][4] then
                        zonec = activezone
                    else
                        zonec = inactivezone
                    end
                    
					classc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[friendTable[i][3]]
                    
					if classc == nil then
                        classc = GetQuestDifficultyColor(friendTable[i][2])
                    end
					
					if friendTable[i][2] ~= '' then
						levelc = GetQuestDifficultyColor(friendTable[i][2])
					else
						levelc = RAID_CLASS_COLORS["PRIEST"]
						classc = RAID_CLASS_COLORS["PRIEST"]
					end
					
					if UnitInParty(friendTable[i][1]) or UnitInRaid(friendTable[i][1]) then
                        grouped = 1
                    else
                        grouped = 2
                    end
                    
					GameTooltip:AddDoubleLine(format(levelNameClassString,levelc.r*255,levelc.g*255,levelc.b*255,friendTable[i][2],friendTable[i][1],groupedTable[grouped]," "..friendTable[i][6]),friendTable[i][4],classc.r,classc.g,classc.b,zonec.r,zonec.g,zonec.b)
				end
			end
		end
        
		if BNTotalOnline > 0 then
			GameTooltip:AddLine(' ')
			GameTooltip:AddLine(battleNetString)

			local status = 0
			for i = 1, #BNTable do
				if BNTable[i][7] then
					if BNTable[i][6] == wowString then
						if (BNTable[i][8] == true) then status = 1 elseif (BNTable[i][9] == true) then status = 2 else status = 3 end
	
						--classc, levelc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[BNTable[i][14, GetQuestDifficultyColor(BNTable[i][16])
						--if classc == nil then classc = GetQuestDifficultyColor(BNTable[i][16]) end]]
						
						classc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[BNTable[i][14]]
						
						if classc == nil then
							classc = RAID_CLASS_COLORS['PRIEST']
						end
						
						if BNTable[i][16] ~= '' then
							levelc = GetQuestDifficultyColor(BNTable[i][16])
						else
							levelc = RAID_CLASS_COLORS['PRIEST']
						end
						
						if UnitInParty(BNTable[i][4]) or UnitInRaid(BNTable[i][4]) then grouped = 1 else grouped = 2 end
						GameTooltip:AddDoubleLine(format(clientLevelNameString, BNTable[i][6],levelc.r*255,levelc.g*255,levelc.b*255,BNTable[i][16],classc.r*255,classc.g*255,classc.b*255,BNTable[i][4],groupedTable[grouped], 255, 0, 0, statusTable[status]),BNTable[i][2],238,238,238,238,238,238)
						if IsShiftKeyDown() then
							if GetRealZoneText() == BNTable[i][15] then zonec = activezone else zonec = inactivezone end
							if GetRealmName() == BNTable[i][11] then realmc = activezone else realmc = inactivezone end
							GameTooltip:AddDoubleLine("  "..BNTable[i][15], BNTable[i][11], zonec.r, zonec.g, zonec.b, realmc.r, realmc.g, realmc.b)
						end
					else
						GameTooltip:AddDoubleLine("|cffeeeeee"..BNTable[i][6].." ("..BNTable[i][4]..")|r", "|cffeeeeee"..BNTable[i][2].."|r")
					end
				end
			end
		end
		GameTooltip:Show()
	else 
		GameTooltip:Hide() 
	end
    
    if (not cfg.Tab.ShowAlways) then
        ShowTab()
        if (cfg.Tab.ShowBelowMinimap) then
            SlideDown()
        else
            SlideUp()
        end
    end
end)

f.Center:RegisterEvent("BN_FRIEND_ACCOUNT_ONLINE")
f.Center:RegisterEvent("BN_FRIEND_ACCOUNT_OFFLINE")
f.Center:RegisterEvent("BN_FRIEND_INFO_CHANGED")
f.Center:RegisterEvent("BN_FRIEND_TOON_ONLINE")
f.Center:RegisterEvent("BN_FRIEND_TOON_OFFLINE")
f.Center:RegisterEvent("BN_TOON_NAME_UPDATED")
f.Center:RegisterEvent("FRIENDLIST_UPDATE")
f.Center:RegisterEvent("PLAYER_ENTERING_WORLD")

f.Center:SetScript("OnEvent", FriendUpdate)

-- the 'OnEnter' functions

f:SetScript('OnEnter', function()
    if (not cfg.Tab.ShowAlways) then
        ShowTab()
        if (cfg.Tab.ShowBelowMinimap) then
            SlideDown()
        else
            SlideUp()
        end
    end
end)

f.Right:SetScript('OnEnter', function(self)
    ShowMemoryTip(self)

    if (not cfg.Tab.ShowAlways) then
        ShowTab()
        if (cfg.Tab.ShowBelowMinimap) then
            SlideDown()
        else
            SlideUp()
        end
    end
end)

-- the 'OnLeave' functions

for _, leaveFrame in pairs({
    f,
    f.Right,
    f.Left,
    f.Center,
}) do
    leaveFrame:SetScript('OnLeave', function()
        HideTab()

        if (not cfg.Tab.ShowAlways) then
            if (cfg.Tab.ShowBelowMinimap) then
                SlideUp()
            else
                SlideDown()
            end
        end
        
        GameTooltip:Hide()
    end)
end
    
-- the Minimap scripts

if (not cfg.Tab.ShowAlways) then
    Minimap:HookScript('OnEnter',function()
        ShowTab()

        if (cfg.Tab.ShowBelowMinimap) then
            SlideDown()
        else
            SlideUp()
        end
    end)

    Minimap:HookScript('OnLeave', function()
        HideTab()

        if (cfg.Tab.ShowBelowMinimap) then
            SlideUp()
        else
            SlideDown()
        end
    end)
end