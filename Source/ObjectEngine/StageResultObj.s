#This object will let you spawn the Stage Results whenever you want


#Object Entry replaces SkyIslandPartsA. Just add it as a SimpleMapObj to the ProductMapObjDataTable
.GLE ADDRESS cCreateTable__14NameObjFactory +0x1590
.int .StageResultObj_ObjName
.int .StageResultObj_NEW
.GLE ENDADDRESS


.GLE ADDRESS cPostCreationTable__14NameObjFactory +0x80
#Replace GrandStarReturnDemoStarter. It's not used in the GLE anyways!
.int .StageResultObj_ObjName
.GLE ENDADDRESS

.GLE ADDRESS .END_OF_QUICKWARPAREA_CODE

.StageResultObj_NEW:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
mr        r31, r3
#LiveActor is 0x90 in size. I know that's not what's here but this is just a note soooo
li        r3, 0xA8
bl        __nw__FUl
cmpwi     r3, 0
beq       .StageResultObj_NEW_Return
mr        r4, r31
bl        .StageResultObj_Ctor

.StageResultObj_NEW_Return:
lwz       r0, 0x14(r1)
lwz       r31, 0x0C(r1)
mtlr      r0
addi      r1, r1, 0x10
blr

#-----------------------------------------------------

.StageResultObj_Ctor:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
mr        r31, r3

bl __ct__9LiveActorFPCc
lis       r4, .StageResultObj_VTable@ha
addi      r4, r4, .StageResultObj_VTable@l
stw       r4, 0x00(r31)

li r3, 0
stw r3, 0x90(r31) #StageResultInformer*
stw r3, 0x94(r31) #SubModel* TicoBaby
#Arg0 used to be here
stw r3, 0x9C(r31) #Store Starbits
stw r3, 0xA0(r31) #Store Coins
stb r3, 0xA4(r31) #New Comet Medal flag
stb r3, 0xA5(r31) #Obj Arg 1 "Do not save game" (1 = true)
stb r3, 0xA6(r31) #Obj Arg 2 "Skip results and only save" (1 = true)




#Obj Arg 0 "Save Type"

#-1 = Save All
# 0 = Save None
# 1 = Save Coins Only
# 2 = Save Starbits Only
# 3 = Save Coins and Starbits Only
# 4 = Save Comet Medal Only
# 5 = Save Coins and Comet Medal Only
# 6 = Save Starbits and Comet Medal Only
# 7 = Save All
li r3, -1 #set all the bits!
stw r3, 0x98(r31)

mr        r3, r31
lwz       r31, 0x0C(r1)
lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr

#-----------------------------------------------------

.StageResultObj_Init:
stwu      r1, -0x60(r1)
mflr      r0
stw       r0, 0x64(r1)
addi      r11, r1, 0x60
bl        _savegpr_27

mr        r31, r3
mr        r30, r4
bl initDefaultPos__2MRFP9LiveActorRC12JMapInfoIter

mr r3, r31
#bl connectToSceneMapObjMovement__2MRFP7NameObj
bl connectToSceneLayoutMovementCalcAnim__2MRFP7NameObj

mr r3, r31
bl invalidateClipping__2MRFP9LiveActor

li        r3, 0x48
bl        __nw__FUl
cmpwi     r3, 0
beq       loc_801453DC
bl        __ct__19StageResultInformerFv

loc_801453DC:
stw       r3, 0x90(r31)
bl initWithoutIter__7NameObjFv


#I sure hope Mario is created before this...
bl getPlayerBaseMtx__2MRFv
mr r5, r3
lis r3, .StageResultObj_TicoModel@ha
addi r3, r3, .StageResultObj_TicoModel@l
lis r4, .StageResultObj_SpinTico@ha
addi r4, r4, .StageResultObj_SpinTico@l
bl createModelObjNpc__2MRFPCcPCcPA4_f
stw       r3, 0x94(r31)

mr r3, r31
mr r4, r30
bl tryRegisterDemoCast__2MRFP9LiveActorRC12JMapInfoIter


lis r3, .StageResultObj_DemoFunctor_VTable@ha
addi r3, r3, .StageResultObj_DemoFunctor_VTable@l
lwz       r7, 0x00(r3)
lwz       r6, 0x04(r3)
lwz       r0, 0x08(r3)
lis       r4, .Functor_StageResultObj_StageResultObj_VTable@ha
addi      r4, r4, .Functor_StageResultObj_StageResultObj_VTable@l
stw       r4, 0x14(r1)  #0x00
mr        r3, r31
addi      r4, r1, 0x14
li r5, 0

