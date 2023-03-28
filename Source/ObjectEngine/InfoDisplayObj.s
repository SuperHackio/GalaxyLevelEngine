#This is an object that will display custom Information messages to the user
#Like how when you get a powerup the first time, it shows the message and you need to press (A).



#Object Entry replaces SkyIslandPartsB. Just add it as a SimpleMapObj to the ProductMapObjDataTable
.GLE ADDRESS cCreateTable__14NameObjFactory +0x1598
.int .InfoDisplayObj_ObjName
.int .InfoDisplayObj_NEW
.GLE ENDADDRESS


.GLE ADDRESS .GALAXYINFOAREA_CONNECTOR

#-----------------------------------------------------

.InfoDisplayObj_NEW:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
mr        r31, r3
#LiveActor is 0x90 in size. I know that's not what's here but this is just a note soooo
li        r3, 0xA8
bl        __nw__FUl
cmpwi     r3, 0
beq       .InfoDisplayObj_NEW_Return
mr        r4, r31
bl        .InfoDisplayObj_Ctor

.InfoDisplayObj_NEW_Return:
lwz       r0, 0x14(r1)
lwz       r31, 0x0C(r1)
mtlr      r0
addi      r1, r1, 0x10
blr

#-----------------------------------------------------

.InfoDisplayObj_Ctor:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
mr        r31, r3

bl __ct__9LiveActorFPCc
lis       r4, .InfoDisplayObj_VTable@ha
addi      r4, r4, .InfoDisplayObj_VTable@l
stw       r4, 0x00(r31)

#0x90 = WChar_t* "Message pointer"
#0x94 = Obj Arg 0 (ENUM) "Window Type" (default 0 for UP)
#0x98 = Obj Arg 1 (int) "A Button Delay" (default sDisplayFramesMin__33_unnamed_InformationObserver_cpp_)
#0x9C = int "Current A Button Delay" - The current status of the A Button delay
#0xA0 = Obj Arg 3 (bool) "DoPauseTimeKeepDemo" (default 1 for TRUE)
#0xA1 = bool "WasPausedTimeKeepDemo"

li r3, 0
stw r3, 0x90(r31)
stw r3, 0x94(r31)
stw r3, 0x9C(r31)
stw r3, 0xA0(r31) #Set all bools to 0
lwz r0, sDisplayFramesMin__33_unnamed_InformationObserver_cpp_ - STATIC_R13(r13)
stw r0, 0x98(r31)

mr        r3, r31
lwz       r31, 0x0C(r1)
lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr

#-----------------------------------------------------
.GLE PRINTADDRESS

.InfoDisplayObj_Init:
stwu      r1, -0x150(r1)
mflr      r0
stw       r0, 0x154(r1)
stw       r31, 0x0C(r1)
stw       r30, 0x08(r1)
mr        r31, r3
mr        r30, r4

bl connectToSceneLayoutMovement__2MRFP7NameObj

lis       r3, InfoObserverCamera_StrJp@ha
addi      r3, r3, InfoObserverCamera_StrJp@l
bl        declareEventCameraProgrammable__2MRFPCc

mr        r3, r31
addi      r4, r13, .InfoDisplayObj_NrvWait_sInstance - STATIC_R13
li        r5, 0
bl        initNerve__9LiveActorFPC5Nervel

mr r3, r31
bl invalidateClipping__2MRFP9LiveActor

mr r3, r30
addi r4, r1, 0x10
bl getJMapInfoMessageID__2MRFRC12JMapInfoIterPl
#is there any reason to check for the special -2?

lis r3, .InfoDisplayObj_MessageName@ha
addi r5, r3, .InfoDisplayObj_MessageName@l
addi r3, r1, 0x14
li r4, 0x100   #The standard size for these sorts of strings
lwz r6, 0x10(r1)
bl createZoneMsgId__2MRFPCclPCcl

li r4, 0
stw r4, 0x10(r1)

mr r3, r30
addi r4, r1, 0x10
bl getJMapInfoArg2NoInit__2MRFRC12JMapInfoIterPb
lwz r4, 0x10(r1)
cmpwi r4, 0

li r3, -1
bne .UseSceneCommonMessage

mr r3, r30
bl getPlacedZoneId__2MRFRC12JMapInfoIter

.UseSceneCommonMessage:
mr r4, r3
addi r3, r1, 0x14
bl getSceneMessageDirect__2MRFPCcl
stw r3, 0x90(r31)

mr r3, r30
addi r4, r31, 0x94
bl getJMapInfoArg0NoInit__2MRFRC12JMapInfoIterPl

