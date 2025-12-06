-- Map creation ID configs have the highest priority. Then targetname, then classname, then DEFAULT_ENT_CONFIG
--
-- You cannot configure KeyValues using targetnames. You must specify the entity/entities using
-- map creation IDs, classnames, or with DEFAULT_ENT_CONFIG

GM.TTTConfig = {
    ["DEFAULT_MAP_CONFIG"] = {
        ["DEFAULT_ENT_CONFIG"] = {
            [TEAM_HIDE] = ROLE_INNOCENT,
            [TEAM_SEEK] = ROLE_TRAITOR
        },

        -- Everyone can use traitor buttons
        ["classname.ttt_traitor_button"] = {
            [TEAM_HIDE] = ROLE_TRAITOR,
            [TEAM_SEEK] = ROLE_TRAITOR
        }
    },

    ["ttt_highnoon_a6"] = {

        -- Traitor room door
        [2198] = {

            -- Configuration keys are (currently) not inherited. We need to write this again
            -- even though it's already written in DEFAULT_ENT_CONFIG in DEFAULT_MAP_CONFIG
            [TEAM_HIDE] = ROLE_TRAITOR,
            [TEAM_SEEK] = ROLE_TRAITOR,

            -- Integer keys are for (hns team -> ttt role) mappings
            -- String keys are for entity keyvalue overrides
            --
            -- Force it to be reusable and set the delay to 8
            ["RemoveOnPress"] = false,
            ["wait"] = 10
        },

        -- The map creator forgot to add outputs to one of the fruit explosion buttons,
        -- so disable it
        --
        -- Ideally we would change OnPressed, but to make this button work we would need
        -- multiple OnPressed outputs, which this config system doesn't currently support
        ["targetname.fruitbomb2_button"] = {
            [TEAM_HIDE] = ROLE_INNOCENT,
            [TEAM_SEEK] = ROLE_INNOCENT,

            --["OnPressed"]
        }
    },

    ["ttt_grovestreet_a13"] = {
        -- Shorten delay on the manhole cover
        [1567] = {
            [TEAM_HIDE] = ROLE_TRAITOR,
            [TEAM_SEEK] = ROLE_TRAITOR,
            ["wait"] = 10
        }
    },

    ["ttt_polasbase_v1"] = {
        -- Disable the meltdown thing
        [1800] = {
            [TEAM_HIDE] = TEAM_INNOCENT,
            [TEAM_SEEK] = TEAM_INNOCENT
        }
    }

}

