hl.layer_rule({
    name = "vicinae-blur",
    match = { namespace = "vicinae" },
    blur = true,
    ignore_alpha = 0
})

hl.layer_rule({
    name = "vicinae-no-animation",
    match = { class = "vicinae" },
    no_anim = true
})

hl.window_rule({
    name = "1Password-float",
    match = { class = "1Password" },
    float = true,
    center = true
})

hl.window_rule({
    name = "files-float",
    match = { class = "org.gnome.Nautilus" },
    float = true,
    center = true
})

hl.window_rule({
    name = "float-file-pickers",
    match = { title = "Open.*Files?|Save.*Files?|Open.*Folders?|All Files|Save" },
    float = true,
    center = true
})
