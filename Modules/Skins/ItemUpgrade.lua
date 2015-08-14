local F, C, G = unpack(select(2, ...))
local bc = C.Media.BorderColor

local function LoadSkin()
	ItemUpgradeFrame:StripTextures()
	ItemUpgradeFrame:SetTemplate('Transparent')
	--ItemUpgradeFrameShadows:Kill()
	--ItemUpgradeFrameInset:Kill()

	HandleCloseButton(ItemUpgradeFrameCloseButton)

	HandleItemButton(ItemUpgradeFrame.ItemButton, true)

	hooksecurefunc('ItemUpgradeFrame_Update', function()
		if GetItemUpgradeItemInfo() then
			ItemUpgradeFrame.ItemButton.IconTexture:SetAlpha(1)
			ItemUpgradeFrame.ItemButton.IconTexture:SetTexCoord(unpack(F.TexCoords))
		else
			ItemUpgradeFrame.ItemButton.IconTexture:SetAlpha(0)
		end
	end)

	ItemUpgradeFrameMoneyFrame:StripTextures()
	HandleButton(ItemUpgradeFrameUpgradeButton, true)
	ItemUpgradeFrame.FinishedGlow:Kill()
	ItemUpgradeFrame.ButtonFrame:DisableDrawLayer('BORDER')
end

F.SkinFuncs['Blizzard_ItemUpgradeUI'] = LoadSkin