stw       r31, 0x18(r1) #0x04
stw       r7, 0x1C(r1)  #0x08
stw       r6, 0x20(r1)  #0x0C
stw       r0, 0x24(r1)  #0x10
bl        registerDemoActionFunctor__2MRFPC9LiveActorRCQ22MR11FunctorBasePCc




lwz r3, 0x94(r31)
mr r4, r30
bl tryRegisterDemoCast__2MRFP9LiveActorRC12JMapInfoIter

mr r3, r30
addi r4, r31, 0x98
bl getJMapInfoArg0NoInit__2MRFRC12JMapInfoIterPl
.GLE PRINTADDRESS

mr r3, r30
addi r4, r1, 0x08
li r0, 0
stw r0, 0x00(r4)
bl getJMapInfoArg1NoInit__2MRFRC12JMapInfoIterPb
lbz r3, 0x08(r1)
stb r3, 0xA5(r31)

mr r3, r30
addi r4, r1, 0x08
li r0, 0
stw r0, 0x00(r4)
bl getJMapInfoArg2NoInit__2MRFRC12JMapInfoIterPb
lbz r3, 0x08(r1)
stb r3, 0xA6(r31)


mr        r3, r31
addi      r4, r13, .StageResultObj_NrvNULL_sInstance - STATIC_R13
li r5, 0
bl initNerve__9LiveActorFPC5Nervel

mr        r3, r31
lwz       r12, 0(r3)
lwz       r12, 0x34(r12)
mtctr     r12
bctrl

addi      r11, r1, 0x60
bl _restgpr_27
lwz       r0, 0x64(r1)
mtlr      r0
addi      r1, r1, 0x60
blr

#-----------------------------------------------------

.StageResultObj_Appear:
stwu      r1, -0x20(r1)
mflr      r0
stw       r0, 0x24(r1)
addi      r11, r1, 0x20
bl        _savegpr_29

mr r31, r3
bl appear__9LiveActorFv

.GLE PRINTADDRESS
lbz r3, 0xA6(r31)
cmpwi r3, 0
ble .StageResultObj_Appear_setNerve_Wait
addi r4, r13, .StageResultObj_NrvGameSave_sInstance - STATIC_R13
b .StageResultObj_Appear_setNerve

.StageResultObj_Appear_setNerve_Wait:
addi r4, r13, .StageResultObj_NrvAppearWait_sInstance - STATIC_R13

.StageResultObj_Appear_setNerve:
mr r3, r31
bl setNerve__9LiveActorFPC5Nerve

addi      r11, r1, 0x20
bl        _restgpr_29
lwz       r0, 0x24(r1)
mtlr      r0
addi      r1, r1, 0x20
blr

#-----------------------------------------------------

.StageResultObj_Kill:
stwu      r1, -0x20(r1)
mflr      r0
stw       r0, 0x24(r1)
addi      r11, r1, 0x20
bl        _savegpr_29

mr r31, r3
bl kill__9LiveActorFv

lwz       r3, 0x94(r31)
lwz       r12, 0(r3)
lwz       r12, 0x34(r12)
mtctr     r12
bctrl

mr r3, r31
addi r4, r13, .StageResultObj_NrvNULL_sInstance - STATIC_R13
bl setNerve__9LiveActorFPC5Nerve

addi      r11, r1, 0x20
bl        _restgpr_29
lwz       r0, 0x24(r1)
mtlr      r0
addi      r1, r1, 0x20
blr

#-----------------------------------------------------

.StageResultObj_Control:
.StageResultObj_NrvNull:
blr


#-----------------------------------------------------

.GLE PRINTADDRESS
.StageResultObj_AppearWait:
lwz       r3, 0(r4)

stwu      r1, -0x20(r1)
mflr      r0
stw       r0, 0x24(r1)
addi      r11, r1, 0x20
bl        _savegpr_29

mr        r29, r3
lis r31, .StageResultObj_ObjName@ha
addi r31, r31, .StageResultObj_ObjName@l

bl isFirstStep__2MRFPC9LiveActor
cmpwi r3, 0
beq .StageResultObj_AppearWait_NotFirstStep

bl getGameSequenceInGame__20GameSequenceFunctionFv
bl getPlayResultInStageHolder__18GameSequenceInGameFv
mr r30, r3












#New Obj Arg 0
#It's a bitfield now