mr r3, r30
addi r4, r31, 0x98
bl getJMapInfoArg1NoInit__2MRFRC12JMapInfoIterPl

mr r3, r30
addi r4, r31, 0xA0
bl getJMapInfoArg3NoInit__2MRFRC12JMapInfoIterPb

mr r3, r31
mr r4, r30
bl useStageSwitchReadAppear__2MRFP9LiveActorRC12JMapInfoIter
cmpwi r3, 0
beq .InfoDisplayObj_Init_Return

#Register SW_APPEAR Listener
lis r3, .InfoDisplayObj_AppearListenFunctor_VTable@ha
addi r3, r3, .InfoDisplayObj_AppearListenFunctor_VTable@l
lwz       r7, 0x00(r3)
lwz       r6, 0x04(r3)
lwz       r0, 0x08(r3)
lis       r4, .Functor_InfoDisplayObj_InfoDisplayObj_VTable@ha
addi      r4, r4, .Functor_InfoDisplayObj_InfoDisplayObj_VTable@l
stw       r4, 0x14(r1)  #0x00
mr        r3, r31
addi      r4, r1, 0x14

stw       r31, 0x18(r1) #0x04
stw       r7, 0x1C(r1)  #0x08
stw       r6, 0x20(r1)  #0x0C
stw       r0, 0x24(r1)  #0x10
bl        listenStageSwitchOnAppear__2MRFP9LiveActorRCQ22MR11FunctorBase

.InfoDisplayObj_Init_Return:
mr r3, r31
mr r4, r30
bl tryRegisterDemoCast__2MRFP9LiveActorRC12JMapInfoIter

lwz       r12, 0(r31)
mr        r3, r31
lwz       r12, 0x38(r12)
mtctr     r12
bctrl

lwz       r31, 0x0C(r1)
lwz       r30, 0x08(r1)
lwz       r0, 0x154(r1)
mtlr      r0
addi      r1, r1, 0x150
blr

#-----------------------------------------------------
.InfoDisplayObj_Appear:
.GLE PRINTADDRESS
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
stw       r30, 0x08(r1)
mr        r31, r3

li r3, 0
stb r3, 0xA1(r31)

bl isSystemTalking__2MRFv
cmpwi r3, 0
bne .InfoDisplayObj_Appear_NoDemoOwnership

bl isTimeKeepDemoActive__2MRFv
cmpwi     r3, 0
beq .InfoDisplayObj_Appear_NeedsDemoOwnership

lbz r4, 0xA0(r31)
cmpwi r4, 0
bne .InfoDisplayObj_Appear_NoDemoOwnership

li r3, 1
stb r3, 0xA1(r31)

mr r3, r31
bl pauseTimeKeepDemo__2MRFP9LiveActor

.InfoDisplayObj_Appear_NoDemoOwnership:
mr r3, r31
bl requestMovementOn__2MRFP7NameObj

mr r3, r31
addi r4, r13, .InfoDisplayObj_NrvAppear_sInstance - STATIC_R13
bl setNerve__9LiveActorFPC5Nerve
b .InfoDisplayObj_Appear_Return

.InfoDisplayObj_Appear_NeedsDemoOwnership:
mr r3, r31
lis r4, .InfoDisplayObj_CutsceneNameForTemp@ha
addi r4, r4, .InfoDisplayObj_CutsceneNameForTemp@l
addi r5, r13, .InfoDisplayObj_NrvAppear_sInstance - STATIC_R13
addi r6, r13, .InfoDisplayObj_NrvWait_sInstance - STATIC_R13
bl requestStartDemoWithoutCinemaFrame__2MRFP9LiveActorPCcPC5NervePC5Nerve

.InfoDisplayObj_Appear_Return:
mr        r3, r31
lwz       r12, 0(r3)
lwz       r12, 0x30(r12)
mtctr     r12
bctrl

lwz       r31, 0x0C(r1)
lwz       r30, 0x08(r1)
lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr



.InfoDisplayObj_ExeWait:
blr

.InfoDisplayObj_ExeAppear:
lwz       r3, 0(r4)

stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
stw       r30, 0x08(r1)
mr        r31, r3

bl isFirstStep__2MRFPC9LiveActor
cmpwi r3, 0
beq .InfoDisplayObj_ExeAppear_SkipFirstStep

lwz r3, 0x90(r31)
lwz r4, 0x94(r31)
li r5, 1
bl .GLE_AppearInformationMessageExt


