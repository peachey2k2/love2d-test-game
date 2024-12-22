local ui = require("ui")
local popups = require("popups")


local scenes = {}

scenes.mainMenu = { {
    type = ui.TYPE_BUTTON,
    x = 0.4,
    y = 0.5,
    w = 0.2,
    h = 0.07,
    text = "Play",
    theme = ui.ButtonThemes.positive,
    callback = function() ui.switchScene(scenes.classSelect) end,
}, {
    type = ui.TYPE_BUTTON,
    x = 0.4,
    y = 0.6,
    w = 0.2,
    h = 0.07,
    text = "Extras",
    theme = ui.ButtonThemes.normal,
    callback = function() ui.openPopup(popups.extras) end,
}, {
    type = ui.TYPE_BUTTON,
    x = 0.4,
    y = 0.7,
    w = 0.2,
    h = 0.07,
    text = "Options",
    theme = ui.ButtonThemes.normal,
    callback = function() ui.openPopup(popups.settings) end,
}, {
    type = ui.TYPE_BUTTON,
    x = 0.4,
    y = 0.8,
    w = 0.2,
    h = 0.07,
    text = "Quit",
    theme = ui.ButtonThemes.negative,
    callback = function() love.event.quit() end,
} }

return scenes
