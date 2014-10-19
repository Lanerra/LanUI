local F, C, G = unpack(select(2, ...))
local bc = C.Media.BorderColor

-- Credit to Haste
local lootFrame, lootFrameHolder
local iconSize = 30;

local max = math.max
local tinsert = table.insert

local sq, ss, sn
local OnEnter = function(self)
	local slot = self:GetID()
	if(LootSlotHasItem(slot)) then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetLootItem(slot)
		CursorUpdate(self)
	end

	self.drop:Show()
	self.drop:SetVertexColor(1, 1, 0)
end

local OnLeave = function(self)
	if self.quality and (self.quality > 1) then
		local color = ITEM_QUALITY_COLORS[self.quality]
		self.drop:SetVertexColor(color.r, color.g, color.b)
	else
		self.drop:Hide()
	end
	
	GameTooltip:Hide()
	ResetCursor()
end

local OnClick = function(self)
	LootFrame.selectedQuality = self.quality;
	LootFrame.selectedItemName = self.name:GetText()
	LootFrame.selectedSlot = self:GetID()
	LootFrame.selectedLootButton = self:GetName()
	LootFrame.selectedTexture = self.icon:GetTexture()
	
	if(IsModifiedClick()) then
		HandleModifiedItemClick(GetLootSlotLink(self:GetID()))
	else
		StaticPopup_Hide("CONFIRM_LOOT_DISTRIBUTION")
		ss = self:GetID()
		sq = self.quality
		sn = self.name:GetText()
		LootSlot(ss)
	end
end

local OnShow = function(self)
	if(GameTooltip:IsOwned(self)) then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetLootItem(self:GetID())
		CursorOnUpdate(self)
	end
end

local function anchorSlots(self)
	local iconsize = iconSize
	local shownSlots = 0
	for i=1, #self.slots do
		local frame = self.slots[i]
		if(frame:IsShown()) then
			shownSlots = shownSlots + 1

			frame:Point("TOP", lootFrame, 4, (-8 + iconsize) - (shownSlots * iconsize))
		end
	end

	self:Height(max(shownSlots * iconsize + 16, 20))
end

local function createSlot(id)
	local iconsize = iconSize-2
	local frame = CreateFrame("Button", 'LanLootSlot'..id, lootFrame)
	frame:Point("LEFT", 8, 0)
	frame:Point("RIGHT", -8, 0)
	frame:Height(iconsize)
	frame:SetID(id)

	frame:RegisterForClicks("LeftButtonUp", "RightButtonUp")

	frame:SetScript("OnEnter", OnEnter)
	frame:SetScript("OnLeave", OnLeave)
	frame:SetScript("OnClick", OnClick)
	frame:SetScript("OnShow", OnShow)

	local iconFrame = CreateFrame("Frame", nil, frame)
	iconFrame:Height(iconsize)
	iconFrame:Width(iconsize)
	iconFrame:SetPoint("RIGHT", frame)
	iconFrame:CreateBD()
	frame.iconFrame = iconFrame

	local icon = iconFrame:CreateTexture(nil, "ARTWORK")
	icon:SetTexCoord(unpack(F.TexCoords))
	icon:SetInside()
	icon:CreateBD()
	frame.icon = icon

	local count = iconFrame:CreateFontString(nil, "OVERLAY")
	count:SetJustifyH"RIGHT"
	count:Point("BOTTOMRIGHT", iconFrame, -2, 2)
	count:SetFont(C.Media.Font, C.Media.FontSize, 'OUTLINE')
	count:SetText(1)
	frame.count = count

	local name = frame:CreateFontString(nil, "OVERLAY")
	name:SetJustifyH("LEFT")
	name:SetPoint("LEFT", frame)
	name:SetPoint("RIGHT", icon, "LEFT")
	name:SetNonSpaceWrap(true)
	name:SetFont(C.Media.Font, C.Media.FontSize, 'OUTLINE')
	frame.name = name

	local drop = frame:CreateTexture(nil, "ARTWORK")
	drop:SetTexture("Interface\\QuestFrame\\UI-QuestLogTitleHighlight")
	drop:SetPoint("LEFT", icon, "RIGHT", 0, 0)
	drop:SetPoint("RIGHT", frame)
	drop:SetAllPoints(frame)
	drop:SetAlpha(.3)
	frame.drop = drop
	
	local questTexture = iconFrame:CreateTexture(nil, 'OVERLAY')
	questTexture:SetInside()
	questTexture:SetTexture(TEXTURE_ITEM_QUEST_BANG);
	questTexture:SetTexCoord(unpack(F.TexCoords))
	frame.questTexture = questTexture

	lootFrame.slots[id] = frame
	return frame
