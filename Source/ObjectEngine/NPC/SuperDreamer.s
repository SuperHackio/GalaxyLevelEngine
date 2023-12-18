#Change a value from a bool to an int. (the other bytes aren't in use by anything anyways)

.GLE ADDRESS __ct__23PlayResultInStageHolderFv +0xA0
stw r5, 0x88(r29)  #changing this to be a bitfield. If a bit is set, that star is now bronze
.GLE ENDADDRESS


.GLE ADDRESS createNameObj<12SuperDreamer>__14NameObjFactoryFPCc_P7NameObj +0x14
li        r3, 0x1E8   #We just need a bit more for the new Obj Arg 7
.GLE ENDADDRESS


.GLE ADDRESS sub_804D7EE0
#r3 = Power Star Id
.MR_IsSuperDreamerStarBronze:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)

subi r4, r3, 1
bl .GLE_GetPlayResultInStageHolder
lwz r3, 0x88(r3)
sraw r4, r3, r4
rlwinm r3, r4, 0, 31, 31

lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr
.GLE ASSERT sub_804D7EE0 +0x30
.GLE ENDADDRESS


.GLE ADDRESS reset__23PlayResultInStageHolderFv +0xAC
#Clear the bronze star flags upon reset
stw       r31, 0x88(r30)
.GLE ENDADDRESS


.GLE ADDRESS clearAfterMiss__23PlayResultInStageHolderFv +0x30
#Clear the bronze star flags after death
stw       r5, 0x88(r3)
.GLE ENDADDRESS


.GLE ADDRESS setPadModeSuperDreamer__23PlayResultInStageHolderFv
#r3 = PlayResultInStageHolder*
#r4 = int "SuperDreamer new Obj Arg 7"
.GLE_InitPlayResultSuperDreamer:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)

mr        r31, r3

lwz r5, 0x88(r31)
or r5, r4, r5  #Update the stars flag
stw r5, 0x88(r31)

li r5, 2
stw r5, 0x84(r31)

li r0, 0
stb r0, 0x74(r31)

bl getPlayerLife__2MRFv
cmpwi     r3, 3
li        r0, 3
ble       loc_804C93B0
li        r0, 6

loc_804C93B0:
stw       r0, 0x78(r31)

lwz       r31, 0x0C(r1)
lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr
#.GLE ASSERT 0x804C93D0
.GLE ENDADDRESS


.GLE ADDRESS sub_804D7C40
#Just gonna replace this completely even though it's just vanilla code still
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
stw       r30, 0x08(r1)
mr        r31, r4
mr        r30, r3
bl .GLE_GetPlayResultInStageHolder
lwz r4, 0x1E4(r30)
bl        .GLE_InitPlayResultSuperDreamer
mr        r3, r30
mr        r4, r31
bl        requestChangeStageDreamer__2MRFP7UNKNOWNl
lwz       r0, 0x14(r1)
lwz       r31, 0x0C(r1)
lwz       r30, 0x08(r1)
mtlr      r0
addi      r1, r1, 0x10
blr
.GLE ENDADDRESS


.GLE ADDRESS .NPC_UTILITY_CONNECTOR


.GLE ADDRESS init__12SuperDreamerFRC12JMapInfoIter +0x90
b .SuperDreamer_Init_ReadArg7
.SuperDreamer_Init_ReadArg7_Return:
.GLE ENDADDRESS

.SuperDreamer_Init_ReadArg7:
bl getJMapInfoArg0NoInit__2MRFRC12JMapInfoIterPl

#Brand new Arg 7 will determine which stars get turned to bronze. Default -1 for "All Stars
li r5, -1
stw r5, 0x1E4(r29)

mr        r3, r30
addi      r4, r29, 0x1E4
bl getJMapInfoArg7NoInit__2MRFRC12JMapInfoIterPl
b .SuperDreamer_Init_ReadArg7_Return


