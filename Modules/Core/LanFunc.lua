local F, C, G = unpack(select(2, ...))

local floor = math.floor
local class = F.MyClass
local texture = C.Media.Backdrop
local backdropr, backdropg, backdropb, backdropa = unpack(C.Media.BackdropColor)
local borderr, borderg, borderb = unpack(C.Media.BorderColor)
local bordera = 1
local template
local Inset = 0

-- Workaround for 5.4.1 taint error
setfenv(WorldMapFrame_OnShow, setmetatable({ UpdateMicroButtons = function() end }, { __index = _G }))

-- Pixel perfect script of custom UI scale
local Mult = 768/string.match(F.Resolution, '%d+x(%d+)')/C.Tweaks.UIScale
local Scale = function(x)
	return Mult*math.floor(x/Mult+.5)
end

F.Scale = function(x) return Scale(x) end
F.Mult = Mult

local function UpdateColor(t)
	if t == template then return end

	if t == 'ClassColor' or t == 'Class Color' or t == 'Class' then
		local c = RAID_CLASS_COLORS[class]
		borderr, borderg, borderb = c[1], c[2], c[3]
		backdropr, backdropg, backdropb, backdropa = unpack(C.Media.BackdropColor)
	else
		borderr, borderg, borderb = unpack(C.Media.BorderColor)
		backdropr, backdropg, backdropb, backdropa = unpack(C.Media.BackdropColor)
	end
	
	template = t
end

F.PetBarUpdate = function(self, event)
	local petActionButton, petActionIcon, petAutoCastableTexture, petAutoCastShine
	for i = 1, NUM_PET_ACTION_SLOTS, 1 do
		local buttonName = "PetActionButton"..i
		petActionButton = _G[buttonName]
		petActionIcon = _G[buttonName.."Icon"]
		petAutoCastableTexture = _G[buttonName.."AutoCastable"]
		petAutoCastShine = _G[buttonName.."Shine"]
		local name, subtext, texture, isToken, isActive, autoCastAllowed, autoCastEnabled = GetPetActionInfo(i)

		if not isToken then
			petActionIcon:SetTexture(texture)
			petActionButton.tooltipName = name
		else
			petActionIcon:SetTexture(_G[texture])
			petActionButton.tooltipName = _G[name]
		end

		petActionButton.isToken = isToken
		petActionButton.tooltipSubtext = subtext

		if isActive and name ~= "PET_ACTION_FOLLOW" then
			petActionButton:SetChecked(1)
			if IsPetAttackAction(i) then
				PetActionButton_StartFlash(petActionButton)
			end
		else
			petActionButton:SetChecked(0)
			if IsPetAttackAction(i) then
				PetActionButton_StopFlash(petActionButton)
			end
		end

		if autoCastAllowed then
			petAutoCastableTexture:Show()
		else
			petAutoCastableTexture:Hide()
		end

		if autoCastEnabled then
			AutoCastShine_AutoCastStart(petAutoCastShine)
		else
			AutoCastShine_AutoCastStop(petAutoCastShine)
		end

		if name then
			petActionButton:SetAlpha(1)
		else
			petActionButton:SetAlpha(0)
		end

		if texture then
			if GetPetActionSlotUsable(i) then
				SetDesaturation(petActionIcon, nil)
			else
				SetDesaturation(petActionIcon, 1)
			end
			petActionIcon:Show()
		else
			petActionIcon:Hide()
		end

		if not PetHasActionBar() and texture and name ~= "PET_ACTION_FOLLOW" then
			PetActionButton_StopFlash(petActionButton)
			SetDesaturation(petActionIcon, 1)
			petActionButton:SetChecked(0)
		end
	end
end

