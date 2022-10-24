#Scene Utility for the GLE

.GLE ADDRESS sub_804E6190
#Take out a static initilizer
blr

#BCSV Get shortcuts
.StageDataHolder_GetSceneChangeList:
#StageDataHolder::getSceneChangeList
lis r4, ChangeSceneListInfo@ha
addi r4, r4, ChangeSceneListInfo@l
b .StageDataHolder_GetListJMapInfo

.StageDataHolder_GetStageInfo:
#StageDataHolder::getStageInfo
lis r4, StageInfo@ha
addi r4, r4, StageInfo@l
b .StageDataHolder_GetListJMapInfo


.StageDataHolder_GetListJMapInfo:
#StageDataHolder::getListJMapInfo
#r3 = ZoneID
#r4 = Filename
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
stw       r30, 0x08(r1)

mr r31, r3
mr r30, r4
bl getStageDataHolder__2MRFv
mr r4, r31
bl getStageDataHolderFromZoneId__15StageDataHolderFi

addi      r4, r3, 0xF8
mr r5, r30
bl findJmpInfoFromArray__15StageDataHolderCFPCQ22MR26AssignableArray<8JMapInfo>PCc
#Returns 0 if BCSV is not found

lwz       r31, 0x0C(r1)
lwz       r30, 0x08(r1)
lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr


#Note for Aurum or someone with symbol map access, address 0x8004C860 is the wrong function. It should be "getValue_Ul___8JMapInfoCFiPCcPl_Cb"
.MR_RequestMoveStageFromJMapInfo:
#Reads a BCSV Entry and warps the player there
#r3 = JMapInfo*
#r4 = Entry Index
#r5 = Don't update Statics
li r5, 0
.MR_RequestMoveStageFromJMapInfo_WithReset:
stwu      r1, -0x60(r1)
mflr      r0
stw       r0, 0x64(r1)
addi      r11, r1, 0x60
bl _savegpr_29

mr r31, r3
mr r30, r4
mr r29, r5

addi r3, r1, 0x08
mr r4, r31
lis r5, GalaxyName@ha
addi r5, r5, GalaxyName@l
mr r6, r30
bl getCsvDataStrOrNULL__2MRFPPCcPC8JMapInfoPCcl
lwz r3, 0x08(r1)

cmpwi r3, 0
#If no galaxy name is specified, just use the static variables. This should be the only way to
#Manually use those static variables
bne .MR_RequestMoveStageFromJMapInfo_Success
bl .MR_GoToSavedStage
b .MR_RequestMoveStageFromJMapInfo_Return

.MR_RequestMoveStageFromJMapInfo_Success:
addi r3, r1, 0x0C
mr r4, r31
lis r5, ScenarioNo@ha
addi r5, r5, ScenarioNo@l
mr r6, r30
bl getCsvDataS32__2MRFPlPC8JMapInfoPCcl

addi r3, r1, 0x10
mr r4, r31
lis r5, ZoneName@ha
addi r5, r5, ZoneName@l
mr r6, r30
bl getCsvDataStrOrNULL__2MRFPPCcPC8JMapInfoPCcl
#The above will return 0 if the string is empty. That's exactly what we want!

addi r3, r1, 0x14
mr r4, r31
lis r5, MarioNo@ha
addi r5, r5, MarioNo@l
mr r6, r30
bl getCsvDataS32__2MRFPlPC8JMapInfoPCcl

addi r3, r1, 0x18
mr r4, r31
lis r5, Player@ha
addi r5, r5, Player@l
mr r6, r30
bl getCsvDataS32__2MRFPlPC8JMapInfoPCcl

lwz r3, 0x08(r1)
lwz r4, 0x0C(r1)
lwz r5, 0x10(r1)
lwz r6, 0x14(r1)
lwz r7, 0x18(r1)
mr r8, r29
bl .MR_RequestMoveStage

#Update the paths
mr r3, r31
mr r4, r30
bl .MR_SetPathsFromJMap

.MR_RequestMoveStageFromJMapInfo_Return:
addi      r11, r1, 0x60
bl _restgpr_29
lwz       r0, 0x64(r1)
mtlr      r0
addi      r1, r1, 0x60
blr

.MR_RequestMoveStage:
#Makes the game start the level change process
#r3 = Destination Stage Name
#r4 = Destination Scenario. Leave as -1 to go to the Scenario Select
#r5 = Destination Zone Name. 0 = Main Galaxy
#r6 = Destination MarioNo
#r7 = Character Change (-1 = Do not change Player, 0 = Mario, 1 = Luigi, 2 = Swap. This lets the same area switch between both characters)
#r8 = Don't update Statics (Never give users control over this because the statics are meant to always be automatic)

stwu      r1, -0x50(r1)
mflr      r0
stw       r0, 0x54(r1)
addi      r11, r1, 0x50
bl _savegpr_23

mr r31, r3
mr r30, r4
mr r29, r5
mr r28, r6
mr r24, r8

#Always check for changing players
mr r3, r7
bl .MR_ChangePlayer

cmpwi r24, 1
beq .SkipSaveStage
#Always save the current stage
.GLE PRINTADDRESS
bl .MR_SaveCurrentStage
.SkipSaveStage:

#As a shotcut, lets first check to see if we are just going to the ScenarioSelect or not
cmpwi r30, -1
bne .MR_RequestMoveStage_NotScenarioSelect
#Note about this function, It would make more sense to call it "requestStartScenarioSelect__2MRFPCc" because it takes you
#specifically to the ScenarioSelect of the galaxy

#2022-02-22: Oh wow you somehow listened before I even put this on github
mr r3, r31
bl changeToScenarioSelect__20GameSequenceFunctionFPCc
b .MR_RequestMoveStage_Return


.MR_RequestMoveStage_NotScenarioSelect:

mr r5, r29
cmpwi r5, 0
#If r5 = 0, no zone was provided.
beq .MR_RequestMoveStage_CreateJmap

mr r3, r31
bl makeGalaxyStatusAccessor__2MRFPCc
stw r3, 0x08(r1)
addi r3, r1, 0x08
mr r4, r30
bl getZoneId__20GalaxyStatusAccessorCFPCc
mr r5, r3

.MR_RequestMoveStage_CreateJmap:
addi r3, r1, 0x0C
mr r4, r28
bl __ct__10JMapIdInfoFll

