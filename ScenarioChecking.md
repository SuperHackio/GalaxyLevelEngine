# Scenario Checking

The GLE has multiple places where Scenario Checking is used. The two main places would be:
- GalaxyInfo.bcsv
- ScenarioSwitch.bcsv

These two files function very similar to each other.
## Fields

#### PowerStarNum
The PowerStarNum field will let you check the number of power stars that the player has.<br/>
If you want any power star number to work, simply set this field to **0**

#### FlagName
This field lets you check game event flags, such as the ones triggered by collecting powerups for the first time.<br/>
If this field is left blank, this check will always return true.

#### RequireScenarioName
This is a special set of fields where you can add as many as you want. Your BCSV could only have `RequireScenarioName1`, or it could have `RequireScenarioName1`, `RequireScenarioName2`, `RequireScenarioName3`, etc.<br/>
You can have as many of these fields as needed, the only requirement is that they are numbered incrementally starting at 1. The checking of this field stops when the sequence is broken.<br/>
It is **VERY** important that you format the string like so: `GalaxyName X`, where X is the scenario No. (Example: `DigMineGalaxy 1` checks for Spin Dig Star 1)
> *Note: The space is very important. If your game crashes, try checking to see if you forgot it.*

### ScenarioSwitch Only
#### WatchedEventNo
Similar to RequireScenarioName, in the sense that it's incremental. (`WatchedEventNo1`, `WatchedEventNo2`, `WatchedEventNo3`, etc.)<br/>
These fields check to see if you have watched a specific [Hubworld Event](/Hubworld.md#hubworld-events). This is useful in hubworlds when unlocking new areas or levels, because the ScenarioSwitch won't activate too early.<br/>
If you do not want to check an event, leave these fields set to **-1**.

## Tricks
If you want a star to unlock after completing every other star in the game, you don't need a RequireScenarioName field for every scenario in the game, just set the PowerStarNum to the amount of stars you'll have at the point you want to unlock the one specific star.<br/>
Example from the GLE Template hack, would be Slipsand star 4: Sandstorm Rescue, Space Storm star 4: Bowser in the Sky, and literally every single green seeker star.


There are many ways that you can use these fields to check your game progress, and unlock new levels or stars. Be creative!
