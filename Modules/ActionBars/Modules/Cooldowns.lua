local F, C, G = unpack(select(2, ...))

local active = {}
local function CooldownShow(self)
	active[self] = true
end

local function CooldownHide(self)
	active[self] = false

	local Parent = self:GetParent()
	Parent.icon:SetDesaturated(false)
	Parent:SetAlpha(1)
end

local function CreateTimer(self)
	local Timer = self:CreateAnimationGroup()
	Timer:SetLooping('NONE')
	Timer:SetScript('OnFinished', function() CooldownHide(self) end)
	Timer:CreateAnimation('Animation'):SetOrder(1)

	self.Timer = Timer
	return Timer
end

local Handler = CreateFrame('Frame')
Handler:RegisterEvent('ACTIONBAR_UPDATE_COOLDOWN')
Handler:SetScript('OnEvent', function()
	for Cooldown in pairs(active) do
		local Parent = Cooldown:GetParent()
		local Timer = Cooldown.Timer

		local _, duration = GetActionCooldown(Parent.action)
		if(duration >= 2) then
			Parent.icon:SetDesaturated(true)
			Parent:SetAlpha(1/2)

			if(not Timer) then
				Timer = CreateTimer(Cooldown)
			elseif(Timer:IsPlaying()) then
				Timer:Stop()
			end

			Timer:GetAnimations():SetDuration(duration)
			Timer:Play()
		elseif(Timer and Timer:IsPlaying()) then
			CooldownHide(Cooldown)
			Timer:Stop()
		end
	end
end)

local hooked = {}
local function RegisterCooldown(self)
	local cooldown = self.cooldown
	if(not hooked[cooldown]) then
		cooldown:HookScript('OnShow', CooldownShow)
		cooldown:HookScript('OnHide', CooldownHide)

		hooked[cooldown] = true
	end
end

if(ActionBarButtonEventsFrame.frames) then
	for index, frame in pairs(ActionBarButtonEventsFrame.frames) do
		RegisterCooldown(frame)
	end
end

hooksecurefunc('ActionBarButtonEventsFrame_RegisterFrame', RegisterCooldown)
