#Here is a bit of a re-write of Gearmos
#primarily to give me more code space :japanesegoblin:

.GLE ADDRESS init__9CaretakerFRC12JMapInfoIter
stwu      r1, -0x170(r1)
mflr      r0
stw       r0, 0x174(r1)
addi      r11, r1, 0x170
bl        _savegpr_28

lis r31, CaretakerData@ha
addi r31, r31, CaretakerData@l
mr        r30, r4 #JMapInfoIter*
mr        r29, r3 #Caretaker*

#read Obj Arg 0
li        r0, -1
stw r0, 0x10(r1)
mr        r3, r30
addi r4, r1, 0x10
bl getJMapInfoArg0NoInit__2MRFRC12JMapInfoIterPl
lwz r0, 0x10(r1)
stw       r0, 0x178(r29)


addi      r3, r1, 0xA8
addi      r4, r31, (Caretaker_Str - CaretakerData) # "Caretaker"
bl __ct__12NPCActorCapsFPCc

addi      r28, r31, (Caretaker_Str - CaretakerData) # "Caretaker"
stw       r28, 0x94(r1)

addi      r0, r13, (NULLSTRING - STATIC_R13) # ""
stw       r6, 0x98(r1)
stw       r6, 0x9C(r1)
stw       r6, 0xA0(r1)
stw       r6, 0xA4(r1)

addi      r3, r1, 0xA8
bl setDefault__12NPCActorCapsFv

addi      r3, r13, (unk_807D4828 - STATIC_R13)
addi      r0, r13, (unk_807D4824 - STATIC_R13)
stw       r3, 0x140(r1)
stw       r0, 0x148(r1)


mr r3, r29
mr r4, r30
addi      r5, r1, 0xA8
mr        r6, r28
li        r7, 0
li        r8, 0
bl initialize__8NPCActorFRC12JMapInfoIterRC12NPCActorCapsPCcPCcb

#TODO: Try putting the Obj Arg directly into the object variable
li        r28, 0
stw       r28, 0x0C(r1)
mr        r3, r30
addi      r4, r1, 0x0C
bl        getJMapInfoArg3NoInit__2MRFRC12JMapInfoIterPl
lwz       r0, 0x0C(r1)
stw       r0, 0x180(r29)


mr        r3, r29
addi      r4, r31, (Caretaker_BodyColor_Str - CaretakerData) # "BodyColor"
bl startBrk__2MRFPC9LiveActorPCc


lwz       r4, 0x180(r29)
lis       r0, 0x4330
stw       r0, 0x150(r1)
xoris     r0, r4, 0x8000
stw       r0, 0x154(r1)
lfd       f0, 0x150(r1)
lis       r3, FloatConversion@ha
lfd       f1, FloatConversion@l(r3)
fsubs     f1, f0, f1
mr        r3, r29
bl setBrkFrameAndStop__2MRFPC9LiveActorf


lfs       f3, (Caretaker_flt_3 - STATIC_R2)(r2) # 3.0f
addi      r6, r31, (Caretaker_Bspinhit_Str - CaretakerData) # "BSpinHit"
addi      r7, r31, (Caretaker_Bwaitstand_Str - CaretakerData) # "BWaitStand"
li        r0, 1
lfs       f2, (Caretaker_flt_2 - STATIC_R2)(r2) #2.0f
addi      r3, r31, (Caretaker_Btrampled_Str - CaretakerData) # "BTrampled"
lfs       f1, (Caretaker_flt_0_1 - STATIC_R2)(r2) #0.1f
addi      r5, r31, (Caretaker_Btalkhelp_Str - CaretakerData) # "BTalkHelp"
lfs       f0, (Caretaker_flt_0_05 - STATIC_R2)(r2) #0.05f
addi      r9, r31, (Caretaker_Bruntalk_Str - CaretakerData) # "BRunTalk"
addi      r8, r31, (Caretaker_Bwaitrun_Str - CaretakerData) # "BWaitRun"
stw       r3, 0x138(r29)
stw       r6, 0x134(r29)
stw       r6, 0x140(r29)
stw       r5, 0x13C(r29)
stw       r7, 0x100(r29)
stw       r7, 0x104(r29)
stw       r8, 0x120(r29)
stw       r9, 0x124(r29)
stb       r28, 0xEC(r29)
stb       r0, 0xED(r29)
stfs      f3, 0xF4(r29)
stfs      f2, 0x110(r29)
stfs      f1, 0x114(r29)
stfs      f0, 0x118(r29)
stb       r0, 0x128(r29)

