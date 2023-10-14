.GLE ADDRESS .GAME_EVENT_VALUE_CHECKER_CONNECTOR
#A new feature that lets you enable special storage for silver star collection.
#Intended to be used for Hubworlds

.GLE ADDRESS init__11CollectTicoFRC12JMapInfoIter +0x5C
#0xF8 is now the Index for save data storage
li r3, 0xFC
.GLE ENDADDRESS



.GLE ADDRESS init__11CollectTicoFRC12JMapInfoIter +0x94
b .StrayTico_TrySpawnForceFromStorage
.StrayTico_TrySpawnForceFromStorage_JumpLoc:
.GLE ENDADDRESS

#If something external has already activated SW_A on this silver star, then we can skip it
.StrayTico_TrySpawnForceFromStorage:
lwz       r3, 0x94(r27)
lwzx      r3, r3, r31
stw r29, 0xF8(r3) #Store the new index
bl isOnSwitchA__2MRFPC9LiveActor
cmpwi r3, 0
bne .StrayTico_TrySpawnForceFromStorage_Return

#"""""inline function"""""
stwu      r1, -0x140(r1)

addi r3, r1, 0x08
li r4, 0x120
mr r5, r29
bl .GLE_CreateStrayTicoStorageId_CurrentGalaxy

addi r3, r1, 0x08
bl .GLE_IsExistGameEventValue
cmpwi r3, -1
#If there is no field for this silver star, then just continue as normal
beq .StrayTico_TrySpawnForceFromStorage_ReturnAlt

#If there IS a field, then we should get the value for it. If it is greater than Zero, the silver star will be collected
bl getGameEventValueChecker__16GameDataFunctionFv
addi r4, r1, 0x08
bl getValue__21GameEventValueCheckerCFPCc
cmpwi r3, 0
beq .StrayTico_TrySpawnForceFromStorage_ReturnAlt

#Okay, if we're here, we need to "collect" the silver star
lwz       r3, 0x94(r27)
lwzx      r3, r3, r31
stw r3, 0x08(r1)
bl isValidSwitchAppear__2MRFPC9LiveActor
cmpwi r3, 0
beq .StrayTico_TrySpawnForceFromStorage_SkipInvalidate

#Watch this insane play
li r4, -2
lwz r3, 0x08(r1)
lwz r3, 0x84(r3)
lwz r3, 0x08(r3)
lwz r3, 0x00(r3)
stw r4, 0x00(r3)

.StrayTico_TrySpawnForceFromStorage_SkipInvalidate:
lwz r3, 0x08(r1)
addi r4, r13, sInstance__Q212NrvStrayTico17StrayTicoNrvChase - STATIC_R13
bl setNerve__9LiveActorFPC5Nerve

lwz r3, 0x08(r1)
lwz r12, 0(r3)
lwz r12, 0x30(r12)
mtctr r12
bctrl  #LiveActor::makeActorAppeared((void))

#Kill the bubble lol
lwz r3, 0x08(r1)
lwz       r3, 0x94(r3)
lwz       r12, 0(r3)
lwz       r12, 0x34(r12)
mtctr     r12
bctrl

bl getPlayerCenterPos__2MRFv
mr r4, r3
lwz r3, 0x08(r1)
addi r3, r3, 0x14
bl __as__Q29JGeometry8TVec3<f>FRCQ29JGeometry8TVec3<f>

lwz r3, 0x08(r1)
bl        onCalcGravity__2MRFP9LiveActor

lwz r3, 0x08(r1)
li        r4, 0
bl        onCalcShadow__2MRFP9LiveActorPCc

lwz r3, 0x08(r1)
bl        onBind__2MRFP9LiveActor

lwz r3, 0x08(r1)
bl invalidateClipping__2MRFP9LiveActor

lwz r3, 0x08(r1)
lis r4, StrayTico_Body@ha
addi r4, r4, StrayTico_Body@l
bl validateHitSensor__2MRFP9LiveActorPCc

lwz r3, 0x08(r1)
lis r4, StrayTico_Bubble@ha
addi r4, r4, StrayTico_Bubble@l
bl invalidateHitSensor__2MRFP9LiveActorPCc

lwz r3, 0x08(r1)
bl isValidSwitchA__2MRFPC9LiveActor
cmpwi r3, 0
beq .StrayTico_TrySpawnForceFromStorage_ReturnAlt

