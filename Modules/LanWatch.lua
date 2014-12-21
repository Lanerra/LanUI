local F, C, G = unpack(select(2, ...))

local font = C.Media.Font
local texture = C.Media.Backdrop
local cc = F.PlayerColor

-- Hide Quest Tracker based on zone
function UpdateHideState()
	local Hide = false
	local _, instanceType = GetInstanceInfo()

	if (instanceType ~= "none") then
		if (instanceType == "pvp") then			-- Battlegrounds
			Hide = true
		elseif (instanceType == "arena") then	-- Arena
			Hide = true
		elseif (((instanceType == "party") or (instanceType == "scenario"))) then	-- 5 Man Dungeons
			Hide = false
		elseif (instanceType == "raid") then	-- Raid Dungeons
			Hide = true
		end
	end
	
	if Hide then
		self.hidden = true
		ObjectiveTrackerFrame:Hide()
	else
		local oldHidden = self.hidden
		self.hidden = false
		ObjectiveTrackerFrame:Show()
	end
end

-- Collapse Quest Tracker based on zone
function UpdateCollapseState()
	local Collapsed = false
	local _, instanceType = GetInstanceInfo()

	if (instanceType ~= "none") then
		if (instanceType == "pvp") then			-- Battlegrounds
			Collapsed = true
		elseif (instanceType == "arena") then	-- Arena
			Collapsed = true
		elseif (((instanceType == "party") or (instanceType == "scenario"))) then	-- 5 Man Dungeons
			Collapsed = true
		elseif (instanceType == "raid") then	-- Raid Dungeons
			Collapsed = true
		end
	end

	if Collapsed then
		self.collapsed = true
		ObjectiveTrackerFrame.userCollapsed = true
		ObjectiveTracker_Collapse()
	else
		self.collapsed = false
		ObjectiveTrackerFrame.userCollapsed = false
		ObjectiveTracker_Expand()
	end
end

function UpdatePlayerLocation()
	self:UpdateCollapseState()
	self:UpdateHideState()
end

hooksecurefunc(QUEST_TRACKER_MODULE, "SetBlockHeader", function(_, block)
	local item = block.itemButton

	if item and not item.skinned then
		item:SetSize(C.ActionBars.ButtonSize, C.ActionBars.ButtonSize)
		item:SetTemplate()
		item:StyleButton()

		item:SetNormalTexture(nil)

		item.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		item.icon:SetPoint("TOPLEFT", item, 2, -2)
		item.icon:SetPoint("BOTTOMRIGHT", item, -2, 2)

		item.HotKey:ClearAllPoints()
		item.HotKey:SetPoint("BOTTOMRIGHT", 0, 2)
		item.HotKey:SetFont(C.Media.Font, C.Media.FontSize)
		item.HotKey:SetShadowOffset(F.Mult or 1, -(F.Mult or 1))

		item.Count:ClearAllPoints()
		item.Count:SetPoint("TOPLEFT", 1, -1)
		item.Count:SetFont(C.Media.Font, C.Media.FontSize)
		item.Count:SetShadowOffset(F.Mult or 1, -(F.Mult or 1))

		item.skinned = true
	end
end)

F.RegisterEvent('PLAYER_LOGIN', function(self, event)
	local origSet = ObjectiveTrackerFrame.SetPoint
	local origClear = ObjectiveTrackerFrame.ClearAllPoints

	origClear(ObjectiveTrackerFrame)
	origSet(ObjectiveTrackerFrame, 'TOPRIGHT', MinimapCluster, 'BOTTOMRIGHT', 0, 0)

	ObjectiveTrackerFrame:SetHeight(F.ScreenHeight / 2)

	select(1, ObjectiveTrackerBlocksFrame:GetChildren()):Hide()
	select(1, ObjectiveTrackerBlocksFrame:GetChildren()).Show = F.Dummy

	WorldMapPlayerUpper:EnableMouse(false)
	WorldMapPlayerLower:EnableMouse(false)
end)

G.Misc.ObjectiveTracker = ObjectiveTracker