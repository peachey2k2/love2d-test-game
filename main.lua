local utils = require("utils")
local ui = require("ui")
local shaders = require("shaders")
local scenes = require("scenes")


local generalShader = love.graphics.newShader(shaders.general)


function love.load()
    DEFAULT_FONT = love.graphics.newFont(16)
    love.graphics.setFont(DEFAULT_FONT)

    ui.init()

    ui.switchScene(scenes.mainMenu)
    generalShader:send("avgColor", { 0.8, 0.15, 0.15 });
end

function love.resize(w, h)
    ui.updateSize(w, h)
end

function love.draw()
    local time = love.timer.getTime()

    love.graphics.setShader(generalShader)

    generalShader:send("time", time)
    generalShader:send("resolution", { love.graphics.getWidth(), love.graphics.getHeight() })

    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setShader()

    ui.draw()
end

local key_calls = {
    ["escape"] = function() love.event.quit() end,
}

function love.keypressed(key, scancode, isrepeat)
    if key_calls[key] then
        key_calls[key]()
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        for _, scene in ipairs(ui.drawn) do
            for _, obj in ipairs(scene) do
                if (obj.type == ui.TYPE_BUTTON) and utils.inRect(obj, x, y) then
                    ui.heldButton = obj
                end
            end
        end
    end
end

function love.mousereleased(x, y, button, istouch, presses)
    if button == 1 then
        if (ui.heldButton ~= nil and utils.inRect(ui.heldButton, x, y)) then
            ui.heldButton.callback()
        end
        ui.heldButton = nil
    end
end
