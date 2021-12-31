# Creating a new Galaxy

Creating a new galaxy for the GLE is really easy.

[Click Here](<TODO>) to download a pre-made set of files. This guide will teach you how to customize them to your liking.


### Giving your galaxy a name
The name "TemplateGalaxy" isn't very appealing, so lets change it!

Firstly, pick the name you want to give your galaxy.

Try to name it in line with what the galaxy is about. Here are some examples:

- TamakoroJumpGalaxy = A Starball level involving jumping
- DrillSphereGalaxy = A Spin-Drill galaxy featuring mostly planets
- BigTreeGalaxy = A galaxy with a big tree in it
- HighlandExGalaxy = A bonus galaxy related to being high up
- CubeBubbleLv2Galaxy = The second Cube Bubble galaxy (name from SMG1)

Typically, galaxy names follow this convention:

- They all end with "Galaxy"
- Secret stages end with "ExGalaxy"
- Stages that have more than a single level dedicated to the same mechanic follow "Lv1Galaxy", "Lv2Galaxy", etc.
- These can be combined to "ExLv1Galaxy", "ExLv2Galaxy", etc.

The name must end with Galaxy. That's an internal requirement of SMG2 by default.


Now that you've picked your name, we can continue. This guide will use "MyNewGalaxy" as it's name.
#### Step 1
Rename the following files:

- TemplateGalaxyLight.arc -> MyNewGalaxyLight.arc
- TemplateGalaxyMap.arc -> MyNewGalaxyMap.arc
- TemplateGalaxyScenario.arc -> MyNewGalaxyScenario.arc
- TemplateGalaxyUseResource.arc -> MyNewGalaxyUseResource.arc
- TemplateGalaxyZoneInfo.arc -> MyNewGalaxyZoneInfo.arc

After these archives are renamed, open MyNewGalaxyLight.arc in [WiiExplorer](https://github.com/SuperHackio/WiiExplorer/Releases)<br/>
Rename `TempalteGalaxyLight.bcsv` to `MyNewGalaxyLight.bcsv`, then save the archive.