.GLE ADDRESS initForNpc__12SuperDreamerFRC12JMapInfoIter +0x88
b .SuperDreamer_RegisterDemo
.SuperDreamer_RegisterDemo_Return:
.GLE ENDADDRESS

.SuperDreamer_RegisterDemo:
bl registerEventFunc__2MRFP15TalkMessageCtrlRC19TalkMessageFuncBase
mr        r3, r29
mr        r4, r30
bl tryRegisterDemoCast__2MRFP9LiveActorRC12JMapInfoIter
b .SuperDreamer_RegisterDemo_Return


.GLE ADDRESS endStage__18ScenePlayingResultFv +0x44
bl .__endStage_IsStarBronze
.GLE ENDADDRESS

.GLE ADDRESS endStage__18ScenePlayingResultFv +0x80
bl .__endStage_IsStarBronze
.GLE ENDADDRESS

.GLE ADDRESS endStage__18ScenePlayingResultFv +0xC8
bl .__endStage_IsStarBronze
.GLE ENDADDRESS


.__endStage_IsStarBronze:
subi r4, r28, 1
lwz r3, 0x88(r27)

#r3 = Flags value
#r4 = PowerStarID
.__Decide_IsBronze:
sraw r4, r3, r4
rlwinm r3, r4, 0, 31, 31
mr r0, r3   #The game wants it in r0 each time phew
blr




.GLE ADDRESS sub_804D8690 +0x70
bl .__sub_804D8690_SetStarBronze
.GLE ENDADDRESS

.__sub_804D8690_SetStarBronze:
subi r4, r28, 1
lwz r3, 0x88(r30)
b .__Decide_IsBronze

#---------------------------------------------------
#Also make it so that ObjArg0 not only doubles as Spawn ID and Dreamer file ID, but also now TRIPLES to also include being the Save Data selector. It only makes sense!
.GLE ADDRESS isMakeAppear__12SuperDreamerCFv +0xA4
b .GLE_SuperDreamer_isMakeAppearEX
.GLE_SuperDreamer_isMakeAppearEX_Return:
.GLE ENDADDRESS

.GLE_SuperDreamer_isMakeAppearEX:
cmpwi r3, 0
#if Zero deaths required, just spawn in without bothering
beq .GLE_SuperDreamer_isMakeAppearEX_JumpLoc

lwz       r3, 0x16C(r30)
bl .GLE_isExistDreamerDeadCountFromStorage
cmpwi r3, -1
beq .GLE_SuperDreamer_isMakeAppearEX_JumpLoc2

lwz       r3, 0x16C(r30)
bl .GLE_getDreamerDeadCountFromStorage
lwz       r4, 0x170(r30)
cmpw r3, r4
bge .GLE_SuperDreamer_isMakeAppearEX_JumpLoc

.GLE_SuperDreamer_isMakeAppearEX_JumpLoc2:
li r3, 0
b .GLE_SuperDreamer_isMakeAppearEX_Return

.GLE_SuperDreamer_isMakeAppearEX_JumpLoc:
bl isAllowDreamerInStage__20GameSequenceFunctionFv
b .GLE_SuperDreamer_isMakeAppearEX_Return

#======================================================================================
#-- DreamerDeadCountArea Rework --

.set MAX_DREAMER_DEAD_COUNT_AREA, 32

.GLE ADDRESS cCreateTable__16AreaObjContainer +0x118
.int MAX_DREAMER_DEAD_COUNT_AREA
.GLE ENDADDRESS
#---------------------------------------------------
#Custom replacement for MR::incPlayerAndTryScenarioMissNum((bool))
.GLE_incPlayerAndTryScenarioMissNum:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)

mr        r31, r3

bl incPlayerMissNum__16GameDataFunctionFv
cmpwi r3, 0
beq .GLE_incPlayerAndTryScenarioMissNum_SkipToDebateLuigi
#not sure what this is for to be honest
cmpwi r31, 0
bne .GLE_incPlayerAndTryScenarioMissNum_SkipToDebateLuigi
#Now there's a bunch of stuff in vanilla that we don't need to do here
#for example, we do not need to do the hubworld check because you otherwise do not lose lives in the hubworld
#and besides, what if you did wanna put a SuperDreamer on a hubworld for some reason?

