_G["LootFrame"]:GetRegions():Hide()

local LootBG = CreateFrame('Frame', nil, _G["LootFrame"])
--LootBG:SetPoint('TOPLEFT', 0, 0)
--LootBG:SetPoint('RIGHT', 0, 0)
LootBG:SetPoint('TOPLEFT')
LootBG:SetPoint('RIGHT')
LootBG:SetFrameStrata("LOW")	
LootBG:SetBackdrop({
    bgFile = LanConfig.Media.Backdrop,
	insets = {top = 1, left = 1, bottom = 1, right = 1},
})
LootBG:SetBackdropColor(LanConfig.Media.BackdropColor)

--LootBG:CreateBeautyBorder(12, R, G, B, -4)
LootBG:CreateBeautyBorder(12, R, G, B, 1)

for i = 1, 4 do
    local text = _G['LootButton'..i..'Text']
	_G['LootButton'..i]:CreateBeautyBorder(12, R, G, B, 1)
    for _, font in pairs({
        text,
    }) do
       font:SetFont('Fonts\\ARIALN.ttf', 13, 'THINOUTLINE')
       font:SetTextColor(1, 1, 1)
	   font:SetWidth(170)
	   font:SetNonSpaceWrap(true)
    end
end

for i = 1, 4 do
    local count = _G['LootButton'..i..'Count']
    for _, font in pairs({
        count,
    }) do
        font:SetFont('Fonts\\ARIALN.ttf', 13, 'THINOUTLINE')
        font:SetTextColor(1, 1, 1)
    end
end

local f = CreateFrame("Frame")
f:RegisterEvent("CONFIRM_DISENCHANT_ROLL")
f:RegisterEvent("CONFIRM_LOOT_ROLL")
f:SetScript("OnEvent", function(self, event, id, rollType)
	for i=1,STATICPOPUP_NUMDIALOGS do
		local frame = _G["StaticPopup"..i]
		if frame.which == "CONFIRM_LOOT_ROLL" and frame.data == id and frame.data2 == rollType and frame:IsVisible() then StaticPopup_OnClick(frame, 1) end
	end
end)

StaticPopupDialogs["LOOT_BIND"].OnCancel = function(self, slot)
	if GetNumPartyMembers() == 0 and GetNumRaidMembers() == 0 then ConfirmLootSlot(slot) end
end

local TEST = false
UIParent:UnregisterEvent('START_LOOT_ROLL')
UIParent:UnregisterEvent('CANCEL_LOOT_ROLL')

local GFHCName, GFHCHeight = GameFontHighlightCenter:GetFont()
local frames, rolls, rolltypes, rollstrings = {}, {}, { [0] = PASS, [1] = NEED, [2] = GREED, [3] = ROLL_DISENCHANT }, { [(LOOT_ROLL_PASSED_AUTO):gsub('%%1$s', '(.+)'):gsub('%%2$s', '(.+)')] = 0, [(LOOT_ROLL_PASSED_AUTO_FEMALE):gsub('%%1$s', '(.+)'):gsub('%%2$s', '(.+)')] = 0, [(LOOT_ROLL_PASSED):gsub('%%s', '(.+)')] = 0, [(LOOT_ROLL_GREED):gsub('%%s', '(.+)')] = 2, [(LOOT_ROLL_NEED):gsub('%%s', '(.+)')] = 1, [(LOOT_ROLL_DISENCHANT):gsub('%%s', '(.+)')] = 3 }

local function OnUpdate(self, elapsed)
	if (self.rollID and not self.paused) then
		if (TEST) then
			self:SetValue(self.rollID)
			self.paused = 1
		else
			self:SetValue(GetLootRollTimeLeft(self.rollID))
		end
		
		if (GameTooltip:IsOwned(self)) then
			GameTooltip:SetLootRollItem(self.rollID)
			CursorUpdate(self)
		end
	end
end

local function OnClick(self)
	HandleModifiedItemClick(self.rollLink)
end

local function OnEvent(self, event, ...)
	local rollID = ...
	if ( self.rollID and self.rollID == rollID ) then
		self.paused = 1
		StaticPopup_Hide('CONFIRM_LOOT_ROLL', rollID)
		
		self:SetStatusBarColor(0.5, 0.5, 0.5)
		for i=0, #self.button, 1 do
			GroupLootFrame_DisableLootButton(self.button[i])
		end
		
		local fadeInfo = {}
		fadeInfo.mode = 'OUT'
		fadeInfo.timeToFade = 0.5
		fadeInfo.startAlpha = self:GetAlpha()
		fadeInfo.endAlpha = 0
		fadeInfo.finishedFunc = function()
			rolls[rollID] = nil
			self.rollID = nil
			self.paused = nil
			self:Hide()
		end
		UIFrameFade(self, fadeInfo)
	end
end

local function OnEnter(self)
	GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMLEFT')
	GameTooltip:SetLootRollItem(self.rollID)
	CursorUpdate(self)
end

local function OnLeave(self)
	GameTooltip:Hide()
	ResetCursor()
end

local function Button_OnClick(self)
	RollOnLoot(self:GetParent().rollID, self:GetID())
