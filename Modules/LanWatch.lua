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

local function SkinButton(button, texture)
	if(string.match(button:GetName(), 'WatchFrameItem%d+') and not button.skinned) then
		button:SetSize(26, 26)

		local icon = _G[button:GetName() .. 'IconTexture']
		icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
		icon:SetPoint('TOPLEFT', 1, -1)
		icon:SetPoint('BOTTOMRIGHT', -1, 1)

		_G[button:GetName() .. 'NormalTexture']:SetTexture()

		button.skinned = true
	end
end

local function SetLine(...)
	local line, _, _, isHeader, _, hasDash = ...
	line.hasDash = hasDash == 1

	if(line.hasDash and line.square) then
		line.square:Show()
	elseif(line.square) then
		line.square:Hide()
	end
end

local function GetQuestData(self)
	if(self.type == 'QUEST') then
		local _, _, questIndex = GetQuestWatchInfo(self.index)
		if(questIndex) then
			local _, level, _, _, _, _, frequency = GetQuestLogTitle(questIndex)
			if (frequency == LE_QUEST_FREQUENCY_DAILY) then
				return 1/4, 6/9, 1, 'D'
			elseif (frequency == LE_QUEST_FREQUENCY_WEEKLY) then
				return 1/4, 6/9, 1, 'W'
			else
				local color = GetQuestDifficultyColor(level)
				return color.r, color.g, color.b, level
			end
		end
	end

	return 1, 1, 1
end

local function IsSuperTracked(self)
	if(self.type ~= 'QUEST') then return end

		local _, _, questIndex = GetQuestWatchInfo(self.index)
	if(questIndex) then
		local _, _, _, _, _, _, _, id = GetQuestLogTitle(questIndex)
		if(id and GetSuperTrackedQuestID() == id) then
			return true
		end
	end
end

local function HighlightLine(self, highlight)
	for index = self.startLine, self.lastLine do
		local line = self.lines[index]
		if(line) then
			if(index == self.startLine) then
				local r, g, b, prefix = GetQuestData(self)
				local text = line.text:GetText()
				if(text and string.sub(text, -1) ~= '\032') then
					if prefix then
						line.text:SetFormattedText('[%s] %s\032', prefix, text)
					else
						line.text:SetFormattedText('%s\032', text)
					end
				end

				if(highlight) then
					line.text:SetTextColor(r, g, b)
				else
					if C.Media.ClassColor then
						line.text:SetTextColor(cc.r, cc.g, cc.b)
					else
						line.text:SetTextColor(r * 6/7, g * 6/7, b * 6/7)
					end
				end
			else
				if(highlight) then
					line.text:SetTextColor(6/7, 6/7, 6/7)

					if(line.square) then
						line.square:SetBackdropColor(1/5, 1/2, 4/5)
					end
				else
					line.text:SetTextColor(5/7, 5/7, 5/7)

					if(line.square) then
						if(IsSuperTracked(self)) then
							line.square:SetBackdropColor(5/7, 1/5, 1/5)
						else
							line.square:SetBackdropColor(4/5, 4/5, 1/5)
						end
					end
				end
			end
		end
	end
end

local nextLine = 1
local function SkinLine()
	for index = nextLine, 50 do
		local line = _G['WatchFrameLine' .. index]
		if(line) then
			line.text:SetFont(font, 12)
			line.text:SetShadowColor(0, 0, 0, 0)
			line.text:SetSpacing(5)
			line.dash:SetAlpha(0)

			local square = CreateFrame('Frame', nil, line)
			square:SetPoint('TOPRIGHT', line, 'TOPLEFT', 7, -6)
			square:SetSize(5, 5)
			square:SetBackdrop({bgFile = texture})
			square:SetBackdropColor(4/5, 4/5, 1/5)
			square:SetBackdropBorderColor(0, 0, 0)
			line.square = square

			if(line.hasDash) then
				square:Show()
			else
				square:Hide()
			end
		else
			nextLine = index
			break
		end
	end

	--[[for index = 1, #WATCHFRAME_LINKBUTTONS do
		HighlightLine(WATCHFRAME_LINKBUTTONS[index], false)
	end]]
end

local nextScenarioLine = 1
local function SkinScenarioLine()
	for index = nextScenarioLine, 50 do
		local line = _G['WatchFrameScenarioLine' .. index]
		if(line) then
			line.text:SetFont(font, 12)
			line.text:SetShadowColor(0, 0, 0, 0)
			line.text:SetSpacing(5)

			local square = CreateFrame('Frame', nil, line)
			square:SetPoint('TOPRIGHT', line, 'TOPLEFT', 7, -6)
			square:SetSize(5, 5)
			square:SetBackdrop({bgFile = texture})
			square:SetBackdropColor(4/5, 4/5, 1/5)
			square:SetBackdropBorderColor(0, 0, 0)
			line.square = square

			line.icon:Hide()
		else
			nextScenarioLine = index
			break
		end
	end

	local _, _, numCriteria = C_Scenario.GetStepInfo()
	for index = 1, numCriteria do
		local text, _, completed = C_Scenario.GetCriteriaInfo(index)
		for lineIndex = 1, nextScenarioLine do
			local line = _G['WatchFrameScenarioLine' .. lineIndex]
			if(line and string.find(line.text:GetText(), text)) then
				if(completed) then
					line.square:SetBackdropColor(0, 1, 0)
				else
					line.square:SetBackdropColor(4/5, 4/5, 4/5)
				end
			end
		end
	end
