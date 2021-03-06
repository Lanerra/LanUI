local F, C, G = unpack(select(2, ...))
local bc = C.Media.BorderColor

local function LoadSkin()
	ItemTextFrame:StripTextures(true)
	ItemTextScrollFrame:StripTextures()
	GossipFrame:SetTemplate("Transparent")
	HandleCloseButton(GossipFrameCloseButton)
	HandleNextPrevButton(ItemTextPrevPageButton)
	HandleNextPrevButton(ItemTextNextPageButton)
	ItemTextPageText:SetTextColor(1, 1, 1)
	hooksecurefunc(ItemTextPageText, "SetTextColor", function(self, r, g, b)
		if r ~= 1 or g ~= 1 or b ~= 1 then
			ItemTextPageText:SetTextColor(1, 1, 1)
		end
	end)
	ItemTextFrame:SetTemplate("Transparent")
	ItemTextFrameInset:Kill()
	HandleScrollBar(ItemTextScrollFrameScrollBar)
	HandleCloseButton(ItemTextFrameCloseButton)

	local StripAllTextures = {
		"GossipFrameGreetingPanel",
		"GossipFrame",
		"GossipFrameInset",
		"GossipGreetingScrollFrame",
	}

	HandleScrollBar(GossipGreetingScrollFrameScrollBar, 5)


	for _, object in pairs(StripAllTextures) do
		_G[object]:StripTextures()
	end

	GossipGreetingScrollFrame:SetTemplate()
	GossipGreetingScrollFrame.spellTex = GossipGreetingScrollFrame:CreateTexture(nil, 'ARTWORK')
	GossipGreetingScrollFrame.spellTex:SetTexture([[Interface\QuestFrame\QuestBG]])
	GossipGreetingScrollFrame.spellTex:SetPoint("TOPLEFT", 2, -2)
	GossipGreetingScrollFrame.spellTex:Size(506, 615)
	GossipGreetingScrollFrame.spellTex:SetTexCoord(0, 1, 0.02, 1)

	local KillTextures = {
		"GossipFramePortrait",
	}

	for _, texture in pairs(KillTextures) do
		_G[texture]:Kill()
	end

	local buttons = {
		"GossipFrameGreetingGoodbyeButton",
	}

	for i = 1, #buttons do
		_G[buttons[i]]:StripTextures()
		HandleButton(_G[buttons[i]])
	end


	HandleCloseButton(GossipFrameCloseButton,GossipFrame.backdrop)

	NPCFriendshipStatusBar:StripTextures()
	NPCFriendshipStatusBar:SetStatusBarTexture(C.Media.StatusBar)
	NPCFriendshipStatusBar:CreateBackdrop('Default')
end

tinsert(F.SkinFuncs['LanUI'], LoadSkin)