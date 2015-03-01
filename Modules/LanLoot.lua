local F, C, G = unpack(select(2, ...))

local buttonsize = 24
local width = 221

----------------------------------------------------------------------------------------
--        Loot frame(Butsu by Haste)
----------------------------------------------------------------------------------------
local Loot = CreateFrame('Button', 'LanLoot')
local lb = CreateFrame('Button', 'LanLootAdv', Loot, 'UIPanelScrollDownButtonTemplate')
local LDD = CreateFrame('Frame', 'LanLootLDD', Loot, 'UIDropDownMenuTemplate')
Loot:Hide()

Loot:SetScript('OnEvent', function(self, event, ...)
        self[event](self, event, ...)
end)

function Loot:LOOT_OPENED(event, autoloot)
	self:Show()

	if not self:IsShown() then
		CloseLoot(not autoLoot)
	end

	if IsFishingLoot() then
		self.title:SetText(L_LOOT_FISH)
	elseif not UnitIsFriend('player', 'target') and UnitIsDead('target') then
		self.title:SetText(UnitName('target'))
	else
		self.title:SetText(LOOT)
	end

	-- Blizzard uses strings here
	if GetCVar('lootUnderMouse') == '1' then
		local x, y = GetCursorPosition()
		x = x / self:GetEffectiveScale()
		y = y / self:GetEffectiveScale()

		self:ClearAllPoints()
		self:SetPoint('TOPLEFT', nil, 'BOTTOMLEFT', x - 40, y + 20)
		self:GetCenter()
		self:Raise()
	end

	local m = 0
	local items = GetNumLootItems()
	if items > 0 then
		for i = 1, items do
			local slot = G.slots[i] or F.CreateSlot(i)
			local texture, item, quantity, quality, locked, isQuestItem, questId, isActive = GetLootSlotInfo(i)
			if texture then
				local color = ITEM_QUALITY_COLORS[quality]
				local r, g, b = color.r, color.g, color.b

				if GetLootSlotType(i) == LOOT_SLOT_MONEY then
					item = item:gsub('\n', ', ')
				end

				if quantity and quantity > 1 then
					slot.count:SetText(quantity)
					slot.count:Show()
				else
					slot.count:Hide()
				end

				if questId and not isActive then
					slot.quest:Show()
				else
					slot.quest:Hide()
				end

				if color or questId or isQuestItem then
					if questId or isQuestItem then
						r, g, b = 1, 1, 0.2
					end

					slot.iconFrame:SetBackdropBorderColor(r, g, b)
					slot.drop:SetVertexColor(r, g, b)
				end
				slot.drop:Show()

				slot.isQuestItem = isQuestItem
				slot.quality = quality

				slot.name:SetText(item)
				slot.name:SetTextColor(1, 1, 1)
				slot.icon:SetTexture(texture)

				if quality then
					m = math.max(m, quality)
				end

				slot:Enable()
				slot:Show()
			end
		end
	else
		local slot = G.slots[1] or F.CreateSlot(1)
		local color = ITEM_QUALITY_COLORS[0]

		slot.name:SetText(EMPTY)
		slot.name:SetTextColor(color.r, color.g, color.b)
		slot.icon:SetTexture('Interface\\Icons\\INV_Misc_Herb_AncientLichen')

		slot.count:Hide()
		slot.drop:Hide()
		slot:Disable()
		slot:Show()
	end
	
	self:AnchorSlots()

	local color = ITEM_QUALITY_COLORS[m]
	self:SetBackdropBorderColor(color.r, color.g, color.b, 0.8)

	self:SetWidth(width)
	self.title:SetWidth(width - 45)
	self.title:SetHeight(C.Media.FontSize)
end
Loot:RegisterEvent('LOOT_OPENED')

function Loot:LOOT_SLOT_CLEARED(event, slot)
	if not self:IsShown() then return end

	G.slots[slot]:Hide()
	self:AnchorSlots()
