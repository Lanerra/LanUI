local F, C, G = unpack(select(2, ...))

local font = C.Media.Font
local texture = C.Media.Backdrop
local cc = F.PlayerColor

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
		local questIndex = GetQuestIndexForWatch(self.index)
		if(questIndex) then
			local _, level, _, _, _, _, _, daily = GetQuestLogTitle(questIndex)
			if(daily) then
				return 1/4, 6/9, 1, 'D'
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

	local questIndex = GetQuestIndexForWatch(self.index)
	if(questIndex) then
		local _, _, _, _, _, _, _, _, id = GetQuestLogTitle(questIndex)
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
					--line.text:SetFormattedText('[%s] %s\032', prefix, text)
					line.text:SetFormattedText('%s\032', text)
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

	for index = 1, #WATCHFRAME_LINKBUTTONS do
		HighlightLine(WATCHFRAME_LINKBUTTONS[index], false)
	end
end

local nextScenarioLine = 1
local function SkinScenarioLine()
	for index = nextScenarioLine, 50 do
		local line = _G['WatchFrameScenarioLine' .. index]
		if(line) then
			line.text:SetFont(font, 12)
			line.text:SetShadowColor(0, 0, 0, 0)

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
	hooksecurefunc('WatchFrame_SetLine', SetLine)
	hooksecurefunc('WatchFrame_Update', SkinLine)
	hooksecurefunc('WatchFrameScenario_UpdateScenario', SkinScenarioLine)
	hooksecurefunc('QuestPOI_DisplayButton', QuestPOI)
	hooksecurefunc('SetItemButtonTexture', SkinButton)

	origClick = WatchFrameLinkButtonTemplate_OnClick
	WatchFrameLinkButtonTemplate_OnClick = ClickLine
	WatchFrameLinkButtonTemplate_Highlight = HighlightLine

	local origSet = WatchFrame.SetPoint
	local origClear = WatchFrame.ClearAllPoints

	WatchFrame.SetPoint = F.Dummy
	WatchFrame.ClearAllPoints = F.Dummy

	origClear(WatchFrame)
	origSet(WatchFrame, 'TOPRIGHT', MinimapCluster, 'BOTTOMRIGHT', 0, 0)

	WatchFrame:SetHeight(F.ScreenHeight / 1.6)

	WatchFrameCollapseExpandButton:Hide()
	WatchFrameCollapseExpandButton.Show = F.Dummy

	WatchFrameTitle:Hide()
	WatchFrameTitle.Show = F.Dummy

	local ScenarioTextHeader = WatchFrameScenarioFrame.ScrollChild.TextHeader.text
	ScenarioTextHeader:SetFont(font, 12)
	ScenarioTextHeader:SetShadowColor(0, 0, 0, 0)
	
	if C.Media.ClassColor then
		ScenarioTextHeader:SetTextColor(cc.r, cc.g, cc.b)
	else
		ScenarioTextHeader:SetTextColor(0.85, 0.85, 0)
	end

	SkinScenarioLine()

	WatchFrame_SetSorting(nil, 1)

	WorldMapPlayerUpper:EnableMouse(false)
	WorldMapPlayerLower:EnableMouse(false)
end)

local bg = CreateFrame('Frame', 'WatchBG', WatchFrame)
bg:SetFrameStrata('BACKGROUND')
bg:SetPoint('TOPRIGHT', WatchFrameLines, 23, 5)
bg:SetWidth(WatchFrame:GetWidth() + 2)
bg:SetTemplate()

hooksecurefunc('WatchFrame_Update', function(self, event)
	if #WATCHFRAME_LINKBUTTONS < 1 then
		bg:SetWidth(WatchFrame:GetWidth() + 2)
		WatchFrame:Hide()
	else
		local size = 0
		local newsize
		local adjust
		for i = 1, #WATCHFRAME_QUESTLINES do
			local line = WATCHFRAME_QUESTLINES[i]

			linesize = line.text:GetHeight()
			size = size + linesize
		end
		
		if GetNumQuestWatches() > 4 then
			adjust = 8
		else
			adjust = 0
		end
		
		bg:SetHeight(F.Scale(size + ((GetNumQuestWatches() / 2) * 29) + adjust))
		bg:SetWidth(WatchFrame:GetWidth() + 2)
		WatchFrame:Show()
	end
end)

F.RegisterEvent('PLAYER_REGEN_DISABLED', function()
	WatchFrame:Hide()
end)

F.RegisterEvent('PLAYER_REGEN_ENABLED', function()
	WatchFrame:Show()
end)