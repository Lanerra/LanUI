local F, C, G = unpack(select(2, ...))
local bc = C.Media.BorderColor

local function LoadSkin()
	MailFrame:StripTextures(true)
	MailFrame:SetTemplate("Transparent")
	--MailFrame:SetWidth(360)

	for i = 1, INBOXITEMS_TO_DISPLAY do
		local bg = _G["MailItem"..i]
		bg:StripTextures()
		bg:CreateBackdrop("Default")
		bg.backdrop:Point("TOPLEFT", 2, 1)
		bg.backdrop:Point("BOTTOMRIGHT", -2, 2)

		local b = _G["MailItem"..i.."Button"]
		b:StripTextures()
		b:SetTemplate("Default", true)
		b:StyleButton()

		local t = _G["MailItem"..i.."ButtonIcon"]
		t:SetTexCoord(unpack(F.TexCoords))
		t:SetInside()
	end

	HandleCloseButton(MailFrameCloseButton)
	HandleNextPrevButton(InboxPrevPageButton)
	HandleNextPrevButton(InboxNextPageButton)

	MailFrameTab1:StripTextures()
	MailFrameTab2:StripTextures()
	HandleTab(MailFrameTab1)
	HandleTab(MailFrameTab2)

	-- send mail
	SendMailScrollFrame:StripTextures(true)
	SendMailScrollFrame:SetTemplate("Default")

	HandleScrollBar(SendMailScrollFrameScrollBar)

	HandleEditBox(SendMailNameEditBox)
	HandleEditBox(SendMailSubjectEditBox)
	HandleEditBox(SendMailMoneyGold)
	HandleEditBox(SendMailMoneySilver)
	HandleEditBox(SendMailMoneyCopper)
	SendMailMoneyBg:Kill()
	SendMailMoneyInset:StripTextures()
	SendMailNameEditBox.backdrop:Point("BOTTOMRIGHT", 2, 4)
	SendMailSubjectEditBox.backdrop:Point("BOTTOMRIGHT", 2, 0)
	SendMailFrame:StripTextures()

	local function MailFrameSkin()
		for i = 1, ATTACHMENTS_MAX_SEND do
			local b = _G["SendMailAttachment"..i]
			if not b.skinned then
				b:StripTextures()
				b:SetTemplate("Default", true)
				b:StyleButton()
				b.skinned = true
			end
			local t = b:GetNormalTexture()
			if t then
				t:SetTexCoord(unpack(F.TexCoords))
				t:SetInside()
			end
		end
	end
	hooksecurefunc("SendMailFrame_Update", MailFrameSkin)

	HandleButton(SendMailMailButton)
	HandleButton(SendMailCancelButton)

	-- open mail (cod)
	OpenMailFrame:StripTextures(true)
	OpenMailFrame:SetTemplate("Transparent")
	OpenMailFrameInset:Kill()

	HandleCloseButton(OpenMailFrameCloseButton)
	HandleButton(OpenMailReportSpamButton)
	HandleButton(OpenMailReplyButton)
	HandleButton(OpenMailDeleteButton)
	HandleButton(OpenMailCancelButton)

	InboxFrame:StripTextures()
	MailFrameInset:Kill()

	OpenMailScrollFrame:StripTextures(true)
	OpenMailScrollFrame:SetTemplate("Default")

	HandleScrollBar(OpenMailScrollFrameScrollBar)

	SendMailBodyEditBox:SetTextColor(1, 1, 1)
	OpenMailBodyText:SetTextColor(1, 1, 1)
	InvoiceTextFontNormal:SetTextColor(1, 1, 1)
	OpenMailArithmeticLine:Kill()

	OpenMailLetterButton:StripTextures()
	OpenMailLetterButton:SetTemplate("Default", true)
	OpenMailLetterButton:StyleButton()
	OpenMailLetterButtonIconTexture:SetTexCoord(unpack(F.TexCoords))
	OpenMailLetterButtonIconTexture:SetInside()

	OpenMailMoneyButton:StripTextures()
	OpenMailMoneyButton:SetTemplate("Default", true)
	OpenMailMoneyButton:StyleButton()
	OpenMailMoneyButtonIconTexture:SetTexCoord(unpack(F.TexCoords))
	OpenMailMoneyButtonIconTexture:SetInside()

	for i = 1, ATTACHMENTS_MAX_SEND do
		local b = _G["OpenMailAttachmentButton"..i]
		b:StripTextures()
		b:SetTemplate("Default", true)
		b:StyleButton()

		local t = _G["OpenMailAttachmentButton"..i.."IconTexture"]
		if t then
			t:SetTexCoord(unpack(F.TexCoords))
			t:SetInside()
		end
	end

	OpenMailReplyButton:Point("RIGHT", OpenMailDeleteButton, "LEFT", -2, 0)
	OpenMailDeleteButton:Point("RIGHT", OpenMailCancelButton, "LEFT", -2, 0)
	SendMailMailButton:Point("RIGHT", SendMailCancelButton, "LEFT", -2, 0)
end

tinsert(F.SkinFuncs['LanUI'], LoadSkin)