local F, C, G = unpack(select(2, ...))
local bc = C.Media.BorderColor

local function LoadSkin()
	ArchaeologyFrame:StripTextures()
	ArchaeologyFrameInset:StripTextures()
	ArchaeologyFrame:CreateBackdrop("Transparent")
	ArchaeologyFrame.backdrop:SetAllPoints()
	ArchaeologyFrame.portrait:SetAlpha(0)
	ArchaeologyFrameInset:CreateBackdrop('Default')
	ArchaeologyFrameInset.backdrop:SetPoint('TOPLEFT')
	ArchaeologyFrameInset.backdrop:SetPoint('BOTTOMRIGHT', -3, -1)

	HandleButton(ArchaeologyFrameArtifactPageSolveFrameSolveButton, true)
	HandleButton(ArchaeologyFrameArtifactPageBackButton, true)
	ArchaeologyFrameRaceFilter:SetFrameLevel(ArchaeologyFrameRaceFilter:GetFrameLevel() + 2)
	HandleDropDownBox(ArchaeologyFrameRaceFilter, 125)

	HandleButton(ArchaeologyFrameSummaryPagePrevPageButton)
	HandleButton(ArchaeologyFrameSummaryPageNextPageButton)
	HandleButton(ArchaeologyFrameCompletedPageNextPageButton)
	HandleButton(ArchaeologyFrameCompletedPagePrevPageButton)

	ArchaeologyFrameRankBar:StripTextures()
	ArchaeologyFrameRankBar:SetStatusBarTexture(C.Media.StatusBar)
	ArchaeologyFrameRankBar:SetFrameLevel(ArchaeologyFrameRankBar:GetFrameLevel() + 2)
	ArchaeologyFrameRankBar:CreateBackdrop("Default")

	ArchaeologyFrameArtifactPageSolveFrameStatusBar:StripTextures()
	ArchaeologyFrameArtifactPageSolveFrameStatusBar:SetStatusBarTexture(C.Media.StatusBar)
	ArchaeologyFrameArtifactPageSolveFrameStatusBar:SetStatusBarColor(0.7, 0.2, 0)
	ArchaeologyFrameArtifactPageSolveFrameStatusBar:SetFrameLevel(ArchaeologyFrameArtifactPageSolveFrameStatusBar:GetFrameLevel() + 2)
	ArchaeologyFrameArtifactPageSolveFrameStatusBar:CreateBackdrop("Default")

	for i=1, ARCHAEOLOGY_MAX_COMPLETED_SHOWN do
		local artifact = _G["ArchaeologyFrameCompletedPageArtifact"..i]

		if artifact then
			_G["ArchaeologyFrameCompletedPageArtifact"..i.."Border"]:Kill()
			_G["ArchaeologyFrameCompletedPageArtifact"..i.."Bg"]:Kill()
			_G["ArchaeologyFrameCompletedPageArtifact"..i.."Icon"]:SetTexCoord(unpack(F.TexCoords))
			_G["ArchaeologyFrameCompletedPageArtifact"..i.."Icon"].backdrop = CreateFrame("Frame", nil, artifact)
			_G["ArchaeologyFrameCompletedPageArtifact"..i.."Icon"].backdrop:SetTemplate("Default")
			_G["ArchaeologyFrameCompletedPageArtifact"..i.."Icon"].backdrop:SetOutside(_G["ArchaeologyFrameCompletedPageArtifact"..i.."Icon"])
			_G["ArchaeologyFrameCompletedPageArtifact"..i.."Icon"].backdrop:SetFrameLevel(artifact:GetFrameLevel() - 2)
			_G["ArchaeologyFrameCompletedPageArtifact"..i.."Icon"]:SetDrawLayer("OVERLAY")
		end
	end

	ArchaeologyFrameArtifactPageIcon:SetTexCoord(unpack(F.TexCoords))
	ArchaeologyFrameArtifactPageIcon.backdrop = CreateFrame("Frame", nil, ArchaeologyFrameArtifactPage)
	ArchaeologyFrameArtifactPageIcon.backdrop:SetTemplate("Default")
	ArchaeologyFrameArtifactPageIcon.backdrop:SetOutside(ArchaeologyFrameArtifactPageIcon)
	ArchaeologyFrameArtifactPageIcon.backdrop:SetFrameLevel(ArchaeologyFrameArtifactPage:GetFrameLevel())
	ArchaeologyFrameArtifactPageIcon:SetParent(ArchaeologyFrameArtifactPageIcon.backdrop)
	ArchaeologyFrameArtifactPageIcon:SetDrawLayer("OVERLAY")

	HandleCloseButton(ArchaeologyFrameCloseButton)

	ArcheologyDigsiteProgressBar:StripTextures()
	ArcheologyDigsiteProgressBar.FillBar:StripTextures()
	ArcheologyDigsiteProgressBar.FillBar:SetStatusBarTexture(C.Media.StatusBar)
	ArcheologyDigsiteProgressBar.FillBar:SetStatusBarColor(0.7, 0.2, 0)
	ArcheologyDigsiteProgressBar.FillBar:SetFrameLevel(ArchaeologyFrameArtifactPageSolveFrameStatusBar:GetFrameLevel() + 2)
	ArcheologyDigsiteProgressBar.FillBar:CreateBackdrop("Default")
	ArcheologyDigsiteProgressBar.BarTitle:FontTemplate(nil, nil, 'OUTLINE')
	ArcheologyDigsiteProgressBar:ClearAllPoints()
	ArcheologyDigsiteProgressBar:SetPoint("TOP", UIParent, "TOP", 0, -400)
end

F.SkinFuncs['Blizzard_ArchaeologyUI'] = LoadSkin