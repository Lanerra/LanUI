local F, C, G = unpack(select(2, ...))
local bc = C.Media.BorderColor

function CreateBorderLight(self, borderSize, R, G, B, ...)
    local uL1, uL2, uR1, uR2, bL1, bL2, bR1, bR2 = ...
	if (uL1) then
        if (not uL2 and not uR1 and not uR2 and not bL1 and not bL2 and not bR1 and not bR2) then
            uL2, uR1, uR2, bL1, bL2, bR1, bR2 = uL1, uL1, uL1, uL1, uL1, uL1, uL1
        end
    end
    if (not self.HasBorder) then
        self.Borders = {}
        for i = 1, 8 do
            self.Borders[i] = self:CreateTexture(nil, 'OVERLAY')
            self.Borders[i]:SetParent(self)
			self.Borders[i]:SetTexture(C.Media.OverlayBorder)
            self.Borders[i]:SetSize(borderSize,borderSize)
            self.Borders[i]:SetDrawLayer('OVERLAY', -8)
            if (not R and not G and not B) then
                self.Borders[i]:SetVertexColor(1, 1, 1)
            else
                self.Borders[i]:SetVertexColor(R, G, B)
            end
        end
        
        self.Borders[1]:SetTexCoord(0, 1/3, 0, 1/3) 
        self.Borders[1]:SetPoint('TOPLEFT', self, -(uL1 or 0), uL2 or 0)

        self.Borders[2]:SetTexCoord(2/3, 1, 0, 1/3)
        self.Borders[2]:SetPoint('TOPRIGHT', self, uR1 or 0, uR2 or 0)

        self.Borders[3]:SetTexCoord(0, 1/3, 2/3, 1)
        self.Borders[3]:SetPoint('BOTTOMLEFT', self, -(bL1 or 0), -(bL2 or 0))

        self.Borders[4]:SetTexCoord(2/3, 1, 2/3, 1)
        self.Borders[4]:SetPoint('BOTTOMRIGHT', self, bR1 or 0, -(bR2 or 0))

        self.Borders[5]:SetTexCoord(1/3, 2/3, 0, 1/3)
        self.Borders[5]:SetPoint('TOPLEFT', self.Borders[1], 'TOPRIGHT')
        self.Borders[5]:SetPoint('TOPRIGHT', self.Borders[2], 'TOPLEFT')

        self.Borders[6]:SetTexCoord(1/3, 2/3, 2/3, 1)
        self.Borders[6]:SetPoint('BOTTOMLEFT', self.Borders[3], 'BOTTOMRIGHT')
        self.Borders[6]:SetPoint('BOTTOMRIGHT', self.Borders[4], 'BOTTOMLEFT')

        self.Borders[7]:SetTexCoord(0, 1/3, 1/3, 2/3)
        self.Borders[7]:SetPoint('TOPLEFT', self.Borders[1], 'BOTTOMLEFT')
        self.Borders[7]:SetPoint('BOTTOMLEFT', self.Borders[3], 'TOPLEFT')

        self.Borders[8]:SetTexCoord(2/3, 1, 1/3, 2/3)
        self.Borders[8]:SetPoint('TOPRIGHT', self.Borders[2], 'BOTTOMRIGHT')
        self.Borders[8]:SetPoint('BOTTOMRIGHT', self.Borders[4], 'TOPRIGHT')
        
        local space
        if (borderSize >= 10) then
            space = 3.2
        else
            space = borderSize/3.5
        end

        self.HasBorder = true
    end
end

function SetBorderLayer(self, layer, sub)
    if not self.HasBorder then
        if not sub then sub = 0 end
        self.backdropTexture:SetDrawLayer(layer, sub)
        return
    end
    
    if (self.Borders) then
	    for i = 1, 8 do
            if not sub then sub = 0 end
            self.Borders[i]:SetDrawLayer(layer, sub)
		end
    end
end

function SetTexture(self, texture)
    if not self.HasBorder then return end
    
    if texture == 'white' then
        x = 'Interface\\AddOns\\LanUI\\Media\\textureNormalWhite'
    elseif texture == 'default' then
        x = 'Interface\\AddOns\\LanUI\\Media\\textureNormal'
    else
        x = texture
    end
    
    if (self.Borders) then
	    for i = 1, 8 do
            self.Borders[i]:SetTexture(x)
		end
    end
end

function SetColorShadow(self, R, G, B, A)
    if not self.HasBorder then return end
    
	if (self.Borders) then
        for i = 1, 8 do
            self.Shadow[i]:SetVertexColor(R, G, B, A)
        end        
    end
end
	
function ColorBorder(self, R, G, B)
    if not self.HasBorder then
        self:SetBackdropBorderColor(R, G, B)
        return
    end
    
    if (self.Borders) then
        for i = 1, 8 do
            self.Borders[i]:SetVertexColor(R, G, B)
        end        
    end
end

local function GetBeautyBorderInfo(self)
    if not self.HasBorder then return end
    
    if (not self) then
        print(formatName..' error:|r This frame does not exist!') 
    elseif (self.Borders) then
        local tex = self.Borders[1]:GetTexture()
        local size = self.Borders[1]:GetSize()
        local r, g, b, a = self.Borders[1]:GetVertexColor()

        return size, tex, r, g, b, a
    else
        print(formatName..' error:|r Invalid frame! This object has no '..addonName..' border')   
    end
end

local function SetBeautyBorderPadding(self, uL1, ...)
    if not self.HasBorder then return end
    
    if (not self) then
        print(formatName..' error:|r This frame does not exist!') 
        return
    end

    if (not self:IsObjectType('Frame')) then
        local frame  = 'frame'
        print(formatName..' error:|r The entered object is not a '..frame..'!') 
        return
    end

    local uL2, uR1, uR2, bL1, bL2, bR1, bR2 = ...
    if (uL1) then
        if (not uL2 and not uR1 and not uR2 and not bL1 and not bL2 and not bR1 and not bR2) then
            uL2, uR1, uR2, bL1, bL2, bR1, bR2 = uL1, uL1, uL1, uL1, uL1, uL1, uL1
        end
    end

    local space
    if (GetBeautyBorderInfo(self) >= 10) then
        space = 3
    else
        space = GetBeautyBorderInfo(self)/3.5
    end

    if (self.HasBorder) then
        self.Borders[1]:SetPoint('TOPLEFT', self, -(uL1 or 0), uL2 or 0)

        self.Borders[2]:SetPoint('TOPRIGHT', self, uR1 or 0, uR2 or 0)

        self.Borders[3]:SetPoint('BOTTOMLEFT', self, -(bL1 or 0), -(bL2 or 0))

        self.Borders[4]:SetPoint('BOTTOMRIGHT', self, bR1 or 0, -(bR2 or 0))
    end
end

local function addapi(object)
    local mt = getmetatable(object).__index

    mt.CreateBeautyBorder = CreateBorderLight
    mt.SetBorderLayer = SetBorderLayer
    mt.SetBeautyBorderTexture = SetTexture
    mt.SetBeautyBorderColor = ColorBorder
    mt.SetBeautyBorderPadding = SetBeautyBorderPadding
    mt.GetBeautyBorderInfo = GetBeautyBorderInfo
end

local handled = {
    ['Frame'] = true
}

local object = CreateFrame('Frame')
addapi(object)

object = EnumerateFrames()

while object do
    if (not handled[object:GetObjectType()]) then
        addapi(object)
        handled[object:GetObjectType()] = true
    end

    object = EnumerateFrames(object)
end