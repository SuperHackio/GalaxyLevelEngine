#Moving forwards by 4 because of the DEAD_STATIC

.GLE ADDRESS .ALLSTARLIST_LINK
#This file contains utilities relating to Scenarios
#========================================================================================

#TODO: Add a GLE Binding
#bool GLE::isJMapEntryProgressComplete(JMapInfo* bcsv, s32 entryid)
#This function will scan a BCSV Entry to see if all checks pass
#r3 = JMapInfo
#r4 = Index

#will retirn true if none of the BCSV fields are present
.GLE PRINTADDRESS
isJMapEntryProgressComplete:
stwu      r1, -0x140(r1)
mflr      r0
stw       r0, 0x144(r1)
addi r11, r1, 0x140
bl _savegpr_23

mr r31, r3 #JMapInfo
mr r30, r4 #Index

lis r4, PowerStarNum@ha
addi r4, r4, PowerStarNum@l
bl isExistItemInfo__8JMapInfoFPCc
cmpwi r3, 0
beq .skipStarNum

addi r3, r1, 0x08
lis r5, PowerStarNum@ha
addi r5, r5, PowerStarNum@l
bl LOCAL_GetFieldInt

bl getPowerStarNum__2MRFv
lwz r4, 0x08(r1)
cmpw r3, r4
blt .BCSVCheckReturnFalse

.skipStarNum:
#Here used to be the flag check but now you can have many flags to check

#Loop 1 Time
li r28, 1 #i?
b .BCSVEventValueLoopStart

.BCSVEventValueLoop:
addi      r3, r1, 0x0C
li        r4, 0x40
lis r5, EventValueName_Format@ha
addi r5, r5, EventValueName_Format@l
mr        r6, r28
crclr     4*cr1+eq
bl        snprintf

mr r3, r31
addi r4, r1, 0x0C
bl isExistItemInfo__8JMapInfoFPCc
cmpwi r3, 0 #This means it failed to find the entry
beq .EventNoCheck

addi r3, r1, 0x08
addi r5, r1, 0x0C
bl LOCAL_GetFieldStringOrNULL

#Get the existing value before making a new string
bl getGameDataHolder
lwz r4, 0x08(r1)
cmpwi r4, 0
beq .BCSVEventValueLoopContinue #If the string is empty/NULL
bl getGameEventValue__14GameDataHolderCFPCc
mr r27, r3

addi      r3, r1, 0x0C
li        r4, 0x30
lis r5, EventValue_Format@ha
addi r5, r5, EventValue_Format@l
mr        r6, r28
crclr     4*cr1+eq
bl        snprintf

mr r3, r31
addi r4, r1, 0x0C
bl isExistItemInfo__8JMapInfoFPCc
cmpwi r3, 0 #This is an error.
beq .BCSVCheckReturnFalse

addi r3, r1, 0x08
addi r5, r1, 0x0C
bl LOCAL_GetFieldInt

lwz r4, 0x08(r1)
cmpw r27, r4
blt .BCSVCheckReturnFalse

.BCSVEventValueLoopContinue:
addi r28, r28, 1
.BCSVEventValueLoopStart:
b .BCSVEventValueLoop


.EventNoCheck:
#Loop 2 Time
li r28, 1 #i?
b .BCSVEventLoopStart

.BCSVEventLoop:
addi      r3, r1, 0x0C
li        r4, 0x30
lis r5, FlagName_Format@ha
addi r5, r5, FlagName_Format@l
mr        r6, r28
crclr     4*cr1+eq
bl        snprintf

mr r3, r31
addi r4, r1, 0x0C
bl isExistItemInfo__8JMapInfoFPCc
cmpwi r3, 0 #This means it failed to find the entry
beq .CheckScenario

addi r3, r1, 0x08
addi r5, r1, 0x0C
bl LOCAL_GetFieldStringOrNULL

lwz r3, 0x08(r1)
cmpwi r3, 0
beq .BCSVEventLoopContinue #Continue if the flag is empty

lwz r3, 0x08(r1)
bl isOnGameEventFlag__16GameDataFunctionFPCc
cmpwi r3, 0
beq .BCSVCheckReturnFalse

.BCSVEventLoopContinue:
addi r28, r28, 1
.BCSVEventLoopStart:
b .BCSVEventLoop


.CheckScenario:
#Loop 3 time
li r28, 1 #i?
b .BCSVCheckLoopStart
.BCSVCheckLoop:
addi      r3, r1, 0x0C
li        r4, 0x40
lis r5, RequireScenarioName_Format@ha
addi r5, r5, RequireScenarioName_Format@l
mr        r6, r28
crclr     4*cr1+eq
bl        snprintf

mr r3, r31
addi r4, r1, 0x0C
bl isExistItemInfo__8JMapInfoFPCc
cmpwi r3, 0 #This means it failed to find the entry
li r3, 1
beq .BCSVCheckReturn

addi r3, r1, 0x08
addi r5, r1, 0x0C
bl LOCAL_GetFieldStringOrNULL

lwz r4, 0x08(r1)
cmpwi r4, 0
beq .BCSVCheckLoopContinue #Continue if the string is NULL

