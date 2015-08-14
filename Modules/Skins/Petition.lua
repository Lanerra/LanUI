local F, C, G = unpack(select(2, ...))
local bc = C.Media.BorderColor

local function LoadSkin()
	PetitionFrame:StripTextures(true)
	PetitionFrame:SetTemplate("Transparent")
	PetitionFrameInset:Kill()
	HandleButton(PetitionFrameSignButton)
	HandleButton(PetitionFrameRequestButton)
	HandleButton(PetitionFrameRenameButton)
	HandleButton(PetitionFrameCancelButton)
	HandleCloseButton(PetitionFrameCloseButton)

	PetitionFrameCharterTitle:SetTextColor(1, 1, 0)
	PetitionFrameCharterName:SetTextColor(1, 1, 1)
	PetitionFrameMasterTitle:SetTextColor(1, 1, 0)
	PetitionFrameMasterName:SetTextColor(1, 1, 1)
	PetitionFrameMemberTitle:SetTextColor(1, 1, 0)

	for i=1, 9 do
		_G["PetitionFrameMemberName"..i]:SetTextColor(1, 1, 1)
	end

	PetitionFrameInstructions:SetTextColor(1, 1, 1)

	PetitionFrameRenameButton:Point("LEFT", PetitionFrameRequestButton, "RIGHT", 3, 0)
	PetitionFrameRenameButton:Point("RIGHT", PetitionFrameCancelButton, "LEFT", -3, 0)
end

tinsert(F.SkinFuncs['LanUI'], LoadSkin)
