# SceneChangeArea
The SceneChangeArea in the GLE provides access to the ChangeSceneListInfo.<br/>

#### Obj_Arg0
SceneNo: This obj arg indicates which entry in the ChangeSceneListInfo should be used. This value matches with the `SceneNo` field in the bcsv.

#### Obj_Arg1
Disable Screen Capture: if set to 1, the game will not freeze the game and do the fade, and instead continue until the fade is complete before warping the player

#### Obj_Arg2
Wipe Type: -1 = Fade to White, 0 = Fade to Black, 1 = Mario Head, 2 = Bowser Head, 3 = Circle, 4 = Game Over

#### Obj_Arg3
Wipe Time: In frames, the time that the wipe will play for. Does not affect Bowser Head, or Game Over. (This will be fixed in an update)

#### Obj_Arg5
Game State: 0 = InStage State, 1 = NoStage State, 2 = Hubworld State. For more information on Game States, please visit the [Game State](LINK) page.