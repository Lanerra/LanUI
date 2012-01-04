LanFunc = {}

LanFunc.playerClass = select(2, UnitClass('player'))
LanFunc.playerColor = RAID_CLASS_COLORS[LanFunc.playerClass]
LanFunc.playerName = UnitName('player')
LanFunc.playerLevel = UnitLevel('player')
LanFunc.playerRealm = GetRealmName()
LanFunc.locale = GetLocale()

LanFunc.KeepFS = function(frame, hide)
    if not frame then return end

    for i = 1, frame:GetNumRegions() do
        local reg = select(i, frame:GetRegions())
        if not reg:IsObjectType("FontString") then
            if not hide then reg:SetAlpha(0) else reg:Hide() end
        end
    end
end

LanFunc.RevTable = function(curTab)
    if not curTab then return end
    local revTab = {}

    for _, v in pairs(curTab) do
        revTab[v] = true
    end

    return revTab
end

LanFunc.KeepRegions = function(frame, regions)
    if not frame then return end
    regions = LanFunc.RevTable(regions)

    for i = 1, frame:GetNumRegions() do
        local reg = select(i, frame:GetRegions())
        -- if we have a list, hide the regions not in that list
        if regions and not regions[i] then
            reg:SetAlpha(0)
        end
    end
end

LanFunc.RemoveRegions = function(frame, regions)
    if not frame then return end
   
    regions = LanFunc.RevTable(regions)
   
    for i = 1, frame:GetNumRegions() do
        local reg = select(i, frame:GetRegions())
        if not regions or regions and regions[i] then
            reg:SetAlpha(0)
        end
    end
end

LanFunc.CallAllRegions = function(frame, type, method, ...)
   if frame.GetRegions and method then
        local regions, region = { frame:GetRegions() }
        for index = 1, #regions do
            region = regions[index]
            if region[method] and (not type or region:IsObjectType(type)) then
                region[method](region, ...)
            end
        end
    end
end

local EventFrame = CreateFrame('Frame')
EventFrame:SetScript('OnEvent', function(self, event, ...)
    if type(self[event]) == 'function' then
        return self[event](self, event, ...)
    end
end)

LanFunc.CreateBD = function(f)
	f:SetBackdrop({
		bgFile = LanConfig.Media.Backdrop,
    })
	f:SetBackdropColor(unpack(LanConfig.Media.BackdropColor))
end

LanFunc.Kill = function(object)
    local objectReference = object
    if type(object) == 'string' then
        objectReference = _G[object]
    else
        objectReference = object
    end
    if not objectReference then
        return
    end
    
    if type(objectReference) == 'frame' then
        objectReference:UnregisterAllEvents()
    end
    
    objectReference.Show = LanFunc.dummy
    objectReference:Hide()
end

LanFunc.StripTextures = function(object, kill)
    for i=1, object:GetNumRegions() do
        local region = select(i, object:GetRegions())
        if region:GetObjectType() == "Texture" then
            if kill then
                LanFunc.Kill(region)
            else
                region:SetTexture(nil)
            end
        end
    end		
end

LanFunc.Skin = function(f, size, pad)
    if (not f.LanSkin) then
        LanFunc.StripTextures(f)
        LanFunc.CreateBD(f)
        f:CreateBeautyBorder(size)
        f:SetBeautyBorderPadding(pad)

        f.LanSkin = true
    else
        print(f..' has already been skinned.')
    end
end

LanFunc.utf8sub = function(string, index, dots)
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

LanFunc.RGBToHex = function(r, g, b)
	r = r <= 1 and r >= 0 and r or 0
	g = g <= 1 and g >= 0 and g or 0
	b = b <= 1 and b >= 0 and b or 0
	return string.format('|cff%02x%02x%02x', r*255, g*255, b*255)
end

LanFunc.ShortValue = function(v)
	if (v >= 1e6) then
		return ('%.1fm'):format(v / 1e6):gsub('%.?0+([km])$', '%1')
	elseif (v >= 1e3 or v <= -1e3) then
		return ('%.1fk'):format(v / 1e3):gsub('%.?0+([km])$', '%1')
	else
		return v
	end
end

LanFunc.dummy = function() end

LanFunc.screenWidth, LanFunc.screenHeight = string.match((({GetScreenResolutions()})[GetCurrentResolution()] or ''), '(%d+).-(%d+)')

LanFunc.scales = {
    ['720'] = { ['576'] = 0.65},
    ['800'] = { ['600'] = 0.7},
    ['960'] = { ['600'] = 0.84},
    ['1024'] = { ['600'] = 0.89, ['768'] = 0.7},
    ['1152'] = { ['864'] = 0.7},
    ['1176'] = { ['664'] = 0.93},
    ['1280'] = { ['800'] = 0.84, ['720'] = 0.93, ['768'] = 0.87, ['960'] = 0.7, ['1024'] = 0.65},
    ['1360'] = { ['768'] = 0.93},
    ['1366'] = { ['768'] = 0.93},
    ['1440'] = { ['900'] = 0.84},
    ['1600'] = { ['1200'] = 0.7, ['1024'] = 0.82, ['900'] = 0.93},
    ['1680'] = { ['1050'] = 0.84},
    ['1768'] = { ['992'] = 0.93},
    ['1920'] = { ['1440'] = 0.7, ['1200'] = 0.84, ['1080'] = 0.93},
    ['2048'] = { ['1536'] = 0.7},
    ['2560'] = { ['1600'] = 0.64},
}