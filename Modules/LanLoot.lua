local F, C, G = unpack(select(2, ...))

local TEST = true

local iconsize = 32
local width = 200
local sq, ss, sn, st

local addon = CreateFrame('Button', 'LanLoot', UIParent)
addon:SetFrameStrata('HIGH')
addon:SetClampedToScreen(true)
addon:SetWidth(width)
addon:SetHeight(64)

addon.slots = {}

local OnEnter = function(self)
	local slot = self:GetID()
	if GetLootSlotType(slot) == LOOT_SLOT_ITEM then
		GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
		GameTooltip:SetLootItem(slot)
		CursorUpdate(self)
	end
end

local OnLeave = function(self)
	GameTooltip:Hide()
	ResetCursor()
end

local OnClick = function(self)
	if(IsModifiedClick()) then
		HandleModifiedItemClick(GetLootSlotLink(self:GetID()))
	else
		StaticPopup_Hide'CONFIRM_LOOT_DISTRIBUTION'
		ss = self:GetID()
		sq = self.quality
		sn = self.name:GetText()
		st = self.icon:GetTexture()

		LootFrame.selectedLootButton = self:GetName();
		LootFrame.selectedSlot = ss;
		LootFrame.selectedQuality = sq;
		LootFrame.selectedItemName = sn;
		LootFrame.selectedTexture = st;

		LootSlot(ss)
	end
end

local createSlot = function(id)
	local frame = CreateFrame('Button', 'LanSlot'..id, addon)
	frame:SetPoint('TOP', addon, 0, -((id-1)*(iconsize+1)))
	frame:SetPoint('RIGHT')
	frame:SetPoint('LEFT')
	frame:SetHeight(24)
	frame:SetFrameStrata('HIGH')
	frame:SetFrameLevel(20)
	frame:SetID(id)
	addon.slots[id] = frame

	local bg = CreateFrame('Frame', nil, frame)
	bg:SetPoint('TOPLEFT', frame, -1, 1)
	bg:SetPoint('BOTTOMRIGHT', frame, 1, -1)
	bg:SetFrameLevel(frame:GetFrameLevel()-1)
	bg:SetTemplate()
	frame.bg = bg

	frame:SetScript('OnClick', OnClick)
	frame:SetScript('OnEnter', OnEnter)
	frame:SetScript('OnLeave', OnLeave)

	local iconFrame = CreateFrame('Frame', nil, frame)
	iconFrame:SetHeight(iconsize)
	iconFrame:SetWidth(iconsize)
	iconFrame:SetFrameStrata('HIGH')
	iconFrame:SetFrameLevel(20)
	iconFrame:ClearAllPoints()
	iconFrame:SetPoint('RIGHT', frame, 'LEFT', -2, 0)

	local icon = iconFrame:CreateTexture(nil, 'ARTWORK')
	icon:SetTexCoord(.08, .92, .08, .92)
	icon:SetPoint('TOPLEFT', 1, -1)
	icon:SetPoint('BOTTOMRIGHT', -1, 1)
	frame.icon = icon
	
	local iconbg = CreateFrame('Frame', nil, iconFrame)
	iconbg:SetAllPoints(icon)
	CreateBorderLight(iconbg, C.Media.BorderSize, C.Media.BorderColor.r, C.Media.BorderColor.g, C.Media.BorderColor.b)
	SetTexture(iconbg, 'white')

	local count = iconFrame:CreateFontString(nil, 'OVERLAY')
	count:SetFont(C.Media.Font, 12)
	count:SetJustifyH('CENTER')
	count:SetPoint('TOP', iconFrame, 1, -2)
	count:SetText(1)
	frame.count = count

	local name = frame:CreateFontString(nil, 'OVERLAY')
	name:SetFont(C.Media.Font, 12)
	name:SetJustifyH('LEFT')
	name:SetPoint('RIGHT', frame)
	name:SetPoint('LEFT', icon, 'RIGHT', 8, 0)
	name:SetNonSpaceWrap(true)
	frame.name = name

	return frame
end

local anchorSlots = function(self)
	local shownSlots = 0
	for i=1, #self.slots do
		local frame = self.slots[i]
		if(frame:IsShown()) then
			shownSlots = shownSlots + 1

			-- We don't have to worry about the previous slots as they're already hidden.
			frame:SetPoint('TOP', addon, 4, (-8 + iconsize) - (shownSlots * (iconsize+1)))
		end
	end

	self:SetHeight(math.max(shownSlots * iconsize + 16, 20))