F.StylePet = function()
	for _, name in pairs({
		'PetActionButton',
		'PossessButton',    
		'StanceButton', 
	}) do
		for i = 1, 12 do
			local button = _G[name..i]
			local cast = _G[name..i..'AutoCastable']
			if (button) then
				if cast then
					cast:SetAlpha(0)
					cast.SetAlpha = F.Dummy
				end

				if (not button.Shadow) then
					local normal = _G[name..i..'NormalTexture2'] or _G[name..i..'NormalTexture']
					normal:ClearAllPoints()
					normal:SetPoint('TOPRIGHT', button, 1, 1)
					normal:SetPoint('BOTTOMLEFT', button, -1, -1)
					normal:SetVertexColor(0, 0, 0, 0)
					
					local icon = _G[name..i..'Icon']
					icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
					icon:SetPoint('TOPRIGHT', button, 1, 1)
					icon:SetPoint('BOTTOMLEFT', button, -1, -1)

					local flash = _G[name..i..'Flash']
					flash:SetTexture(flashtex)

					local buttonBg = _G[name..i..'FloatingBG']
					if (buttonBg) then
						buttonBg:ClearAllPoints()
						buttonBg:SetPoint('TOPRIGHT', button, 5, 5)
						buttonBg:SetPoint('BOTTOMLEFT', button, -5, -5)
						buttonBg:SetVertexColor(0, 0, 0, 0.5)
						button.Shadow = true
					else
						button.Shadow = button:CreateTexture(nil, 'BACKGROUND')
						button.Shadow:SetParent(button) 
						button.Shadow:SetPoint('TOPRIGHT', normal, 4, 4)
						button.Shadow:SetPoint('BOTTOMLEFT', normal, -4, -4)
						button.Shadow:SetVertexColor(0, 0, 0, 0.5)
					end
				end
			end
		end
	end
end

-- API stuff

local function Size(frame, width, height)
	frame:SetSize(Scale(width), Scale(height or width))
end

local function Width(frame, width)
	frame:SetWidth(Scale(width))
end

local function Height(frame, height)
	frame:SetHeight(Scale(height))
end

local function Point(obj, arg1, arg2, arg3, arg4, arg5)
	if type(arg1)=='number' then arg1 = Scale(arg1) end
	if type(arg2)=='number' then arg2 = Scale(arg2) end
	if type(arg3)=='number' then arg3 = Scale(arg3) end
	if type(arg4)=='number' then arg4 = Scale(arg4) end
	if type(arg5)=='number' then arg5 = Scale(arg5) end

	obj:SetPoint(arg1, arg2, arg3, arg4, arg5)
end

local function SetOutside(obj, anchor, xOffset, yOffset)
	xOffset = xOffset or 2
	yOffset = yOffset or 2
	anchor = anchor or obj:GetParent()

	if obj:GetPoint() then obj:ClearAllPoints() end
	
	obj:Point('TOPLEFT', anchor, 'TOPLEFT', -xOffset, yOffset)
	obj:Point('BOTTOMRIGHT', anchor, 'BOTTOMRIGHT', xOffset, -yOffset)
end

local function SetInside(obj, anchor, xOffset, yOffset)
	xOffset = xOffset or 2
	yOffset = yOffset or 2
	anchor = anchor or obj:GetParent()

	if obj:GetPoint() then obj:ClearAllPoints() end
	
	obj:Point('TOPLEFT', anchor, 'TOPLEFT', xOffset, -yOffset)
	obj:Point('BOTTOMRIGHT', anchor, 'BOTTOMRIGHT', -xOffset, yOffset)
end

local function Filter(frame, name)
    if not frame:GetName() then return end
	local sbut = frame:GetName():match(name)
    if (sbut) then
        return true
    else
        return false
    end
end

local function SetTemplate(f, t)
	if f.skinned then return end
    texture = C.Media.Backdrop
	
	UpdateColor(t)
	
	if f.SetBackdrop and not Filter(f, 'Button') and not Filter(f, 'Overlay') then
		f:SetBackdrop({
			bgFile = texture, 
		})
		
		f:SetBackdropColor(backdropr, backdropg, backdropb, backdropa)
		f:SetBackdropBorderColor(borderr, borderg, borderb)
	end
	
	--[[if Filter(f, 'Button') then
		ChatFrame1:AddMessage('Nope, '..f:GetName()..' gets no backdrop.')
	end]]
    
    if C.Media.ClassColor == true then
        CreateBorderLight(f, C.Media.BorderSize, C.Media.BorderColor.r, C.Media.BorderColor.g, C.Media.BorderColor.b)
        SetTexture(f, 'white')
    else
        CreateBorderLight(f, C.Media.BorderSize, unpack(C.Media.BorderColor))
        SetTexture(f, 'default')
    end
	
	f.skinned = true
