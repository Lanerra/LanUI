local F, C, G = unpack(select(2, ...))

local floor = math.floor
local class = F.MyClass
local texture = C.Media.Backdrop
local backdropr, backdropg, backdropb, backdropa = unpack(C.Media.BackdropColor)
local borderr, borderg, borderb = unpack(C.Media.BorderColor)
local bordera = 1
local template
local bc = C.Media.BorderColor

F.Texts = {}

local scale = max(0.64, min(1.15, 768/F.ScreenHeight))

-- Pixel perfect script of custom UI scale
local Mult = 768/string.match(F.Resolution, '%d+x(%d+)')/scale
local Scale = function(x)
	return Mult*math.floor(x/Mult+.5)
end

F.Scale = function(x) return Scale(x) end
F.Mult = Mult

F.PetBarUpdate = function(self, event)
	for i = 1, NUM_PET_ACTION_SLOTS, 1 do
		local ButtonName = "PetActionButton" .. i
		local PetActionButton = _G[ButtonName]
		local PetActionIcon = _G[ButtonName.."Icon"]
		local PetActionBackdrop = PetActionButton.Backdrop
		local PetAutoCastableTexture = _G[ButtonName.."AutoCastable"]
		local PetAutoCastShine = _G[ButtonName.."Shine"]
		local Name, SubText, Texture, IsToken, IsActive, AutoCastAllowed, AutoCastEnabled = GetPetActionInfo(i)

		if (not IsToken) then
			PetActionIcon:SetTexture(Texture)
			PetActionButton.tooltipName = Name
		else
			PetActionIcon:SetTexture(_G[Texture])
			PetActionButton.tooltipName = _G[Name]
		end

		PetActionButton.IsToken = IsToken
		PetActionButton.tooltipSubtext = SubText
		
		if (IsActive) then
			PetActionButton:SetChecked(1)
			
			if PetActionBackdrop then
				PetActionBackdrop:SetBackdropBorderColor(0, 1, 0)
			end
			
			if IsPetAttackAction(i) then
				PetActionButton_StartFlash(PetActionButton)
			end
		else
			PetActionButton:SetChecked()
			
			if PetActionBackdrop then
				PetActionBackdrop:SetBackdropBorderColor(unpack(C.Media.BorderColor))
			end
			
			if IsPetAttackAction(i) then
				PetActionButton_StopFlash(PetActionButton)
			end			
		end

		if AutoCastAllowed then
			PetAutoCastableTexture:Show()
		else
			PetAutoCastableTexture:Hide()
		end
		
		if AutoCastEnabled then
			AutoCastShine_AutoCastStart(PetAutoCastShine)
		else
			AutoCastShine_AutoCastStop(PetAutoCastShine)
		end
		
		if Texture then
			if (GetPetActionSlotUsable(i)) then
				SetDesaturation(PetActionIcon, nil)
			else
				SetDesaturation(PetActionIcon, 1)
			end
			
			PetActionIcon:Show()
		else
			PetActionIcon:Hide()
		end
		
		if (not PetHasActionBar() and Texture and Name ~= "PET_ACTION_FOLLOW") then
			PetActionButton_StopFlash(PetActionButton)
			SetDesaturation(PetActionIcon, 1)
			PetActionButton:SetChecked(0)
		end
		
		if i == 1 then
			PetActionButton:GetCheckedTexture():ClearAllPoints()
			PetActionButton:GetCheckedTexture():SetAllPoints()
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

	if obj:GetPoint() then
		obj:ClearAllPoints()
	end
	
	obj:Point('TOPLEFT', anchor, 'TOPLEFT', -xOffset, yOffset)
	obj:Point('BOTTOMRIGHT', anchor, 'BOTTOMRIGHT', xOffset, -yOffset)
end

