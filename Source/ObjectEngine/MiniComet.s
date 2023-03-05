#Lovely comet that was previously used in SMG2's world maps
#A bit finiky to work with, but it's good enough for the GLE Template hack
#Replaces ItemRoomDoor because that object is broken now anyways I think

.GLE ADDRESS .MAME_MUIMUI_ATTACK_MAN_CONNECTOR

.MiniComet_sInit:
addi      r3, r13, MiniComet_NerveLoc - STATIC_R13
lis       r4, MiniComet_NrvVTable@ha
addi      r4, r4, MiniComet_NrvVTable@l
stw       r4, 0x00(r3)
blr

.MiniComet_Create:
#This function is still just the one from ItemRoomDoor

.MiniComet_Ctor:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
mr        r31, r4
lis       r5, MiniComet_NameJP@ha
addi      r4, r5, MiniComet_NameJP@l # "コメット（ワールドマップ）"
stw       r30, 0x08(r1)
mr        r30, r3
bl        __ct__9LiveActorFPCc
stw       r31, 0x90(r30)
lis       r4, MiniComet_VTable@ha
addi      r4, r4, MiniComet_VTable@l
mr        r3, r30
stw       r4, 0(r30)
lwz       r31, 0x0C(r1)
lwz       r30, 0x08(r1)
lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr

.MiniComet_Init:
stwu      r1, -0x20(r1)
mflr      r0
li        r6, 0
stw       r0, 0x24(r1)
stw       r31, 0x1C(r1)
stw       r30, 0x18(r1)
mr        r31, r3
mr        r30, r4

lis       r5, MiniComet_NameEN@ha
addi      r5, r5, MiniComet_NameEN@l
bl processInitFunction__2MRFP9LiveActorRC12JMapInfoIterPCcb
mr        r3, r31
addi      r4, r13, MiniCometWaitNerve - STATIC_R13
li        r5, 0
bl        initNerve__9LiveActorFPC5Nervel
mr        r3, r31
bl        invalidateClipping__2MRFP9LiveActor
mr        r3, r31
mr r4, r30
bl tryRegisterDemoCast__2MRFP9LiveActorRC12JMapInfoIter
lwz       r12, 0(r31)
mr        r3, r31
lwz       r12, 0x30(r12)
mtctr     r12
#bctrl                   #MakeActorAppeared
lwz       r0, 0x24(r1)
lwz       r31, 0x1C(r1)
lwz       r30, 0x18(r1)
mtlr      r0
addi      r1, r1, 0x20
blr

.MiniComet_Appear:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
mr        r31, r3
bl        appear__9LiveActorFv
mr        r3, r31
lis       r4, MiniComet_Appear@ha
addi      r4, r4, MiniComet_Appear@l # "Appear"
bl        startAction__2MRFPC9LiveActorPCc
lwz       r0, 0x14(r1)
lwz       r31, 0x0C(r1)
mtlr      r0
addi      r1, r1, 0x10
blr

.MiniComet_Nrv:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
lwz       r31, 0(r4)
mr        r3, r31
bl        isActionEnd__2MRFPC9LiveActor
cmpwi     r3, 0
beq       loc_804E3398
lwz       r12, 0(r31)
mr        r3, r31
lwz       r12, 0x34(r12)
mtctr     r12
bctrl
loc_804E3398:
lwz       r0, 0x14(r1)
lwz       r31, 0x0C(r1)
mtlr      r0
addi      r1, r1, 0x10
blr


.MINI_COMET_CONNECTOR:
.GLE ENDADDRESS

.GLE ADDRESS cCreateTable__14NameObjFactory +0x1570
.int MiniComet_NameEN
.GLE ENDADDRESS

.GLE ADDRESS createNameObj<12ItemRoomDoor>__14NameObjFactoryFPCc_P7NameObj +0x28
bl .MiniComet_Create
.GLE ENDADDRESS

.GLE ADDRESS MiniComet_Data

MiniComet_NameJP:
    .string "コメット（ワールドマップ）"

MiniComet_NameEN:
    .string "MiniComet"

MiniComet_Appear:
    .string "Appear" AUTO

MiniComet_VTable:
.int 0
.int 0
.int __dt__21StarReturnDemoStarterFv   #SOMEBODY STOP THIS MAN!1!!!1
.int .MiniComet_Init
.int initAfterPlacement__7NameObjFv
.int movement__9LiveActorFv
.int draw__7NameObjCFv
.int calcAnim__9LiveActorFv
.int calcViewAndEntry__9LiveActorFv
.int startMovement__7NameObjFv
.int endMovement__7NameObjFv
.int .MiniComet_Appear
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

MiniComet_NrvVTable:
.int 0
.int 0
.int .MiniComet_Nrv
.int executeOnEnd__5NerveCFP5Spine

.GLE ENDADDRESS