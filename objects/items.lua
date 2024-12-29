local items = {}

items.Types = {
    WEAPON = 0,
    ARMOR = 1,
    CONSUMABLE = 2,
}

items.Sword = {
    name = "Sword",
    type = items.Types.WEAPON,
    damage = 5,
    value = 10,
    tooltip = {
        title = "Sword",
        text = "A simple sword.",
        attribs = nil,
        interpolate = nil,
    },
}

items.Shield = {
    name = "Shield",
    type = items.Types.ARMOR,
    defense = 5,
    value = 10,
    tooltip = {
        title = "Shield",
        text = "A simple shield.",
        attribs = nil,
        interpolate = nil,
    },
}

return items