local function SetInside(obj, anchor, xOffset, yOffset)
	xOffset = xOffset or F.Mult
	yOffset = yOffset or F.Mult
	anchor = anchor or obj:GetParent()

	if obj:GetPoint() then
		obj:ClearAllPoints()
	end
	
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
		bg:SetOutside()
		bg:SetFrameLevel(lvl == 0 and 1 or lvl - 1)

		bg:SetBackdrop({
		  bgFile = C.Media.Backdrop, 
		  edgeFile = C.Media.Backdrop, 
		  tile = false, tileSize = 0, edgeSize = F.Mult, 
		  insets = { left = 0, right = 0, top = 0, bottom = 0}
		})	

		bg:SetBackdropColor(unpack(C.Media.BackdropColor))
		bg:SetBackdropBorderColor(bc.r, bc.g, bc.b)

		f.backdrop = bg
	end
    
	frame.skinned = true
	frame = nil
	f = nil
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
	
	if button.SetNormalTexture then
		button:SetNormalTexture("")
		button.SetNormalTexture = F.Dummy
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

local function FontTemplate(fs, font, fontSize, fontStyle)
	fs.font = font
	fs.fontSize = fontSize
	fs.fontStyle = fontStyle

	font = font or C.Media.Font
	fontSize = fontSize or C.Media.FontSize
	fontStyle = fontStyle or C.Media.FontStyle

	if fontStyle == 'OUTLINE' then
		if (fontSize > 10 and not fs.fontSize) then
			fontStyle = 'MONOCHROMEOUTLINE'
			fontSize = 10
		end
	end

	fs:SetFont(font, fontSize, fontStyle)
	if fontStyle then
		fs:SetShadowColor(0, 0, 0, 0.2)
	else
		fs:SetShadowColor(0, 0, 0, 1)
	end
	fs:SetShadowOffset((F.Mult or 1), -(F.Mult or 1))

	F['Texts'][fs] = true
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
	if frame.backdrop then return end
	
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
	bg:SetOutside()
	bg:SetFrameLevel(lvl == 0 and 1 or lvl - 1)

	bg:SetBackdrop({
		  bgFile = C.Media.Backdrop, 
		  edgeFile = C.Media.Backdrop, 
		  tile = false, tileSize = 0, edgeSize = F.Mult, 
		  insets = { left = 0, right = 0, top = 0, bottom = 0}
		})	

	bg:SetBackdropColor(unpack(bdColor))
	bg:SetBackdropBorderColor(bc.r, bc.g, bc.b)
	
	--[[if border then
		bg:SetTemplate(true)
	end]]
	
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
	local name = f:GetName()
	
	if f.Left then f.Left:SetAlpha(0) end
	if f.Middle then f.Middle:SetAlpha(0) end
	if f.Right then f.Right:SetAlpha(0) end
	
	if f.SetNormalTexture then
		f:SetNormalTexture("")
		f.SetNormalTexture = F.Dummy
	end
	
	if f.SetHighlightTexture then f:SetHighlightTexture("") end
	
	if f.SetPushedTexture then f:SetPushedTexture("") end
	
	if f.SetDisabledTexture then f:SetDisabledTexture("") end
	
	if strip then f:StripTextures() end
	
	f:SetTemplate()
	f:SetBackdropColor(bc.r * .25, bc.g * .25, bc.b * .25, 0.5)
	f:HookScript('OnEnter', SetModifiedBackdrop)
	f:HookScript('OnLeave', SetOriginalBackdrop)
end
F.SkinButton = SkinButton -- Compatibility, yo

function SkinIconButton(b, shrinkIcon)
	if b.isSkinned then return; end

	local icon = b.icon or b.IconTexture or b.iconTexture
	local texture
	if b:GetName() and _G[b:GetName()..'IconTexture'] then
		icon = _G[b:GetName()..'IconTexture']
	elseif b:GetName() and _G[b:GetName()..'Icon'] then
		icon = _G[b:GetName()..'Icon']
	end

	if(icon and icon:GetTexture()) then
		texture = icon:GetTexture()
	end

	b:StripTextures()
	b:CreateBD()
	b:StyleButton()
	
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

		if(texture) then
			icon:SetTexture(texture)
		end
	end
	b.isSkinned = true
end
F.SkinIconButton = SkinIconButton

