local F, C, G = unpack(select(2, ...))
local bc = C.Media.BorderColor

local function LoadSkin()
	TabardFrame:StripTextures(true)
	TabardFrame:SetTemplate("Transparent")
	TabardModel:CreateBackdrop("Default")
	HandleButton(TabardFrameCancelButton)
	HandleButton(TabardFrameAcceptButton)
	HandleCloseButton(TabardFrameCloseButton)
	HandleRotateButton(TabardCharacterModelRotateLeftButton)
	HandleRotateButton(TabardCharacterModelRotateRightButton)
	TabardFrameCostFrame:StripTextures()
	TabardFrameCustomizationFrame:StripTextures()
	TabardFrameInset:Kill()
	TabardFrameMoneyInset:Kill()
	TabardFrameMoneyBg:StripTextures()

	for i=1, 5 do
		local custom = "TabardFrameCustomization"..i
		_G[custom]:StripTextures()
		HandleNextPrevButton(_G[custom.."LeftButton"])
		HandleNextPrevButton(_G[custom.."RightButton"])

		if i > 1 then
			_G[custom]:ClearAllPoints()
			_G[custom]:Point("TOP", _G["TabardFrameCustomization"..i-1], "BOTTOM", 0, -6)
		else
			local point, anchor, point2, x, y = _G[custom]:GetPoint()
			_G[custom]:Point(point, anchor, point2, x, y+4)
		end
	end

	TabardCharacterModelRotateLeftButton:Point("BOTTOMLEFT", 4, 4)
	TabardCharacterModelRotateRightButton:Point("TOPLEFT", TabardCharacterModelRotateLeftButton, "TOPRIGHT", 4, 0)
	hooksecurefunc(TabardCharacterModelRotateLeftButton, "SetPoint", function(self, point, attachTo, anchorPoint, xOffset, yOffset)
		if point ~= "BOTTOMLEFT" or xOffset ~= 4 or yOffset ~= 4 then
			self:Point("BOTTOMLEFT", 4, 4)
		end
	end)

	hooksecurefunc(TabardCharacterModelRotateRightButton, "SetPoint", function(self, point, attachTo, anchorPoint, xOffset, yOffset)
		if point ~= "TOPLEFT" or xOffset ~= 4 or yOffset ~= 0 then
			self:Point("TOPLEFT", TabardCharacterModelRotateLeftButton, "TOPRIGHT", 4, 0)
		end
	end)
end

tinsert(F.SkinFuncs['LanUI'], LoadSkin)