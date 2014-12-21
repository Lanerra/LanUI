local F, C, G = unpack(select(2, ...))

local LoadTooltipSkin = CreateFrame("Frame")
LoadTooltipSkin:RegisterEvent("ADDON_LOADED")
LoadTooltipSkin:SetScript("OnEvent", function(self, event, addon)
	if IsAddOnLoaded("Skinner") or IsAddOnLoaded("Aurora") then
		self:UnregisterEvent("ADDON_LOADED")
		return
	end
	
	LoadAddOn('Blizzard_GarrisonUI')

	if addon == "Blizzard_GarrisonUI" then
		local Tooltips = {
			FloatingGarrisonFollowerTooltip,
			FloatingGarrisonFollowerAbilityTooltip,
			FloatingGarrisonMissionTooltip,
			GarrisonFollowerAbilityTooltip,
			GarrisonBuildingFrame.BuildingLevelTooltip,
		}
		for i, tt in pairs(Tooltips) do
			if tt then
				tt.Background:SetTexture(nil)
				tt.BorderTop:SetTexture(nil)
				tt.BorderTopLeft:SetTexture(nil)
				tt.BorderTopRight:SetTexture(nil)
				tt.BorderLeft:SetTexture(nil)
				tt.BorderRight:SetTexture(nil)
				tt.BorderBottom:SetTexture(nil)
				tt.BorderBottomRight:SetTexture(nil)
				tt.BorderBottomLeft:SetTexture(nil)
				tt:SetTemplate()

				if tt.Portrait then tt.Portrait:StripTextures() end
			end
		end
	end
end)