function SkinScrollBar(frame)
	if _G[frame:GetName().."BG"] then _G[frame:GetName().."BG"]:SetTexture(nil) end
	if _G[frame:GetName().."Track"] then _G[frame:GetName().."Track"]:SetTexture(nil) end
	
	if _G[frame:GetName().."Top"] then
		_G[frame:GetName().."Top"]:SetTexture(nil)
	end
	
	if _G[frame:GetName().."Bottom"] then
		_G[frame:GetName().."Bottom"]:SetTexture(nil)
	end
	
	if _G[frame:GetName().."Middle"] then
		_G[frame:GetName().."Middle"]:SetTexture(nil)
	end

	if _G[frame:GetName().."ScrollUpButton"] and _G[frame:GetName().."ScrollDownButton"] then
		_G[frame:GetName().."ScrollUpButton"]:StripTextures()
		if not _G[frame:GetName().."ScrollUpButton"].icon then
			SkinNextPrevButton(_G[frame:GetName().."ScrollUpButton"])
			SquareButton_SetIcon(_G[frame:GetName().."ScrollUpButton"], 'UP')
			_G[frame:GetName().."ScrollUpButton"]:Size(_G[frame:GetName().."ScrollUpButton"]:GetWidth() + 7, _G[frame:GetName().."ScrollUpButton"]:GetHeight() + 7)	
		end
		
		_G[frame:GetName().."ScrollDownButton"]:StripTextures()
		if not _G[frame:GetName().."ScrollDownButton"].icon then
			SkinNextPrevButton(_G[frame:GetName().."ScrollDownButton"])
			SquareButton_SetIcon(_G[frame:GetName().."ScrollDownButton"], 'DOWN')
			_G[frame:GetName().."ScrollDownButton"]:Size(_G[frame:GetName().."ScrollDownButton"]:GetWidth() + 7, _G[frame:GetName().."ScrollDownButton"]:GetHeight() + 7)	
		end		
		
		if not frame.trackbg then
			frame.trackbg = CreateFrame("Frame", nil, frame)
			frame.trackbg:Point("TOPLEFT", _G[frame:GetName().."ScrollUpButton"], "BOTTOMLEFT", 0, -1)
			frame.trackbg:Point("BOTTOMRIGHT", _G[frame:GetName().."ScrollDownButton"], "TOPRIGHT", 0, 1)
			frame.trackbg:CreateBD()
		end
		
		if frame:GetThumbTexture() then
			if not thumbTrim then thumbTrim = 3 end
			frame:GetThumbTexture():SetTexture(nil)
			if not frame.thumbbg then
				frame.thumbbg = CreateFrame("Frame", nil, frame)
				frame.thumbbg:Point("TOPLEFT", frame:GetThumbTexture(), "TOPLEFT", 2, -thumbTrim)
				frame.thumbbg:Point("BOTTOMRIGHT", frame:GetThumbTexture(), "BOTTOMRIGHT", -2, thumbTrim)
				frame.thumbbg:CreateBD()
				frame.thumbbg.backdrop:SetBackdropColor(C.Media.BorderColor.r, C.Media.BorderColor.g, C.Media.BorderColor.b)
				frame.thumbbg.backdrop:SetInside()
				--frame.thumbbg:SetTemplate(true)
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

function SkinTab(tab)
	if not tab then return end
	
	local point1, anchor, point2, x, y = tab:GetPoint()
	
	for _, object in pairs(tabs) do
		local tex = _G[tab:GetName()..object]
		if tex then
			tex:SetTexture(nil)
		end
	end
	
	if tab.GetHighlightTexture and tab:GetHighlightTexture() then
		tab:GetHighlightTexture():SetTexture(nil)
	else
		tab:StripTextures()
	end
	
	tab.backdrop = CreateFrame("Frame", nil, tab)
	tab.backdrop:SetTemplate()
	tab.backdrop:SetFrameLevel(tab:GetFrameLevel() - 1)
	tab.backdrop:Point("TOPLEFT", 10, -1)
	tab.backdrop:Point("BOTTOMRIGHT", -10, 2)	
	tab.backdrop:SetFrameLevel(tab:GetFrameLevel() - 1)

    local name = tab:GetName()
	
	if not _G[name..'Text'] then
		for i = 1, tab:GetNumRegions() do
			local object = select(i, tab:GetRegions())
			if object:GetObjectType() == 'FontString' then
				object:ClearAllPoints()
				object:SetPoint('CENTER')
				object:SetJustifyH('CENTER')
				object.SetPoint = F.Dummy
			end
		end
	else
		_G[name..'Text']:ClearAllPoints()
		_G[name..'Text']:SetPoint('CENTER')
		_G[name..'Text']:SetJustifyH('CENTER')
		_G[name..'Text'].SetPoint = F.Dummy
	end
	
	tab:SetFrameStrata('BACKGROUND')
	
	if tab:GetParent():GetFrameLevel() ~= 0 then
		tab:SetFrameLevel(tab:GetParent():GetFrameLevel() - 1)
	end
