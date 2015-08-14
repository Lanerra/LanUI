local F, C, G = unpack(select(2, ...))
local bc = C.Media.BorderColor

----------------------------------------------------------------------------------------
--	Void Storage skin (written by shestak)
----------------------------------------------------------------------------------------

local function LoadSkin()
	local StripAllTextures = {
		"VoidStorageBorderFrame",
		"VoidStorageDepositFrame",
		"VoidStorageWithdrawFrame",
		"VoidStorageCostFrame",
		"VoidStorageStorageFrame",
		"VoidStoragePurchaseFrame",
		"VoidItemSearchBox",
	}

	for _, object in pairs(StripAllTextures) do
		_G[object]:StripTextures()
	end


	for i=1, 2 do
		local tab = VoidStorageFrame["Page"..i]
		tab:DisableDrawLayer("BACKGROUND")
		tab:StyleButton(nil, true)
		tab:GetNormalTexture():SetTexCoord(unpack(F.TexCoords))
		tab:GetNormalTexture():SetInside()
		tab:SetTemplate()
	end

	VoidStoragePurchaseFrame:SetFrameStrata('DIALOG')
	VoidStorageFrame:SetTemplate("Transparent")
	VoidStoragePurchaseFrame:SetTemplate("Default")
	VoidStorageFrameMarbleBg:Kill()
	VoidStorageFrameLines:Kill()
	select(2, VoidStorageFrame:GetRegions()):Kill()

	HandleButton(VoidStoragePurchaseButton)
	HandleButton(VoidStorageHelpBoxButton)
	HandleButton(VoidStorageTransferButton)

	HandleCloseButton(VoidStorageBorderFrame.CloseButton)
	VoidItemSearchBox:CreateBackdrop("Overlay")
	VoidItemSearchBox.backdrop:Point("TOPLEFT", 10, -1)
	VoidItemSearchBox.backdrop:Point("BOTTOMRIGHT", 4, 1)

	for i = 1, 9 do
		local button_d = _G["VoidStorageDepositButton"..i]
		local button_w = _G["VoidStorageWithdrawButton"..i]
		local icon_d = _G["VoidStorageDepositButton"..i.."IconTexture"]
		local icon_w = _G["VoidStorageWithdrawButton"..i.."IconTexture"]

		_G["VoidStorageDepositButton"..i.."Bg"]:Hide()
		_G["VoidStorageWithdrawButton"..i.."Bg"]:Hide()

		button_d:StyleButton()
		button_d:SetTemplate()
		button_d.IconBorder:SetAlpha(0)

		button_w:StyleButton()
		button_w:SetTemplate()
		button_w.IconBorder:SetAlpha(0)

		icon_d:SetTexCoord(unpack(F.TexCoords))
		icon_d:SetInside()

		icon_w:SetTexCoord(unpack(F.TexCoords))
		icon_w:SetInside()
	end

	for i = 1, 80 do
		local button = _G["VoidStorageStorageButton"..i]
		local icon = _G["VoidStorageStorageButton"..i.."IconTexture"]

		_G["VoidStorageStorageButton"..i.."Bg"]:Hide()

		button:StyleButton()
		button:SetTemplate()

		icon:SetTexCoord(unpack(F.TexCoords))
		icon:SetInside()
		button.IconBorder:SetAlpha(0)
	end

	hooksecurefunc("VoidStorage_ItemsUpdate", function(doDeposit, doContents)
		local self = VoidStorageFrame;
		if ( doDeposit ) then
			for i=1, 9 do
				local button = _G["VoidStorageDepositButton"..i]
				local _, _, quality = GetVoidTransferDepositInfo(i);
				if (quality and quality > LE_ITEM_QUALITY_COMMON and BAG_ITEM_QUALITY_COLORS[quality]) then
					button:SetBackdropBorderColor(BAG_ITEM_QUALITY_COLORS[quality].r, BAG_ITEM_QUALITY_COLORS[quality].g, BAG_ITEM_QUALITY_COLORS[quality].b);
				else
					button:SetTemplate()
				end
			end
		end

		if ( doContents ) then
			for i=1, 9 do
				local button = _G["VoidStorageWithdrawButton"..i]
				local _, _, quality = GetVoidTransferWithdrawalInfo(i);
				if (quality and quality > LE_ITEM_QUALITY_COMMON and BAG_ITEM_QUALITY_COLORS[quality]) then
					button:SetBackdropBorderColor(BAG_ITEM_QUALITY_COLORS[quality].r, BAG_ITEM_QUALITY_COLORS[quality].g, BAG_ITEM_QUALITY_COLORS[quality].b);
				else
					button:SetTemplate()
				end
			end

			for i = 1, 80 do
				local button = _G["VoidStorageStorageButton"..i]
				local _, _, _, _, _, quality = GetVoidItemInfo(self.page, i);
				if (quality and quality > LE_ITEM_QUALITY_COMMON and BAG_ITEM_QUALITY_COLORS[quality]) then
					button:SetBackdropBorderColor(BAG_ITEM_QUALITY_COLORS[quality].r, BAG_ITEM_QUALITY_COLORS[quality].g, BAG_ITEM_QUALITY_COLORS[quality].b);
				else
					button:SetTemplate()
				end
			end
		end
	end)
end

F.SkinFuncs['Blizzard_VoidStorageUI'] = LoadSkin