local F, C, G = unpack(select(2, ...))

-- Texture Coordinates
F.TexCoords = {.08, .92, .08, .92}

-- Kill Talent popup
TalentMicroButtonAlert:UnregisterAllEvents()
TalentMicroButtonAlert:SetParent(LanUIHider)

-- Move TicketStatusFrame
TicketStatusFrame:ClearAllPoints()

if ChatFrame3:IsShown() then
    TicketStatusFrame:SetPoint('BOTTOMLEFT', ChatFrame3, 'TOPLEFT', 0, 5)
elseif C.Panels.BP then
    TicketStatusFrame:SetPoint('BOTTOMRIGHT', UIParent, 0, BottomPanel:GetHeight() + 5)
else
    TicketStatusFrame:SetPoint('BOTTOMRIGHT', UIParent, 0, 0)
end

-- Garbage Collector
local eventcount = 0
local LanJanitor = CreateFrame("Frame")
LanJanitor:RegisterAllEvents()
LanJanitor:SetScript("OnEvent", function(self, event)
    eventcount = eventcount + 1
    --if InCombatLockdown() then return end

    if (InCombatLockdown() and eventcount > 25000) or (not InCombatLockdown() and eventcount > 10000) or event == "PLAYER_ENTERING_WORLD" then
        collectgarbage("collect")
        eventcount = 0        
    end
end)

-- Kill annoying raid shit
if not InCombatLockdown() then
    CompactRaidFrameManager:UnregisterAllEvents()
    CompactRaidFrameManager:SetParent(LanUIHider)
    CompactRaidFrameManager:Hide()
    CompactRaidFrameContainer:UnregisterAllEvents()
    CompactRaidFrameContainer:SetParent(LanUIHider)
    CompactRaidFrameContainer:Hide()
end

ShowPartyFrame = F.Dummy
HidePartyFrame = F.Dummy
CompactUnitFrame_UpdateAll = F.Dummy
CompactUnitFrameProfiles_ApplyProfile = F.Dummy
CompactRaidFrameManager_UpdateShown = F.Dummy
CompactRaidFrameManager_UpdateOptionsFlowContainer = F.Dummy

-- Fade in/out world when GameMenu is opened
local sh = UIParent:CreateTexture(nil, 'BACKGROUND')
sh:SetAllPoints(UIParent)
sh:SetTexture(0, 0, 0)
sh:Hide()

hooksecurefunc(GameMenuFrame, 'Show', function()
    sh:SetAlpha(0)
    securecall('UIFrameFadeIn', sh, 0.235, sh:GetAlpha(), 0.5)
end)

hooksecurefunc(GameMenuFrame, 'Hide', function()
    securecall('UIFrameFadeOut', sh, 0.235, sh:GetAlpha(), 0)
end)

-- BigWigs Skin
local f = CreateFrame("Frame")
local function RegisterMyStyle()
	if not BigWigs then return end
	local bars = BigWigs:GetPlugin("Bars", true)
	if not bars then return end
	f:UnregisterEvent("ADDON_LOADED")
	f:UnregisterEvent("PLAYER_LOGIN")
	bars:RegisterBarStyle("identifier", {
		apiVersion = 1,
		version = 1,
		GetSpacing = function(bar) return 8 end,
		ApplyStyle = function(bar)
            bar.candyBarBar:SetStatusBarTexture(C.Media.StatusBar)
            bar.candyBarBar:SetStatusBarColor(.25, .25, .25)
            
            bar.Overlay = CreateFrame('Frame', nil, bar)
            bar.Overlay:SetAllPoints(bar)
            bar.Overlay:SetFrameLevel(bar.candyBarBar:GetFrameLevel() + 3)
            bar.Overlay:SetTemplate()
            bar.Overlay.backdrop:SetParent(bar)
            bar.Overlay.backdrop:SetBeautyBorderPadding(3)
            bar.Overlay.backdrop:SetBackdropColor(0, 0, 0, 0)
            bar.Overlay.backdrop:SetBackdropBorderColor(0, 0, 0, 0)
            
            bar.candyBarBackground:SetTexture(C.Media.Backdrop)
            bar.candyBarBackground:SetVertexColor(0, 0, 0, 0.5)
        end,
		BarStopped = function(bar)
            bar:SetParent(UIParent)
            bar:ClearAllPoints()
            bar:Hide()
        end,
		GetStyleName = function() return "LanBW" end,
	})
end
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("PLAYER_LOGIN")

local reason = nil
f:SetScript("OnEvent", function(self, event, msg)
	if event == "ADDON_LOADED" then
		if not reason then reason = (select(6, GetAddOnInfo("BigWigs_Plugins"))) end
		if (reason == "MISSING" and msg == "BigWigs") or msg == "BigWigs_Plugins" then
			RegisterMyStyle()
		end
	elseif event == "PLAYER_LOGIN" then
		RegisterMyStyle()
	end
end)