.StageResultObj_TrySaveCoins:
lwz r3, 0x98(r29)
rlwinm. r0,r3,0,31,31
beq .StageResultObj_NoSaveCoins

#Save coins to save file
mr r3, r30
bl getClearedCoinNum__23PlayResultInStageHolderCFv
bl tryOnGameEventFlagCoinCounterStop__16GameDataFunctionFi
b .StageResultObj_TrySaveStarbits


.StageResultObj_NoSaveCoins:
#Do not save coins to save file
mr r3, r30
bl getClearedCoinNum__23PlayResultInStageHolderCFv
stw r3, 0xA0(r29)
li r4, 0
stw r4, 0x54(r30)






.StageResultObj_TrySaveStarbits:
lwz r3, 0x98(r29)
rlwinm. r0,r3,0,30,30
beq .StageResultObj_NoSaveStarbits

#save starbits to save file
mr r3, r30
bl getClearedStarPieceNum__23PlayResultInStageHolderCFv
bl tryOnGameEventFlagStarPieceCounterStop__16GameDataFunctionFi
b .StageResultObj_TrySaveMedal


.StageResultObj_NoSaveStarbits:
#Do not save starbits to save file
mr r3, r30
bl getClearedStarPieceNum__23PlayResultInStageHolderCFv
stw r3, 0x9C(r29)
li r4, 0
stw r4, 0x4C(r30)






.StageResultObj_TrySaveMedal:
lwz r3, 0x98(r29)
rlwinm.  r0,r3,0,29,29
beq .StageResultObj_NoSaveMedal

bl        tryCollectTicoCoinSaved__20GameSequenceFunctionFv
lbz       r0, 0x61(r30)
cmpwi     r0, 0
beq       loc_804D8748
mr        r3, r30
bl getStageName__23PlayResultInStageHolderCF
bl onGalaxyFlagTicoCoin__16GameDataFunctionFPCc
b loc_804D8748


.StageResultObj_NoSaveMedal:
lbz r4, 0x62(r30)
stb r4, 0xA4(r29)
li r4, 0
stb r4, 0x62(r30)




loc_804D8748:

bl isPlayerElementModeYoshi__2MRFv
cmpwi r3, 0
bne .StageResultObj_AppearWait_TryStartResults

#Start Master Luma
lwz       r30, 0x94(r29)
mr        r3, r30
lwz       r12, 0(r3)
lwz       r12, 0x2C(r12)
mtctr     r12
bctrl

bl        isPlayerLuigi__2MRFv
cmpwi     r3, 0
addi r4, r31, .StageResultObj_ResultWaitStart - .StageResultObj_ObjName
beq       loc_80145D4C
addi r4, r31, .StageResultObj_LuigiResultWaitStart - .StageResultObj_ObjName

loc_80145D4C:
mr        r3, r30
bl        startAction__2MRFPC9LiveActorPCc


bl        isPlayerLuigi__2MRFv
cmpwi     r3, 0
addi r3, r31, .StageResultObj_ResultWaitStart - .StageResultObj_ObjName
beq       loc_80145D4C_2
addi r3, r31, .StageResultObj_LuigiResultWaitStart - .StageResultObj_ObjName

loc_80145D4C_2:
bl sub_8004F640

.StageResultObj_AppearWait_NotFirstStep:

bl isBckOneTimeAndStoppedPlayer__2MRFv
cmpwi r3, 0
beq .StageResultObj_AppearWait_TryStartResults

addi      r3, r31, .StageResultObj_ResultWait - .StageResultObj_ObjName
li        r4, 0
bl        startBckPlayer__2MRFPCcPCc

.StageResultObj_AppearWait_TryStartResults:

lwz r3, WaitStringJapanese - STATIC_R2(r2)
bl isDemoPartLastStep__2MRFPCc
cmpwi r3, 0
beq .StageResultObj_AppearWait_Return

lwz       r3, 0x90(r29)
lwz       r12, 0(r3)
lwz       r12, 0x2C(r12)
mtctr     r12
bctrl
lwz       r3, 0x90(r29)
bl        requestMovementOn__2MRFP11LayoutActor

loc_8014579C:
mr        r3, r29
bl        pauseTimeKeepDemo__2MRFP9LiveActor

mr        r3, r29
addi r4, r13, .StageResultObj_NrvStageResults_sInstance - STATIC_R13
bl setNerve__9LiveActorFPC5Nerve


.StageResultObj_AppearWait_Return:
addi      r11, r1, 0x20
bl        _restgpr_29
lwz       r0, 0x24(r1)
mtlr      r0
addi      r1, r1, 0x20
blr

