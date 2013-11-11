local F, C, G = unpack(select(2, ...))

-------------------------------------------------------------------
--  Author: Wimpface (waStats) modifyed by Game92 @ Wowinterface --
-------------------------------------------------------------------

if (C.Tweaks.StatsFrame) then
    local statsframe = CreateFrame('Frame', 'StatsTextFrame', UIParent)
    statsframe:SetHeight(25)
    statsframe:SetPoint('TOPLEFT', Minimap, 'BOTTOMLEFT', -4, -5)
    statsframe:SetPoint('TOPRIGHT', Minimap, 'BOTTOMRIGHT', 0, -5)

    local statstext = statsframe:CreateFontString(nil, 'OVERLAY')
    statstext:SetPoint('CENTER', statsframe)
    statstext:SetHeight(10) 
    statstext:SetWidth(160)
    statstext:SetFont(C.Media.Font, 18, 'THINOUTLINE')
    statstext:SetTextColor(F.PlayerColor.r, F.PlayerColor.g, F.PlayerColor.b)

    local colorlag = function(number)
        if number <= 100 then
            return '|cff00ff00'
        elseif number <= 200 then
            return '|cffffff00'
        else
            return '|cffff0000'
        end
    end

    local colorfps = function(number)
        if number >= 30 then
            return '|cff00ff00'
        elseif number < 30 then
            return '|cffffff00'
        elseif number < 15 then
            return '|cffff0000'
        end
    end

    local interval = 0
    statsframe:SetScript('OnUpdate', function(self, elapsed)
        interval = interval - elapsed
        if interval <= 0 then
            local fps = GetFramerate()
            local latency = select(3,GetNetStats())
            statstext:SetText(string.format('%s%d|r fps %s%d|r ms', colorfps(fps), fps, colorlag(latency), latency))
            interval = 1
        end
    end)

    LanFunc.Skin(statsframe, 12, 1)
end