#Make corrections for hidden/seeker stars
li r23, -1

mr r3, r31
bl makeGalaxyStatusAccessor__2MRFPCc
stw r3, 0x08(r1)

addi r3, r1, 0x08
mr r4, r30
bl isStarHiddenOrGreen__20GalaxyStatusAccessorCFv
cmpwi r3, 0
beq .SkipFixScenario

#Fixes stars from crashing when trying to access scenario's marked as secret stars
mr r23, r30   #r30 now becomes what we need to go into r5 in the change call
mr r3, r31
mr r4, r30
bl getPlacedHiddenStarScenarioNo__2MRFPCcl
mr r30, r3

.SkipFixScenario:
#SceneChange time
mr r3, r31
mr r4, r30
mr r5, r23 #Note: Idk if giving a value other than -1 actually matters or not | Note on 2022-01-27 - YES THIS MATTERS.
addi r6, r1, 0x0C
bl changeSceneStage__20GameSequenceFunctionFPCcllP10JMapIdInfo

#Here used to be where the game state would get changed, but that wouldn't work here because internally
#we did not change stages yet. Code to change states will run automatically as soon as possible.
#I really hope this will work...

#Spoiler: It did not work
mr r3, r31
bl .MR_UpdateStageMode

.MR_RequestMoveStage_Return:
addi      r11, r1, 0x50
bl _restgpr_23
lwz       r0, 0x54(r1)
mtlr      r0
addi      r1, r1, 0x50
blr

.MR_ChangePlayer:
cmpwi r3, 2
beq .MR_SwapPlayer   #This function is close enough that we can just beq to it.
cmpwi r3, 0
bltlr #do not change if less than 0
bgt .ChangeToLuigi

.ChangeToMario:
b setPlayerStatusMario__2MRFv
.ChangeToLuigi:
b onGameEventFlagLuigiPlayed__16GameDataFunctionFv

.MR_SwapPlayer:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)

bl isPlayerLuigi__2MRFv

lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10

cmpwi r3, 0
beq .ChangeToLuigi
b .ChangeToMario
#This function is absurd!

.MR_GoToSavedStage:
.GLE PRINTADDRESS
#Goes to the stage saved in the static variables. If there isn't one, go back to the Title Screen
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
lis r31, Static_PreviousStage@ha
addi r31, r31, Static_PreviousStage@l

lwz r3, 0x0C(r31)
cmpwi r3, 0
beq .SavedSkipZoneNameIfZero
#Sneaky sneaky because the item in 0x00 is a ScenarioData*
lwz r3, 0x00(r31)
lwz r4, 0x0C(r31)
bl getZoneName__12ScenarioDataCFi

.SavedSkipZoneNameIfZero:
mr r5, r3
lwz r3, 0x00(r31)
lwz r3, 0x00(r3) #Do it twice because yes
lwz r4, 0x04(r31)
lwz r6, 0x08(r31)
li r7, -1
li r8, 1
bl .MR_RequestMoveStage

lwz       r31, 0x0C(r1)
lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr

.MR_SetPathsFromJMap:
#Reads a BCSV Entry and sets the path variables
#r3 = JMapInfo*
#r4 = Entry Index
stwu      r1, -0x30(r1)
mflr      r0
stw       r0, 0x34(r1)
addi      r11, r1, 0x30
bl _savegpr_29

mr r31, r3
mr r30, r4

addi r3, r1, 0x08
mr r4, r31
lis r5, ResultPathId@ha
addi r5, r5, ResultPathId@l
mr r6, r30
bl getCsvDataS16__2MRFPsPC8JMapInfoPCcl
lhz r4, 0x08(r1)
cmpwi r4, -1
#Do not change if the ID is -1
beq .SkipResultPath
bl .MR_SetReturnPath

.SkipResultPath:
addi r3, r1, 0x0A
mr r4, r31
lis r5, EntryPathId@ha
addi r5, r5, EntryPathId@l
mr r6, r30
bl getCsvDataS16__2MRFPsPC8JMapInfoPCcl
lhz r4, 0x0A(r1)
cmpwi r4, -1
#Do not change if the ID is -1
beq .SkipEntryPath
bl .MR_SetEntryPath

.SkipEntryPath:
#The above label exists in case you want to add more entries here

.MR_SetPathsFromJMap_Return:
addi      r11, r1, 0x30
bl _restgpr_29
lwz       r0, 0x34(r1)
mtlr      r0
addi      r1, r1, 0x30
blr

.MR_SetReturnPath:
#r3 = value
li r3, 0
b .MR_SetModularPath

.MR_SetEntryPath:
#r3 = value
li r3, 1
b .MR_SetModularPath

.MR_SetModularPath:
#r3 = modular path index
#r4 = Value
lis r5, Static_ModularPaths@ha
addi r5, r5, Static_ModularPaths@l
#Aw yeah, it's big brain time
slwi r3, r3, 1
sthx r4, r5, r3
blr

.GLE PRINTADDRESS
.MR_GetStageMode:
#Reads the StageInfo bcsv to find the Mode entry
#returns a value that can be passed directly into MR::setGameState((int))
#Due to reasons, can only read the currently loaded galaxy's mode.
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)

#Mode can only be on the Main galaxy
li r3, 0
bl .StageDataHolder_GetStageInfo
mr r31, r3

bl getCurrentScenarioNo__2MRFv
mr r5, r3
mr r3, r31
lis r4, Mode@ha
addi r4, r4, Mode@l
bl .MR_GetStageInfoEntry

cmpwi r3, -1
bne .MR_GetStageMode_Success

li r3, 0 #Default to InStage mode
b .MR_GetStageMode_Return

.MR_GetStageMode_Success:
#We now have the entry that this stage mode uses
mr r6, r3
addi r3, r1, 0x08
mr r4, r31
lis r5, Param00Int@ha
addi r5, r5, Param00Int@l
bl getCsvDataS32__2MRFPlPC8JMapInfoPCcl
lwz r3, 0x08(r1)

.MR_GetStageMode_Return:
lwz       r31, 0x0C(r1)
lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr


.MR_GetStageInfoEntry:
#Returns the index of the desired setting for the desired scenario
#r3 = JMapInfo*
#r4 = Setting name
#r5 = Scenario. The entry with -1 will be used if no scenario specific entry is found
stwu r1, -0x50(r1)
mflr      r0
stw       r0, 0x54(r1)
addi      r11, r1, 0x50
bl _savegpr_26