#Replaced with a function moment
lwz r3, 0x08(r1)
addi r4, r1, 0x0C
bl .GLE_GetGalaxyAndScenarioFromString

addi      r3, r1, 0x10
lwz r4, 0x0C(r1)
bl hasPowerStar__16GameDataFunctionFPCcl
cmpwi r3, 0
beq .BCSVCheckReturnFalse

.BCSVCheckLoopContinue:
addi r28, r28, 1
.BCSVCheckLoopStart:
b .BCSVCheckLoop #aka while(true)

.BCSVCheckReturnFalse:
li r3, 0

.BCSVCheckReturn:

mr r23, r3
#Normally ew'd be done here, but now with Invert support we need to check to see if
#The user is asking if the condition is NOT met
mr r3, r31
lis r4, Invert@ha
addi r4, r4, Invert@l
bl isExistItemInfo__8JMapInfoFPCc
cmpwi r3, 0
beq .skipInvert

addi r3, r1, 0x08
lis r5, Invert@ha
addi r5, r5, Invert@l
bl LOCAL_GetFieldInt

lwz r4, 0x08(r1)
cmpwi r4, 1
blt .skipInvert

xori r23, r23, 1 #Flip the bit so 0 becomes 1 and 1 becomes 0

.skipInvert:
mr r3, r23

addi r11, r1, 0x140
bl _restgpr_23
lwz       r0, 0x144(r1)
mtlr      r0
addi      r1, r1, 0x140
blr

#Locals for isJMapEntryProgressComplete
#DO NOT USE ELSEWHERE
LOCAL_GetFieldInt:
mr r4, r31
mr r6, r30
b getCsvDataS32__2MRFPlPC8JMapInfoPCcl

LOCAL_GetFieldStringOrNULL:
mr r4, r31
mr r6, r30
b getCsvDataStrOrNULL__2MRFPPCcPC8JMapInfoPCcl

#r3 = const char *
#r4 = void*
#Void pointer will be ordered as: Scenario ID, Galaxy Name
.GLE_GetGalaxyAndScenarioFromString:
addi r5, r4, 0x04
addi r6, r4, 0x00
lis r4, GalaxyScenario_Format@ha
addi r4, r4, GalaxyScenario_Format@l
crclr     4*cr1+eq
b sscanf











#========================================================================================


#GLE::makeStarPaneName(r3 = char const * StringLocation, r4 = int StarID)
makeStarPaneName:
mr r6, r4
lis r5, Star_Format@ha
addi r5, r5, Star_Format@l
b makePaneName_Loc

#GLE::makeNewBubblePaneName(r3 = char const * StringLocation, r4 = int StarID)
makeNewBubblePaneName:
mr r6, r4
lis r5, New_Format@ha
addi r5, r5, New_Format@l
b makePaneName_Loc

#GLE::makeHiddenBubblePaneName(r3 = char const * StringLocation, r4 = int StarID)
makeHiddenBubblePaneName:
mr r6, r4
lis r5, Hidden_Format@ha
addi r5, r5, Hidden_Format@l
b makePaneName_Loc

#GLE::makeCometBubblePaneName(r3 = char const * StringLocation, r4 = int StarID)
makeCometBubblePaneName:
mr r6, r4
lis r5, Comet_Format@ha
addi r5, r5, Comet_Format@l
#Cheat here and just let the code continue

#Used by the above functions
makePaneName_Loc:
li        r4, 0x08
crclr     4*cr1+eq
b        snprintf



#New addition to lock the ScenarioSelect to a max amount of stars

#r3 = GalaxyStatusAccessor
.GetPowerStarNumOrMax:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
bl getPowerStarNum__20GalaxyStatusAccessorCFv

cmpwi r3, StarCount
ble .GetPowerStarNumOrMax_Return

li r3, StarCount

.GetPowerStarNumOrMax_Return:
lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr

#========================================================================================

#I can't believe normal SMG2 doesn't have this...
#GameDataFunction::getGameDataHolder((void))
getGameDataHolder:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
bl        getSaveDataHandleSequence__16GameDataFunctionFv
bl        getCurrentUserFile__22SaveDataHandleSequenceFv
lwz       r3, 0(r3)
lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr

#========================================================================================
#Galaxy Registration
makeStageRegisterFileName:
mr        r6, r5
lis       r5, RegisterFile@ha
addi      r5, r5, RegisterFile@l
crclr     4*cr1+eq
b         snprintf

newMakeScenarioArchiveName:
lwz       r5, 0x10(r1)
addi      r3, r1, 0x20
li        r4, 256
bl makeScenarioArchiveFileName__2MRFPcUlPCc
li        r3, 0x10
b newMakeScenarioArchiveName_Return

.GLE ADDRESS __ct__18ScenarioDataParserFPCc +0x58
bl makeStageRegisterFileName
#GLE ENDADDRESS will restore the address we had before the last GLE ADDRESS command.
.GLE ENDADDRESS

