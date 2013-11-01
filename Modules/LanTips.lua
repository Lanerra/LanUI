for _, font in pairs({
	
    _G['GameFontHighlight'],
    _G['GameFontDisable'],
    _G['GameFontNormal'],
	_G['GameFontHighlightMedium'],
	_G['ReputationDetailFont'],
	_G['ItemTextFontNormal'],
	_G['DialogButtonNormalText'],
	
}) do
    font:SetFont(LanConfig.Media.Font, 12, 'THINOUTLINE')
end

-- mail box font

for _, font in pairs({

	_G['InvoiceTextFontNormal'],
    _G['InvoiceTextFontSmall'],
	_G['MailTextFontNormal'],
	
}) do
   font:SetFont(LanConfig.Media.Font, 13, 'THINOUTLINE')
   font:SetTextColor(1, 1, 1)
end   

for _, font in pairs({

    _G['GameFontHighlightSmall'],
	_G['GameFontNormalSmall'],
    _G['GameFontDisableSmall'],
	
}) do
    font:SetFont(LanConfig.Media.Font, 11, 'THINOUTLINE')
end

-- small font in the spell book.

for _, font in pairs({  
  
	_G['SubSpellFont'],
	
}) do
    font:SetFont(LanConfig.Media.Font, 11, 'THINOUTLINE')
	font:SetTextColor(1, 1, 1)
end	

for _, font in pairs({  
  
	_G['NumberFontNormalSmall'],
	
}) do
    font:SetFont(LanConfig.Media.Font, 13, 'THINOUTLINE')
end

for _, font in pairs({

    _G['WorldMapTextFont'],
    _G['MovieSubtitleFont'],
	
}) do
    font:SetFont(LanConfig.Media.Font, 14, 'THINOUTLINE')
end	

for _, font in pairs({

    _G['NumberFontNormal'],
	
}) do
    font:SetFont(LanConfig.Media.Font, 14, 'THINOUTLINE')
end

for _, font in pairs({

    _G['NumberFontNormalLarge'],
    _G['NumberFontNormalHuge'],
    _G['GameFontNormalHuge'],
	_G['GameFontNormalLarge'],
	
}) do
    font:SetFont(LanConfig.Media.Font, 14, 'THINOUTLINE')
end

for _, font in pairs({

    _G['QuestFontHighlight'],
    _G['QuestFontNormalSmall'],
    _G['QuestLogNoQuestText'],
	_G['QuestLogTitleText'],
	
}) do
   font:SetFont(LanConfig.Media.Font, 14, 'THINOUTLINE')
   font:SetTextColor(1, 1, 1)
end

for _, font in pairs({

    _G['QuestTitleFont'],
    _G['QuestFont'],

}) do
   font:SetFont(LanConfig.Media.Font, 14, 'THINOUTLINE')
   font:SetTextColor(1, 1, 1)
end
	
for _, font in pairs({
 
	_G['AchievementPointsFont'],
    _G['AchievementPointsFontSmall'],
    _G['AchievementDateFont'],
	
}) do
    font:SetFont(LanConfig.Media.Font, 12, 'THINOUTLINE')
end
 
for _, font in pairs({

    _G['AchievementCriteriaFont'],
    _G['AchievementDescriptionFont'],

}) do
   font:SetFont(LanConfig.Media.Font, 12)
   font:SetTextColor(1, 1, 1)
end

-- Change Zone Text

for _, font in pairs({

    _G['ZoneTextFont'],									
    _G['SubZoneTextFont'],
    _G['PVPInfoTextFont'],
	
}) do
   font:SetFont(LanConfig.Media.Font, 35, 'THINOUTLINE')
end	

-- Friend List / Real ID

for _, font in pairs({

	_G['FriendsFont_Large'],               
	_G['FriendsFont_Normal'],            
	_G['FriendsFont_Small'],                 
	_G['FriendsFont_UserText'], 

}) do
   font:SetFont(LanConfig.Media.Font, 11, 'THINOUTLINE')
end

-- Tooltip Font.

