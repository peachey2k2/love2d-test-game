local utils = require("utils")
local shaders = require("graphics/shaders")
local tastytext = require("lib/tastytext")

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

ui.CUR_FONT = {
    small = nil,
    normal = nil,
    large = nil,
}
ui.CURRENT_OFFSET = 1


ui.TYPE_BUTTON = 0
ui.TYPE_TEXT = 1

ui.heldButton = nil

local TOOLTIP_WRAP_RATIO = 0.25
local SUBTOOLTIP_WRAP_RATIO = 0.15
local TOOLTIP_PAD = 5

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
    },
    positive = {
        fgColor = { 0.1, 0.6, 0.15 },
        bgColor = { 0.05, 0.4, 0.075 },
        fgHoverColor = { 0.15, 0.7, 0.225 },
        bgHoverColor = { 0.10, 0.5, 0.15 },
        textColor = { 1, 1, 1 },
    }
}

ui.TextThemes = {
    light = {
        textColor = { 1, 1, 1 },
    },
    dark = {
        textColor = { 0, 0, 0 },
    }
}

-- contains the currently drawn scene(s)
ui.drawn = {}

-- we defer the tooltip drawing to the end of the draw cycle
ui.tooltip = nil

function ui.updateSize(w, h)
    ui.windowSize = { w, h }

    local modifier = math.min(w, h * 1.3)

    ui.CUR_FONT.small = love.graphics.newFont("graphics/Miracode.ttf", math.ceil(modifier / 80.0))
    ui.CUR_FONT.normal = love.graphics.newFont("graphics/Miracode.ttf", math.ceil(modifier / 45.0))
    ui.CUR_FONT.large = love.graphics.newFont("graphics/Miracode.ttf", math.ceil(modifier / 30.0))
    love.graphics.setFont(ui.CUR_FONT.normal)
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
    ui.drawn = { scene }
    -- table.insert(ui.drawn, scene)
end

local typeFuncMatches = {
    [ui.TYPE_BUTTON] = function(obj) ui.drawButton(obj) end,
    [ui.TYPE_TEXT] = function(obj) ui.drawText(obj) end,
}

function ui.draw()
    for _, scene in ipairs(ui.drawn) do
        for _, obj in ipairs(scene) do
            typeFuncMatches[obj.type](obj)
        end
    end
    if ui.tooltip then
        ui.drawTooltip(ui.tooltip, TOOLTIP_WRAP_RATIO, love.mouse.getPosition())
        ui.tooltip = nil
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
        button.xx + (button.ww - ui.CUR_FONT.normal:getWidth(button.text)) / 2,
        button.yy + (button.hh - ui.CUR_FONT.normal:getHeight()) / 2 - offset
    )

    if (isHovered and button.tooltip) then
        ui.tooltip = button.tooltip
    end
end

function ui.drawText(text)
    love.graphics.setColor(text.theme.textColor)
    local textObj = love.graphics.newText(ui.CUR_FONT.normal, text.text)
    local sizeX, sizeY = textObj:getDimensions()
    love.graphics.draw(textObj, text.xx - sizeX / 2, text.yy - sizeY / 2)
end

local strTags = {
    col = { 1, 0, 0, 1 },
    def = { 1, 1, 1, 1 },
}

function ui.drawTooltip(tooltip, wrapRatio, xPos, yPos)
    local wrap = ui.windowSize[1] * wrapRatio
    local textFormatted = utils.strFormat(tooltip.text, tooltip.interpolate)
    local textObj = tastytext.new(textFormatted, wrap, ui.CUR_FONT.small, strTags)

    -- local wText, wrappedText = ui.CUR_FONT.small:getWrap(textFormatted, wrap)
    -- local hText = #wrappedText * ui.CUR_FONT.small:getHeight()
    local wText = textObj.limit
    local hText = textObj.lines * textObj.line_height

    local wTitle, hTitle = ui.CUR_FONT.normal:getWidth(tooltip.title), ui.CUR_FONT.normal:getHeight()
    local wIn, hIn = wText + TOOLTIP_PAD * 2, hText + TOOLTIP_PAD * 2
    local wOut, hOut = math.max(wIn, wTitle) + TOOLTIP_PAD * 2, hIn + hTitle + TOOLTIP_PAD * 3
    local wFrame, hFrame = wOut + TOOLTIP_PAD * 2, hOut + TOOLTIP_PAD * 2

    love.graphics.setColor(0.1, 0.1, 0.1)
    love.graphics.rectangle("fill", xPos, yPos, wFrame, hFrame, 8, 8, 9)
    love.graphics.setColor(0.9, 0.9, 0.9)
    love.graphics.rectangle("fill", xPos + TOOLTIP_PAD, yPos + TOOLTIP_PAD, wOut, hOut, 8, 8, 9)
    love.graphics.setColor(0.1, 0.1, 0.1)
    love.graphics.rectangle("fill", xPos + 2 * TOOLTIP_PAD, yPos + hTitle + 3 * TOOLTIP_PAD, wIn, hIn, 8, 8, 9)

    love.graphics.setColor(0, 0, 0)
    love.graphics.print(tooltip.title, xPos + (wOut - wTitle) / 2 + TOOLTIP_PAD, yPos + 2 * TOOLTIP_PAD)

    love.graphics.setColor(1, 1, 1)
    -- for i, line in ipairs(wrappedText) do
    --     love.graphics.print(line, ui.CUR_FONT.small,
    --         xPos + 3 * TOOLTIP_PAD,
    --         yPos + hTitle + 4 * TOOLTIP_PAD + (i - 1) * ui.CUR_FONT.small:getHeight()
    --     )
    -- end
    love.graphics.translate(xPos + 3 * TOOLTIP_PAD, yPos + hTitle + 4 * TOOLTIP_PAD)
    textObj:draw()
    love.graphics.origin()
    if tooltip.interpolate then
        for i, interp in ipairs(tooltip.interpolate) do
            if interp.tooltip then
                ui.drawTooltip(interp.tooltip, SUBTOOLTIP_WRAP_RATIO, xPos + wFrame + 2, yPos + (i - 1) * 76)
            end
        end
    end
end

return ui
