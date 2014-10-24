local F, C, G = unpack(select(2, ...))

if C.Panels.ABPanel == true then
    local ABPanel = CreateFrame('Frame', 'ABPanel', UIParent)

    ABPanel:SetPoint('BOTTOM', UIParent, 0, 50)
    ABPanel:SetWidth((C.ActionBars.ButtonSize * 12) + (C.ActionBars.ButtonSpacing * 14))
    ABPanel:SetHeight((C.ActionBars.ButtonSize) + (C.ActionBars.ButtonSpacing * 3))
    ABPanel:SetFrameStrata('BACKGROUND')
    
    ABPanel:SetTemplate()
    ABPanel.backdrop:SetOutside()
    
    for i = 1, 12 do
        _G['ActionButton'..i]:SetFrameStrata('HIGH')
        _G['MultiBarBottomLeftButton'..i]:SetFrameStrata('HIGH')
        _G['MultiBarBottomRightButton'..i]:SetFrameStrata('HIGH')
    end
end

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