for _, font in pairs({

	_G['GameTooltipHeaderText'],               


}) do
   font:SetFont(LanConfig.Media.Font, 15, 'THINOUTLINE')
end

for _, font in pairs({

	_G['GameTooltipText'],               


}) do
   font:SetFont(LanConfig.Media.Font, 12, 'THINOUTLINE')
end

for _, font in pairs({

	_G['GameTooltipTextSmall'],               


}) do
   font:SetFont(LanConfig.Media.Font, 11, 'THINOUTLINE')
end

-- Bag Frame Money Font.

for _, font in pairs({

	_G['ContainerFrame1MoneyFrameGoldButtonText'], 
	_G['ContainerFrame1MoneyFrameSilverButtonText'],
	_G['ContainerFrame1MoneyFrameCopperButtonText'],
	_G['BankFrameMoneyFrameGoldButtonText'],
	_G['BankFrameMoneyFrameSilverButtonText'],
	_G['BankFrameMoneyFrameCopperButtonText'],
    

}) do
    font:SetFont(LanConfig.Media.Font, 14, 'THINOUTLINE')
end	

for _, font in pairs({

    _G["BackpackTokenFrameToken1Count"],
	_G["BackpackTokenFrameToken2Count"],
	_G["BackpackTokenFrameToken3Count"],

}) do
    font:SetFont(LanConfig.Media.Font, 12, 'THINOUTLINE')
end

--- THANKS HANKTHETANK I LOVE YOU --------

--[[

local dummy = CreateFrame("Frame")
local FontFinderToolTip = CreateFrame("GameTooltip", "FontFinderToolTip", UIParent, "GameTooltipTemplate")
local WorldFrame = WorldFrame

local totalElapsed = 0
local currentFrame = nil
dummy:SetScript("OnUpdate", function(self, elapsed)
	totalElapsed = totalElapsed + elapsed
	if totalElapsed > 0.1 then
		local frame = GetMouseFocus()
		
		if not frame then frame = WorldFrame end
		if frame ~= currentFrame then FontFinderToolTip:ClearLines() else return end
		local frames = { frame }
		for i = 1, #({frame:GetChildren()}) do table.insert(frames, ({frame:GetChildren()})[i]) end
		
		FontFinderToolTip:SetOwner(UIParent, "ANCHOR_CURSOR")
		for _, frame in ipairs(frames) do
			local addedHeader = false
			if frame:GetRegions() then
				for i = 1, select("#", frame:GetRegions()) do
					local region = select(i, frame:GetRegions())
					if region.GetObjectType and region:GetObjectType() == "FontString" then
						if not addedHeader then
							FontFinderToolTip:AddLine((frame:GetName() or "(Anonymous)"), 1, 0.65, 0.16, false)
						end
						FontFinderToolTip:AddDoubleLine(
							"<" .. region:GetObjectType() .. ":" .. (region:GetName() or "(Anonymous)") .. ">",
							region:GetFontObject() and region:GetFontObject():GetName() or "(No FontObject)",
							1, 1, 1,
							0.85, 1, 0.2
						)
						addedHeader = true
					end
				end
			end
		end

		FontFinderToolTip:Show()
		currentFrame = frame
		totalElapsed = 0
	end
end)

--]]
	
-- Item level crap :D

local old_PaperDollFrame_SetItemLevel = PaperDollFrame_SetItemLevel
function PaperDollFrame_SetItemLevel(ilvl, unit, ...)
	old_PaperDollFrame_SetItemLevel(ilvl, unit, ...)
	if ( unit ~= 'player' ) then
		return;
	end
	_G[ilvl:GetName()..'StatText']:SetText(math.floor(GetAverageItemLevel()*10000)/10000)
end
 	
----------------------------------------
--Tooltip mods by Alza -----------------
----------------------------------------

ITEM_LEVEL = "|cff00ffffilvl: %d|r" -- Blue color

