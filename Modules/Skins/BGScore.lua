local F, C, G = unpack(select(2, ...))
local bc = C.Media.BorderColor

local function LoadSkin()
	WorldStateScoreScrollFrame:StripTextures()
	WorldStateScoreFrame:StripTextures()
	WorldStateScoreFrame:SetTemplate("Transparent")
	HandleCloseButton(WorldStateScoreFrameCloseButton)
	HandleScrollBar(WorldStateScoreScrollFrameScrollBar)
	WorldStateScoreFrameInset:SetAlpha(0)
	HandleButton(WorldStateScoreFrameLeaveButton)
	HandleButton(WorldStateScoreFrameQueueButton)
	for i = 1, 3 do
		HandleTab(_G["WorldStateScoreFrameTab"..i])
	end
end

tinsert(F.SkinFuncs['LanUI'], LoadSkin)