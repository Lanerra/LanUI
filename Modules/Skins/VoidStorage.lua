local F, C, G = unpack(select(2, ...))
local bc = C.Media.BorderColor

----------------------------------------------------------------------------------------
--	Void Storage skin (written by shestak)
----------------------------------------------------------------------------------------

local function LoadSkin()
	local StripAllTextures = {
		'VoidStorageBorderFrame',
		'VoidStorageDepositFrame',
		'VoidStorageWithdrawFrame',
		'VoidStorageCostFrame',
		'VoidStorageStorageFrame',
		'VoidStoragePurchaseFrame',
		'VoidItemSearchBox',
	}

	for _, object in pairs(StripAllTextures) do
		_G[object]:StripTextures()
	end

	for i=1, 2 do
		local tab = VoidStorageFrame["Page"..i]
		local normTex = tab:GetNormalTexture()
		local texture = normTex:GetTexture()
		tab:StripTextures()

		tab:StyleButton(nil, true)
		tab:SetNormalTexture(texture)
		normTex:SetTexCoord(unpack(F.TexCoords))
		normTex:SetInside()
		tab:SetTemplate()
	end

	VoidStoragePurchaseFrame:SetFrameStrata('DIALOG')
	VoidStorageFrame:SetTemplate()
	VoidStoragePurchaseFrame:SetTemplate()
	VoidStorageFrameMarbleBg:Kill()
	VoidStorageFrameLines:Kill()
	select(2, VoidStorageFrame:GetRegions()):Kill()

	StyleButton(VoidStoragePurchaseButton)
	StyleButton(VoidStorageHelpBoxButton)
	StyleButton(VoidStorageTransferButton)

	SkinCloseButton(VoidStorageBorderFrame.CloseButton)
	VoidItemSearchBox:CreateBD()
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

		button_w:StyleButton()
		button_w:SetTemplate()

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
	end
end

F.SkinFuncs['Blizzard_VoidStorageUI'] = LoadSkin