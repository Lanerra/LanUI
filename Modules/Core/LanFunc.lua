local F, C, G = unpack(select(2, ...))

local floor = math.floor
local class = F.MyClass
local texture = C.Media.Backdrop
local backdropr, backdropg, backdropb, backdropa = unpack(C.Media.BackdropColor)
local borderr, borderg, borderb = unpack(C.Media.BorderColor)
local bordera = 1
local template
local bc = C.Media.BorderColor

-- Pixel perfect script of custom UI scale
local Mult = 768/string.match(F.Resolution, '%d+x(%d+)')/C.Tweaks.UIScale
local Scale = function(x)
	return Mult*math.floor(x/Mult+.5)
end

F.Scale = function(x) return Scale(x) end
F.Mult = Mult

F.PetBarUpdate = function(self, event)
	local petActionButton, petActionIcon, petAutoCastableTexture, petAutoCastShine
	for i = 1, NUM_PET_ACTION_SLOTS, 1 do
		local buttonName = 'PetActionButton'..i
		petActionButton = _G[buttonName]
		petActionIcon = _G[buttonName..'Icon']
		petAutoCastableTexture = _G[buttonName..'AutoCastable']
		petAutoCastShine = _G[buttonName..'Shine']
		local checked = petActionButton:GetCheckedTexture()
		
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

		if isActive and name ~= 'PET_ACTION_FOLLOW' then
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
		
		petActionButton:SetAlpha(1)

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

		if not PetHasActionBar() and texture and name ~= 'PET_ACTION_FOLLOW' then
			PetActionButton_StopFlash(petActionButton)
			SetDesaturation(petActionIcon, 1)
			petActionButton:SetChecked(0)
		end
		
		checked:SetAlpha(0.3)
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
				
				if button.SetCheckedTexture and not button.checked then
					local checked = button:CreateTexture('frame', nil, self)
					checked:SetTexture(0,1,0,.3)
					checked:Point('TOPLEFT', 1, -1)
					checked:Point('BOTTOMRIGHT', -1, 1)
					button.checked = checked
					button:SetCheckedTexture(checked)
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
	xOffset = xOffset or F.Mult
	yOffset = yOffset or F.Mult
	anchor = anchor or obj:GetParent()

	if obj:GetPoint() then obj:ClearAllPoints() end
	
	obj:Point('TOPLEFT', anchor, 'TOPLEFT', -xOffset, yOffset)
	obj:Point('BOTTOMRIGHT', anchor, 'BOTTOMRIGHT', xOffset, -yOffset)
end

local function SetInside(obj, anchor, xOffset, yOffset)
	xOffset = xOffset or F.Mult
	yOffset = yOffset or F.Mult
	anchor = anchor or obj:GetParent()

	if obj:GetPoint() then obj:ClearAllPoints() end
	
	obj:Point('TOPLEFT', anchor, 'TOPLEFT', xOffset, -yOffset)
	obj:Point('BOTTOMRIGHT', anchor, 'BOTTOMRIGHT', -xOffset, yOffset)
end

local function SetTemplate(frame, nobd)
	if frame.skinned then return end
    local f
	
	if frame:GetObjectType() == "Texture" then
		f = frame:GetParent()
	else
		f = frame
	end
	
	if not nobd then
		local lvl = f:GetFrameLevel()

		local bg = CreateFrame("Frame", nil, f)
		bg:SetParent(f)
		bg:SetInside()
		bg:SetFrameLevel(lvl == 0 and 1 or lvl - 1)

		bg:SetBackdrop({
			bgFile = C.Media.Backdrop,
			edgeFile = C.Media.Backdrop,
			edgeSize = F.Mult,
		})

		bg:SetBackdropColor(unpack(C.Media.BackdropColor))
		bg:SetBackdropBorderColor(bc.r, bc.g, bc.b)

		f.backdrop = bg
	end
    
    if C.Media.ClassColor == true then
        CreateBorderLight(f.backdrop or f, C.Media.BorderSize, bc.r, bc.g, bc.b)
        SetTexture(f.backdrop or f, 'white')
    else
        CreateBorderLight(f.backdrop or f, C.Media.BorderSize, bc.r, bc.g, bc.b)
        SetTexture(f.backdrop or f, 'default')
    end
	
	if f.backdrop then
		f.backdrop:SetBeautyBorderPadding(1)
	else
		f:SetBeautyBorderPadding(1)
	end
	f.skinned = true