end

function LOOT_SLOT_CLEARED(event, slot)
	if(not lootFrame:IsShown()) then return end

	lootFrame.slots[slot]:Hide()
	anchorSlots(lootFrame)
end

function LOOT_CLOSED()
	StaticPopup_Hide("LOOT_BIND")
	lootFrame:Hide()

	for _, v in pairs(lootFrame.slots) do
		v:Hide()
	end
end

function OPEN_MASTER_LOOT_LIST()
	ToggleDropDownMenu(1, nil, GroupLootDropDown, lootFrame.slots[ss], 0, 0)
end

function UPDATE_MASTER_LOOT_LIST()
	MasterLooterFrame_UpdatePlayers()
end

function LOOT_OPENED(event, autoloot)
	lootFrame:Show()

	if(not lootFrame:IsShown()) then
		CloseLoot(not autoLoot)
	end

	local items = GetNumLootItems()

	if(IsFishingLoot()) then
		lootFrame.title:SetText('Fish')
	elseif(not UnitIsFriend("player", "target") and UnitIsDead"target") then
		lootFrame.title:SetText(UnitName("target"))
	else
		lootFrame.title:SetText(LOOT)
	end

	-- Blizzard uses strings here
	if(GetCVar("lootUnderMouse") == "1") then
		local x, y = GetCursorPosition()
		x = x / lootFrame:GetEffectiveScale()
		y = y / lootFrame:GetEffectiveScale()

		lootFrame:ClearAllPoints()
		lootFrame:Point("TOPLEFT", nil, "BOTTOMLEFT", x - 40, y + 20)
		lootFrame:GetCenter()
		lootFrame:Raise()
	else
		lootFrame:ClearAllPoints()
		lootFrame:SetPoint("TOPLEFT", lootFrameHolder, "TOPLEFT")	
	end

	local m, w, t = 0, 0, lootFrame.title:GetStringWidth()
	if(items > 0) then
		for i=1, items do
			local slot = lootFrame.slots[i] or createSlot(i)
			local texture, item, quantity, quality, locked, isQuestItem, questId, isActive = GetLootSlotInfo(i)
			local color = ITEM_QUALITY_COLORS[quality]

			if texture and texture:find('INV_Misc_Coin') then
				item = item:gsub("\n", ", ")
			end	
			
			if quantity and (quantity > 1) then
				slot.count:SetText(quantity)
				slot.count:Show()
			else
				slot.count:Hide()
			end

			if quality and (quality > 1) then
				slot.drop:SetVertexColor(color.r, color.g, color.b)
				slot.drop:Show()
			else
				slot.drop:Hide()
			end

			slot.quality = quality
			slot.name:SetText(item)
			if color then
				slot.name:SetTextColor(color.r, color.g, color.b)
			end
			slot.icon:SetTexture(texture)
			
			if quality then
				m = max(m, quality)
			end
			w = max(w, slot.name:GetStringWidth())

			
			local questTexture = slot.questTexture
			if ( questId and not isActive ) then
				questTexture:Show();
				ActionButton_ShowOverlayGlow(slot.iconFrame)
			elseif ( questId or isQuestItem ) then
				questTexture:Hide();	
				ActionButton_ShowOverlayGlow(slot.iconFrame)
			else
				questTexture:Hide();
				ActionButton_HideOverlayGlow(slot.iconFrame)
			end			
			
			slot:Enable()
			slot:Show()
		end
	else
		local slot = lootFrame.slots[1] or createSlot(1)
		local color = ITEM_QUALITY_COLORS[0]

		slot.name:SetText('----------')
		if color then
			slot.name:SetTextColor(color.r, color.g, color.b)
		end
		slot.icon:SetTexture("Interface\\Icons\\INV_Misc_Herb_AncientLichen")

		items = 1
		w = max(w, slot.name:GetStringWidth())

		slot.count:Hide()
		slot.drop:Hide()
		slot:Disable()
		slot:Show()
	end
	anchorSlots(lootFrame)

	w = w + 60
	t = t + 5

	local color = ITEM_QUALITY_COLORS[m]
	lootFrame:SetBackdropBorderColor(color.r, color.g, color.b, .8)
	lootFrame:Width(max(w, t))