if GetLocale() == "enUS" or GetLocale() == "enGB" then
ITEM_BIND_ON_EQUIP = "BoE"
ITEM_BIND_ON_PICKUP = "BoP"
ITEM_BIND_ON_USE = "Bind on use"
ITEM_CLASSES_ALLOWED = "Class: %s"
ITEM_CONJURED = "Conjured"
ITEM_CREATED_BY = "" -- No creator name
ITEM_LEVEL_AND_MIN = "Level: %d (min: %d)"
ITEM_LEVEL_RANGE = "Requires level: %d - %d"
ITEM_LEVEL_RANGE_CURRENT = "Requires level: %d - %d (%d)"
ITEM_LIMIT_CATEGORY_MULTIPLE = "BoE: %s (%d)"
ITEM_MOD_AGILITY = "%c%s Agility"
ITEM_MOD_AGILITY_SHORT = "Agility"
ITEM_MOD_ARMOR_PENETRATION_RATING = "ARP +%s"
ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT = "ARP"
ITEM_MOD_ATTACK_POWER = "AP +%s"
ITEM_MOD_BLOCK_RATING = "Block rating +%s"
ITEM_MOD_BLOCK_RATING_SHORT = "Block rating"
ITEM_MOD_BLOCK_VALUE = "Block value +%s"
ITEM_MOD_BLOCK_VALUE_SHORT = "Block value"
ITEM_MOD_CRIT_MELEE_RATING = "Crit (melee) +%s"
ITEM_MOD_CRIT_MELEE_RATING_SHORT = "Crit (melee)"
ITEM_MOD_CRIT_RANGED_RATING = "Crit (ranged) +%s"
ITEM_MOD_CRIT_RANGED_RATING_SHORT = "Crit (ranged)"
ITEM_MOD_CRIT_RATING = "Crit +%s"
ITEM_MOD_CRIT_RATING_SHORT = "Crit"
ITEM_MOD_CRIT_SPELL_RATING = "Crit (spell) +%s"
ITEM_MOD_CRIT_SPELL_RATING_SHORT = "Crit (spell)"
ITEM_MOD_DAMAGE_PER_SECOND_SHORT = "DPS"
ITEM_MOD_DEFENSE_SKILL_RATING = "Defence +%s"
ITEM_MOD_DEFENSE_SKILL_RATING_SHORT = "Defence"
ITEM_MOD_DODGE_RATING = "Dodge +%s"
ITEM_MOD_DODGE_RATING_SHORT = "Dodge"
ITEM_MOD_EXPERTISE_RATING = "Expertise +%s"
ITEM_MOD_EXPERTISE_RATING_SHORT = "Expertise"
ITEM_MOD_FERAL_ATTACK_POWER = "Feral AP +%s"
ITEM_MOD_FERAL_ATTACK_POWER_SHORT = "Feral AP"
ITEM_MOD_HASTE_MELEE_RATING = "Haste (melee) +%s"
ITEM_MOD_HASTE_MELEE_RATING_SHORT = "Haste (melee)"
ITEM_MOD_HASTE_RANGED_RATING = "Haste (ranged) +%s"
ITEM_MOD_HASTE_RANGED_RATING_SHORT = "Haste (ranged)"
ITEM_MOD_HASTE_RATING = "Haste +%s"
ITEM_MOD_HASTE_RATING_SHORT = "Haste"
ITEM_MOD_HASTE_SPELL_RATING = "Haste (spell) +%s"
ITEM_MOD_HASTE_SPELL_RATING_SHORT = "Haste (spell)"
ITEM_MOD_HEALTH = "%c%s Health"
ITEM_MOD_HEALTH_REGEN = "%d Hp5"
ITEM_MOD_HEALTH_REGEN_SHORT = "Hp5"
ITEM_MOD_HEALTH_REGENERATION = "%d Hp5"
ITEM_MOD_HEALTH_REGENERATION_SHORT = "Hp5"
ITEM_MOD_HIT_MELEE_RATING = "Hit (melee) +%s"
ITEM_MOD_HIT_MELEE_RATING_SHORT = "Hit (melee)"
ITEM_MOD_HIT_RANGED_RATING = "Hit (ranged) +%s"
ITEM_MOD_HIT_RANGED_RATING_SHORT = "Hit (ranged)"
ITEM_MOD_HIT_RATING = "Hit +%s"
ITEM_MOD_HIT_RATING_SHORT = "Hit"
ITEM_MOD_HIT_SPELL_RATING = "Hit (spell) +%s"
ITEM_MOD_HIT_SPELL_RATING_SHORT = "Hit (spell)"
ITEM_MOD_HIT_TAKEN_RATING = "Miss +%s"
ITEM_MOD_HIT_TAKEN_RATING_SHORT = "Miss"
ITEM_MOD_HIT_TAKEN_SPELL_RATING = "Spell miss +%s"
ITEM_MOD_HIT_TAKEN_SPELL_RATING_SHORT = "Spell miss"
ITEM_MOD_HIT_TAKEN_MELEE_RATING = "Melee miss +%s"
ITEM_MOD_HIT_TAKEN_MELEE_RATING_SHORT = "Melee miss"
ITEM_MOD_HIT_TAKEN_RANGED_RATING = "Ranged miss +%s"
ITEM_MOD_HIT_TAKEN_RANGED_RATING_SHORT = "Ranged miss"
ITEM_MOD_INTELLECT = "%c%s Intellect"
ITEM_MOD_MANA = "%c%s Mana"
ITEM_MOD_MANA_REGENERATION = "+%d Mp5"
ITEM_MOD_MANA_REGENERATION_SHORT = "Mp5"
ITEM_MOD_MASTERY_RATING = "Mastery +%s"
ITEM_MOD_MELEE_ATTACK_POWER_SHORT = "AP (melee)"
ITEM_MOD_PARRY_RATING = "Parry +%s"
ITEM_MOD_RANGED_ATTACK_POWER = "AP (ranged) +%s"
ITEM_MOD_RANGED_ATTACK_POWER_SHORT = "AP (ranged)"
ITEM_MOD_RESILIENCE_RATING = "Resi +%s"
ITEM_MOD_RESILIENCE_RATING_SHORT = "Resi"
ITEM_MOD_SPELL_DAMAGE_DONE = "Spellpower +%s"
ITEM_MOD_SPELL_DAMAGE_DONE_SHORT = "Spellpower"
ITEM_MOD_SPELL_HEALING_DONE = "Healing +%s"
ITEM_MOD_SPELL_HEALING_DONE_SHORT = "Healing"
ITEM_MOD_SPELL_POWER = "Spellpower +%s"
ITEM_MOD_SPELL_PENETRATION = "Spell Penetration +%s"
ITEM_OPENABLE = "Open!"
ITEM_RACES_ALLOWED = "Race: %s"
ITEM_RANDOM_ENCHANT = "Random enchant"
ITEM_RESIST_ALL = "%c%d All resistances"
ITEM_RESIST_SINGLE = "Resist: %c%d %s"
ITEM_SIGNABLE = "Sign!"
ITEM_SOCKETABLE = "" -- No gem info line
ITEM_SOCKET_BONUS = "Bonus: %s"
ITEM_SOLD_COLON = "Sold:"
ITEM_SPELL_CHARGES = "%d charges"
ITEM_SPELL_TRIGGER_ONPROC = "Proc:"
ITEM_STARTS_QUEST = "Starts quest"
ITEM_WRONG_CLASS = "Wrong class!"
ITEM_UNSELLABLE = "Can't be sold"
SELL_PRICE = "Price"
end

