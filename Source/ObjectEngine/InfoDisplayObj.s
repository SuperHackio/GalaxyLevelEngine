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



mr        r3, r31
lwz       r31, 0x0C(r1)
lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr

#-----------------------------------------------------

.InfoDisplayObj_Init:


#-----------------------------------------------------
.InfoDisplayObj_Appear:
blr


.InfoDisplayObj_ObjName:
    .string "InfoDisplayObj"
    
.InfoDisplayObj_CutsceneNameForTemp:
    .string "InfoDispObjTemp" AUTO


.InfoDisplayObj_VTable:
.int 0
.int 0
.int __dt__21StarReturnDemoStarterFv   #MOOOOM! PHINEAS AND FERB ARE RECYCLING DTOR'S!
.int .InfoDisplayObj_Init
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

.INFODISPLAYOBJ_CONNECTOR:
.GLE ENDADDRESS