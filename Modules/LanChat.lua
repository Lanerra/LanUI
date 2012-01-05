CHAT_FRAME_TAB_SELECTED_MOUSEOVER_ALPHA = 1.0
CHAT_FRAME_TAB_SELECTED_NOMOUSE_ALPHA = 1.0     -- set to 0 if u want to hide the tabs when no mouse is over them or the chat
    
CHAT_FRAME_TAB_NORMAL_MOUSEOVER_ALPHA = 1.0
CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA = 1.0       -- set to 0 if u want to hide the tabs when no mouse is over them or the chat
    
CHAT_FRAME_FADE_OUT_TIME = 0.5
CHAT_FRAME_FADE_TIME = 0.1

function Spam(self, event, arg1)
    if strfind(arg1, 'You have unlearned') or strfind(arg1,'You have learned a new spell:') or strfind(arg1, 'You have learned a new ability:') or strfind(arg1, 'Your pet has unlearned') then
       return true
    end
    
    if strfind(arg1, 'Welcome to World of Warcraft!') or strfind(arg1,'We care about player security and encourage you to') or strfind(arg1, 'visit http://us.battle.net/security/ for helpful information') or strfind(arg1, 'and tips.') then
        return true
    end
    
    if strfind(arg1, 'AucAdvanced: Util:AutoMagic loaded!') or strfind(arg1, 'AucAdvanced: Util:EasyBuyout loaded!') or strfind(arg1, 'AucAdvanced: Util:GlypherPost loaded!') or strfind(arg1, 'Auctioneer: Util:ScanFinish loaded!') or strfind(arg1, 'AucAdvanced: Util:ScanStart loaded!') then
        return true
    end
end

ChatFrame_AddMessageEventFilter('CHAT_MSG_SYSTEM', Spam)

for i = 1, NUM_CHAT_WINDOWS do
    local cf = _G['ChatFrame' .. i]
    cf:SetFading(nil)
end

local events = {
    CHAT_MSG_SAY = 'chatBubbles', 
    CHAT_MSG_YELL = 'chatBubbles',
    CHAT_MSG_PARTY = 'chatBubblesParty', 
    CHAT_MSG_PARTY_LEADER = 'chatBubblesParty',
    CHAT_MSG_MONSTER_SAY = 'chatBubbles', 
    CHAT_MSG_MONSTER_YELL = 'chatBubbles', 
    CHAT_MSG_MONSTER_PARTY = 'chatBubblesParty',
}

local function SkinFrame(frame)
    for i = 1, select('#', frame:GetRegions()) do
        local region = select(i, frame:GetRegions())
        if (region:GetObjectType() == 'FontString') then
            frame.text = region
        else
            region:Hide()
        end
    end

    frame.text:SetFontObject('GameFontHighlight')
    frame.text:SetJustifyH('LEFT')

	frame:ClearAllPoints()
	frame:SetPoint('TOPLEFT', frame.text, -10, 25)
	frame:SetPoint('BOTTOMRIGHT', frame.text, 10, -10)
	frame:SetBackdrop({
        bgFile = LanConfig.Media.Backdrop,
		insets = {top = 1, left = 1, bottom = 1, right = 1},
	})
	frame:SetBackdropColor(unpack(LanConfig.Media.BackdropColor))
    
	frame:CreateBeautyBorder(12, 1, 1, 1)
    frame.sender = frame:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
    frame.sender:SetPoint('BOTTOMLEFT', frame.text, 'TOPLEFT', 0, 4)
    frame.sender:SetJustifyH('LEFT')

    frame:HookScript('OnHide', function()
		frame.inUse = false
	end)
end

local function UpdateFrame(frame, guid, name)
    if (not frame.text) then 
        SkinFrame(frame) 
    end
    frame.inUse = true

    local class
    if (guid ~= nil and guid ~= '') then
        _, class, _, _, _, _ = GetPlayerInfoByGUID(guid)
    end

    if (name) then
        local color = RAID_CLASS_COLORS[class] or { r = 0.5, g = 0.5, b = 0.5 }
        frame.sender:SetText(('|cFF%2x%2x%2x%s|r'):format(color.r * 255, color.g * 255, color.b * 255, name))
        if frame.text:GetWidth() < frame.sender:GetWidth() then
            frame.text:SetWidth(frame.sender:GetWidth())
        end
    end
end

