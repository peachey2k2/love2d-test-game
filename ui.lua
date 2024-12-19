local utils = require("utils")

local ui = {}

ui.DEFAULT_FONT = nil

ui.TYPE_BG_SHADER = 0
ui.TYPE_BUTTON = 1

ui.heldButton = nil


ui.ButtonNormal = {
    fgColor = { 0.2, 0.2, 0.2 },
    bgColor = { 0.1, 0.1, 0.1 },
    fgHoverColor = { 0.28, 0.28, 0.28 },
    bgHoverColor = { 0.18, 0.18, 0.18 },
    textColor = { 1, 1, 1 },
}

ui.ButtonNegative = {
    fgColor = { 0.6, 0.1, 0.1 },
    bgColor = { 0.4, 0.05, 0.05 },
    fgHoverColor = { 0.7, 0.15, 0.15 },
    bgHoverColor = { 0.5, 0.10, 0.10 },
    textColor = { 1, 1, 1 },
}

function ui.drawButton(button)
    local mouseX, mouseY = love.mouse.getPosition()
    local isHovered = utils.inRect(button, mouseX, mouseY)

    love.graphics.setColor(isHovered and button.theme.bgHoverColor or button.theme.bgColor)

    local offset = 8

    if (ui.heldButton == button) then
        offset = 0
    else
        love.graphics.rectangle("fill",
            button.x, button.y,
            button.width, button.height,
            8, 8, 9
        )
    end

    love.graphics.setColor(isHovered and button.theme.fgHoverColor or button.theme.fgColor)

    love.graphics.rectangle("fill",
        button.x, button.y - offset,
        button.width, button.height,
        8, 8, 9
    )

    love.graphics.setColor(button.theme.textColor)
    love.graphics.print(button.text,
        button.x + (button.width - DEFAULT_FONT:getWidth(button.text)) / 2,
        button.y + (button.height - DEFAULT_FONT:getHeight()) / 2 - offset
    )
end

return ui
