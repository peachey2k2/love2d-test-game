local utils = {}

function utils.inRect(rect, x, y)
    return (
        rect.x < x and (rect.x + rect.width) > x and
        rect.y < y and (rect.y + rect.height) > y
    )
end

return utils