lwz r3, 0x08(r1)
bl onSwitchA__2MRFP9LiveActor

.StrayTico_TrySpawnForceFromStorage_ReturnAlt:
#I hope this discards the string...
addi      r1, r1, 0x140

.StrayTico_TrySpawnForceFromStorage_Return:
addi      r29, r29, 1
b .StrayTico_TrySpawnForceFromStorage_JumpLoc



.GLE ADDRESS exeGlad__9StrayTicoFv +0x38
b .StrayTico_SetCollectedFlag
.StrayTico_SetCollectedFlag_JumpLoc:
.GLE ENDADDRESS

.StrayTico_SetCollectedFlag:
stwu      r1, -0x140(r1)

addi r3, r1, 0x08
li r4, 0x120
lwz r5, 0xF8(r28)
bl .GLE_CreateStrayTicoStorageId_CurrentGalaxy

addi r3, r1, 0x08
bl .GLE_IsExistGameEventValue
cmpwi r3, -1
#If there is no field for this silver star, then just continue as normal
beq .StrayTico_SetCollectedFlag_Return

bl getGameEventValueChecker__16GameDataFunctionFv
addi r4, r1, 0x08
li r5, 1
bl setValue__21GameEventValueCheckerFPCcUs


.StrayTico_SetCollectedFlag_Return:
addi      r1, r1, 0x140

lwz       r3, 0x90(r28)
b .StrayTico_SetCollectedFlag_JumpLoc




#This works similar to Mario Maker. Once the key spawns, the red coins are reset.
.GLE ADDRESS exeCompleteDemo__9StrayTicoFv +0x4C
b .StrayTico_ResetFlag
.StrayTico_ResetFlag_JumpLoc:
.GLE ENDADDRESS

.StrayTico_ResetFlag:
stwu      r1, -0x140(r1)

addi r3, r1, 0x08
li r4, 0x120
lwz r5, 0xF8(r31)
bl .GLE_CreateStrayTicoStorageId_CurrentGalaxy

addi r3, r1, 0x08
bl .GLE_IsExistGameEventValue
cmpwi r3, -1
#If there is no field for this silver star, then just continue as normal
beq .StrayTico_ResetFlag_Return

bl getGameEventValueChecker__16GameDataFunctionFv
addi r4, r1, 0x08
li r5, 0
bl setValue__21GameEventValueCheckerFPCcUs

.StrayTico_ResetFlag_Return:
addi      r1, r1, 0x140

mr        r3, r31
b .StrayTico_ResetFlag_JumpLoc

#r3 = const char* Destination
#r4 = Destination Length
#r5 = Silver Star ID
.GLE_CreateStrayTicoStorageId_CurrentGalaxy:
stwu      r1, -0x20(r1)
mflr      r0
stw       r0, 0x24(r1)
addi r11, r1, 0x20
bl _savegpr_28

mr r31, r3
mr r30, r4
mr r29, r5

bl getCurrentStageName__2MRFv
mr r28, r3

bl getCurrentScenarioNo__2MRFv
mr r6, r3

mr r3, r31
mr r4, r30
mr r5, r28
#6 would be here if I didn't need r3 earlier
mr r7, r29
bl .GLE_CreateStrayTicoStorageId

addi r11, r1, 0x20
bl _restgpr_28
lwz       r0, 0x24(r1)
mtlr      r0
addi      r1, r1, 0x20
blr

#r3 = const char* Destination
#r4 = Size
#r5 = GalaxyName
#r6 = ScenarioNo
#r7 = Silver Star ID
.GLE_CreateStrayTicoStorageId:
mr r8, r7
mr r7, r6
mr r6, r5
lis r5, CollectTico_EventValue_Format@ha
addi r5, r5, CollectTico_EventValue_Format@l
crclr     4*cr1+eq
b       snprintf

#%s = Galaxy Name
#%d = Scenario
#%d = Silver star ID
CollectTico_EventValue_Format:
    .string "StrayTico[%s%d_%d]"
    
StrayTico_Body:
    .string "Body" 
    
StrayTico_Bubble:
    .string "Bubble" AUTO

.COLLECTTICO_CONNECTOR:
.GLE ENDADDRESS