mr r31, r3
mr r30, r4
mr r29, r5

li r28, 0
li r27, -1 #Default Entry
b Loop_Start

Loop:
addi r3, r1, 0x08
mr r4, r31
lis r5, Type@ha
addi r5, r5, Type@l
mr r6, r28
bl getCsvDataStr__2MRFPPCcPC8JMapInfoPCcl

cmpwi r3, 0
beq Loop_Quit

lwz r3, 0x08(r1)
mr r4, r30
bl isEqualString__2MRFPCcPCc
cmpwi r3, 1
bne Loop_Continue
#Skip entries that aren't marked as the setting we want

mr r3, r31
mr r4, r28
bl isJMapEntryProgressComplete
cmpwi r3, 0
beq Loop_Continue

addi r3, r1, 0x08
mr r4, r31
lis r5, ScenarioNo@ha
addi r5, r5, ScenarioNo@l
mr r6, r28
bl getCsvDataS32__2MRFPlPC8JMapInfoPCcl

lwz r3, 0x08(r1)

cmpwi r3, -1
bne .CheckNotDefault
mr r27, r28 #Save the default

.CheckNotDefault:
cmpw r3, r29
mr r3, r28
beq Loop_Break

Loop_Continue:
addi r28, r28, 1
Loop_Start:
mr r3, r31
bl getCsvDataElementNum__2MRFPC8JMapInfo
cmpw r28, r3
blt+ Loop

Loop_Quit:
mr r3, r27
#Returns -1 if no entry was found
Loop_Break:
addi      r11, r1, 0x50
bl _restgpr_26
lwz r0, 0x54(r1)
mtlr      r0
addi      r1, r1, 0x50
blr

.GLE PRINTADDRESS
.GLE ASSERT sub_804E6680
.GLE ADDRESS sub_804E6680
#Take out another static initilizer
blr

.MR_GetStartZoneID:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
bl getInitializeStartIdInfo__2MRFv
lwz r3, 0x04(r3)
lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr

#This section will be for the Scenario Settings
#As of GLE-V2, the Scenario Settings have moved!
#They are now inside the map file, and are loaded only when the stage is loaded.
#Thus, all the below functions only care about the current information, such as Scenario and Galaxy Name.
#This BCSV doesn't even need to exist. All settings will be marked as the default option if so.
#Especially because all options are just bytes lol

.MR_GetCurrentScenarioSetting:
li r5, 0 #default to byte

.MR_GetCurrentScenarioSetting_Type:
#r3 = Setting Name
#r4 = Reverse
#r5 = Type. See .MR_GetScenarioSetting_Type
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
stw       r30, 0x08(r1)

mr r31, r3
mr r30, r4
mr r6, r5
bl getCurrentScenarioNo__2MRFv
mr r4, r3
mr r3, r31
mr r5, r30
bl .MR_GetScenarioSetting_Type

lwz       r31, 0x0C(r1)
lwz       r30, 0x08(r1)
lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr

.MR_GetScenarioSetting:
li r6, 0 #default to byte

.MR_GetScenarioSetting_Type:
#r3 = Setting Name
#r4 = Scenario ID
#r5 = Reverse
#r6 = Type, 0 = Byte, 1 = Float
stwu      r1, -0x100(r1)
mflr      r0
stw       r0, 0x104(r1)
addi      r11, r1, 0x100
bl _savegpr_21

#reset f1 to 0.0f
li r0, 0
stw r0, 0x08(r1)
lfs f1, 0x08(r1)

mr r31, r3
mr r30, r5
mr r29, r4
li r26, 0 #function flag
mr r21, r6

bl .MR_GetStartZoneID
bl .StageDataHolder_GetScenarioSettings
cmpwi r3, 0

#if r3 is 0, then the BCSV doesn't exist. We will assume the value is 0, then
#since r3 is already 0, we can just branch. It will still get inverted if requested.
beq .MR_GetScenarioSetting_Return
mr r28, r3

#make sure the field exists...
mr r4, r31
bl isExistItemInfo__8JMapInfoFPCc
cmpwi r3, 0
beq .MR_GetScenarioSetting_Return

.GetScenario:
li r22, 0
b .GetScenarioSetting_Loop_Start
.GetScenarioSetting_Loop:

addi r3, r1, 0x08
mr r4, r28
lis r5, ScenarioNo@ha
addi r5, r5, ScenarioNo@l
mr r6, r22
bl getCsvDataS32__2MRFPlPC8JMapInfoPCcl

lwz r3, 0x08(r1)
cmpw r3, r29
bne .GetScenarioSetting_Loop_Continue

#Lets see if we can use this entry or not.
#This part of the bcsv is purely optional
mr r3, r28
mr r4, r22
bl isJMapEntryProgressComplete
cmpwi r3, 0
beq .GetScenarioSetting_Loop_Continue

#r22 now has our valid entry
b .GetScenarioSetting_Success

.GetScenarioSetting_Loop_Continue:
addi r22, r22, 1


.GetScenarioSetting_Loop_Start:
mr r3, r28
bl getCsvDataElementNum__2MRFPC8JMapInfo
cmpw r22, r3
blt .GetScenarioSetting_Loop



#if we checked the default, and got nothing, then branch to the return.
cmpwi r29, -1
li r3, 0
beq .MR_GetScenarioSetting_Return

#Try again, but to find the default this time.
li r29, -1
b .GetScenario





.GetScenarioSetting_Success:
#We found an entry to use. Fetch the data!
addi r3, r1, 0x08
mr r4, r28
mr r5, r31
mr r6, r22

cmpwi r21, 0
beq .__readByte

#keeping this label here in case I need to add another data type...
.__readFloat:
bl getCsvDataF32__2MRFPfPC8JMapInfoPCcl
lfs f1, 0x08(r1)
b .MR_GetScenarioSetting_Return

.__readByte:
bl getCsvDataU8__2MRFPUcPC8JMapInfoPCcl
lbz r3, 0x08(r1)

.MR_GetScenarioSetting_Return:
cmpwi r21, 0
bne .NoInvert #can't invert anything but bytes

