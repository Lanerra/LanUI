local F, C, G = unpack(select(2, ...))
local bc = C.Media.BorderColor

local function LoadSkin()
	AuctionFrameCloseButton:SkinCloseButton()
	AuctionFrame:StripTextures(true)
	AuctionFrame:SetTemplate()
	
	BrowseFilterScrollFrame:StripTextures()
	BrowseScrollFrame:StripTextures()
	AuctionsScrollFrame:StripTextures()
	BidScrollFrame:StripTextures()
	
	BrowseDropDown:SkinDropDownBox()
	PriceDropDown:SkinDropDownBox()
	DurationDropDown:SkinDropDownBox()
	
	IsUsableCheckButton:SkinCheckBox()
	ShowOnPlayerCheckButton:SkinCheckBox()

	-- Dress Frame
	do
		local frame = _G['SideDressUpFrame']
		local reset = _G['SideDressUpModelResetButton']
		local close = _G['SideDressUpModelCloseButton']
		local left = _G['SideDressUpFrameModelRotateLeftButton']
		local right = _G['SideDressUpFrameModelRotateRightButton']
		
		frame:HookScript('OnShow', function(self) self:StripTextures() frame:SetTemplate() end)
		frame:Point('TOPLEFT', AuctionFrame, 'TOPRIGHT', 16, 0)
		reset:SkinButton()
		close:StripTextures()
		close:SkinCloseButton()
		if left and right then
			left:SkinRotateButton()
			right:SkinRotateButton()
			right:Point('TOPLEFT', left, 'TOPRIGHT', 4, 0)
		end
	end
	
	--Progress Frame
	AuctionProgressFrame:StripTextures()
	AuctionProgressFrame:SetTemplate()
	AuctionProgressFrameCancelButton:Reskin()
	AuctionProgressFrameCancelButton:SetHitRectInsets(0, 0, 0, 0)
	AuctionProgressFrameCancelButton:GetNormalTexture():ClearAllPoints()
	AuctionProgressFrameCancelButton:GetNormalTexture():Point('TOPLEFT', 2, -2)
	AuctionProgressFrameCancelButton:GetNormalTexture():Point('BOTTOMRIGHT', -2, 2)
	AuctionProgressFrameCancelButton:GetNormalTexture():SetTexCoord(0.67, 0.37, 0.61, 0.26)
	AuctionProgressFrameCancelButton:Size(28, 28)
	AuctionProgressFrameCancelButton:Point('LEFT', AuctionProgressBar, 'RIGHT', 8, 0)
	
	AuctionProgressBarIcon:SetTexCoord(0.67, 0.37, 0.61, 0.26)
	
	local backdrop = CreateFrame('Frame', nil, AuctionProgressBarIcon:GetParent())
	backdrop:Point('TOPLEFT', AuctionProgressBarIcon, 'TOPLEFT', -2, 2)
	backdrop:Point('BOTTOMRIGHT', AuctionProgressBarIcon, 'BOTTOMRIGHT', 2, -2)
	backdrop:CreateBD()
	AuctionProgressBarIcon:SetParent(backdrop)
	
	AuctionProgressBarText:ClearAllPoints()
	AuctionProgressBarText:SetPoint('CENTER')
	
	AuctionProgressBar:StripTextures()
	AuctionProgressBar:CreateBD()
	AuctionProgressBar.backdrop:SetOutside(AuctionProgressBar)
	AuctionProgressBar:SetStatusBarTexture(C.Media.StatusBar)
	AuctionProgressBar:SetStatusBarColor(1, 1, 0)
	
	BrowseNextPageButton:SkinNextPrevButton()
	BrowsePrevPageButton:SkinNextPrevButton()
	
	BrowseNextPageButton:SetPoint("TOPRIGHT", AuctionFrameBrowse, "TOPRIGHT", 70, -60)
	BrowsePrevPageButton:SetPoint("TOPLEFT", AuctionFrameBrowse, "TOPLEFT", 658, -60)
	
	SkinCheckBox(ExactMatchCheckButton)
	
	local buttons = {
		'BrowseBidButton',
		'BidBidButton',
		'BrowseBuyoutButton',
		'BidBuyoutButton',
		'BrowseCloseButton',
		'BidCloseButton',
		'BrowseSearchButton',
		'AuctionsCreateAuctionButton',
		'AuctionsCancelAuctionButton',
		'AuctionsCloseButton',
		'BrowseResetButton',
		'AuctionsStackSizeMaxButton',
		'AuctionsNumStacksMaxButton',
	}
	
	for _, button in pairs(buttons) do
		_G[button]:SkinButton()
	end
	
	--Fix Button Positions
	AuctionsCloseButton:Point('BOTTOMRIGHT', AuctionFrameAuctions, 'BOTTOMRIGHT', 66, 10)
	AuctionsCancelAuctionButton:Point('RIGHT', AuctionsCloseButton, 'LEFT', -4, 0)
	BidBuyoutButton:Point('RIGHT', BidCloseButton, 'LEFT', -4, 0)
	BidBidButton:Point('RIGHT', BidBuyoutButton, 'LEFT', -4, 0)
	BrowseBuyoutButton:Point('RIGHT', BrowseCloseButton, 'LEFT', -4, 0)
	BrowseBidButton:Point('RIGHT', BrowseBuyoutButton, 'LEFT', -4, 0)		
	AuctionsItemButton:StripTextures()
	AuctionsItemButton:Reskin()
	BrowseResetButton:ClearAllPoints()
	BrowseResetButton:Point('TOPLEFT', AuctionFrameBrowse, 'TOPLEFT', 81, -74)
	BrowseSearchButton:Point('TOPRIGHT', AuctionFrameBrowse, 'TOPRIGHT', 25, -34)
	
	AuctionsItemButton:SetScript('OnUpdate', function()
		if AuctionsItemButton:GetNormalTexture() then
			AuctionsItemButton:GetNormalTexture():SetTexCoord(.08, .92, .08, .92)
			AuctionsItemButton:GetNormalTexture():ClearAllPoints()
			AuctionsItemButton:GetNormalTexture():Point('TOPLEFT', 2, -2)
			AuctionsItemButton:GetNormalTexture():Point('BOTTOMRIGHT', -2, 2)
		end
	end)
	
	local sorttabs = {
		'BrowseQualitySort',
		'BrowseLevelSort',
		'BrowseDurationSort',
		'BrowseHighBidderSort',
		'BrowseCurrentBidSort',
		'BidQualitySort',
		'BidLevelSort',
		'BidDurationSort',
		'BidBuyoutSort',
		'BidStatusSort',
		'BidBidSort',
		'AuctionsQualitySort',
		'AuctionsDurationSort',
		'AuctionsHighBidderSort',
		'AuctionsBidSort',
	}
	
	for _, sorttab in pairs(sorttabs) do
		_G[sorttab..'Left']:Kill()
		_G[sorttab..'Middle']:Kill()
		_G[sorttab..'Right']:Kill()
	end

	AuctionFrameTab1:ClearAllPoints()
	AuctionFrameTab1:Point('TOPLEFT', AuctionFrame, 'BOTTOMLEFT', 4, 3)
	
	for i=1, AuctionFrame.numTabs do
		_G['AuctionFrameTab'..i]:SkinTab()
		
		if i ~= 1 then
			_G['AuctionFrameTab'..i]:ClearAllPoints()
			_G['AuctionFrameTab'..i]:SetPoint('LEFT', _G['AuctionFrameTab'..i-1], 'RIGHT', 4, 0)
		end
	end
	
	for i=1, NUM_FILTERS_TO_DISPLAY do
		local tab = _G['AuctionFilterButton'..i]
		tab:StripTextures()
		tab:StyleButton()
	end
	
	local editboxs = {
		'BrowseName',
		'BrowseMinLevel',
		'BrowseMaxLevel',
		'BrowseBidPriceGold',
		'BrowseBidPriceSilver',
		'BrowseBidPriceCopper',
		'BidBidPriceGold',
		'BidBidPriceSilver',
		'BidBidPriceCopper',
		'AuctionsStackSizeEntry',
		'AuctionsNumStacksEntry',
		'StartPriceGold',
		'StartPriceSilver',
		'StartPriceCopper',
		'BuyoutPriceGold',
		'BuyoutPriceSilver',
		'BuyoutPriceCopper'			
	}
	
	for _, editbox in pairs(editboxs) do
		_G[editbox]:SkinEditBox()
		_G[editbox]:SetTextInsets(1, 1, -1, 1)
	end
	_G['BrowseName']:SetTextInsets(15, 15, -1, 1)
	BrowseMaxLevel:Point('LEFT', BrowseMinLevel, 'RIGHT', 8, 0)
	AuctionsStackSizeEntry.backdrop:SetAllPoints()
	AuctionsNumStacksEntry.backdrop:SetAllPoints()
	
	for i=1, NUM_BROWSE_TO_DISPLAY do
		local button = _G['BrowseButton'..i]
		local icon = _G['BrowseButton'..i..'Item']
		
		if _G['BrowseButton'..i..'ItemIconTexture'] then
			_G['BrowseButton'..i..'ItemIconTexture']:SetTexCoord(.08, .92, .08, .92)
			_G['BrowseButton'..i..'ItemIconTexture']:ClearAllPoints()
			_G['BrowseButton'..i..'ItemIconTexture']:Point('TOPLEFT', 2, -2)
			_G['BrowseButton'..i..'ItemIconTexture']:Point('BOTTOMRIGHT', -2, 2)
		end
		
		if icon then
			icon:StyleButton()
			--TODO: Find a better method to ensure that the icon:GetNormalTexture doesn't return after clicking
			icon:HookScript('OnUpdate', function() icon:GetNormalTexture():Kill() end)
			
			icon:CreateBD(true)
			icon.backdrop:SetAllPoints()
		end

		button:StripTextures()
		button:StyleButton()
		button:SetTemplate()
		_G['BrowseButton'..i..'Highlight'] = button:GetHighlightTexture()
		button:GetHighlightTexture():ClearAllPoints()
		button:GetHighlightTexture():Point('TOPLEFT', icon, 'TOPRIGHT', 2, 0)
		button:GetHighlightTexture():SetPoint('BOTTOMRIGHT', button, 'BOTTOMRIGHT', -2, 5)
		button:GetPushedTexture():SetAllPoints(button:GetHighlightTexture())
	end
	
	for i=1, NUM_AUCTIONS_TO_DISPLAY do
		local button = _G['AuctionsButton'..i]
		local icon = _G['AuctionsButton'..i..'Item']
		
		_G['AuctionsButton'..i..'ItemIconTexture']:SetTexCoord(.08, .92, .08, .92)
		_G['AuctionsButton'..i..'ItemIconTexture'].SetTexCoord = F.Dummy
		_G['AuctionsButton'..i..'ItemIconTexture']:ClearAllPoints()
		_G['AuctionsButton'..i..'ItemIconTexture']:Point('TOPLEFT', 2, -2)
		_G['AuctionsButton'..i..'ItemIconTexture']:Point('BOTTOMRIGHT', -2, 2)
		
		icon:StyleButton()
		--TODO: Find a better method to ensure that the icon:GetNormalTexture doesn't return after clicking
		icon:HookScript('OnUpdate', function() icon:GetNormalTexture():Kill() end)
		
		icon:CreateBD(true)
		icon.backdrop:SetAllPoints()

		button:StripTextures()
		button:StyleButton()
		_G['AuctionsButton'..i..'Highlight'] = button:GetHighlightTexture()
		button:GetHighlightTexture():ClearAllPoints()
		button:GetHighlightTexture():Point('TOPLEFT', icon, 'TOPRIGHT', 2, 0)
		button:GetHighlightTexture():SetPoint('BOTTOMRIGHT', button, 'BOTTOMRIGHT', -2, 5)
		button:GetPushedTexture():SetAllPoints(button:GetHighlightTexture())		
	end
	
	for i=1, NUM_BIDS_TO_DISPLAY do
		local button = _G['BidButton'..i]
		local icon = _G['BidButton'..i..'Item']
		
		_G['BidButton'..i..'ItemIconTexture']:SetTexCoord(.08, .92, .08, .92)
		_G['BidButton'..i..'ItemIconTexture']:ClearAllPoints()
		_G['BidButton'..i..'ItemIconTexture']:Point('TOPLEFT', 2, -2)
		_G['BidButton'..i..'ItemIconTexture']:Point('BOTTOMRIGHT', -2, 2)
		
		icon:StyleButton()
		icon:HookScript('OnUpdate', function() icon:GetNormalTexture():Kill() end)
		
		icon:CreateBD(true)
		icon.backdrop:SetAllPoints()

		button:StripTextures()
		button:StyleButton()
		button:SetTemplate()
		_G['BidButton'..i..'Highlight'] = button:GetHighlightTexture()
		button:GetHighlightTexture():ClearAllPoints()
		button:GetHighlightTexture():Point('TOPLEFT', icon, 'TOPRIGHT', 2, 0)
		button:GetHighlightTexture():SetPoint('BOTTOMRIGHT', button, 'BOTTOMRIGHT', -2, 5)
		button:GetPushedTexture():SetAllPoints(button:GetHighlightTexture())			
	end
	
	--Custom Backdrops
	BrowseFilterScrollFrame:Height(300) --Adjust scrollbar height a little off

	BrowseScrollFrame:Height(300) --Adjust scrollbar height a little off
	
	AuctionFrameBid.bg = CreateFrame('Frame', nil, AuctionFrameBid)
	AuctionFrameBid.bg:SetTemplate()
	AuctionFrameBid.bg:Point('TOPLEFT', 22, -72)
	AuctionFrameBid.bg:Point('BOTTOMRIGHT', 66, 39)
	BidScrollFrame:Height(332)	

	AuctionsScrollFrame:Height(336)	
	AuctionFrameAuctions.bg1 = CreateFrame('Frame', nil, AuctionFrameAuctions)
	AuctionFrameAuctions.bg1:SetTemplate()
	AuctionFrameAuctions.bg1:Point('TOPLEFT', 15, -70)
	AuctionFrameAuctions.bg1:Point('BOTTOMRIGHT', -545, 35)  
	AuctionFrameAuctions.bg1:SetFrameLevel(AuctionFrameAuctions.bg1:GetFrameLevel() - 2)	
	
	AuctionFrameAuctions.bg2 = CreateFrame('Frame', nil, AuctionFrameAuctions)
	AuctionFrameAuctions.bg2:SetTemplate()
	AuctionFrameAuctions.bg2:Point('TOPLEFT', AuctionFrameAuctions.bg1, 'TOPRIGHT', 3, 0)
	AuctionFrameAuctions.bg2:Point('BOTTOMRIGHT', AuctionFrame, -8, 35)  
	AuctionFrameAuctions.bg2:SetFrameLevel(AuctionFrameAuctions.bg2:GetFrameLevel() - 2)

	BrowseFilterScrollFrameScrollBar:SkinScrollBar()
	BrowseScrollFrameScrollBar:SkinScrollBar()
	AuctionsScrollFrameScrollBar:SkinScrollBar()
	BidScrollFrameScrollBar:SkinScrollBar()