#------------------------------------------

.StageResultObj_exeStageResults:
lwz       r3, 0(r4)

stwu      r1, -0x20(r1)
mflr      r0
stw       r0, 0x24(r1)
addi      r11, r1, 0x20
bl        _savegpr_29

mr r31, r3

bl isBckOneTimeAndStoppedPlayer__2MRFv
cmpwi r3, 0
beq .StageResultObj_exeStageResults_AnimNotOneTime

lis r3, .StageResultObj_ResultWait@ha
addi r3, r3, .StageResultObj_ResultWait@l
li        r4, 0
bl        startBckPlayer__2MRFPCcPCc

.StageResultObj_exeStageResults_AnimNotOneTime:

lwz       r3, 0x90(r31)
bl isDead__2MRFPC11LayoutActor
cmpwi r3, 0
beq .StageResultObj_exeStageResults_Return


bl isPlayerElementModeYoshi__2MRFv
cmpwi r3, 0
bne .StageResultObj_exeStageResultsAfter_End

bl        getPlayerCurrentBckName__2MRFv
lis r4, .StageResultObj_ResultWait@ha
addi r4, r4, .StageResultObj_ResultWait@l
bl        isEqualStringCase__2MRFPCcPCc
cmpwi     r3, 0
beq       .StageResultObj_exeStageResults_Return

.StageResultObj_exeStageResultsAfter_End:
mr        r3, r31
addi r4, r13, .StageResultObj_NrvGameSave_sInstance - STATIC_R13
bl setNerve__9LiveActorFPC5Nerve

.StageResultObj_exeStageResults_Return:
addi      r11, r1, 0x20
bl        _restgpr_29
lwz       r0, 0x24(r1)
mtlr      r0
addi      r1, r1, 0x20
blr

#------------------------------------------
.GLE PRINTMESSAGE RestoreItems
.GLE PRINTADDRESS
.StageResultObj_exeGameSave:
lwz       r3, 0(r4)

stwu      r1, -0x20(r1)
mflr      r0
stw       r0, 0x24(r1)
addi      r11, r1, 0x20
bl        _savegpr_29

mr r31, r3
bl isFirstStep__2MRFPC9LiveActor
cmpwi r3, 0
beq .StageResultObj_exeGameSave_NotFirstStep


#Ignore the stuff underneath since we never got to part 1 of that code if the value is set to 1.
lbz r3, 0xA6(r31)
cmpwi r3, 0
bgt .StageResultObj_exeGameSave_TrySave

#If Obj Arg 0 is set, save all the current data!
bl getGameSequenceInGame__20GameSequenceFunctionFv
bl getPlayResultInStageHolder__18GameSequenceInGameFv



#New Obj Arg 0
#It's a bitfield now
lwz r5, 0x98(r31)

.StageResultObj_TryRestoreCoins:
rlwinm. r0,r5,0,31,31
bne .StageResultObj_NoRestoreCoins

lwz r4, 0xA0(r31)
stw r4, 0x54(r3)
b .StageResultObj_TryRestoreStarbits

.StageResultObj_NoRestoreCoins:
li r4, 0
stw r4, 0x54(r3)


.StageResultObj_TryRestoreStarbits:
rlwinm. r0,r5,0,30,30
bne .StageResultObj_NoRestoreStarbits


lwz r4, 0x9C(r31)
stw r4, 0x4C(r3)
b .StageResultObj_TryRestoreMedal

.StageResultObj_NoRestoreStarbits:
li r4, 0
stw r4, 0x4C(r3)


.StageResultObj_TryRestoreMedal:
rlwinm.  r0,r5,0,29,29
bne .StageResultObj_NoRestoreMedal
lbz r4, 0xA4(r31)
stb r4, 0x62(r3)


.StageResultObj_NoRestoreMedal:
.StageResultObj_exeGameSave_DoSave:

bl forceSyncStarPieceCounter__2MRFv
bl forceSyncCoinCounter__2MRFv

.StageResultObj_exeGameSave_TrySave:
lbz r3, 0xA5(r31)
cmpwi r3, 0
bgt .StageResultObj_exeGameSave_NotFirstStep

#first step
li r3, 1
li r4, 0
li r5, 0
bl startGameDataSaveSequence__20GameSequenceFunctionFbbb


.StageResultObj_exeGameSave_NotFirstStep:

mr r3, r31
li r4, 15
bl isGreaterStep__2MRFPC9LiveActorl
cmpwi r3, 0
beq .StageResultObj_exeGameSave_Return


