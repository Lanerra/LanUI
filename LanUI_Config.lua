LanConfig = {
    FirstTime = false, -- How sweet! Fresh meat!
    
    Media = {
        Font = [[Interface\Addons\LanUI\Media\Expressway.ttf]], -- Default font
        FontSize = 15,
        StatusBar = [[Interface\Addons\LanUI\Media\StatusBar]], -- Default statusbar
        BuffBorder = [[Interface\Addons\LanUI\Media\textureNormal]], -- Buff border texture
        DebuffBorder = [[Interface\Addons\LanUI\Media\textureDebuff]], -- Debuff border texture
        OverlayBorder = [[Interface\Addons\LanUI\Media\textureOverlay]], -- Overlay border for other elements
        Backdrop = [[Interface\BUTTONS\WHITE8X8]], -- Background texture for panels/skinning
        BackdropColor = {0, 0, 0, 0.75}, -- Background color for panels/skinning
    },
    Panels = {
        ABPanel = true, -- Panel for action bars
        BP = true, -- Bottom Panel
        BPClass = false, -- Class color the Bottom Panel
        TP = false, -- Top Panel
        TPClass = false, -- Class color the Top Panel
    },
    Tooltip = {
        TTMouse = false, -- Tooltip on mouse
        ShowCoins = true, -- Display coins instead of 'gold, silver, copper'
    },
    Tweaks = {
        LanNames = true, -- Personal settings for name display
        LanNameplates = true, -- Personal settings for nameplate display
        Sticky = true, -- Sticky targetting
        RepairSell = true, -- Automatically sell grey items, repair damage
        AutoDEGreed = false, -- Automatically disenchant or greed on Bind on Pickup items above a certain ilvl
        StatsFrame = false, -- Show or hide StatsFrame
    },
    Chat = {
        ChatSetup = true, -- Automatically configure chat frames
        NoChatFade = true, -- Prevent chat frame/tabs from fading
    },
    Buff = {
        BuffSize = 36, -- Size of buffs
        BuffScale = 1, -- Scale of buffs
        BuffPerRow = 13, -- Buffs per row
        BuffSpacingY = 7, -- Vertical spacing
        BuffSpacingX = 7, -- Horizontal spacing
    },
    FontSize = {
        BuffDuration = 16, -- Duration size
        BuffCount = 17, -- Count size
        Stat = 15, -- Stat font size
        Time = 18, -- Minimap time font size
        Calendar = 18, -- Minimap calendar font size
        Tracking = 18, -- Minimap tracking font size
        OmniCC = 16, -- OmniCC font size
    },
    Buffs = {
        Size = 36,
        Scale = 1,
        PerRow = 9,
        BorderColor = { 1, 1, 1 },
        DurationSize = 16,
        CountSize = 17,
        PadX = 7,
        PadY = 7,
    },
    ActionBars = {
        ButtonSize = 27,
        ButtonSpacing = 4,
    },
}