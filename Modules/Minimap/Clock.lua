local F, C, G = unpack(select(2, ...))

local classColor = RAID_CLASS_COLORS[F.MyClass]

if (not IsAddOnLoaded('Blizzard_TimeManager')) then
    LoadAddOn('Blizzard_TimeManager')
end

TimeManagerClockTicker:FontTemplate(C.Media.Font, 15, 'OUTLINE')
TimeManagerClockTicker:SetShadowOffset(0, 0)
TimeManagerClockTicker:SetTextColor(classColor.r, classColor.g, classColor.b)
TimeManagerClockTicker:SetPoint('TOPRIGHT', TimeManagerClockButton, 0, 0)

TimeManagerClockButton:GetRegions():Hide()
TimeManagerClockButton:ClearAllPoints()
TimeManagerClockButton:SetWidth(40)
TimeManagerClockButton:SetHeight(18)
TimeManagerClockButton:SetPoint('BOTTOM', Minimap, 0, 2)

TimeManagerAlarmFiredTexture:SetTexture(nil)

hooksecurefunc(TimeManagerAlarmFiredTexture, 'Show', function()
    TimeManagerClockTicker:SetTextColor(1, 0, 1)
end)

hooksecurefunc(TimeManagerAlarmFiredTexture, 'Hide', function()
    TimeManagerClockTicker:SetTextColor(classColor.r, classColor.g, classColor.b)
end)

TimeManagerFrame:SetTemplate()

for i = 1, select('#', GameTimeFrame:GetRegions()) do
    local texture = select(i, GameTimeFrame:GetRegions())
    if (texture and texture:GetObjectType() == 'Texture') then
        texture:SetTexture(nil)
    end
end

GameTimeFrame:SetSize(14, 14)
GameTimeFrame:SetHitRectInsets(0, 0, 0, 0)
GameTimeFrame:ClearAllPoints()
GameTimeFrame:SetPoint('TOPRIGHT', Minimap, -3.5, -3.5)

GameTimeFrame:GetFontString():FontTemplate(C.Media.Font, 15, 'OUTLINE')
GameTimeFrame:GetFontString():SetShadowOffset(0, 0)
GameTimeFrame:GetFontString():SetPoint('TOPRIGHT', GameTimeFrame)

for _, texture in pairs({
    GameTimeCalendarEventAlarmTexture,
    GameTimeCalendarInvitesTexture,
    GameTimeCalendarInvitesGlow,
    TimeManagerAlarmFiredTexture,
}) do
    texture:SetTexture(nil)

    if (texture:IsShown()) then
        GameTimeFrame:GetFontString():SetTextColor(1, 0, 1)
    else
        GameTimeFrame:GetFontString():SetTextColor(classColor.r, classColor.g, classColor.b)
    end

    hooksecurefunc(texture, 'Show', function()
        GameTimeFrame:GetFontString():SetTextColor(1, 0, 1)
    end)

    hooksecurefunc(texture, 'Hide', function()
        GameTimeFrame:GetFontString():SetTextColor(classColor.r, classColor.g, classColor.b)
    end)
end