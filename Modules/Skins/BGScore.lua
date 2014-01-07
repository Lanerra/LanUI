local F, C, G = unpack(select(2, ...))
local bc = C.Media.BorderColor

local function LoadSkin()
	WorldStateScoreScrollFrame:StripTextures()
	WorldStateScoreScrollFrameScrollBar:SkinScrollBar()
	WorldStateScoreFrame:StripTextures()
	WorldStateScoreFrameInset:StripTextures()
	WorldStateScoreFrame:SetTemplate()
	WorldStateScoreFrameCloseButton:SkinCloseButton()
	WorldStateScoreFrameInset:Kill()
	WorldStateScoreFrameLeaveButton:SkinButton()

	for i = 1, WorldStateScoreScrollFrameScrollChildFrame:GetNumChildren() do
		local b = _G['WorldStateScoreButton'..i]
		b:StripTextures()
		b:StyleButton(false)
		b:SetTemplate(true)
	end

	for i = 1, 3 do 
		_G['WorldStateScoreFrameTab'..i]:SkinTab()
		
		if i ~= 1 then
			_G['WorldStateScoreFrameTab'..i]:Point('LEFT', _G['WorldStateScoreFrameTab'..i - 1], 'RIGHT', 4, 0)
		end
	end
end

tinsert(F.SkinFuncs['LanUI'], LoadSkin)