end
Loot:RegisterEvent('LOOT_SLOT_CLEARED')

function Loot:LOOT_CLOSED()
	StaticPopup_Hide('LOOT_BIND')
	self:Hide()
	lb:Hide()

	for _, v in pairs(G.slots) do
			v:Hide()
	end
end
Loot:RegisterEvent('LOOT_CLOSED')

function Loot:OPEN_MASTER_LOOT_LIST()
	ToggleDropDownMenu(nil, nil, GroupLootDropDown, LootFrame.selectedLootButton, 0, 0)
end
Loot:RegisterEvent('OPEN_MASTER_LOOT_LIST')

function Loot:UPDATE_MASTER_LOOT_LIST()
	UIDropDownMenu_Refresh(GroupLootDropDown)
end
Loot:RegisterEvent('UPDATE_MASTER_LOOT_LIST')

do
	local title = Loot:CreateFontString(nil, 'OVERLAY')
	title:FontTemplate()
	title:SetShadowOffset(0, 0)
	title:SetJustifyH('LEFT')
	title:SetPoint('TOPLEFT', Loot, 'TOPLEFT', 8, -7)
	Loot.title = title
end

Loot:SetScript('OnMouseDown', function(self)
	if IsAltKeyDown() then
			self:StartMoving()
	end
end)

Loot:SetScript('OnMouseUp', function(self)
	self:StopMovingOrSizing()
end)

Loot:SetScript('OnHide', function(self)
	StaticPopup_Hide('CONFIRM_LOOT_DISTRIBUTION')
	CloseLoot()
end)

Loot:SetMovable(true)
Loot:RegisterForClicks('AnyUp')
Loot:SetParent(UIParent)
Loot:SetUserPlaced(true)
Loot:SetPoint('TOPLEFT', UIParent, 'TOPLEFT', 245, -220)
Loot:SetTemplate()
Loot:SetClampedToScreen(true)
Loot:SetFrameStrata('DIALOG')
Loot:SetToplevel(true)
Loot:SetFrameLevel(10)

local close = CreateFrame('Button', 'LootCloseButton', Loot, 'UIPanelCloseButton')
F.SkinCloseButton(close, Loot)
close:SetWidth(14)
close:SetHeight(14)

close:SetScript('OnClick', function() CloseLoot() end)

