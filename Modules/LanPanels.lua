local F, C, G = unpack(select(2, ...))

if C.Panels.ABPanel == true then
    local ABPanel = CreateFrame('Frame', 'ABPanel', UIParent)

    ABPanel:SetPoint('BOTTOM', UIParent, 0, 50)
    --ABPanel:SetSize((C.ActionBars.ButtonSize * 12) + (C.ActionBars.ButtonSpacing * 13), (C.ActionBars.ButtonSize * 1) + (C.ActionBars.ButtonSpacing * 2))
    ABPanel:SetWidth((C.ActionBars.ButtonSize * 12) + (C.ActionBars.ButtonSpacing * 14))
    ABPanel:SetHeight((C.ActionBars.ButtonSize) + (C.ActionBars.ButtonSpacing * 3))
    ABPanel:SetFrameStrata('BACKGROUND')
    
    ABPanel:SetTemplate()
    
    for i = 1, 12 do
        _G['ActionButton'..i]:SetFrameStrata('HIGH')
        _G['MultiBarBottomLeftButton'..i]:SetFrameStrata('HIGH')
        _G['MultiBarBottomRightButton'..i]:SetFrameStrata('HIGH')
    end
    
    if C.ActionBars.Bar2 then
        ABPanel:SetHeight((C.ActionBars.ButtonSize * 2) + (C.ActionBars.ButtonSpacing * 4))
    end
    
    if C.ActionBars.Bar3 then
        ABPanel:SetHeight((C.ActionBars.ButtonSize * 3) + (C.ActionBars.ButtonSpacing * 5))
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