end

local borders = {
	'insettop',
	'insetbottom',
	'insetleft',
	'insetright',
	'insetinsidetop',
	'insetinsidebottom',
	'insetinsideleft',
	'insetinsideright',
}

local function HideInsets(f)
	for i, border in pairs(borders) do
		if f[border] then
			f[border]:SetTexture(0,0,0,0)
		end
	end
end

local function CreateBackdrop(f, t, tex)
	if f.backdrop then return end
	if not t then t = 'Default' end

	local b = CreateFrame('Frame', nil, f)
	b:Point('TOPLEFT', -2, 2)
	b:Point('BOTTOMRIGHT', 2, -2)
	b:SetTemplate(t, tex)

	if f:GetFrameLevel() - 1 >= 0 then
		b:SetFrameLevel(f:GetFrameLevel() - 1)
	else
		b:SetFrameLevel(0)
	end
	
	f.backdrop = b
end

local function Kill(object)
	if object.IsProtected then 
		if object:IsProtected() then
			error("Attempted to kill a protected object: <"..object:GetName()..">")
		end
	end
	
	if object.UnregisterAllEvents then
		object:UnregisterAllEvents()
		object:SetParent(LanUIHider)
	else
		object.Show = object.Hide
	end

	object:Hide()
end

local function StyleButton(button)
	if button.stylish then return end
	
	local path = 'Interface\\AddOns\\LanUI\\Media\\'
	local norm = _G[button:GetName()..'NormalTexture']
	
	if button.SetHighlightTexture and not button.hover then
		local hover = button:CreateTexture('frame', nil, self)
		hover:SetTexture(path..'textureHighlight')
		hover:Point('TOPRIGHT', 1, 1)
		hover:Point('BOTTOMLEFT', -1, -1)
		button.hover = hover
		button:SetHighlightTexture(hover)
	end

	if button.SetPushedTexture and not button.pushed then
		local pushed = button:CreateTexture('frame', nil, self)
		pushed:SetTexture(path..'texturePushed')
		pushed:Point('TOPRIGHT', 1, 1)
		pushed:Point('BOTTOMLEFT', -1, -1)
		button.pushed = pushed
		button:SetPushedTexture(pushed)
	end

	if button.SetCheckedTexture and not button.checked then
		local checked = button:CreateTexture('frame', nil, self)
		checked:SetTexture(path..'textureChecked')
		checked:Point('TOPRIGHT', 1, 1)
		checked:Point('BOTTOMLEFT', -1, -1)
		button.checked = checked
		button:SetCheckedTexture(checked)
	end
	
	if norm then
		norm:SetAlpha(0)
	end

	local cooldown = button:GetName() and _G[button:GetName()..'Cooldown']
	if cooldown then
		cooldown:ClearAllPoints()
		cooldown:Point('TOPRIGHT', 1, 1)
		cooldown:Point('BOTTOMLEFT', -1, -1)
	end
	
	button:SetTemplate()
	button:SetBeautyBorderPadding(2)
	
	button.stylish = true
	--ChatFrame1:AddMessage(button:GetName().. ' successfully skinned!')
end

local function FontString(parent, name, fontName, fontHeight, fontStyle)
	local fs = parent:CreateFontString(nil, 'OVERLAY')
	fs:SetFont(fontName, fontHeight, fontStyle)
	fs:SetJustifyH('LEFT')
	
	if not name then
		parent.text = fs
	else
		parent[name] = fs
	end
	
	return fs
end

local function HighlightTarget(self, event, unit)
	if self.unit == 'target' then return end
	if UnitIsUnit('target', self.unit) then
		self.HighlightTarget:Show()
	else
		self.HighlightTarget:Hide()
	end
end

