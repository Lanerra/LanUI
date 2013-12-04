local F, C, G = unpack(select(2, ...))

-- Time to skin those Blizzard Frames! This could get pretty nasty...

-- Functions all up in this mother fucker!

--[[LanSkin = {
	['Backdrop'] = LanConfig.Media.Backdrop,
	['Glow'] = 'Interface\\AddOns\\LanUI\\Media\\glowTex',
}

LanSkin.CreateBD = function(f, a)
    if not f then
        if f.SetBackdrop then
            f:SetBackdrop({
                bgFile = LanSkin.Backdrop,
            })
            f:SetBackdropColor(0, 0, 0, a or .5)
            f:SetBackdropBorderColor(0, 0, 0)
            
            f:CreateBeautyBorder(12, 1, 1, 1, 1, 2, 2, 2, 1, 1, 2, 1)
        else
            return
        end
    end
end

LanSkin.CreateSD = function(parent, size, r, g, b, alpha, offset)
    local sd = CreateFrame('Frame', nil, parent)
    
    if not r then
        r, g, b = 1, 1, 1
    end
    
	sd:SetBackdrop({
		edgeFile = LanSkin.Glow,
	})
	sd:SetBackdropBorderColor(0, 0, 0)
	sd:SetAlpha(0)
	
    sd:CreateBeautyBorder(12, r, g, b, 1, 2, 2, 2, 1, 1, 2, 1)
end

LanSkin.CreatePulse = function(frame, speed, mult, alpha) -- pulse function originally by nightcracker
	frame.speed = speed or .05
	frame.mult = mult or 1
	frame.alpha = alpha or 1
	frame.tslu = 0 -- time since last update
	frame:SetScript('OnUpdate', function(self, elapsed)
		self.tslu = self.tslu + elapsed
		if self.tslu > self.speed then
			self.tslu = 0
			self:SetAlpha(self.alpha)
		end
		self.alpha = self.alpha - elapsed*self.mult
		if self.alpha < 0 and self.mult > 0 then
			self.mult = self.mult*-1
			self.alpha = 0
		elseif self.alpha > 1 and self.mult < 0 then
			self.mult = self.mult*-1
		end
	end)
end

LanSkin.CreateTab = function(f)
    LanFunc.StripTextures(f)

	local sd = CreateFrame('Frame', nil, f)
	sd:SetBackdrop({
		bgFile = LanSkin.Backdrop,
	})
	sd:SetPoint('TOPLEFT', 13, 0)
	sd:SetPoint('BOTTOMRIGHT', -10, 0)
	sd:SetBackdropColor(unpack(LanConfig.Media.BackdropColor))
	sd:SetBackdropBorderColor(0, 0, 0)
	sd:SetFrameStrata('LOW')
	
	sd:CreateBeautyBorder(12, 1, 1, 1, 1, 1, 1, 1, 1, -1, 1, -1)
end

LanSkin.Reskin = function(f)
	local glow = CreateFrame('Frame', nil, f)
	
    --LanFunc.StripTextures(f)
    
	glow:SetBackdrop({
		edgeFile = LanSkin.Glow,
		edgeSize = 9,
	})
	glow:SetPoint('TOPLEFT', f, -6, 6)
	glow:SetPoint('BOTTOMRIGHT', f, 6, -6)
	glow:SetBackdropBorderColor(c.r, c.g, c.b)
	glow:SetAlpha(0)
	
    f:CreateBeautyBorder(12)
	
	f:SetBeautyBorderColor(1, 1, 1)
	
	f:SetNormalTexture('')
	f:SetHighlightTexture('')
	f:SetPushedTexture('')
	f:SetDisabledTexture('')

	LanSkin.CreateBD(f, .25)

	f:HookScript('OnEnter', function(self)
        self:SetBackdropBorderColor(c.r, c.g, c.b)
        self:SetBackdropColor(c.r*0.5, c.g*0.5, c.b*0.5, 0.8)
        LanSkin.CreatePulse(glow)
    end)
 	
    f:HookScript('OnLeave', function(self)
        self:SetBackdropBorderColor(0, 0, 0)
        self:SetBackdropColor(unpack(LanConfig.Media.BackdropColor))
        glow:SetScript('OnUpdate', nil)
        glow:SetAlpha(0)
    end)
end

-- Font changes
GameFontNormalHuge:SetFont(C.Media.Font, 20, 'OUTLINE')
GameFontNormalHuge:SetShadowOffset(0, 0)

GameTooltipHeaderText:SetFont(C.Media.Font, 17)
GameTooltipText:SetFont(C.Media.Font, 15)
GameTooltipTextSmall:SetFont(C.Media.Font, 15)

for _, font in pairs({
    _G['GameFontHighlight'],
    
    _G['GameFontDisable'],

    _G['GameFontHighlightExtraSmall'],
    _G['GameFontHighlightMedium'],
    
    _G['GameFontNormal'],
    _G['GameFontNormalSmall'],
    _G['GameFontNormalLarge'],
    _G['GameFontNormalHuge'],
    
    _G['TextStatusBarText'],
    
    _G['GameFontDisableSmall'],
    _G['GameFontHighlightSmall'],
}) do
    font:SetFont(C.Media.Font, 13)
end

for _, font in pairs({
    _G['AchievementPointsFont'],
    _G['AchievementPointsFontSmall'],
    _G['AchievementDescriptionFont'],
    _G['AchievementCriteriaFont'],
    _G['AchievementDateFont'],
}) do
    font:SetFont(C.Media.Font, 12)
end]]