end

function LoadLoot()
	lootFrameHolder = CreateFrame("Frame", "LanLootFrameHolder", UIParent)
	lootFrameHolder:Point("TOPLEFT", 36, -195)
	lootFrameHolder:Width(150)
	lootFrameHolder:Height(22)
	
	lootFrame = CreateFrame('Button', 'LanLootFrame', lootFrameHolder)
	lootFrame:SetClampedToScreen(true)
	lootFrame:SetPoint('TOPLEFT')
	lootFrame:Size(256, 64)
	lootFrame:SetTemplate()
	lootFrame:SetFrameStrata("FULLSCREEN")
	lootFrame:SetToplevel(true)	
	lootFrame.title = lootFrame:CreateFontString(nil, 'OVERLAY')
	lootFrame.title:SetFont(C.Media.Font, C.Media.FontSize, 'OUTLINE')
	lootFrame.title:Point('BOTTOMLEFT', lootFrame, 'TOPLEFT', 0,  1)
	lootFrame.slots = {}
	lootFrame:SetScript("OnHide", function(self)
		StaticPopup_Hide("CONFIRM_LOOT_DISTRIBUTION")
		CloseLoot()
	end)

	self:RegisterEvent("LOOT_OPENED")
	self:RegisterEvent("LOOT_SLOT_CLEARED")
	self:RegisterEvent("LOOT_CLOSED")
	self:RegisterEvent("OPEN_MASTER_LOOT_LIST")
	self:RegisterEvent("UPDATE_MASTER_LOOT_LIST")
	
	-- Fuzz
	LootFrame:UnregisterAllEvents()
	tinsert(UISpecialFrames, 'LanLootFrame')

	function _G.GroupLootDropDown_GiveLoot(self)
		if ( sq >= MASTER_LOOT_THREHOLD ) then
			local dialog = StaticPopup_Show("CONFIRM_LOOT_DISTRIBUTION", ITEM_QUALITY_COLORS[sq].hex..sn..FONT_COLOR_CODE_CLOSE, self:GetText())
			if (dialog) then
				dialog.data = self.value
			end
		else
			GiveMasterLoot(ss, self.value)
		end
		CloseDropDownMenus()
	end

	PopupDialogs["CONFIRM_LOOT_DISTRIBUTION"].OnAccept = function(self, data)
		GiveMasterLoot(ss, data)
	end
end