end
F.SkinTab = SkinTab -- Compatibility, yo

function SkinNextPrevButton(btn, horizonal)
	local norm, pushed, disabled
	local inverseDirection = btn:GetName() and (strfind(btn:GetName():lower(), 'left') or strfind(btn:GetName():lower(), 'prev') or strfind(btn:GetName():lower(), 'decrement'))
	
	btn:StripTextures()
	btn:SetNormalTexture(nil)
	btn:SetPushedTexture(nil)
	btn:SetHighlightTexture(nil)
	btn:SetDisabledTexture(nil)

	if not btn.icon then
		btn.icon = btn:CreateTexture(nil, 'ARTWORK')
		btn.icon:Size(13)
		btn.icon:SetPoint('CENTER')
		btn.icon:SetTexture([[Interface\Buttons\SquareButtonTextures]])
		btn.icon:SetTexCoord(0.01562500, 0.20312500, 0.01562500, 0.20312500)
		
		btn:SetScript('OnMouseDown', function(self)
			if self:IsEnabled() then
				self.icon:SetPoint("CENTER", -1, -1);
			end		
		end)
		
		btn:SetScript('OnMouseUp', function(self)
			self.icon:SetPoint("CENTER", 0, 0);
		end)
		
		btn:SetScript('OnDisable', function(self)
			SetDesaturation(self.icon, true);
			self.icon:SetAlpha(0.5);		
		end)
		
		btn:SetScript('OnEnable', function(self)
			SetDesaturation(self.icon, false);
			self.icon:SetAlpha(1.0);		
		end)
		
		if not btn:IsEnabled() then
			btn:GetScript('OnDisable')(btn)
		end
	end

	if buttonOverride then
		if inverseDirection then
			SquareButton_SetIcon(btn, 'UP')
		else
			SquareButton_SetIcon(btn, 'DOWN')
		end
	else
		if inverseDirection then
			SquareButton_SetIcon(btn, 'LEFT')
		else
			SquareButton_SetIcon(btn, 'RIGHT')
		end	
	end
	
	SkinButton(btn)
	btn:Size(btn:GetWidth() - 7, btn:GetHeight() - 7)
end
F.SkinNextPrevButton = SkinNextPrevButton -- Compatibility, yo

local function SkinRotateButton(btn)
	btn:SetTemplate()
	btn:Size(btn:GetWidth() - 14, btn:GetHeight() - 14)	
	
	btn:GetNormalTexture():SetTexCoord(0.3, 0.29, 0.3, 0.65, 0.69, 0.29, 0.69, 0.65)
	btn:GetPushedTexture():SetTexCoord(0.3, 0.29, 0.3, 0.65, 0.69, 0.29, 0.69, 0.65)	
	
	btn:GetHighlightTexture():SetTexture(1, 1, 1, 0.3)
	
	btn:GetNormalTexture():SetInside()
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
	local button = _G[frame:GetName().."Button"]
	if not button then return end
	
	if not width then width = 155 end
	
	frame:StripTextures()
	frame:Width(width)
	
	if(_G[frame:GetName()..'Text']) then
		_G[frame:GetName()..'Text']:ClearAllPoints()
		_G[frame:GetName()..'Text']:Point('RIGHT', button, 'LEFT', -2, 0)
	end
	
	if button then
		button:ClearAllPoints()
		button:Point('RIGHT', frame, 'RIGHT', -10, 3)
		
		hooksecurefunc(button, 'SetPoint', function(self, point, attachTo, anchorPoint, xOffset, yOffset, noReset)
			if not noReset then
				button:ClearAllPoints()
				button:SetPoint('RIGHT', frame, 'RIGHT', -10, 3, true)
			end
		end)
		
		button:SkinNextPrevButton(button)
	end
	
	frame:CreateBD()
	frame.backdrop:Point("TOPLEFT", 20, -2)
	frame.backdrop:Point("BOTTOMRIGHT", button, "BOTTOMRIGHT", 2, -2)
