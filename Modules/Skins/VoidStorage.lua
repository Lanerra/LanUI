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

	VoidStorageFrame:SetTemplate()
	VoidStoragePurchaseFrame:SetTemplate()
	VoidStorageFrameMarbleBg:Kill()
	VoidStorageFrameLines:Kill()
	select(2, VoidStorageFrame:GetRegions()):Kill()

	VoidStoragePurchaseButton:SkinButton()
	VoidStorageHelpBoxButton:SkinButton()
	VoidStorageTransferButton:SkinButton()

	VoidStorageBorderFrame.CloseButton:SkinCloseButton()
	VoidItemSearchBox:CreateBD()
	VoidItemSearchBox.backdrop:Point('TOPLEFT', 10, -1)
	VoidItemSearchBox.backdrop:Point('BOTTOMRIGHT', 4, 1)

	for i = 1, 9 do
		local button_d = _G['VoidStorageDepositButton'..i]
		local button_w = _G['VoidStorageWithdrawButton'..i]
		local icon_d = _G['VoidStorageDepositButton'..i..'IconTexture']
		local icon_w = _G['VoidStorageWithdrawButton'..i..'IconTexture']

		_G['VoidStorageDepositButton'..i..'Bg']:Hide()
		_G['VoidStorageWithdrawButton'..i..'Bg']:Hide()

		button_d:StyleButton()
		button_d:SetTemplate(true)

		button_w:StyleButton()
		button_w:SetTemplate(true)

		icon_d:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		icon_d:ClearAllPoints()
		icon_d:Point('TOPLEFT', 2, -2)
		icon_d:Point('BOTTOMRIGHT', -2, 2)

		icon_w:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		icon_w:ClearAllPoints()
		icon_w:Point('TOPLEFT', 2, -2)
		icon_w:Point('BOTTOMRIGHT', -2, 2)
	end

	for i = 1, 80 do
		local button = _G['VoidStorageStorageButton'..i]
		local icon = _G['VoidStorageStorageButton'..i..'IconTexture']

		_G['VoidStorageStorageButton'..i..'Bg']:Hide()

		button:StyleButton()
		button:SetTemplate()

		icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		icon:ClearAllPoints()
		icon:Point('TOPLEFT', 2, -2)
		icon:Point('BOTTOMRIGHT', -2, 2)
	end
	
	-- dress
	SideDressUpFrame:StripTextures(true)
	SideDressUpFrame:CreateBD(true)

	SideDressUpModelResetButton:SkinButton()
	SideDressUpModelCloseButton:StripTextures()
	SideDressUpModelCloseButton:SkinCloseButton()
end

F.SkinFuncs['Blizzard_VoidStorageUI'] = LoadSkin