end

local backdrop = {
	bgFile = LanConfig.Media.Backdrop,
	insets = {top = -1, left = -1, bottom = -1, right = -1},
}

local function CreateRollFrame()
	local frame = CreateFrame('StatusBar', 'LanGroupLootBar'..(#frames+1), LanGroupLoot)
	frame.hasItem = 1
	frame:SetAlpha(0)
	frame:EnableMouse(1)
	frame:SetWidth(235)
	frame:SetHeight(29)
	
    frame:CreateBeautyBorder(12, 1, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3)
	
	if (#frames == 0) then
		frame:SetPoint('TOP')
	else
		frame:SetPoint('TOP', frames[#frames], 'BOTTOM', 0, -12)
	end
	
	frame:SetStatusBarTexture(LanConfig.Media.StatusBar)
	frame:SetScript('OnUpdate', OnUpdate)
	frame:SetScript('OnMouseUp', OnClick)
	frame:RegisterEvent('CANCEL_LOOT_ROLL')
	frame:SetScript('OnEvent', OnEvent)
	frame:SetScript('OnEnter', OnEnter)
	frame:SetScript('OnLeave', OnLeave)
	
	frame.background = frame:CreateTexture('$parentBackground', 'BORDER')
	frame.background:SetAllPoints()
	frame.background:SetTexture(LanConfig.Media.Backdrop)
	frame.background:SetVertexColor(unpack(LanConfig.Media.BackdropColor))
	
	frame.button = {}

	frame.button[0] = CreateFrame('Button', '$perentPassButton', frame)
	frame.button[0]:SetMotionScriptsWhileDisabled(true)
	frame.button[0]:SetID(0)
	frame.button[0]:SetWidth(21)
	frame.button[0]:SetHeight(21)
	frame.button[0]:SetNormalTexture('Interface\\Buttons\\UI-GroupLoot-Pass-Up')
	frame.button[0]:SetHighlightTexture('Interface\\Buttons\\UI-GroupLoot-Pass-Down')
	frame.button[0]:SetHighlightTexture('Interface\\Buttons\\UI-GroupLoot-Pass-Highlight')
	frame.button[0]:SetPoint('RIGHT', -5, 1)
	frame.button[0]:SetScript('OnClick', Button_OnClick)
	frame.button[0]:SetScript('OnEnter', Button_OnEnter)
	frame.button[0]:SetScript('OnLeave', OnLeave)

	frame.button[2] = CreateFrame('Button', '$perentGreedButton', frame)
	frame.button[2]:SetMotionScriptsWhileDisabled(true)
	frame.button[2]:SetID(2)
	frame.button[2]:SetWidth(23)
	frame.button[2]:SetHeight(23)
	frame.button[2]:SetNormalTexture('Interface\\Buttons\\UI-GroupLoot-Coin-Up')
	frame.button[2]:SetPushedTexture('Interface\\Buttons\\UI-GroupLoot-Coin-Down')
	frame.button[2]:SetHighlightTexture('Interface\\Buttons\\UI-GroupLoot-Coin-Highlight')
	frame.button[2]:SetPoint('RIGHT', frame.button[0], 'LEFT', -2, -4)
	frame.button[2]:SetScript('OnClick', Button_OnClick)
	frame.button[2]:SetScript('OnEnter', Button_OnEnter)
	frame.button[2]:SetScript('OnLeave', OnLeave)
	
	frame.button[1] = CreateFrame('Button', '$perentNeedButton', frame)
	frame.button[1]:SetMotionScriptsWhileDisabled(true)
	frame.button[1]:SetID(1)
	frame.button[1]:SetWidth(23)
	frame.button[1]:SetHeight(23)
	frame.button[1]:SetNormalTexture('Interface\\Buttons\\UI-GroupLoot-Dice-Up')
	frame.button[1]:SetPushedTexture('Interface\\Buttons\\UI-GroupLoot-Dice-Down')
	frame.button[1]:SetHighlightTexture('Interface\\Buttons\\UI-GroupLoot-Dice-Highlight')
	frame.button[1]:SetPoint('RIGHT', frame.button[2], 'LEFT', -2, 2)
	frame.button[1]:SetScript('OnClick', Button_OnClick)
	frame.button[1]:SetScript('OnEnter', Button_OnEnter)
	frame.button[1]:SetScript('OnLeave', OnLeave)

	frame.button[3] = CreateFrame('Button', '$perentDisenchantButton', frame)
	frame.button[3]:SetMotionScriptsWhileDisabled(true)
	frame.button[3]:SetID(3)
	frame.button[3]:SetWidth(23)
	frame.button[3]:SetHeight(23)
	frame.button[3]:SetNormalTexture('Interface\\Buttons\\UI-GroupLoot-DE-Up')
	frame.button[3]:SetPushedTexture('Interface\\Buttons\\UI-GroupLoot-DE-Down')
	frame.button[3]:SetHighlightTexture('Interface\\Buttons\\UI-GroupLoot-DE-Highlight')
	frame.button[3]:SetPoint('RIGHT', frame.button[1], 'LEFT', -2, 0)
	frame.button[3]:SetScript('OnClick', Button_OnClick)
	frame.button[3]:SetScript('OnEnter', Button_OnEnter)
	frame.button[3]:SetScript('OnLeave', OnLeave)
	
	frame.text = frame:CreateFontString('$perentText', 'ARTWORK', 'InvoiceTextFontNormal')
	frame.text:SetPoint('LEFT', 5, 0)
	frame.text:SetFont(GFHCName, GFHCHeight+1)
	frame.text:SetPoint('RIGHT', frame.button[3], 'LEFT')
    frame.text:SetShadowColor(0, 0, 0, 0.75)
    frame.text:SetShadowOffset(1, -1)

	local iconframe = CreateFrame('Frame', nil, frame)
    iconframe:SetHeight(31)
    iconframe:SetWidth(31)
	iconframe:ClearAllPoints()
	iconframe:SetBackdrop(backdrop)
	iconframe:SetBackdropColor(unpack(LanConfig.Media.BackdropColor))
	iconframe:SetPoint('RIGHT', frame, 'LEFT', -8, 0)
	
	iconframe:CreateBeautyBorder(12, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2)

	local icon = iconframe:CreateTexture('Frame', nil)
    icon:SetTexCoord(.08, .92, .08, .92)
	icon:SetPoint('TOPLEFT', iconframe, 'TOPLEFT', 1 , -1)
	icon:SetPoint('BOTTOMRIGHT', iconframe, 'BOTTOMRIGHT', -1, 1)
	frame.icon = icon
	
	table.insert(frames, frame)
	return frame
end

local function GetRollFrame()
	for _, frame in ipairs(frames) do
		if (not frame.rollID) then
			return frame
		end
	end

	return CreateRollFrame()
end

local function OnEvent(self, event, ...)
	if (event == 'CHAT_MSG_LOOT') then
		local msg = ...
        
		for string, type in pairs(rollstrings) do
			local _, _, player, item = string.find(msg, string)
			if (player and item) then
				local rollID
				for _, frame in ipairs(frames) do
					rollID = frame.rollID
					if (rollID and frame.rollLink == item) then
						rolls[rollID] = rolls[rollID] or {}
						rolls[rollID][type] = rolls[rollID][type] or {}
						rolls[rollID][type].count = (rolls[rollID][type].count or 0)+1
						
						return
					end
				end
			end
		end
        
		return
	end
	
	local rollID, rollTime = ...
	local texture, name, count, quality, bindOnPickUp, canNeed, canGreed, canDisenchant, reasonNeed, reasonGreed, reasonDisenchant, deSkillRequired = GetLootRollItemInfo(rollID)
	local color = ITEM_QUALITY_COLORS[quality]
	local frame = GetRollFrame()
	frame.rollID = rollID
	frame.rollTime = rollTime
	frame.rollLink = GetLootRollItemLink(rollID)
	frame:SetMinMaxValues(0, rollTime)
	frame:SetStatusBarColor(color.r, color.g, color.b, 1)
	frame.text:SetText(count > 1 and count..'x '..name or name)
	frame.icon:SetTexture(texture)

	if (canNeed) then
		GroupLootFrame_EnableLootButton(frame.button[1])
		frame.button[1].reason = nil
	else
		GroupLootFrame_DisableLootButton(frame.button[1])
		frame.button[1].reason = _G['LOOT_ROLL_INELIGIBLE_REASON'..reasonNeed]
	end
	
	if (canGreed) then
		GroupLootFrame_EnableLootButton(frame.button[2])
		frame.button[2].reason = nil
	else
		GroupLootFrame_DisableLootButton(frame.button[2])
		frame.button[2].reason = _G['LOOT_ROLL_INELIGIBLE_REASON'..reasonGreed]
	end
	
	if (canDisenchant) then
		GroupLootFrame_EnableLootButton(frame.button[3])
		frame.button[3].reason = nil
	else
		GroupLootFrame_DisableLootButton(frame.button[3])
		frame.button[3].reason = format(_G['LOOT_ROLL_INELIGIBLE_REASON'..reasonDisenchant], deSkillRequired)
	end
	
	local fadeInfo = {}
	fadeInfo.mode = 'IN'
	fadeInfo.timeToFade = 0.5
	fadeInfo.startAlpha = frame:GetAlpha()
	fadeInfo.endAlpha = 1
	UIFrameFade(frame, fadeInfo)
end

local frame = CreateFrame('Frame', 'LanGroupLoot', UIParent)
frame:SetWidth(280)
frame:SetHeight(25)
frame:SetPoint('TOP', 0, -300)
frame:RegisterEvent('START_LOOT_ROLL')
frame:RegisterEvent('CHAT_MSG_LOOT')
frame:SetScript('OnEvent', OnEvent)

if (TEST) then
	local color = 1
	function GetLootRollItemInfo(rollID)
		color = color+1
		return 'Interface\\Icons\\Spell_Fire_Burnout', 'Test-Roll '..rollID, 1, color, nil, nil, 1, nil, 5, nil, 4, 450
	end
	for i=1, 4, 1 do
		OnEvent(frame, 'START_LOOT_ROLL', i, 4)
	end
end