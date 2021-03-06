local F, C, G = unpack(select(2, ...))

local Hider = LanUIHider

for _, frame in pairs({
	'MainMenuBarPageNumber',
	'ActionBarDownButton',
	'ActionBarUpButton',
	'OverrideActionBarExpBar',
	'OverrideActionBarHealthBar',
	'OverrideActionBarPowerBar',
	'OverrideActionBarPitchFrame',
	'OverrideActionBarLeaveFrame',
	'CharacterMicroButton',
	'SpellbookMicroButton',
	'TalentMicroButton',
	'AchievementMicroButton',
	'QuestLogMicroButton',
	'GuildMicroButton',
	'LFDMicroButton',
	'CollectionsMicroButton',
	'EJMicroButton',
	'StoreMicroButton',
	'MainMenuMicroButton',
	'HelpMicroButton',
	'MainMenuBarBackpackButton',
	'CharacterBag0Slot',
	'CharacterBag1Slot',
	'CharacterBag2Slot',
	'CharacterBag3Slot',
	'StanceBarFrame',
	'MainMenuBar',
}) do
	_G[frame]:SetParent(Hider)
	_G[frame].SetParent = F.Dummy
end

for _, texture in pairs({
	'StanceBarLeft',
	'StanceBarMiddle',
	'StanceBarRight',
	'SlidingActionBarTexture0',
	'SlidingActionBarTexture1',
	'PossessBackground1',
	'PossessBackground2',
	'MainMenuBarTexture0',
	'MainMenuBarTexture1',
	'MainMenuBarTexture2',
	'MainMenuBarTexture3',
	'MainMenuBarLeftEndCap',
	'MainMenuBarRightEndCap',
}) do
	_G[texture]:SetTexture(nil)
end

for _, texture in pairs({
	'_BG',
	'EndCapL',
	'EndCapR',
	'_Border',
	'Divider1',
	'Divider2',
	'Divider3',
	'ExitBG',
	'MicroBGL',
	'MicroBGR',
	'_MicroBGMid',
	'ButtonBGL',
	'ButtonBGR',
	'_ButtonBGMid',
}) do
	OverrideActionBar[texture]:Kill()
end