#Save points replace the Sequence Value
#Each save point must have a unique ID

.GLE ADDRESS initializeData__23GameDataWorldMapStorageFv +0x20
li r0, 0 #Set the save point ID to 0.
#This value used to be the Current WorldID
.GLE ENDADDRESS




.GLE ADDRESS requestChangeStageInGameAfterLoadingGameData__2MRFv
li r3, 0
.RequestChangeStageAfterGameOver_JumpLoc:
stwu r1, -0x30(r1)
mflr r0
stw r0, 0x34(r1)
addi r11, r1, 0x30
bl _savegpr_25

mr r25, r3
bl .MR_GetGameSequenceProgress
bl setStateInStage__20GameSequenceProgressFv
bl initlizeInGameActorState__2MRFv

lwz       r3, sInstance__29SingletonHolder_10GameSystem_ - STATIC_R13(r13)
lwz       r3, 0x34(r3)
lwz       r31, 0x4(r3) #Get pointer to SavePointList.bcsv

#The current world variable was replaced by our Save point ID
bl getCurrentWorldId__16GameDataFunctionFv
mr r5, r3
mr r3, r31
lis r4, id@ha
addi r4, r4, id@l
li r6, 0
bl findElement<l>__8JMapInfoCFPCcli_12JMapInfoIter
mr r30, r4
mr r3, r31
bl getCsvDataElementNum__2MRFPC8JMapInfo
cmpw r30, r3
blt .RequestChangeStageAfterTitle_NoError
#We don't know where to send you, so lets send you *back* to the title screen
bl notifyToGameSequenceProgressToEndScene__20GameSequenceFunctionFv
b .RequestChangeStageAfterTitle_Return

.RequestChangeStageAfterTitle_NoError:
#well now we just use our standard goto stage from BCSV function
mr r3, r31
mr r4, r30
mr r5, r25
bl .MR_RequestMoveStageFromJMapInfo_WithReset

#Now lets tick the flag to have the hubworld arrival cutscene play
#It won't be played if it doesn't exist, so don't worry about that
bl getGameSequenceInGame__20GameSequenceFunctionFv
bl getScenePlayingResultMarioFaceShip__16InGameActorStateFv
li r0, 1
stb r0, 0x12(r3)

.RequestChangeStageAfterTitle_Return:
bl .GLE_SetHealthToDefault

addi      r11, r1, 0x30
bl _restgpr_25
lwz       r0, 0x34(r1)
mtlr      r0
addi      r1, r1, 0x30
blr
.GLE ENDADDRESS

#Here's where the game saves your location id to your save data

.GLE ADDRESS serialize__23GameDataWorldMapStorageCFPUcUl
b GameDataWorldMapStorage_Extension
GameDataWorldMapStorage_Extension_Return:
.GLE ENDADDRESS

.GLE ADDRESS sub_804FA1D0
blr  #Another static initilizer

GameDataWorldMapStorage_Extension:
stwu r1, -0x60(r1)
mflr r0
stw r0, 0x64(r1)
addi r11, r1, 0x60
bl _savegpr_22

mr r22, r3
mr r23, r4
mr r24, r5

lwz       r3, sInstance__29SingletonHolder_10GameSystem_ - STATIC_R13(r13)
lwz       r3, 0x34(r3)
lwz       r31, 0x4(r3) #Get pointer to SavePointList.bcsv

li r30, 0
b .SavePointCheck_Loop_Start

.SavePointCheck_Loop:
#YES This BCSV *Technically* supports progression checks too...
mr r3, r31
mr r4, r30
bl isJMapEntryProgressComplete
cmpwi r3, 0
beq .SavePointCheck_Loop_Continue

addi r3, r1, 0x08
mr r4, r31
lis r5, GalaxyName@ha
addi r5, r5, GalaxyName@l
mr r6, r30
bl getCsvDataStr__2MRFPPCcPC8JMapInfoPCcl

lwz r3, 0x08(r1)
bl isEqualStageName__2MRFPCc
cmpwi r3, 0
beq .SavePointCheck_Loop_Continue


addi r3, r1, 0x08
mr r4, r31
lis r5, ScenarioNo@ha
addi r5, r5, ScenarioNo@l
mr r6, r30
bl getCsvDataS32__2MRFPlPC8JMapInfoPCcl

bl getCurrentSelectedScenarioNo__2MRFv
lwz r4, 0x08(r1)
cmpw r3, r4
bne .SavePointCheck_Loop_Continue

addi r3, r1, 0x08
mr r4, r31
lis r5, EntireLevelFlag@ha
addi r5, r5, EntireLevelFlag@l
mr r6, r30
bl getCsvDataU8__2MRFPUcPC8JMapInfoPCcl
lbz r3, 0x08(r1)
cmpwi r3, 0
#Skip the ZoneName, and MarioNo checks if the flag is true.
bne .SaveFound

addi r3, r1, 0x08
mr r4, r31
lis r5, ZoneName@ha
addi r5, r5, ZoneName@l
mr r6, r30
bl getCsvDataStrOrNULL__2MRFPPCcPC8JMapInfoPCcl

lwz r3, 0x08(r1)
cmpwi r3, 0
beq .SavePointCheck_SkipZone

bl getZoneIdFromZoneName__2MRFPCc

.SavePointCheck_SkipZone:
mr r29, r3

bl getRespawnPoint__2MRFv
mr r28, r3
lwz r3, 0x04(r28)
cmpw r3, r29
bne .SavePointCheck_Loop_Continue

addi r3, r1, 0x08
mr r4, r31
lis r5, MarioNo@ha
addi r5, r5, MarioNo@l
mr r6, r30
bl getCsvDataS32__2MRFPlPC8JMapInfoPCcl

lwz r3, 0x08(r1)
lwz r4, 0x00(r28)
cmpw r3, r4
bne .SavePointCheck_Loop_Continue


.SaveFound:
#If we are here, a save point has been found.
addi r3, r1, 0x08
mr r4, r31
lis r5, id@ha
addi r5, r5, id@l
mr r6, r30
bl getCsvDataU8__2MRFPUcPC8JMapInfoPCcl

lbz r3, 0x08(r1)
bl setCurrentWorld__2MRFl
b .SavePointCheck_Loop_Break

.SavePointCheck_Loop_Continue:
addi r30, r30, 1

.SavePointCheck_Loop_Start:
mr r3, r31
bl getCsvDataElementNum__2MRFPC8JMapInfo
cmpw r30, r3
blt .SavePointCheck_Loop


.SavePointCheck_Loop_Break:

#Jump to here if no save point is found
.SavePointCheck_Return:

mr r3, r22
mr r4, r23
mr r5, r24 

addi      r11, r1, 0x60
bl _restgpr_22
lwz       r0, 0x64(r1)
mtlr      r0
addi      r1, r1, 0x60

stwu      r1, -0x30(r1)
b GameDataWorldMapStorage_Extension_Return

EntireLevelFlag:
    .string "EntireLevelFlag" AUTO

.GLE ENDADDRESS