.GLE ADDRESS __ct__18ScenarioDataParserFPCc +0x70
b newMakeScenarioArchiveName
newMakeScenarioArchiveName_Return:
.GLE ENDADDRESS


#========================================================================================
.GLE ADDRESS getWorldNo__20GalaxyStatusAccessorCFv
#GalaxyStatusAccessor::getWorldNo((void))
#Replaced with a way to grab the GalaxyInfo BCSV, so returns a BCSV Pointer
lwz r3,0x00(r3)
lwz r3,0x0C(r3)
blr
.GLE ENDADDRESS

#========================================================================================
#GalaxyStatusAccessor::IsStarOpen((long))
.GLE ADDRESS isOpenScenario__20GalaxyStatusAccessorCFl
b GalaxyStatusAccessor__isStarOpen
.GLE ENDADDRESS


#Custom replacement
GalaxyStatusAccessor__isStarOpen:
stwu r1, -0x100(r1)
mflr      r0
stw       r0, 0x104(r1)
addi      r11, r1, 0x100
bl _savegpr_15

mr r31, r3 #GalaxyStatusAccessor
mr r30, r4 #Scenario to check

bl hasPowerStar__20GalaxyStatusAccessorCFl
cmpwi r3, 1
#Leave r3 as 1 because we need to return 1 anyways
beq GalaxyStatusAccessor__isStarOpen_Return

#Check if it's a comet
mr r3, r31
mr r4, r30
bl isStarComet__20GalaxyStatusAccessorCFl
cmpwi r3, 1
bne .StarNotComet
mr r3, r31
bl getName__20GalaxyStatusAccessorCFv
bl isOnGalaxyFlagTicoCoin__16GameDataFunctionFPCc
cmpwi r3, 0
#Leave r3 as 0 because we need to return 0 anyways
beq GalaxyStatusAccessor__isStarOpen_Return

.StarNotComet:
mr r3, r31
#Get the GalaxyInfo BCSV File
bl getWorldNo__20GalaxyStatusAccessorCFv
mr r29, r3

li r28, 0
b UnlockTypeLoop_Start

UnlockTypeLoop:
addi r3, r1, 0x08
mr r4, r29
lis r5, Type@ha
addi r5, r5, Type@l
mr r6, r28
bl getCsvDataStr__2MRFPPCcPC8JMapInfoPCcl

cmpwi r3, 0
beq GalaxyStatusAccessor__isStarOpen_Return

lwz r3, 0x08(r1)
lis r4, Unlock@ha
addi r4, r4, Unlock@l
bl isEqualString__2MRFPCcPCc
cmpwi r3, 1
bne UnlockTypeLoop_Continue
#Skip entries that aren't marked as Unlock conditions
addi r3, r1, 0x08
mr r4, r29
lis r5, Param00Int@ha
addi r5, r5, Param00Int@l
mr r6, r28
bl getCsvDataS32__2MRFPlPC8JMapInfoPCcl

lwz r3, 0x08(r1)
cmpw r3, r30
beq UnlockTypeLoop_Break

UnlockTypeLoop_Continue:
addi r28, r28, 1
UnlockTypeLoop_Start:
mr r3, r29
bl getCsvDataElementNum__2MRFPC8JMapInfo
cmpw r28, r3
blt+ UnlockTypeLoop


# The only way we get here is if r28 goes too far.
#Lock the star if so. Users should properly define an unlock for each star,
#Even if that condition is just 0 stars.
li r3, 0
b GalaxyStatusAccessor__isStarOpen_Return

UnlockTypeLoop_Break:
#We have our BCSV Entry for the given scenario in r28 now.
#Lets use another function to check the rest of the entry.
mr r3, r29
mr r4, r28
bl isJMapEntryProgressComplete
#I'd compare, but this function only returns 0 or 1, so it should be safe
#to just leave it like this...

GalaxyStatusAccessor__isStarOpen_Return:
addi      r11, r1, 0x100
bl _restgpr_15
lwz r0, 0x104(r1)
mtlr      r0
addi      r1, r1, 0x100
blr

#========================================================================================

#TODO: Expand this!
startScenarioSelectBgm:
stwu r1, -0x20(r1)
mflr      r0
stw       r0, 0x24(r1)
addi      r11, r1, 0x20
bl _savegpr_29


#Lets get the GalaxyStatusAccessor of this stage
bl makeCurrentGalaxyStatusAccessor__2MRFv
stw r3, 0x08(r1)
addi r3, r1, 0x08
bl getWorldNo__20GalaxyStatusAccessorCFv
lis r4, SelectBgm@ha
addi r4, r4, SelectBgm@l
li r5, 2
li r6, 0  #Always 0
bl .getActiveEntryFromGalaxyInfo
.GLE PRINTADDRESS
cmpwi r3, 0
bne .CustomSelectMusic

lis r3, BGM_SMG2_COURSESELECT02@ha
addi      r3, r3, BGM_SMG2_COURSESELECT02@l
.CustomSelectMusic:
li        r4, 0
bl        startStageBGM__2MRFPCcb


addi      r11, r1, 0x20
bl _restgpr_29
lwz r0, 0x24(r1)
mtlr      r0
addi      r1, r1, 0x20
blr
#SelectBgm


