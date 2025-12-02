-- From TTT util.lua

function Dev(level, ...)
    if cvars and cvars.Number("developer", 0) >= level then
        Msg("[TTT dev]")
        -- table.concat does not tostring, derp

        local params = {...}
        for i=1, #params do
            Msg(" " .. tostring(params[i]))
        end

        Msg("\n")
    end
end


if SERVER then return end

-- Short helper for input.LookupBinding, returns capitalised key or a default
function Key(binding, default)
    local b = input.LookupBinding(binding)
    if not b then return default end

    return string.upper(b)
end


-- Is screenpos on screen?
function IsOffScreen(scrpos)
    return not scrpos.visible or scrpos.x < 0 or scrpos.y < 0 or scrpos.x > ScrW() or scrpos.y > ScrH()
end