local function HighlightUnit(f, r, g, b)
	if f.HighlightTarget then return end
	local glowBorder = {edgeFile = C.Media.Backdrop, edgeSize = 1}
	f.HighlightTarget = CreateFrame('Frame', nil, f)
	f.HighlightTarget:Point('TOPLEFT', f, 'TOPLEFT', -2, 2)
	f.HighlightTarget:Point('BOTTOMRIGHT', f, 'BOTTOMRIGHT', 2, -2)
	f.HighlightTarget:SetBackdrop(glowBorder)
	f.HighlightTarget:SetFrameLevel(f:GetFrameLevel() + 1)
	f.HighlightTarget:SetBackdropBorderColor(r,g,b,1)
	f.HighlightTarget:Hide()
	f:RegisterEvent('PLAYER_TARGET_CHANGED', HighlightTarget)
end

local function StripTextures(self, kill)
	for i=1, self:GetNumRegions() do
		local region = select(i, self:GetRegions())
		if region:GetObjectType() == 'Texture' then
			if kill then
				region:Kill()
			else
				region:SetTexture(nil)
			end
		end
	end		
end

-- Let's skin this bitch!

local function SetModifiedBackdrop(self)
	local color = F.PlayerColor
	self:SetBackdropColor(color.r*.15, color.g*.15, color.b*.15)
	self:SetBackdropBorderColor(color.r, color.g, color.b)
end

local function SetOriginalBackdrop(self)
	local color = F.PlayerColor
	if C.Media.ClassColor == true then
		self:SetBackdropBorderColor(color.r, color.g, color.b)
	else
		self:SetTemplate()
	end
end

local function SkinButton(f, strip)
	if f:GetName() then
		local l = _G[f:GetName()..'Left']
		local m = _G[f:GetName()..'Middle']
		local r = _G[f:GetName()..'Right']


		if l then l:SetAlpha(0) end
		if m then m:SetAlpha(0) end
		if r then r:SetAlpha(0) end
	end

	if f.Left then f.Left:SetAlpha(0) end
	if f.Right then f.Right:SetAlpha(0) end	
	if f.Middle then f.Middle:SetAlpha(0) end
	if f.SetNormalTexture then f:SetNormalTexture('') end	
	if f.SetHighlightTexture then f:SetHighlightTexture('') end
	if f.SetPushedTexture then f:SetPushedTexture('') end	
	if f.SetDisabledTexture then f:SetDisabledTexture('') end	
	if strip then StripTextures(f) end
	
	SetTemplate(f, 'Default')
	f:HookScript('OnEnter', SetModifiedBackdrop)
	f:HookScript('OnLeave', SetOriginalBackdrop)
end
F.SkinButton = SkinButton -- Compatibility, yo

local function SkinIconButton(b, shrinkIcon)
	if b.isSkinned then return end

	b:StripTextures()
	b:CreateBackdrop('Default', true)
	b:StyleButton()

	local icon = b.icon
	if b:GetName() and _G[b:GetName()..'IconTexture'] then
		icon = _G[b:GetName()..'IconTexture']
	elseif b:GetName() and _G[b:GetName()..'Icon'] then
		icon = _G[b:GetName()..'Icon']
	end

	if icon then
		icon:SetTexCoord(.08,.88,.08,.88)

		-- create a backdrop around the icon

		if shrinkIcon then
			b.backdrop:SetAllPoints()
			icon:SetInside(b)
		else
			b.backdrop:SetOutside(icon)
		end
		icon:SetParent(b.backdrop)
	end
	b.isSkinned = true
end