#========================================================================================


#Used by ScenarioSelect
Return_0x40_r27:
addi      r11, r1, 0x40
bl        _restgpr_27
lwz       r0, 0x44(r1)
mtlr      r0
addi      r1, r1, 0x40
blr


#========================================================================================


#Luigi Comet Timer
#Fun fact for anyone reading this - This Luigi comet timer was in GLE-V1 despite
#the fact that there's no way to play as Luigi in GLE-V1... Oopsies
.GLE ADDRESS getCometLimitTimer__20GalaxyStatusAccessorCFl
b LuigiCometTimer
.GLE ENDADDRESS

LuigiCometTimer:
stwu      r1, -0x20(r1)
mflr      r0
stw       r0, 0x24(r1)
stw       r31, 0x1C(r1)
stw       r30, 0x18(r1)

lwz r31, 0x00(r3)
mr r30, r4

mr r3, r31
lis       r4, CometLimitTimer@ha
addi      r4, r4, CometLimitTimer@l # "CometLimitTimer"
mr r5, r30
addi      r6, r1, 0x08
bl        getValueS32__12ScenarioDataCFPCclPl

lwz r3, 0x08(r1)
cmpwi r3, 0
beq .LimitTimerReturn

bl isPlayerLuigi__2MRFv
cmpwi r3, 0
beq .ReturnMarioTimer

mr r3, r31
lis       r4, LuigiMode@ha
addi      r4, r4, LuigiMode@l # "LuigiModeTimer"
mr r5, r30
addi      r6, r1, 0x0C
bl        getValueS32__12ScenarioDataCFPCclPl

lwz r3, 0x0C(r1)
cmpwi r3, 0
bne .ReturnLuigiTimer


.ReturnMarioTimer:
lwz r3, 0x08(r1)
b .LimitTimerReturn

.ReturnLuigiTimer:
lwz r3, 0x0C(r1)

.LimitTimerReturn:
lwz       r30, 0x18(r1)
lwz       r31, 0x1C(r1)
lwz       r0, 0x24(r1)
mtlr      r0
addi      r1, r1, 0x20
blr


#========================================================================================
#========== Power Star Colours ==========

#PowerStar::getColorInDemo
#replacement
PowerStar_getColorInDemo:
li r6, 0
li r7, 0

#r3 = LiveActor*
#r4 = int Power Star ID
#r5 = bool* Is Empty
#r6 = char const* Galaxy Name
#r7 = Is need Result Colour

PowerStar_getColorInStage:
stwu      r1, -0x70(r1)
mflr      r0
stw       r0, 0x74(r1)
addi      r11, r1, 0x70
bl        _savegpr_24

li r29, 0
mr r26, r4
mr r28, r5
mr r27, r6
mr r24, r7
cmpwi r3, 0
beq .PowerStarIDExists

cmpwi r26, -1
bne .PowerStarIDExists
lwz       r31, 4(r3)

#Lets find the Power Star ID
bl getSceneObjHolder__2MRFv
li r4, 4
bl getObj__14SceneObjHolderCFi
lwz r3, 0x14(r3)
mr r4, r31
bl findStarID__20PowerStarEventKeeperCFPCc
mr r26, r3

.PowerStarIDExists:
cmpwi r27, 0
beq .CurrentGalaxy
mr r3, r27
bl makeGalaxyStatusAccessor__2MRFPCc
b .Store

.CurrentGalaxy:
#Lets get the GalaxyStatusAccessor of this stage
bl makeCurrentGalaxyStatusAccessor__2MRFv

.Store:
stw r3, 0x0C(r1)

.CheckColour:
.GLE PRINTADDRESS
#Interruption:
#Star masks.
#While we technically don't need to reassign the colour,
#we do need to check if we show the empty power star or not.
addi r3, r1, 0x0C
bl getWorldNo__20GalaxyStatusAccessorCFv
lis r4, StarMask@ha
addi r4, r4, StarMask@l
li r5, 2
mr r6, r26
bl .getActiveEntryFromGalaxyInfo

cmpwi r3, 0
beq .NoUpdatePowerStarColourStarMask

lis r4, GalaxyScenario_Format@ha
addi r4, r4, GalaxyScenario_Format@l
addi r5, r1, 0x14
addi r6, r1, 0x10
crclr     4*cr1+eq
bl sscanf

lwz r26, 0x10(r1)  #Load the int from the scan
addi r3, r1, 0x14
bl makeGalaxyStatusAccessor__2MRFPCc
stw r3, 0x0C(r1)
#Should be it...


.NoUpdatePowerStarColourStarMask:
addi r3, r1, 0x0C
lwz r3, 0(r3)
lis r4, PowerStarColor@ha
addi r4, r4, PowerStarColor@l
mr r5, r26
addi r6, r1, 0x08
bl getValueS32__12ScenarioDataCFPCclPl

cmpwi r3, 0
beq .ReturnWithBool #if the value is not found

bl sub_804D7EE0
cmpwi r3, 1
li r29, 1
beq .ReturnWithBool
lwz r29, 0x08(r1)