mr        r3, r29
addi      r4, r31, (Caretaker_Dirt_Str - CaretakerData) # "Dirt"
bl        startBtk__2MRFPC9LiveActorPCc
lfs       f1, (Caretaker_flt_0 - STATIC_R2)(r2) # 0.0f
mr        r3, r29
bl setBtkFrameAndStop__2MRFPC9LiveActorf

mr        r3, r29
addi      r4, r31, (Caretaker_Wait_Str - CaretakerData) # "Wait"
bl        startBckNoInterpole__2MRFPC9LiveActorPCc

#TODO: Try putting the Obj Arg directly into the object variable
stw       r28, 0x08(r1)
mr        r3, r30
addi      r4, r1, 0x08
bl        getJMapInfoArg4NoInit__2MRFRC12JMapInfoIterPl
lwz       r4, 0x08(r1)
stw       r4, 0x17C(r29)
mr        r3, r29
bl setAnim__9CaretakerFl

mr        r3, r29
bl calcAnimDirect__2MRFP9LiveActor

#Check to see if this Gearmo has a TalkMessageCtrl
#If there is none, then registering any message functions is worthless
lwz       r28, 0x94(r29)
cmpwi r28, 0
beq .Caretaker_Skip_MBSF_Func

#So here we're going to register our Global Events since the Global Events cover the Gearmo minigames in full
mr r3, r29
bl .MR_RegisterGlobalBranchFunc
mr r3, r29
bl .MR_RegisterGlobalEventFunc
mr r3, r29
bl .MR_RegisterGlobalAnimeFunc


#I moved this code so that it only runs if the Gearmo has a message attached to it.
lwz       r0, 0x178(r29)  #Obj Arg 0
cmplwi    r0, 2
bgt       .Caretaker_Skip_MBSF_Func
mr        r3, r29
bl        declarePowerStar__2MRFPC7NameObj

#Change the animation based on Obj Arg 0
#This code is much shorter than Nintendo's
li        r3, 0x20 # ' '
bl        __nw__FUl
cmpwi     r3, 0
beq       .CareTaker_Init_FailedTakeOutStar
mr        r4, r29
lwz       r0, 0x178(r29)
cmpwi     r0, 1
bne       .Caretaker_Init_AnimTool
addi      r5, r31, (Caretaker_TakeOutStarCaretakerFreeHand_Str - CaretakerData) # "TakeOutStarCaretakerFreeHand"
b .Caretaker_Init_CreateTakrOutStar
.Caretaker_Init_AnimTool:
addi      r5, r31, (aTakeoutstarcar_0 - 0x806B7BD0) # "TakeOutStarCaretaker"
.Caretaker_Init_CreateTakrOutStar:
mr        r6, r5
addi      r7, r13, (unk_807D4820 - STATIC_R13)
li        r8, 0
bl        __ct__11TakeOutStarFP8NPCActorPCcPCcPC5Nervel  #Symbol map is wrong on this one...
.CareTaker_Init_FailedTakeOutStar:
stw       r3, 0x168(r29)


.Caretaker_Skip_MBSF_Func:
#Now lets deal with the Minigame mode. Also covers normal gearmos
lwz       r0, 0x178(r29)
cmpwi     r0, 0
bne       .Caretaker_Init_Return

addi      r6, r31, (Caretaker_SpinHit_Str - CaretakerData) # "SpinHit"
addi      r7, r31, (Caretaker_Wait_Str - CaretakerData) # "Wait"
addi      r8, r31, (Caretaker_TalkNormal_Str - CaretakerData) # "TalkNormal"
addi      r9, r31, (Caretaker_WaitRun_Str - CaretakerData) # "WaitRun"
addi      r5, r31, (Caretaker_Trampled_Str - CaretakerData) # "Trampled"
addi      r0, r31, (Caretaker_TalkAngry_Str - CaretakerData) # "TalkAngry"
stw       r6, 0x134(r29)
stw       r6, 0x140(r29)
stw       r5, 0x138(r29)
stw       r0, 0x13C(r29)
stw       r7, 0x100(r29)
stw       r7, 0x104(r29)
stw       r8, 0x108(r29)
stw       r8, 0x10C(r29)
stw       r9, 0x120(r29)
stw       r9, 0x124(r29)

addi      r3, r1, 0x94
li        r4, 0
bl        getNPCItemData__2MRFP12NPCActorIteml