end
F.SetTemplate = SetTemplate -- Compatibility, yo

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

local function Kill(object)
	if object.IsProtected then 
		if object:IsProtected() then
			error('Attempted to kill a protected object: <'..object:GetName()..'>')
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

function StyleButton(button)
	if button.isSkinned then return end
	
	local name = button:GetName()
	
	if button.GetNormalTexture and name then
		local normal = button:GetNormalTexture()
		if normal then
			normal:ClearAllPoints()
			normal:SetPoint('TOPRIGHT', button, 1, 1)
			normal:SetPoint('BOTTOMLEFT', button, -1, -1)
			normal:SetVertexColor(0, 0, 0, 0)
		end
	end
	
	if button.SetHighlightTexture and not button.hover then
		local hover = button:CreateTexture('frame', nil, self)
		hover:SetTexture(1, 1, 1, 0.3)
		hover:Point('TOPLEFT', 1, -1)
		hover:Point('BOTTOMRIGHT', -1, 1)
		button.hover = hover
		button:SetHighlightTexture(hover)
	end

	if button.SetPushedTexture and not button.pushed then
		local pushed = button:CreateTexture('frame', nil, self)
		pushed:SetTexture(0.9, 0.8, 0.1, 0.3)
		pushed:Point('TOPLEFT', 1, -1)
		pushed:Point('BOTTOMRIGHT', -1, 1)
		button.pushed = pushed
		button:SetPushedTexture(pushed)
	end

	if button.SetCheckedTexture and not button.checked then
		local checked = button:CreateTexture('frame', nil, self)
		checked:SetTexture(0,1,0,.3)
		checked:Point('TOPLEFT', 1, -1)
		checked:Point('BOTTOMRIGHT', -1, 1)
		button.checked = checked
		button:SetCheckedTexture(checked)
	end

	local cooldown = button:GetName() and _G[button:GetName()..'Cooldown']
	if cooldown then
		cooldown:ClearAllPoints()
		cooldown:Point('TOPLEFT', 1, -1)
		cooldown:Point('BOTTOMRIGHT', -1, 1)
	end
	
	button.isSkinned = true
end
F.StyleButton = StyleButton -- Compatibility, yo

local function FontString(parent, name, fontName, fontHeight, fontStyle, justify)
	local fs = parent:CreateFontString(nil, 'OVERLAY')
	fs:SetFont(fontName or C.Media.Font, fontHeight or C.Media.FontSize, fontStyle or '')
	fs:SetJustifyH(justify or 'LEFT')
	
	if not name then
		parent.text = fs
	else
		parent[name] = fs
	end
	
	return fs
end

local function StripTextures(object, kill)
	for i = 1, object:GetNumRegions() do
		local region = select(i, object:GetRegions())
		if region and region:GetObjectType() == "Texture" then
			if kill and type(kill) == 'boolean' then
				region:Kill()
			elseif region:GetDrawLayer() == kill then
				region:SetTexture(nil)
			elseif kill and type(kill) == 'string' and region:GetTexture() ~= kill then
				region:SetTexture(nil)
			else
				region:SetTexture(nil)
			end
		end
	end
end

-- Let's skin this bitch!

local function SetModifiedBackdrop(self)
	local color = F.PlayerColor
	self.backdrop:SetBackdropColor(bc.r*0.5, bc.g*0.5, bc.b*0.5, 0.8)
	self.backdrop:SetBackdropBorderColor(color.r, color.g, color.b)
end

local function SetOriginalBackdrop(self)
	local color = F.PlayerColor
	
	self.backdrop:SetBackdropColor(unpack(C.Media.BackdropColor))
end

local function CreateBD(frame, border)
	local f
	local bdColor = C.Media.BackdropColor
	
	if frame:GetObjectType() == "Texture" then
		f = frame:GetParent()
	else
		f = frame
	end

	local lvl = f:GetFrameLevel()

	local bg = CreateFrame("Frame", nil, f)
	bg:SetParent(f)
	bg:SetInside()
	bg:SetFrameLevel(lvl == 0 and 1 or lvl - 1)

	bg:SetBackdrop({
		bgFile = C.Media.Backdrop,
		edgeFile = C.Media.Backdrop,
		edgeSize = F.Mult,
	})

	bg:SetBackdropColor(unpack(bdColor))
	bg:SetBackdropBorderColor(bc.r, bc.g, bc.b)
	
	if border then
		bg:SetTemplate(true)
	end
	
	f.backdrop = bg