cmpwi r30, 0
beq .NoInvert
xori r3, r3, 1 #Flip the bit so 0 becomes 1 and 1 becomes 0
.NoInvert:

addi      r11, r1, 0x100
bl _restgpr_21
lwz       r0, 0x104(r1)
mtlr      r0
addi      r1, r1, 0x100
blr

.GLE PRINTADDRESS
#Can't go past here
.GLE ASSERT sub_804E6820
.GLE ENDADDRESS

#There are some functions that will need to be altered to use this new warp system
#Well, they don't *have* to, but I'd like them to for consistency purposes

.GLE ADDRESS notifyToGameSequenceProgressToEndScene__20GameSequenceFunctionFv
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)

bl sub_804D4730
bl initlizeInGameActorState__2MRFv

#Normally we'd force the player to be mario, but we need not do that

lis r3, FileSelect@ha
addi r3, r3, FileSelect@l
li r4, 1
li r5, 0
li r6, 0
li r7, -1
li r8, 1
bl .MR_RequestMoveStage

bl .MR_GetGameSequenceProgress
bl setStateTitle__20GameSequenceProgressFv

lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr
.GLE ENDADDRESS
#======================================================
.GLE ADDRESS sub_804E73B0
blr
.StageDataHolder_GetScenarioSettings:
#StageDataHolder::getScenarioSettings
lis r4, ScenarioSettings@ha
addi r4, r4, ScenarioSettings@l
b .StageDataHolder_GetListJMapInfo
.MR_GetGameSequenceProgress:
lwz       r3, sInstance__29SingletonHolder_10GameSystem_ - STATIC_R13(r13)
lwz       r3, 0xC(r3)
lwz       r3, 0(r3)
blr
.MR_UpdateStageMode:
#re-written twice now... this game sucks
#r3 = Stage Name
stwu      r1, -0x80(r1)
mflr      r0
stw       r0, 0x84(r1)
addi r11, r1, 0x80
bl _savegpr_23
mr r31, r3

bl makeGalaxyStatusAccessor__2MRFPCc
stw       r3, 0x08(r1)

addi r3, r1, 0x08
bl getWorldNo__20GalaxyStatusAccessorCFv
mr r25, r3

lis r4, Type@ha
addi r4, r4, Type@l
bl isExistItemInfo__8JMapInfoFPCc
cmpwi r3, 0
beq .NoModeDefined

mr r3, r25
lis r4, Type@ha
addi r4, r4, Type@l
lis r5, Mode@ha
addi r5, r5, Mode@l
bl isExistElement__8JMapInfoFPCcPCc
cmpwi r3, 0
bne .ModeDefined

.NoModeDefined:
li r29, 0
b .SetMode

.ModeDefined:
li r27, 0
b .GetModeLoop_Start

.GetModeLoop:
addi r3, r1, 0x0C
mr r4, r25
lis r5, Type@ha
addi r5, r5, Type@l
mr r6, r27
bl getCsvDataStr__2MRFPPCcPC8JMapInfoPCcl
cmpwi r3, 0
#Error, Likely the field does not exist
beq- .NoModeDefined

lwz r3, 0x0C(r1)
lis r4, Mode@ha
addi r4, r4, Mode@l
bl isEqualString__2MRFPCcPCc
cmpwi r3, 1
#Skip entries that aren't marked as Mode
bne .GetModeLoop_Continue

mr r3, r25
mr r4, r27
#Do this to see if we should validate this number or not
bl isJMapEntryProgressComplete
cmpwi r3, 0
beq .GetModeLoop_Continue

addi r3, r1, 0x08
mr r4, r25
lis r5, Param00Int@ha
addi r5, r5, Param00Int@l
mr r6, r27
bl getCsvDataS32__2MRFPlPC8JMapInfoPCcl
lwz r29, 0x08(r1)
b .SetMode

.GetModeLoop_Continue:
addi r27, r27, 1
.GetModeLoop_Start:
mr r3, r25
bl getCsvDataElementNum__2MRFPC8JMapInfo
cmpw r27, r3
blt .GetModeLoop

.SetMode:
.GLE PRINTADDRESS
bl getGameSequenceInGame__20GameSequenceFunctionFv
mr r4, r31
cmpwi r29, 1
beq .SetModeNoStage
bgt .SetModeHubworld

bl setStateInStage__16InGameActorStateFPCc
b .SetStageMode_Return

.SetModeHubworld:
bl setStateMarioFaceShip__16InGameActorStateFv
b .SetStageMode_Return

.SetModeNoStage:
bl setStateNoStage__16InGameActorStateFv

.SetStageMode_Return:
addi r11, r1, 0x80
bl _restgpr_23
lwz       r0, 0x84(r1)
mtlr      r0
addi      r1, r1, 0x80
blr

.MR_IsGameStateHubworld:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)

bl getGameSequenceInGame__20GameSequenceFunctionFv
bl isStateMarioFaceShip__16InGameActorStateFv

lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr

.GLE ADDRESS isStageMarioFaceShipOrWorldMap__2MRFv
b .MR_IsGameStateHubworldOrNoStage
.GLE ENDADDRESS

.GLE ADDRESS isStageMarioFaceShip__2MRFv
b .MR_IsGameStateHubworld
.GLE ENDADDRESS

#Dehardcode for AudSceneMgr::startScene.
#Don't know what this does, will add support for it if we do. (and care)
.GLE ADDRESS sub_80085720 +0x20
li r3, 0
.GLE ENDADDRESS


#=================
.GLE ADDRESS isStageWorldMap__2MRFv
li r3, 0
blr
.GLE ENDADDRESS
#=================

.GLE ADDRESS init__10MarioActorFRC12JMapInfoIter +0x17C
nop
nop
nop
nop
nop
nop
nop
nop
b 0x2C
.GLE ENDADDRESS

.MR_IsGameStateHubworldOrNoStage:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)

bl .MR_IsGameStateHubworld
cmpwi r3, 1
beq .MR_IsGameStateHubworldOrNoStage_Return


bl getGameSequenceInGame__20GameSequenceFunctionFv
addi r4, r13, InGameActorState_NoStage - STATIC_R13
bl isNerve__13NerveExecutorCFPC5Nerve
cmpwi r3, 1
beq .MR_IsGameStateHubworldOrNoStage_Return