local function SkinScrollBar(frame)
	if _G[frame:GetName()..'BG'] then _G[frame:GetName()..'BG']:SetTexture(nil) end
	if _G[frame:GetName()..'Track'] then _G[frame:GetName()..'Track']:SetTexture(nil) end

	if _G[frame:GetName()..'Top'] then
		_G[frame:GetName()..'Top']:SetTexture(nil)
	end
	
	if _G[frame:GetName()..'Bottom'] then
		_G[frame:GetName()..'Bottom']:SetTexture(nil)
	end
	
	if _G[frame:GetName()..'Middle'] then
		_G[frame:GetName()..'Middle']:SetTexture(nil)
	end

	if _G[frame:GetName()..'ScrollUpButton'] and _G[frame:GetName()..'ScrollDownButton'] then
		StripTextures(_G[frame:GetName()..'ScrollUpButton'])
		SetTemplate(_G[frame:GetName()..'ScrollUpButton'], 'Default', true)
		if not _G[frame:GetName()..'ScrollUpButton'].texture then
			_G[frame:GetName()..'ScrollUpButton'].texture = _G[frame:GetName()..'ScrollUpButton']:CreateTexture(nil, 'OVERLAY')
			Point(_G[frame:GetName()..'ScrollUpButton'].texture, 'TOPLEFT', 2, -2)
			Point(_G[frame:GetName()..'ScrollUpButton'].texture, 'BOTTOMRIGHT', -2, 2)
			_G[frame:GetName()..'ScrollUpButton'].texture:SetTexture([[Interface\AddOns\LanUI\Media\arrowup.tga]])
			_G[frame:GetName()..'ScrollUpButton'].texture:SetVertexColor(unpack(C.Media.BorderColor))
		end	
		
		StripTextures(_G[frame:GetName()..'ScrollDownButton'])
		SetTemplate(_G[frame:GetName()..'ScrollDownButton'], 'Default', true)
	
		if not _G[frame:GetName()..'ScrollDownButton'].texture then
			_G[frame:GetName()..'ScrollDownButton'].texture = _G[frame:GetName()..'ScrollDownButton']:CreateTexture(nil, 'OVERLAY')
			Point(_G[frame:GetName()..'ScrollDownButton'].texture, 'TOPLEFT', 2, -2)
			Point(_G[frame:GetName()..'ScrollDownButton'].texture, 'BOTTOMRIGHT', -2, 2)
			_G[frame:GetName()..'ScrollDownButton'].texture:SetTexture([[Interface\AddOns\LanUI\Media\arrowdown.tga]])
			_G[frame:GetName()..'ScrollDownButton'].texture:SetVertexColor(unpack(C.Media.BorderColor))
		end				
		
		if not frame.trackbg then
			frame.trackbg = CreateFrame('Frame', nil, frame)
			Point(frame.trackbg, 'TOPLEFT', _G[frame:GetName()..'ScrollUpButton'], 'BOTTOMLEFT', 0, -1)
			Point(frame.trackbg, 'BOTTOMRIGHT', _G[frame:GetName()..'ScrollDownButton'], 'TOPRIGHT', 0, 1)
			SetTemplate(frame.trackbg, 'Transparent')
		end
		
		if frame:GetThumbTexture() then
			if not thumbTrim then thumbTrim = 3 end
			frame:GetThumbTexture():SetTexture(nil)
			if not frame.thumbbg then
				frame.thumbbg = CreateFrame('Frame', nil, frame)
				Point(frame.thumbbg, 'TOPLEFT', frame:GetThumbTexture(), 'TOPLEFT', 2, -thumbTrim)
				Point(frame.thumbbg, 'BOTTOMRIGHT', frame:GetThumbTexture(), 'BOTTOMRIGHT', -2, thumbTrim)
				SetTemplate(frame.thumbbg, 'Default', true)
				if frame.trackbg then
					frame.thumbbg:SetFrameLevel(frame.trackbg:GetFrameLevel())
				end
			end
		end	
	end	
end
F.SkinScrollBar = SkinScrollBar -- Compatibility, yo

--Tab Regions
local tabs = {
	'LeftDisabled',
	'MiddleDisabled',
	'RightDisabled',
	'Left',
	'Middle',
	'Right',
}

local function SkinTab(tab)
	if not tab then return end
	for _, object in pairs(tabs) do
		local tex = _G[tab:GetName()..object]
		if tex then
			tex:SetTexture(nil)
		end
	end
	
	if tab.GetHighlightTexture and tab:GetHighlightTexture() then
		tab:GetHighlightTexture():SetTexture(nil)
	else
		StripTextures(tab)
	end
	
	tab.backdrop = CreateFrame('Frame', nil, tab)
	SetTemplate(tab.backdrop, 'Default')
	tab.backdrop:SetFrameLevel(tab:GetFrameLevel() - 1)
    
    Point(tab.backdrop, 'TOPLEFT', 0, 0)
	Point(tab.backdrop, 'BOTTOMRIGHT', 0, 0)

    local name = tab:GetName()
    _G[name..'Text']:ClearAllPoints()
    _G[name..'Text']:SetPoint('CENTER')
    _G[name..'Text'].SetPoint = F.Dummy