local function FindFrame(msg)
    for i = 1, WorldFrame:GetNumChildren() do
        local frame = select(i, WorldFrame:GetChildren())
        if (not frame:GetName() and not frame.inUse) then
            for i = 1, select('#', frame:GetRegions()) do
                local region = select(i, frame:GetRegions())
                if region:GetObjectType() == 'FontString' and region:GetText() == msg then
                    return frame
                end
            end
        end
    end
end

local f = CreateFrame('Frame')
for event, cvar in pairs(events) do 
    f:RegisterEvent(event) 
end

f:SetScript('OnEvent', function(self, event, msg, sender, _, _, _, _, _, _, _, _, _, guid)
    if (GetCVarBool(events[event])) then
        f.elapsed = 0
        f:SetScript('OnUpdate', function(self, elapsed)
            self.elapsed = self.elapsed + elapsed
            local frame = FindFrame(msg)
            if (frame or self.elapsed > 0.3) then
                f:SetScript('OnUpdate', nil)
                if (frame) then 
                    UpdateFrame(frame, guid, sender) 
                end
            end
        end)
    end
end)

CHAT_FONT_HEIGHTS = {
    [1] = 8,
    [2] = 9,
    [3] = 10,
    [4] = 11,
    [5] = 12,
    [6] = 13,
    [7] = 14,
    [8] = 15,
    [9] = 16,
    [10] = 17,
    [11] = 18,
    [12] = 19,
    [13] = 20,
}

CHAT_FLAG_AFK = '[AFK] '
CHAT_FLAG_DND = '[DND] '
CHAT_FLAG_GM = '[GM] '

CHAT_SAY_GET = '%s:\32'
CHAT_YELL_GET = '%s:\32'

CHAT_WHISPER_GET = '[from] %s:\32'
CHAT_WHISPER_INFORM_GET = '[to] %s:\32'

CHAT_BN_WHISPER_GET = '[from] %s:\32'
CHAT_BN_WHISPER_INFORM_GET = '[to] %s:\32'

CHAT_GUILD_GET = '[|Hchannel:Guild|hG|h] %s:\32'
CHAT_OFFICER_GET = '[|Hchannel:o|hO|h] %s:\32'

CHAT_PARTY_GET = '[|Hchannel:party|hP|h] %s:\32'
CHAT_PARTY_LEADER_GET = '[|Hchannel:party|hPL|h] %s:\32'
CHAT_PARTY_GUIDE_GET = '[|Hchannel:party|hDG|h] %s:\32'
CHAT_MONSTER_PARTY_GET = '[|Hchannel:raid|hR|h] %s:\32'

CHAT_RAID_GET = '[|Hchannel:raid|hR|h] %s:\32'
CHAT_RAID_WARNING_GET = '[RW!] %s:\32'
CHAT_RAID_LEADER_GET = '[|Hchannel:raid|hL|h] %s:\32'

CHAT_BATTLEGROUND_GET = '[|Hchannel:Battleground|hBG|h] %s:\32'
CHAT_BATTLEGROUND_LEADER_GET = '[|Hchannel:Battleground|hBL|h] %s:\32'

CHAT_YOU_CHANGED_NOTICE_BN = '# |Hchannel:%d|h%s|h'
CHAT_YOU_JOINED_NOTICE_BN = '+ |Hchannel:%d|h%s|h'
CHAT_YOU_LEFT_NOTICE_BN = '- |Hchannel:%d|h%s|h'
CHAT_SUSPENDED_NOTICE_BN = '- |Hchannel:%d|h%s|h'

ChatTypeInfo['CHANNEL'].sticky = 1
ChatTypeInfo['GUILD'].sticky = 1
ChatTypeInfo['OFFICER'].sticky = 1
ChatTypeInfo['PARTY'].sticky = 1
ChatTypeInfo['RAID'].sticky = 1
ChatTypeInfo['BATTLEGROUND'].sticky = 1
ChatTypeInfo['BATTLEGROUND_LEADER'].sticky = 1
ChatTypeInfo['WHISPER'].sticky = 0

local AddMessage = ChatFrame1.AddMessage

function FCF_AddMessage(self, text, ...)
    if (type(text) == 'string') then
                
        text = text:gsub('(|HBNplayer.-|h)%[(.-)%]|h', '%1%2|h')
        text = text:gsub('(|Hplayer.-|h)%[(.-)%]|h', '%1%2|h')
                
        text = text:gsub('%[(%d+)%. (.+)%].+(|Hplayer.+)', '[|Hchannel:channel|h%1|h] %3') 
    end
    return AddMessage(self, text, ...)