bl getGameSequenceInGame__20GameSequenceFunctionFv
addi r4, r13, InGameActorState_PeachCastle - STATIC_R13
bl isNerve__13NerveExecutorCFPC5Nerve

.MR_IsGameStateHubworldOrNoStage_Return:
lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr


.GLE ADDRESS isStageMarioFaceShipNormal__2MRFv
li r3, 0
blr
.GLE ENDADDRESS


.GLE ADDRESS createStarPiece__2MRFv +0x20
li r3, 0
.GLE ENDADDRESS

.GLE ADDRESS __ct__20MarioHairAndHatModelFv +0x50
li r3, 0
.GLE ENDADDRESS

#Is there really no function fo this??
.MR_GetSystemWipeHolder:
lwz       r3, sInstance__29SingletonHolder_10GameSystem_ - STATIC_R13(r13)
lwz       r3, 0x30(r3)
blr

.MR_OpenCurrentWipe:
#This function is used to open the wipe that is currently closed
#Used primarily in situations where we are unsure about which wipe
#will be active. This will fix the screen cutting from White to Black or vise versa
#r3 = Wipe Time
stwu      r1, -0x20(r1)
mflr      r0
stw       r0, 0x24(r1)
addi      r11, r1, 0x20
bl        _savegpr_28

mr r29, r3

# bl isSystemWipeOpen__2MRFv
# cmpwi r3, 1
# beq .HandleSystemWipe

# bl getSceneWipeHolder__23SceneWipeHolderFunctionFv
# b .AfterSystemWipe

# .HandleSystemWipe:
# bl .MR_GetSystemWipeHolder

# .AfterSystemWipe:
# #SystemWipeHolder and SceneWipeHolder inherit the same base class thankfully
# mr r31, r3
# #Each holder contains a way to get the current wipe.
# bl getCurrent__14WipeHolderBaseCFv
# mr r31, r3

# lwz       r12, 0(r3)
# lwz       r12, 0x3C(r12)
# mtctr     r12
# bctrl     #WipeLayoutBase::ForceClose

# mr r3, r31
# mr r4, r29
# lwz       r12, 0(r3)
# lwz       r12, 0x38(r12)
# mtctr     r12
# bctrl     #WipeLayoutBase::wipe

#We will need to check every individual wipe class instance... ugh

#System wipes first
bl .MR_GetSystemWipeHolder
mr r31, r3
#Lets start with the Fade Wipes
#Black first, then White

#There are 4 scene wipes
#0 = Black Fade
#1 = Circle
#2 = White Fade
#3 = Mario Head (This one was added in SMG2)

# li r28, 0
# b .MR_OpenCurrentWipe_LoopStart
# .MR_OpenCurrentWipe_Loop:

# bl .LOCAL_GetWipeFromIndex
# mr r30, r3
# bl .LOCAL_IsWipeClosed
# cmpwi r3, 1

# beq .MR_OnFindClosedWipe

# .MR_OpenCurrentWipe_LoopContinue:
# addi r28, r28, 1
# .MR_OpenCurrentWipe_LoopStart:
# lwz       r3, 0x20(r31) #Wipe Array Length
# cmpw r28, r3
# blt .MR_OpenCurrentWipe_Loop

# b .MR_OpenCurrentWipe_Return

# .MR_OnFindClosedWipe:
mr r3, r31
li r4, 0
lwz       r12, 0(r3)
lwz       r12, 0x34(r12)
mtctr     r12
bctrl

mr r3, r31
li r4, 0
mr r5, r29
lwz       r12, 0(r3)
lwz       r12, 0x30(r12)
mtctr     r12
bctrl


.MR_OpenCurrentWipe_Return:
addi      r11, r1, 0x20
bl        _restgpr_28
lwz       r0, 0x24(r1)
mtlr      r0
addi      r1, r1, 0x20
blr

.LOCAL_GetWipeFromIndex:
#r28 = index
lwz       r4, 0x18(r31) #WipeLayoutBase[]
slwi r0, r28, 2
lwzx r3, r4, r0
blr

.LOCAL_IsWipeClosed:
#r3 = WipeLayoutBase
lwz       r12, 0(r3)
lwz       r12, 0x48(r12)
mtctr     r12
bctr      #WipeFade::isClose(const(void))

#================ Functions needing OpenCurrentWipe ================
.GLE ADDRESS sub_804B4490 +0x3C
# li        r3, 0x5A
# bl .MR_OpenCurrentWipe
nop
nop
.GLE ENDADDRESS
#TODO: Figure out where all the proper places for MR_OpenCurrentWipe are

#===================================================================

.MR_GetDeathOverrideIndex:
#Gets the current Death Override as specified in the Zone's StageInfo.
lis r3, OnDeath@ha
addi r3, r3, OnDeath@l
b .MR_GetStageInfoFromLocalOrMain

.MR_GetGameOverOverrideIndex:
lis r3, OnGameOver@ha
addi r3, r3, OnGameOver@l
b .MR_GetStageInfoFromLocalOrMain

.MR_GetExitOverrideIndex:
lis r3, OnExit@ha
addi r3, r3, OnExit@l
b .MR_GetStageInfoFromLocalOrMain

.MR_GetStageInfoFromLocalOrMain:
#If the entry is not found in the local ZoneInfo, the main galaxy's StageInfo will be checked instead
#r3 = Field Name
#Double Return Values:
#r3 = Entry Index (-1 if none found)
#r4 = IsLocal (bool) Returns 1 if the Local stage was used
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)

mr r31, r3

bl .MR_GetStartZoneID
bl .StageDataHolder_GetStageInfo
#Try get the zone's Death Override
mr r4, r31
bl .MR_GetStageDataHolderStageInfoEntry_Param00Int
cmpwi r3, -1
li r4, 1
bne .MR_GetStageInfoFromLocalOrMain_Return

#Nothing in the locals
#Lets check the Main
li r3, 0
bl .StageDataHolder_GetStageInfo
mr r4, r31
bl .MR_GetStageDataHolderStageInfoEntry_Param00Int
#Return -1 if this fails
li r4, 0 #Is Not Local
.MR_GetStageInfoFromLocalOrMain_Return:
lwz       r31, 0x0C(r1)
lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr

.MR_GetStageDataHolderStageInfoEntry_Param00Int:
#r3 = StageInfo JMapInfo*
#r4 = Setting Name
stwu      r1, -0x20(r1)
mflr      r0
stw       r0, 0x24(r1)
stw       r31, 0x1C(r1)
stw       r30, 0x18(r1)