end
F.CreateBD = CreateBD -- Compatibility, yo

local function CreatePulse(frame, speed, mult, alpha) -- pulse function originally by nightcracker
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
		
		self.alpha = self.alpha - elapsed * self.mult
		
		if self.alpha < 0 and self.mult > 0 then
			self.mult = self.mult * -1
			self.alpha = 0
		elseif self.alpha > 1 and self.mult < 0 then
			self.mult = self.mult * -1
		end
	end)
end
F.CreatePulse = CreatePulse -- Compatibility, yo

local function Reskin(f)
	local glow = CreateFrame('Frame', nil, f)
	
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
	
	glow:SetBackdrop({
		edgeFile = C.Media.Glow,
		edgeSize = 9,
	})
	
	glow:SetPoint('TOPLEFT', f, -6, 6)
	glow:SetPoint('BOTTOMRIGHT', f, 6, -6)
	glow:SetBackdropBorderColor(bc.r, bc.g, bc.b)
	glow:SetAlpha(0)
	
    f:SetTemplate()
	f:SetBackdropColor(bc.r * .25, bc.g * .25, bc.b * .25, 0.5)
	
	f:SetNormalTexture('')
	f:SetHighlightTexture('')
	f:SetPushedTexture('')
	f:SetDisabledTexture('')

	f:HookScript('OnEnter', function(self)
        SetModifiedBackdrop(self)
        glow:CreatePulse()
    end)
 	
    f:HookScript('OnLeave', function(self)
		SetOriginalBackdrop(self)
        glow:SetScript('OnUpdate', nil)
        glow:SetAlpha(0)
    end)
end
F.Reskin = Reskin -- Compatibility, yo

function SkinButton(f, strip)
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
	
	SetTemplate(f)
	f:SetBackdropColor(bc.r * .25, bc.g * .25, bc.b * .25, 0.5)
	f:HookScript('OnEnter', SetModifiedBackdrop)
	f:HookScript('OnLeave', SetOriginalBackdrop)
end
F.SkinButton = SkinButton -- Compatibility, yo

local function SkinIconButton(b, shrinkIcon)
	if b.isSkinned then return end

	b:StripTextures()
	b:CreateBD()
	b:StyleButton()

	local icon = b.icon
	if b:GetName() and _G[b:GetName()..'IconTexture'] then
		icon = _G[b:GetName()..'IconTexture']
	elseif b:GetName() and _G[b:GetName()..'Icon'] then
		icon = _G[b:GetName()..'Icon']
	end

	if icon then
		icon:SetTexCoord(unpack(F.TexCoords))

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
F.SkinIconButton = SkinIconButton

function SkinScrollBar(frame)
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
		if not _G[frame:GetName()..'ScrollUpButton'].texture then
			_G[frame:GetName()..'ScrollUpButton'].texture = _G[frame:GetName()..'ScrollUpButton']:CreateTexture(nil, 'OVERLAY')
			Point(_G[frame:GetName()..'ScrollUpButton'].texture, 'TOPLEFT', 2, -2)
			Point(_G[frame:GetName()..'ScrollUpButton'].texture, 'BOTTOMRIGHT', -2, 2)
			_G[frame:GetName()..'ScrollUpButton'].texture:SetTexture([[Interface\AddOns\LanUI\Media\arrowup.tga]])
			_G[frame:GetName()..'ScrollUpButton'].texture:SetVertexColor(bc.r, bc.g, bc.b)
		end	
		
		StripTextures(_G[frame:GetName()..'ScrollDownButton'])
	
		if not _G[frame:GetName()..'ScrollDownButton'].texture then
			_G[frame:GetName()..'ScrollDownButton'].texture = _G[frame:GetName()..'ScrollDownButton']:CreateTexture(nil, 'OVERLAY')
			Point(_G[frame:GetName()..'ScrollDownButton'].texture, 'TOPLEFT', 2, -2)
			Point(_G[frame:GetName()..'ScrollDownButton'].texture, 'BOTTOMRIGHT', -2, 2)
			_G[frame:GetName()..'ScrollDownButton'].texture:SetTexture([[Interface\AddOns\LanUI\Media\arrowdown.tga]])
			_G[frame:GetName()..'ScrollDownButton'].texture:SetVertexColor(bc.r, bc.g, bc.b)
		end				
		
		if not frame.trackbg then
			frame.trackbg = CreateFrame('Frame', nil, frame)
			Point(frame.trackbg, 'TOPLEFT', _G[frame:GetName()..'ScrollUpButton'], 'BOTTOMLEFT', 0, -1)
			Point(frame.trackbg, 'BOTTOMRIGHT', _G[frame:GetName()..'ScrollDownButton'], 'TOPRIGHT', 0, 1)
			SetTemplate(frame.trackbg, true)
			frame.trackbg:SetBeautyBorderPadding(2)
		end
		
		if frame:GetThumbTexture() then
			if not thumbTrim then thumbTrim = 3 end
			frame:GetThumbTexture():SetTexture(bc.r, bc.g, bc.b)
			frame:GetThumbTexture():SetPoint('TOP', frame, 0, -thumbTrim)
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

