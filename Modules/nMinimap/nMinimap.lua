    
    -- a 'new' mail notification    

MiniMapMailFrame:SetSize(14, 14)
MiniMapMailFrame:ClearAllPoints()
MiniMapMailFrame:SetPoint('BOTTOMRIGHT', Minimap, -4, 5)

MiniMapMailBorder:SetTexture(nil)
MiniMapMailIcon:SetTexture(nil)

hooksecurefunc(MiniMapMailFrame, 'Show', function()
    MiniMapMailBorder:SetTexture(nil)
    MiniMapMailIcon:SetTexture(nil)
end)

MiniMapMailFrame.Text = MiniMapMailFrame:CreateFontString(nil, 'OVERLAY')
MiniMapMailFrame.Text:SetParent(MiniMapMailFrame)
MiniMapMailFrame.Text:SetFont(LanConfig.Media.Font, 15, 'OUTLINE')
MiniMapMailFrame.Text:SetPoint('BOTTOMRIGHT', MiniMapMailFrame)
MiniMapMailFrame.Text:SetTextColor(1, 0, 1)
MiniMapMailFrame.Text:SetText('N')

    -- hide all unwanted things
    
MinimapZoomIn:Hide()
MinimapZoomIn:UnregisterAllEvents()

MinimapZoomOut:Hide()
MinimapZoomOut:UnregisterAllEvents()

MiniMapWorldMapButton:Hide()
MiniMapWorldMapButton:UnregisterAllEvents()

MinimapNorthTag:SetAlpha(0)

MinimapBorder:Hide()
MinimapBorderTop:Hide()

MinimapZoneText:Hide()

MinimapZoneTextButton:Hide()
MinimapZoneTextButton:UnregisterAllEvents()

    -- hide the tracking button

MiniMapTracking:UnregisterAllEvents()
MiniMapTracking:Hide()

    -- hide the durability frame (the armored man)
    
DurabilityFrame:Hide()
DurabilityFrame:UnregisterAllEvents()

    -- bigger minimap
    
MinimapCluster:SetScale(1.1)
MinimapCluster:EnableMouse(false)

    -- new position
    
Minimap:ClearAllPoints()
Minimap:SetPoint('TOPRIGHT', UIParent, -26, -26)

    -- square minimap and create a border

function GetMinimapShape()
    return 'SQUARE'
end

Minimap:SetMaskTexture('Interface\\ChatFrame\\ChatFrameBackground')

Minimap:CreateBeautyBorder(11)
Minimap:SetBeautyBorderPadding(1)

    -- enable mousewheel zooming

Minimap:EnableMouseWheel(true)
Minimap:SetScript('OnMouseWheel', function(self, delta)
	if (delta > 0) then
		_G.MinimapZoomIn:Click()
	elseif delta < 0 then
		_G.MinimapZoomOut:Click()
	end
end)

    -- modify the minimap tracking

Minimap:SetScript('OnMouseUp', function(self, button)
    if (button == 'RightButton') then
        ToggleDropDownMenu(1, nil, MiniMapTrackingDropDown, self, - (Minimap:GetWidth() * 0.7), -3)
    else
        Minimap_OnClick(self)
    end
end)

    -- skin the ticket status frame

TicketStatusFrame:ClearAllPoints()
TicketStatusFrame:SetPoint('BOTTOMRIGHT', UIParent, 0, 0)

TicketStatusFrameButton:HookScript('OnShow', function(self)
	self:SetBackdrop({
        bgFile = LanConfig.Media.Backdrop, 
        insets = {
            left = 3, 
            right = 3, 
            top = 3, 
            bottom = 3
        }
    })
    self:SetBackdropColor(LanConfig.Media.BackdropColor)
    self:CreateBeautyBorder(12)
end)

local function GetZoneColor()
	local zoneType = GetZonePVPInfo()
    
	if (zoneType == 'sanctuary') then
		return 0.4, 0.8, 0.94
	elseif (zoneType == 'arena') then
		return 1, 0.1, 0.1
	elseif (zoneType == 'friendly') then
		return 0.1, 1, 0.1
	elseif (zoneType == 'hostile') then
		return 1, 0.1, 0.1
	elseif (zoneType == 'contested') then
		return 1, 0.8, 0
	else
		return 1, 1, 1
	end
end

    -- mouseover zone text
    
local MainZone = Minimap:CreateFontString(nil, 'OVERLAY')
MainZone:SetParent(Minimap)
MainZone:SetFont('Fonts\\ARIALN.ttf', 16, 'THINOUTLINE')
MainZone:SetPoint('TOP', Minimap, 0, -22)
MainZone:SetTextColor(1, 1, 1)
MainZone:SetAlpha(0)
MainZone:SetSize(130, 32)
MainZone:SetJustifyV('BOTTOM')

local SubZone = Minimap:CreateFontString(nil, 'OVERLAY')
SubZone:SetParent(Minimap)
SubZone:SetFont('Fonts\\ARIALN.ttf', 13, 'THINOUTLINE')
SubZone:SetPoint('TOP', MainZone, 'BOTTOM', 0, -1)
SubZone:SetTextColor(1, 1, 1)
SubZone:SetAlpha(0)
SubZone:SetSize(130, 26)
SubZone:SetJustifyV('TOP')

Minimap:HookScript('OnEnter', function()

        -- disable the mouseover if the shift key is pressed, in cases we want to make a ping and the text is annoying
        
    if (SubZone and not IsShiftKeyDown()) then
        SubZone:SetTextColor(GetZoneColor())
        SubZone:SetText(GetSubZoneText())
        securecall('UIFrameFadeIn', SubZone, 0.235, SubZone:GetAlpha(), 1)
        
        MainZone:SetTextColor(GetZoneColor())
        MainZone:SetText(GetRealZoneText())
        securecall('UIFrameFadeIn', MainZone, 0.235, MainZone:GetAlpha(), 1)
   end
end)

Minimap:HookScript('OnLeave', function()
    if (SubZone) then
        securecall('UIFrameFadeOut', SubZone, 0.235, SubZone:GetAlpha(), 0)
        securecall('UIFrameFadeOut', MainZone, 0.235, MainZone:GetAlpha(), 0)
    end
end)