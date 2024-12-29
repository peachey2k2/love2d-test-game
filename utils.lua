local utils = {}

function utils.inRect(rect, x, y)
    return (
        rect.xx < x and (rect.xx + rect.ww) > x and
        rect.yy < y and (rect.yy + rect.hh) > y
    )
end

function utils.strFormat(format, values)
    if values == nil then
        return format
    end
    local substitutes = {}
    for i = 1, #values do
        local name = values[i].name and values[i].name or values[i]
        substitutes[i] = "<col>" .. name .. "<def>"
    end
    return string.format(format, unpack(substitutes))
end

return utils
