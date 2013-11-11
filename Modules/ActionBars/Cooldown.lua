local F, C, G = unpack(select(2, ...))

--[[
    Lightweight OmniCC, pulled from Tukui. You da man, dawg.
--]]

if IsAddOnLoaded("OmniCC") or IsAddOnLoaded("ncCooldown") then return end

-- Constants for dat ass
OmniCC = true -- Hax!
local ICON_SIZE = 36 -- Normal icon size (No touchy!)
local DAY, HOUR, MINUTE = 86400, 3600, 60 -- Used for formatting text
local DAYISH, HOURISH, MINUTEISH = 3600 * 23.5, 60 * 59.5, 59.5 -- Used for formatting text at transition points
local HALFDAYISH, HALFHOURISH, HALFMINUTEISH = DAY/2 + 0.5, HOUR/2 + 0.5, MINUTE/2 + 0.5 -- Used for calculating next update times

--configuration settings
F.SetDefaultActionButtonCooldownFont = C.Media.Font
F.SetDefaultActionButtonCooldownFontSize = 20 -- Base font size at scale of 1
F.SetDefaultActionButtonCooldownMinScale = 0.5 -- Minimum scale to show the cooldowns
F.SetDefaultActionButtonCooldownMinDuration = 2.5 -- Minimum duration to even bother showing cooldowns
local EXPIRING_DURATION = 5 --the minimum number of seconds a cooldown must be to use to display in the expiring format

local EXPIRING_FORMAT = F.RGBToHex(1, 0, 0)..'%.1f|r' -- AIN'T NOBODY GOT TIME FO' DAT!
local SECONDS_FORMAT = F.RGBToHex(1, 1, 0)..'%d|r' -- Seconds remaining
local MINUTES_FORMAT = F.RGBToHex(1, 1, 1)..'%dm|r' -- Minutes remaining
local HOURS_FORMAT = F.RGBToHex(0.4, 1, 1)..'%dh|r' -- Hours remaining
local DAYS_FORMAT = F.RGBToHex(0.4, 0.4, 1)..'%dh|r' -- Days remaining

-- Everybody walk that dinosaur!
local floor = math.floor
local min = math.min
local GetTime = GetTime

-- Return text to display, and how long until the next update
local function getTimeText(s)
	-- Format for below a minute
	if s < MINUTEISH then
		local seconds = tonumber(F.Round(s))
		if seconds > EXPIRING_DURATION then
			return SECONDS_FORMAT, seconds, s - (seconds - 0.51)
		else
			return EXPIRING_FORMAT, s, 0.051
		end
	-- Format as minutes when below an hour
	elseif s < HOURISH then
		local minutes = tonumber(F.Round(s/MINUTE))
		return MINUTES_FORMAT, minutes, minutes > 1 and (s - (minutes*MINUTE - HALFMINUTEISH)) or (s - MINUTEISH)
	-- Format as hours when below a day
	elseif s < DAYISH then
		local hours = tonumber(F.Round(s/HOUR))
		return HOURS_FORMAT, hours, hours > 1 and (s - (hours*HOUR - HALFHOURISH)) or (s - HOURISH)
	-- Format for days
	else
		local days = tonumber(F.Round(s/DAY))
		return DAYS_FORMAT, days,  days > 1 and (s - (days*DAY - HALFDAYISH)) or (s - DAYISH)
	end
end

-- Stop. Hammertime.
local function Timer_Stop(self)
	self.enabled = nil
	self:Hide()
end

-- Force timer to update on next frame
local function Timer_ForceUpdate(self)
	self.nextUpdate = 0
	self:Show()
end

-- Smart sizes based on Parent Frame
-- Hide if too small
local function Timer_OnSizeChanged(self, width, height)
	local fontScale = F.Round(width) / ICON_SIZE
	if fontScale == self.fontScale then
		return
	end

	self.fontScale = fontScale
	if fontScale < F.SetDefaultActionButtonCooldownMinScale then
		self:Hide()
	else
		self.text:SetFont(F.SetDefaultActionButtonCooldownFont, fontScale * F.SetDefaultActionButtonCooldownFontSize)

		if self.enabled then
			Timer_ForceUpdate(self)
		end
	end