local function LoadSkin()
	local frame = MissingLootFrame
	local close = MissingLootFramePassButton

	frame:StripTextures()
	frame:SetTemplate()

	MissingLootFramePassButton:SkinCloseButton()
	
	local function SkinButtons()
		local number = GetNumMissingLootItems()
		for i = 1, number do
			local slot = _G['MissingLootFrameItem'..i]
			local icon = slot.icon
			
			if not slot.isSkinned then
				slot:StripTextures()
				slot:StyleButton()
				slot:CreateBD()
				icon:SetTexCoord(.08, .92, .08, .92)
				icon:ClearAllPoints()
				icon:Point('TOPLEFT', 2, -2)
				icon:Point('BOTTOMRIGHT', -2, 2)
				
				slot.isSkinned = true
			end
			
			local quality = select(4, GetMissingLootItemInfo(i))
			local color = (GetItemQualityColor(quality)) or (unpack(bc))
			frame:SetBeautyBorderColor(color)
		end
	end
	hooksecurefunc('MissingLootFrame_Show', SkinButtons)
	
	-- loot history frame
	LootHistoryFrame:StripTextures()
	LootHistoryFrame.CloseButton:SkinCloseButton()
	LootHistoryFrame:StripTextures()
	LootHistoryFrame:SetTemplate()
	LootHistoryFrame.ResizeButton:SkinCloseButton()
	LootHistoryFrame.ResizeButton.t:SetText('v v v v')
	LootHistoryFrame.ResizeButton:SetTemplate()
	LootHistoryFrame.ResizeButton:Width(LootHistoryFrame:GetWidth())
	LootHistoryFrame.ResizeButton:Height(19)
	LootHistoryFrame.ResizeButton:ClearAllPoints()
	LootHistoryFrame.ResizeButton:Point('TOP', LootHistoryFrame, 'BOTTOM', 0, -2)
	LootHistoryFrameScrollFrameScrollBar:SkinScrollBar()
	
	local function UpdateLoots(self)
		local numItems = C_LootHistory.GetNumItems()
		for i=1, numItems do
			local frame = self.itemFrames[i]
			
			if not frame.isSkinned then
				frame.NameBorderLeft:Hide()
				frame.NameBorderRight:Hide()
				frame.NameBorderMid:Hide()
				frame.IconBorder:Hide()
				frame.Divider:Hide()
				frame.ActiveHighlight:Hide()
				frame.Icon:SetTexCoord(.08,.88,.08,.88)
				frame.Icon:SetDrawLayer('ARTWORK')
				
				-- create a backdrop around the icon
				frame:CreateBD(true)
				frame.backdrop:Point('TOPLEFT', frame.Icon, -2, 2)
				frame.backdrop:Point('BOTTOMRIGHT', frame.Icon, 2, -2)
				frame.backdrop:SetBackdropColor(0,0,0,0)
				frame.isSkinned = true
			end
		end
	end
	hooksecurefunc('LootHistoryFrame_FullUpdate', UpdateLoots)
	
	-- master loot frame
	MasterLooterFrame:StripTextures()
	MasterLooterFrame:SetTemplate()
	
	hooksecurefunc('MasterLooterFrame_Show', function()
		local b = MasterLooterFrame.Item
		if b then
			local i = b.Icon
			local icon = i:GetTexture()
			local c = ITEM_QUALITY_COLORS[LootFrame.selectedQuality]
			
			b:StripTextures()
			i:SetTexture(icon)
			i:SetTexCoord(.1,.9,.1,.9)
			b:CreateBD(true)
			b.backdrop:SetInside(i)
			b.backdrop:SetBeautyBorderColor(c.r, c.g, c.b)
		end
		
		for i=1, MasterLooterFrame:GetNumChildren() do
			local child = select(i, MasterLooterFrame:GetChildren())
			if child and not child.isSkinned and not child:GetName() then
				if child:GetObjectType() == 'Button' then
					if child:GetPushedTexture() then
						child:SkinCloseButton()
					else
						child:SetTemplate()
						child:StyleButton()		
					end
					child.isSkinned = true
				end
			end
		end
	end)
	
	-- bonus
	BonusRollFrame:StripTextures()
	BonusRollFrame:CreateBD(true)
	BonusRollFrame.backdrop:SetFrameLevel(0)
	BonusRollFrame.PromptFrame.Icon:SetTexCoord(unpack(F.TexCoords))
	BonusRollFrame.PromptFrame.IconBackdrop = CreateFrame('Frame', nil, BonusRollFrame.PromptFrame)
	BonusRollFrame.PromptFrame.IconBackdrop:SetFrameLevel(BonusRollFrame.PromptFrame.IconBackdrop:GetFrameLevel() - 1)
	BonusRollFrame.PromptFrame.IconBackdrop:SetInside(BonusRollFrame.PromptFrame.Icon)
	BonusRollFrame.PromptFrame.IconBackdrop:SetTemplate()
	BonusRollFrame.PromptFrame.Timer.Bar:SetTexture(75/255,  175/255, 76/255)
	BonusRollFrame.PromptFrame.Timer.Bar:SetVertexColor(75/255,  175/255, 76/255)
	BonusRollFrame.BlackBackgroundHoist:StripTextures()
	BonusRollFrame.PromptFrame.Timer:CreateBD(true)
	
	LootFrame:StripTextures()
	LootFrameInset:StripTextures()
	LootFrame:SetHeight(LootFrame:GetHeight() - 30)
	SkinCloseButton(LootFrameCloseButton)

	LootFrame:SetTemplate()
	LootFramePortraitOverlay:SetParent(G.Misc.UIHider)

	for i=1, LootFrame:GetNumRegions() do
		local region = select(i, LootFrame:GetRegions());
		if(region:GetObjectType() == "FontString") then
			if(region:GetText() == ITEMS) then
				LootFrame.Title = region
			end
		end
	end

	LootFrame.Title:ClearAllPoints()
	LootFrame.Title:SetPoint("TOPLEFT", LootFrame, "TOPLEFT", 4, -4)
	LootFrame.Title:SetJustifyH("LEFT")

	for i=1, LOOTFRAME_NUMBUTTONS do
		local button = _G["LootButton"..i]
		_G["LootButton"..i.."NameFrame"]:Hide()
		F.SkinIconButton(button, true)
		
		_G["LootButton"..i.."IconQuestTexture"]:SetParent(G.Misc.UIHider)

		local point, attachTo, point2, x, y = button:GetPoint()
		button:ClearAllPoints()
		button:SetPoint(point, attachTo, point2, x, y+30)
	end

	hooksecurefunc("LootFrame_UpdateButton", function(index)
		local numLootItems = LootFrame.numLootItems;
		--Logic to determine how many items to show per page
		local numLootToShow = LOOTFRAME_NUMBUTTONS;
		local self = LootFrame;
		if( self.AutoLootTable ) then
			numLootItems = #self.AutoLootTable;
		end
		if ( numLootItems > LOOTFRAME_NUMBUTTONS ) then
			numLootToShow = numLootToShow - 1; -- make space for the page buttons
		end
		
		local button = _G["LootButton"..index];
		local slot = (numLootToShow * (LootFrame.page - 1)) + index;
		if(button and button:IsShown()) then
			local texture, item, quantity, quality, locked, isQuestItem, questId, isActive;
			if(LootFrame.AutoLootTablLootFramee)then
				local entry = LootFrame.AutoLootTable[slot];
				if( entry.hide ) then
					button:Hide();
					return;
				else
					texture = entry.texture;
					item = entry.item;
					quantity = entry.quantity;
					quality = entry.quality;
					locked = entry.locked;
					isQuestItem = entry.isQuestItem;
					questId = entry.questId;
					isActive = entry.isActive;
				end
			else
				texture, item, quantity, quality, locked, isQuestItem, questId, isActive = GetLootSlotInfo(slot);
			end

			if(texture) then
				if ( questId and not isActive ) then
					ActionButton_ShowOverlayGlow(button)
				elseif ( questId or isQuestItem ) then
					ActionButton_ShowOverlayGlow(button)		
				else
					ActionButton_HideOverlayGlow(button)
				end
			end
		end
	end)

	LootFrame:HookScript("OnShow", function(self)
		if(IsFishingLoot()) then
			self.Title:SetText('Fish')
		elseif(not UnitIsFriend("player", "target") and UnitIsDead"target") then
			self.Title:SetText(UnitName("target"))
		else
			self.Title:SetText(LOOT)
		end
	end)

	SkinNextPrevButton(LootFrameDownButton)
	SkinNextPrevButton(LootFrameUpButton)
	SquareButton_SetIcon(LootFrameUpButton, 'UP')
	SquareButton_SetIcon(LootFrameDownButton, 'DOWN')
end

tinsert(F.SkinFuncs['LanUI'], LoadSkin)