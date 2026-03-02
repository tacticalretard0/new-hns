# New Hide and Seek

Fork of [Light Hide and Seek](https://github.com/fgrg2801/light-hns)

## Main changes from Light Hide and Seek

- Re-added some features from the original Hide and Seek gamemode
- Sandbox support (superadmins can use the spawn menu)
- TTT entity support (traitor buttons work)
- Built-in third person (to toggle, type `!3p` in chat or `thirdperson_toggle` in console)
- Night vision for hiders
- System for adding hooks which allows for order constraints

## TO DO

- Achievements
    - Implement logic for the achievements `topplayer`, `healthy`, `rooted`, `friendsnatcher`
    - Rewrite the achievements menu
    - Let players see eachother's achievements (accessed through the scoreboard)
    - Add at least one requirements achievement, and make sure the code for req achievements works properly
    - Add achievement master stars in the scoreboard
- Infinite stamina in noclip
- Infinite stamina for the map winner
- Fix chat commands (again)
- Some default method of changing the map once all of the rounds are over. Could be a really basic mapvote, or something as simple as `game.LoadNextMap()`. Could also list all of the available maps and ask the host to choose one
- TTT
    - A CVar to disable TTT entities entirely
    - Support for ttt_filter_role and ttt_game_text entities
    - Don't let blind seekers press traitor buttons. Could also prevent traitor buttons from being used at all during blind time
    - A configuration system located in a text file instead of a Lua file, which would be easier for people to edit
- GUI / HUD
    - Options menu toggle for the CVar `has_avatarframes`
    - Bhop counter and options for its position
    - Buttons in the options menu to reset CVars to their default values
    - Use radio buttons for gender selection in the options menu
    - Option to use GMod's default voice indicators
    - Server-side CVar for allowing / disallowing team indicators, and client-side preference CVar for whether or not to draw them
    - Improve scoreboard refreshing, showing, and hiding
    - Update some of the text in the help menu

