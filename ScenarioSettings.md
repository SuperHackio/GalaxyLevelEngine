# ScenarioSettings
Inside `/ObjectData/SystemData.arc`, is a BCSV under the name `ScenarioSettings.bcsv`. This BCSV contains vital settings for specific galaxy scenarios to allow for certain activities or functions.

#### GalaxyName
A special string consisting of `<GalaxyName>_<ScenarioNo>` (*Example: TamakoroSliderGalaxy_2*). The underscore is important here, so do not get confused with the BCSV from [ScenarioSwitch](/ScenarioChecking.md).


After defining the Galaxy Name and Scenario, we can define flags and values for each entry.

#### NoStarChance
Disables the game from playing the Star Appearance music.<br/>
Available values:
- **0** = False
- **1** = True

> *Note: The Galaxy Level Engine takes priority over the SMG2 Project Template*

#### PlayAttackMan
This field will tell the Scenario Select that this mission has a Chimp mission on it.<br/>
Available values:
- **0** = Off
- **1** = On

> *Note: To work properly, requires an entry for a High and Low score inside the [GameEventValueTable](/GameEventValueTable.md)*

#### Score Attack
This field is required if you are using the Score Attack Chimp, or the Bowling Chimp.<br/>
Available values:
- **0** = False
- **1** = True

#### Race
This field is the ID of the race - required for fluzzard to work properly (both normal gliding and races).<br/>
Available values:
- **0** = No Fluzzard
- Any above 0 = ID of Race (for best time keeping)

> *Note: To work properly, requires an entry for a High and Low score inside the [GameEventValueTable](/GameEventValueTable.md)*

#### Tutorial
This field activates certain things needed for the Fluzzard Tutorial to work properly.<br/>
Available values:
- **0** = False
- **1** = True

#### PurpleCoinCaretaker
This field indicates that the purple coin star needs to be spawned by an NPC and not the purple coin spawner. Only Gearmos are known to be able to spawn this star.<br/>
Available values:
- **0** = False
- **1** = True

#### NoPause
This field disables pausing. Forced **TRUE** on the FileSelect, automatically.<br/>
Available values:
- **0** = False
- **1** = True

#### NoPauseReturn
This field disables the ability to "Return to Map", and replaces it with "Save and Quit". Should ideally be enabled for only Hubworlds, but can be enabled anywhere.<br/>
Available values:
- **0** = False
- **1** = True

#### NoPauseExit
This field disables "Return to Map" **and** "Save and Quit", meaning you cannot exit the level whatsoever. Recommended for use during your hack's prologue. (See the GLE Template hack as an example.)<br/>
Available values:
- **0** = False
- **1** = True

> *Note: This effect will be always automatically active during the first mission of your hack. A setting to change this will be introduced in GLE-V2*
