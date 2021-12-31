# Hubworlds
Hubworlds are special levels designed to be an access point for other levels. They come with unique features that only hubworlds have.

## Star Return Sequences
Inside `/ObjectData/SystemData.arc`, is a BCSV under the name `HubworldStarReturnDataTable.bcsv`. This table allows you to specify a cutscene that will be played when you return with a Power Star from a level.

#### GalaxyName
This is the name of the galaxy that this entry belongs to. (*Example: HubworldGalaxy*)

Because it would be too time consuming to write an entry for each galaxy, there are 3 other things you can put into this field: (Case sensitive)

- POWERSTAR - The absolute default, if no others exist.
- GRANDSTAR - Applies to Grand Stars the first time you get one.
- GRANDSTARPLUS - Applies to Grand Stars any time you get it after the first time.

#### ScenarioNo
If you decide to put the name of a Galaxy into the GalaxyName field, then this field becomes active. You can define which of a scenario specifically that the return path applies to.<br/>
If you leave this value at **-1**, then it will apply to all scenarios in a galaxy. You can then add another entry with the same GalaxyName, and set a scenario to have it override the **-1** entry.

#### ReturnType
This is the name of the Demo that will be played. This is NOT the Sheet Name. The object DemoGroup has a property called `DemoName` (aka `Cutscene Name`) which is what you need to copy into the ReturnType field.

## Hubworld Events
Inside `/ObjectData/SystemData.arc`, is a BCSV under the name `HubworldEventDataTable.bcsv`.<br/>
The original Starship Mario event system has been thrown out in favour of a new one that relies only on Demos.<br/>
You'll also need to add entries into the `GameEventValueTable.bcsv` (also in SystemData.arc) if you want the game to be able to play the cutscene, and save the fact that you've seen it.<br/>
The entry for GameEventValueTable is as follows:

- Set ValueName to `顔惑星イベント番号/X` where "X" is replaced with your EventNo (*Example:`顔惑星イベント番号/0` for Event Number 0*)
- Set Value to 0. Yes, it must be 0.

`HubworldEventDataTable.bcsv` goes as follows:

#### EventNo
The number of the Event. Give each event a unique number.<br/>
Each row in the BCSV can only check a single set of conditions, but if you would like to have an OR case (meaning the conditions of one entry OR another entry are met) then you can set multiple entries to have the same EventNo.

#### StageName
The name of the stage that you want to check

#### ScenarioNo
The scenario of the stage that you want to check. **-1** means **Any Scenario**

#### PowerStarNum
The number of powerstars the player needs in order for this event to trigger. Set to **0** if power star count is not a requirement.

#### FlagName
The flag required to trigger this event. Leave the field empty if flags are not a requirement.

#### ReturnDemoOverride
This field will override the Star Return Sequence cutscene with the cutscene name listed in the entry. This functionality is similar to the original SMG2 where you would do the power star return sequence inside the Engine Room.<br/>
This demo override will only apply if the event is triggered. If multiple events with `ReturnDemoOverride`s are queued to play, the first one in the list will be used.

#### DemoName
This is the name of the Demo that will be played for the event. This is NOT the Sheet Name. The object DemoGroup has a property called `DemoName` (aka `Cutscene Name`) which is what you need to copy into the field.

### Event Queue
There is an internal queue of **8 Entries** (GLE-V1). You cannot exceed this amount of entries in the queue, so please put effort into making sure that your hack never triggers more than 8 events at once.

Events are added to the queue in the order they appear in the BCSV (from top to bottom) So if you need a certain event to have priority, move it higher in the list.

### Event Quirks
Events have some special cases tied to them.

- If your cutscene played music, it will continue to play during gameplay after the cutscene is over unless you stop it during the cutscene.
- If your cutscene faded the screen using a Wipe, the wipe will be cancelled and replaced with a black wipe after the demo ends. (You can end your demo with a custom wipe)
- The last part (or, the last entry in the Time list) must be named `終了`, and be at minimum of **120** in length.
- The hubworld music will start at the start of each event. You can stop it with a Sound entry at the first part (or, the first entry in the Time list) with an AllStop frame.

## Hubworld Music
Hubworld music is currently not changable without ASM. **This will be changed in GLE-V2**