bl isActiveSaveDataHandleSequence__20GameSequenceFunctionFv
cmpwi r3, 0
bne .StageResultObj_exeGameSave_Return


mr        r3, r31
addi r4, r13, .StageResultObj_NrvStageResultsAfter_sInstance - STATIC_R13
bl setNerve__9LiveActorFPC5Nerve


.StageResultObj_exeGameSave_Return:
addi      r11, r1, 0x20
bl        _restgpr_29
lwz       r0, 0x24(r1)
mtlr      r0
addi      r1, r1, 0x20
blr

#------------------------------------------

.StageResultObj_exeStageResultsAfter:
lwz       r3, 0(r4)

stwu      r1, -0x20(r1)
mflr      r0
stw       r0, 0x24(r1)
addi      r11, r1, 0x20
bl        _savegpr_29

mr r31, r3
bl isFirstStep__2MRFPC9LiveActor
cmpwi r3, 0
beq .StageResultObj_exeStageResultsAfter_NotFirstStep

mr        r3, r31
bl        resumeTimeKeepDemo__2MRFP9LiveActor

.StageResultObj_exeStageResultsAfter_NotFirstStep:

bl        isTimeKeepDemoActive__2MRFv
cmpwi     r3, 0
bne       .StageResultObj_exeStageResultsAfter_Return

lwz       r12, 0(r31)
mr        r3, r31
lwz       r12, 0x34(r12)
mtctr     r12
bctrl

.StageResultObj_exeStageResultsAfter_Return:

addi      r11, r1, 0x20
bl        _restgpr_29
lwz       r0, 0x24(r1)
mtlr      r0
addi      r1, r1, 0x20
blr


#=====================================================

#This function warps Mario to the position that this object is placed
.GLE PRINTADDRESS
.StageResultObj_DemoFunc:
stwu      r1, -0x60(r1)
mflr      r0
stw       r0, 0x64(r1)

mr r4, r3
addi r3, r1, 0x08
bl makeMtxTR__2MRFPA4_fPC9LiveActor
addi r3, r1, 0x08
bl setBaseMtx__11MarioAccessFPA4_f

lwz       r0, 0x64(r1)
mtlr      r0
addi      r1, r1, 0x60
blr

.Functor_StageResultObj_CAST:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
mr        r4, r3
addi      r12, r4, 8
lwz       r3, 4(r3)
bl        __ptmf_scall
#nop  #As if I'm including this nop lol
lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr

.Functor_StageResultObj_Clone:
stwu      r1, -0x10(r1)
mflr      r0
li        r5, 0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
mr        r31, r3
li        r3, 0x14
bl        __nw__FUlP7JKRHeapi
cmpwi     r3, 0
beq       loc_803484F4
lwz       r4, 4(r31)
lis       r5, .Functor_StageResultObj_StageResultObj_VTable@ha
addi      r5, r5, .Functor_StageResultObj_StageResultObj_VTable@l
stw       r5, 0(r3)
lwz       r0, 8(r31)
stw       r4, 4(r3)
lwz       r4, 0xC(r31)
stw       r0, 8(r3)
lwz       r0, 0x10(r31)
stw       r4, 0xC(r3)
stw       r0, 0x10(r3)

loc_803484F4:
lwz       r0, 0x14(r1)
lwz       r31, 0x0C(r1)
mtlr      r0
addi      r1, r1, 0x10
blr

#=====================================================
.StageResultObj_STATIC_INIT:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)

lis r5, .StageResultObj_NrvNULL@ha
addi r5, r5, .StageResultObj_NrvNULL@l
addi r3, r13, unk_807D5E10 - STATIC_R13

addi r4, r5, .StageResultObj_NrvNULL - .StageResultObj_NrvNULL    #Typical SMG stuff
stw r4, 0x00(r3)

addi r4, r5, .StageResultObj_NrvAppearWait - .StageResultObj_NrvNULL
stw r4, 0x04(r3)

addi r4, r5, .StageResultObj_NrvStageResults - .StageResultObj_NrvNULL
stw r4, 0x08(r3)

addi r4, r5, .StageResultObj_NrvGameSave - .StageResultObj_NrvNULL
stw r4, 0x0C(r3)

addi r4, r5, .StageResultObj_NrvStageResultsAfter - .StageResultObj_NrvNULL
stw r4, 0x10(r3)

lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr


