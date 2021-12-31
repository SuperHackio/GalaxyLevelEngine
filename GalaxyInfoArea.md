# GalaxyInfoArea
This is a special area that lets you display galaxy banners. This area requires that the `ChangeSceneListInfo` bcsv that `SceneChangeArea` uses be filled out.

#### Obj_Arg0
SceneNo: This obj arg indicates which entry in the `ChangeSceneListInfo` should be used. This value matches with the `SceneNo` field in the bcsv.

## Banners
This area only has one obj arg, which references the `ChangeSceneListInfo`. There is other information that this area uses, however.<br/>
This area will only display a galaxy if it is displayed in the AllStarList as well. (Though, secret galaxies are ignored in this situation)<br/>
For more information, please visit the [AllStarList](/AllStarList.md) page.

### Galaxy Banners
Galaxy banners are stored inside `/ObjectData/GalaxyInfoTexture.arc`, and they are stored in the [BTI](https://luma.aurumsmods.com/wiki/BTI) file format.<br/>
The image must have the following settings:
- Width: 256
- Height: 72
- Format: You choose, but `CMPR` is recommended.
- Mag Filter: Linear recommended.
- Min Filter: Linear recommended.
- Horizontal Wrapping: Clamp
- Vertical Wrapping: Clamp

The name of the bti file should match the galaxy it belongs to. (*Example: DigMineGalaxy.bti*)<br/>
The GLE also comes with 2 special filenames: `1UnknownGalaxy.bti` and `UnknownGalaxy.bti`.
- 1UnknownGalaxy.bti: This is used when the galaxy is locked behind 1 star.
- UnknownGalaxy.bti: This is used when the galaxy is locked behind any other star amount.
