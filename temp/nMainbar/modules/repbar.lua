
local _, nMainbar = ...
local cfg = nMainbar.Config
 
    -- reputation bar mouseover text

ReputationWatchStatusBarText:SetFont(cfg.repBar.font, cfg.repBar.fontsize, 'THINOUTLINE')
ReputationWatchStatusBarText:SetShadowOffset(0, 0)

if (cfg.repBar.mouseover) then
    ReputationWatchStatusBarText:SetAlpha(0)

    ReputationWatchBar:HookScript('OnEnter', function()
        securecall('UIFrameFadeIn', ReputationWatchStatusBarText, 0.2, ReputationWatchStatusBarText:GetAlpha(), 1)
    end)

    ReputationWatchBar:HookScript('OnLeave', function()
        securecall('UIFrameFadeOut', ReputationWatchStatusBarText, 0.2, ReputationWatchStatusBarText:GetAlpha(), 0) 
    end)
else
    ReputationWatchStatusBarText:Show()
    ReputationWatchStatusBarText.Hide = function() end
end