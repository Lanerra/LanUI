local F, C, G = unpack(select(2, ...))

local _, ns = ...
local oUF = ns.oUF

-- Define some custom oUF tags
oUF.Tags.Methods['LanPvPTime'] = function(unit)
	return UnitIsPVP(unit) and not IsPVPTimerRunning() and '*' or IsPVPTimerRunning() and ('%d:%02d'):format((GetPVPTimer() / 1000) / 60, (GetPVPTimer() / 1000) % 60)
end

oUF.Tags.Events['LanThreat'] = 'UNIT_THREAT_LIST_UPDATE'
oUF.Tags.Methods['LanThreat'] = function()
	local _, _, perc = UnitDetailedThreatSituation('player', 'target')
	return perc and ('%s%d%%|r'):format(F.RGBToHex(GetThreatStatusColor(UnitThreatSituation('player', 'target'))), perc)
end

oUF.Tags.Events['LanClassification'] = 'UNIT_CLASSIFICATION_CHANGED'
oUF.Tags.Methods['LanClassification'] = function(unit)
    local level = UnitLevel(unit)
    local colorL = GetQuestDifficultyColor(level)
    
    if (level < 0) then
        r, g, b = 1, 0, 0
    else
        r, g, b = colorL.r, colorL.g, colorL.b
    end
    
    local c = UnitClassification(unit)
    if(c == 'rare') then
        return format('|cff%02x%02x%02x%s|r', r*255, g*255, b*255, 'R')
    elseif(c == 'eliterare') then
        return format('|cff%02x%02x%02x%s|r', r*255, g*255, b*255, 'R+')
    elseif(c == 'elite') then
        return format('|cff%02x%02x%02x%s|r', r*255, g*255, b*255, '+')
    elseif(c == 'worldboss') then
        return format('|cff%02x%02x%02x%s|r', r*255, g*255, b*255, 'B')
    end
end

oUF.Tags.Methods['LanLevel'] = function(unit)
    local level = UnitLevel(unit)
    local colorL = GetQuestDifficultyColor(level)
        
    if (level < 0) then 
        r, g, b = 1, 0, 0
        level = '??'
    elseif (level == 0) then
        r, g, b = colorL.r, colorL.g, colorL.b
        level = '?'
    else
        r, g, b = colorL.r, colorL.g, colorL.b
        level = level
    end

    return format('|cff%02x%02x%02x%s|r', r*255, g*255, b*255, level)
end

oUF.Tags.Events['LanName'] = 'UNIT_NAME_UPDATE UNIT_HEALTH'
oUF.Tags.Methods['LanName'] = function(unit)
    local r, g, b = 1, 1, 1
    local colorA, colorB
    local unitName, unitRealm = UnitName(unit)
    local _, class = UnitClass(unit)

    if (unitRealm) and (unitRealm ~= '') then
        unitName = unitName..' (*)'
    end

    for i = 1, 4 do
        if (unit == 'party'..i) then
            colorA = oUF.colors.class[class]
        end
    end

    if (unit == 'player' or not UnitIsFriend('player', unit) and UnitIsPlayer(unit) and UnitClass(unit) and not unit:match('arena(%d)')) then
        colorA = oUF.colors.class[class]
    elseif (unit == 'targettarget' or unit == 'focustarget' or unit:match('arena(%d)target')) then
        r, g, b = UnitSelectionColor(unit)
    else
        colorB = {1, 1, 1}
    end

    if (colorA) then
        r, g, b = colorA[1], colorA[2], colorA[3]
    elseif (colorB) then
        r, g, b = colorB[1], colorB[2], colorB[3]
    end
    
    if (not UnitIsConnected(unit)) then
        Name = '|cffD7BEA5'..'OFFLINE'
        return Name
    elseif (UnitIsDead(unit)) then
        Name = '|cffD7BEA5'..'DEAD'
        return Name
    elseif (UnitIsGhost(unit)) then
        Name = '|cffD7BEA5'..'GHOST'
        return Name
	else
        return format('|cff%02x%02x%02x%s|r', r*255, g*255, b*255, unitName)
    end
end

oUF.Tags.Events['LanRaidName'] = 'UNIT_NAME_UPDATE UNIT_HEALTH'
oUF.Tags.Methods['LanRaidName'] = function(unit)    
    if (not UnitIsConnected(unit)) then
        Name = '|cffD7BEA5'..'OFF'
    elseif (UnitIsDead(unit)) then
        Name = '|cffD7BEA5'..'DEAD'
    elseif (UnitIsGhost(unit)) then
        Name = '|cffD7BEA5'..'GHOST'
	else
        Name = string.sub(UnitName(unit), 1, 4)
    end

	return Name