end
F.SkinTab = SkinTab -- Compatibility, yo

local function SkinNextPrevButton(btn, horizonal)
	SetTemplate(btn, 'Default')
	Size(btn, btn:GetWidth() - 7, btn:GetHeight() - 7)	
	
	if horizonal then
		btn:GetNormalTexture():SetTexCoord(0.3, 0.29, 0.3, 0.72, 0.65, 0.29, 0.65, 0.72)
		btn:GetPushedTexture():SetTexCoord(0.3, 0.35, 0.3, 0.8, 0.65, 0.35, 0.65, 0.8)
		btn:GetDisabledTexture():SetTexCoord(0.3, 0.29, 0.3, 0.75, 0.65, 0.29, 0.65, 0.75)	
	else
		btn:GetNormalTexture():SetTexCoord(0.3, 0.29, 0.3, 0.81, 0.65, 0.29, 0.65, 0.81)
		if btn:GetPushedTexture() then
			btn:GetPushedTexture():SetTexCoord(0.3, 0.35, 0.3, 0.81, 0.65, 0.35, 0.65, 0.81)
		end
		if btn:GetDisabledTexture() then
			btn:GetDisabledTexture():SetTexCoord(0.3, 0.29, 0.3, 0.75, 0.65, 0.29, 0.65, 0.75)
		end
	end
	
	btn:GetNormalTexture():ClearAllPoints()
	Point(btn:GetNormalTexture(), 'TOPLEFT', 2, -2)
	Point(btn:GetNormalTexture(), 'BOTTOMRIGHT', -2, 2)
	if btn:GetDisabledTexture() then
		btn:GetDisabledTexture():SetAllPoints(btn:GetNormalTexture())
	end
	if btn:GetPushedTexture() then
		btn:GetPushedTexture():SetAllPoints(btn:GetNormalTexture())
	end
	btn:GetHighlightTexture():SetTexture(1, 1, 1, 0.3)
	btn:GetHighlightTexture():SetAllPoints(btn:GetNormalTexture())
end
F.SkinNextPrevButton = SkinNextPrevButton -- Compatibility, yo

local function SkinRotateButton(btn)
	SetTemplate(btn, 'Default')
	Size(btn, btn:GetWidth() - 14, btn:GetHeight() - 14)	
	
	btn:GetNormalTexture():SetTexCoord(0.3, 0.29, 0.3, 0.65, 0.69, 0.29, 0.69, 0.65)
	btn:GetPushedTexture():SetTexCoord(0.3, 0.29, 0.3, 0.65, 0.69, 0.29, 0.69, 0.65)	
	
	btn:GetHighlightTexture():SetTexture(1, 1, 1, 0.3)
	
	btn:GetNormalTexture():ClearAllPoints()
	Point(btn:GetNormalTexture(), 'TOPLEFT', 2, -2)
	Point(btn:GetNormalTexture(), 'BOTTOMRIGHT', -2, 2)
	btn:GetPushedTexture():SetAllPoints(btn:GetNormalTexture())	
	btn:GetHighlightTexture():SetAllPoints(btn:GetNormalTexture())
end
F.SkinRotateButton = SkinRotateButton -- Compatibility, yo

local function SkinEditBox(frame)
	if _G[frame:GetName()..'Left'] then Kill(_G[frame:GetName()..'Left']) end
	if _G[frame:GetName()..'Middle'] then Kill(_G[frame:GetName()..'Middle']) end
	if _G[frame:GetName()..'Right'] then Kill(_G[frame:GetName()..'Right']) end
	if _G[frame:GetName()..'Mid'] then Kill(_G[frame:GetName()..'Mid']) end
	CreateBackdrop(frame, 'Default')
	
	if frame:GetName() and frame:GetName():find('Silver') or frame:GetName():find('Copper') then
		Point(frame.backdrop, 'BOTTOMRIGHT', -12, -2)
	end
end
F.SkinEditBox = SkinEditBox -- Compatibility, yo