function SkinTab(tab)
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
	tab.backdrop:SetTemplate()
	tab.backdrop:SetBeautyBorderPadding(0)
	tab.backdrop:SetFrameLevel(tab:GetFrameLevel() - 1)
    
    Point(tab.backdrop, 'TOPLEFT', 0, 0)
	Point(tab.backdrop, 'BOTTOMRIGHT', 0, 0)

    local name = tab:GetName()
	
	if not _G[name..'Text'] then
		for i = 1, tab:GetNumRegions() do
			local object = select(i, tab:GetRegions())
			if object:GetObjectType() == 'FontString' then
				object:ClearAllPoints()
				object:SetPoint('CENTER')
				object.SetPoint = F.Dummy
			end
		end
	else
		_G[name..'Text']:ClearAllPoints()
		_G[name..'Text']:SetPoint('CENTER')
		_G[name..'Text'].SetPoint = F.Dummy
	end
	
	tab:SetFrameStrata('BACKGROUND')
	
	if tab:GetParent():GetFrameLevel() ~= 0 then
		tab:SetFrameLevel(tab:GetParent():GetFrameLevel() - 1)
	end
end
F.SkinTab = SkinTab -- Compatibility, yo

function SkinNextPrevButton(btn, horizonal)
	--SetTemplate(btn)
	Size(btn, btn:GetWidth() - 15, btn:GetHeight() - 15)
	
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
	SetTemplate(btn)
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

function SkinIcon(icon, parent)
	parent = parent or icon:GetParent()
	
	icon:SetTexCoord(unpack(F.TexCoords))
	parent:CreateBD()
	icon:SetParent(parent.backdrop)
	parent.backdrop:SetOutside(icon)
end
F.SkinIcon = SkinIcon

function SkinEditBox(frame)
	frame:CreateBD()

	if frame.TopLeftTex then frame.TopLeftTex:Kill() end
	if frame.TopRightTex then frame.TopRightTex:Kill() end
	if frame.TopTex then frame.TopTex:Kill() end
	if frame.BottomLeftTex then frame.BottomLeftTex:Kill() end
	if frame.BottomRightTex then frame.BottomRightTex:Kill() end
	if frame.BottomTex then frame.BottomTex:Kill() end
	if frame.LeftTex then frame.LeftTex:Kill() end
	if frame.RightTex then frame.RightTex:Kill() end
	if frame.MiddleTex then frame.MiddleTex:Kill() end
	
	if frame:GetName() then
		if _G[frame:GetName().."Left"] then _G[frame:GetName().."Left"]:Kill() end
		if _G[frame:GetName().."Middle"] then _G[frame:GetName().."Middle"]:Kill() end
		if _G[frame:GetName().."Right"] then _G[frame:GetName().."Right"]:Kill() end
		if _G[frame:GetName().."Mid"] then _G[frame:GetName().."Mid"]:Kill() end
		
		if frame:GetName():find("Silver") or frame:GetName():find("Copper") then
			frame.backdrop:Point("BOTTOMRIGHT", -12, -2)
		end		
	end

	if(frame.Left) then
		frame.Left:Kill()
	end

	if(frame.Right) then
		frame.Right:Kill()
	end

	if(frame.Middle) then
		frame.Middle:Kill()
	end