mr        r3, r29
addi      r4, r1, 0x94
li        r5, 0
bl        equipment__8NPCActorFRC12NPCActorItemb

mr        r3, r29
mr        r4, r30
bl        needStageSwitchReadA__2MRFP9LiveActorRC12JMapInfoIter

mr        r3, r29
mr        r4, r30
bl        needStageSwitchWriteB__2MRFP9LiveActorRC12JMapInfoIter

mr        r3, r30
addi      r4, r29, 0x184
bl        getJMapInfoArg1NoInit__2MRFRC12JMapInfoIterPl

li        r3, 0x2C # ','
bl        __nw__FUl
cmpwi     r3, 0
beq       loc_80344D0C
bl        __ct__20StartCountdownLayoutFv

loc_80344D0C:
stw       r3, 0x164(r29)
bl        initWithoutIter__7NameObjFv
li        r3, 0x3C # '<'
bl        __nw__FUl
cmpwi     r3, 0
beq       loc_80344D28
bl        __ct__15BombTimerLayoutFv

loc_80344D28:
stw       r3, 0x170(r29)
bl        initWithoutIter__7NameObjFv
lwz       r0, 0x184(r29)
lwz       r3, 0x170(r29)
mulli     r4, r0, 60
bl        setTimeLimit__15BombTimerLayoutFUl
lwz       r3, 0x170(r29)
lwz       r12, 0(r3)
lwz       r12, 0x30(r12)
mtctr     r12
bctrl
mr        r3, r29
mr        r4, r30
addi      r5, r31, (Caretaker_GarbageManagement - CaretakerData) # "ゴミ管理"
li        r6, 0x20
bl        joinToGroupArray__2MRFP9LiveActorRC12JMapInfoIterPCcl
stw       r3, 0x174(r29)

bl        enablePlayerResourceFire__2MRFv

li        r3, 0x92
bl        createSceneObj__2MRFi

lwz       r28, 0x94(r29)
cmpwi     r28, 0
beq       .Caretaker_SkipDistanceToTalk
lwz       r3, 0x94(r29)
lwz       r4, 0x184(r29)
bl        setMessageArg__2MRFP15TalkMessageCtrli

lwz       r3, 0x94(r29)
lfs       f1, (Caretaker_flt_350 - STATIC_R2)(r2)
bl        setDistanceToTalk__2MRFP15TalkMessageCtrlf

.Caretaker_SkipDistanceToTalk:
mr        r3, r30
bl        createActorCameraInfo__2MRFRC12JMapInfoIter
stw       r3, 0x16C(r29)
mr        r3, r29
mr        r4, r30
addi      r5, r29, 0x16C
bl        initActorCamera__2MRFPC9LiveActorRC12JMapInfoIterPP15ActorCameraInfo

.Caretaker_Init_Return:
mr        r3, r29
addi      r4, r13, (sInstance__Q212NrvCaretaker16CaretakerNrvWait - STATIC_R13)
bl        setNerve__9LiveActorFPC5Nerve

#Normally this code is reserved for Gearmos with Obj Arg -1 and 0. We're gonna see if it works with the other two as well.
mr        r3, r29
bl        isExistRail__2MRFPC9LiveActor
cmpwi     r3, 0
beq       .Caretaker_RailFail
mr        r3, r29
bl        moveCoordAndFollowTrans__2MRFP9LiveActor
lfs       f2, 0x14(r29)
lfs       f1, 0x18(r29)
lfs       f0, 0x1C(r29)
stfs      f2, 0xC4(r29)
stfs      f1, 0xC8(r29)
stfs      f0, 0xCC(r29)

.Caretaker_RailFail:
addi      r11, r1, 0x170
bl        _restgpr_28
lwz       r0, 0x174(r1)
mtlr      r0
addi      r1, r1, 0x170
blr



#Don't ask why this is here and not in SceneUtility
.MR_SystemCircleWipeToCenter:
stwu      r1, -0x20(r1)
mflr      r0
stw       r0, 0x24(r1)

li r3, 0
stw r3, 0x08(r1)
stw r3, 0x0C(r1)
stw r3, 0x10(r1)
addi r3, r1, 0x08
bl setWipeCircleCenterPos__2MRFRCQ29JGeometry8TVec3<f>

lwz       r0, 0x24(r1)
mtlr      r0
addi      r1, r1, 0x20
blr


#This label is for any additional code that's needed I guess.
.Caretaker_InitEnd:
.GLE PRINTADDRESS
.GLE ENDADDRESS


