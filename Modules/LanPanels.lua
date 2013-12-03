local F, C, G = unpack(select(2, ...))

if C.Panels.BP == true then
    local BottomPanel = CreateFrame('Frame', 'BottomPanel', UIParent)
	
    BottomPanel:SetPoint('BOTTOM', 0, -4)
	BottomPanel:SetFrameStrata('LOW')
    BottomPanel:SetHeight(24)
    BottomPanel:SetWidth(2000)

    BottomPanel:SetTemplate()
end

if C.Panels.TP == true then
    local TopPanel = CreateFrame('Frame', 'TopPanel', UIParent)
	
    TopPanel:SetPoint('TOP', 0, 2)
    TopPanel:SetFrameLevel(0)
    TopPanel:SetFrameStrata('LOW')
    TopPanel:SetHeight(18)
    TopPanel:SetWidth(2000)

    TopPanel:SetTemplate()
end