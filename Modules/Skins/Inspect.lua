local F, C, G = unpack(select(2, ...))
local bc = C.Media.BorderColor

local function LoadSkin()
	InspectFrame:StripTextures(true)
	InspectFrameInset:StripTextures(true)
	InspectFrame:SetTemplate('Transparent')
	HandleCloseButton(InspectFrameCloseButton)

	for i=1, 4 do
		HandleTab(_G["InspectFrameTab"..i])
	end

	InspectModelFrameBorderTopLeft:Kill()
	InspectModelFrameBorderTopRight:Kill()
	InspectModelFrameBorderTop:Kill()
	InspectModelFrameBorderLeft:Kill()
	InspectModelFrameBorderRight:Kill()
	InspectModelFrameBorderBottomLeft:Kill()
	InspectModelFrameBorderBottomRight:Kill()
	InspectModelFrameBorderBottom:Kill()
	InspectModelFrameBorderBottom2:Kill()
	InspectModelFrameBackgroundOverlay:Kill()
	InspectModelFrame:CreateBackdrop("Default")

	local slots = {
		"HeadSlot",
		"NeckSlot",
		"ShoulderSlot",
		"BackSlot",
		"ChestSlot",
		"ShirtSlot",
		"TabardSlot",
		"WristSlot",
		"HandsSlot",
		"WaistSlot",
		"LegsSlot",
		"FeetSlot",
		"Finger0Slot",
		"Finger1Slot",
		"Trinket0Slot",
		"Trinket1Slot",
		"MainHandSlot",
		"SecondaryHandSlot",
	}
	for _, slot in pairs(slots) do
		local icon = _G["Inspect"..slot.."IconTexture"]
		local slot = _G["Inspect"..slot]
		slot:StripTextures()
		slot:StyleButton(false)
		icon:SetTexCoord(unpack(F.TexCoords))
		icon:SetInside()
		slot:SetFrameLevel(slot:GetFrameLevel() + 2)
		slot:CreateBackdrop("Default")
		slot.backdrop:SetAllPoints()
	end

	hooksecurefunc('InspectPaperDollItemSlotButton_Update', function(button)
		local unit = InspectFrame.unit;
		local quality = GetInventoryItemQuality(unit, button:GetID())
		if quality and button.backdrop then
			local r, g, b = GetItemQualityColor(quality)
			button.backdrop:SetBackdropBorderColor(r, g ,b)
		elseif button.backdrop then
			button.backdrop:SetBackdropBorderColor(bc.r, bc.g, bc.b)
		end
	end)

	--InspectPVPFrameBottom:Kill()
	InspectGuildFrameBG:Kill()

	InspectTalentFrame:StripTextures()
end

F.SkinFuncs['Blizzard_InspectUI'] = LoadSkin