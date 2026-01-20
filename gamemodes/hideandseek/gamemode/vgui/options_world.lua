
GM:AddHook(function(_, _, tabs)
    table.insert(tabs, {name = "World", icon = "icon16/world.png"})

end, "HASOptionsTabs", {"HNS", "AddWorldTab"})



GM:AddHook(function(_, _, panel, cvars)
    table.insert(cvars, "has_carryangles")

    local boxCarry = panel:Add("DCheckBoxLabel")

    boxCarry:SetText("Rotate props while carrying them?")
    boxCarry:SetConVar("has_carryangles")

    boxCarry:Dock(TOP)

end, "HASOptions_World", {"HNS", "FillWorldTab", "CarryAngles"})

