if LanConfig.Panels.ABPanel == true then
	local ABPanel = CreateFrame('Frame', 'ABPanel', UIParent)
	
	ABPanel:SetPoint('TOPLEFT', ActionButton1, -7, 5)
    ABPanel:SetPoint('BOTTOMRIGHT', MultiBarBottomLeftButton12, 7, -5)
    ABPanel:SetFrameStrata('BACKGROUND')
	
	LanFunc.Skin(ABPanel, 12, 1)
end

if LanConfig.Panels.BP == true then
    local BottomPanel = CreateFrame('Frame', 'BottomPanel', UIParent)
	
    BottomPanel:SetPoint('BOTTOM', 0, -2)
	BottomPanel:SetFrameStrata('LOW')
    BottomPanel:SetHeight(22)
    BottomPanel:SetWidth(2000)

    LanFunc.Skin(BottomPanel, 12, 1)
    	
    if LanConfig.Panels.BPClass == true then
        BottomPanel:SetBackdropColor(LanFunc.playerColor.r*0.8, LanFunc.playerColor.g*0.8, LanFunc.playerColor.b*0.8, 0.9)
    else
        BottomPanel:SetBackdropColor(unpack(LanConfig.Media.BackdropColor))
    end
end

if LanConfig.Panels.TP == true then
    local TopPanel = CreateFrame('Frame', 'TopPanel', UIParent)
	
    TopPanel:SetPoint('TOP', 0, 2)
    TopPanel:SetFrameLevel(0)
    TopPanel:SetFrameStrata('LOW')
    TopPanel:SetHeight(18)
    TopPanel:SetWidth(2000)

    LanFunc.Skin(TopPanel, 12, 1)
	
    if LanConfig.Panels.TPClass == true then
        TopPanel:SetBackdropColor(LanFunc.playerColor.r*0.8, LanFunc.playerColor.g*0.8, LanFunc.playerColor.b*0.8, 0.8)
    else
        TopPanel:SetBackdropColor(unpack(LanConfig.Media.BackdropColor))
    end
end