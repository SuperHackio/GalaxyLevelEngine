# ChangeSceneListInfo

This bcsv existed in all files in the original SMG2, but the GLE replaces the file with it's own version of it for use with the SceneChangeArea area object.
> *NOTE: This system is subject for change, as it is somewhat confusing, and not very intuitive. Will update this page when that update comes out...*

## Fields

#### SceneNo
Use this field to connect the entry to the area in the level. Sync the number here with Obj_Arg0 of the [SceneChangeArea](LINK). Be sure to give each entry a unique number!

#### SceneList
The name of the Gakaxy that you will be sent to when you enter the area.

#### ZoneName
The name of the Zone that you'll be sent to. Only applies if you're not sent to the [Scenario Select](LINK).

#### ScenarioNo
The scenario that you will be sent to when you enter the area. If you want to be sent to the [Scenario Select](LINK), set this field to **-1**.

#### MarioNo
The StartID that mario will be spawned at. Only applies if you're not sent to the [Scenario Select](LINK).

#### ResultStage
The name of the Galaxy that you will be sent to upon completing any star. Usually, you will set this to be your Hubworld galaxy.

#### ResultZone
The name of the zZone that you'll be sent to upon completing any star. Usually, this will be a zone in your hubworld.

#### ResultScenario
The scenario that you'll return to upon completing any star. An example use case would be to send your player to the main scenario that will be used for most of the game, after starting a new file.<br/>
See the GLE Template hack as a demonstration - When you load into a new file, you are on Scenario 1 because the sequence value of 0 took you there. All galaxies in the GLE Template hack have these "result" fields set to take you to Scenario 2 of the Hubworld.

#### ResultMarioNo
The Start ID that mario will be spawned at upon completing any star. Usually this is a spawn point placed nearby the level entrance.

#### ExitMarioNo
The Start ID that mario will be spawned at upon BACKing out of the Scenario Select, or selecting Return to Map on the pause menu.

#### ResultPathId
This path ID field is used to determine a path that the [Power Star Return](LINK) sequences can reference - thus allowing a single setup to cover many or all levels. To use this value, simply set the `StarReturnDemoStarter`'s Camera to **-2**.

## Other Information
A template BCSV can be downloaded [by clicking here](LINK).