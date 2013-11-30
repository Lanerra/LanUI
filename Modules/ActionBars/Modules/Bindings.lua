local F, C, G = unpack(select(2, ...))

local actionButtons = G.ActionBars.ActionButtons

local gsub = string.gsub
local function CleanKey(key)
	if(key) then
		key = string.upper(key)
		key = gsub(key, ' ', '')
		key = gsub(key, '%-', '')
		key = gsub(key, 'MOUSEBUTTON', 'B')
		key = gsub(key, 'MIDDLEMOUSE', 'MM')

		return key
	end
end

local Handler = CreateFrame('Frame')
Handler:RegisterEvent('UPDATE_BINDINGS')
Handler:SetScript('OnEvent', function()
	for _, button in pairs(actionButtons) do
		for index = 1, NUM_ACTIONBAR_BUTTONS do
			if(_G[button .. index]) then
				local Hotkey = _G[button .. index .. 'HotKey']
				if(Hotkey) then
					Hotkey:SetText(CleanKey(Hotkey:GetText()) or '')
				end
			end
		end
	end
end)
