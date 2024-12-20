local utils = {}

function utils.inRect(rect, x, y)
    return (
        rect.xx < x and (rect.xx + rect.ww) > x and
        rect.yy < y and (rect.yy + rect.hh) > y
    )
end

return utils
