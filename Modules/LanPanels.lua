local F, C, G = unpack(select(2, ...))

if C.ActionBars.Bar2 == true then
    if C.Panels.ABPanel == true then
        local ABPanel = CreateFrame('Frame', 'ABPanel', UIParent)
    
        ABPanel:SetPoint('TOPLEFT', MultiBarBottomLeftButton1, -6, 5)
        ABPanel:SetPoint('BOTTOMRIGHT', ActionButton12, 6, -5)
        ABPanel:SetFrameStrata('BACKGROUND')
        
        ABPanel:SetTemplate()
        
        for i = 1, 12 do
            _G['ActionButton'..i]:SetFrameStrata('HIGH')
            _G['MultiBarBottomLeftButton'..i]:SetFrameStrata('HIGH')
        end
    end
else
    return
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