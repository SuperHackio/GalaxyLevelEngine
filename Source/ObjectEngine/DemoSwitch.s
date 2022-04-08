#A Very, very basic object
#designed to be registered to cutscenes (demos) for an easy way to activate switches

.GLE ADDRESS MarioFaceAfterGrandStarTakeOffDemoObj
DemoSwitch_ObjName:
    .string "DemoSwitch" AUTO
    
.GLE ENDADDRESS

.GLE ADDRESS createNameObj<37MarioFaceAfterGrandStarTakeOffDemoObj>__14NameObjFactoryFPCc_P7NameObj
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
mr        r31, r3

li        r3, 0xA0
bl __nw__FUl
cmpwi     r3, 0
beq       .DemoSwitch_Return
mr        r4, r31
bl .DemoSwitch_Ctor

.DemoSwitch_Return:
lwz       r0, 0x14(r1)
lwz       r31, 0x0C(r1)
mtlr      r0
addi      r1, r1, 0x10
blr
.GLE ENDADDRESS

.GLE ADDRESS __ct__37MarioFaceAfterGrandStarTakeOffDemoObjFPCc
.DemoSwitch_Ctor:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
mr        r31, r3

bl        __ct__9LiveActorFPCc
lis       r3, __vt__37MarioFaceAfterGrandStarTakeOffDemoObj@ha
addi      r3, r3, __vt__37MarioFaceAfterGrandStarTakeOffDemoObj@l
stw       r3, 0(r31)

mr        r3, r31
lwz       r31, 0x0C(r1)
lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr

.DemoSwitch_Init:
stwu      r1, -0x20(r1)
mflr      r0
stw       r0, 0x24(r1)
addi r11, r1, 0x20
bl _savegpr_26

mr        r31, r3
mr        r30, r4
bl useStageSwitchWriteA__2MRFP9LiveActorRC12JMapInfoIter
mr r3, r31
mr r4, r30
bl useStageSwitchWriteB__2MRFP9LiveActorRC12JMapInfoIter
mr r3, r31
mr r4, r30
bl tryRegisterDemoCast__2MRFP9LiveActorRC12JMapInfoIter

addi r11, r1, 0x20
bl _restgpr_26
lwz       r0, 0x24(r1)
mtlr      r0
addi      r1, r1, 0x20
blr
.GLE ENDADDRESS

.GLE ADDRESS __vt__37MarioFaceAfterGrandStarTakeOffDemoObj
.int 0
.int 0
.int __dt__11TimerSwitchFv   #Stealing because I can
.int .DemoSwitch_Init
.int initAfterPlacement__7NameObjFv
.int movement__9LiveActorFv
.int draw__7NameObjCFv
.int calcAnim__9LiveActorFv
.int calcViewAndEntry__9LiveActorFv
.int startMovement__7NameObjFv
.int endMovement__7NameObjFv
.int appear__9LiveActorFv
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

.GLE ENDADDRESS