.ReturnWithBool:
cmpwi     r28, 0
beq .Return

cmpwi r24, 0
beq .IsNewStarSkip

#First check to see if we just got this star
addi r3, r1, 0x0C
bl getName__20GalaxyStatusAccessorCFv
mr r4, r26
bl isJustGetStar__20GameSequenceFunctionFPCcl
cmpwi r3, 0
beq .IsNewStarSkip

bl sub_804D6B10
cmpwi r3, 1
beq .Return

.IsNewStarSkip:
addi r3, r1, 0x0C
mr r4, r26
bl hasPowerStar__20GalaxyStatusAccessorCFl
stb       r3, 0(r28)

addi r3, r1, 0x0C
mr r4, r26
bl hasPowerStarAsBronze__20GalaxyStatusAccessorCFl
cmpwi r3, 0
beq .Return
li r3, 0   #Store the fact that the star is not yet collected. 'cause it technically isn't
stb       r3, 0(r28)

.Return:
mr        r3, r29

addi      r11, r1, 0x70
bl        _restgpr_24
lwz       r0, 0x74(r1)
mtlr      r0
addi      r1, r1, 0x70
blr

#========================================================================================


#GameDataFunction::isOnGalaxyFlagTicoCoin((char const *))
#An addition to let users say there's no comet medal and still have the galaxy "completable"
.GLE ADDRESS isOnGalaxyFlagTicoCoin__16GameDataFunctionFPCc +0x0C
b .CometMedalEx
.CometMedalEx_Return_YesMedal:
.GLE ENDADDRESS

.CometMedalEx:
stw r3, 0x0C(r1)
bl makeGalaxyStatusAccessor__2MRFPCc
stw r3, 0x08(r1)
addi r3, r1, 0x08
bl getWorldNo__20GalaxyStatusAccessorCFv
lis r4, CometMedalStatus@ha
addi r4, r4, CometMedalStatus@l
li r5, 0
li r6, 1
bl .getActiveEntryFromGalaxyInfo
#0 means Yes Comet Medal
xori r3, r3, 1 #Flip the bool
cmpwi r3, 0 #1 means Yes Comet Medal
beq .CometMedalEx_Return_NoMedal
lwz r3, 0x0C(r1)
bl makeSomeGalaxyStorage__16GameDataFunctionFPCc
b .CometMedalEx_Return_YesMedal

.CometMedalEx_Return_NoMedal:
#No medal, return TRUE always
li r3, 1
lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr

#========================================================================================
#r3 = JMapInfo*
#r4 = Type to search for
#r5 = Mode - 0 = return bool | 1 = return Param00int | 2 = return Param00Str
#r6 = (Mode = 0) Param00Int int | (Mode = 1) Param00Str char const * (0 = ignore) | (Mode = 2) Param00Int int

.getActiveEntryFromGalaxyInfo:
stwu      r1, -0x70(r1)
mflr      r0
stw       r0, 0x74(r1)
addi      r11, r1, 0x70
bl        _savegpr_26

mr r31, r3
mr r30, r4
mr r29, r5
mr r28, r6

bl getCsvDataElementNum__2MRFPC8JMapInfo
mr r27, r3
li r26, 0

b .getActiveEntryFromGalaxyInfo_LoopStart

.getActiveEntryFromGalaxyInfo_Loop:

#First find the entry with the correct type
addi r3, r1, 0x08
mr r4, r31
lis r5, Type@ha
addi r5, r5, Type@l
mr r6, r26
bl getCsvDataStr__2MRFPPCcPC8JMapInfoPCcl

#Return 0 if the read failed
cmpwi r3, 0
beq .getActiveEntryFromGalaxyInfo_Return


lwz r3, 0x08(r1)
mr r4, r30
bl isEqualString__2MRFPCcPCc
cmpwi r3, 0
beq .getActiveEntryFromGalaxyInfo_LoopContinue

#isJMapEntryProgressComplete was added kinda late into development...
#2022-03-26
mr r3, r31
mr r4, r26
bl isJMapEntryProgressComplete
cmpwi r3, 0
beq .getActiveEntryFromGalaxyInfo_LoopContinue

#Type matches!

cmpwi r29, 1
#Just return r3 (1 or 0) if the mode is less than 1 (aka 0, return bool)
beq .getActiveEntryFromGalaxyInfo_CheckInt
bgt .getActiveEntryFromGalaxyInfo_CheckStr

#Mode 0 = Return bool (on the entry that has a matching int)
addi r3, r1, 0x0C
mr r4, r31
lis r5, Param00Int@ha
addi r5, r5, Param00Int@l
mr r6, r26
bl getCsvDataS32__2MRFPlPC8JMapInfoPCcl

lwz r3, 0x0C(r1)
cmpw r3, r28
li r3, 0
bne .getActiveEntryFromGalaxyInfo_Return
li r3, 1
b .getActiveEntryFromGalaxyInfo_Return



.getActiveEntryFromGalaxyInfo_CheckInt:
#Mode 1 = Return Param00Int (on the entry with a matching string)
cmpwi r28, 0
beq .SkipStringCheck

