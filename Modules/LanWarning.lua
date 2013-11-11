local F, C, G = unpack(select(2, ...))

RaidWarningFrame.slot1:SetFont(C.Media.Font, 20, 'THINOUTLINE')
RaidWarningFrame.slot2:SetFont(C.Media.Font, 20, 'THINOUTLINE')

RaidBossEmoteFrame.slot1:SetFont(C.Media.Font, 20, 'THINOUTLINE')
RaidBossEmoteFrame.slot2:SetFont(C.Media.Font, 20, 'THINOUTLINE')

RaidWarningFrame:ClearAllPoints() 
RaidWarningFrame:SetPoint('CENTER', UIParent, 'CENTER', 0, 190)
RaidWarningFrame:SetScale(1.03)

RaidWarningFrameSlot2:ClearAllPoints() 
RaidWarningFrameSlot2:SetPoint('TOP', RaidWarningFrameSlot1, 'BOTTOM', 0, -3)

RaidBossEmoteFrameSlot2:ClearAllPoints() 
RaidBossEmoteFrameSlot2:SetPoint('TOP', RaidBossEmoteFrameSlot1, 'BOTTOM', 0, -3)