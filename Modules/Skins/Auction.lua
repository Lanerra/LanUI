local F, C, G = unpack(select(2, ...))
local bc = C.Media.BorderColor

local function LoadSkin()
	HandleCloseButton(AuctionFrameCloseButton)
	HandleScrollBar(AuctionsScrollFrameScrollBar)
	AuctionFrame:StripTextures(true)
	AuctionFrame:SetTemplate("Transparent")

	BrowseFilterScrollFrame:StripTextures()
	BrowseScrollFrame:StripTextures()
	AuctionsScrollFrame:StripTextures()
	BidScrollFrame:StripTextures()

	HandleDropDownBox(BrowseDropDown)
	HandleDropDownBox(PriceDropDown)
	HandleDropDownBox(DurationDropDown)
	HandleScrollBar(BrowseFilterScrollFrameScrollBar)
	HandleScrollBar(BrowseScrollFrameScrollBar)

	HandleCheckBox(IsUsableCheckButton)
	HandleCheckBox(ShowOnPlayerCheckButton)

	SideDressUpFrame:StripTextures(true)
	SideDressUpFrame:SetTemplate("Transparent")
	SideDressUpFrame:Point("TOPLEFT", AuctionFrame, "TOPRIGHT", 2, 0)
	HandleButton(SideDressUpModelResetButton)
	HandleCloseButton(SideDressUpModelCloseButton)

	--Progress Frame
	AuctionProgressFrame:StripTextures()
	AuctionProgressFrame:SetTemplate("Transparent")
	AuctionProgressFrameCancelButton:StyleButton()
	AuctionProgressFrameCancelButton:SetTemplate("Default")
	AuctionProgressFrameCancelButton:SetHitRectInsets(0, 0, 0, 0)
	AuctionProgressFrameCancelButton:GetNormalTexture():SetInside()
	AuctionProgressFrameCancelButton:GetNormalTexture():SetTexCoord(0.67, 0.37, 0.61, 0.26)
	AuctionProgressFrameCancelButton:Size(28, 28)
	AuctionProgressFrameCancelButton:Point("LEFT", AuctionProgressBar, "RIGHT", 8, 0)

	AuctionProgressBarIcon:SetTexCoord(unpack(F.TexCoords))

	local backdrop = CreateFrame("Frame", nil, AuctionProgressBarIcon:GetParent())
	backdrop:SetOutside(AuctionProgressBarIcon)
	backdrop:SetTemplate("Default")
	AuctionProgressBarIcon:SetParent(backdrop)

	AuctionProgressBarText:ClearAllPoints()
	AuctionProgressBarText:SetPoint("CENTER")

	AuctionProgressBar:StripTextures()
	AuctionProgressBar:CreateBackdrop("Default")
	AuctionProgressBar:SetStatusBarTexture(C.Media.StatusBar)
	AuctionProgressBar:SetStatusBarColor(1, 1, 0)

	HandleNextPrevButton(BrowseNextPageButton)
	HandleNextPrevButton(BrowsePrevPageButton)

	BrowseNextPageButton:ClearAllPoints()
	BrowseNextPageButton:SetPoint("TOPRIGHT", AuctionFrameBrowse, "TOPRIGHT", 70, -60)
	BrowsePrevPageButton:ClearAllPoints()
	BrowsePrevPageButton:SetPoint("TOPLEFT", AuctionFrameBrowse, "TOPLEFT", 658, -60)

	HandleCheckBox(ExactMatchCheckButton)
	local buttons = {
		"BrowseBidButton",
		"BidBidButton",
		"BrowseBuyoutButton",
		"BidBuyoutButton",
		"BrowseCloseButton",
		"BidCloseButton",
		"BrowseSearchButton",
		"AuctionsCreateAuctionButton",
		"AuctionsCancelAuctionButton",
		"AuctionsCloseButton",
		"BrowseResetButton",
		"AuctionsStackSizeMaxButton",
		"AuctionsNumStacksMaxButton",
	}

	for _, button in pairs(buttons) do
		HandleButton(_G[button], true)
	end

	--Fix Button Positions
	AuctionsCloseButton:Point("BOTTOMRIGHT", AuctionFrameAuctions, "BOTTOMRIGHT", 66, 10)
	AuctionsCancelAuctionButton:Point("RIGHT", AuctionsCloseButton, "LEFT", -4, 0)
	BidBuyoutButton:Point("RIGHT", BidCloseButton, "LEFT", -4, 0)
	BidBidButton:Point("RIGHT", BidBuyoutButton, "LEFT", -4, 0)
	BrowseBuyoutButton:Point("RIGHT", BrowseCloseButton, "LEFT", -4, 0)
	BrowseBidButton:Point("RIGHT", BrowseBuyoutButton, "LEFT", -4, 0)
	AuctionsItemButton:StripTextures()
	AuctionsItemButton:StyleButton()
	AuctionsItemButton:SetTemplate("Default", true)

	AuctionsItemButton:HookScript('OnEvent', function(self, event, ...)
		self:SetBackdropBorderColor(bc.r, bc.b, bc.g)
		if event == 'NEW_AUCTION_UPDATE' and self:GetNormalTexture() then
			local Quality = select(4, GetAuctionSellItemInfo())
			self:GetNormalTexture():SetTexCoord(unpack(F.TexCoords))
			self:GetNormalTexture():SetInside()
			if Quality and Quality > 1 and BAG_ITEM_QUALITY_COLORS[Quality] then
				self:SetBackdropBorderColor(BAG_ITEM_QUALITY_COLORS[Quality].r, BAG_ITEM_QUALITY_COLORS[Quality].g, BAG_ITEM_QUALITY_COLORS[Quality].b)
			end
		end
	end)

	local sorttabs = {
		"BrowseQualitySort",
		"BrowseLevelSort",
		"BrowseDurationSort",
		"BrowseHighBidderSort",
		"BrowseCurrentBidSort",
		"BidQualitySort",
		"BidLevelSort",
		"BidDurationSort",
		"BidBuyoutSort",
		"BidStatusSort",
		"BidBidSort",
		"AuctionsQualitySort",
		"AuctionsDurationSort",
		"AuctionsHighBidderSort",
		"AuctionsBidSort",
	}

	for _, sorttab in pairs(sorttabs) do
		_G[sorttab.."Left"]:Kill()
		_G[sorttab.."Middle"]:Kill()
		_G[sorttab.."Right"]:Kill()
	end
	
	AuctionFrameTab1:ClearAllPoints()
	AuctionFrameTab1:Point('TOPLEFT', AuctionFrame, 'BOTTOMLEFT', 4, 2)

	for i=1, AuctionFrame.numTabs do
		HandleTab(_G["AuctionFrameTab"..i])
	end
	
	for i=1, NUM_FILTERS_TO_DISPLAY do
		local tab = _G["AuctionFilterButton"..i]
		tab:StyleButton()
		_G["AuctionFilterButton"..i..'NormalTexture']:SetAlpha(0)
		_G["AuctionFilterButton"..i..'NormalTexture'].SetAlpha = F.Dummy
	end

	local editboxs = {
		"BrowseName",
		"BrowseMinLevel",
		"BrowseMaxLevel",
		"BrowseBidPriceGold",
		"BrowseBidPriceSilver",
		"BrowseBidPriceCopper",
		"BidBidPriceGold",
		"BidBidPriceSilver",
		"BidBidPriceCopper",
		"AuctionsStackSizeEntry",
		"AuctionsNumStacksEntry",
		"StartPriceGold",
		"StartPriceSilver",
		"StartPriceCopper",
		"BuyoutPriceGold",
		"BuyoutPriceSilver",
		"BuyoutPriceCopper"
	}

	for _, editbox in pairs(editboxs) do
		HandleEditBox(_G[editbox])
		_G[editbox]:SetTextInsets(1, 1, -1, 1)
	end
	_G["BrowseName"]:SetTextInsets(15, 15, -1, 1)
	BrowseMaxLevel:Point("LEFT", BrowseMinLevel, "RIGHT", 8, 0)
	AuctionsStackSizeEntry.backdrop:SetAllPoints()
	AuctionsNumStacksEntry.backdrop:SetAllPoints()

	for i=1, NUM_BROWSE_TO_DISPLAY do
		local button = _G["BrowseButton"..i]
		local icon = _G["BrowseButton"..i.."Item"]

		if _G["BrowseButton"..i.."ItemIconTexture"] then
			_G["BrowseButton"..i.."ItemIconTexture"]:SetTexCoord(unpack(F.TexCoords))
			_G["BrowseButton"..i.."ItemIconTexture"]:SetInside()
		end

		if icon then
			icon:StyleButton()
			icon:GetNormalTexture():SetTexture('')
			icon:SetTemplate("Default")
			icon.IconBorder:SetTexture('')
			hooksecurefunc(icon.IconBorder, 'SetVertexColor', function(self, r, g, b)
				icon:SetBackdropBorderColor(r, g, b)
			end)
			hooksecurefunc(icon.IconBorder, 'Hide', function(self, r, g, b)
				icon:SetBackdropBorderColor(bc.r, bc.b, bc.g)
			end)
		end

		if button then
			button:StripTextures()
			button:StyleButton()
			_G["BrowseButton"..i.."Highlight"] = button:GetHighlightTexture()
			button:GetHighlightTexture():ClearAllPoints()
			button:GetHighlightTexture():Point("TOPLEFT", icon, "TOPRIGHT", 2, 0)
			button:GetHighlightTexture():SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 5)
			button:GetPushedTexture():SetAllPoints(button:GetHighlightTexture())
		end
	end

	for i=1, NUM_AUCTIONS_TO_DISPLAY do
		local button = _G["AuctionsButton"..i]
		local icon = _G["AuctionsButton"..i.."Item"]

		_G["AuctionsButton"..i.."ItemIconTexture"]:SetTexCoord(unpack(F.TexCoords))
		_G["AuctionsButton"..i.."ItemIconTexture"]:SetInside()

		icon:StyleButton()
		icon:GetNormalTexture():SetTexture('')
		icon:SetTemplate("Default")
		icon.IconBorder:SetTexture('')
		hooksecurefunc(icon.IconBorder, 'SetVertexColor', function(self, r, g, b)
			icon:SetBackdropBorderColor(r, g, b)
		end)
		hooksecurefunc(icon.IconBorder, 'Hide', function(self, r, g, b)
			icon:SetBackdropBorderColor(bc.r, bc.b, bc.g)
		end)

		button:StripTextures()
		button:StyleButton()
		_G["AuctionsButton"..i.."Highlight"] = button:GetHighlightTexture()
		button:GetHighlightTexture():ClearAllPoints()
		button:GetHighlightTexture():Point("TOPLEFT", icon, "TOPRIGHT", 2, 0)
		button:GetHighlightTexture():SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 5)
		button:GetPushedTexture():SetAllPoints(button:GetHighlightTexture())
	end

	for i=1, NUM_BIDS_TO_DISPLAY do
		local button = _G["BidButton"..i]
		local icon = _G["BidButton"..i.."Item"]

		_G["BidButton"..i.."ItemIconTexture"]:SetTexCoord(unpack(F.TexCoords))
		_G["BidButton"..i.."ItemIconTexture"]:SetInside()

		icon:StyleButton()
		icon:GetNormalTexture():SetTexture('')
		icon:SetTemplate("Default")
		icon.IconBorder:SetTexture('')
		hooksecurefunc(icon.IconBorder, 'SetVertexColor', function(self, r, g, b)
			icon:SetBackdropBorderColor(r, g, b)
		end)
		hooksecurefunc(icon.IconBorder, 'Hide', function(self, r, g, b)
			icon:SetBackdropBorderColor(bc.r, bc.b, bc.g)
		end)

		button:StripTextures()
		button:StyleButton()
		_G["BidButton"..i.."Highlight"] = button:GetHighlightTexture()
		button:GetHighlightTexture():ClearAllPoints()
		button:GetHighlightTexture():Point("TOPLEFT", icon, "TOPRIGHT", 2, 0)
		button:GetHighlightTexture():SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 5)
		button:GetPushedTexture():SetAllPoints(button:GetHighlightTexture())
	end

	--Custom Backdrops
	AuctionFrameBrowse.bg1 = CreateFrame("Frame", nil, AuctionFrameBrowse)
	AuctionFrameBrowse.bg1:SetTemplate("Default")
	AuctionFrameBrowse.bg1:Point("TOPLEFT", 20, -103)
	AuctionFrameBrowse.bg1:Point("BOTTOMRIGHT", -575, 40)
	BrowseNoResultsText:SetParent(AuctionFrameBrowse.bg1)
	BrowseSearchCountText:SetParent(AuctionFrameBrowse.bg1)
	AuctionFrameBrowse.bg1:SetFrameLevel(AuctionFrameBrowse.bg1:GetFrameLevel() - 1)
	BrowseFilterScrollFrame:Height(300) --Adjust scrollbar height a little off

	AuctionFrameBrowse.bg2 = CreateFrame("Frame", nil, AuctionFrameBrowse)
	AuctionFrameBrowse.bg2:SetTemplate("Default")
	AuctionFrameBrowse.bg2:Point("TOPLEFT", AuctionFrameBrowse.bg1, "TOPRIGHT", 4, 0)
	AuctionFrameBrowse.bg2:Point("BOTTOMRIGHT", AuctionFrame, "BOTTOMRIGHT", -8, 40)
	AuctionFrameBrowse.bg2:SetFrameLevel(AuctionFrameBrowse.bg2:GetFrameLevel() - 1)
	BrowseScrollFrame:Height(300) --Adjust scrollbar height a little off

	AuctionFrameBid.bg = CreateFrame("Frame", nil, AuctionFrameBid)
	AuctionFrameBid.bg:SetTemplate("Default")
	AuctionFrameBid.bg:Point("TOPLEFT", 22, -72)
	AuctionFrameBid.bg:Point("BOTTOMRIGHT", 66, 39)
	AuctionFrameBid.bg:SetFrameLevel(AuctionFrameBid.bg:GetFrameLevel() - 1)
	BidScrollFrame:Height(332)

	AuctionsScrollFrame:Height(336)
	AuctionFrameAuctions.bg1 = CreateFrame("Frame", nil, AuctionFrameAuctions)
	AuctionFrameAuctions.bg1:SetTemplate("Default")
	AuctionFrameAuctions.bg1:Point("TOPLEFT", 15, -70)
	AuctionFrameAuctions.bg1:Point("BOTTOMRIGHT", -545, 35)
	AuctionFrameAuctions.bg1:SetFrameLevel(AuctionFrameAuctions.bg1:GetFrameLevel() - 2)

	AuctionFrameAuctions.bg2 = CreateFrame("Frame", nil, AuctionFrameAuctions)
	AuctionFrameAuctions.bg2:SetTemplate("Default")
	AuctionFrameAuctions.bg2:Point("TOPLEFT", AuctionFrameAuctions.bg1, "TOPRIGHT", 3, 0)
	AuctionFrameAuctions.bg2:Point("BOTTOMRIGHT", AuctionFrame, -8, 35)
	AuctionFrameAuctions.bg2:SetFrameLevel(AuctionFrameAuctions.bg2:GetFrameLevel() - 2)
	
	--WoW Token Category
	HandleButton(BrowseWowTokenResults.Buyout)
	BrowseWowTokenResultsToken:CreateBackdrop("Default")
	BrowseWowTokenResultsTokenIconTexture:SetTexCoord(unpack(F.TexCoords))
	BrowseWowTokenResultsToken.backdrop:SetOutside(BrowseWowTokenResultsTokenIconTexture)
	BrowseWowTokenResultsToken.backdrop:SetBackdropBorderColor(BrowseWowTokenResultsToken.IconBorder:GetVertexColor())
	BrowseWowTokenResultsToken.backdrop:SetFrameLevel(BrowseWowTokenResultsToken:GetFrameLevel())
	BrowseWowTokenResultsToken.IconBorder:SetTexture(nil)
	BrowseWowTokenResultsToken.ItemBorder:SetTexture(nil)
	
	--WoW Token Tutorial Frame
	WowTokenGameTimeTutorial:CreateBackdrop("Transparent")
	HandleCloseButton(WowTokenGameTimeTutorial.CloseButton)
	HandleButton(StoreButton)
	WowTokenGameTimeTutorial.Inset.InsetBorderBottom:SetAlpha(0)
	WowTokenGameTimeTutorial.Inset.InsetBorderRight:SetAlpha(0)
	WowTokenGameTimeTutorial.Inset.InsetBorderBottomLeft:SetAlpha(0)
	WowTokenGameTimeTutorial.Inset.InsetBorderBottomRight:SetAlpha(0)
	WowTokenGameTimeTutorial.Inset.InsetBorderTopLeft:SetAlpha(0)
	WowTokenGameTimeTutorial.Inset.InsetBorderLeft:SetAlpha(0)
	WowTokenGameTimeTutorial.Inset.InsetBorderTopRight:SetAlpha(0)
	WowTokenGameTimeTutorial.Inset.InsetBorderTop:SetAlpha(0)
	WowTokenGameTimeTutorial.Inset.Bg:SetAlpha(0)
	WowTokenGameTimeTutorialTitleBg:SetAlpha(0)
	WowTokenGameTimeTutorialBg:SetAlpha(0)
	WowTokenGameTimeTutorialTopRightCorner:SetAlpha(0)
	WowTokenGameTimeTutorialTopLeftCorner:SetAlpha(0)
	WowTokenGameTimeTutorialTopBorder:SetAlpha(0)
	WowTokenGameTimeTutorialBotLeftCorner:SetAlpha(0)
	WowTokenGameTimeTutorialBotRightCorner:SetAlpha(0)
	WowTokenGameTimeTutorialBottomBorder:SetAlpha(0)
	WowTokenGameTimeTutorialLeftBorder:SetAlpha(0)
	WowTokenGameTimeTutorialRightBorder:SetAlpha(0)
