local F, C, G = unpack(select(2, ...))

function CreateBorderLight(self, borderSize, R, G, B, ...)
    local uL1, uL2, uR1, uR2, bL1, bL2, bR1, bR2 = ...
	if (uL1) then
        if (not uL2 and not uR1 and not uR2 and not bL1 and not bL2 and not bR1 and not bR2) then
            uL2, uR1, uR2, bL1, bL2, bR1, bR2 = uL1, uL1, uL1, uL1, uL1, uL1, uL1
        end
    end
    if (not self.HasBorder) then
        self.Border = {}
        for i = 1, 8 do
            self.Border[i] = self:CreateTexture(nil, 'OVERLAY')
            self.Border[i]:SetParent(self)
			self.Border[i]:SetTexture(C.Media.OverlayBorder)
            self.Border[i]:SetSize(borderSize,borderSize)
            if (not R and not G and not B) then
                self.Border[i]:SetVertexColor(1, 1, 1)
            else
                self.Border[i]:SetVertexColor(R, G, B)
            end
        end
        
        self.Border[1]:SetTexCoord(0, 1/3, 0, 1/3) 
        self.Border[1]:SetPoint('TOPLEFT', self, -(uL1 or 0), uL2 or 0)

        self.Border[2]:SetTexCoord(2/3, 1, 0, 1/3)
        self.Border[2]:SetPoint('TOPRIGHT', self, uR1 or 0, uR2 or 0)

        self.Border[3]:SetTexCoord(0, 1/3, 2/3, 1)
        self.Border[3]:SetPoint('BOTTOMLEFT', self, -(bL1 or 0), -(bL2 or 0))

        self.Border[4]:SetTexCoord(2/3, 1, 2/3, 1)
        self.Border[4]:SetPoint('BOTTOMRIGHT', self, bR1 or 0, -(bR2 or 0))

        self.Border[5]:SetTexCoord(1/3, 2/3, 0, 1/3)
        self.Border[5]:SetPoint('TOPLEFT', self.Border[1], 'TOPRIGHT')
        self.Border[5]:SetPoint('TOPRIGHT', self.Border[2], 'TOPLEFT')

        self.Border[6]:SetTexCoord(1/3, 2/3, 2/3, 1)
        self.Border[6]:SetPoint('BOTTOMLEFT', self.Border[3], 'BOTTOMRIGHT')
        self.Border[6]:SetPoint('BOTTOMRIGHT', self.Border[4], 'BOTTOMLEFT')

        self.Border[7]:SetTexCoord(0, 1/3, 1/3, 2/3)
        self.Border[7]:SetPoint('TOPLEFT', self.Border[1], 'BOTTOMLEFT')
        self.Border[7]:SetPoint('BOTTOMLEFT', self.Border[3], 'TOPLEFT')

        self.Border[8]:SetTexCoord(2/3, 1, 1/3, 2/3)
        self.Border[8]:SetPoint('TOPRIGHT', self.Border[2], 'BOTTOMRIGHT')
        self.Border[8]:SetPoint('BOTTOMRIGHT', self.Border[4], 'TOPRIGHT')
        
        local space
        if (borderSize >= 10) then
            space = 3.2
        else
            space = borderSize/3.5
        end

        self.HasBorder = true
    end
end

function SetBorderLayer(self, layer)
    if (self.Border) then
	    for i = 1, 8 do
            self.Border[i]:SetDrawLayer(layer)
		end
    end
end

function SetTexture(self, texture)
    if texture == 'white' then
        x = 'Interface\\AddOns\\LanUI\\Media\\textureNormalWhite'
    elseif texture == 'default' then
        x = 'Interface\\AddOns\\LanUI\\Media\\textureNormal'
    end
    
    if (self.Border) then
	    for i = 1, 8 do
            self.Border[i]:SetTexture(x)
		end
    end
end

function SetColorShadow(self, R, G, B, A)
	if (self.Border) then
        for i = 1, 8 do
            self.Shadow[i]:SetVertexColor(R, G, B, A)
        end        
    end
end
	
function ColorBorder(self, R, G, B)
    if (self.Border) then
        for i = 1, 8 do
            self.Border[i]:SetVertexColor(R, G, B)
        end        
    end
end

local function GetBeautyBorderInfo(self)
    if (not self) then
        print(formatName..' error:|r This frame does not exist!') 
    elseif (self.Border) then
        local tex = self.Border[1]:GetTexture()
        local size = self.Border[1]:GetSize()
        local r, g, b, a = self.Border[1]:GetVertexColor()

        return size, tex, r, g, b, a
    else
        print(formatName..' error:|r Invalid frame! This object has no '..addonName..' border')   
    end
end

local function SetBeautyBorderPadding(self, uL1, ...)
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
        self.Border[1]:SetPoint('TOPLEFT', self, -(uL1 or 0), uL2 or 0)

        self.Border[2]:SetPoint('TOPRIGHT', self, uR1 or 0, uR2 or 0)

        self.Border[3]:SetPoint('BOTTOMLEFT', self, -(bL1 or 0), -(bL2 or 0))

        self.Border[4]:SetPoint('BOTTOMRIGHT', self, bR1 or 0, -(bR2 or 0))
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