local F, C, G = unpack(select(2, ...))

local Mult = 768/string.match(F.Resolution, '%d+x(%d+)')/F.TrueScale
local Scale = function(x)
	return Mult*math.floor(x/Mult+.5)
end

C['FirstTime'] = false -- How sweet! Fresh meat!

C['Media'] = {
    ['Font'] = [[Interface\Addons\LanUI\Media\Expressway.ttf]], -- Default font
    ['SCTFont'] = [[Interface\Addons\LanUI\Media\HOOGE.ttf]], -- Scrolling Combat Text Font
    ['FontSize'] = 15, -- Default font size
    ['StatusBar'] = [[Interface\Addons\LanUI\Media\StatusBar]], -- Default statusbar
    ['BuffBorder'] = [[Interface\Addons\LanUI\Media\textureNormal]], -- Buff border texture
    ['DebuffBorder'] = [[Interface\Addons\LanUI\Media\textureDebuff]], -- Debuff border texture
    ['OverlayBorder'] = [[Interface\Addons\LanUI\Media\textureOverlay]], -- Overlay border for other elements
    ['Backdrop'] = [[Interface\BUTTONS\WHITE8X8]], -- Background texture for panels/skinning
    ['Glow'] = [[Interface\AddOns\LanUI\Media\glowTex]], -- Texture used for glows
    ['BackdropColor'] = {0, 0, 0, 0.5}, -- Background color for panels/skinning
    ['BorderColor'] = {1, 1, 1}, -- Border color
    ['BorderSize'] = 12, -- Border size
    ['ClassColor'] = true, -- Class color our borders?
}

C['ActionBars'] = {
    ['Hotkey'] = false, -- Show button hotkeys
    ['Macro'] = false, -- Show name of macros
    ['ButtonSize'] = 27, -- Size of buttons
    ['PetButtonSize'] = 29, -- Size of pet and stance buttons
    ['ButtonSpacing'] = 4, -- Spacing between buttons
}

C['Bags'] = {
    ['SlotSize'] = 32,
    ['SlotSpacing'] = 4,
    ['BankColumns'] = 17,
    ['BagColumns'] = 10,
}

C['Minimap'] = {
    ['Tab'] = {
        ['Show'] = true,
        ['ShowAlways'] = false,
        ['AlphaMouseover'] = 1,
        ['AlphaNoMouseover'] = 0.5,
        ['ShowBelowMinimap'] = true,
    },
    ['Mouseover'] = {
        ['ZoneText'] = true,
        ['InstanceDifficulty'] = false,
    },
}

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
    ['AutoDEGreed'] = true, -- Automatically disenchant or greed on Bind on Pickup items above a certain ilvl
    ['StatsFrame'] = false, -- Show or hide StatsFrame
    ['AutoScale'] = true,
    ['UIScale'] = 0.625,
    ['PowerLevel'] = false,
}

C['Chat'] = {
    ['ChatHeight'] = 200, -- ChatFrame Height
    ['ChatSetup'] = true, -- Automatically configure chat frames
    ['CombatMinimize'] = true, -- Reduce ChatFrame height when in comabt
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

C['UF'] = {
    Show = {
        CastBars = true,
        Focus = true,
        ToT = true,
        Party = true,
        Raid = true,
        HealerOverride = true, -- Forces display of predictive healing (incoming heals)
        ClassColorHealth = false
    },
    Media = {
        FontSize = 15,
        BorderSize = 12,
        BorderColor = { 1, 1, 1 },
        BackdropColor = { 0, 0, 0, 0.5 },
        BorderPadding = 4
    },
    Units = {
        Player = {
            Height = Scale(30),
            Width = Scale(200),
            Position = {'CENTER', UIParent, Scale(-325), Scale(-175)},
            Health = {
                Percent = false,
                Deficit = false,
                Current = true,
            },
            ShowPowerText = true,
            ShowBuffs = false,
        },
        Pet = {
            Height = Scale(30),
            Width = Scale(80),
            Position = {'CENTER', UIParent, Scale(-485), Scale(-175)},
            Health = {
                Percent = false,
                Deficit = false,
                Current = false,
            },
        },
        Target = {
            Height = Scale(30),
            Width = Scale(200),
            Position = {'CENTER', UIParent, Scale(325), Scale(-175)},
            Health = {
                Percent = true,
                Deficit = false,
                Current = false,
                PerCur = false,
            },
            ShowPowerText = true,
            ShowBuffs = true,
        },
        ToT = {
            Height = Scale(30),
            Width = Scale(80),
            Position = {'CENTER', UIParent, Scale(485), Scale(-175)},
            Health = {
                Percent = false,
                Deficit = false,
                Current = false,
            },
        },
        Focus = {
            Height = Scale(30),
            Width = Scale(30),
            Position = {'CENTER', UIParent, 0, Scale(-175)},
            Health = {
                Percent = false,
                Deficit = false,
                Current = false,
            },
            VerticalHealth = true,
        },
        Party = {
            Height = Scale(20),
            Width = Scale(100),
            Position = {'TOPLEFT', UIParent, Scale(25), Scale(-25)},
            Health = {
                Percent = true,
                Deficit = false,
                Current = false,
                ClassColor = true,
            },
            HidePower = true, -- Reserved for future use
            Healer = false, -- Center frames in the UI and adjust size for better visibility?
            ShowBuffs = false,
        },
        Raid = {
            Height = Scale(18),
            Width = Scale(100),
            Position = {'TOPLEFT', UIParent, Scale(25), Scale(-25)},
            Health = {
                Percent = false,
                Deficit = true,
                Current = false,
                ClassColor = true,
            },
            HidePower = true, -- Reserved for future use
            Healer = false, -- Center frames in the UI and adjust size for better visibility?
        },
    },
    CastBars = {
        Player = {
            Show = true,
            Height = Scale(25),
            Width = Scale(200),
            Scale = 1,
            Position = {'CENTER', UIParent, Scale(-325), Scale(-232)},
            ClassColor = false,
            SafeZone = true,
            Latency = false,
            Color = {.25, .25, .25},
        },
        Target = {
            Show = true,
            Height = Scale(25),
            Width = Scale(200),
            Scale = 1,
            Position = {'CENTER', UIParent, Scale(325), Scale(-232)},
            ClassColor = false,
            Color = {.25, .25, .25},
            InterruptHighlight = true,
            InterruptColor = {1, 0, 1},
        },
    },
}

-- NO TOUCHY! -----------------------------------------------------------
if C.Media.ClassColor then
    C.Media.BorderColor = F.PlayerColor
else
    C.Media.BorderColor.r, C.Media.BorderColor.g, C.Media.BorderColor.b = C.Media.BorderColor[1], C.Media.BorderColor[2], C.Media.BorderColor[3]
end
-------------------------------------------------------------------------