end

-- Modify all editboxes        
for i = 1, NUM_CHAT_WINDOWS do
    _G['ChatFrame'..i..'EditBox']:SetAltArrowKeyMode(false)
    _G['ChatFrame'..i..'EditBox']:SetBackdrop({
        bgFile = 'Interface\\Buttons\\WHITE8x8',
        insets = { 
            left = 3, 
            right = 3, 
            top = 2, 
            bottom = 2 
        },
    })
    
    _G['ChatFrame'..i..'EditBox']:SetBackdropColor(0, 0, 0, 0.5)
    
    for k = 6, 11 do
        select(k, _G['ChatFrame'..i..'EditBox']:GetRegions()):SetTexture(nil)
    end
    
    ChatFrame1EditBox:ClearAllPoints() 
    ChatFrame1EditBox:SetPoint('BOTTOMLEFT', ChatFrame1, 'TOPLEFT', -7, 4) 
    ChatFrame1EditBox:SetPoint('BOTTOMRIGHT', ChatFrame1, 'TOPRIGHT', 7, 4)  
    
    ChatFrame2EditBox:ClearAllPoints() 
    ChatFrame2EditBox:SetPoint('BOTTOMLEFT', ChatFrame2, 'TOPLEFT', -7, 26) 
    ChatFrame2EditBox:SetPoint('BOTTOMRIGHT', ChatFrame2, 'TOPRIGHT', 7, 26) 
    
    _G['ChatFrame'..i..'EditBox']:CreateBeautyBorder(12, 1, 1, 1, -2, -1, -2, -1, -2, -1, -2, -1)
end

hooksecurefunc('ChatEdit_UpdateHeader', function(editbox)
	if ACTIVE_CHAT_EDIT_BOX then
		local type = editbox:GetAttribute('chatType')
		if ( type == 'CHANNEL' ) then
			local id = GetChannelName(editbox:GetAttribute('channelTarget'))
			if id == 0 then	
				ChatFrame1EditBox:SetBeautyBorderColor(1, 1, 1)
				ChatFrame1EditBox:SetBackdropColor(1/10, 1/10, 1/10, 0.75)
			else 
				ChatFrame1EditBox:SetBeautyBorderColor(ChatTypeInfo[type..id].r, ChatTypeInfo[type..id].g, ChatTypeInfo[type..id].b)
				ChatFrame1EditBox:SetBackdropColor(ChatTypeInfo[type..id].r/10, ChatTypeInfo[type..id].g/10, ChatTypeInfo[type..id].b/10, 0.75)
			end
		else
			ChatFrame1EditBox:SetBeautyBorderColor(ChatTypeInfo[type].r, ChatTypeInfo[type].g, ChatTypeInfo[type].b)
--~ 			ChatFrame1EditBox:SetBackdropColor(ChatTypeInfo[type].r/10, ChatTypeInfo[type].g/10, ChatTypeInfo[type].b/10, 0.75)
		end
	else
		ChatFrame1EditBox:SetBeautyBorderColor(1, 1, 1)
		ChatFrame1EditBox:SetBackdropColor(0, 0, 0, 0.75)
	end
end)

function FCF_FlashTab(self)
	local tabFlash = _G[self:GetName()..'TabFlash']
	if (not self.isDocked or (self == SELECTED_DOCK_FRAME) or UIFrameIsFlashing(tabFlash)) then
		return
	end
	tabFlash:Show()
	UIFrameFlash(tabFlash, 0.25, 0.25, 5, nil, 0.5, 0.5)
end

-- Frame up our Chatframes
ChatFrame1:CreateBeautyBorder(12, 5, 5, 5, 5, 5, 5, 5, 5, 6, 5, 6)
ChatFrame2:CreateBeautyBorder(12, 5, 5, 5, 5, 27, 5, 27, 5, 6, 5, 6)
ChatFrame3:CreateBeautyBorder(12, 5, 5, 5, 5, 5, 5, 5, 5, 6, 5, 6)

-- Fix positioning of CombatLogQuickButtonFrame to align better to our Chatframe
ChatFrame2:SetScript('OnShow', function(self)
    CombatLogQuickButtonFrame_Custom:ClearAllPoints()
    CombatLogQuickButtonFrame_Custom:SetPoint('BOTTOMLEFT', ChatFrame2, 'TOPLEFT', -2, 0)
    CombatLogQuickButtonFrame_Custom:SetPoint('BOTTOMRIGHT', ChatFrame2, 'TOPRIGHT', 2, 0)
end)

