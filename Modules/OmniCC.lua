--- Very Basic Version of OmniCC By Tuller.

local MIN_SCALE = 0.5
local MIN_DURATION = 2

local format = string.format
local floor = math.floor
local min = math.min

local function GetFormattedTime(s)
	if s >= 86400 then
		return format('%dd', floor(s/86400 + 0.5)), s % 86400
	elseif s >= 3600 then
		return format('%dh', floor(s/3600 + 0.5)), s % 3600
	elseif s >= 60 then
		return format('%dm', floor(s/60 + 0.5)), s % 60
	end
	return floor(s + 0.5), s - floor(s)
end

local function Timer_OnUpdate(self, elapsed)
	if self.text:IsShown() then
		if self.nextUpdate > 0 then
			self.nextUpdate = self.nextUpdate - elapsed
		else
			if (self:GetEffectiveScale()/UIParent:GetEffectiveScale()) < MIN_SCALE then
				self.text:SetText('')
				self.nextUpdate = 0.5
			else
				local remain = self.duration - (GetTime() - self.start)
				if floor(remain + 0.5) > 0 then
					local time, nextUpdate = GetFormattedTime(remain)
					self.text:SetText(time)
					self.nextUpdate = nextUpdate
				else
					self.text:Hide()
				end
			end
		end
	end
end

local function Timer_Create(self)
	local scale = min(self:GetParent():GetWidth() / 32, 1)
	if scale < MIN_SCALE then
		self.noOCC = true
	else
		local text = self:CreateFontString(nil, 'OVERLAY')
		text:SetPoint('CENTER', 0, -1)
		text:SetFont(LanConfig.Media.Font, 18, 'THINOUTLINE')
		text:SetTextColor(1, 1, 1)

		self.text = text
		self:SetScript('OnUpdate', Timer_OnUpdate)
		return text
	end
end

local function Timer_Start(self, start, duration)
	self.start = start
	self.duration = duration
	self.nextUpdate = 0

	local text = self.text or (not self.noOCC and Timer_Create(self))
	if text then
		text:Show()
	end
end

local methods = getmetatable(ActionButton1Cooldown).__index
hooksecurefunc(methods, 'SetCooldown', function(self, start, duration)
	if start > 0 and duration > MIN_DURATION then
		Timer_Start(self, start, duration)
	else
		local text = self.text
		if text then
			text:Hide()
		end
	end
end)