mr r31, r3
mr r30, r4

bl getCurrentScenarioNo__2MRFv
mr r5, r3
mr r3, r31
mr r4, r30
bl .MR_GetStageDataHolderStageInfoEntry_Param00Int_Scenario

lwz       r31, 0x1C(r1)
lwz       r30, 0x18(r1)
lwz       r0, 0x24(r1)
mtlr      r0
addi      r1, r1, 0x20
blr

.MR_GetStageDataHolderStageInfoEntry_Param00Int_Scenario:
#r3 = StageInfo JMapInfo*
#r4 = Setting Name
#r5 = Scenario
stwu      r1, -0x20(r1)
mflr      r0
stw       r0, 0x24(r1)
stw       r31, 0x1C(r1)

mr r31, r3
bl .MR_GetStageInfoEntry

cmpwi r3, -1
#li r3, -1 #Return "No Override"
#r3 should have -1 in it already
beq .MR_GetStageDataHolderStageInfoEntry_Param00Str_Scenario_Return

mr r6, r3
addi r3, r1, 0x08
mr r4, r31
lis r5, Param00Int@ha
addi r5, r5, Param00Int@l
bl getCsvDataS32__2MRFPlPC8JMapInfoPCcl
lwz r3, 0x08(r1)

.MR_GetStageDataHolderStageInfoEntry_Param00Int_Scenario_Return:
lwz       r31, 0x1C(r1)
lwz       r0, 0x24(r1)
mtlr      r0
addi      r1, r1, 0x20
blr


.MR_GetStageDataHolderStageInfoEntry_Param00Str_Scenario:
#r3 = StageInfo JMapInfo*
#r4 = Setting Name
#r5 = Scenario
stwu      r1, -0x20(r1)
mflr      r0
stw       r0, 0x24(r1)
stw       r31, 0x1C(r1)

mr r31, r3
bl .MR_GetStageInfoEntry

cmpwi r3, -1
#li r3, -1 #Return "No Override"
#r3 should have -1 in it already
beq .MR_GetStageDataHolderStageInfoEntry_Param00Str_Scenario_Return

mr r6, r3
addi r3, r1, 0x08
mr r4, r31
lis r5, Param00Str@ha
addi r5, r5, Param00Str@l
bl getCsvDataStrOrNULL__2MRFPPCcPC8JMapInfoPCcl
lwz r3, 0x08(r1)

.MR_GetStageDataHolderStageInfoEntry_Param00Str_Scenario_Return:
lwz       r31, 0x1C(r1)
lwz       r0, 0x24(r1)
mtlr      r0
addi      r1, r1, 0x20
blr

#================================================
.GLE PRINTADDRESS
.RequestChangeStageAfterMiss:
stwu      r1, -0x60(r1)
mflr      r0
stw       r0, 0x64(r1)
addi      r11, r1, 0x60
bl _savegpr_25

#First of all, due to Death Overrides, we must first check the StageInfo bcsv file
#For ease of access, we have .MR_GetDeathOverrideIndex
bl .MR_GetDeathOverrideIndex
cmpwi r3, -1
#If this function returns -1, then there is no death override
beq .NoOverrideOnDeath
mr r31, r3
cmpwi r4, 1 #Do we check Local?
bne .NotLocal

bl .MR_GetStartZoneID
bl .StageDataHolder_GetSceneChangeList
b .RequestMoveOnJMapInfoOnDeath
.NotLocal:
li r3, 0
bl .StageDataHolder_GetSceneChangeList

.RequestMoveOnJMapInfoOnDeath:
mr r4, r31
bl .MR_RequestMoveStageFromJMapInfo
b requestChangeStageAfterMiss_Return

.NoOverrideOnDeath:

#If there's no override, we don't need the load icon to appear
bl .MR_GetLoadingLayout
cmpwi r3, 0
beq .requestChangeStageAfterMiss_Return2
bl hideLayout__2MRFP11LayoutActor
#Don't show the loading layout when dying

.requestChangeStageAfterMiss_Return2:

bl getGameSequenceInGame__20GameSequenceFunctionFv
mr r31, r3
bl getPlayResultInStageHolder__18GameSequenceInGameFv
mr r30, r3
lwz       r3, sInstance__29SingletonHolder_10GameSystem_ - STATIC_R13(r13)
lwz       r29, 0x24(r3)
#Lets check to see if we are in a hubworld
bl .MR_IsGameStateHubworld
cmpwi r3, 1
bne .OnInStageDeath

#Death in a hubworld? Send you to the same stage
addi      r3, r1, 0x08  #JMapIdInfo
lwz       r4, 0x6C(r30)
bl __ct__10JMapIdInfoFRC10JMapIdInfo

mr r3, r29
bl getCurrentSelectedScenarioNo__25GameSystemSceneControllerCFv
mr r28, r3

mr r3, r29
bl getCurrentScenarioNo__25GameSystemSceneControllerCFv
mr r4, r3

#Not using the usual function because we don't need to
#It also doesn't support the setting of r5
addi      r3, r29, 0x40
mr r5, r28
addi r6, r1, 0x08
bl changeSceneStage__20GameSequenceFunctionFPCcllP10JMapIdInfo
bl forceCloseSystemWipeCircle__2MRFv
bl .MR_SystemCircleWipeToCenter
b requestChangeStageAfterMiss_Return


.OnInStageDeath:
#Stages have some extra stuff...
mr r3, r30
bl clearAfterMiss__23PlayResultInStageHolderFv

lwz       r3, 0x18(r31)
li r0, 1
stb       r0, 0x18(r3)

addi      r3, r1, 0x08  #JMapIdInfo
lwz       r4, 0x6C(r30)
bl __ct__10JMapIdInfoFRC10JMapIdInfo
#Copies the current respawn point

mr r3, r29
bl getCurrentSelectedScenarioNo__25GameSystemSceneControllerCFv
mr r28, r3

mr r3, r29
bl getCurrentScenarioNo__25GameSystemSceneControllerCFv
mr r4, r3
addi      r3, r29, 0x40
mr        r5, r28
addi      r6, r1, 0x08
#Surprise! We're not using the GLE's usual level change function
bl sub_804D8510


