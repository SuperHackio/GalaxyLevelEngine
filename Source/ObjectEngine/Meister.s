#Lubba will be reduced to a normal NPC here
#Not including this in the NPC_Utility.s because this is a complete object re-write, not just a couple fixes

.GLE ADDRESS MeisterObjEntry
.int .MeisterObjName
.int .MeisterNEW
.GLE ENDADDRESS

.GLE ADDRESS createNameObj<7Meister>__14NameObjFactoryFPCc_P7NameObj
.MeisterNEW:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
mr        r31, r3
li        r3, 0x164
bl       __nw__FUl
cmpwi     r3, 0
beq       .MeisterNEWReturn
mr        r4, r31
bl        .MeisterCtor

.MeisterNEWReturn:
lwz       r0, 0x14(r1)
lwz       r31, 0x0C(r1)
mtlr      r0
addi      r1, r1, 0x10
blr
.GLE ENDADDRESS

.GLE ADDRESS __ct__7MeisterFPCc
#Here's the chunky boi

#Meister::Meister((char const *))
.MeisterCtor:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
mr        r31, r3
bl        __ct__8NPCActorFPCc
lis       r4,.MeisterVTable@ha
mr        r3, r31
addi      r4, r4, .MeisterVTable@l
stw       r4, 0(r31)
lwz       r31, 0x0C(r1)
lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr
#==================================
.MeisterInit:
stwu      r1, -0x150(r1)
mflr      r0
stw       r0, 0x154(r1)
addi      r11, r1, 0x150
bl        _savegpr_29

mr        r29, r3 #this
mr        r30, r4 #JMapInfoIter
lis       r31, MeisterDataLoc@ha
addi      r31, r31, MeisterDataLoc@l

#--- This part could be used in theory to make a custom NPC ProductMapObjDataTable class maybe? idk tbh...
addi      r3, r1, 0x08
bl getObjectName__2MRFPPCcRC12JMapInfoIter

li r3, 0x70
bl       __nw__FUl

stw      r3, 0x0C(r1)
li        r4, 0x70
addi r5, r31, .AnimFile_Format - MeisterDataLoc@l
lwz r6, 0x08(r1)
crclr     4*cr1+eq
bl        snprintf


#NPC init time
addi      r3, r1, 0x10
lwz r4, 0x08(r1) #Get the name of the object
bl        __ct__12NPCActorCapsFPCc

addi      r3, r1, 0x10
bl        setDefault__12NPCActorCapsFv

mr        r3, r29
mr        r4, r30
addi      r5, r1, 0x10
lwz r6, 0x08(r1)
li        r7, 0
lwz r8, 0x0C(r1)
bl        initialize__8NPCActorFRC12JMapInfoIterRC12NPCActorCapsPCcPCcb

addi r4, r31, .NPC_Reaction - MeisterDataLoc@l
addi r5, r31, .NPC_Pointing - MeisterDataLoc@l
addi r6, r31, .NPC_Trampled - MeisterDataLoc@l
addi r7, r31, .NPC_Spin - MeisterDataLoc@l
addi r8, r31, .NPC_Turn - MeisterDataLoc@l
addi r9, r31, .NPC_Talk - MeisterDataLoc@l
addi r0, r31, .NPC_Wait - MeisterDataLoc@l

stw       r0, 0x100(r29)
stw       r8, 0x104(r29)
stw       r9, 0x108(r29)
stw       r8, 0x10C(r29)
stw       r7, 0x134(r29)
stw       r6, 0x138(r29)
stw       r5, 0x13C(r29)
stw       r4, 0x140(r29)

mr        r3, r29
mr        r4, r30
bl .MR_RegisterTalkToDemo

lfs       f1, MeisterZero - STATIC_R2(r2)
addi      r3, r1, 0xE0+var_D4
bl        __ct__Q29JGeometry8TVec3<f>Ff
mr        r7, r3
mr        r3, r29
addi      r5, r31, 0
li        r4, 4
li        r6, 0
bl        initSound__9LiveActorFlPCcPCQ29JGeometry8TVec3<f>RCQ29JGeometry8TVec3<f>


addi      r11, r1, 0x150
bl        _restgpr_29
lwz       r0, 0x154(r1)
mtlr      r0
addi      r1, r1, 0x150
blr




.END_OF_MEISTER_CODE:
#This indicator is here so the compiler knows where to place code. We have a lot of extra room here, which was the goal.



.GLE ASSERT __sinit_\Meister_cpp
.GLE ENDADDRESS

.GLE ADDRESS MeisterDataLoc
.MeisterObjName:
    .string "Meister"

.AnimFile_Format:
    .string "%sAnim" 

.NPC_Reaction:
    .string "Reaction"

.NPC_Pointing:
    .string "Pointing"
    
.NPC_Trampled:
    .string "Trampled"
    
.NPC_Spin:
    .string "Spin"
    
.NPC_Turn:
    .string "Turn"
    
.NPC_Talk:
    .string "Talk"
    
.NPC_Wait:
    .string "Wait" AUTO

.MeisterVTable:
.int 0
.int 0
.int __dt__5PeachFv   #Share a DTor with Peach... they're identical anyways
.int .MeisterInit
.int initAfterPlacement__8NPCActorFv
.int movement__9LiveActorFv
.int draw__7NameObjCFv
.int calcAnim__9LiveActorFv
.int calcViewAndEntry__9LiveActorFv
.int startMovement__7NameObjFv
.int endMovement__7NameObjFv
.int appear__9LiveActorFv
.int makeActorAppeared__8NPCActorFv
.int kill__8NPCActorFv
.int makeActorDead__8NPCActorFv
.int receiveMessage__9LiveActorFUlP9HitSensorP9HitSensor
.int getBaseMtx__9LiveActorCFv
.int getTakingMtx__9LiveActorCFv
.int startClipped__9LiveActorFv
.int endClipped__9LiveActorFv
.int control__8NPCActorFv
.int calcAndSetBaseMtx__8NPCActorFv
.int updateHitSensor__9LiveActorFP9HitSensor
.int attackSensor__8NPCActorFP9HitSensorP9HitSensor
.int receiveMsgPush__9LiveActorFP9HitSensorP9HitSensor
.int receiveMsgPlayerAttack__8NPCActorFUlP9HitSensorP9HitSensor
.int receiveMsgEnemyAttack__8NPCActorFUlP9HitSensorP9HitSensor
.int receiveOtherMsg__8NPCActorFUlP9HitSensorP9HitSensor
.int isReactionNerve__8NPCActorCFv
.int isSensorSpinCloudBlock__8NPCActorCFPC9HitSensor

#Got a lot of space here
.END_OF_MEISTER_DATA:
.GLE ENDADDRESS