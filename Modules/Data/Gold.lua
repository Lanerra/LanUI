--------------------------------------------------------------------
-- GOLD
--------------------------------------------------------------------

local Player = UnitName('player')
local Realm = GetRealmName()

local GoldFrame = CreateFrame("Frame", "GoldDataFrame")
GoldFrame:EnableMouse(true)
GoldFrame:SetFrameStrata("MEDIUM")
GoldFrame:SetFrameLevel(3)
GoldFrame:SetPoint('BOTTOM', UIParent, 0, 3)

local Gold = GoldFrame:CreateFontString(nil, "OVERLAY")
Gold:SetFont(LanConfig.Media.Font, 8)
Gold:SetParent(GoldFrame)
Gold:SetHeight(12)
Gold:SetWidth(40)
Gold:SetShadowOffset(1, -1)
Gold:SetShadowColor(0, 0, 0, 0.4)

local defaultColor = { 1, 1, 1 }
local Profit	= 0
local Spent		= 0
local OldMoney	= 0

local g, s, c = "|cffffd700g|r", "|cffc7c7cfs|r", "|cffeda55fc|r"

local function formatMoney(money)
	local gold = floor(math.abs(money) / 10000)
	local silver = mod(floor(math.abs(money) / 100), 100)
	local copper = mod(floor(math.abs(money)), 100)
	if gold ~= 0 then
		-- return format("%s"..g.." %s"..s.." %s"..c, gold, silver, copper)
		return format("%s"..g, gold)
	elseif silver ~= 0 then
		return format("%s"..s.." %s"..c, silver, copper)
	else
		return format("%s"..c, copper)
	end
end

local function FormatTooltipMoney(money)
	if not money then return end
	local gold, silver, copper = abs(money / 10000), abs(mod(money / 100, 100)), abs(mod(money, 100))
	local cash = ""
	cash = format("%d"..g.." %d"..s.." %d"..c, gold, silver, copper)		
	return cash
end	

GoldFrame:SetScript("OnEnter", function(self)
	if not InCombatLockdown() then
		local anchor, xoff, yoff = 'ANCHOR_TOP', 0, 4
		GameTooltip:SetOwner(self, anchor, xoff, yoff)
		GameTooltip:ClearLines()
		GameTooltip:AddLine('Session: ')
		GameTooltip:AddDoubleLine('Earned: ', formatMoney(Profit), 1, 1, 1, 1, 1, 1)
		GameTooltip:AddDoubleLine('Spent: ', formatMoney(Spent), 1, 1, 1, 1, 1, 1)
		if Profit < Spent then
			GameTooltip:AddDoubleLine('Deficit: ', formatMoney(Profit-Spent), 1, 0, 0, 1, 1, 1)
		elseif (Profit-Spent)>0 then
			GameTooltip:AddDoubleLine('Profit: ', formatMoney(Profit-Spent), 0, 1, 0, 1, 1, 1)
		end				
		GameTooltip:AddLine' '								
	
		local totalGold = 0				
		GameTooltip:AddLine('Character: ')			

		for k,_ in pairs(LanDataDB[Realm]) do
			if LanDataDB[Realm][k]["gold"] then 
				GameTooltip:AddDoubleLine(k, FormatTooltipMoney(LanDataDB[Realm][k]["gold"]), 1, 1, 1, 1, 1, 1)
				totalGold = totalGold + LanDataDB[Realm][k]["gold"]
			end
		end 
		GameTooltip:AddLine' '
		GameTooltip:AddLine('Server: ')
		GameTooltip:AddDoubleLine('Total: ', FormatTooltipMoney(totalGold), 1, 1, 1, 1, 1, 1)

		for i = 1, MAX_WATCHED_TOKENS do
			local name, count, extraCurrencyType, icon, itemID = GetBackpackCurrencyInfo(i)
			if name and i == 1 then
				GameTooltip:AddLine(" ")
				GameTooltip:AddLine(CURRENCY)
			end
			if name and count then GameTooltip:AddDoubleLine(name, count, 1, 1, 1) end
		end
		GameTooltip:Show()
	end
end)

GoldFrame:SetScript("OnLeave", function() GameTooltip:Hide() end)

local function OnEvent(self, event)
	if event == "PLAYER_ENTERING_WORLD" then
		OldMoney = GetMoney()
	end
	
	local NewMoney	= GetMoney()
	local Change = NewMoney-OldMoney -- Positive if we gain money
	
	if OldMoney>NewMoney then		-- Lost Money
		Spent = Spent - Change
	else							-- Gained Moeny
		Profit = Profit + Change
	end
	
	Gold:SetText(formatMoney(NewMoney))
	-- Setup Money Tooltip
	self:SetAllPoints(Gold)
    self:SetPoint('BOTTOM', UIParent, 0, 3)

	if (LanDataDB == nil) then LanDataDB = {}; end
	if (LanDataDB[Realm] == nil) then LanDataDB[Realm] = {} end
	if (LanDataDB[Realm][Player] == nil) then LanDataDB[Realm][Player] = {} end
	LanDataDB[Realm][Player]["gold"] = GetMoney()
	LanDataDB.gold = nil -- old
		
	OldMoney = NewMoney
end

GoldFrame:RegisterEvent("PLAYER_MONEY")
GoldFrame:RegisterEvent("SEND_MAIL_MONEY_CHANGED")
GoldFrame:RegisterEvent("SEND_MAIL_COD_CHANGED")
GoldFrame:RegisterEvent("PLAYER_TRADE_MONEY")
GoldFrame:RegisterEvent("TRADE_MONEY_CHANGED")
GoldFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
GoldFrame:SetScript("OnMouseDown", function() OpenAllBags() end)
GoldFrame:SetScript("OnEvent", OnEvent)

-- reset gold data
local function RESETGOLD()		
	for k,_ in pairs(LanDataDB[Realm]) do
		LanDataDB[Realm][k].gold = nil
	end 
	if (LanDataDB == nil) then LanDataDB = {}; end
	if (LanDataDB[Realm] == nil) then LanDataDB[Realm] = {} end
	if (LanDataDB[Realm][Player] == nil) then LanDataDB[Realm][Player] = {} end
	LanDataDB[Realm][Player]["gold"] = GetMoney()
end
SLASH_RESETGOLD1 = "/resetgold"
SlashCmdList["RESETGOLD"] = RESETGOLD