addi r3, r1, 0x0C
mr r4, r31
lis r5, Param00Str@ha
addi r5, r5, Param00Str@l
mr r6, r26
bl getCsvDataStrOrNULL__2MRFPPCcPC8JMapInfoPCcl

lwz r3, 0x0C(r1)
mr r4, r28
bl isEqualString__2MRFPCcPCc
cmpwi r3, 0
beq .getActiveEntryFromGalaxyInfo_LoopContinue

.SkipStringCheck:
mr r3, r31
mr r4, r26
bl isJMapEntryProgressComplete
cmpwi r3, 0
beq .getActiveEntryFromGalaxyInfo_LoopContinue

addi r3, r1, 0x0C
mr r4, r31
lis r5, Param00Int@ha
addi r5, r5, Param00Int@l
mr r6, r26
bl getCsvDataS32__2MRFPlPC8JMapInfoPCcl
lwz r3, 0x0C(r1)
b .getActiveEntryFromGalaxyInfo_Return

.getActiveEntryFromGalaxyInfo_CheckStr:
#Mode 2 = Return Param00Str (on the entry with a matching int)
addi r3, r1, 0x0C
mr r4, r31
lis r5, Param00Int@ha
addi r5, r5, Param00Int@l
mr r6, r26
bl getCsvDataS32__2MRFPlPC8JMapInfoPCcl

lwz r3, 0x0C(r1)
cmpw r3, r28
bne .getActiveEntryFromGalaxyInfo_LoopContinue

addi r3, r1, 0x0C
mr r4, r31
lis r5, Param00Str@ha
addi r5, r5, Param00Str@l
mr r6, r26
bl getCsvDataStrOrNULL__2MRFPPCcPC8JMapInfoPCcl

lwz r3, 0x0C(r1)
b .getActiveEntryFromGalaxyInfo_Return


.getActiveEntryFromGalaxyInfo_LoopContinue:
addi r26, r26, 1
.getActiveEntryFromGalaxyInfo_LoopStart:
cmpw r26, r27
blt .getActiveEntryFromGalaxyInfo_Loop
#well, if we get here, then there was no suitable entry found.
li r3, 0  #returns False, NullPtr, and 0



.getActiveEntryFromGalaxyInfo_Return:
addi      r11, r1, 0x70
bl        _restgpr_26
lwz       r0, 0x74(r1)
mtlr      r0
addi      r1, r1, 0x70
blr


#========================================================================================


#GameSequenceFunction::getPowerStarColour((bool *))
.GameSequenceFunction_getPowerStarColor:
stwu      r1, -0x20(r1)
mflr      r0
stw       r0, 0x24(r1)
addi      r11, r1, 0x20
bl        _savegpr_27
mr        r27, r3
bl        getClearedStageName__20GameSequenceFunctionFv
mr        r31, r3
bl        getClearedPowerStarId__20GameSequenceFunctionFv
mr        r4, r3
li r3, 0
mr r5, r27
mr r6, r31
li r7, 1
bl PowerStar_getColorInStage
addi      r11, r1, 0x20
bl        _restgpr_27
lwz       r0, 0x24(r1)
mtlr      r0
addi      r1, r1, 0x20
blr
.GLE PRINTADDRESS

.InitMapToolInfo:
mr r3, r30
lwz r4, 0x90(r30)
addi r5, r1, 0x08
li r6, 0
li r7, 0
bl PowerStar_getColorInStage

lbz r4, 0x08(r1)
cmpwi r4, 1
beq .NoCol

.GetStarCol:
stw r3, 0x130(r30)
b .ReturnInitMapToolInfo

.NoCol:
li r3, 4
stw r3, 0x130(r30)
b .ReturnInitMapToolInfo

.GLE ADDRESS initMapToolInfo__9PowerStarFRC12JMapInfoIter
stwu      r1, -0x20(r1)
mflr      r0
stw       r0, 0x24(r1)
stw       r31, 0x1C(r1)
stw       r30, 0x18(r1)
mr        r31, r4
.GLE ENDADDRESS

.GLE ADDRESS initMapToolInfo__9PowerStarFRC12JMapInfoIter +0xA8
b .InitMapToolInfo
.GLE ENDADDRESS

.GLE ADDRESS initMapToolInfo__9PowerStarFRC12JMapInfoIter +0x118
.ReturnInitMapToolInfo:
lwz       r0, 0x24(r1)
lwz       r31, 0x1C(r1)
lwz       r30, 0x18(r1)
mtlr      r0
addi      r1, r1, 0x20
blr
.GLE ENDADDRESS

.GLE ADDRESS setupColor__9PowerStarFPC7NameObjl +0x44
bl PowerStar_getColorInDemo
.GLE ENDADDRESS

.GLE ADDRESS requestPointLight__9PowerStarFPC9LiveActorPC7NameObjl +0x3C
bl PowerStar_getColorInDemo
.GLE ENDADDRESS

.GLE ADDRESS setupColorAtResultSequence__9PowerStarFP9LiveActorb +0x28
bl .GameSequenceFunction_getPowerStarColor
.GLE ENDADDRESS

