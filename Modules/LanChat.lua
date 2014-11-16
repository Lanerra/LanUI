local F, C, G = unpack(select(2, ...))

local LanChat = CreateFrame('Frame', 'LanChat')
G.Chat.Chat = LanChat
for i = 1, NUM_CHAT_WINDOWS do
	G.Chat['ChatFrame'..i] = _G['ChatFrame'..i]
end

local _G = _G

_G.CHAT_FRAME_TAB_SELECTED_MOUSEOVER_ALPHA = 1.0
_G.CHAT_FRAME_TAB_SELECTED_NOMOUSE_ALPHA = 1.0     -- set to 0 if u want to hide the tabs when no mouse is over them or the chat
    
_G.CHAT_FRAME_TAB_NORMAL_MOUSEOVER_ALPHA = 1.0
_G.CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA = 1.0       -- set to 0 if u want to hide the tabs when no mouse is over them or the chat
    
_G.CHAT_FRAME_FADE_OUT_TIME = 0.5
_G.CHAT_FRAME_FADE_TIME = 0.1

-- Spam cleanup!

function Spam(self, event, msg)
    if strfind(msg, 'You have unlearned') or strfind(msg,'You have learned a new spell:') or strfind(msg, 'You have learned a new ability:') or strfind(msg, 'Your pet has unlearned') then
       return true
    end
end

ChatFrame_AddMessageEventFilter('CHAT_MSG_SYSTEM', Spam)

local SpamCheck = CreateFrame('Frame', nil)
SpamCheck:RegisterEvent('PLAYER_ENTERING_WORLD')
SpamCheck:SetScript('OnEvent', function()
    local text, accessID, lineID, extraData, keeper
    for i = 1, ChatFrame1:GetNumMessages(0) do
        text, accessID, lineID, extraData = ChatFrame1:GetMessageInfo(i)

        if strfind(text, 'Lan') then
            keeper = tostring(text)
            break
        end
    end
    
    ChatFrame1:SetHeight(C.Chat.ChatHeight)
    ChatFrame3:SetHeight(C.Chat.ChatHeight)

    ChatFrame1:RemoveMessagesByAccessID(0)
    ChatFrame1:AddMessage(keeper, nil, nil, nil, lineID, nil, accessID, extraData)
    SpamCheck:UnregisterEvent('PLAYER_ENTERING_WORLD')
end)

-- Skin chat bubbles
local BubbleHook = CreateFrame('Frame')

local function StyleBubble(frame)
	local Scale = UIParent:GetScale()

	for i = 1, frame:GetNumRegions() do
		local region = select(i, frame:GetRegions())
		if region:GetObjectType() == 'Texture' then
			region:SetTexture(nil)
		elseif region:GetObjectType() == 'FontString' then
			region:SetFont(C.Media.Font, 13)
			region:SetShadowOffset(Scale, -Scale)
            region:SetDrawLayer('OVERLAY')
            
            frame:SetTemplate()
            region:SetParent(frame.backdrop)
		end
	end

	--frame:SetTemplate()
end

local function isChatBubble(frame)
    for i = 1, frame:GetNumRegions() do
        local region = select(i, frame:GetRegions())
        if (region.GetTexture and region:GetTexture() and type(region:GetTexture() == "string") and strlower(region:GetTexture()) == [[interface\tooltips\chatbubble-background]]) then
            return true
        end
	end

    return false
end

local last = 0
local numKids = 0