#bl .MR_GetStageMode
addi      r3, r29, 0x40
bl .MR_UpdateStageMode

requestChangeStageAfterMiss_Return:

addi      r11, r1, 0x60
bl _restgpr_25
lwz       r0, 0x64(r1)
mtlr      r0
addi      r1, r1, 0x60
blr


.RequestChangeStageAfterGameOver:
stwu      r1, -0x60(r1)
mflr      r0
stw       r0, 0x64(r1)
addi      r11, r1, 0x60
bl _savegpr_25

b .ResetForGameOver
.GameOverReturn:


bl calcCurrentPowerStarNum__16GameDataFunctionFv
cmpwi r3, 0
ble .SkipGameOverDemoFlag
bl enablePlayGameOverDemo__2MRFv
.SkipGameOverDemoFlag:

#First thing's first, fetch the Game Over overrides
bl .MR_GetGameOverOverrideIndex
cmpwi r3, -1
#If this function returns -1, then there is no death override
beq .NoOverrideOnGameOver
mr r31, r3
cmpwi r4, 1 #Do we check Local?
bne .NotLocal_GameOver

bl .MR_GetStartZoneID
bl .StageDataHolder_GetSceneChangeList
b .RequestMoveOnJMapInfoOnGameOver
.NotLocal_GameOver:
li r3, 0
bl .StageDataHolder_GetSceneChangeList

.RequestMoveOnJMapInfoOnGameOver:
mr r4, r31
bl .MR_RequestMoveStageFromJMapInfo
b requestChangeStageAfterMiss_Return

.NoOverrideOnGameOver:
li r3, 1
bl .RequestChangeStageAfterGameOver_JumpLoc

.RequestChangeStageAfterGameOver_Return:

b .MultiFunctionEnd_0x60_r25
#==============================
.GLE PRINTADDRESS
.RequestChangeStageOnExit:
stwu      r1, -0x60(r1)
mflr      r0
stw       r0, 0x64(r1)
addi      r11, r1, 0x60
bl _savegpr_25

bl sub_8001BB90

bl .MR_GetExitOverrideIndex
cmpwi r3, -1
#If this function returns -1, then there is no death override
beq .NoOverrideOnExit
mr r31, r3
cmpwi r4, 1 #Do we check Local?
bne .NotLocal_Exit

bl .MR_GetStartZoneID
bl .StageDataHolder_GetSceneChangeList
b .RequestMoveOnJMapInfoOnExit
.NotLocal_Exit:
li r3, 0
bl .StageDataHolder_GetSceneChangeList

.RequestMoveOnJMapInfoOnExit:
mr r4, r31
bl .MR_RequestMoveStageFromJMapInfo
b .RequestChangeStageOnExit_Return

.NoOverrideOnExit:

bl .MR_GoToSavedStage
#bl .MR_GetStageMode
#lwz       r4, sInstance__29SingletonHolder_10GameSystem_ - STATIC_R13(r13)
#lwz       r4, 0x24(r4)
#addi      r4, r4, 0x40
#bl .MR_SetStageMode

.RequestChangeStageOnExit_Return:
#b .MultiFunctionEnd_0x60_r25

#Saves code space.
.MultiFunctionEnd_0x60_r25:
addi      r11, r1, 0x60
bl _restgpr_25
lwz       r0, 0x64(r1)
mtlr      r0
addi      r1, r1, 0x60
blr

.GLE ADDRESS requestChangeStageToWorldMap__2MRFv
b .RequestChangeStageOnExit
.GLE ENDADDRESS


#==============================
.MR_ChangeStageOnStarGet:
stwu      r1, -0x120(r1)
mflr      r0
stw       r0, 0x124(r1)
addi      r11, r1, 0x120
bl _savegpr_25

#Okay well, here's the interesting part
#We need to introduce Star Masks here
#And I guess later make it so that the actual correct scenario data gets applied...
#I really fear that part will go wrong...
#Though maybe people will just need to make a dummy scenario?
#I don't know yet...

#UPDATE 2022-02-22/23
#Need to split this into the level transition and star mask because they now belong to separate BCSVs
#Deal with the mask first, then the stage change

#Moved to BootOut.s
bl .MR_ApplyStarMask

bl getClearedPowerStarId__20GameSequenceFunctionFv
mr r30, r3
#Jump here if we don't have a mask
#Like the Mode setting, OnStarGet can only be applied to the Main galaxy, so none of the zones can have this set.
li r3, 0
bl .StageDataHolder_GetStageInfo
mr r31, r3

#Okay so here's the fun part - figuring out what to mask the star with
#All we need to do is alter the data inside the ScenePlayingResult

#First we need to actually make sure we *are* masking a star

#Lets see if the return stage was overridden
mr r3, r31
lis r4, OnStarGet@ha
addi r4, r4, OnStarGet@l
mr r5, r30
bl .MR_GetStageDataHolderStageInfoEntry_Param00Int_Scenario

cmpwi r3, -1
#There's no entry at all so lets just skip forward
beq .NoOverrideOnStarGet

mr r30, r3
bl requestScenePlayingResultEndStage__2MRFv

#Level warp time
#Users can disable an alternate warp by setting the param to -1
cmpwi r30, -1
beq .StageIsNotSet

li r3, 0
bl .StageDataHolder_GetSceneChangeList
mr r4, r30
bl .MR_RequestMoveStageFromJMapInfo
b .MR_ChangeStageOnStarGet_Return


.StageIsNotSet:
bl .MR_GoToSavedStage
b .MR_ChangeStageOnStarGet_Return



.NoOverrideOnStarGet:
#Just a normal star get
bl requestScenePlayingResultEndStage__2MRFv

#Normally, this function is littered with hardcoded stuff
#I'll ignore that here because there's no need for that hardcoded junk here

#Because no override was specified, we will attempt to bring the player back to the previous level
bl .MR_GoToSavedStage

.MR_ChangeStageOnStarGet_Return:
addi      r11, r1, 0x120
bl _restgpr_25
lwz       r0, 0x124(r1)
mtlr      r0
addi      r1, r1, 0x120
blr

.GLE ADDRESS requestChangeStageAfterStageClear__2MRFv
#2022-06-13
#Getting ready for No-boot-out code
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)