.GLE ADDRESS requestPointLightAtResultSequence__9PowerStarFPC9LiveActor +0x18
bl .GameSequenceFunction_getPowerStarColor
.GLE ENDADDRESS


GetBTPFrameOverride:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)

mr r4, r3
li r3, 0
li r5, 0
li r6, 0
li r7, 0
bl PowerStar_getColorInStage

.loc_802DFC30:
lwz       r0, 0x14(r1)
lwz       r31, 0x0C(r1)
mtlr      r0
addi      r1, r1, 0x10
blr


.GLE PRINTMESSAGE EndWorldmapCode
.GLE PRINTADDRESS
.SCENARIO_UTILITY_LINK:
.GLE ENDADDRESS
#End of the worldmap usage for now

.GLE ADDRESS getBtpFrameCurrentStage__9PowerStarFl
b GetBTPFrameOverride
.GLE ENDADDRESS


#========================================================================================

.GLE ADDRESS start__13ScenarioTitleFv -0x04
.ScenarioTitle_Start:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
mr        r31, r3

bl .isStageNoScenarioTitle
cmpwi r3, 0
bne .ScenarioTitle_Start_Return
mr r3, r31

lwz       r12, 0(r3)
lwz       r12, 0x2C(r12)
mtctr     r12
bctrl
mr        r3, r31
addi      r4, r13, (unk_807D57D8 - STATIC_R13)
bl        setNerve__11LayoutActorCFPC5Nerve

.ScenarioTitle_Start_Return:
lwz       r0, 0x14(r1)
lwz       r31, 0x0C(r1)
mtlr      r0
addi      r1, r1, 0x10
blr

.GLE ASSERT end__13ScenarioTitleFv
.GLE ENDADDRESS

.GLE ADDRESS exeRailMove__15ScenarioStarterFv +0x158
bl .ScenarioTitle_Start
.GLE ENDADDRESS

.GLE ADDRESS exePlay__35GameSceneScenarioOpeningCameraStateFv +0x24
bl .ScenarioTitle_Start
.GLE ENDADDRESS

#========================================================================================


.GLE ADDRESS makeBeginScenarioDataIter__2MRFP16ScenarioDataIter
#MR::makeBeginScenarioDataIter((void))
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
mr        r31, r3
bl getScenarioDataParser__20ScenarioDataFunctionFv
stw      r3, 0x04(r31)
li r4, 0
stw r4, 0x00(r31)
stw r4, 0x08(r31)
mr r3, r31

lwz       r0, 0x14(r1)
lwz       r31, 0x0C(r1)
mtlr      r0
addi      r1, r1, 0x10
blr
.GLE ENDADDRESS

#ScenarioDataIter::goNext2((void))
.GLE ADDRESS goNext2__16ScenarioDataIterFv
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)

mr        r31, r3
bl isEnd__16ScenarioDataIterCFv
cmpwi     r3, 0
bne       .loc_804CBCC8
lwz       r3, 8(r31)
addi      r0, r3, 1
stw       r0, 8(r31)

.loc_804CBCC8:

lwz       r0, 0x14(r1)
lwz       r31, 0x0C(r1)
mtlr      r0
addi      r1, r1, 0x10
blr
.GLE ENDADDRESS

.GLE ADDRESS sub_804E19F0
li r3, 0
blr
.GLE ENDADDRESS

.GLE ADDRESS sub_804E6820
blr
.GLE ENDADDRESS

.GLE ADDRESS sub_804D88F0
blr
.GLE ENDADDRESS


#========================================================================================


#===== Grand Stars =====
.GLE ADDRESS GrandStar_StringLoc
Grand_String:
    .string "Grand" AUTO
.GLE ENDADDRESS

.GLE ADDRESS isGrandStar__13GameDataConstFPCcl
stwu      r1, -0x20(r1)
mflr      r0
stw       r0, 0x24(r1)
stw       r31, 0x1C(r1)
cmpwi r4, -1
ble .isGrandStarAtResultSequence_End

mr r31, r4
bl makeGalaxyStatusAccessor__2MRFPCc
stw       r3, 0x08(r1)
addi      r3, r1, 0x08
mr r4, r31
bl IsGrandStar
#GalaxyStatusAccessor::isPowerStarGreen((long))
#but we changed it to GalaxyStatusAccessor::isPowerStarGrand((long))
#NOTE: The function is offset by 4 because I moved it down

.isGrandStarAtResultSequence_End:
lwz       r31, 0x1C(r1)
lwz       r0, 0x24(r1)
mtlr      r0
addi      r1, r1, 0x20
blr
.GLE ENDADDRESS

.GLE ADDRESS isGreenStar__20GalaxyStatusAccessorCFl
IsGreenStar:
#Removed.
li r3, 0
blr

IsGrandStar:
lwz       r3, 0(r3)
b isPowerStarTypeGreen__12ScenarioDataCFl
.GLE ENDADDRESS

.GLE ADDRESS hasGrandStar__14GameDataHolderCFi +0x24
nop
.GLE ENDADDRESS

