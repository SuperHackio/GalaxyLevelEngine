# Game State

The GLE provides 3 game states for your game to be in: InStage, NoStage, and Hubworld.

## InStage State
InStage state is the stage that the game is normally in during levels: A proper scenario must be setup, and there must be a power star and all the usual level stuff.

## NoStage State
NoStage state is similar to InStage state, but there is no need for power stars, or normal level stuff. The game acts normally as if you were in a level, and your starbits are stored in the global count, and not the stage count.

## Hubworld State
Hubworld state is the most unique, and it has a lot of features that you'll only see in hubworlds such as Hub Events and sequence updates. For more information on Hubworlds, please visit the [Hubworld](/Hubworld.md) page.