bl getPlayerPos__2MRFv
mr r4, r3
lis r3, DreamerDeadCountArea_ManagerName@ha
addi r3, r3, DreamerDeadCountArea_ManagerName@l
bl getAreaObj__2MRFPCcRCQ29JGeometry8TVec3<f>
cmpwi r3, 0
beq .GLE_incPlayerAndTryScenarioMissNum_SkipToDebateLuigi

#Okay! We died inside an area. Quickly check the ObjArg then set the value
lwz r31, 0x20(r3)
cmpwi r31, -1
beq .GLE_incPlayerAndTryScenarioMissNum_SkipToDebateLuigi

mr r3, r31
bl .GLE_getDreamerDeadCountFromStorage
addi r3, r3, 1
li r4, 0
li r5, 99
bl clamp__2MRFlll
mr r4, r3
mr r3, r31
bl .GLE_setDreamerDeadCountFromStorage

.GLE_incPlayerAndTryScenarioMissNum_SkipToDebateLuigi:
#Okay now I know the playable Luigi isn't properly implemented but I will put this here anyways for compatibility purposes
bl hasMissedInScene__2MRFv
cmpwi r3, 0
bne .GLE_incPlayerAndTryScenarioMissNum_Return
bl sub_804D31E0

.GLE_incPlayerAndTryScenarioMissNum_Return:
lwz       r0, 0x14(r1)
lwz       r31, 0x0C(r1)
mtlr      r0
addi      r1, r1, 0x10
blr

.GLE ADDRESS incPlayerAndTryScenarioMissNum__2MRFb
b .GLE_incPlayerAndTryScenarioMissNum
.GLE ENDADDRESS
#---------------------------------------------------
#r3 = ID
.GLE_isExistDreamerDeadCountFromStorage:
stwu      r1, -0x150(r1)
mflr      r0
stw       r0, 0x154(r1)
addi      r11, r1, 0x150
bl _savegpr_29

mr r31, r3

bl .GLE_GetCurrentStageName_Guarantee
mr r5, r3
mr r6, r31
addi r3, r1,0x0C
li r4, 0x110
bl .GLE_getDreamerDeadCountStorageName

addi r3, r1,0x0C
bl .GLE_IsExistGameEventValue

b .GLE_DreamerDeadCountFromStorage_SHARED
#addi      r11, r1, 0x150
#bl _restgpr_29
#lwz       r0, 0x154(r1)
#mtlr      r0
#addi      r1, r1, 0x150
#blr
#---------------------------------------------------
#r3 = ID
.GLE_getDreamerDeadCountFromStorage:
stwu      r1, -0x150(r1)
mflr      r0
stw       r0, 0x154(r1)
addi      r11, r1, 0x150
bl _savegpr_29

mr r31, r3

bl .GLE_GetCurrentStageName_Guarantee
mr r5, r3
mr r6, r31
addi r3, r1,0x0C
li r4, 0x110
bl .GLE_getDreamerDeadCountStorageName

bl getGameEventValueChecker__16GameDataFunctionFv
addi r4, r1,0x0C
bl getValue__21GameEventValueCheckerCFPCc

b .GLE_DreamerDeadCountFromStorage_SHARED
#addi      r11, r1, 0x150
#bl _restgpr_29
#lwz       r0, 0x154(r1)
#mtlr      r0
#addi      r1, r1, 0x150
#blr
#---------------------------------------------------
#r3 = ID
#r4 = value
.GLE_setDreamerDeadCountFromStorage:
stwu      r1, -0x150(r1)
mflr      r0
stw       r0, 0x154(r1)
addi      r11, r1, 0x150
bl _savegpr_29

mr r31, r3
mr r30, r4

