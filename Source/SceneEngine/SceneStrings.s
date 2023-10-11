.GLE ADDRESS SceneChangeEngineStringTable

ListPath:
    .string "/jmp/List"

ChangeSceneListInfo:
    .string "ChangeSceneListInfo"
    
StageInfo:
    .string "StageInfo"
    
ScenarioSettings:
    .string "ScenarioSettings"
    
Mode:
    .string "Mode"
    
OnExit:
    .string "OnExit"
    
OnDeath:
    .string "OnDeath"
    
OnGameOver:
    .string "OnGameOver"

OnStarGet:
    .string "OnStarGet"
    
ResultPathId:
    .string "ResultPathId" 
    
EntryPathId:
    .string "EntryPathId"
    
MinigameBgm:
    .string "MinigameBgm"
    
#Scenario Settings
#Disables the star chance music.
NoStarChance:
    .string "NoStarChance"

#Enables The Chimp to be used
PlayAttackMan:
    .string "PlayAttackMan"
    
#If set, the GLE will create a ScoreAttackAccessor on that scenario. Required for Score Attack and Bowling missions
#Not required for Ice Skating
ScoreAttack:
    .string "ScoreAttack"
    
#The ID of the race. Valid ID's are 1,2, etc. 0 means "Disabled"
RaceId:
    .string "RaceId"
    
#Enables the Fluzzard Tutorial to be usable properly
RaceTutorial:
    .string "RaceTutorial"
    
#This will prevent the game from spawning a power star for purple coins when you get 100 of them.
#The timer will stop once you grab the 100th purple coin (if you didn't enable NoStopClock)
#Something else must then spawn the star. Typically, this will be a Gearmo, as they are the only NPC who can track
#your purple coin information... I think.
ManualPurpleCoin:
    .string "ManualPurpleCoin"
    
#If enabled, the timer for comet stars will NOT stop when the star spawns. This also goes for purple coin comets
NoStopClock:
    .string "NoStopClock"
    
#Completely disables pausing.
#Forced true on the Title Screen
NoPause:
    .string "NoPause"
    
#Replaces the pause menu's Return to Map with Save and Quit
NoPauseReturn:
    .string "NoPauseReturn"
    
#The pause menu will only show the "Back" button
NoPauseExit:
    .string "NoPauseExit"
    
#Will enable the storybook layout
StoryLayout:
    .string "StoryLayout"
    
#Disables the "Welcome to the Galaxy" text
#Update 2023-01-01
#Finally fixed this dang thing lol
NoWelcome:
    .string "NoWelcome"
    
#Disables the ScenarioTitle from appearing inside the intro cutscene and fly-in
NoScenarioTitle:
    .string "NoScenarioTitle"
    
PeachStarGet:
    .string "PeachStarGet"
    
NoBootOut:
    .string "NoBootOut"

#Allows users to tell levels to not pause the music when pausing the game.
#The value used here is passed to MoveVolume
PauseVol:
    .string "PauseVol"

id:
    .string "id"
    
MarioNo:
    .string "MarioNo" 
    

#GameSettings
Data:
    .string "Data"
    
Data_Enabled:
    .string "o"
    
Data_Disabled:
    .string "x"
    
Lives:
    .string "Lives"
    
LoadIcon:
    .string "LoadIcon"
    
Player:
    .string "Player"
    
AllCompleteMessage:
    .string "AllCompleteMessage"
    
StarColorStart:
    .string "StarColorStart"
    
CometColorStart:
    .string "CometColorStart"
    
GrandColorStart:
    .string "GrandColorStart" 
    
    
#AllStarList strings
#I really should find a better palce to put these...
AllStarList_NewString:
    .string "AllStarList"
    
MaxPages:
    .string "MaxPages"
    
PageNumber:
    .string "PageNumber"

GalaxyPane:
    .string "GalaxyPane"
    
StarPane:
    .string "StarPane"
    
CompletePane:
    .string "CompletePane"
    
MedalPane:
    .string "MedalPane"
    
Title:
    .string "Title"

HideGalaxyText:
    .string "AllStarList_Invalid"
    
PageTitle_Format:
    .string "AllStarList_Title%d"
    
NoBootOut_DemoFormat:
    .string "NoBootOut%d"
    
ResourceMask_Str:
    .string "ResourceMask"
    
KeepHealth_Str:
    .string "KeepHealth"
    
__GLE_DEBUG_MODE:
    .string "Debug" AUTO
    
    
Static_PreviousStage:
#.GLE TRASH will discard these lines from the final output ini and xml.
#This is likely the only time this will be used
#This is done because we don't want Dolphin always overriding the addresses with 0.
.GLE TRASH BEGIN
.int 0 #Previous Galaxy (ScenarioData*) | 0x00
.int 0 #Previous Scenario ID | 0x04
.int 0 #Previous Start ID | 0x08
.int 0 #Previous Zone ID | 0x0C

Static_ModularPaths:
.short 0 #Path ID -2 = Use for Return Paths
.short 0 #Path ID -3 = Use for Entry Paths

Static_IsNeedMusicStopFromScenarioSelect:
.int 0

Static_PlayerHealthStorage:
.int 0
.GLE TRASH END

#You can technically add more modular paths, but the base GLE will only come with these 2

.GLE PRINTADDRESS
.GLE ENDADDRESS