local function LoadSkin()
	GarrisonBuildingFrame:StripTextures()
	GarrisonBuildingFrame:SetTemplate()
	GarrisonBuildingFrame.CloseButton:SkinCloseButton()
	GarrisonBuildingFrame.TownHallBox.UpgradeButton:SkinButton()
	GarrisonBuildingFrame.InfoBox.UpgradeButton:SkinButton()

	GarrisonLandingPage:StripTextures()
	GarrisonLandingPage:SetTemplate()
	GarrisonLandingPageReportListListScrollFrameScrollBar:SkinScrollBar()
	GarrisonLandingPage.CloseButton:SkinCloseButton()
	GarrisonLandingPage.CloseButton:SetFrameStrata("HIGH")
	GarrisonLandingPageTab1:SetPoint("TOPLEFT", GarrisonLandingPage, "BOTTOMLEFT", 70, 2)
	GarrisonLandingPageTab1:SkinTab()
	GarrisonLandingPageTab2:SkinTab()

	-- GarrisonLandingPageReport.InProgress:GetRegions():Kill()
	-- GarrisonLandingPageReport.InProgress:SkinButton()
	-- GarrisonLandingPageReport.Available:GetRegions():Kill()
	-- GarrisonLandingPageReport.Available:SkinButton()

	GarrisonLandingPage.FollowerList:StripTextures()
	GarrisonLandingPage.FollowerList:CreateBD()
	GarrisonLandingPage.FollowerList.SearchBox:SetPoint("TOPLEFT", 2, 25)
	GarrisonLandingPage.FollowerList.SearchBox:SkinEditBox()
	GarrisonLandingPage.FollowerTab.XPBar:SetTemplate()

	GarrisonMissionFrame:StripTextures()
	GarrisonMissionFrame:CreateBD()
	GarrisonMissionFrame.CloseButton:SkinCloseButton()
	GarrisonMissionFrame.MissionTab.MissionPage.CloseButton:SkinCloseButton()
	GarrisonMissionFrame.MissionTab.MissionPage:StripTextures()
	GarrisonMissionFrame.MissionTab.MissionPage.Stage:StripTextures()
	GarrisonMissionFrame.MissionTab.MissionPage:CreateBD()
	GarrisonMissionFrame.MissionTab.MissionPage.Stage:CreateBD()
	
	local stage = GarrisonMissionFrame.MissionTab.MissionPage.Stage
	local sb = GarrisonMissionFrame.MissionTab.MissionPage.Stage.backdrop
	local mission = GarrisonMissionFrame.MissionTab.MissionPage
	local mb = GarrisonMissionFrame.MissionTab.MissionPage.backdrop

	sb:ClearAllPoints()
	sb:Point('TOPLEFT', stage, 3, 1)
	sb:Point('BOTTOMRIGHT', stage, -3, -1)

	--mission:CreateBD()
	mb:ClearAllPoints()
	mb:Point('TOPLEFT', sb)
	mb:Point('BOTTOMRIGHT', mission, -3, 0)
	
	local complete = GarrisonMissionFrame.MissionComplete
	GarrisonMissionFrameMissions.CompleteDialog.BorderFrame:StripTextures()
	GarrisonMissionFrameMissions.CompleteDialog.BorderFrame:SetTemplate()
	GarrisonMissionFrameMissions.CompleteDialog.BorderFrame.ViewButton:SkinButton()
	complete:StripTextures()
	complete:CreateBD()
	complete.Stage.MissionInfo:StripTextures()
	
	complete.Stage:CreateBD()
	complete.Stage.backdrop:SetOutside(complete.Stage)
	complete.NextMissionButton:SkinButton()
	GarrisonMissionFrameMissions.CompleteDialog.BorderFrame.ViewButton:SkinButton()
	complete.NextMissionButton:ClearAllPoints()
	complete.NextMissionButton:Point('BOTTOM', complete, 0, 4)
	complete.Stage.backdrop:Point('TOPLEFT', complete.Stage, 2, 2)
	complete.Stage.backdrop:Point('BOTTOMRIGHT', complete.Stage, -2, -2)
	complete.backdrop:Point('TOPLEFT', complete.Stage.backdrop)
	complete.backdrop:Point('BOTTOMRIGHT', complete, -2, 0)
	
	local chance = GarrisonMissionFrame.MissionTab.MissionPage.RewardsFrame.Chance
	reward = GarrisonMissionFrame.MissionTab.MissionPage.RewardsFrame.Reward1

	chance:ClearAllPoints()
	chance:Point('RIGHT', reward, 'LEFT', 0, 10)
	
	GarrisonMissionFrameFollowers.MaterialFrame:StripTextures()
	
	GarrisonMissionFrame.MissionTab.MissionPage.RewardsFrame:StripTextures()
	GarrisonMissionFrame.MissionTab.MissionPage.CostFrame:ClearAllPoints()
	GarrisonMissionFrame.MissionTab.MissionPage.CostFrame:Point('BOTTOM', GarrisonMissionFrame.MissionTab.MissionPage, 0, 4)
	
	--[[for i = 1, 5 do
		local Reward = _G['GarrisonMissionFrame.MissionTab.MissionPage.RewardsFrame.Reward'..i]
		
		if Reward then
			Reward.Icon:SetTexCoord(unpack(F.TexCoords))
			Reward:CreateBD()
			Reward.backdrop:SetOutside(Reward.Icon)
			Reward.Icon:SetDrawLayer('OVERLAY')
			Reward.Count:SetDrawLayer('OVERLAY')
		end
	end]]

	local StartButton = GarrisonMissionFrame.MissionTab.MissionPage.StartMissionButton
	StartButton:SkinButton()
	StartButton:ClearAllPoints()
	StartButton:Point('TOP', GarrisonMissionFrame.MissionTab.MissionPage, 'BOTTOM', 0, -4)
	StartButton.ClearAllPoints = F.Dummy
	StartButton.SetPoint = F.Dummy
	StartButton.Flash:Kill()
	--StartButton.overlay:SetVertexColor(0.3, 0.3, 0.3, 0.3)
	--[[StartButton:SetScript("OnLeave", function(self)
		StartButton:SetBackdropBorderColor(unpack(C.media.border_color))
		StartButton.overlay:SetVertexColor(0.3, 0.3, 0.3, 0.3)
	end)]]

	GarrisonMissionFrameTab1:SetPoint("BOTTOMLEFT", GarrisonMissionFrame, "BOTTOMLEFT", 11, -40)
	GarrisonMissionFrameTab1:SkinTab()
	GarrisonMissionFrameTab2:SkinTab()

	GarrisonMissionFrameFollowers:StripTextures()
	GarrisonMissionFrameFollowers:CreateBD()
	GarrisonMissionFrameFollowers.SearchBox:SkinEditBox()
	GarrisonMissionFrameFollowersListScrollFrameScrollBar:SkinScrollBar()

	GarrisonCapacitiveDisplayFrame:StripTextures()
	GarrisonCapacitiveDisplayFrameInset:StripTextures()
	GarrisonCapacitiveDisplayFrame:CreateBD()
	-- GarrisonCapacitiveDisplayFrame.CapacitiveDisplay:StripTextures()
	GarrisonCapacitiveDisplayFrameCloseButton:SkinCloseButton()
	GarrisonCapacitiveDisplayFrame.StartWorkOrderButton:SkinButton()

	-- local function Reagents()
		-- for _, button in pairs(GarrisonCapacitiveDisplayFrame.CapacitiveDisplay.Reagents) do
			-- -- button:StripTextures()
			-- button.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			-- button:CreateBackdrop("Default")
			-- button.backdrop:ClearAllPoints()
			-- button.backdrop:SetPoint("TOPLEFT", button.Icon, -2, 2)
			-- button.backdrop:SetPoint("BOTTOMRIGHT", button.Icon, 2, -2)
		-- end
	-- end
	-- hooksecurefunc("GarrisonCapacitiveDisplayFrame_Update", Reagents)

	for i = 1, GarrisonLandingPageReportListListScrollFrameScrollChild:GetNumChildren() do
		local child = select(i, GarrisonLandingPageReportListListScrollFrameScrollChild:GetChildren())
		for j = 1, child:GetNumChildren() do
			local childC = select(j, child:GetChildren())
			childC.Icon:SetTexCoord(unpack(F.TexCoords))
			childC.Icon:CreateBD()
			childC:CreateBD()
		end
	end
end

F.SkinFuncs["Blizzard_GarrisonUI"] = LoadSkin