BubbleHook:SetScript('OnUpdate', function(self, elapsed)
	last = last + elapsed
	if last > .1 then
		last = 0
		local newNumKids = WorldFrame:GetNumChildren()
		if newNumKids ~= numKids then
			for i = numKids + 1, newNumKids do
				local frame = select(i, WorldFrame:GetChildren())

				if isChatBubble(frame) then
					StyleBubble(frame)
				end
			end
			numKids = newNumKids
		end
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

CURRENCY_GAINED = '+ |cffffffff%s|r'
CURRENCY_GAINED_MULTIPLE = '+ |cffffffff%s|r x|cffffffff%d|r'

ChatTypeInfo['CHANNEL'].sticky = 1
ChatTypeInfo['GUILD'].sticky = 1
ChatTypeInfo['OFFICER'].sticky = 1
ChatTypeInfo['PARTY'].sticky = 1
ChatTypeInfo['RAID'].sticky = 1
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
				ChatFrame1EditBox:SetBackdropColor(1/10, 1/10, 1/10, 0.5)
                SetTexture(ChatFrame1EditBox, 'white')
			else 
				ChatFrame1EditBox:SetBeautyBorderColor(ChatTypeInfo[type..id].r, ChatTypeInfo[type..id].g, ChatTypeInfo[type..id].b)
				ChatFrame1EditBox:SetBackdropColor(ChatTypeInfo[type..id].r/10, ChatTypeInfo[type..id].g/10, ChatTypeInfo[type..id].b/10, 0.75)
                SetTexture(ChatFrame1EditBox, 'white')
			end
		elseif (type == 'SAY') then
            ChatFrame1EditBox:SetBeautyBorderColor(1, 1, 1)
            ChatFrame1EditBox:SetBackdropColor(0, 0, 0, 0.5)
            SetTexture(ChatFrame1EditBox, 'default')
        else
			ChatFrame1EditBox:SetBeautyBorderColor(ChatTypeInfo[type].r, ChatTypeInfo[type].g, ChatTypeInfo[type].b)
            SetTexture(ChatFrame1EditBox, 'white')
		end
	else
		ChatFrame1EditBox:SetBeautyBorderColor(1, 1, 1)
		ChatFrame1EditBox:SetBackdropColor(0, 0, 0, 0.5)
        SetTexture(ChatFrame1EditBox, 'default')
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

-- Fix positioning of CombatLogQuickButtonFrame to align better to our Chatframe
ChatFrame2:SetScript('OnShow', function(self)
    CombatLogQuickButtonFrame_Custom:ClearAllPoints()
    CombatLogQuickButtonFrame_Custom:SetPoint('BOTTOMLEFT', ChatFrame2, 'TOPLEFT', -2, 0)
    CombatLogQuickButtonFrame_Custom:SetPoint('BOTTOMRIGHT', ChatFrame2, 'TOPRIGHT', 2, 0)
end)

-- Fix Chat windows
for i = 1, NUM_CHAT_WINDOWS do
    local dummy = F.Dummy
    
    local eb = _G['ChatFrame'..i..'EditBox']
    eb:Hide()
    eb:HookScript('OnEnterPressed', function(s) s:Hide() end)
    
    local chat = _G['ChatFrame'..i]
    chat:SetShadowOffset(1, -1)
    chat:SetClampedToScreen(false)
    
    chat:SetClampRectInsets(0, 0, 0, 0)
    chat:SetMinResize(150, 25)

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
    
    _G['ChatFrame'..i..'ButtonFrame']:Kill()
    
    local tabText = _G['ChatFrame'..i..'TabText']
    tabText:SetFont(C.Media.Font, 12)
    tabText:SetShadowOffset(0, 0)   -- (1, -1)
    tabText:SetJustifyH('CENTER')
    tabText:SetPoint('CENTER', 0, 5)
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
    
    tab:StripTextures()
    
    local p1, frame, p2, x, y = tab:GetPoint()
    tab:SetPoint(p1, frame, p2, x, y + 1)
   
    tab:SkinTab()

    -- Hide some of those unwanted textures

    local resizeHandle = _G['ChatFrame'..i..'ResizeButton']
    resizeHandle:SetAlpha(0)
    
    ChatFrameMenuButton:Hide()
    ChatFrameMenuButton.Show = ChatFrameMenuButton.Hide
    
    local frames = {
		'ChatFrame1Background',
        'ChatFrame1TopLeftTexture',
        'ChatFrame1BottomLeftTexture',
        'ChatFrame1TopRightTexture',
        'ChatFrame1BottomRightTexture',
        'ChatFrame1LeftTexture',
        'ChatFrame1RightTexture',
        'ChatFrame1BottomTexture',
        'ChatFrame1TopTexture',
        'ChatFrame2Background',
        'ChatFrame2TopLeftTexture',
        'ChatFrame2BottomLeftTexture',
        'ChatFrame2TopRightTexture',
        'ChatFrame2BottomRightTexture',
        'ChatFrame2LeftTexture',
        'ChatFrame2RightTexture',
        'ChatFrame2BottomTexture',
        'ChatFrame2TopTexture',
        'ChatFrame3Background',
        'ChatFrame3TopLeftTexture',
        'ChatFrame3BottomLeftTexture',
        'ChatFrame3TopRightTexture',
        'ChatFrame3BottomRightTexture',
        'ChatFrame3LeftTexture',
        'ChatFrame3RightTexture',
        'ChatFrame3BottomTexture',
        'ChatFrame3TopTexture',
	}
	
	for _, frame in pairs(frames) do
		_G[frame]:Kill()
	end
    
    chat:SetFrameStrata('LOW')
    _G['ChatFrame'..i..'Background']:Kill()
    
	local chatframe = _G[("ChatFrame%d"):format(i)]
    chatframe:SetFading(0)
    
    local x = CreateFrame('Frame', _G['ChatHolder'..i], chat)
    x:SetPoint('TOPLEFT', chat, -5, 5)
    x:SetPoint('BOTTOMRIGHT', chat, 5, -7)
    x:SetSize(425, C.Chat.ChatHeight)
    x:SetFrameStrata('BACKGROUND')
    x:SetTemplate()
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

for i = 1, BNToastFrame:GetNumRegions() do
	if i ~= 10 then
		local region = select(i, BNToastFrame:GetRegions())
		if region:GetObjectType() == 'Texture' then
			region:SetTexture(nil)
		end
	end
end

BNToastFrame:SetTemplate()

BNToastFrame:HookScript('OnShow', function(self)
    BNToastFrame:ClearAllPoints()
    BNToastFrame:SetPoint('BOTTOMLEFT', ChatFrame1EditBox, 'TOPLEFT', 0, 15)
end)

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
    ChatFrame1Tab.ClearAllPoints = F.Dummy
    ChatFrame1Tab:SetPoint('TOPLEFT', ChatFrame1, 'BOTTOMLEFT', -5, -7)
    ChatFrame1Tab.SetPoint = F.Dummy

    ChatFrame3Tab:ClearAllPoints()
    ChatFrame3Tab.ClearAllPoints = F.Dummy
    ChatFrame3Tab:SetPoint('TOPRIGHT', ChatFrame3, 'BOTTOMRIGHT', 5, -7)
    ChatFrame3Tab.SetPoint = F.Dummy
    FCF_SavePositionAndDimensions(DEFAULT_CHAT_FRAME)
    
    ChatFrame1Tab:SetAlpha(1)
    ChatFrame1Tab.SetAlpha = F.Dummy
    ChatFrame2Tab:SetAlpha(1)
    ChatFrame2Tab.SetAlpha = F.Dummy
    ChatFrame3Tab:SetAlpha(1)
    ChatFrame3Tab.SetAlpha = F.Dummy
    
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

if C.Chat.CombatMinimize then
    F.RegisterEvent('PLAYER_REGEN_DISABLED', function()
        ChatFrame1:SetHeight(50)
        ChatFrame3:SetHeight(50)
    end)
    
    F.RegisterEvent('PLAYER_REGEN_ENABLED', function()
        ChatFrame1:SetHeight(C.Chat.ChatHeight)
        ChatFrame3:SetHeight(C.Chat.ChatHeight)
    end)
end

local function RemoveCurrentRealmName(self, event, msg, author, ...)
	local realmName = GetRealmName()

	if msg:find("-" .. realmName) then
		return false, gsub(msg, "%-"..realmName, ""), author, ...
	end
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", RemoveCurrentRealmName)