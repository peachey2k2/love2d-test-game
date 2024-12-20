local ui = require("ui")

local scenes = {}

scenes.mainMenu = { {
    type = ui.TYPE_BUTTON,
    x = 0.25,
    y = 0.8,
    w = 0.2,
    h = 0.1,
    text = "Chess Battle Advanced",
    theme = ui.ButtonThemes.negative,
    callback = function() print("button 1 pressed") end,
}, {
    type = ui.TYPE_BUTTON,
    x = 0.55,
    y = 0.8,
    w = 0.2,
    h = 0.1,
    text = "Chess Battle Advanced",
    theme = ui.ButtonThemes.normal,
    callback = function() print("button 2 pressed") end,
} }

return scenes