end

oUF.Tags.Events['LanShortName'] = 'UNIT_NAME_UPDATE UNIT_HEALTH'
oUF.Tags.Methods['LanShortName'] = function(unit)
    local name = UnitName(unit)
    if (not UnitIsConnected(unit)) then
        Name = '|cffD7BEA5'..'OFFLINE'
        return Name
    elseif (UnitIsDead(unit)) then
        Name = '|cffD7BEA5'..'DEAD'
        return Name
    elseif (UnitIsGhost(unit)) then
        Name = '|cffD7BEA5'..'GHOST'
        return Name
	else
        if strlen(name) > 8 then
            local NewName = string.sub(UnitName(unit), 1, 8)..'...'
            return NewName
        else
            return name
        end
    end
end

oUF.Tags.Events['LanPower'] = 'UNIT_DISPLAYPOWER UNIT_POWER_FREQUENT UNIT_MAXPOWER'
oUF.Tags.Methods['LanPower'] = function(unit)
    local min = UnitPower(unit)
    return min
end

oUF.Tags.Events['LanCombat'] = 'PLAYER_REGEN_DISABLED PLAYER_REGEN_ENABLED'
oUF.Tags.Methods['LanCombat'] = function(unit)
	if unit == 'player' and UnitAffectingCombat('player') then
		return [[|TInterface\CharacterFrame\UI-StateIcon:0:0:0:0:64:64:37:58:5:26|t]]
	end
end
oUF.Tags.SharedEvents['PLAYER_REGEN_DISABLED'] = true
oUF.Tags.SharedEvents['PLAYER_REGEN_ENABLED'] = true

oUF.Tags.Events['LanLeader'] = 'PARTY_LEADER_CHANGED PARTY_MEMBERS_CHANGED'
oUF.Tags.Methods['LanLeader'] = function(unit)
	if UnitIsGroupLeader(unit) then
		return [[|TInterface\GroupFrame\UI-Group-LeaderIcon:0|t]]
	elseif UnitInRaid(unit) and UnitIsRaidOfficer(unit) then
		return [[|TInterface\GroupFrame\UI-Group-AssistantIcon:0|t]]
	end
end

oUF.Tags.Events['LanMaster'] = 'PARTY_LOOT_METHOD_CHANGED PARTY_MEMBERS_CHANGED'
oUF.Tags.Methods['LanMaster'] = function(unit)
	local method, pid, rid = GetLootMethod()
	if method ~= 'master' then return end
	local munit
	if pid then
		if pid == 0 then
			munit = 'player'
		else
			munit = 'party' .. pid
		end
	elseif rid then
		munit = 'raid' .. rid
	end
	if munit and UnitIsUnit(munit, unit) then
		return [[|TInterface\GroupFrame\UI-Group-MasterLooter:0:0:0:2|t]]
	end
end

oUF.Tags.Events['LanResting'] = 'PLAYER_UPDATE_RESTING'
oUF.Tags.Methods['LanResting'] = function(unit)
	if unit == 'player' and IsResting() then
		return [[|TInterface\CharacterFrame\UI-StateIcon:0:0:0:-6:64:64:28:6:6:28|t]]
	end
end


oUF.Tags.Methods['LanHolyPower'] = function(unit)
	local hp = UnitPower('player', SPELL_POWER_HOLY_POWER)

	if hp > 0 then
		return string.format('|c50f58cba%d|r', hp)
	end
end
oUF.Tags.Events['LanHolyPower'] = 'UNIT_POWER_FREQUENT'

oUF.Tags.Methods['LanShards'] = function(unit)
	local hp = UnitPower('player', SPELL_POWER_SOUL_SHARDS)

	if hp > 0 then
		return string.format('|c909482c9%d|r', hp)
	end
end
oUF.Tags.Events['LanShards'] = 'UNIT_POWER'

oUF.Tags.Methods['LanCombo'] = function(unit)
    local cp = GetComboPoints('player', 'target')
    
    if cp > 0 then
        return string.format('|cffffff00%d|r', cp)
    end
end
oUF.Tags.Events['LanCombo'] = 'UNIT_COMBO_POINTS PLAYER_TARGET_CHANGED'

oUF.Tags.Methods['LanChi'] = function(unit)
    local chi = UnitPower('player', SPELL_POWER_CHI)
    
    if chi > 0 then
        return string.format('|c909482c9%d|r', chi)
    end
end
oUF.Tags.Events['LanChi'] = 'UNIT_POWER'