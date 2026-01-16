
local function ParseStringIntoQuery(queryString)
    -- Parse
    local query = queryString:Split(" ")


    -- Now validate
    local stackSize = 0
    for _, tkn in ipairs(query) do
        -- Binary operators pop two elements off of the stack then push the result
        if tkn == "|" or tkn == "^" or tkn == "&" then
            stackSize = stackSize - 2 + 1

            continue
        end

        -- Unary operators have no effect to the stack size
        if tkn == "!" then
            continue
        end


        -- If the token wasn't an operator, then it was a tag name
        stackSize = stackSize + 1
    end

    assert(stackSize == 1, "Invalid query string: the RPN leaves " .. tostring(stackSize) .. " values on the stack, but it must be 1")

    return query
end



local function TagSetMatchesQuery(tagSet, query)
    local stack = {}

    for _, tkn in ipairs(query) do
        if tkn == "|" then
            local right = table.remove(stack, #stack)
            local left = table.remove(stack, #stack)

            table.insert(stack, left or right)

            continue
        end

        if tkn == "^" then
            local right = table.remove(stack, #stack)
            local left = table.remove(stack, #stack)

            table.insert(stack, (left or right) and not (left and right))

            continue
        end

        if tkn == "&" then
            local right = table.remove(stack, #stack)
            local left = table.remove(stack, #stack)

            table.insert(stack, left and right)

            continue
        end



        table.insert(stack, table.HasValue(tagSet, tkn))

    end


    return stack[1]

end




local hooks = {}

-- TODO: make this an iterator?
function GM:QueryHooks(queryString)
    local query = ParseStringIntoQuery(queryString)

    local matches = {}

    for _, list in pairs(hooks) do
        for _, hook in ipairs(list) do
            if TagSetMatchesQuery(hook.tags, query) then
                table.insert(matches, hook)
            end
        end
    end

    return matches
end

function GM:AddHook(func, event, tags, constraints)
    constraints = constraints or {}

    constraints.runMeAfter = constraints.runMeAfter or ""
    constraints.runMeBefore = constraints.runMeBefore or ""

    table.insert(tags, "event:" .. event)


    hooks[event] = hooks[event] or {}

    local hook = {
        id = #hooks[event] + 1,
        func = func,
        event = event,
        tags = tags,
        constraints = constraints
    }


    table.insert(hooks[event], hook)
end


local graphs = {}




local function BuildGraphs(gm)
    for event, list in pairs(hooks) do


        graphs[event] = {}
        -- Initialize nodes
        for id, hook in ipairs(list) do
            graphs[event][id] = {
                func = hook.func,
                andThen = {},
                indegree = 0,
            }
        end



        local err = "Hook constraint references a hook for a different event"

        -- Connect nodes
        for id, hook in ipairs(list) do
            local hookNode = graphs[event][hook.id]

            -- runMeAfter
            for _, otherHook in ipairs(gm:QueryHooks(hook.constraints.runMeAfter)) do
                if otherHook.event ~= event then error(err) end


                local otherHookNode = graphs[event][otherHook.id]

                -- Don't do anything if the connection already exists for some reason
                if otherHookNode.andThen[id] then continue end

                hookNode.indegree = hookNode.indegree + 1
                otherHookNode.andThen[id] = true
            end


            -- runMeBefore
            for jd, otherHook in ipairs(gm:QueryHooks(hook.constraints.runMeBefore)) do
                if otherHook.event ~= event then error(err) end


                local otherHookNode = graphs[event][otherHook.id]

                if hookNode.andThen[jd] then continue end

                otherHookNode.indegree = otherHookNode.indegree + 1
                hookNode.andThen[jd] = true
            end

        end

    end
end



local sequences = {}

local function CheckForEdges(graph)
    for _, node in ipairs(graph) do
        if node.indegree ~= 0 then return true end
    end
    
    return false
end

-- Kahn's algorithm
-- https://en.wikipedia.org/wiki/Topological_sorting#Kahn's_algorithm
local function SolveGraph(event, graph)
    local sourceNodeIds = {}

    for id, node in ipairs(graph) do
        if node.indegree ~= 0 then continue end
        sourceNodeIds[id] = true
    end


    while not table.IsEmpty(sourceNodeIds) do
        -- Remove an arbitrary node and get its ID
        local id = next(sourceNodeIds)
        sourceNodeIds[id] = nil


        local node = graph[id]

        sequences[event] = sequences[event] or {}
        table.insert(sequences[event], node.func)
        --table.ForceInsert(sequences[event], node.func)

        for jd, _ in pairs(node.andThen) do
            node.andThen[jd] = nil

            local otherNode = graph[jd]
            otherNode.indegree = otherNode.indegree - 1

            if otherNode.indegree == 0 then
                sourceNodeIds[jd] = true
            end
        end

    end


    if CheckForEdges(graph) then
        error("Order constraints for hook " .. event .. " are contradictory (graph contains cycle)")
    end

end





function GM:SolveHooks()
    -- GM:SolveHooks could end up being called from within the gamemode, in which case GM is set and GAMEMODE is nil,
    -- or it could be called from an addon after the gamemode is loaded, when GM is nil and GAMEMODE is set
    --
    -- We pass BuildGraphs `self` so that it can always access the gamemode table
    BuildGraphs(self)

    for event, graph in pairs(graphs) do
        SolveGraph(event, graph)
    end


    for event, seq in pairs(sequences) do

        self[event] = function(gm, ...)
            local data = {}

            for _, func in ipairs(seq) do

                --local newData = func(gm, data, ...)
                func(gm, data, ...)

                --if newData ~= nil then data = newData end

            end


            return data.ret


        end

    end



end