-- Fix Chat windows
for i = 1, NUM_CHAT_WINDOWS do
    local dummy = function() end
    
    local eb = _G['ChatFrame'..i..'EditBox']
    eb:Hide()
    eb:HookScript('OnEnterPressed', function(s) s:Hide() end)
    
    local chat = _G['ChatFrame'..i]
    chat:SetShadowOffset(1, -1)
    chat:SetClampedToScreen(false)
    
    chat:SetClampRectInsets(0, 0, 0, 0)
    chat:SetMaxResize(UIParent:GetWidth(), UIParent:GetHeight())
    chat:SetMinResize(150, 25)

    chat:SetBackdrop({
        bgFile = 'Interface\\Buttons\\WHITE8x8',
        insets = { 
            left = -2, 
            right = -2, 
            top = -1, 
            bottom = -3 
        },
    })
    chat:SetBackdropColor(0, 0, 0, 0.5)
    
	-- Enable mousewheel scrolling in all chatframes
    chat:EnableMouseWheel(true)
    chat:SetScript('OnMouseWheel', function(self, direction)
    if (direction > 0) then
            if (IsShiftKeyDown()) then
                self:ScrollToTop()
            else
                self:ScrollUp()
            end
        elseif (direction < 0)  then
            if (IsShiftKeyDown()) then
                self:ScrollToBottom()
            else
                self:ScrollDown()
            end
        end
    end)
    
    if (i ~= 2) then
        chat.AddMessage = FCF_AddMessage
    end
    
    LanFunc.Kill(_G['ChatFrame'..i..'ButtonFrame'])
    
    local function SkinTab(tab)
        if (not tab) then
            return
        end

        tab.backdrop = CreateFrame('Frame', nil, tab)
        
        LanFunc.Skin(tab.backdrop, 12, 1)
        
        tab.backdrop:SetFrameStrata('BACKGROUND')
        tab.backdrop:SetFrameLevel(_G['ChatFrame'..i]:GetFrameLevel() - 1)
        tab.backdrop:SetPoint('TOPLEFT')
        tab.backdrop:SetPoint('BOTTOMRIGHT')

        -- always set tab text centered
        local name = tab:GetName()
        _G[name..'Text']:ClearAllPoints()
        _G[name..'Text']:SetPoint('CENTER')
        _G[name..'Text'].SetPoint = LanFunc.dummy
    end
    
    local tabText = _G['ChatFrame'..i..'TabText']
    tabText:SetFont('Fonts\\ARIALN.ttf', 14, 'OUTLINE')
    tabText:SetShadowOffset(0, 0)   -- (1, -1)
    tabText:SetJustifyH('CENTER')
    tabText:SetWidth(60)

    local tabGlow = _G['ChatFrame'..i..'TabGlow']
    
    tabGlow.Show = function()
        tabText:SetTextColor(1, 0, 1)
    end
    
    tabGlow.Hide = function()
        tabText:SetTextColor(1, 1, 1)
    end
    
    local tab = _G['ChatFrame'..i..'Tab']
    tab:SetScript('OnEnter', function()
        tabText:SetTextColor(1, 0, 1)
    end)
    
    tab:SetScript('OnLeave', function()
        local r, g, b
        local hasNofication = tabGlow:IsShown()

        if (_G['ChatFrame'..i] == SELECTED_CHAT_FRAME) then
            r, g, b = 0, 0.75, 1
        elseif (hasNofication) then
            r, g, b = 1, 0, 1
        else
            r, g, b = 1, 1, 1
        end

        tabText:SetTextColor(r, g, b)
    end)
    
    LanFunc.StripTextures(tab)
    SkinTab(tab)
    
    local p1, frame, p2, x, y = tab:GetPoint()
    tab:SetPoint(p1, frame, p2, x, y + 1)

    -- Hide some of those unwanted textures

    local resizeHandle = _G['ChatFrame'..i..'ResizeButton']
    resizeHandle:SetAlpha(0)
    
    ChatFrameMenuButton:Hide()
    ChatFrameMenuButton.Show = ChatFrameMenuButton.Hide
end

-- tab text colors for the tabs
    
hooksecurefunc('FCFTab_UpdateColors', function(self, selected)
	if (selected) then
		self:GetFontString():SetTextColor(0, 0.75, 1)
	else
		self:GetFontString():SetTextColor(1, 1, 1)
	end
end)
    
    -- Move the minimize button (ChatFrames 2-10)
    
