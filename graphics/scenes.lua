local ui = require("graphics/ui")
local popups = require("graphics/popups")
local items = require("objects/items")


local scenes = {}

scenes.mainMenu = { {
    type = ui.TYPE_TEXT,
    x = 0.5,
    y = 0.1,
    w = 0.0,
    h = 0.0,
    text = "Sample Text",
    theme = ui.TextThemes.light,
}, {
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

scenes.classSelect = { {
    type = ui.TYPE_TEXT,
    x = 0.5,
    y = 0.1,
    w = 0.0,
    h = 0.0,
    text = "Select a Class",
    theme = ui.TextThemes.light,
}, {
    type = ui.TYPE_BUTTON,
    x = 0.4,
    y = 0.5,
    w = 0.2,
    h = 0.07,
    text = "Warrior",
    theme = ui.ButtonThemes.normal,
    callback = function() ui.switchScene(scenes.game) end,
    tooltip = {
        title = "Warrior",
        text =
        "A strong and sturdy class, the warrior is capable of taking a lot of damage and dealing a lot of damage. Starts with a {} and a {}. Testing custom interpolation -> {} <- here!!",
        attribs = { items.Sword, items.Shield, "chess battle advanced" },
        footnote = nil,
    },
}, {
    type = ui.TYPE_BUTTON,
    x = 0.4,
    y = 0.6,
    w = 0.2,
    h = 0.07,
    text = "Mage",
    theme = ui.ButtonThemes.normal,
    callback = function() ui.switchScene(scenes.game) end,
}, {
    type = ui.TYPE_BUTTON,
    x = 0.4,
    y = 0.7,
    w = 0.2,
    h = 0.07,
    text = "Rogue",
    theme = ui.ButtonThemes.normal,
    callback = function() ui.switchScene(scenes.game) end,
}, {
    type = ui.TYPE_BUTTON,
    x = 0.4,
    y = 0.8,
    w = 0.2,
    h = 0.07,
    text = "Back",
    theme = ui.ButtonThemes.negative,
    callback = function() ui.switchScene(scenes.mainMenu) end,
} }

return scenes
