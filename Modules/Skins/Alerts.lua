local F, C, G = unpack(select(2, ...))
local bc = C.Media.BorderColor

local function LoadSkin()
	local function forceAlpha(self, alpha, isForced)
		if alpha ~= 1 and isForced ~= true then
			self:SetAlpha(1, true)
		end
	end
	
	local function FixBg(f)
		if f:GetObjectType() == "AnimationGroup" then
			f = f:GetParent()
		end
		f.backdrop:SetBackdropColor(unpack(C.Media.BackdropColor))
	end
	
	local function DigsiteCompleteToastPopUp()
		local frame = _G["DigsiteCompleteToastFrame"]

		if frame then
			frame:SetAlpha(1)
			frame.SetAlpha = F.Dummy

			if not frame.backdrop then
				frame:SetTemplate()
				frame.backdrop:SetPoint("TOPLEFT", frame, "TOPLEFT", 4, -6)
				frame.backdrop:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -7, 6)

				frame:HookScript("OnEnter", FixBg)
				frame:HookScript("OnShow", FixBg)
				frame.animIn:HookScript("OnFinished", FixBg)
			end

			-- Background
			frame:GetRegions():Hide()

			_G["DigsiteCompleteToastFrameGlow"]:Kill()
			_G["DigsiteCompleteToastFrameShine"]:Kill()
		end
	end
	hooksecurefunc("AlertFrame_SetDigsiteCompleteToastFrameAnchors", DigsiteCompleteToastPopUp)

	local function SkinStorePurchasePopUp()
		local frame = _G["StorePurchaseAlertFrame"]

		if frame then
			frame:SetAlpha(1)
			frame.SetAlpha = F.Dummy

			if not frame.backdrop then
				frame:SetTemplate()
				frame.backdrop:SetPoint("TOPLEFT", frame, "TOPLEFT", -5, -6)
				frame.backdrop:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 1, 6)

				frame:HookScript("OnEnter", FixBg)
				frame:HookScript("OnShow", FixBg)
				frame.animIn:HookScript("OnFinished", FixBg)
			end

			-- Background
			frame.Background:Kill()
			frame.glow:Kill()
			frame.shine:Kill()

			-- Icon
			frame.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

			-- Icon border
			if not frame.Icon.b then
				frame.Icon.b = CreateFrame("Frame", nil, frame)
				frame.Icon.b:SetFrameLevel(0)
				frame.Icon.b:CreateBD()
				frame.Icon.b:SetPoint("TOPLEFT", frame.Icon, "TOPLEFT", -2, 2)
				frame.Icon.b:SetPoint("BOTTOMRIGHT", frame.Icon, "BOTTOMRIGHT", 2, -2)
			end
		end
	end
	hooksecurefunc("AlertFrame_SetStorePurchaseAnchors", SkinStorePurchasePopUp)

	local function SkinLootUpgradePopUp()
		for i = 1, #LOOT_UPGRADE_ALERT_FRAMES do
			local frame = LOOT_UPGRADE_ALERT_FRAMES[i]
			if frame then
				frame:SetAlpha(1)
				frame.SetAlpha = F.Dummy

				if not frame.backdrop then
					frame:SetTemplate()
					frame.backdrop:SetPoint("TOPLEFT", frame, "TOPLEFT", -14, -6)
					frame.backdrop:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 10, 6)

					frame:HookScript("OnEnter", FixBg)
					frame:HookScript("OnShow", FixBg)
					frame.animIn:HookScript("OnFinished", FixBg)
				end

				-- Background
				frame.Background:Kill()
				frame.BaseQualityBorder:Kill()
				frame.UpgradeQualityBorder:Kill()
				frame.BorderGlow:Kill()
				frame.Sheen:Kill()
				for i = 1, frame.numArrows do
					frame["Arrow"..i]:Kill()
				end

				-- Icon
				frame.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

				-- Icon border
				if not frame.Icon.b then
					frame.Icon.b = CreateFrame("Frame", nil, frame)
					frame.Icon.b:SetFrameLevel(0)
					frame.Icon.b:CreateBD()
					frame.Icon.b:SetPoint("TOPLEFT", frame.Icon, "TOPLEFT", -2, 2)
					frame.Icon.b:SetPoint("BOTTOMRIGHT", frame.Icon, "BOTTOMRIGHT", 2, -2)
				end
			end
		end
	end
	hooksecurefunc("AlertFrame_SetLootUpgradeFrameAnchors", SkinLootUpgradePopUp)

	local function SkinGarrisonBuildingPopUp()
		local frame = _G["GarrisonBuildingAlertFrame"]

		if frame then
			frame:SetAlpha(1)
			frame.SetAlpha = F.Dummy

			if not frame.backdrop then
				frame:SetTemplate()
				frame.backdrop:SetPoint("TOPLEFT", frame, "TOPLEFT", 7, -6)
				frame.backdrop:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -10, 6)

				frame:HookScript("OnEnter", FixBg)
				frame:HookScript("OnShow", FixBg)
				frame.animIn:HookScript("OnFinished", FixBg)
			end

			-- Background
			frame:GetRegions():Hide()
			frame.glow:Kill()
			frame.shine:Kill()

			-- Icon
			frame.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

			-- Icon border
			if not frame.Icon.b then
				frame.Icon.b = CreateFrame("Frame", nil, frame)
				frame.Icon.b:SetFrameLevel(0)
				frame.Icon.b:CreateBD()
				frame.Icon.b:SetPoint("TOPLEFT", frame.Icon, "TOPLEFT", -2, 2)
				frame.Icon.b:SetPoint("BOTTOMRIGHT", frame.Icon, "BOTTOMRIGHT", 2, -2)
			end
		end
	end
	hooksecurefunc("AlertFrame_SetGarrisonBuildingAlertFrameAnchors", SkinGarrisonBuildingPopUp)

	local function SkinGarrisonMissionPopUp()
		local frame = _G["GarrisonMissionAlertFrame"]

		if frame then
			frame:SetAlpha(1)
			frame.SetAlpha = F.Dummy

			if not frame.backdrop then
				frame:SetTemplate()
				frame.backdrop:SetPoint("TOPLEFT", frame, "TOPLEFT", 7, -6)
				frame.backdrop:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -10, 6)

				frame:HookScript("OnEnter", FixBg)
				frame:HookScript("OnShow", FixBg)
				frame.animIn:HookScript("OnFinished", FixBg)
			end

			-- Background
			frame:GetRegions():Hide()
			frame.glow:Kill()
			frame.shine:Kill()

			-- Icon
			--frame.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

			-- Icon border
			-- if not frame.Icon.b then
				-- frame.Icon.b = CreateFrame("Frame", nil, frame)
				-- frame.Icon.b:SetFrameLevel(0)
				-- frame.Icon.b:CreateBD()
				-- frame.Icon.b:SetPoint("TOPLEFT", frame.Icon, "TOPLEFT", -2, 2)
				-- frame.Icon.b:SetPoint("BOTTOMRIGHT", frame.Icon, "BOTTOMRIGHT", 2, -2)
			-- end
		end
	end
	hooksecurefunc("AlertFrame_SetGarrisonMissionAlertFrameAnchors", SkinGarrisonMissionPopUp)

	local function SkinGarrisonFollowerPopUp()
		local frame = _G["GarrisonFollowerAlertFrame"]

		if frame then
			frame:SetAlpha(1)
			frame.SetAlpha = F.Dummy

			if not frame.backdrop then
				frame:SetTemplate()
				frame.backdrop:SetPoint("TOPLEFT", frame, "TOPLEFT", 7, -6)
				frame.backdrop:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -10, 6)

				frame:HookScript("OnEnter", FixBg)
				frame:HookScript("OnShow", FixBg)
				frame.animIn:HookScript("OnFinished", FixBg)
			end

			-- Background
			frame:GetRegions():Hide()
			frame.glow:Kill()
			frame.shine:Kill()

			-- Icon
			--frame.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

			-- Icon border
			-- if not frame.Icon.b then
				-- frame.Icon.b = CreateFrame("Frame", nil, frame)
				-- frame.Icon.b:SetFrameLevel(0)
				-- frame.Icon.b:CreateBD()
				-- frame.Icon.b:SetPoint("TOPLEFT", frame.Icon, "TOPLEFT", -2, 2)
				-- frame.Icon.b:SetPoint("BOTTOMRIGHT", frame.Icon, "BOTTOMRIGHT", 2, -2)
			-- end
		end
	end
	hooksecurefunc("AlertFrame_SetGarrisonFollowerAlertFrameAnchors", SkinGarrisonFollowerPopUp)
	
	hooksecurefunc("AlertFrame_SetAchievementAnchors", function(anchorFrame)
		for i = 1, MAX_ACHIEVEMENT_ALERTS do
			local frame = _G["AchievementAlertFrame"..i]
			
			if frame then
				frame:SetAlpha(1)
				if not frame.hooked then hooksecurefunc(frame, "SetAlpha", forceAlpha);frame.hooked = true end
				if not frame.backdrop then
					frame:SetTemplate()
					frame.backdrop:Point("TOPLEFT", _G[frame:GetName().."Background"], "TOPLEFT", -2, -6)
					frame.backdrop:Point("BOTTOMRIGHT", _G[frame:GetName().."Background"], "BOTTOMRIGHT", -2, 6)		
				end
				
				-- Background
				_G["AchievementAlertFrame"..i.."Background"]:SetTexture(nil)
				_G["AchievementAlertFrame"..i..'OldAchievement']:Kill()
				_G["AchievementAlertFrame"..i.."Glow"]:Kill()
				_G["AchievementAlertFrame"..i.."Shine"]:Kill()
				_G["AchievementAlertFrame"..i.."GuildBanner"]:Kill()
				_G["AchievementAlertFrame"..i.."GuildBorder"]:Kill()
				-- Text
				_G["AchievementAlertFrame"..i.."Unlocked"]:FontTemplate()
				_G["AchievementAlertFrame"..i.."Unlocked"]:SetShadowOffset(F.Mult or 1, -(F.Mult or 1))
				_G["AchievementAlertFrame"..i.."Unlocked"]:SetTextColor(1, 1, 1)
				_G["AchievementAlertFrame"..i.."Name"]:FontTemplate()
				_G["AchievementAlertFrame"..i.."Name"]:SetShadowOffset(F.Mult or 1, -(F.Mult or 1))

				-- Icon
				_G["AchievementAlertFrame"..i.."IconTexture"]:SetTexCoord(unpack(F.TexCoords))
				_G["AchievementAlertFrame"..i.."IconOverlay"]:Kill()
				
				_G["AchievementAlertFrame"..i.."IconTexture"]:ClearAllPoints()
				_G["AchievementAlertFrame"..i.."IconTexture"]:Point("LEFT", frame, 7, 0)
				
				if not _G["AchievementAlertFrame"..i.."IconTexture"].b then
					_G["AchievementAlertFrame"..i.."IconTexture"].b = CreateFrame("Frame", nil, _G["AchievementAlertFrame"..i])
					_G["AchievementAlertFrame"..i.."IconTexture"].b:CreateBD()
					_G["AchievementAlertFrame"..i.."IconTexture"].b:SetOutside(_G["AchievementAlertFrame"..i.."IconTexture"])
					_G["AchievementAlertFrame"..i.."IconTexture"]:SetParent(_G["AchievementAlertFrame"..i.."IconTexture"].b)
				end
			end
		end	
	end)

	hooksecurefunc("AlertFrame_SetDungeonCompletionAnchors", function(anchorFrame)
		for i = 1, DUNGEON_COMPLETION_MAX_REWARDS do
			local frame = _G["DungeonCompletionAlertFrame"..i]
			if frame then
				frame:SetAlpha(1)
				if not frame.hooked then hooksecurefunc(frame, "SetAlpha", forceAlpha);frame.hooked = true end
				if not frame.backdrop then
					frame:SetTemplate()
					frame.backdrop:Point("TOPLEFT", frame, "TOPLEFT", -2, -6)
					frame.backdrop:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 6)		
				end
				
				frame.shine:Kill()
				frame.glowFrame:Kill()
				frame.glowFrame.glow:Kill()
				
				frame.raidArt:Kill()
				frame.dungeonArt1:Kill()
				frame.dungeonArt2:Kill()
				frame.dungeonArt3:Kill()
				frame.dungeonArt4:Kill()
				frame.heroicIcon:Kill()
				
				-- Icon
				frame.dungeonTexture:SetTexCoord(unpack(F.TexCoords))
				frame.dungeonTexture:SetDrawLayer('OVERLAY')
				frame.dungeonTexture:ClearAllPoints()
				frame.dungeonTexture:Point("LEFT", frame, 7, 0)
				
				if not frame.dungeonTexture.b then
					frame.dungeonTexture.b = CreateFrame("Frame", nil, frame)
					frame.dungeonTexture.b:CreateBD()
					frame.dungeonTexture.b:SetOutside(frame.dungeonTexture)
					frame.dungeonTexture:SetParent(frame.dungeonTexture.b)
				end
			end
		end		
	end)
	
	hooksecurefunc("AlertFrame_SetGuildChallengeAnchors", function(anchorFrame)
		local frame = GuildChallengeAlertFrame

		if frame then
			frame:SetAlpha(1)
			if not frame.hooked then hooksecurefunc(frame, "SetAlpha", forceAlpha);frame.hooked = true end

			if not frame.backdrop then
				frame:SetTemplate()
				frame.backdrop:Point("TOPLEFT", frame, "TOPLEFT", -2, -6)
				frame.backdrop:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 6)
			end

			-- Background
			local region = select(2, frame:GetRegions())
			if region:GetObjectType() == "Texture" then
				if region:GetTexture() == "Interface\\GuildFrame\\GuildChallenges" then
					region:Kill()
				end
			end

			GuildChallengeAlertFrameGlow:Kill()
			GuildChallengeAlertFrameShine:Kill()
			GuildChallengeAlertFrameEmblemBorder:Kill()

			-- Icon border
			if not GuildChallengeAlertFrameEmblemIcon.b then
				GuildChallengeAlertFrameEmblemIcon.b = CreateFrame("Frame", nil, frame)
				GuildChallengeAlertFrameEmblemIcon.b:CreateBD()
				GuildChallengeAlertFrameEmblemIcon.b:Point("TOPLEFT", GuildChallengeAlertFrameEmblemIcon, "TOPLEFT", -3, 3)
				GuildChallengeAlertFrameEmblemIcon.b:Point("BOTTOMRIGHT", GuildChallengeAlertFrameEmblemIcon, "BOTTOMRIGHT", 3, -2)
				GuildChallengeAlertFrameEmblemIcon:SetParent(GuildChallengeAlertFrameEmblemIcon.b)
			end

			SetLargeGuildTabardTextures("player", GuildChallengeAlertFrameEmblemIcon, nil, nil)
		end	
	end)

	hooksecurefunc("AlertFrame_SetChallengeModeAnchors", function(anchorFrame)
		local frame = ChallengeModeAlertFrame1
		
		if frame then
			frame:SetAlpha(1)
			if not frame.hooked then hooksecurefunc(frame, "SetAlpha", forceAlpha);frame.hooked = true end

			if not frame.backdrop then
				frame:SetTemplate()
				frame.backdrop:Point("TOPLEFT", frame, "TOPLEFT", 19, -6)
				frame.backdrop:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -22, 6)
			end

			-- Background
			for i = 1, frame:GetNumRegions() do
				local region = select(i, frame:GetRegions())
				if region:GetObjectType() == "Texture" then
					if region:GetTexture() == "Interface\\Challenges\\challenges-main" then
						region:Kill()
					end
				end
			end

			ChallengeModeAlertFrame1Shine:Kill()
			ChallengeModeAlertFrame1GlowFrame:Kill()
			ChallengeModeAlertFrame1GlowFrame.glow:Kill()
			ChallengeModeAlertFrame1Border:Kill()

			-- Icon
			ChallengeModeAlertFrame1DungeonTexture:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			ChallengeModeAlertFrame1DungeonTexture:ClearAllPoints()
			ChallengeModeAlertFrame1DungeonTexture:Point("LEFT", frame.backdrop, 9, 0)

			-- Icon border
			if not ChallengeModeAlertFrame1DungeonTexture.b then
				ChallengeModeAlertFrame1DungeonTexture.b = CreateFrame("Frame", nil, frame)
				ChallengeModeAlertFrame1DungeonTexture.b:CreateBD()
				ChallengeModeAlertFrame1DungeonTexture.b:SetOutside(ChallengeModeAlertFrame1DungeonTexture)
				ChallengeModeAlertFrame1DungeonTexture:SetParent(ChallengeModeAlertFrame1DungeonTexture.b)
			end
		end	
	end)

	hooksecurefunc("AlertFrame_SetScenarioAnchors", function(anchorFrame)
		local frame = ScenarioAlertFrame1

		if frame then
			frame:SetAlpha(1)
			if not frame.hooked then hooksecurefunc(frame, "SetAlpha", forceAlpha);frame.hooked = true end

			if not frame.backdrop then
				frame:SetTemplate()
				frame.backdrop:Point("TOPLEFT", frame, "TOPLEFT", 4, 4)
				frame.backdrop:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -7, 6)
			end

			-- Background
			for i = 1, frame:GetNumRegions() do
				local region = select(i, frame:GetRegions())
				if region:GetObjectType() == "Texture" then
					if region:GetTexture() == "Interface\\Scenarios\\ScenariosParts" then
						region:Kill()
					end
				end
			end

			ScenarioAlertFrame1Shine:Kill()
			ScenarioAlertFrame1GlowFrame:Kill()
			ScenarioAlertFrame1GlowFrame.glow:Kill()

			-- Icon
			ScenarioAlertFrame1DungeonTexture:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			ScenarioAlertFrame1DungeonTexture:ClearAllPoints()
			ScenarioAlertFrame1DungeonTexture:Point("LEFT", frame.backdrop, 9, 0)

			-- Icon border
			if not ScenarioAlertFrame1DungeonTexture.b then
				ScenarioAlertFrame1DungeonTexture.b = CreateFrame("Frame", nil, frame)
				ScenarioAlertFrame1DungeonTexture.b:CreateBD()
				ScenarioAlertFrame1DungeonTexture.b:SetOutside(ScenarioAlertFrame1DungeonTexture)
				ScenarioAlertFrame1DungeonTexture:SetParent(ScenarioAlertFrame1DungeonTexture.b)
			end
		end
	end)

	hooksecurefunc('AlertFrame_SetCriteriaAnchors', function()
		for i = 1, MAX_ACHIEVEMENT_ALERTS do
			local frame = _G['CriteriaAlertFrame'..i]
			if frame then
				frame:SetAlpha(1)
				if not frame.hooked then hooksecurefunc(frame, "SetAlpha", forceAlpha);frame.hooked = true end

				if not frame.backdrop then
					frame:SetTemplate()
					frame.backdrop:Point("TOPLEFT", frame, "TOPLEFT", -2, -6)
					frame.backdrop:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 6)
				end
				
				_G['CriteriaAlertFrame'..i..'Unlocked']:SetTextColor(1, 1, 1)
				_G['CriteriaAlertFrame'..i..'Name']:SetTextColor(1, 1, 0)
				_G['CriteriaAlertFrame'..i..'Background']:Kill()
				_G['CriteriaAlertFrame'..i..'Glow']:Kill()
				_G['CriteriaAlertFrame'..i..'Shine']:Kill()
				_G['CriteriaAlertFrame'..i..'IconBling']:Kill()
				_G['CriteriaAlertFrame'..i..'IconOverlay']:Kill()
				
				-- Icon border
				if not _G['CriteriaAlertFrame'..i..'IconTexture'].b then
					_G['CriteriaAlertFrame'..i..'IconTexture'].b = CreateFrame("Frame", nil, frame)
					_G['CriteriaAlertFrame'..i..'IconTexture'].b:CreateBD()
					_G['CriteriaAlertFrame'..i..'IconTexture'].b:Point("TOPLEFT", _G['CriteriaAlertFrame'..i..'IconTexture'], "TOPLEFT", -3, 3)
					_G['CriteriaAlertFrame'..i..'IconTexture'].b:Point("BOTTOMRIGHT", _G['CriteriaAlertFrame'..i..'IconTexture'], "BOTTOMRIGHT", 3, -2)
					_G['CriteriaAlertFrame'..i..'IconTexture']:SetParent(_G['CriteriaAlertFrame'..i..'IconTexture'].b)
				end
				_G['CriteriaAlertFrame'..i..'IconTexture']:SetTexCoord(unpack(F.TexCoords))
			end	
		end
	end)
	
	hooksecurefunc('AlertFrame_SetLootWonAnchors', function()
		for i=1, #LOOT_WON_ALERT_FRAMES do
			local frame = LOOT_WON_ALERT_FRAMES[i];
			if frame then
				frame:SetAlpha(1)
				if not frame.hooked then hooksecurefunc(frame, "SetAlpha", forceAlpha);frame.hooked = true end
				
				frame.Background:Kill()
				frame.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
				frame.Icon:SetDrawLayer("BORDER")
				frame.IconBorder:Kill()
				frame.glow:Kill()
				frame.shine:Kill()
				if frame.SpecRing and frame.SpecIcon and frame.SpecIcon.GetTexture and frame.SpecIcon:GetTexture() == nil then frame.SpecRing:Hide() end
				
				-- Icon border
				if not frame.Icon.b then
					frame.Icon.b = CreateFrame("Frame", nil, frame)
					frame.Icon.b:CreateBD()
					frame.Icon.b:SetOutside(frame.Icon)
					frame.Icon:SetParent(frame.Icon.b)
				end
				
				if not frame.backdrop then
					frame:SetTemplate()
					frame.backdrop:SetPoint('TOPLEFT', frame.Icon.b, 'TOPLEFT', -4, 4)
					frame.backdrop:SetPoint('BOTTOMRIGHT', frame.Icon.b, 'BOTTOMRIGHT', 180, -4)
				end				
			end
		end	
	end)
	
	hooksecurefunc('AlertFrame_SetMoneyWonAnchors', function()
		for i=1, #MONEY_WON_ALERT_FRAMES do
			local frame = MONEY_WON_ALERT_FRAMES[i];
			if frame then
				frame:SetAlpha(1)
				if not frame.hooked then hooksecurefunc(frame, "SetAlpha", forceAlpha);frame.hooked = true end

				frame.Background:Kill()
				frame.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
				frame.IconBorder:Kill()
				
				-- Icon border
				if not frame.Icon.b then
					frame.Icon.b = CreateFrame("Frame", nil, frame)
					frame.Icon.b:CreateBD()
					frame.Icon.b:SetOutside(frame.Icon)
					frame.Icon:SetParent(frame.Icon.b)
				end
				
				if not frame.backdrop then
					frame:SetTemplate()
					frame.backdrop:SetPoint('TOPLEFT', frame.Icon.b, 'TOPLEFT', -4, 4)
					frame.backdrop:SetPoint('BOTTOMRIGHT', frame.Icon.b, 'BOTTOMRIGHT', 180, -4)
				end				
			end
		end	
	end)
	
	local frame = BonusRollMoneyWonFrame
	frame:SetAlpha(1)
	hooksecurefunc(frame, "SetAlpha", forceAlpha)

	frame.Background:Kill()
	frame.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	frame.IconBorder:Kill()
	
	-- Icon border
	frame.Icon.b = CreateFrame("Frame", nil, frame)
	frame.Icon.b:CreateBD()
	frame.Icon.b:SetOutside(frame.Icon)
	frame.Icon:SetParent(frame.Icon.b)

	frame:SetTemplate()
	frame.backdrop:SetPoint('TOPLEFT', frame.Icon.b, 'TOPLEFT', -4, 4)
	frame.backdrop:SetPoint('BOTTOMRIGHT', frame.Icon.b, 'BOTTOMRIGHT', 180, -4)
	
	local frame = BonusRollLootWonFrame
	frame:SetAlpha(1)
	hooksecurefunc(frame, "SetAlpha", forceAlpha)
	
	frame.Background:Kill()
	frame.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	frame.IconBorder:Kill()
	frame.glow:Kill()
	frame.shine:Kill()
	
	-- Icon border
	frame.Icon.b = CreateFrame("Frame", nil, frame)
	frame.Icon.b:CreateBD()
	frame.Icon.b:SetOutside(frame.Icon)
	frame.Icon:SetParent(frame.Icon.b)

	frame:SetTemplate()
	frame.backdrop:SetPoint('TOPLEFT', frame.Icon.b, 'TOPLEFT', -4, 4)
	frame.backdrop:SetPoint('BOTTOMRIGHT', frame.Icon.b, 'BOTTOMRIGHT', 180, -4)
	
end

tinsert(F.SkinFuncs['LanUI'], LoadSkin)