end

-- Update timer text
-- Hide if done
local function Timer_OnUpdate(self, elapsed)
	if self.nextUpdate > 0 then
		self.nextUpdate = self.nextUpdate - elapsed
	else
		local remain = self.duration - (GetTime() - self.start)
		if tonumber(F.Round(remain)) > 0 then
			if (self.fontScale * self:GetEffectiveScale() / UIParent:GetScale()) < F.SetDefaultActionButtonCooldownMinScale then
				self.text:SetText('')
				self.nextUpdate  = 1
			else
				local formatStr, time, nextUpdate = getTimeText(remain)
				self.text:SetFormattedText(formatStr, time)
				self.nextUpdate = nextUpdate
			end
		else
			Timer_Stop(self)
		end
	end
end

-- New timers! Yay!
local function Timer_Create(self)
	-- A frame to watch for OnSizeChanged events
	-- Needed due to OnSizeChanged freakiness
	local scaler = CreateFrame('Frame', nil, self)
	scaler:SetAllPoints(self)

	local timer = CreateFrame('Frame', nil, scaler); timer:Hide()
	timer:SetAllPoints(scaler)
	timer:SetScript('OnUpdate', Timer_OnUpdate)

	local text = timer:CreateFontString(nil, 'OVERLAY')
	text:Point("CENTER", 2, 0)
	text:SetJustifyH("CENTER")
	timer.text = text

	Timer_OnSizeChanged(timer, scaler:GetSize())
	scaler:SetScript('OnSizeChanged', function(self, ...) Timer_OnSizeChanged(timer, ...) end)

	self.timer = timer
	return timer
end

-- Hook the SetCooldown method of all cooldown frames
-- ActionButton1Cooldown is used here since its likely to always exist
local function Timer_Start(self, start, duration, charges, maxCharges)
	if self.noOCC then return end
	
	--start timer
	if start > 0 and duration > F.SetDefaultActionButtonCooldownMinDuration then
		local timer = self.timer or Timer_Create(self)
		local num = charges or 0
		timer.start = start
		timer.duration = duration
		timer.charges = num
		timer.maxCharges = maxCharges
		timer.enabled = true
		timer.nextUpdate = 0
		if timer.fontScale >= F.SetDefaultActionButtonCooldownMinScale and timer.charges < 1 then
			timer:Show()
		end
	--stop timer
	else
		local timer = self.timer
		if timer then
			Timer_Stop(timer)
		end
	end
end

hooksecurefunc(getmetatable(_G["ActionButton1Cooldown"]).__index, "SetCooldown", Timer_Start)

local active = {}
local hooked = {}

local function cooldown_OnShow(self)
	active[self] = true
end

local function cooldown_OnHide(self)
	active[self] = nil
end

F.UpdateActionButtonCooldown = function(self)
	local button = self:GetParent()
	local start, duration, enable = GetActionCooldown(button.action)
	local charges, maxCharges, chargeStart, chargeDuration = GetActionCharges(button.action)

	Timer_Start(self, start, duration, charges, maxCharges)
end

local EventWatcher = CreateFrame("Frame")
EventWatcher:Hide()
EventWatcher:SetScript("OnEvent", function(self, event)
	for cooldown in pairs(active) do
		F.UpdateActionButtonCooldown(cooldown)
	end
end)
EventWatcher:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN")

local function actionButton_Register(frame)
	local cooldown = frame.cooldown
	if not hooked[cooldown] then
		cooldown:HookScript("OnShow", cooldown_OnShow)
		cooldown:HookScript("OnHide", cooldown_OnHide)
		hooked[cooldown] = true
	end
end

if _G["ActionBarButtonEventsFrame"].frames then
	for i, frame in pairs(_G["ActionBarButtonEventsFrame"].frames) do
		actionButton_Register(frame)
	end
end

hooksecurefunc("ActionBarButtonEventsFrame_RegisterFrame", actionButton_Register)