bl .GLE_GetCurrentStageName_Guarantee
mr r5, r3
mr r6, r31
addi r3, r1,0x0C
li r4, 0x110
bl .GLE_getDreamerDeadCountStorageName

bl getGameEventValueChecker__16GameDataFunctionFv
addi r4, r1,0x0C
mr r5, r30
bl setValue__21GameEventValueCheckerFPCcUs

.GLE_DreamerDeadCountFromStorage_SHARED:
addi      r11, r1, 0x150
bl _restgpr_29
lwz       r0, 0x154(r1)
mtlr      r0
addi      r1, r1, 0x150
blr
#---------------------------------------------------
#r3 = Char* Dest
#r4 = int DestSize
#r5 = Const Char* StageName
#r6 = int ID
.GLE_getDreamerDeadCountStorageName:
mr r7, r6
mr r6, r5
lis       r5, DreamerDeadCount_EventValue_Format@ha
addi      r5, r5, DreamerDeadCount_EventValue_Format@l
crclr     4*cr1+eq
b       snprintf

DreamerDeadCount_EventValue_Format:
    .string "DreamerDeadCount[%s_%d]"

#======================================================================================





#I don't feel like making a new file for this
#GhostAttackGhost changes
#ObjArg1 = bool Use Alternate rendering/execution. Setting to true will use 2D water execution instead. All this does is make the model wobble a bit
#ObjArg7 = gst ID  (0xC4)


#Make more space for Arg7
.GLE ADDRESS createNameObj<16GhostAttackGhost>__14NameObjFactoryFPCc_P7NameObj +0x14
li r3, 0xC8
.GLE ENDADDRESS

.GLE ADDRESS init__16GhostAttackGhostFRC12JMapInfoIter +0x24
mr r3, r29
addi r4, r1, 0x08
bl getJMapInfoArg1NoInit__2MRFRC12JMapInfoIterPb
#free parking
nop
nop
nop
nop
nop
nop
nop
lbz r3, 0x08(r1)

#.GLE ASSERT 0x803493B0
.GLE ENDADDRESS


.GLE ADDRESS init__16GhostAttackGhostFRC12JMapInfoIter +0x104
mr r3, r29
addi r4, r28, 0xC4
li r5, 0
stw r5, 0x00(r4)
bl getJMapInfoArg7NoInit__2MRFRC12JMapInfoIterPl
nop
nop
lwz r3, 0xC4(r28)
.GLE ENDADDRESS


#Upgrade the manager to hold more ghosts!
.set GHOSTATTACKGHOST_MAX, 8
.set GHOSTATTACKGHOST_ARRAYOFFSET, 0x18
.set GHOSTATTACKGHOST_SCENEOBJ, 0x8E

#0x00 - VTable*
#0x04 - char const* mName
#0x08 - mFlags
#0x0A - mExecuteIdx
#0x0C - mLinkedInfo
#
#0x14 - mGhostNum
#GHOSTATTACKGHOST_ARRAYOFFSET - GhostAttackGhost[GHOSTATTACKGHOST_MAX]

.GLE ADDRESS newEachObj__14SceneObjHolderFi +0xDC0
li        r3, 0x18 + (GHOSTATTACKGHOST_MAX * 4)
.GLE ENDADDRESS


.GLE ADDRESS __ct__19GhostAttackAccessorFv
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
mr        r31, r3

lis       r4, GhostAttackGhostManager_JpName@ha
addi      r4, r4, GhostAttackGhostManager_JpName@l # "ゴーストアタック"
bl        __ct__7NameObjFPCc

lis       r3, __vt__19GhostAttackAccessor@ha
addi      r3, r3, __vt__19GhostAttackAccessor@l
stw       r3, 0(r31)

li        r0, 0
stw       r0, 0x14(r31)
b .GhostAttackGhostManager_InitGhostArray
.GhostAttackGhostManager_InitGhostArray_Return:

mr        r3, r31
lwz       r31, 0x0C(r1)
lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr
.GLE ENDADDRESS