local function SkinDropDownBox(frame, width)
	local button = _G[frame:GetName()..'Button']
	if not width then width = 155 end
	
	StripTextures(frame)
	Width(frame, width)
	
	_G[frame:GetName()..'Text']:ClearAllPoints()
	Point(_G[frame:GetName()..'Text'], 'RIGHT', button, 'LEFT', -2, 0)

	button:ClearAllPoints()
	Point(button, 'RIGHT', frame, 'RIGHT', -10, 3)
	button.SetPoint = F.Dummy
	
	SkinNextPrevButton(button, true)
	
	CreateBackdrop(frame, 'Default')
	Point(frame.backdrop, 'TOPLEFT', 20, -2)
	Point(frame.backdrop, 'BOTTOMRIGHT', button, 'BOTTOMRIGHT', 2, -2)
end
F.SkinDropDownBox = SkinDropDownBox -- Compatibility, yo

local function SkinCheckBox(frame)
	StripTextures(frame)
	CreateBackdrop(frame, 'Default')
	Point(frame.backdrop, 'TOPLEFT', 4, -4)
	Point(frame.backdrop, 'BOTTOMRIGHT', -4, 4)
	
	if frame.SetCheckedTexture then
		frame:SetCheckedTexture('Interface\\Buttons\\UI-CheckBox-Check')
	end
	
	if frame.SetDisabledCheckedTexture then
		frame:SetDisabledCheckedTexture('Interface\\Buttons\\UI-CheckBox-Check-Disabled')
	end
	
	-- why does the disabled texture is always displayed as checked ?
	frame:HookScript('OnDisable', function(self)
		if not self.SetDisabledTexture then return end
		if self:GetChecked() then
			self:SetDisabledTexture('Interface\\Buttons\\UI-CheckBox-Check-Disabled')
		else
			self:SetDisabledTexture('')
		end
	end)
	
	frame.SetNormalTexture = F.Dummy
	frame.SetPushedTexture = F.Dummy
	frame.SetHighlightTexture = F.Dummy
end
F.SkinCheckBox = SkinCheckBox -- Compatibility, yo

local function SkinCloseButton(f, point)	
	if point then
		Point(f, 'TOPRIGHT', point, 'TOPRIGHT', -5, -5)
	end
	
	f:SetNormalTexture('')
	f:SetPushedTexture('')
	f:SetHighlightTexture('')
	f:SetDisabledTexture('')

	f.t = f:CreateFontString(nil, 'OVERLAY')
	f.t:SetFont(C.Media.Font, 12, 'OUTLINE')
	f.t:SetPoint('CENTER', 0, 1)
	f.t:SetText('x')
end
F.SkinCloseButton = SkinCloseButton -- Compatibility, yo

local function SkinSlideBar(frame, height, movetext)
	frame:SetTemplate('Default')
	frame:SetBackdropColor(0, 0, 0, .8)

	if not height then
		height = frame:GetHeight()
	end

	if movetext then
		if(_G[frame:GetName() .. 'Low']) then _G[frame:GetName() .. 'Low']:Point('BOTTOM', 0, -18) end
		if(_G[frame:GetName() .. 'High']) then _G[frame:GetName() .. 'High']:Point('BOTTOM', 0, -18) end
		if(_G[frame:GetName() .. 'Text']) then _G[frame:GetName() .. 'Text']:Point('TOP', 0, 19) end
	end

	_G[frame:GetName()]:SetThumbTexture(C.Media.Backdrop)
	_G[frame:GetName()]:GetThumbTexture():SetVertexColor(unpack(C.Media.BorderColor))
	if( frame:GetWidth() < frame:GetHeight() ) then
		frame:Width(height)
		_G[frame:GetName()]:GetThumbTexture():Size(frame:GetWidth(), frame:GetWidth() + 4)
	else
		frame:Height(height)
		_G[frame:GetName()]:GetThumbTexture():Size(height + 4, height)
	end
end
F.SkinSlideBar = SkinSlideBar -- Compatibility, yo

