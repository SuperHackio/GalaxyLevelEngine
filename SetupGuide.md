# Getting Started
This guide will teach you how to setup the GLE for your project.
## Prerequisites
#### Files
- All SMG2 base game files
- All GLE files

#### Knowledge
- General SMG2 hacking knowledge
- How to edit BCSV files
- How to connect switches
- How to use Whitehole (Or the level editor of your choice)

#### Programs
- A BCSV Editor (Whitehole's BCSV editor will work for most of the setup process)
- A MSBT Editor (I reccomend [MSBT_Editor by Penguin](https://github.com/penguin117117/MSBT_Editor))
- [WiiExplorer](https://github.com/SuperHackio/WiiExplorer/Releases)

> *Note: All images were taken using the GLE Template hack. You will need to apply the example to your own files. Don't name a stage HubworldGalaxy just because the Template does.*

---

## Initial Setup

If you simply put all the GLE files into the same directory as your fresh SMG2 files, the game will not work properly, there is more setup that needs to be done.<br/>
In order to get started, please create a new galaxy. Read [Creating a New Galaxy](<TODO>) for instructions and template galaxy files.


After you have your new galaxy map files placed in the correct location, it is time to register it.

### Registering Galaxies
In the Galaxy Level Engine, we make
use of a new directory, called
ScenarioData. It registers Galaxies.

All galaxies must be registered in order for you to be able to access them in-game.

To register a galaxy, go into the ScenarioData folder, and add a new, empty file with the name "<GalaxyName>.reg" (*Example: HubworldGalaxy.reg*)

<TODO IMAGE>

These files do absolutely nothing, and the game does not read them. All the game cares about is if the file exists or not. The game will crash if you try to register a galaxy that doesn't have files in StageData.

You are absolutely required to register FileSelect. You will see that there is already a file called FileSelect.reg, so you shouldn't need to worry about doing this yourself. If it is missing, simply add it yourself.

#### Naming Conventions
Galaxies are named with the following conventions:

- Hubworlds - **<Name>Galaxy** (*Example:HubworldGalaxy*)
- Galaxies - **<Name>Galaxy** (*Example:IslandFleetGalaxy*)
- Zones - **<Name>Zone** (*Example:AbekobeStartZone*)

Please keep these in mind when naming your new hubworlds, galaxies, and zones.

---

Now that your galaxies have been registered, it is time to finish the initial setup

### Setting up the Game Sequence
Using a BCSV Editor, open the following file: `ObjectData/SystemDataTable.arc /SystemDataTable/GalaxyDataTable.bcsv`.<br/>
What you need to do here, is add a new entry. Now do the following:

- Set the GalaxyName to be that of your Hubworld's internal name (*Example: HubworldGalaxy*)
- Leave the Zone Name blank for now
- !! Set the Sequence field to 0 !!
- !! Set the ScenarioNo field to 1 !!
- !! Set the MarioNo to 0 !!
- !! Set the **GameState** field to 2 (Custom field, hash is **0xB2754F9F**)

With the initial sequence value set, you should be able to load your game and successfully load the hubworld