bl disableCloseInformationMessage__2MRFv
lwz r4, 0x98(r31)
stw r4, 0x9C(r31)

.InfoDisplayObj_ExeAppear_SkipFirstStep:
lwz       r3, 0x9C(r31)
cmpwi     r3, 0
blt .InfoDisplayObj_ExeAppear_SkipSubtract
addi      r0, r3, -1
stw       r0, 0x9C(r31)
.InfoDisplayObj_ExeAppear_SkipSubtract:

li        r3, 0
bl testCorePadTriggerA__2MRFl
cmpwi r3, 0
beq .InfoDisplayObj_ExeAppear_Return

lwz       r0, 0x9C(r31)
cmpwi     r0, 0
bge .InfoDisplayObj_ExeAppear_Return

mr        r3, r31
addi r4, r13, .InfoDisplayObj_NrvDisappear_sInstance - STATIC_R13
bl setNerve__9LiveActorFPC5Nerve

.InfoDisplayObj_ExeAppear_Return:
lwz       r31, 0x0C(r1)
lwz       r30, 0x08(r1)
lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr

.InfoDisplayObj_ExeDisappear:
lwz       r3, 0(r4)

stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
stw       r30, 0x08(r1)
mr        r31, r3

bl isFirstStep__2MRFPC9LiveActor
cmpwi r3, 0
beq .InfoDisplayObj_ExeDisappear_SkipFirstStep

bl disappearInformationMessage__2MRFv

.InfoDisplayObj_ExeDisappear_SkipFirstStep:

bl isDeadInformationMessage__2MRFv
cmpwi r3, 0
beq .InfoDisplayObj_ExeDisappear_Return

lbz r3, 0xA1(r31)
cmpwi r3, 0
beq .InfoDisplayObj_ExeDisappear_HasDemoOwnership

mr r3, r31
bl resumeTimeKeepDemo__2MRFP9LiveActor
b .InfoDisplayObj_ExeDisappear_SkipEndDemo

.InfoDisplayObj_ExeDisappear_HasDemoOwnership:

lis r4, .InfoDisplayObj_CutsceneNameForTemp@ha
addi r3, r4, .InfoDisplayObj_CutsceneNameForTemp@l
bl isDemoActive__2MRFPCc
cmpwi     r3, 0
beq .InfoDisplayObj_ExeDisappear_SkipEndDemo

mr r3, r31
lis r4, .InfoDisplayObj_CutsceneNameForTemp@ha
addi r4, r4, .InfoDisplayObj_CutsceneNameForTemp@l
bl endDemo__2MRFP7NameObjPCc

.InfoDisplayObj_ExeDisappear_SkipEndDemo:
mr        r3, r31
lwz       r12, 0(r3)
lwz       r12, 0x38(r12)
mtctr     r12
bctrl

.InfoDisplayObj_ExeDisappear_Return:
lwz       r31, 0x0C(r1)
lwz       r30, 0x08(r1)
lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr


#GLE::appearInformationMessageExt((wchar_t const*, WINDOW_TYPE, bool))
.GLE_AppearInformationMessageExt:
stwu      r1, -0x20(r1)
mflr      r0
stw       r0, 0x24(r1)
addi      r11, r1, 0x20
bl _savegpr_29

mr r31, r3  #WChar_t
mr r30, r4  #ENUM
mr r29, r5  # bool

bl        getGameSceneLayoutHolder__2MRFv
lwz       r3, 0x14(r3)
stw       r30, 0x30(r3)
mr        r4, r31
bl        setMessage__18InformationMessageFPCw

mr        r3, r29
bl        appearInformationMessage__24@unnamed@ScreenUtil_cpp@Fb

addi      r11, r1, 0x20
bl _restgpr_29
lwz       r0, 0x24(r1)
mtlr      r0
addi      r1, r1, 0x20
blr

#=====================================================

.Functor_InfoDisplayObj_CAST:
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

.Functor_InfoDisplayObj_Clone:
stwu      r1, -0x10(r1)
mflr      r0
li        r5, 0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
mr        r31, r3
li        r3, 0x14
bl        __nw__FUlP7JKRHeapi
cmpwi     r3, 0
beq       .Functor_InfoDisplayObj_Clone_b
lwz       r4, 4(r31)
lis       r5, .Functor_InfoDisplayObj_InfoDisplayObj_VTable@ha
addi      r5, r5, .Functor_InfoDisplayObj_InfoDisplayObj_VTable@l
stw       r5, 0(r3)
lwz       r0, 8(r31)
stw       r4, 4(r3)
lwz       r4, 0xC(r31)
stw       r0, 8(r3)
lwz       r0, 0x10(r31)
stw       r4, 0xC(r3)
stw       r0, 0x10(r3)

