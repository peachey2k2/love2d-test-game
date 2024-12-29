local utils = require("utils")
local ui = require("graphics/ui")
local shaders = require("graphics/shaders")
local scenes = require("graphics/scenes")


function love.load()
    -- DEFAULT_FONT = love.graphics.newFont("Miracode.ttf")
    -- love.graphics.setFont(DEFAULT_FONT)
    -- ui.CUR_FONT.normal = DEFAULT_FONT

    ui.init()

    ui.switchScene(scenes.mainMenu)
    shaders.general:send("avgColor", { 0.8, 0.15, 0.15 });
end

function love.errorhandler(msg)
    print((debug.traceback("Error: " .. tostring(msg), 1 + (layer or 1)):gsub("\n[^\n]+$", "")))
end

function love.resize(w, h)
    ui.updateSize(w, h)
end

function love.draw()
    local time = love.timer.getTime()

    love.graphics.setShader(shaders.general)

    shaders.general:send("time", time)
    shaders.general:send("resolution", { love.graphics.getWidth(), love.graphics.getHeight() })

    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setShader()

    ui.draw()

    local fps = love.timer.getFPS()
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(fps, 10, 10)
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