local function addapi(object)
	local mt = getmetatable(object).__index
	if not object.Size then mt.Size = Size end
	if not object.Point then mt.Point = Point end
	if not object.SetOutside then mt.SetOutside = SetOutside end
	if not object.SetInside then mt.SetInside = SetInside end
	if not object.SetTemplate then mt.SetTemplate = SetTemplate end
	if not object.CreateBackdrop then mt.CreateBackdrop = CreateBackdrop end
	if not object.StripTextures then mt.StripTextures = StripTextures end
	if not object.CreateShadow then mt.CreateShadow = CreateShadow end
	if not object.Kill then mt.Kill = Kill end
	if not object.StyleButton then mt.StyleButton = StyleButton end
	if not object.Width then mt.Width = Width end
	if not object.Height then mt.Height = Height end
	if not object.FontString then mt.FontString = FontString end
	if not object.HighlightUnit then mt.HighlightUnit = HighlightUnit end
	if not object.SkinButton then mt.SkinButton = SkinButton end
	if not object.SkinIconButton then mt.SkinIconButton = SkinIconButton end
	if not object.SkinScrollBar then mt.SkinScrollBar = SkinScrollBar end
	if not object.SkinTab then mt.SkinTab = SkinTab end
	if not object.SkinNextPrevButton then mt.SkinNextPrevButton = SkinNextPrevButton end
	if not object.SkinRotateButton then mt.SkinRotateButton = SkinRotateButton end
	if not object.SkinEditBox then mt.SkinEditBox = SkinEditBox end
	if not object.SkinDropDownBox then mt.SkinDropDownBox = SkinDropDownBox end
	if not object.SkinCheckBox then mt.SkinCheckBox = SkinCheckBox end
	if not object.SkinCloseButton then mt.SkinCloseButton = SkinCloseButton end
	if not object.SkinSlideBar then mt.SkinSlideBar = SkinSlideBar end
	if not object.HideInsets then mt.HideInsets = HideInsets end
end

local handled = {['Frame'] = true}
local object = CreateFrame('Frame')
addapi(object)
addapi(object:CreateTexture())
addapi(object:CreateFontString())

object = EnumerateFrames()
while object do
	if not handled[object:GetObjectType()] then
		addapi(object)
		handled[object:GetObjectType()] = true
	end

	object = EnumerateFrames(object)
end

function F.utf8sub(string, index, dots)
    local bytes = string:len()
    if bytes <= index then
        return string
    else
        local length, currentIndex = 0, 1

        while currentIndex <= bytes do
            length = length + 1
            local char = string:byte(currentIndex)
            if char > 240 then
                currentIndex = currentIndex + 4
            elseif char > 225 then
                currentIndex = currentIndex + 3
            elseif char > 192 then
                currentIndex = currentIndex + 2
            else
                currentIndex = currentIndex + 1
            end

            if length == index then
                break
            end
        end

        if length == index and currentIndex <= bytes then
            return string:sub(1, currentIndex - 1)..(dots and '...' or '')
        else
            return string
        end
    end
end

function F.RGBToHex(r, g, b)
	r = r <= 1 and r >= 0 and r or 0
	g = g <= 1 and g >= 0 and g or 0
	b = b <= 1 and b >= 0 and b or 0
	return string.format('|cff%02x%02x%02x', r*255, g*255, b*255)
end

function F.ShortValue(v)
	if (v >= 1e6) then
		return ('%.1fm'):format(v / 1e6):gsub('%.?0+([km])$', '%1')
	elseif (v >= 1e3 or v <= -1e3) then
		return ('%.1fk'):format(v / 1e3):gsub('%.?0+([km])$', '%1')
	else
		return v
	end
end

F.Round = function(number, decimals)
	if not decimals then decimals = 0 end
    return (('%%.%df'):format(decimals)):format(number)
end

function F.RevTable(curTab)
    if not curTab then return end
    local revTab = {}

    for _, v in pairs(curTab) do
        revTab[v] = true
    end

    return revTab
end

function F.RemoveRegions(frame, regions)
	if not frame then return end

	regions = F.RevTable(regions)

	for i = 1, frame:GetNumRegions() do
		local reg = select(i, frame:GetRegions())
		if not regions or regions and regions[i] then
			reg:SetAlpha(0)
		end
    end
end