end

F.SkinFuncs['Blizzard_AuctionUI'] = LoadSkin

-- macro while inactive: /script BlackMarket_LoadUI() ShowUIPanel(BlackMarketFrame)

local function SkinTab(tab)
	tab.Left:SetAlpha(0)
	if tab.Middle then
		tab.Middle:SetAlpha(0)
	end
	tab.Right:SetAlpha(0)
end

local function LoadSecondarySkin()
	BlackMarketFrame:StripTextures()
	BlackMarketFrame:CreateBackdrop('Transparent')
	BlackMarketFrame.backdrop:SetAllPoints()

	BlackMarketFrame.Inset:StripTextures()
	BlackMarketFrame.Inset:CreateBackdrop()
	BlackMarketFrame.Inset.backdrop:SetAllPoints()

	HandleCloseButton(BlackMarketFrame.CloseButton)
	HandleScrollBar(BlackMarketScrollFrameScrollBar, 4)
	SkinTab(BlackMarketFrame.ColumnName)
	SkinTab(BlackMarketFrame.ColumnLevel)
	SkinTab(BlackMarketFrame.ColumnType)
	SkinTab(BlackMarketFrame.ColumnDuration)
	SkinTab(BlackMarketFrame.ColumnHighBidder)
	SkinTab(BlackMarketFrame.ColumnCurrentBid)

	BlackMarketFrame.MoneyFrameBorder:StripTextures()
	HandleEditBox(BlackMarketBidPriceGold)
	BlackMarketBidPriceGold.backdrop:Point("TOPLEFT", -2, 0)
	BlackMarketBidPriceGold.backdrop:Point("BOTTOMRIGHT", -2, 0)

	HandleButton(BlackMarketFrame.BidButton)

	hooksecurefunc('BlackMarketScrollFrame_Update', function()
		local buttons = BlackMarketScrollFrame.buttons;
		local numButtons = #buttons;
		local offset = HybridScrollFrame_GetOffset(BlackMarketScrollFrame);
		local numItems = C_BlackMarket.GetNumItems();

		for i = 1, numButtons do
			local button = buttons[i];
			local index = offset + i; -- adjust index


			if not button.skinned then
				HandleItemButton(button.Item)
				button:StripTextures('BACKGROUND')
				button:StyleButton()
				button.skinned = true
			end

			if ( index <= numItems ) then
				local name, texture = C_BlackMarket.GetItemInfoByIndex(index);
				if ( name ) then
					button.Item.IconTexture:SetTexture(texture);
				end
			end
		end
	end)

	BlackMarketFrame.HotDeal:StripTextures()
	HandleItemButton(BlackMarketFrame.HotDeal.Item)
	BlackMarketFrame.HotDeal.Item.hover:SetAllPoints()
	BlackMarketFrame.HotDeal.Item.pushed:SetAllPoints()

	--HandleButton(BlackMarketFrame.HotDeal.BidButton)
	--HandleEditBox(BlackMarketHotItemBidPriceGold)

	for i=1, BlackMarketFrame:GetNumRegions() do
		local region = select(i, BlackMarketFrame:GetRegions())
		if region and region:GetObjectType() == 'FontString' and region:GetText() == BLACK_MARKET_TITLE then
			region:ClearAllPoints()
			region:SetPoint('TOP', BlackMarketFrame, 'TOP', 0, -4)
		end
	end
end
F.SkinFuncs['Blizzard_BlackMarketUI'] = LoadSecondarySkin