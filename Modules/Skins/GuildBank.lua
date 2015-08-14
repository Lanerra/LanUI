local F, C, G = unpack(select(2, ...))
local bc = C.Media.BorderColor

local function LoadSkin()
	GuildBankFrame:StripTextures()
	GuildBankFrame:SetTemplate("Transparent")
	GuildBankEmblemFrame:StripTextures(true)
	GuildBankMoneyFrameBackground:Kill()
	HandleScrollBar(GuildBankPopupScrollFrameScrollBar)

	--Close button doesn't have a fucking name, extreme hackage
	for i=1, GuildBankFrame:GetNumChildren() do
		local child = select(i, GuildBankFrame:GetChildren())
		if child.GetPushedTexture and child:GetPushedTexture() and not child:GetName() then
			HandleCloseButton(child)
		end
	end

	HandleButton(GuildBankFrameDepositButton, true)
	HandleButton(GuildBankFrameWithdrawButton, true)
	HandleButton(GuildBankInfoSaveButton, true)
	HandleButton(GuildBankFramePurchaseButton, true)

	GuildBankFrameWithdrawButton:Point("RIGHT", GuildBankFrameDepositButton, "LEFT", -2, 0)
	GuildBankInfoScrollFrame:Point('TOPLEFT', GuildBankInfo, 'TOPLEFT', -10, 12)
	GuildBankInfoScrollFrame:StripTextures()
	GuildBankInfoScrollFrame:Width(GuildBankInfoScrollFrame:GetWidth() - 8)
	GuildBankTransactionsScrollFrame:StripTextures()

	GuildBankFrame.inset = CreateFrame("Frame", nil, GuildBankFrame)
	GuildBankFrame.inset:SetTemplate("Default")
	GuildBankFrame.inset:Point("TOPLEFT", 20, -58)
	GuildBankFrame.inset:Point("BOTTOMRIGHT", -16, 60)

	for i=1, NUM_GUILDBANK_COLUMNS do
		_G["GuildBankColumn"..i]:StripTextures()

		for x=1, NUM_SLOTS_PER_GUILDBANK_GROUP do
			local button = _G["GuildBankColumn"..i.."Button"..x]
			local icon = _G["GuildBankColumn"..i.."Button"..x.."IconTexture"]
			local texture = _G["GuildBankColumn"..i.."Button"..x.."NormalTexture"]
			if texture then
				texture:SetTexture(nil)
			end
			button:StyleButton()
			button:SetTemplate("Default", true)
			
			button.IconBorder:SetTexture(nil)
			hooksecurefunc(button.IconBorder, 'SetVertexColor', function(self, r, g, b, a)
				button:SetBackdropBorderColor(r, g, b, a)
			end)
			
			hooksecurefunc(button.IconBorder, 'Hide', function()
				button:SetBackdropBorderColor(bc.r, bc.g, bc.b)
			end)

			icon:SetInside()
			icon:SetTexCoord(unpack(F.TexCoords))
		end
	end

	for i=1, MAX_GUILDBANK_TABS do
		local button = _G["GuildBankTab"..i.."Button"]
		local texture = _G["GuildBankTab"..i.."ButtonIconTexture"]
		_G["GuildBankTab"..i]:StripTextures(true)

		button:StripTextures()
		button:StyleButton(true)
		button:SetTemplate("Default", true)

		texture:SetInside()
		texture:SetTexCoord(unpack(F.TexCoords))
	end

	for i=1, 4 do
		HandleTab(_G["GuildBankFrameTab"..i])
	end

	--Popup
	GuildBankPopupFrame:StripTextures()
	GuildBankPopupScrollFrame:StripTextures()
	GuildBankPopupFrame:SetTemplate("Transparent")
	GuildBankPopupFrame:Point("TOPLEFT", GuildBankFrame, "TOPRIGHT", 1, -30)
	HandleButton(GuildBankPopupOkayButton)
	HandleButton(GuildBankPopupCancelButton)
	HandleEditBox(GuildBankPopupEditBox)
	GuildBankPopupNameLeft:Kill()
	GuildBankPopupNameRight:Kill()
	GuildBankPopupNameMiddle:Kill()

	GuildItemSearchBox.Left:Kill()
	GuildItemSearchBox.Middle:Kill()
	GuildItemSearchBox.Right:Kill()
	GuildItemSearchBox.searchIcon:Kill()
	GuildItemSearchBox:CreateBackdrop("Overlay")
	GuildItemSearchBox.backdrop:Point("TOPLEFT", 10, -1)
	GuildItemSearchBox.backdrop:Point("BOTTOMRIGHT", -1, 1)

	for i=1, NUM_GUILDBANK_ICONS_SHOWN do
		local button = _G["GuildBankPopupButton"..i]
		local icon = _G[button:GetName().."Icon"]
		button:StripTextures()
		button:SetTemplate("Default")
		button:StyleButton(true)
		icon:SetInside()
		icon:SetTexCoord(unpack(F.TexCoords))
	end

	HandleScrollBar(GuildBankTransactionsScrollFrameScrollBar)
	HandleScrollBar(GuildBankInfoScrollFrameScrollBar)
end

F.SkinFuncs['Blizzard_GuildBankUI'] = LoadSkin