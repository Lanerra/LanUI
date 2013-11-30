local F, C, G = unpack(select(2, ...))

local Parent = CreateFrame('Frame', 'LanOverrideBar', UIParent, 'SecureHandlerStateTemplate')
Parent:SetPoint('BOTTOM', 0, 80)
Parent:SetSize(198, 33)

RegisterStateDriver(Parent, 'visibility', '[petbattle] hide; [overridebar][vehicleui][possessbar,@vehicle,exists] show; hide')
RegisterStateDriver(OverrideActionBar, 'visibility', '[overridebar][vehicleui][possessbar,@vehicle,exists] show; hide')

local SkinAB = F.SkinAB
for index = 1, NUM_OVERRIDE_BUTTONS do
	local Button = _G['OverrideActionBarButton' .. index]
	Button:ClearAllPoints()

	if(index == 1) then
		Button:SetPoint('BOTTOMLEFT', Parent, 2, 0)
	else
		Button:SetPoint('LEFT', _G['OverrideActionBarButton' .. index - 1], 'RIGHT', 5, 0)
	end

	SkinAB('OverrideActionBarButton' .. index)
end

OverrideActionBar:SetParent(Parent)
OverrideActionBar:EnableMouse(false)
OverrideActionBar:SetScript('OnShow', nil)
