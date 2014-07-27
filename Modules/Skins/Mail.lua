local F, C, G = unpack(select(2, ...))
local bc = C.Media.BorderColor

local function LoadSkin()
	MailFrame:StripTextures(true)
	MailFrame:SetTemplate()
	MailFrame:SetWidth(360)
	MailFrameCloseButton:SkinCloseButton()
	MailFrameInset:StripTextures()
	InboxFrame:StripTextures()

	for i = 1, INBOXITEMS_TO_DISPLAY do
		local bg = _G['MailItem'..i]
		bg:StripTextures()
		bg:CreateBD()
		bg.backdrop:Point('TOPLEFT', 2, 1)
		bg.backdrop:Point('BOTTOMRIGHT', -2, 2)
		
		local b = _G['MailItem'..i..'Button']
		b:StripTextures()
		b:CreateBD()
		b:StyleButton()

		local t = _G['MailItem'..i..'ButtonIcon']
		t:SetTexCoord(.08, .92, .08, .92)
		t:ClearAllPoints()
		t:Point('TOPLEFT', 2, -2)
		t:Point('BOTTOMRIGHT', -2, 2)
	end

	--InboxCloseButton:SkinCloseButton()
	InboxPrevPageButton:SkinNextPrevButton()
	InboxNextPageButton:SkinNextPrevButton()

	MailFrameTab1:StripTextures()
	MailFrameTab2:StripTextures()
	MailFrameTab1:SkinTab()
	MailFrameTab2:SkinTab()
	MailFrameTab2:Point('LEFT', MailFrameTab1, 'RIGHT', 4, 0)

	-- send mail
	SendMailScrollFrame:StripTextures(true)
	SendMailScrollFrame:SetTemplate()

	SendMailScrollFrameScrollBar:SkinScrollBar()

	SendMailNameEditBox:SkinEditBox()
	SendMailNameEditBox:SetHeight(20)
	SendMailSubjectEditBox:SkinEditBox()
	SendMailSubjectEditBox:ClearAllPoints()
	SendMailSubjectEditBox:SetPoint('TOPLEFT', SendMailNameEditBox, 'BOTTOMLEFT', 0, -8)
	SendMailMoneyGold:SkinEditBox()
	SendMailMoneySilver:SkinEditBox()
	SendMailMoneyCopper:SkinEditBox()
	SendMailMoneyBg:StripTextures()
	SendMailMoneyInset:StripTextures()
	SendMailFrame:StripTextures()

	local function MailFrameSkin()
		for i = 1, ATTACHMENTS_MAX_SEND do				
			local b = _G['SendMailAttachment'..i]
			if not b.skinned then
				b:StripTextures()
				b:SetTemplate()
				b:StyleButton()
				b.skinned = true
			end
			local t = b:GetNormalTexture()
			if t then
				t:SetTexCoord(.08, .92, .08, .92)
				t:ClearAllPoints()
				t:Point('TOPLEFT', 2, -2)
				t:Point('BOTTOMRIGHT', -2, 2)
			end
		end
	end
	hooksecurefunc('SendMailFrame_Update', MailFrameSkin)

	SendMailMailButton:SkinButton()
	SendMailCancelButton:SkinButton()

	-- open mail (cod)
	OpenMailFrame:StripTextures(true)
	OpenMailFrame:SetTemplate()
	OpenMailFrameInset:StripTextures()

	OpenMailFrameCloseButton:SkinCloseButton()
	OpenMailReportSpamButton:SkinButton()
	OpenMailReplyButton:SkinButton()
	OpenMailDeleteButton:SkinButton()
	OpenMailCancelButton:SkinButton()

	OpenMailScrollFrame:StripTextures(true)
	OpenMailScrollFrame:SetTemplate(true)

	OpenMailScrollFrameScrollBar:SkinScrollBar()

	SendMailBodyEditBox:SetTextColor(1, 1, 1)
	OpenMailBodyText:SetTextColor(1, 1, 1)
	InvoiceTextFontNormal:SetTextColor(1, 1, 1)
	OpenMailArithmeticLine:Kill()

	OpenMailLetterButton:StripTextures()
	OpenMailLetterButton:SetTemplate(true)
	OpenMailLetterButton:StyleButton()
	OpenMailLetterButtonIconTexture:SetTexCoord(.08, .92, .08, .92)						
	OpenMailLetterButtonIconTexture:ClearAllPoints()
	OpenMailLetterButtonIconTexture:Point('TOPLEFT', 2, -2)
	OpenMailLetterButtonIconTexture:Point('BOTTOMRIGHT', -2, 2)

	OpenMailMoneyButton:StripTextures()
	OpenMailMoneyButton:SetTemplate(true)
	OpenMailMoneyButton:StyleButton()
	OpenMailMoneyButtonIconTexture:SetTexCoord(.08, .92, .08, .92)						
	OpenMailMoneyButtonIconTexture:ClearAllPoints()
	OpenMailMoneyButtonIconTexture:Point('TOPLEFT', 2, -2)
	OpenMailMoneyButtonIconTexture:Point('BOTTOMRIGHT', -2, 2)

	for i = 1, ATTACHMENTS_MAX_SEND do				
		local b = _G['OpenMailAttachmentButton'..i]
		b:StripTextures()
		b:SetTemplate(true)
		b:StyleButton()
		
		local t = _G['OpenMailAttachmentButton'..i..'IconTexture']
		if t then
			t:SetTexCoord(.08, .92, .08, .92)
			t:ClearAllPoints()
			t:Point('TOPLEFT', 2, -2)
			t:Point('BOTTOMRIGHT', -2, 2)
		end				
	end

	OpenMailReplyButton:Point('RIGHT', OpenMailDeleteButton, 'LEFT', -2, 0)
	OpenMailDeleteButton:Point('RIGHT', OpenMailCancelButton, 'LEFT', -2, 0)
	SendMailMailButton:Point('RIGHT', SendMailCancelButton, 'LEFT', -2, 0)
end

tinsert(F.SkinFuncs['LanUI'], LoadSkin)