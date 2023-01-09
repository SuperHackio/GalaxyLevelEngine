#This object will let you spawn the Stage Results whenever you want

#Obj Arg 0 = Store Collectables? (bool) -1 = false, * = true
#  Setting this Obj Arg to TRUE will put any collected coins into the global counters that you see in hubworlds. Useful for NBO Stars as it will also save your comet medal.


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
li        r3, 0xA0
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
stw r3, 0x98(r31) #Obj Arg 0

mr        r3, r31
lwz       r31, 0x0C(r1)
lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr

#-----------------------------------------------------

.StageResultObj_Init:
stwu      r1, -0x20(r1)
mflr      r0
stw       r0, 0x24(r1)
addi      r11, r1, 0x20
bl        _savegpr_27

mr        r31, r3
mr        r30, r4
bl initDefaultPos__2MRFP9LiveActorRC12JMapInfoIter

mr r3, r31
bl connectToSceneMapObjMovement__2MRFP7NameObj

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

lwz r3, 0x94(r31)
mr r4, r30
bl tryRegisterDemoCast__2MRFP9LiveActorRC12JMapInfoIter

mr r3, r30
addi r4, r31, 0x98
bl getJMapInfoArg0NoInit__2MRFRC12JMapInfoIterPl

mr        r3, r31
addi      r4, r13, .StageResultObj_NrvNULL_sInstance - STATIC_R13
li r5, 0
bl initNerve__9LiveActorFPC5Nervel

mr        r3, r31
lwz       r12, 0(r3)
lwz       r12, 0x34(r12)
mtctr     r12
bctrl

addi      r11, r1, 0x20
bl _restgpr_27
lwz       r0, 0x24(r1)
mtlr      r0
addi      r1, r1, 0x20
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

mr r3, r31
addi r4, r13, .StageResultObj_NrvAppearWait_sInstance - STATIC_R13
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



#If Obj Arg 0 is set, save all the current data!
lwz r3, 0x98(r29)
cmpwi r3, 0
beq loc_804D8748

bl getGameSequenceInGame__20GameSequenceFunctionFv
bl getPlayResultInStageHolder__18GameSequenceInGameFv
mr r30, r3

bl getClearedStarPieceNum__23PlayResultInStageHolderCFv
bl tryOnGameEventFlagStarPieceCounterStop__16GameDataFunctionFi

mr r3, r30
bl getClearedCoinNum__23PlayResultInStageHolderCFv
bl tryOnGameEventFlagCoinCounterStop__16GameDataFunctionFi

bl        tryCollectTicoCoinSaved__20GameSequenceFunctionFv
lbz       r0, 0x61(r30)
cmpwi     r0, 0
beq       loc_804D8748
mr        r3, r30
bl getStageName__23PlayResultInStageHolderCF
bl onGalaxyFlagTicoCoin__16GameDataFunctionFPCc

loc_804D8748:
#don't clear the values here, clear them once we're done with them

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
addi r4, r13, .StageResultObj_NrvStageResultsAfter_sInstance - STATIC_R13
bl setNerve__9LiveActorFPC5Nerve

.StageResultObj_exeStageResults_Return:
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

#If Obj Arg 0 is set, save all the current data!
lwz r3, 0x98(r31)
cmpwi r3, 0
beq .StageResultObj_exeStageResultsAfter_Return

bl getGameSequenceInGame__20GameSequenceFunctionFv
bl getPlayResultInStageHolder__18GameSequenceInGameFv
li r4, 0
stw r4, 0x4C(r3)
stw r4, 0x54(r3)


.StageResultObj_exeStageResultsAfter_Return:
addi      r11, r1, 0x20
bl        _restgpr_29
lwz       r0, 0x24(r1)
mtlr      r0
addi      r1, r1, 0x20
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

addi r4, r5, .StageResultObj_NrvStageResultsAfter - .StageResultObj_NrvNULL
stw r4, 0x0C(r3)

lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr

.GLE ASSERT __sinit_\Meister_cpp
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

.StageResultObj_NrvStageResultsAfter_sInstance:
.int 0

.GLE TRASH END
.GLE ENDADDRESS

#=====================================================================

.GLE ADDRESS .END_OF_QUICKWARPAREA_DATA

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

.StageResultObj_NrvStageResultsAfter:
.int 0
.int 0
.int .StageResultObj_exeStageResultsAfter
.int executeOnEnd__5NerveCFP5Spine




.GLE ENDADDRESS