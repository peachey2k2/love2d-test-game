local utils = require("utils")
local ui = require("ui")
local shaders = require("shaders")


local drawn = {}

local generalShader = love.graphics.newShader(shaders.general)

local main_menu = { {
    type = ui.TYPE_BUTTON,
    x = 300,
    y = 200,
    width = 200,
    height = 50,
    text = "Chess Battle Advanced",
    theme = ui.ButtonNegative,
    callback = function() print("button 1 pressed") end,
}, {
    type = ui.TYPE_BUTTON,
    x = 300,
    y = 300,
    width = 200,
    height = 50,
    text = "Chess Battle Advanced",
    theme = ui.ButtonNormal,
    callback = function() print("button 2 pressed") end,
} }


function love.load()
    DEFAULT_FONT = love.graphics.newFont(16)
    love.graphics.setFont(DEFAULT_FONT)

    table.insert(drawn, main_menu)
    generalShader:send("avgColor", { 0.8, 0.15, 0.15 });
end

function love.draw()
    local time = love.timer.getTime()

    if #drawn >= 1 then
        love.graphics.setShader(generalShader)

        generalShader:send("time", time)
        generalShader:send("resolution", { love.graphics.getWidth(), love.graphics.getHeight() })

        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setShader()
    end

    for _, scene in ipairs(drawn) do
        for _, obj in ipairs(scene) do
            if (obj.type == ui.TYPE_BUTTON) then
                ui.drawButton(obj)
            end
        end
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        for _, scene in ipairs(drawn) do
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