#===== Seeker Stars =====

.GLE ADDRESS getGreenStarMainScenario__2MRFPCcl
#MR::isPowerStarSeeker
.MR_isPowerStarSeeker:
stwu      r1, -0x20(r1)
mflr      r0
stw       r0, 0x24(r1)
stw       r31, 0x1C(r1)
cmpwi r4, -1
ble .isPowerStarSeeker_End

mr r31, r4
bl makeGalaxyStatusAccessor__2MRFPCc
stw       r3, 0x08(r1)
addi      r3, r1, 0x08
mr r4, r31
bl .GalaxyStatusAccessor_isPowerStarSeeker

.isPowerStarSeeker_End:
lwz       r31, 0x1C(r1)
lwz       r0, 0x24(r1)
mtlr      r0
addi      r1, r1, 0x20
blr
.GLE ENDADDRESS

.GLE ADDRESS getNormalPowerStarNum__12ScenarioDataCFv +0x40
li r3, 0
.GLE ENDADDRESS

.GLE ADDRESS getGreenStarNum__20GalaxyStatusAccessorCFv
li r3, 0
blr
.GLE ENDADDRESS

.GLE ADDRESS isStarHiddenOrGreen__20GalaxyStatusAccessorCFv +0x38
bl .ScenarioData_isPowerStarSeeker
.GLE ENDADDRESS

#GalaxyStatusAccessor::getGreenStarNum(const(void))
#function removal is above Seeker Star section.

.GLE ADDRESS getGreenStarNumOwned__20GalaxyStatusAccessorCFv
li r3, 0
blr

#GalaxyStatusAccessor::isPowerStarSeeker((long))
.GalaxyStatusAccessor_isPowerStarSeeker:
lwz       r3, 0(r3)
b .ScenarioData_isPowerStarSeeker

#ScenarioData::isPowerStarSeeker
.ScenarioData_isPowerStarSeeker:
stwu      r1, -0x20(r1)
mflr      r0
stw       r0, 0x24(r1)

li        r0, 0
stw       r0, 0x08(r1)

mr        r5, r4
lis       r4, PowerStarType@ha
addi      r4, r4, PowerStarType@l
addi      r6, r1, 0x08
bl        getScenarioString__12ScenarioDataFPCclPPCc
lwz       r3, 0x08(r1)
lis       r4, Seeker@ha
addi      r4, r4, Seeker@l
bl        isEqualString__2MRFPCcPCc

lwz       r0, 0x24(r1)
mtlr      r0
addi      r1, r1, 0x20
blr
.GLE ENDADDRESS

.GLE ADDRESS getPlacedHiddenStarScenarioNo__2MRFPCcl +0x34
bl .GalaxyStatusAccessor_isPowerStarSeeker
.GLE ENDADDRESS

.GLE ADDRESS initStarInfoTableAfterPlacement__20PowerStarEventKeeperFv +0xA8
#Remove the 120 ending flag as a requirement. Users can just use Star Unlocks to do this.
li r3, 1
.GLE ENDADDRESS

.GLE ADDRESS isPowerStarGreenInCurrentStage__2MRFv +0x2C
bl .MR_isPowerStarSeeker
.GLE ENDADDRESS

# Seeker star colour change removals
.GLE ADDRESS changeColour__11CinemaFrameFv +0x28
#branch forward
b 0x9C
.GLE ENDADDRESS

.GLE ADDRESS init__16CometEventKeeperFv +0xF0
li r3, 0
.GLE ENDADDRESS

.GLE ADDRESS setColor__12WipeGameOverFP11LayoutActor
blr
.GLE ENDADDRESS

.GLE ADDRESS setColor__9WipeKoopaFP11LayoutActor
blr
.GLE ENDADDRESS

.GLE ADDRESS sub_804A83A0
blr
.GLE ENDADDRESS



.GLE ADDRESS sub_804E8E30
#no idea what this function does but it can crash the AllStarList so away it goes!
li r3, 1
blr
.GLE ENDADDRESS


.GLE ADDRESS ScenarioEngineStringTable
RequireScenarioName_Format:
    .string "RequireScenarioName%d"
    
GalaxyScenario_Format:
    .string "%s %d"
    
Invert:
    .string "Invert"
    
PowerStarNum:
    .string "PowerStarNum"

FlagName_Format:
    .string "FlagName%d"
    
EventValueName_Format:
    .string "EventValueName%d"

EventValue_Format:
    .string "EventValue%d"
    
RegisterFile:
    .string "/ScenarioData/%s.reg"
    
Type:
    .string "Type"
    
Param00Int:
    .string "Param00Int"
    
Param00Str:
    .string "Param00Str"
    
LuigiMode:
    .string "LuigiModeTimer"
    
Seeker:
    .string "Seeker"
    
StarMask:
    .string "Mask" 
    
SelectBgm:
    .string "SelectBgm" 
    
CometMedalStatus:
    .string "NoTicoCoin" AUTO
    
#.GLE ASSERT 0x807023D0
#Unlock string is in ScenarioSelect's strings