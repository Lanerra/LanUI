local F, C, G = unpack(select(2, ...))
local bc = C.Media.BorderColor

local function LoadSkin()
	GuildControlUI:StripTextures()
	GuildControlUIHbar:StripTextures()
	GuildControlUI:SetTemplate("Transparent")
	GuildControlUIRankBankFrameInset:StripTextures()
	GuildControlUIRankBankFrameInsetScrollFrame:StripTextures()
	HandleScrollBar(GuildControlUIRankBankFrameInsetScrollFrameScrollBar);

	local function SkinGuildRanks()
		for i=1, GuildControlGetNumRanks() do
			local rankFrame = _G["GuildControlUIRankOrderFrameRank"..i]
			if rankFrame then
				HandleButton(rankFrame.downButton)
				HandleButton(rankFrame.upButton)
				HandleButton(rankFrame.deleteButton)

				if not rankFrame.nameBox.backdrop then
					HandleEditBox(rankFrame.nameBox)
				end

				rankFrame.nameBox.backdrop:Point("TOPLEFT", -2, -4)
				rankFrame.nameBox.backdrop:Point("BOTTOMRIGHT", -4, 4)
			end
		end
	end
	hooksecurefunc("GuildControlUI_RankOrder_Update", SkinGuildRanks)
	GuildControlUIRankOrderFrameNewButton:HookScript("OnClick", function()
		F.Delay(1, SkinGuildRanks)
	end)

	HandleDropDownBox(GuildControlUINavigationDropDown)
	HandleDropDownBox(GuildControlUIRankSettingsFrameRankDropDown, 180)
	GuildControlUINavigationDropDownButton:Width(20)
	GuildControlUIRankSettingsFrameRankDropDownButton:Width(20)

	for i=1, NUM_RANK_FLAGS do
		if _G["GuildControlUIRankSettingsFrameCheckbox"..i] then
			HandleCheckBox(_G["GuildControlUIRankSettingsFrameCheckbox"..i])
		end
	end

	HandleButton(GuildControlUIRankOrderFrameNewButton)

	HandleEditBox(GuildControlUIRankSettingsFrameGoldBox)
	GuildControlUIRankSettingsFrameGoldBox.backdrop:Point("TOPLEFT", -2, -4)
	GuildControlUIRankSettingsFrameGoldBox.backdrop:Point("BOTTOMRIGHT", 2, 4)
	GuildControlUIRankSettingsFrameGoldBox:StripTextures()

	GuildControlUIRankBankFrame:StripTextures()

	local function fixSkin(frame)
		frame.backdrop:Hide();
		--Initiate fucked up method of creating a backdrop
		if not C.Media.PixelPerfect then
			frame.bg1 = frame:CreateTexture(nil, "BACKGROUND")
			frame.bg1:SetDrawLayer("BACKGROUND", 4)
			frame.bg1:SetTexture(C.Media.Backdrop) --Default TukUI users this is normTex, normTex doesn't exist
			frame.bg1:SetVertexColor(unpack(C.Media.BackdropColor))
			frame.bg1:Point("TOPLEFT", frame.backdrop, 'TOPLEFT', F.Mult*4, -F.Mult*4)
			frame.bg1:Point("BOTTOMRIGHT", frame.backdrop, 'BOTTOMRIGHT', -F.Mult*4, F.Mult*4)

			frame.bg2 = frame:CreateTexture(nil, "BACKGROUND")
			frame.bg2:SetDrawLayer("BACKGROUND", 3)
			frame.bg2:SetTexture(0,0,0)
			frame.bg2:Point("TOPLEFT", frame.backdrop, 'TOPLEFT', F.Mult*3, -F.Mult*3)
			frame.bg2:Point("BOTTOMRIGHT", frame.backdrop, 'BOTTOMRIGHT', -F.Mult*3, F.Mult*3)

			frame.bg3 = frame:CreateTexture(nil, "BACKGROUND")
			frame.bg3:SetDrawLayer("BACKGROUND", 2)
			frame.bg3:SetTexture(bc.r, bc.g, bc.b)
			frame.bg3:Point("TOPLEFT", frame.backdrop, 'TOPLEFT', F.Mult*2, -F.Mult*2)
			frame.bg3:Point("BOTTOMRIGHT", frame.backdrop, 'BOTTOMRIGHT', -F.Mult*2, F.Mult*2)

			frame.bg4 = frame:CreateTexture(nil, "BACKGROUND")
			frame.bg4:SetDrawLayer("BACKGROUND", 1)
			frame.bg4:SetTexture(0,0,0)
			frame.bg4:Point("TOPLEFT", frame.backdrop, 'TOPLEFT', F.Mult, -F.Mult)
			frame.bg4:Point("BOTTOMRIGHT", frame.backdrop, 'BOTTOMRIGHT', -F.Mult, F.Mult)
		else
			frame.bg1 = frame:CreateTexture(nil, "BACKGROUND")
			frame.bg1:SetDrawLayer("BACKGROUND", 4)
			frame.bg1:SetTexture(C.Media.Backdrop) --Default TukUI users this is normTex, normTex doesn't exist
			frame.bg1:SetVertexColor(unpack(C.Media.BackdropColor))
			frame.bg1:SetInside(frame.backdrop, F.Mult)

			frame.bg3 = frame:CreateTexture(nil, "BACKGROUND")
			frame.bg3:SetDrawLayer("BACKGROUND", 2)
			frame.bg3:SetTexture(bc.r, bc.g, bc.b)
			frame.bg3:SetAllPoints(frame.backdrop)
		end
	end


	local once = false
	hooksecurefunc("GuildControlUI_BankTabPermissions_Update", function()
		local numTabs = GetNumGuildBankTabs()
		if numTabs < MAX_BUY_GUILDBANK_TABS then
			numTabs = numTabs + 1
		end
		for i=1, numTabs do
			local tab = _G["GuildControlBankTab"..i.."Owned"]
			local icon = tab.tabIcon
			local editbox = tab.editBox

			icon:SetTexCoord(unpack(F.TexCoords))

			if once == false then
				HandleButton(_G["GuildControlBankTab"..i.."BuyPurchaseButton"])
				HandleEditBox(_G["GuildControlBankTab"..i.."OwnedStackBox"])
				HandleCheckBox(_G["GuildControlBankTab"..i.."OwnedViewCheck"])
				HandleCheckBox(_G["GuildControlBankTab"..i.."OwnedDepositCheck"])
				HandleCheckBox(_G["GuildControlBankTab"..i.."OwnedUpdateInfoCheck"])

				fixSkin(_G["GuildControlBankTab"..i.."OwnedStackBox"])
				fixSkin(_G["GuildControlBankTab"..i.."OwnedViewCheck"])
				fixSkin(_G["GuildControlBankTab"..i.."OwnedDepositCheck"])
				fixSkin(_G["GuildControlBankTab"..i.."OwnedUpdateInfoCheck"])

			end
		end
		once = true
	end)

	HandleDropDownBox(GuildControlUIRankBankFrameRankDropDown, 180)
	GuildControlUIRankBankFrameRankDropDownButton:Width(20)
end

F.SkinFuncs['Blizzard_GuildControlUI'] = LoadSkin