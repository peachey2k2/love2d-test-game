local utils = require("utils")

local ui = {}

ui.windowSize = { 0, 0 }

local function xy_toScreenSpace(x, y)
    return x * ui.windowSize[1], y * ui.windowSize[2]
end

local function scene_toScreenSpace(scene)
    for _, obj in ipairs(scene) do
        obj.xx, obj.yy = xy_toScreenSpace(obj.x, obj.y)
        obj.ww, obj.hh = xy_toScreenSpace(obj.w, obj.h)
    end
end

ui.CURRENT_FONT = nil
ui.CURRENT_OFFSET = 1


ui.TYPE_BG_SHADER = 0
ui.TYPE_BUTTON = 1

ui.heldButton = nil

ui.ButtonThemes = {
    normal = {
        fgColor = { 0.2, 0.2, 0.2 },
        bgColor = { 0.1, 0.1, 0.1 },
        fgHoverColor = { 0.28, 0.28, 0.28 },
        bgHoverColor = { 0.18, 0.18, 0.18 },
        textColor = { 1, 1, 1 },
    },
    negative = {
        fgColor = { 0.6, 0.1, 0.1 },
        bgColor = { 0.4, 0.05, 0.05 },
        fgHoverColor = { 0.7, 0.15, 0.15 },
        bgHoverColor = { 0.5, 0.10, 0.10 },
        textColor = { 1, 1, 1 },
    }
}

ui.drawn = {}

function ui.updateSize(w, h)
    ui.windowSize = { w, h }

    local modifier = math.min(w, h)

    ui.CURRENT_FONT = love.graphics.newFont(modifier / 40.0)
    love.graphics.setFont(ui.CURRENT_FONT)
    ui.CURRENT_OFFSET = modifier / 80.0

    for _, scene in ipairs(ui.drawn) do
        scene_toScreenSpace(scene)
    end
end

function ui.init()
    ui.updateSize(love.graphics.getWidth(), love.graphics.getHeight())
end

function ui.switchScene(scene)
    scene_toScreenSpace(scene)
    table.insert(ui.drawn, scene)
end

function ui.draw()
    for _, scene in ipairs(ui.drawn) do
        for _, obj in ipairs(scene) do
            if (obj.type == ui.TYPE_BUTTON) then
                ui.drawButton(obj)
            end
        end
    end
end

function ui.drawButton(button)
    local mouseX, mouseY = love.mouse.getPosition()
    local isHovered = utils.inRect(button, mouseX, mouseY)

    love.graphics.setColor(isHovered and button.theme.bgHoverColor or button.theme.bgColor)

    local offset = ui.CURRENT_OFFSET

    if (ui.heldButton == button) then
        offset = 0
    else
        love.graphics.rectangle("fill",
            button.xx, button.yy,
            button.ww, button.hh,
            8, 8, 9
        )
    end

    love.graphics.setColor(isHovered and button.theme.fgHoverColor or button.theme.fgColor)

    love.graphics.rectangle("fill",
        button.xx, button.yy - offset,
        button.ww, button.hh,
        8, 8, 9
    )

    love.graphics.setColor(button.theme.textColor)
    love.graphics.print(button.text,
        button.xx + (button.ww - ui.CURRENT_FONT:getWidth(button.text)) / 2,
        button.yy + (button.hh - ui.CURRENT_FONT:getHeight()) / 2 - offset
    )
end

return ui
