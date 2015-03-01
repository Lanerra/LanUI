local F, C, G = unpack(select(2, ...))
local bc = C.Media.BorderColor

local function LoadSkin()
	local IconBackdrop = CreateFrame('Frame', nil, LossOfControlFrame)
	IconBackdrop:SetTemplate()
	IconBackdrop:SetOutside(LossOfControlFrame.Icon)
	IconBackdrop:SetFrameLevel(LossOfControlFrame:GetFrameLevel() - 1)

	LossOfControlFrame.Icon:SetTexCoord(.1, .9, .1, .9)
	LossOfControlFrame:StripTextures()
	LossOfControlFrame.AbilityName:ClearAllPoints()
	LossOfControlFrame.Cooldown:SetAlpha(0)

	hooksecurefunc('LossOfControlFrame_SetUpDisplay', function(self)
		self.Icon:ClearAllPoints()
		self.Icon:SetPoint('CENTER', self, 'CENTER', 0, 0)
		
		self.AbilityName:ClearAllPoints()
		self.AbilityName:SetPoint('BOTTOM', self, 0, -28)
		self.AbilityName.scrollTime = nil
		self.AbilityName:FontTemplate(C.Media.Font, 18, 'OUTLINE')
		
		self.TimeLeft.NumberText:ClearAllPoints()
		self.TimeLeft.NumberText:SetPoint('BOTTOM', self, 4, -58)
		self.TimeLeft.NumberText.scrollTime = nil
		self.TimeLeft.NumberText:FontTemplate(C.Media.Font, 18, 'OUTLINE')
		
		self.TimeLeft.SecondsText:ClearAllPoints()
		self.TimeLeft.SecondsText:SetPoint('BOTTOM', self, 0, -80)
		self.TimeLeft.SecondsText.scrollTime = nil
		self.TimeLeft.SecondsText:FontTemplate(C.Media.Font, 18, 'OUTLINE')
		
		-- always stop shake animation on start
		if self.Anim:IsPlaying() then
			self.Anim:Stop()
		end
	end)
end

tinsert(F.SkinFuncs['LanUI'], LoadSkin)