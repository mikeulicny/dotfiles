-- Monitors
hl.monitor({
    output = "DP-3",
    mode = "preferred",
    position = "auto",
    scale = 1
})

-- Autostart
hl.on("hyprland.start", function()
    hl.exec_cmd("ashell")
    hl.exec_cmd("mako")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("vicinae server")
end)

-- Environment Variables
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- Look and Feel
hl.config({
    general = {
        gaps_in     = 5,
        gaps_out    = 10,
        border_size = 2,
        col = {
            active_border   = "rgba(ffffff55)",
            inactive_border = "rgba(ffffff26)",
        },
        resize_on_border = false,
        allow_tearing    = false,
        layout           = "dwindle",

    },

    decoration = {
        rounding       = 12,
        rounding_power = 2,

        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = "rgba(1a1a1aee)",
        },

        blur = {
            enabled = true,
            size    = 10,
            passes  = 3,
            vibrancy = 0.1696,
            new_optimizations = true,
            xray = true,
        },
    },
})

hl.curve( "apple", { type = "bezier", points = { {0.42, 0.0}, {0.58, 1.0} } })

hl.animation({
    leaf = "global",
    enabled = true,
    speed = 0.35,
    bezier = "apple",
})


hl.config({
    master = {
        new_status = "master",
    }
})

hl.config({
    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        focus_on_activate = true,
    },
})


-- Input
hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",
        repeat_delay = 250,
        repeat_rate = 60,

        follow_mouse = 1,

        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

        touchpad = {
            natural_scroll = false,
        },
    },
})

require "bindings"
require "rules"
