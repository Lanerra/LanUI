local F, C, G = unpack(select(2, ...))

local Parent = CreateFrame('Frame', 'LanExtraBar', UIParent, 'SecureHandlerStateTemplate')
Parent:SetPoint('BOTTOM', LanPetBar, 'TOP', 0, 5)
Parent:SetSize(50, 50)

RegisterStateDriver(Parent, 'visibility', '[petbattle][overridebar][vehicleui] hide; show')

ExtraActionBarFrame:SetParent(Parent)
ExtraActionBarFrame:EnableMouse(false)
ExtraActionBarFrame:SetAllPoints()
ExtraActionBarFrame.ignoreFramePositionManager = true

for i = 2, ExtraActionButton1:GetNumRegions() do
	select(i, ExtraActionButton1:GetRegions()):Kill()
end

ExtraActionButton1:SetTemplate()

for i = 1, 8 do
	ExtraActionButton1.Border[i]:SetDrawLayer('OVERLAY', 0)
end
