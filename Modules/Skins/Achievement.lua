local F, C, G = unpack(select(2, ...))
local bc = C.Media.BorderColor

local function LoadSkin()
	-----------------------
	-- Achievement Frame
	-----------------------
	
	local frames = {
		'AchievementFrame',
		'AchievementFrameCategories',
		'AchievementFrameSummary',
		'AchievementFrameHeader',
		'AchievementFrameSummaryCategoriesHeader',
		'AchievementFrameSummaryAchievementsHeader',
		'AchievementFrameStatsBG',
		'AchievementFrameAchievements',
		'AchievementFrameComparison',
		'AchievementFrameComparisonHeader',
		'AchievementFrameComparisonSummaryPlayer',
		'AchievementFrameComparisonSummaryFriend',
	}
	
	for _, frame in pairs(frames) do
		_G[frame]:StripTextures(true)
	end
	
	local noname_frames = {
		'AchievementFrameStats',
		'AchievementFrameSummary',
		'AchievementFrameAchievements',
		'AchievementFrameComparison'
	}
	
	for _, frame in pairs(noname_frames) do
		for i=1, _G[frame]:GetNumChildren() do
			local child = select(i, _G[frame]:GetChildren())
			if child and not child:GetName() then
				child:SetBackdrop(nil)
			end
		end
	end
	
	AchievementFrame:CreateBD(true)
	AchievementFrame.backdrop:Point('TOPLEFT', 0, 6)
	AchievementFrame.backdrop:SetPoint('BOTTOMRIGHT')
	AchievementFrameHeaderTitle:ClearAllPoints()
	AchievementFrameHeaderTitle:Point('TOPLEFT', AchievementFrame.backdrop, 'TOPLEFT', -30, -8)
	AchievementFrameHeaderPoints:ClearAllPoints()
	AchievementFrameHeaderPoints:Point('LEFT', AchievementFrameHeaderTitle, 'RIGHT', 2, 0)
	
	--Backdrops
	AchievementFrameCategoriesContainer:CreateBD()
	AchievementFrameCategoriesContainer.backdrop:Point('TOPLEFT', 0, 4)
	AchievementFrameCategoriesContainer.backdrop:Point('BOTTOMRIGHT', -2, -3)
	AchievementFrameAchievementsContainer:CreateBD()
	AchievementFrameAchievementsContainer.backdrop:Point('TOPLEFT', 0, 2)
	AchievementFrameAchievementsContainer.backdrop:Point('BOTTOMRIGHT', -3, -3)
	
	AchievementFrameCloseButton:SkinCloseButton(AchievementFrame.backdrop)
	AchievementFrameFilterDropDown:SkinDropDownBox()
	AchievementFrameFilterDropDown:Point('TOPRIGHT', AchievementFrame, 'TOPRIGHT', -44, 5)
	
	-- ScrollBars
	AchievementFrameCategoriesContainerScrollBar:SkinScrollBar()
	AchievementFrameAchievementsContainerScrollBar:SkinScrollBar()
	AchievementFrameStatsContainerScrollBar:SkinScrollBar()
	AchievementFrameComparisonContainerScrollBar:SkinScrollBar()
	AchievementFrameComparisonStatsContainerScrollBar:SkinScrollBar()
	
	--Tabs
	for i = 1, 3 do
		_G['AchievementFrameTab'..i]:SkinTab()
		_G['AchievementFrameTab'..i]:SetFrameLevel(_G['AchievementFrame']:GetFrameLevel() - 1)
		_G['AchievementFrameTab1']:SetPoint('BOTTOMLEFT', AchievementFrame, 10, -30)
		
		if i ~= 1 then
			_G['AchievementFrameTab'..i]:Point('LEFT', _G['AchievementFrameTab'..i - 1], 'RIGHT', 4, 0)
		end
	end
	
	local function SkinStatusBar(bar)
		bar:StripTextures()
		bar:SetStatusBarTexture(C.Media.StatusBar)
		bar:SetStatusBarColor(.3, .3, .3)
		bar:CreateBD(true)
		
		if _G[bar:GetName()..'Title'] then
			_G[bar:GetName()..'Title']:SetPoint('LEFT', 4, 0)
		end

		if _G[bar:GetName()..'Label'] then
			_G[bar:GetName()..'Label']:SetPoint('LEFT', 4, 0)
		end
		
		if _G[bar:GetName()..'Text'] then
			_G[bar:GetName()..'Text']:SetPoint('RIGHT', -4, 0)
		end
	end

	SkinStatusBar(AchievementFrameSummaryCategoriesStatusBar)
	SkinStatusBar(AchievementFrameComparisonSummaryPlayerStatusBar)
	SkinStatusBar(AchievementFrameComparisonSummaryFriendStatusBar)
	AchievementFrameComparisonSummaryFriendStatusBar.text:ClearAllPoints()
	AchievementFrameComparisonSummaryFriendStatusBar.text:SetPoint('CENTER')
	AchievementFrameComparisonHeader:Point('BOTTOMRIGHT', AchievementFrameComparison, 'TOPRIGHT', 45, -20)
	
	for i=1, 12 do
		local frame = _G['AchievementFrameSummaryCategoriesCategory'..i]
		local button = _G['AchievementFrameSummaryCategoriesCategory'..i..'Button']
		local highlight = _G['AchievementFrameSummaryCategoriesCategory'..i..'ButtonHighlight']
		SkinStatusBar(frame)
		button:StripTextures()
		highlight:StripTextures()
		
		_G[highlight:GetName()..'Middle']:SetTexture(1, 1, 1, 0.3)
		_G[highlight:GetName()..'Middle']:SetAllPoints(frame)
	end
	
	AchievementFrame:HookScript('OnShow', function()
		for i=1, 20 do
			local frame = _G['AchievementFrameCategoriesContainerButton'..i]
			if frame and not frame.isSkinned then
				frame:StripTextures()
				frame:StyleButton()
				frame:SetTemplate()
				frame.isSkinned = true
			end
			
			if i ~= 1 then
				frame:SetPoint('TOP', _G['AchievementFrameCategoriesContainerButton'..i - 1], 'BOTTOM', 0, -2)
			end
		end	
	end)
	
	hooksecurefunc('AchievementFrameSummary_UpdateAchievements', function()
		for i=1, ACHIEVEMENTUI_MAX_SUMMARY_ACHIEVEMENTS do
			local frame = _G['AchievementFrameSummaryAchievement'..i]
			_G['AchievementFrameSummaryAchievement'..i..'Highlight']:Kill()
			frame:StripTextures()
			
			_G['AchievementFrameSummaryAchievement'..i..'Description']:SetTextColor(0.6, 0.6, 0.6)
			
			if not frame.backdrop then
				frame:CreateBD()
				frame.backdrop:Point('TOPLEFT', 2, -2)
				frame.backdrop:Point('BOTTOMRIGHT', -2, 2)

				_G['AchievementFrameSummaryAchievement'..i..'IconBling']:Kill()
				_G['AchievementFrameSummaryAchievement'..i..'IconOverlay']:Kill()
				F.SetTemplate(_G['AchievementFrameSummaryAchievement'..i..'Icon'], true)
				_G['AchievementFrameSummaryAchievement'..i..'Icon']:Height(_G['AchievementFrameSummaryAchievement'..i..'Icon']:GetHeight() - 14)
				_G['AchievementFrameSummaryAchievement'..i..'Icon']:Width(_G['AchievementFrameSummaryAchievement'..i..'Icon']:GetWidth() - 14)
				_G['AchievementFrameSummaryAchievement'..i..'Icon']:ClearAllPoints()
				_G['AchievementFrameSummaryAchievement'..i..'Icon']:Point('LEFT', 6, 0)
				_G['AchievementFrameSummaryAchievement'..i..'IconTexture']:SetTexCoord(.08, .92, .08, .92)
				_G['AchievementFrameSummaryAchievement'..i..'IconTexture']:ClearAllPoints()
				_G['AchievementFrameSummaryAchievement'..i..'IconTexture']:Point('TOPLEFT', 2, -2)
				_G['AchievementFrameSummaryAchievement'..i..'IconTexture']:Point('BOTTOMRIGHT', -2, 2)
			end
			
			if frame.accountWide then
				frame.backdrop:SetBeautyBorderColor(ACHIEVEMENTUI_BLUEBORDER_R, ACHIEVEMENTUI_BLUEBORDER_G, ACHIEVEMENTUI_BLUEBORDER_B)
			else
				frame.backdrop:SetBeautyBorderColor(bc.r, bc.g, bc.b)
			end	
		end				
	end)
	
	for i=1, 7 do
		local frame = _G['AchievementFrameAchievementsContainerButton'..i]
		_G['AchievementFrameAchievementsContainerButton'..i..'Highlight']:Kill()
		frame:StripTextures(true)
		frame.SetBackdropBorderColor = F.Dummy

		--Initiate fucked up method of creating a backdrop
		frame.bg1 = frame:CreateTexture(nil, 'BACKGROUND')
		frame.bg1:SetDrawLayer('BACKGROUND', 4)
		frame.bg1:SetTexture(C.Media.Backdrop) --Default TukUI users this is normTex, glossTex doesn't exist
		frame.bg1:SetVertexColor(unpack(C.Media.BackdropColor))
		frame.bg1:Point('TOPLEFT', F.Mult * 4, -F.Mult * 4)
		frame.bg1:Point('BOTTOMRIGHT', -F.Mult * 4, F.Mult * 4)				
		
		frame.bg2 = frame:CreateTexture(nil, 'BACKGROUND')
		frame.bg2:SetDrawLayer('BACKGROUND', 3)
		frame.bg2:SetTexture(0,0,0)
		frame.bg2:Point('TOPLEFT', F.Mult * 3, -F.Mult * 3)
		frame.bg2:Point('BOTTOMRIGHT', -F.Mult * 3, F.Mult * 3)
		
		frame.bg3 = frame:CreateTexture(nil, 'BACKGROUND')
		frame.bg3:SetDrawLayer('BACKGROUND', 2)
		frame.bg3:SetTexture(bc.r, bc.g, bc.b)
		frame.bg3:Point('TOPLEFT', F.Mult * 2, -F.Mult * 2)
		frame.bg3:Point('BOTTOMRIGHT', -F.Mult * 2, F.Mult * 2)			

		frame.bg4 = frame:CreateTexture(nil, 'BACKGROUND')
		frame.bg4:SetDrawLayer('BACKGROUND', 1)
		frame.bg4:SetTexture(0,0,0)
		frame.bg4:Point('TOPLEFT', F.Mult, -F.Mult)
		frame.bg4:Point('BOTTOMRIGHT', -F.Mult, F.Mult)	

		_G['AchievementFrameAchievementsContainerButton'..i..'Description']:SetTextColor(0.6, 0.6, 0.6)
		_G['AchievementFrameAchievementsContainerButton'..i..'Description'].SetTextColor = F.Dummy
		_G['AchievementFrameAchievementsContainerButton'..i..'HiddenDescription']:SetTextColor(1, 1, 1)
		_G['AchievementFrameAchievementsContainerButton'..i..'HiddenDescription'].SetTextColor = F.Dummy
		
		_G['AchievementFrameAchievementsContainerButton'..i..'IconBling']:Kill()
		_G['AchievementFrameAchievementsContainerButton'..i..'IconOverlay']:Kill()
		F.SetTemplate(_G['AchievementFrameAchievementsContainerButton'..i..'Icon'], true)
		_G['AchievementFrameAchievementsContainerButton'..i..'Icon']:Height(_G['AchievementFrameAchievementsContainerButton'..i..'Icon']:GetHeight() - 14)
		_G['AchievementFrameAchievementsContainerButton'..i..'Icon']:Width(_G['AchievementFrameAchievementsContainerButton'..i..'Icon']:GetWidth() - 14)
		_G['AchievementFrameAchievementsContainerButton'..i..'Icon']:ClearAllPoints()
		_G['AchievementFrameAchievementsContainerButton'..i..'Icon']:Point('LEFT', 6, 0)
		_G['AchievementFrameAchievementsContainerButton'..i..'IconTexture']:SetTexCoord(.08, .92, .08, .92)
		_G['AchievementFrameAchievementsContainerButton'..i..'IconTexture']:ClearAllPoints()
		_G['AchievementFrameAchievementsContainerButton'..i..'IconTexture']:Point('TOPLEFT', 2, -2)
		_G['AchievementFrameAchievementsContainerButton'..i..'IconTexture']:Point('BOTTOMRIGHT', -2, 2)		

		_G['AchievementFrameAchievementsContainerButton'..i..'Tracked'].oborder = "Don't use sharp border" --Needed for ElvUI only
		_G['AchievementFrameAchievementsContainerButton'..i..'Tracked']:StripTextures()
		_G['AchievementFrameAchievementsContainerButton'..i..'Tracked']:SetTemplate()
		_G['AchievementFrameAchievementsContainerButton'..i..'Tracked']:SetCheckedTexture('Interface\\Buttons\\UI-CheckBox-Check')
		_G['AchievementFrameAchievementsContainerButton'..i..'Tracked']:Size(12, 12)
		_G['AchievementFrameAchievementsContainerButton'..i..'Tracked']:GetCheckedTexture():Point('TOPLEFT', -4, 4)
		_G['AchievementFrameAchievementsContainerButton'..i..'Tracked']:GetCheckedTexture():Point('BOTTOMRIGHT', 4, -4)
		
		_G['AchievementFrameAchievementsContainerButton'..i..'Tracked']:ClearAllPoints()
		_G['AchievementFrameAchievementsContainerButton'..i..'Tracked']:Point('BOTTOMLEFT', frame, 'BOTTOMLEFT', 5, 5)
		
		_G['AchievementFrameAchievementsContainerButton'..i..'Tracked'].ClearAllPoints = F.Dummy
		_G['AchievementFrameAchievementsContainerButton'..i..'Tracked'].SetPoint = F.Dummy
	end

	local compares = {
		'Player',
		'Friend'
	}
	
	for _, compare in pairs(compares) do
		for i=1, 9 do
			local frame = 'AchievementFrameComparisonContainerButton'..i..compare
			
			_G[frame]:StripTextures()
			_G[frame..'Background']:Kill()
			
			_G[frame].SetBackdropBorderColor = F.Dummy		
			
			if _G[frame..'Description'] then
				_G[frame..'Description']:SetTextColor(0.6, 0.6, 0.6)
				_G[frame..'Description'].SetTextColor = F.Dummy
			end

			--Initiate fucked up method of creating a backdrop
			_G[frame].bg1 = _G[frame]:CreateTexture(nil, 'BACKGROUND')
			_G[frame].bg1:SetDrawLayer('BACKGROUND', 4)
			_G[frame].bg1:SetTexture(C.Media.Backdrop) --Default TukUI users this is normTex, glossTex doesn't exist
			_G[frame].bg1:SetVertexColor(unpack(C.Media.BackdropColor))
			_G[frame].bg1:Point('TOPLEFT', F.Mult * 4, -F.Mult * 4)
			_G[frame].bg1:Point('BOTTOMRIGHT', -F.Mult * 4, F.Mult * 4)				
			
			_G[frame].bg2 = _G[frame]:CreateTexture(nil, 'BACKGROUND')
			_G[frame].bg2:SetDrawLayer('BACKGROUND', 3)
			_G[frame].bg2:SetTexture(0,0,0)
			_G[frame].bg2:Point('TOPLEFT', F.Mult * 3, -F.Mult * 3)
			_G[frame].bg2:Point('BOTTOMRIGHT', -F.Mult * 3, F.Mult * 3)
			
			_G[frame].bg3 = _G[frame]:CreateTexture(nil, 'BACKGROUND')
			_G[frame].bg3:SetDrawLayer('BACKGROUND', 2)
			_G[frame].bg3:SetTexture(bc.r, bc.g, bc.b)
			_G[frame].bg3:Point('TOPLEFT', F.Mult * 2, -F.Mult * 2)
			_G[frame].bg3:Point('BOTTOMRIGHT', -F.Mult * 2, F.Mult * 2)			

			_G[frame].bg4 = _G[frame]:CreateTexture(nil, 'BACKGROUND')
			_G[frame].bg4:SetDrawLayer('BACKGROUND', 1)
			_G[frame].bg4:SetTexture(0,0,0)
			_G[frame].bg4:Point('TOPLEFT', F.Mult, -F.Mult)
			_G[frame].bg4:Point('BOTTOMRIGHT', -F.Mult, F.Mult)	

			if compare == 'Friend' then
				_G[frame..'Shield']:Point('TOPRIGHT', _G['AchievementFrameComparisonContainerButton'..i..'Friend'], 'TOPRIGHT', -20, -3)
			end

			_G[frame..'IconBling']:Kill()
			_G[frame..'IconOverlay']:Kill()
			F.SetTemplate(_G[frame..'Icon'], true)
			_G[frame..'Icon']:Height(_G[frame..'Icon']:GetHeight() - 14)
			_G[frame..'Icon']:Width(_G[frame..'Icon']:GetWidth() - 14)
			_G[frame..'Icon']:ClearAllPoints()
			_G[frame..'Icon']:Point('LEFT', 6, 0)
			_G[frame..'IconTexture']:SetTexCoord(.08, .92, .08, .92)
			_G[frame..'IconTexture']:ClearAllPoints()
			_G[frame..'IconTexture']:Point('TOPLEFT', 2, -2)
			_G[frame..'IconTexture']:Point('BOTTOMRIGHT', -2, 2)					
		end
	end
	
	for i=1, 20 do
		local frame = _G['AchievementFrameStatsContainerButton'..i]
		frame:StyleButton()
		
		_G['AchievementFrameStatsContainerButton'..i..'BG']:SetTexture(1, 1, 1, 0)
		_G['AchievementFrameStatsContainerButton'..i..'HeaderLeft']:Kill()
		_G['AchievementFrameStatsContainerButton'..i..'HeaderRight']:Kill()
		_G['AchievementFrameStatsContainerButton'..i..'HeaderMiddle']:Kill()
		
		local frame = 'AchievementFrameComparisonStatsContainerButton'..i
		_G[frame]:StripTextures()
		_G[frame]:StyleButton()
	
		_G[frame..'BG']:SetTexture(1, 1, 1, 0.2)
		_G[frame..'HeaderLeft']:Kill()
		_G[frame..'HeaderRight']:Kill()
		_G[frame..'HeaderMiddle']:Kill()			
	end
	
	AchievementFrameSummary:SetPoint('TOPLEFT', AchievementFrameCategories, 'TOPRIGHT', 5, 1)
	
	hooksecurefunc('AchievementButton_GetProgressBar', function(index)
		local frame = _G['AchievementFrameProgressBar'..index]
		if frame then
			if not frame.skinned then
				frame:StripTextures()
				frame:SetStatusBarTexture(C.Media.Statusbar)
				frame:SetStatusBarColor(4/255, 179/255, 30/255)
				frame:SetFrameLevel(frame:GetFrameLevel() + 3)
				
				frame:Height(frame:GetHeight() - 2)
				
				--Initiate fucked up method of creating a backdrop
				frame.bg1 = frame:CreateTexture(nil, 'BACKGROUND')
				frame.bg1:SetDrawLayer('BACKGROUND', -7)
				frame.bg1:SetTexture(unpack(C.Media.BackdropColor))
				frame.bg1:Point('TOPLEFT', -F.Mult * 3, F.Mult * 3)
				frame.bg1:Point('BOTTOMRIGHT', F.Mult * 3, -F.Mult * 3)
				
				frame.bg2 = frame:CreateTexture(nil, 'BACKGROUND')
				frame.bg2:SetDrawLayer('BACKGROUND', -6)
				frame.bg2:SetTexture(bc.r, bc.g, bc.b)
				frame.bg2:Point('TOPLEFT', -F.Mult * 2, F.Mult * 2)
				frame.bg2:Point('BOTTOMRIGHT', F.Mult * 2, -F.Mult * 2)					

				frame.bg3 = frame:CreateTexture(nil, 'BACKGROUND')
				frame.bg3:SetDrawLayer('BACKGROUND', -5)
				frame.bg3:SetTexture(unpack(C.Media.BackdropColor))
				frame.bg3:Point('TOPLEFT', -F.Mult, F.Mult)
				frame.bg3:Point('BOTTOMRIGHT', F.Mult, -F.Mult)	
				--F.SetTemplate(frame.bg3, true)
				
				frame.text:ClearAllPoints()
				frame.text:SetPoint('CENTER', frame, 'CENTER', 0, -1)
				frame.text:SetJustifyH('CENTER')
				
				if index > 1 then
					frame:ClearAllPoints()
					frame:Point('TOP', _G['AchievementFrameProgressBar'..index-1], 'BOTTOM', 0, -5)
					frame.SetPoint = F.Dummy
					frame.ClearAllPoints = F.Dummy
				end
				
				frame.skinned = true
			end

		end
	end)
	
	hooksecurefunc('AchievementObjectives_DisplayCriteria', function(objectivesFrame, id)
		local numCriteria = GetAchievementNumCriteria(id)
		local textStrings, metas = 0, 0
		for i = 1, numCriteria do	
			local criteriaString, criteriaType, completed, quantity, reqQuantity, charName, flags, assetID, quantityString = GetAchievementCriteriaInfo(id, i)
			
			if ( criteriaType == CRITERIA_TYPE_ACHIEVEMENT and assetID ) then
				metas = metas + 1;
				local metaCriteria = AchievementButton_GetMeta(metas);				
				if ( objectivesFrame.completed and completed ) then
					metaCriteria.label:SetShadowOffset(0, 0)
					metaCriteria.label:SetTextColor(1, 1, 1, 1);
				elseif ( completed ) then
					metaCriteria.label:SetShadowOffset(1, -1)
					metaCriteria.label:SetTextColor(0, 1, 0, 1);
				else
					metaCriteria.label:SetShadowOffset(1, -1)
					metaCriteria.label:SetTextColor(.6, .6, .6, 1);
				end				
			elseif criteriaType ~= 1 then
				textStrings = textStrings + 1;
				local criteria = AchievementButton_GetCriteria(textStrings);				
				if ( objectivesFrame.completed and completed ) then
					criteria.name:SetTextColor(1, 1, 1, 1);
					criteria.name:SetShadowOffset(0, 0);
				elseif ( completed ) then
					criteria.name:SetTextColor(0, 1, 0, 1);
					criteria.name:SetShadowOffset(1, -1);
				else
					criteria.name:SetTextColor(.6, .6, .6, 1);
					criteria.name:SetShadowOffset(1, -1);
				end		
			end
		end
	end)
	
	hooksecurefunc('AchievementButton_DisplayAchievement', function(frame)
		if frame.accountWide and frame.bg3 then
			frame.bg3:SetTexture(ACHIEVEMENTUI_BLUEBORDER_R, ACHIEVEMENTUI_BLUEBORDER_G, ACHIEVEMENTUI_BLUEBORDER_B)
		elseif frame.bg3 then
			frame.bg3:SetTexture(bc.r, bc.g, bc.b)
		end
	end)
end

F.SkinFuncs['Blizzard_AchievementUI'] = LoadSkin