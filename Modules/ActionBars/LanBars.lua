local F, C, G = unpack(select(2, ...))

local FONT = C.Media.Font
local TEXTURE = C.Media.Backdrop
local BACKDROP = {
	edgeFile = TEXTURE, edgeSize = F.Mult,
	insets = {left = F.Mult, right = F.Mult, top = F.Mult, bottom = F.Mult},
}

local function UpdateButton(self)
	local Button = self:GetParent()
	local action = Button.action

	Button.icon:SetVertexColor(1, 1, 1)

	if(not IsUsableAction(action)) then
		Button.icon:SetVertexColor(0.4, 0.4, 0.4)
	else
		Button.icon:SetVertexColor(1, 1, 1)
	end
end

local function PersistentNormalTexture(self, texture)
	self:SetNormalTexture(nil)
end

local function SkinAB(name, size)
	local Button = _G[name]
	Button:SetSize(size or C.ActionBars.ButtonSize, size or C.ActionBars.ButtonSize)
	Button:SetBackdrop(BACKDROP)

	local Hotkey = _G[name .. 'HotKey']
	local CheckedTexture = Button:GetCheckedTexture()
	if(size) then
		Hotkey:SetAlpha(0)
		
		--[[hooksecurefunc('PetActionBar_Update', function()
			local name = 'PetActionButton'
			for i = 1, 12 do
				local button = _G[name..i]
				if button then
					button:SetNormalTexture(nil)
				end
			end
		end)]]
		local border  = _G[name.."Border"];
		local normal  = _G[name.."NormalTexture"];
		local normal2 = Button:GetNormalTexture()
		
		if normal then
			normal:SetTexture(nil)
			normal:Hide()
			normal:SetAlpha(0)
		end
		
		if normal2 then
			normal2:SetTexture(nil)
			normal2:Hide()
			normal2:SetAlpha(0)
		end
		
		if border then
			border:Kill()
		end

		CheckedTexture.SetAlpha = F.Dummy
		CheckedTexture:SetTexture(0, 1/2, 1, 1/3)
		CheckedTexture:ClearAllPoints()
		CheckedTexture:SetPoint('TOPRIGHT', -1, -1)
		CheckedTexture:SetPoint('BOTTOMLEFT', 1, 1)

		_G[name .. 'Shine']:SetSize(size * 0.9, size * 0.9)
		_G[name .. 'AutoCastable']:SetAlpha(0)
	elseif C.ActionBars.Hotkey == false then
		Hotkey:SetAlpha(0)
	else
		Hotkey:ClearAllPoints()
		Hotkey:SetPoint('TOPLEFT', 1, -1)
		Hotkey:SetFont(FONT, 12)

		CheckedTexture:SetTexture(nil)
	end

	local Count = _G[name .. 'Count']
	Count:ClearAllPoints()
	Count:SetPoint('BOTTOMRIGHT', 0, 1)
	Count:SetFont(FONT, 12)

	local Icon = Button.icon
	Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	Icon:SetAllPoints()

	local PushedTexture = Button:GetPushedTexture()
	PushedTexture:SetTexture(1, 1, 2/5, 1/5)
	PushedTexture:ClearAllPoints()
	PushedTexture:SetPoint('TOPRIGHT', -1, -1)
	PushedTexture:SetPoint('BOTTOMLEFT', 1, 1)

	local HighlightTexture = Button:GetHighlightTexture()
	HighlightTexture:SetTexture(0, 3/5, 1, 1/5)
	HighlightTexture:ClearAllPoints()
	HighlightTexture:SetPoint('TOPRIGHT', -1, -1)
	HighlightTexture:SetPoint('BOTTOMLEFT', 1, 1)

	local NormalTexture = _G[name .. 'NormalTexture']
	if(NormalTexture) then
		NormalTexture:SetTexture(nil)
		hooksecurefunc(NormalTexture, 'SetVertexColor', UpdateButton)
	end

	local FloatingBG = _G[name .. 'FloatingBG']
	if(FloatingBG) then
		FloatingBG:Hide()
	end

	local FlyoutBorder = _G[name .. 'FlyoutBorder']
	if(FlyoutBorder) then
		FlyoutBorder:SetTexture(nil)
	end

	local FlyoutBorderShadow = _G[name .. 'FlyoutBorderShadow']
	if(FlyoutBorderShadow) then
		FlyoutBorderShadow:SetTexture(nil)
	end

	_G[name .. 'Border']:SetTexture(nil)
	_G[name .. 'Name']:Hide()

	Button:SetTemplate()
	Button.Skinned = true
end

F.SkinAB = SkinAB

G.ActionBars.ActionButtons = {
	'ActionButton',
	'MultiBarBottomLeftButton',
	'MultiBarBottomRightButton',
	'MultiBarRightButton',
	'MultiBarLeftButton',
}