end

F.SkinFuncs['Blizzard_AuctionUI'] = LoadSkin

-- macro while inactive: /script BlackMarket_LoadUI() ShowUIPanel(BlackMarketFrame)

local function LoadSecondarySkin()
		BlackMarketFrame:StripTextures()
		BlackMarketFrame.Inset:StripTextures()
		BlackMarketFrame:SetTemplate()
		BlackMarketScrollFrameScrollBar:SkinScrollBar()
		BlackMarketFrame.MoneyFrameBorder:StripTextures()
		BlackMarketBidPriceGold:SkinEditBox()
		BlackMarketBidPriceGold:Height(16)
		BlackMarketFrame.HotDeal.Item.IconTexture:SetTexCoord(.08, .92, .08, .92)
		BlackMarketFrame.BidButton:SkinButton()
		BlackMarketFrame.BidButton:Height(20)
		BlackMarketFrame.CloseButton:SkinCloseButton()
		
		local tabs = {'ColumnName', 'ColumnLevel', 'ColumnType', 'ColumnDuration', 'ColumnHighBidder', 'ColumnCurrentBid'}
		for _, tab in pairs(tabs) do
			local tab = BlackMarketFrame[tab]
			tab.Left:Hide()
			tab.Middle:Hide()
			tab.Right:Hide()
			
			tab:CreateB()
			tab.backdrop:Point('TOPLEFT', tab, 3, 0)
			tab.backdrop:Point('BOTTOMRIGHT', tab, -3, 0)	
		end
		
	hooksecurefunc('BlackMarketScrollFrame_Update', function()
		local buttons = BlackMarketScrollFrame.buttons
		local numButtons = #buttons
		local offset = HybridScrollFrame_GetOffset(BlackMarketScrollFrame)
		local numItems = C_BlackMarket.GetNumItems()
		
		for i = 1, numButtons do
			local button = buttons[i]
			local index = offset + i
			
			
			if not button.skinned then
				button.Item:StripTextures()
				button.Item:SetTemplate()
				button.Item.IconTexture:SetInside()
				button.Item.IconTexture:SetTexCoord(.1,.9,.1,.9)
				button.Item:StyleButton()
				button:StripTextures()
				button.skinned = true
			end
			
			if ( index <= numItems ) then
				local name, texture = C_BlackMarket.GetItemInfoByIndex(index)
				if ( name ) then
					button.Item.IconTexture:SetTexture(texture)
				end
			end
		end
	end)
	
	BlackMarketFrame.HotDeal:StripTextures()
	BlackMarketFrame.HotDeal.Item:CreateBD(true)
	BlackMarketFrame.HotDeal.Item:StyleButton()
	BlackMarketFrame.HotDeal.Item.hover:SetAllPoints()
	BlackMarketFrame.HotDeal.Item.pushed:SetAllPoints()

	--BlackMarketHotItemBidPriceGold:SkinEditBox()
	
	for i=1, BlackMarketFrame:GetNumRegions() do
		local region = select(i, BlackMarketFrame:GetRegions())
		if region and region:GetObjectType() == 'FontString' and region:GetText() == BLACK_MARKET_TITLE then
			region:ClearAllPoints()
			region:SetPoint('TOP', BlackMarketFrame, 'TOP', 0, -4)
		end
	end
end
F.SkinFuncs['Blizzard_BlackMarketUI'] = LoadSecondarySkin