end

addon:SetScript('OnHide', function(self)
	StaticPopup_Hide'CONFIRM_LOOT_DISTRIBUTION'
	CloseLoot()
end)

addon.LOOT_CLOSED = function(self)
	StaticPopup_Hide'LOOT_BIND'
	self:Hide()

	for _, v in next, self.slots do
		v:Hide()
	end
end

addon.LOOT_OPENED = function(self, event, autoloot)
	self:Show()

	if(not self:IsShown()) then
		CloseLoot(not autoLoot)
	end

	local items = GetNumLootItems()

	local x, y = GetCursorPosition()
	x = x / self:GetEffectiveScale()
	y = y / self:GetEffectiveScale()

	self:ClearAllPoints()
	self:SetPoint('TOPLEFT', nil, 'BOTTOMLEFT', x-40, y+20)
	self:Raise()

	if(items > 0) then
		for i = 1, items do
			local slot = addon.slots[i] or createSlot(i)
			local texture, item, quantity, quality, locked, isQuestItem, questId, isActive = GetLootSlotInfo(i)
			if texture then

				if GetLootSlotType(i) == LOOT_SLOT_MONEY then
					item = item:gsub('\n', ', ')
				end

				if(quantity > 1) then
					slot.count:SetText(quantity)
					slot.count:Show()
				else
					slot.count:Hide()
				end

				slot.quality = quality

				local color = ITEM_QUALITY_COLORS[quality]

				if questId and not isActive then
					slot.bg:SetBackdropColor(.5, 0, 0, .5)
					slot.name:SetTextColor(1, 0, 0)
				elseif questId or isQuestItem then
					slot.bg:SetBackdropColor(.5, 0, 0, .5)
					slot.name:SetTextColor(color.r, color.g, color.b)
				else
					slot.bg:SetBackdropColor(0, 0, 0, .5)
					slot.name:SetTextColor(color.r, color.g, color.b)
				end

				slot.name:SetText(item)
				slot.icon:SetTexture(texture)

				slot:Enable()
				slot:Show()
			end
		end
	else
		self:Hide()
	end

	anchorSlots(self)
end

addon.LOOT_SLOT_CLEARED = function(self, event, slot)
	if(not self:IsShown()) then return end
	addon.slots[slot]:Hide()
	anchorSlots(self)
end

addon.OPEN_MASTER_LOOT_LIST = function(self)
	ToggleDropDownMenu(1, nil, GroupLootDropDown, addon.slots[ss], 0, 0)
end

addon.UPDATE_MASTER_LOOT_LIST = function(self)
	MasterLooterFrame_UpdatePlayers()
end

addon:SetScript('OnEvent', function(self, event, arg1) self[event](self, event, arg1) end)

addon:RegisterEvent('LOOT_OPENED')
addon:RegisterEvent('LOOT_SLOT_CLEARED')
addon:RegisterEvent('LOOT_CLOSED')
addon:RegisterEvent('OPEN_MASTER_LOOT_LIST')
addon:RegisterEvent('UPDATE_MASTER_LOOT_LIST')
addon:Hide()

LootFrame:UnregisterAllEvents()
table.insert(UISpecialFrames, 'LanLoot')

LootHistoryDropDown.initialize = function(self)
	local info = UIDropDownMenu_CreateInfo();
	info.isTitle = 1;
	info.text = MASTER_LOOTER;
	info.fontObject = GameFontNormalLeft;
	info.notCheckable = 1;
	UIDropDownMenu_AddButton(info);

	info = UIDropDownMenu_CreateInfo();
	info.notCheckable = 1;
	local name, class = C_LootHistory.GetPlayerInfo(self.itemIdx, self.playerIdx);
	local classColor = RAID_CLASS_COLORS[class];
	local colorCode = string.format('|cFF%02x%02x%02x',  classColor.r*255,  classColor.g*255,  classColor.b*255);
	info.text = string.format(MASTER_LOOTER_GIVE_TO, colorCode..name..'|r');
	info.func = LootHistoryDropDown_OnClick;
	UIDropDownMenu_AddButton(info);
end

UIParent:UnregisterEvent('START_LOOT_ROLL')
UIParent:UnregisterEvent('CANCEL_LOOT_ROLL')

local gwidth = 200
local giconsize = 32
local grouplootlist, grouplootframes = {}, {}