bl getClearedPowerStarId__20GameSequenceFunctionFv
bl .IsScenarioNoBootOut  #We want to check based on what star you got, not which scenario you're on
cmpwi r3, 0
bgt .ChangeStageAfterStageClear_Dont

.ChangeStageAfterStageClear_Force:
bl forceCloseSystemWipeCircle__2MRFv
bl .MR_SystemCircleWipeToCenter
bl .MR_ChangeStageOnStarGet
b .ChangeStageAfterStageClear_Return

.ChangeStageAfterStageClear_Dont:
bl .MR_NoBootOut_OnRequestChangeStage

.ChangeStageAfterStageClear_Return:
lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr
.GLE ASSERT requestChangeStageAfterMiss__2MRFv
.GLE ENDADDRESS


#=========== StageDataHolder Utility
#I ran out of code space near StageDataHolder oof
.InitListInfo:
lwz       r3, 0xC4(r30)
addi      r4, r30, 0xF8
lis r5, ListPath@ha
addi r5, r5, ListPath@l
bl initJmpInfo__15StageDataHolderFPQ22MR26AssignableArray_8JMapInfo_PCc

mr        r3, r30
addi      r4, r30, 0xF8
bl updateDataAddress__15StageDataHolderFPCQ22MR26AssignableArray<8JMapInfo>

lwz       r0, 0x14(r1)
b .InitListInfo_Return

#Had to move this
.MR_SaveCurrentStage:
.GLE PRINTADDRESS
#Saves the current stage to the static variables
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)

lis r31, Static_PreviousStage@ha
addi r31, r31, Static_PreviousStage@l

bl makeCurrentGalaxyStatusAccessor__2MRFv
stw r3, 0x00(r31)

bl getCurrentScenarioNo__2MRFv
stw r3, 0x04(r31)

#bl getCurrentMarioStartId__2MRFv
bl getRespawnPoint__2MRFv
lwz r4, 0x00(r3)
stw r4, 0x08(r31)

#bl getCurrentStartZoneId__2MRFv
lwz r4, 0x04(r3)
stw r4, 0x0C(r31)

lwz       r31, 0x0C(r1)
lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr



#================== GameSettings
#Strings are in SceneStrings.s
.MR_GetGameSetting:
#r3 = Setting Name
#r4 = Return Type: 0 = Return Param00Int | 1 = Is Data set to "o" | 2 = return Data
stwu      r1, -0x20(r1)
mflr      r0
stw       r0, 0x24(r1)
stw       r31, 0x1C(r1)
stw       r30, 0x18(r1)

mr r31, r3
bl MR_GetGameSettingsJMap    #R4 will remain untouched
mr r30, r3

cmpwi r4, 1
bgt .MR_GetGameSetting_GetData
beq .MR_GetGameSetting_IsDataO

#Genius fallthrough :sunglasses:
.MR_GetGameSetting_GetParam00Int:
addi r3, r1, 0x08
mr r4, r30
lis r5, Type@ha
addi r5, r5, Type@l
mr r6, r31
lis r7, Param00Int@ha
addi r7, r7, Param00Int@l
bl getValue_l_PCc___2MRCFPlP8JMapInfoPCcPCcPCc_Cb

lwz r3, 0x08(r1)
b .MR_GetGameSetting_Return

.MR_GetGameSetting_IsDataO:
addi r3, r1, 0x08
mr r4, r30
lis r5, Type@ha
addi r5, r5, Type@l
mr r6, r31
lis r7, Data@ha
addi r7, r7, Data@l
bl findElement_PCc_PCc___8JMapInfoCFPCcli_12JMapInfoIter
lwz r3, 0x08(r1)
lis r4, Data_Enabled@ha
addi r4, r4, Data_Enabled@l
bl isEqualString__2MRFPCcPCc
b .MR_GetGameSetting_Return

.MR_GetGameSetting_GetData:
addi r3, r1, 0x08
mr r4, r30
lis r5, Type@ha
addi r5, r5, Type@l
mr r6, r31
lis r7, Data@ha
addi r7, r7, Data@l
bl findElement_PCc_PCc___8JMapInfoCFPCcli_12JMapInfoIter
lwz r3, 0x08(r1)

.MR_GetGameSetting_Return:
lwz       r31, 0x1C(r1)
lwz       r30, 0x18(r1)
lwz       r0, 0x24(r1)
mtlr      r0
addi      r1, r1, 0x20
blr

#At the bottom 'cause I ran out of room at the top
.MR_GetModularPath:
#r3 = path index
#This will be below -1, always.
neg r4, r4
subi r4, r4, 2
lis r5, Static_ModularPaths@ha
addi r5, r5, Static_ModularPaths@l
slwi r4, r4, 1
lhzx r4, r5, r4
blr

#============== TOTALLY UNRELATED POWERUP FUNCTION =============
#no sus here. Totally not just copied from SMG1........(spoiler: it was copied from SMG1)
#r3 = Powerup to check for
.MR_isPlayerElementMode:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0xC(r1)

mr        r31, r3
bl        getPlayerActor__11MarioAccessFv
lhz       r0, 0x6F8(r3) #except this. This wasn't copied
subf      r0, r31, r0
cntlzw    r0, r0
srwi      r3, r0, 5

lwz       r31, 0xC(r1)
lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr

.GLE ADDRESS getRailInfo__2MRFP12JMapInfoIterPPC8JMapInfoRC12JMapInfoIter +0x40
b .MR_getRailInfo_Ext
.MR_getRailInfo_Ext_Return:
.GLE ENDADDRESS

.MR_getRailInfo_Ext:
lwz       r6, 0x08(r1)
cmpwi r6, -1
bge .SkipReturnPath

lwz       r4, 0x08(r1)
bl .MR_GetModularPath
mr r6, r4

.SkipReturnPath:
b .MR_getRailInfo_Ext_Return
.GLE PRINTADDRESS


.ExeNoStage_StartBgm:
bl openWipeFade__2MRFl
li r3, 0
bl startCurrentStageBGM__2MRFi
b .ExeNoStage_StartBgm_Return


.GLE ADDRESS exeNoStage__16InGameActorStateFv +0x1C
b .ExeNoStage_StartBgm
.ExeNoStage_StartBgm_Return:
.GLE ENDADDRESS

.GLE ASSERT __ct__14WorldMapHolderFv
.GLE ENDADDRESS