ARMOR_TEMPLATE = "Armor: %s"
DAMAGE_TEMPLATE = "Damage: %s - %s"
DPS_TEMPLATE = "%s DPS"
DURABILITY_TEMPLATE = "Durability: %d/%d"
SHIELD_BLOCK_TEMPLATE = "Block: %d"

EMPTY_SOCKET_RED = "Red"
EMPTY_SOCKET_YELLOW = "Yellow"
EMPTY_SOCKET_BLUE = "Blue"
EMPTY_SOCKET_META = "Meta"
EMPTY_SOCKET_NO_COLOR = "Prismatic"

CURRENCY_GAINED = "+ |cffffffff%s|r"
CURRENCY_GAINED_MULTIPLE = "+ |cffffffff%s|r x|cffffffff%d|r"

LOOT_MONEY = '|cffffff00+|r |cffffffff%s'
YOU_LOOT_MONEY = '|cffffff00+|r |cffffffff%s'
YOU_LOOT_MONEY_GUILD = '|cffffff00+|r |cffffffff%s|r |cffffff00+|r |cffffffff( %s )|r'
LOOT_MONEY_SPLIT_GUILD = '|cffffff00+|r |cffffffff%s|r |cffffff00+|r |cffffffff( %s )|r'
LOOT_MONEY_SPLIT = '|cffffff00+|r |cffffffff%s'