#This is here to fix Mario's hair model from appearing at 0,0,0 during level intros
.MarioHairAndHatModel_Hide:
bl registerDemoSimpleCastAll__2MRFP9LiveActor
mr r3, r30
bl hideModelAndOnCalcAnim__2MRFP9LiveActor
b .MarioHairAndHatModel_Hide_Return

.GLE ADDRESS __ct__20MarioHairAndHatModelFv +0x134
b .MarioHairAndHatModel_Hide
.MarioHairAndHatModel_Hide_Return:
.GLE ENDADDRESS

.GLE PRINTADDRESS
.GLE ASSERT 0x80352F10
.GLE ENDADDRESS

#=====================================================================

#Static addresses
.GLE ADDRESS unk_807D5E10
.GLE TRASH BEGIN

.StageResultObj_NrvNULL_sInstance:
.int 0

.StageResultObj_NrvAppearWait_sInstance:
.int 0

.StageResultObj_NrvStageResults_sInstance:
.int 0

.StageResultObj_NrvGameSave_sInstance:
.int 0

.StageResultObj_NrvStageResultsAfter_sInstance:
.int 0

.GLE TRASH END
.GLE ENDADDRESS

#=====================================================================

.GLE ADDRESS .END_OF_QUICKWARPAREA_DATA

.StageResultObj_DemoFunctor_VTable:
.int 0
.int 0xFFFFFFFF
.int .StageResultObj_DemoFunc

.StageResultObj_ObjName:
    .string "StageResultObj"
    
.StageResultObj_TicoModel:
    .string "チコモデル"
    
.StageResultObj_SpinTico:
    .string "SpinTico"
    
.StageResultObj_ResultWaitStart:
    .string "ResultWaitStart" 
    
.StageResultObj_LuigiResultWaitStart:
    .string "LuigiResultWaitStart" 
    
.StageResultObj_ResultWait:
    .string "ResultWait" AUTO


.Functor_StageResultObj_StageResultObj_VTable:
.int 0
.int 0
.int .Functor_StageResultObj_CAST
.int .Functor_StageResultObj_Clone


.StageResultObj_VTable:
.int 0
.int 0
.int __dt__21StarReturnDemoStarterFv   #mfw shared Dtors
.int .StageResultObj_Init
.int initAfterPlacement__7NameObjFv
.int movement__9LiveActorFv
.int draw__7NameObjCFv
.int calcAnim__9LiveActorFv
.int calcViewAndEntry__9LiveActorFv
.int startMovement__7NameObjFv
.int endMovement__7NameObjFv
.int .StageResultObj_Appear
.int makeActorAppeared__9LiveActorFv
.int .StageResultObj_Kill
.int makeActorDead__9LiveActorFv
.int receiveMessage__9LiveActorFUlP9HitSensorP9HitSensor
.int getBaseMtx__9LiveActorCFv
.int getTakingMtx__9LiveActorCFv
.int startClipped__9LiveActorFv
.int endClipped__9LiveActorFv
.int .StageResultObj_Control
.int calcAndSetBaseMtx__9LiveActorFv
.int updateHitSensor__9LiveActorFP9HitSensor
.int attackSensor__9LiveActorFP9HitSensorP9HitSensor
.int receiveMsgPush__9LiveActorFP9HitSensorP9HitSensor
.int receiveMsgPlayerAttack__9LiveActorFUlP9HitSensorP9HitSensor
.int receiveMsgEnemyAttack__9LiveActorFUlP9HitSensorP9HitSensor
.int receiveOtherMsg__9LiveActorFUlP9HitSensorP9HitSensor

#Really abusing the memory over here

.StageResultObj_NrvNULL:
.int 0
.int 0
.int .StageResultObj_NrvNull
.int executeOnEnd__5NerveCFP5Spine

.StageResultObj_NrvAppearWait:
.int 0
.int 0
.int .StageResultObj_AppearWait
.int executeOnEnd__5NerveCFP5Spine

.StageResultObj_NrvStageResults:
.int 0
.int 0
.int .StageResultObj_exeStageResults
.int executeOnEnd__5NerveCFP5Spine

.StageResultObj_NrvGameSave:
.int 0
.int 0
.int .StageResultObj_exeGameSave
.int executeOnEnd__5NerveCFP5Spine

.StageResultObj_NrvStageResultsAfter:
.int 0
.int 0
.int .StageResultObj_exeStageResultsAfter
.int executeOnEnd__5NerveCFP5Spine

.END_OF_STAGERESULTOBJ_DATA:


.GLE ENDADDRESS