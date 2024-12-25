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
}

items.Shield = {
    name = "Shield",
    type = items.Types.ARMOR,
    defense = 5,
    value = 10,
}

return items
