local F, C, G = unpack(select(2, ...))
local bc = C.Media.BorderColor

local function LoadSkin()
	InspectFrame:StripTextures(true)
	InspectFrameInset:StripTextures(true)
	InspectFrame:CreateBD(true)
	InspectFrame.backdrop:SetAllPoints()
	InspectFrameCloseButton:SkinCloseButton()
	
	for i=1, 4 do
		_G['InspectFrameTab'..i]:SkinTab()
		
		if i ~= 1 then
			_G['InspectFrameTab'..i]:Point('LEFT', _G['InspectFrameTab'..i - 1], 'RIGHT', 4, 0)
		end
		
		_G['InspectFrameTab'..i]:SetWidth(65)
		_G['InspectFrameTab'..i].SetWidth = F.Dummy
		_G['InspectFrameTab'..i].SetSize = F.Dummy
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
	InspectModelFrame:CreateBD(true)
	
		local slots = {
			'HeadSlot',
			'NeckSlot',
			'ShoulderSlot',
			'BackSlot',
			'ChestSlot',
			'ShirtSlot',
			'TabardSlot',
			'WristSlot',
			'HandsSlot',
			'WaistSlot',
			'LegsSlot',
			'FeetSlot',
			'Finger0Slot',
			'Finger1Slot',
			'Trinket0Slot',
			'Trinket1Slot',
			'MainHandSlot',
			'SecondaryHandSlot',
		}
		for _, slot in pairs(slots) do
			local icon = _G['Inspect'..slot..'IconTexture']
			local slot = _G['Inspect'..slot]
			slot:StripTextures()
			slot:StyleButton(false)
			icon:SetTexCoord(.08, .92, .08, .92)
			icon:ClearAllPoints()
			icon:Point('TOPLEFT', 2, -2)
			icon:Point('BOTTOMRIGHT', -2, 2)
			
			slot:SetFrameLevel(slot:GetFrameLevel() + 2)
			slot:CreateBD(true)
			slot.backdrop:SetAllPoints()
		end		
	
	InspectGuildFrameBG:Kill()
	
	InspectTalentFrame:StripTextures()
end

F.SkinFuncs['Blizzard_InspectUI'] = LoadSkin