end
F.SkinEditBox = SkinEditBox -- Compatibility, yo

function SkinDropDownBox(frame, width)
	local button = _G[frame:GetName()..'Button']
	if not width then width = 155 end
	
	StripTextures(frame)
	Width(frame, width)
	
	_G[frame:GetName()..'Text']:ClearAllPoints()
	Point(_G[frame:GetName()..'Text'], 'RIGHT', button, 'LEFT', -2, 0)

	button:ClearAllPoints()
	Point(button, 'RIGHT', frame, 'RIGHT', -10, 0)
	button.SetPoint = F.Dummy
end
F.SkinDropDownBox = SkinDropDownBox -- Compatibility, yo

function SkinCheckBox(frame)
	StripTextures(frame)
	CreateBD(frame)
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

function SkinCloseButton(f, point)	
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

function SkinSlideBar(frame, height, movetext)
	--frame:SetTemplate()
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
	_G[frame:GetName()]:GetThumbTexture():SetVertexColor(bc.r, bc.g, bc.b)
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
	if not object.CreateBD then mt.CreateBD = CreateBD end
	if not object.CreatePulse then mt.CreatePulse = CreatePulse end
	if not object.Reskin then mt.Reskin = Reskin end
	if not object.CreateBackdrop then mt.CreateBackdrop = CreateBD end
	if not object.SkinIcon then mt.SkinIcon = SkinIcon end
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

------------------------------------------------------------------------
-- Add time before calling a function
-- Usage: F.Delay(seconds, functionToCall, ...)
------------------------------------------------------------------------

local waitTable = {}
local waitFrame
F.Delay = function(delay, func, ...)
	if(type(delay)~="number" or type(func)~="function") then
		return false
	end
	if(waitFrame == nil) then
		waitFrame = CreateFrame("Frame","WaitFrame", UIParent)
		waitFrame:SetScript("onUpdate",function (self,elapse)
			local count = #waitTable
			local i = 1
			while(i<=count) do
				local waitRecord = tremove(waitTable,i)
				local d = tremove(waitRecord,1)
				local f = tremove(waitRecord,1)
				local p = tremove(waitRecord,1)
				if(d>elapse) then
				  tinsert(waitTable,i,{d-elapse,f,p})
				  i = i + 1
				else
				  count = count - 1
				  f(unpack(p))
				end
			end
		end)
	end
	tinsert(waitTable,{delay,func,{...}})
	return true
end

-- Unitframe tester
local function TestBase()
	for _, v in pairs(oUF.objects) do
		v.unit = "target"
		local buffs = v.Buffs or v.Auras
		local debuffs = v.Debuffs
		if buffs and buffs.CustomFilter then
			buffs.CustomFilter = nil
		end
		if debuffs and debuffs.CustomFilter then
			debuffs.CustomFilter = nil
		end
		v.Hide = function() return end
		v:Show()
	end
	local time = 0
	local f = CreateFrame("Frame")
	f:SetScript("OnUpdate", function(self, elapsed)
		time = time + elapsed
		if ( time > 2 ) then
			for _, v in pairs(oUF.objects) do
				v:UpdateAllElements("OptionsRefresh")
			end
			time = 0
		end
	end)
end

------------------------------------------------------------------------
-- Skinning
------------------------------------------------------------------------

F.SkinFuncs = {}
F.SkinFuncs['LanUI'] = {}

local LoadBlizzardSkin = CreateFrame('Frame')
LoadBlizzardSkin:RegisterEvent('ADDON_LOADED')
LoadBlizzardSkin:SetScript('OnEvent', function(self, event, addon)
	if IsAddOnLoaded('Skinner') or IsAddOnLoaded('Aurora') then
		self:UnregisterEvent('ADDON_LOADED')
		return 
	end
	
	for _addon, skinfunc in pairs(F.SkinFuncs) do
		if type(skinfunc) == 'function' then
			if _addon == addon then
				if skinfunc then
					skinfunc()
				end
			end
		elseif type(skinfunc) == 'table' then
			if _addon == addon then
				for _, skinfunc in pairs(F.SkinFuncs[_addon]) do
					if skinfunc then
						skinfunc()
					end
				end
			end
		end
	end
end)