do
	local slots = {}
	G.slots = slots

	local OnEnter = function(self)
		local slot = self:GetID()
		if LootSlotHasItem(slot) then
			GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
			GameTooltip:SetLootItem(slot)
			CursorUpdate(self)
		end

		self.drop:Show()
		if self.isQuestItem then
			self.drop:SetVertexColor(0.8, 0.8, 0.2)
		else
			self.drop:SetVertexColor(1, 1, 0)
		end
	end

	local OnLeave = function(self)
		local color = ITEM_QUALITY_COLORS[self.quality]
		if self.isQuestItem then
			self.drop:SetVertexColor(1, 1, 0.2)
		elseif color then
			self.drop:SetVertexColor(color.r, color.g, color.b)
		end

		GameTooltip:Hide()
		ResetCursor()
	end

	local OnClick = function(self)
		if IsModifiedClick() then
			HandleModifiedItemClick(GetLootSlotLink(self:GetID()))
		else
			StaticPopup_Hide('CONFIRM_LOOT_DISTRIBUTION')

			LootFrame.selectedLootButton = self
			LootFrame.selectedSlot = self:GetID()
			LootFrame.selectedQuality = self.quality
			LootFrame.selectedItemName = self.name:GetText()

			LootSlot(self:GetID())
		end
	end

	local OnUpdate = function(self)
		if GameTooltip:IsOwned(self) then
			GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
			GameTooltip:SetLootItem(self:GetID())
			CursorOnUpdate(self)
		end
	end

	function F.CreateSlot(id)
		local frame = CreateFrame('Button', 'LanLootSlot'..id, Loot)
		frame:SetHeight(math.max(C.Media.FontSize, buttonsize))
		frame:SetID(id)

		frame:RegisterForClicks('LeftButtonUp', 'RightButtonUp')

		frame:SetScript('OnEnter', OnEnter)
		frame:SetScript('OnLeave', OnLeave)
		frame:SetScript('OnClick', OnClick)
		frame:SetScript('OnUpdate', OnUpdate)

		local iconFrame = CreateFrame('Frame', nil, frame)
		iconFrame:SetSize(buttonsize, buttonsize)
		iconFrame:SetTemplate()
		iconFrame:SetPoint('LEFT', frame)
		frame.iconFrame = iconFrame

		local icon = iconFrame:CreateTexture(nil, 'BORDER')
		icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		icon:SetPoint('TOPLEFT', 2, -2)
		icon:SetPoint('BOTTOMRIGHT', -2, 2)
		frame.icon = icon

		local quest = iconFrame:CreateTexture(nil, 'OVERLAY')
		quest:SetTexture('Interface\\Minimap\\ObjectIcons')
		quest:SetTexCoord(1/8, 2/8, 1/8, 2/8)
		quest:SetSize(buttonsize * 0.8, buttonsize * 0.8)
		quest:SetPoint('BOTTOMLEFT', -buttonsize * 0.15, 0)
		frame.quest = quest

		local count = iconFrame:CreateFontString(nil, 'OVERLAY')
		count:SetJustifyH('RIGHT')
		count:SetPoint('BOTTOMRIGHT', iconFrame, 'BOTTOMRIGHT', 1, 1)
		count:FontTemplate()
		count:SetShadowOffset(0, 0)
		count:SetText(1)
		frame.count = count

		local name = frame:CreateFontString(nil, 'OVERLAY')
		name:SetJustifyH('CENTER')
		name:SetPoint('LEFT', icon, 'RIGHT', 10, 0)
		name:SetNonSpaceWrap(true)
		name:FontTemplate()
		name:SetWidth(width - buttonsize - 25)
		name:SetHeight(C.Media.FontSize)
		frame.name = name

		local drop = frame:CreateTexture(nil, 'ARTWORK')
		drop:SetTexture(C.Media.Backdrop)
		drop:SetPoint('TOPLEFT', buttonsize + 5, -2)
		drop:SetPoint('BOTTOMRIGHT', -2, 2)
		drop:SetAlpha(0.5)
		frame.drop = drop
		
		local dropbg = CreateFrame('Frame', 'SlotBG', frame)
		dropbg:SetPoint('TOPLEFT', frame.drop, -2, 2)
		dropbg:SetPoint('BOTTOMRIGHT', frame.drop, 2, -2)
		dropbg:SetFrameStrata('DIALOG')
		dropbg:SetTemplate()
		dropbg:SetBackdropColor(0, 0, 0, 0)
		
		slots[id] = frame
		return frame
	end

	function Loot:AnchorSlots()
		local frameSize = math.max(buttonsize, 2)
		local shownSlots = 0

		local prevShown
		for i = 1, #slots do
			local frame = slots[i]
			if frame:IsShown() then
				frame:ClearAllPoints()
				frame:SetPoint('LEFT', 8, 0)
				frame:SetPoint('RIGHT', -8, 0)
				if not prevShown then
					frame:SetPoint('TOPLEFT', self, 8, -25)
				else
					frame:SetPoint('TOP', prevShown, 'BOTTOM', 0, -5)
				end

				frame:SetHeight(frameSize)
				shownSlots = shownSlots + 1
				prevShown = frame
			end
		end

		self:SetHeight((shownSlots * (frameSize + 3)) + 30)
	end
end

-- Kill the default loot frame
LootFrame:UnregisterAllEvents()

-- Escape the dungeon
table.insert(UISpecialFrames, 'LanLoot')