end

local origClick
local function ClickLine(self, button, ...)
	if(button == 'RightButton' and not IsShiftKeyDown() and self.type == 'QUEST') then
		local _, _, _, _, _, _, _, _, questID = GetQuestLogTitle(GetQuestIndexForWatch(self.index))
		QuestPOI_SelectButtonByQuestId('WatchFrameLines', questID, true)

		if(WorldMapFrame:IsShown()) then
			WorldMapFrame_SelectQuestById(questID)
		end

		SetSuperTrackedQuestID(questID)

		for index = 1, #WATCHFRAME_LINKBUTTONS do
			if(index ~= self.index) then
				HighlightLine(WATCHFRAME_LINKBUTTONS[index], false)
			end
		end
	else
		origClick(self, button, ...)
	end
end

local function QuestPOI(name, type, index)
	if(name == 'WatchFrameLines') then
		_G['poi' .. name .. type .. '_' .. index]:Hide()
	end
end

F.RegisterEvent('PLAYER_LOGIN', function(self, event)
	hooksecurefunc('ObjectiveTracker_Update', SkinLine)
	hooksecurefunc('ObjectiveTracker_Update', SkinScenarioLine)
	hooksecurefunc('QuestPOI_FindButton', QuestPOI)
	hooksecurefunc('SetItemButtonTexture', SkinButton)

	origClick = WatchFrameLinkButtonTemplate_OnClick
	WatchFrameLinkButtonTemplate_OnClick = ClickLine
	WatchFrameLinkButtonTemplate_Highlight = HighlightLine

	local origSet = ObjectiveTrackerFrame.SetPoint
	local origClear = ObjectiveTrackerFrame.ClearAllPoints

	origClear(ObjectiveTrackerFrame)
	origSet(ObjectiveTrackerFrame, 'TOPRIGHT', MinimapCluster, 'BOTTOMRIGHT', 0, 0)

	ObjectiveTrackerFrame:SetHeight(F.ScreenHeight / 1.6)

	select(1, ObjectiveTrackerBlocksFrame:GetChildren()):Hide()
	select(1, ObjectiveTrackerBlocksFrame:GetChildren()).Show = F.Dummy

	--[[local ScenarioTextHeader = select(1, ScenarioBlocksFrame:GetChildren()).TextHeader.text
	ScenarioTextHeader:SetFont(font, 12)
	ScenarioTextHeader:SetShadowColor(0, 0, 0, 0)
	
	if C.Media.ClassColor then
		ScenarioTextHeader:SetTextColor(cc.r, cc.g, cc.b)
	else
		ScenarioTextHeader:SetTextColor(0.85, 0.85, 0)
	end]]

	SkinScenarioLine()
	
	WorldMapPlayerUpper:EnableMouse(false)
	WorldMapPlayerLower:EnableMouse(false)
end)

local bg = CreateFrame('Frame', 'WatchBG', WatchFrame)
bg:SetFrameStrata('BACKGROUND')
bg:SetPoint('TOPRIGHT', WatchFrameLines, 23, 5)
bg:SetWidth(ObjectiveTrackerFrame:GetWidth() + 2)
bg:SetTemplate()

--[[hooksecurefunc('ObjectiveTracker_Update', function(self, event)
	if #WATCHFRAME_LINKBUTTONS < 1 then
		bg:SetWidth(ObjectiveTrackerFrame:GetWidth() + 2)
		ObjectiveTrackerFrame:Hide()
	else
		local size = 0
		local newsize
		for i = 1, #WATCHFRAME_QUESTLINES do
			local line = WATCHFRAME_QUESTLINES[i]

			linesize = line.text:GetHeight()
			size = size + linesize
		end
		
		bg:SetHeight(F.Scale(size + ((GetNumQuestWatches() / 2) * 29)) * F.Mult)
		bg:SetWidth(ObjectiveTrackerFrame:GetWidth() + 2)
		ObjectiveTrackerFrame:Show()
	end
end)]]

F.RegisterEvent('PLAYER_REGEN_DISABLED', function()
	ObjectiveTrackerFrame:Hide()
end)

F.RegisterEvent('PLAYER_REGEN_ENABLED', function()
	ObjectiveTrackerFrame:Show()
end)

G.Misc.ObjectiveTracker = ObjectiveTracker