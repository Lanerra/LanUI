local F, C, G = unpack(select(2, ...))

C['FirstTime'] = false -- How sweet! Fresh meat!

C['ActionBars'] = {
    ['Enabled'] = true, -- Option to enable or disable our own action bar implementation
    ['Hotkey'] = false, -- Show button hotkeys
    ['Macro'] = false, -- Show name of macros
    ['HideShapeshift'] = false, -- Hide shapeshift/totembar
    ['ButtonSize'] = 27, -- Size of buttons
    ['PetButtonSize'] = 29, -- Size of pet and stance buttons
    ['ButtonSpacing'] = 4, -- Spacing between buttons
    ['OwnShadow'] = false, -- Use separate bar for Shadow Dance (Rogue Only)
    ['OwnMeta'] = true, -- Use separate bar for Metamorphosis (Warlock Only)
    ['OwnStance'] = false, -- Use separate bar for each Warrior Stance (Warrior Only)
    ['Bar2'] = true, -- Need a second bar?
    ['Bar3'] = false, -- How about a third?
    ['Bar4'] = false, -- A fourth?
    ['Bar5'] = false, -- I think you get the picture by now
    ['Bar6'] = false,
    ['Bar7'] = false,
}    

C['Minimap'] = {
    ['tab'] = {
        ['show'] = true,
        ['showAlways'] = false,
        ['alphaMouseover'] = 1,
        ['alphaNoMouseover'] = 0.5,
        ['showBelowMinimap'] = true,
    },
    ['mouseover'] = {
        ['zoneText'] = true,
        ['instanceDifficulty'] = false,
    },
}

C['Media'] = {
    ['Font'] = [[Interface\Addons\LanUI\Media\Expressway.ttf]], -- Default font
    ['FontSize'] = 15, -- Default font size
    ['StatusBar'] = [[Interface\Addons\LanUI\Media\StatusBar]], -- Default statusbar
    ['BuffBorder'] = [[Interface\Addons\LanUI\Media\textureNormal]], -- Buff border texture
    ['DebuffBorder'] = [[Interface\Addons\LanUI\Media\textureDebuff]], -- Debuff border texture
    ['OverlayBorder'] = [[Interface\Addons\LanUI\Media\textureOverlay]], -- Overlay border for other elements
    ['Backdrop'] = [[Interface\BUTTONS\WHITE8X8]], -- Background texture for panels/skinning
    ['BackdropColor'] = {0, 0, 0, 0.5}, -- Background color for panels/skinning
    ['BorderColor'] = {1, 1, 1}, -- Border color
    ['BorderSize'] = 12, -- Border size
    ['ClassColor'] = true, -- Class color our borders?
}

-- NO TOUCHY!
if C.Media.ClassColor == true then
    C.Media.BorderColor = F.PlayerColor
end

C['Panels'] = {
    ['ABPanel'] = true, -- Panel for action bars
    ['BP'] = true, -- Bottom Panel
    ['BPClass'] = false, -- Class color the Bottom Panel
    ['TP'] = false, -- Top Panel
    ['TPClass'] = false, -- Class color the Top Panel
}

C['Tooltip'] = {
    ['TTMouse'] = false, -- Tooltip on mouse
    ['ShowCoins'] = true, -- Display coins instead of 'gold, silver, copper'
}

C['Tweaks'] = {
    ['LanNames'] = true, -- Personal settings for name display
    ['LanNameplates'] = true, -- Personal settings for nameplate display
    ['Sticky'] = true, -- Sticky targetting
    ['RepairSell'] = true, -- Automatically sell grey items, repair damage
    ['AutoDEGreed'] = false, -- Automatically disenchant or greed on Bind on Pickup items above a certain ilvl
    ['StatsFrame'] = false, -- Show or hide StatsFrame
    ['UIScale'] = 0.625,
}

C['Chat'] = {
    ['ChatSetup'] = true, -- Automatically configure chat frames
    ['NoChatFade'] = true, -- Prevent chat frame/tabs from fading
}

C['Buffs'] = {
    ['Size'] = 36, -- Size of buffs
    ['Scale'] = 1, -- Scale of buffs
    ['PerRow'] = 9, -- Buffs per row
    ['BorderColor'] = { 1, 1, 1 }, -- Default buff border color
    ['DurationSize'] = 16, -- Duration text size
    ['CountSize'] = 17, -- Count text size
    ['PadX'] = 7, -- Horizontal spacing
    ['PadY'] = 7, -- Vertical spacing
}