.Functor_InfoDisplayObj_Clone_b:
lwz       r0, 0x14(r1)
lwz       r31, 0x0C(r1)
mtlr      r0
addi      r1, r1, 0x10
blr

#=====================================================
.InfoDisplayObj_STATIC_INIT:
#stwu      r1, -0x10(r1)
#mflr      r0
#stw       r0, 0x14(r1)

lis r5, .InfoDisplayObj_NrvAppear@ha
addi r5, r5, .InfoDisplayObj_NrvAppear@l
addi r3, r13, .InfoDisplayObj_NrvWait_sInstance - STATIC_R13

addi r4, r5, .InfoDisplayObj_NrvWait - .InfoDisplayObj_NrvAppear    #Typical SMG stuff
stw r4, 0x00(r3)

addi r4, r5, .InfoDisplayObj_NrvAppear - .InfoDisplayObj_NrvAppear
stw r4, 0x04(r3)

addi r4, r5, .InfoDisplayObj_NrvDisappear - .InfoDisplayObj_NrvAppear
stw r4, 0x08(r3)

#lwz       r0, 0x14(r1)
#mtlr      r0
#addi      r1, r1, 0x10
blr

#=====================================================================

#Static addresses
.GLE ADDRESS unk_807D5E10
.GLE TRASH BEGIN

.InfoDisplayObj_NrvWait_sInstance:
.int 0

.InfoDisplayObj_NrvAppear_sInstance:
.int 0

.InfoDisplayObj_NrvDisappear_sInstance:
.int 0

.GLE TRASH END
.GLE ENDADDRESS

#=====================================================================

.InfoDisplayObj_AppearListenFunctor_VTable:
.int 0
.int 0x2C
.int 0

.InfoDisplayObj_ObjName:
.InfoDisplayObj_MessageName:
    .string "InfoDisplayObj"
    
.InfoDisplayObj_CutsceneNameForTemp:
    .string "InfoDispObjTemp" AUTO

.Functor_InfoDisplayObj_InfoDisplayObj_VTable:
.int 0
.int 0
.int .Functor_InfoDisplayObj_CAST
.int .Functor_InfoDisplayObj_Clone

.InfoDisplayObj_VTable:
.int 0
.int 0
.int __dt__19InformationObserverFv   #MOOOOM! PHINEAS AND FERB ARE RECYCLING DTOR'S!
.int .InfoDisplayObj_Init
.int initAfterPlacement__7NameObjFv
.int movement__9LiveActorFv
.int draw__7NameObjCFv
.int calcAnim__9LiveActorFv
.int calcViewAndEntry__9LiveActorFv
.int startMovement__7NameObjFv
.int endMovement__7NameObjFv
.int .InfoDisplayObj_Appear
.int makeActorAppeared__9LiveActorFv
.int kill__9LiveActorFv
.int makeActorDead__9LiveActorFv
.int receiveMessage__9LiveActorFUlP9HitSensorP9HitSensor
.int getBaseMtx__9LiveActorCFv
.int getTakingMtx__9LiveActorCFv
.int startClipped__9LiveActorFv
.int endClipped__9LiveActorFv
.int control__9LiveActorFv
.int calcAndSetBaseMtx__9LiveActorFv
.int updateHitSensor__9LiveActorFP9HitSensor
.int attackSensor__9LiveActorFP9HitSensorP9HitSensor
.int receiveMsgPush__9LiveActorFP9HitSensorP9HitSensor
.int receiveMsgPlayerAttack__9LiveActorFUlP9HitSensorP9HitSensor
.int receiveMsgEnemyAttack__9LiveActorFUlP9HitSensorP9HitSensor
.int receiveOtherMsg__9LiveActorFUlP9HitSensorP9HitSensor

.InfoDisplayObj_NrvAppear:
.int 0
.int 0
.int .InfoDisplayObj_ExeAppear
.int executeOnEnd__5NerveCFP5Spine

.InfoDisplayObj_NrvWait:
.int 0
.int 0
.int .InfoDisplayObj_ExeWait
.int executeOnEnd__5NerveCFP5Spine

.InfoDisplayObj_NrvDisappear:
.int 0
.int 0
.int .InfoDisplayObj_ExeDisappear
.int executeOnEnd__5NerveCFP5Spine








.INFODISPLAYOBJ_CONNECTOR:
.GLE ENDADDRESS