LOOT_ITEM = '%s |cffffff00+|r %s'
LOOT_ITEM_MULTIPLE = '%s |cffffff00+|r %sx%d'
LOOT_ITEM_SELF = '|cffffff00+|r %s'
LOOT_ITEM_SELF_MULTIPLE = '|cffffff00+|r %sx%d'
LOOT_ITEM_PUSHED_SELF = '|cffffff00+|r %s'
LOOT_ITEM_PUSHED_SELF_MULTIPLE = '|cffffff00+|r %sx%d'
LOOT_ROLL_ALL_PASSED = 'All passed on %s'
LOOT_ROLL_PASSED_AUTO = '%s passed %s (auto)'
LOOT_ROLL_PASSED_SELF_AUTO = 'pass %s (auto)'

ACHIEVEMENT_BROADCAST = '%s achieved %s!'
ERR_AUCTION_SOLD_S = "|cff1eff00%s|r |cffFF0000Sold.|r"
ERR_SKILL_UP_SI = '%s |cff1eff00%d|r'
NORMAL_QUEST_DISPLAY = "|cffffffff%s|r"
TRIVIAL_QUEST_DISPLAY = "|cffffffff%s (low level)|r"
FACTION_STANDING_DECREASED = '|3-7(%s) -%d'
FACTION_STANDING_INCREASED = '|3-7(%s) +%d'
CHAT_FLAG_AFK = '[AFK] '
CHAT_FLAG_DND = '[DND] '
CHAT_FLAG_GM = '[GM] '
CHAT_SAY_GET = '%s:\32'
CHAT_YELL_GET = '%s:\32'
CHAT_GUILD_GET = 'g - %s:\32'
CHAT_OFFICER_GET = 'Officer - %s:\32'
CHAT_PARTY_GUIDE_GET  = 'dg - %s:\32' 
CHAT_PARTY_GET = 'p - %s:\32'
CHAT_PARTY_LEADER_GET = 'pl - %s:\32'
CHAT_MONSTER_PARTY_GET = '[|Hchannel:raid|hR|h] %s:\32'
CHAT_RAID_GET = 'r - %s:\32'
CHAT_RAID_WARNING_GET = 'rw - %s:\32'
CHAT_RAID_LEADER_GET = 'rl - %s:\32'
CHAT_BATTLEGROUND_GET = 'bg - %s:\32'
CHAT_BATTLEGROUND_LEADER_GET = 'bgl - %s:\32'
CHAT_YOU_CHANGED_NOTICE = '# |Hchannel:%d|h%s|h'
CHAT_YOU_JOINED_NOTICE = '+ |Hchannel:%d|h%s|h'
CHAT_YOU_LEFT_NOTICE = '- |Hchannel:%d|h%s|h'
BN_INLINE_TOAST_FRIEND_OFFLINE = '%s has gone |cffff0000offline|r!'
BN_INLINE_TOAST_FRIEND_ONLINE = '%s has come |cff00ff00online|r!'
CHAT_BN_WHISPER_GET = 'From %s:\32'
CHAT_BN_WHISPER_INFORM_GET = '|cffad2424@|r %s:\32'
CHAT_WHISPER_GET = 'f - %s:\32'
CHAT_WHISPER_INFORM_GET = '|cffad2424@|r %s:\32'
ERR_FRIEND_OFFLINE_S = '%s has gone |cffff0000offline|r!'
ERR_FRIEND_ONLINE_SS = '|Hplayer:%s|h[%s]|h has come |cff00ff00online|r!'