.GhostAttackGhostManager_InitGhostArray:
stw       r30, 0x08(r1)

li r30, 0
addi r4, r31, GHOSTATTACKGHOST_ARRAYOFFSET
li r3, 0
b .GhostAttackGhostManager_InitGhostArray_LoopStart

.GhostAttackGhostManager_InitGhostArray_Loop:
stwx r3, r4, r30

.GhostAttackGhostManager_InitGhostArray_LoopContinue:
addi r30, r30, 4

.GhostAttackGhostManager_InitGhostArray_LoopStart:
cmpwi r30, GHOSTATTACKGHOST_MAX*4
blt+ .GhostAttackGhostManager_InitGhostArray_Loop

lwz       r30, 0x08(r1)
b .GhostAttackGhostManager_InitGhostArray_Return


.GLE ADDRESS registerGhostAttackGhost__2MRFP16GhostAttackGhost
#r3 = GhostAttackGhost*
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
mr        r31, r3

li        r3, GHOSTATTACKGHOST_SCENEOBJ
bl createSceneObj__2MRFi
mr r4, r31
bl .GhostAttackGhostManager_TryAddGhost

lwz       r31, 0x0C(r1)
lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr
.GLE ASSERT __dt__19GhostAttackAccessorFv
.GLE ENDADDRESS

#r3 = GhostAttackGhostManager*
#r4 = GhostAttackGhost*
.GhostAttackGhostManager_TryAddGhost:
lwz r5, 0x14(r3) #get the current ghost count
cmpwi r5, GHOSTATTACKGHOST_MAX
bgelr-
addi r6, r5, 1
stw r6, 0x14(r3) #update ghost count
slwi r5, r5, 2
addi r6, r3, GHOSTATTACKGHOST_ARRAYOFFSET
stwx r4, r6, r5
blr



#No parameters
.GLE_TryAppearAllGhost:
stwu      r1, -0x140(r1)
mflr      r0
stw       r0, 0x144(r1)
addi r11, r1, 0x140
bl _savegpr_23

li        r3, GHOSTATTACKGHOST_SCENEOBJ
bl isExistSceneObj__2MRFi
cmpwi r3, 0
beq .GLE_TryAppearAllGhost_Return

li        r3, GHOSTATTACKGHOST_SCENEOBJ
bl .GLE_GetSceneObj
mr r31, r3

li r30, 0
addi r29, r31, GHOSTATTACKGHOST_ARRAYOFFSET
bl getCurrentStageName__2MRFv
mr r28, r3
b .GLE_TryAppearAllGhost_LoopStart

.GLE_TryAppearAllGhost_Loop:
#For each Luigi, check if the ghost is open

#Load Luigi
slwi r3, r30, 2
lwzx r27, r29, r3

mr r3, r28
lwz r4, 0xC4(r27)
bl .GLE_isOpenGhostAttackGhost
cmpwi r3, 0
beq .GLE_TryAppearAllGhost_KillGhost

mr        r3, r27
lwz       r12, 0(r3)
lwz       r12, 0x30(r12)
mtctr     r12
bctrl  #Appear
b .GLE_TryAppearAllGhost_LoopContinue

.GLE_TryAppearAllGhost_KillGhost:
mr        r3, r27
lwz       r12, 0(r3)
lwz       r12, 0x38(r12)
mtctr     r12
bctrl  #Kill

.GLE_TryAppearAllGhost_LoopContinue:
addi r30, r30, 1
.GLE_TryAppearAllGhost_LoopStart:
lwz r3, 0x14(r31)
cmpw r30, r3
blt .GLE_TryAppearAllGhost_Loop


.GLE_TryAppearAllGhost_Return:
addi r11, r1, 0x140
bl _restgpr_23
lwz       r0, 0x144(r1)
mtlr      r0
addi      r1, r1, 0x140
blr


.SUPERDREAMER_CONNECTOR:
.GLE ENDADDRESS