for i = 2, NUM_CHAT_WINDOWS do
    local chat = _G['ChatFrame'..i]

    local chatMinimize = _G['ChatFrame'..i..'ButtonFrameMinimizeButton']
    chatMinimize:ClearAllPoints()
    chatMinimize:SetPoint('TOPRIGHT', chat, 'TOPLEFT', -2, 0)
end

BNToastFrame:CreateBeautyBorder(12, 1, 1, 1)

BNToastFrame:ClearAllPoints()
BNToastFrame:SetPoint('BOTTOMLEFT', ChatFrame1, 'TOPLEFT', -5, 5)
BNToastFrame.SetPoint = LanFunc.dummy
BNToastFrame.SetAllPoints = LanFunc.dummy
BNToastFrame.ClearAllPoints = LanFunc.dummy
BNToastFrameCloseButton:Hide()

BNToastFrame:SetBackdrop({
    bgFile = LanConfig.Media.Backdrop,
    insets = { 
        left = 1, 
        right = 1, 
        top = 1, 
        bottom = 1 
    },
})
BNToastFrame:SetBackdropColor(unpack(LanConfig.Media.BackdropColor))
BNToastFrame.SetBackdrop = LanFunc.dummy
BNToastFrame.SetBackdropColor = LanFunc.dummy
BNToastFrameTopLine:SetFont(LanConfig.Media.Font, 12, nil)
BNToastFrameBottomLine:SetFont(LanConfig.Media.Font, 12, nil)

FriendsMicroButton:Hide()
FriendsMicroButton.Show = FriendsMicroButton.Hide

GeneralDockManagerOverflowButton:SetScript('OnShow', GeneralDockManagerOverflowButton.Hide)
GeneralDockManagerOverflowButton:Hide()

-- Skin those tabs!
local x = CreateFrame('Frame')
x:RegisterEvent('PLAYER_LOGIN')
x:SetScript('OnEvent', function()
	ChatFrame1Tab:SetHeight(24)
    ChatFrame2Tab:SetHeight(24)
    ChatFrame3Tab:SetHeight(24)

    ChatFrame1Tab:ClearAllPoints()
    ChatFrame1Tab.ClearAllPoints = LanFunc.dummy
    ChatFrame1Tab:SetPoint('TOPLEFT', ChatFrame1, 'BOTTOMLEFT', -5, -7)
    ChatFrame1Tab.SetPoint = LanFunc.dummy

    ChatFrame3Tab:ClearAllPoints()
    ChatFrame3Tab.ClearAllPoints = LanFunc.dummy
    ChatFrame3Tab:SetPoint('TOPRIGHT', ChatFrame3, 'BOTTOMRIGHT', 5, -7)
    ChatFrame3Tab.SetPoint = LanFunc.dummy
    FCF_SavePositionAndDimensions(DEFAULT_CHAT_FRAME)
    
    ChatFrame1Tab:SetAlpha(1)
    ChatFrame1Tab.SetAlpha = LanFunc.dummy
    ChatFrame2Tab:SetAlpha(1)
    ChatFrame2Tab.SetAlpha = LanFunc.dummy
    ChatFrame3Tab:SetAlpha(1)
    ChatFrame3Tab.SetAlpha = LanFunc.dummy
    
    ChatFrame1EditBox:Hide()
    ChatFrame2Tab:Hide()
    ChatFrame2Tab.Hide = ChatFrame2Tab.Show
end)

-- Modify the GM ChatFrame
local f = CreateFrame('Frame')
f:RegisterEvent('ADDON_LOADED')
f:SetScript('OnEvent', function(_, event)
    if (event == 'ADDON_LOADED' and arg1 == 'Blizzard_GMChatUI') then
        GMChatFrame:EnableMouseWheel(true)
        GMChatFrame:SetScript('OnMouseWheel', ChatFrame1:GetScript('OnMouseWheel'))
        GMChatFrame:SetHeight(200)
        
        GMChatFrameUpButton:SetAlpha(0)
        GMChatFrameUpButton:EnableMouse(false)
        
        GMChatFrameDownButton:SetAlpha(0)
        GMChatFrameDownButton:EnableMouse(false)
        
        GMChatFrameBottomButton:SetAlpha(0)
        GMChatFrameBottomButton:EnableMouse(false)
    end
end)