end
F.SkinDropDownBox = SkinDropDownBox -- Compatibility, yo

function SkinCheckBox(frame, noBackdrop)
	frame:StripTextures()
	if noBackdrop then
		frame:SetTemplate()
		frame:Size(16)
	else
		frame:CreateBD()
		frame.backdrop:SetInside(nil, 4, 4)
	end

	if frame.SetCheckedTexture then
		frame:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")
		if noBackdrop then
			frame:GetCheckedTexture():SetInside(nil, -4, -4)
		end
	end
	
	if frame.SetDisabledTexture then
		frame:SetDisabledTexture("Interface\\Buttons\\UI-CheckBox-Check-Disabled")
		if noBackdrop then
			frame:GetDisabledTexture():SetInside(nil, -4, -4)
		end		
	end
	
	frame:HookScript('OnDisable', function(self)
		if not self.SetDisabledTexture then return; end
		if self:GetChecked() then
			self:SetDisabledTexture("Interface\\Buttons\\UI-CheckBox-Check-Disabled")
		else
			self:SetDisabledTexture("")
		end
	end)
	
	if frame.SetNormalTexture then
		hooksecurefunc(frame, "SetNormalTexture", function(self, texPath)
			if texPath ~= "" then
				self:SetNormalTexture("");
			end
		end)
	end
	
	if frame.SetPushedTexture then
		hooksecurefunc(frame, "SetPushedTexture", function(self, texPath)
			if texPath ~= "" then
				self:SetPushedTexture("");
			end
		end)
	end
	
	if frame.SetHighlightTexture then
		hooksecurefunc(frame, "SetHighlightTexture", function(self, texPath)
			if texPath ~= "" then
				self:SetHighlightTexture("");
			end
		end)
	end
end
F.SkinCheckBox = SkinCheckBox -- Compatibility, yo

function SkinCloseButton(f, point, text)	
	f:StripTextures()
	
	if not text then text = 'x' end
	
	if not f.text then
		f.text = f:CreateFontString(nil, 'OVERLAY')
		f.text:FontTemplate(C.Media.Font, 16, 'OUTLINE')
		f.text:SetText(text)
		f.text:SetJustifyH('CENTER')
		f.text:SetPoint('CENTER', f, 'CENTER')
	end
	
	if point then
		f:Point("TOPRIGHT", point, "TOPRIGHT", 2, 2)
	end
end
F.SkinCloseButton = SkinCloseButton -- Compatibility, yo

function SkinSlideBar(frame, height, movetext)
	local orientation = frame:GetOrientation()
	local SIZE = 12
	frame:StripTextures()
	frame:CreateBD()
	frame.backdrop:SetAllPoints()
	hooksecurefunc(frame, "SetBackdrop", function(self, backdrop)
		if backdrop ~= nil then
			frame:SetBackdrop(nil)
		end
	end)
	frame:SetThumbTexture(C.Media.Backdrop)
	frame:GetThumbTexture():SetVertexColor(0.3, 0.3, 0.3)
	frame:GetThumbTexture():Size(SIZE-2,SIZE-2)
	if orientation == 'VERTICAL' then
		frame:Width(SIZE)
	else
		frame:Height(SIZE)
		
		for i=1, frame:GetNumRegions() do
			local region = select(i, frame:GetRegions())
			if region and region:GetObjectType() == 'FontString' then
				local point, anchor, anchorPoint, x, y = region:GetPoint()
				if anchorPoint:find('BOTTOM') then
					region:Point(point, anchor, anchorPoint, x, y - 4)
				end
			end
		end		
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
	if not object.FontTemplate then mt.FontTemplate = FontTemplate end
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