local MAX_LEVEL = MAX_PLAYER_LEVEL_TABLE[GetExpansionLevel()]

local function shouldAutoRoll(quality, BoP)
	return quality == 2 and not BoP and C.Tweaks.AutoDEGreed and (MAX_LEVEL == UnitLevel('player'))
end

local function OnEvent(self, event, rollId)
	local _, _, _, quality, BoP, _, _, canDE = GetLootRollItemInfo(rollId)
	if shouldAutoRoll(quality, BoP) then
		RollOnLoot(rollId, canDE and 3 or 2)
	else
		tinsert(grouplootlist, {rollId = rollId})
		self:UpdateGroupLoot()
	end
end

local function FrameOnEvent(self, event, rollId)
	if(self.rollId and rollId==self.rollId) then
		for index, value in next, grouplootlist do
			if(self.rollId==value.rollId) then
				tremove(grouplootlist, index)
				break
			end
		end
		StaticPopup_Hide('CONFIRM_LOOT_ROLL', self.rollId)
		self.rollId = nil
		LanGroupLoot:UpdateGroupLoot()
	end
end

local function FrameOnClick(self)
	HandleModifiedItemClick(self.rollLink)
end

local function onUpdate(self)
	if GameTooltip:IsOwned(self) then
		if IsModifiedClick('COMPAREITEMS') or GetCVarBool('alwaysCompareItems') then
			GameTooltip_ShowCompareItem()
		else
			ShoppingTooltip1:Hide()
			ShoppingTooltip2:Hide()
			ShoppingTooltip3:Hide()
		end

		if IsModifiedClick('DRESSUP') then
			ShowInspectCursor()
		else
			ResetCursor()
		end
	end
end

local function FrameOnEnter(self)
	if(not self.rollId) then return end
	GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMLEFT')
	GameTooltip:SetLootRollItem(self.rollId)
	self:SetScript('OnUpdate', onUpdate)
	CursorUpdate(self)
end

local function FrameOnLeave(self)
	self:SetScript('OnUpdate', nil)
	GameTooltip:Hide()
	ResetCursor()
end

local function ButtonOnClick(self, button)
	RollOnLoot(self:GetParent().rollId, self.type)
end

local function SortFunc(a, b)
	return a.rollId < b.rollId
end

local GLoot = CreateFrame('Frame', 'LanGroupLoot', UIParent)
GLoot:RegisterEvent('START_LOOT_ROLL')
GLoot:SetScript('OnEvent', OnEvent)
GLoot:SetPoint('RIGHT', -50, 0)
GLoot:SetWidth(gwidth)
GLoot:SetHeight(24)

