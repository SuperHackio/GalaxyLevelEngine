# GameEventValueTable
Inside `/ObjectData/SystemData.arc`, is a BCSV under the name `GameEventValueTable.bcsv`. This BCSV lets you define event values for the game to use.


## Scenario Based Flags
Some missions in the GLE require entries in here to properly track scores

#### The Chimp
Each Chimp mission needs 2 entries: A High and Low score.<br/>
High Scores are scores the player achieves.<br/>
Low Scores are scores that are there by default. For The Chimp, this is always 0.

Example: These flag names indicate that they belong to Shiverburn star 3<br/>
`ベストスコア[KachikochiLavaGalaxy_3]/lo` = Low Score. Set to 0.<br/>
`ベストスコア[KachikochiLavaGalaxy_3]/hi` = High Score. Set to 0.

#### Fluzzard
Each Fluzzard mission needs 2 entries: A High and Low score.<br/>
High Scores are scores the player achieves.<br/>
Low Scores are scores that are there by default. For fluzzard, this value is **Time in Seconds** multiplied by **60**.<br/>(*Example: 1m30s would be 90x60=5400*)

Example: These flag names indicate that they belong to Wild Glide star 1<br/>
`グライダー[JungleGliderGalaxy_1]/lo` = Default Time that appears. See above formula.<br/>
`グライダー[JungleGliderGalaxy_1]/hi` = Best Time. Set to 0.

#### Hubworld Events
See [Hubworld Events](/Hubworld.md#hubworld-events)

## Optional Flags
- `累積死亡回数` = a counter for how many times you have died on this save file. Recommended, as this value is displayed on the File Select. Set to 0.
- `累積ゲームオーバー回数` = a counter for how many times you've Game Over'd. Set to 0.
- `累積プレイ時間/lo` and `累積プレイ時間/hi` = values for how long you have played. Recommended, as these values are used whenever your play time is atttempted to be read. Set both to 0.
