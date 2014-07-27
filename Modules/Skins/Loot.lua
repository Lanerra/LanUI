local F, C, G = unpack(select(2, ...))
local bc = C.Media.BorderColor

local function LoadSkin()
	local frame = MissingLootFrame
	local close = MissingLootFramePassButton

	frame:StripTextures()
	frame:SetTemplate()

	MissingLootFramePassButton:SkinCloseButton()
	
	local function SkinButton()
		local number = GetNumMissingLootItems()
		for i = 1, number do
			local slot = _G['MissingLootFrameItem'..i]
			local icon = slot.icon
			
			if not slot.isSkinned then
				slot:StripTextures()
				slot:SetTemplate()
				slot:StyleButton()
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
	hooksecurefunc('MissingLootFrame_Show', SkinButton)
	
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
	BonusRollFrame.PromptFrame.Icon:SetTexCoord(.1,.9,.1,.9)
	BonusRollFrame.PromptFrame.IconBackdrop = CreateFrame('Frame', nil, BonusRollFrame.PromptFrame)
	BonusRollFrame.PromptFrame.IconBackdrop:SetFrameLevel(BonusRollFrame.PromptFrame.IconBackdrop:GetFrameLevel() - 1)
	BonusRollFrame.PromptFrame.IconBackdrop:SetInside(BonusRollFrame.PromptFrame.Icon)
	BonusRollFrame.PromptFrame.IconBackdrop:SetTemplate()
	BonusRollFrame.PromptFrame.Timer.Bar:SetTexture(75/255,  175/255, 76/255)
	BonusRollFrame.PromptFrame.Timer.Bar:SetVertexColor(75/255,  175/255, 76/255)
	BonusRollFrame.BlackBackgroundHoist:StripTextures()
	BonusRollFrame.PromptFrame.Timer:CreateBD(true)
end

tinsert(F.SkinFuncs['LanUI'], LoadSkin)