function GLoot:UpdateGroupLoot()
	sort(grouplootlist, SortFunc)
	for index, value in next, grouplootframes do value:Hide() end

	if MultiBarLeft:IsShown() then
		GLoot:SetPoint('RIGHT', -150, 0)
	elseif MultiBarRight:IsShown() then
		GLoot:SetPoint('RIGHT', -100, 0)
	else
		GLoot:SetPoint('RIGHT', -50, 0)
	end

	local frame
	for index, value in next, grouplootlist do
		frame = grouplootframes[index]
		if(not frame) then
			frame = CreateFrame('Frame', 'LanGroupLootFrame'..index, UIParent)
			frame:EnableMouse(true)
			frame:SetWidth(220)
			frame:SetHeight(24)
			frame:SetPoint('TOP', GLoot, 0, -((index-1)*(giconsize+3)))
			frame:RegisterEvent('CANCEL_LOOT_ROLL')
			frame:SetScript('OnEvent', FrameOnEvent)
			frame:SetScript('OnMouseUp', FrameOnClick)
			frame:SetScript('OnLeave', FrameOnLeave)
			frame:SetScript('OnEnter', FrameOnEnter)
			frame:SetTemplate()

			frame.pass = CreateFrame('Button', nil, frame)
			frame.pass.type = 0
			frame.pass.roll = 'pass'
			frame.pass:SetWidth(28)
			frame.pass:SetHeight(28)
			frame.pass:SetNormalTexture('Interface\\Buttons\\UI-GroupLoot-Pass-Up')
			frame.pass:SetHighlightTexture('Interface\\Buttons\\UI-GroupLoot-Pass-Down')
			frame.pass:SetPoint('RIGHT', 0, 1)
			frame.pass:SetScript('OnClick', ButtonOnClick)

			frame.greed = CreateFrame('Button', nil, frame)
			frame.greed.type = 2
			frame.greed.roll = 'greed'
			frame.greed:SetWidth(28)
			frame.greed:SetHeight(28)
			frame.greed:SetNormalTexture('Interface\\Buttons\\UI-GroupLoot-Coin-Up')
			frame.greed:SetPushedTexture('Interface\\Buttons\\UI-GroupLoot-Coin-Down')
			frame.greed:SetHighlightTexture('Interface\\Buttons\\UI-GroupLoot-Coin-Highlight')
			frame.greed:SetPoint('RIGHT', frame.pass, 'LEFT', -1, -4)
			frame.greed:SetScript('OnClick', ButtonOnClick)

			frame.disenchant = CreateFrame('Button', nil, frame)
			frame.disenchant.type = 3
			frame.disenchant.roll = 'disenchant'
			frame.disenchant:SetWidth(28)
			frame.disenchant:SetHeight(28)
			frame.disenchant:SetNormalTexture('Interface\\Buttons\\UI-GroupLoot-DE-Up')
			frame.disenchant:SetPushedTexture('Interface\\Buttons\\UI-GroupLoot-DE-Down')
			frame.disenchant:SetHighlightTexture('Interface\\Buttons\\UI-GroupLoot-DE-Highlight')
			frame.disenchant:SetPoint('RIGHT', frame.greed, 'LEFT', -1, 2)
			frame.disenchant:SetScript('OnClick', ButtonOnClick)

			frame.need = CreateFrame('Button', nil, frame)
			frame.need.type = 1
			frame.need.roll = 'need'
			frame.need:SetWidth(28)
			frame.need:SetHeight(28)
			frame.need:SetNormalTexture('Interface\\Buttons\\UI-GroupLoot-Dice-Up')
			frame.need:SetPushedTexture('Interface\\Buttons\\UI-GroupLoot-Dice-Down')
			frame.need:SetHighlightTexture('Interface\\Buttons\\UI-GroupLoot-Dice-Highlight')
			frame.need:SetPoint('RIGHT', frame.disenchant, 'LEFT', -1, 0)
			frame.need:SetScript('OnClick', ButtonOnClick)

			frame.text = frame:CreateFontString(nil, 'OVERLAY')
			frame.text:SetFont(C.Media.Font, 12)
			frame.text:SetJustifyH('LEFT')
			frame.text:SetPoint('LEFT')
			frame.text:SetPoint('RIGHT', frame.need, 'LEFT')

			local iconFrame = CreateFrame('Frame', nil, frame)
			iconFrame:SetHeight(giconsize)
			iconFrame:SetWidth(giconsize)
			iconFrame:ClearAllPoints()
			iconFrame:SetPoint('RIGHT', frame, 'LEFT', -2, 0)

			local icon = iconFrame:CreateTexture(nil, 'OVERLAY')
			icon:SetPoint('TOPLEFT')
			icon:SetPoint('BOTTOMRIGHT')
			icon:SetTexCoord(.08, .92, .08, .92)
			frame.icon = icon
			
			local iconbg = CreateFrame('Frame', nil, iconFrame)
			iconbg:SetAllPoints(icon)
			CreateBorderLight(iconbg, C.Media.BorderSize, C.Media.BorderColor.r, C.Media.BorderColor.g, C.Media.BorderColor.b)
			SetTexture(iconbg, 'white')

			tinsert(grouplootframes, frame)
		end

		local texture, name, count, quality, bindOnPickUp, Needable, Greedable, Disenchantable = GetLootRollItemInfo(value.rollId)

		if Disenchantable then frame.disenchant:Enable() else frame.disenchant:Disable() end
		if Needable then frame.need:Enable() else frame.need:Disable() end
		if Greedable then frame.greed:Enable() else frame.greed:Disable() end

		SetDesaturation(frame.disenchant:GetNormalTexture(), not Disenchantable)
		SetDesaturation(frame.need:GetNormalTexture(), not Needable)
		SetDesaturation(frame.greed:GetNormalTexture(), not Greedable)

		frame.text:SetText(ITEM_QUALITY_COLORS[quality].hex..name)

		frame.icon:SetTexture(texture)

		frame.rollId = value.rollId
		frame.rollLink = GetLootRollItemLink(value.rollId)

		frame:Show()
	end
end