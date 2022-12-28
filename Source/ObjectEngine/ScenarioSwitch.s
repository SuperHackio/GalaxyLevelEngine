
.GLE ADDRESS cCreateTable__14NameObjFactory +0x18B8
#Replaces AuroraSky. Just add it to the ProductMapObjDataTable lol
.int ScenarioSwitch_ObjName
.int .ScenarioSwitch_Create
.GLE ENDADDRESS

#TODO: Consider moving this?
.GLE ADDRESS sub_804F46C0
blr
#==========================================

.ScenarioSwitch_Create:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
mr        r31, r3

li        r3, 0x9C
bl __nw__FUl
cmpwi     r3, 0
beq       .ScenarioSwitch_Create_Return
mr        r4, r31
bl .ScenarioSwitch_Ctor

.ScenarioSwitch_Create_Return:
lwz       r0, 0x14(r1)
lwz       r31, 0x0C(r1)
mtlr      r0
addi      r1, r1, 0x10
blr

#==========================================

.ScenarioSwitch_Ctor:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
mr        r31, r3

bl        __ct__9LiveActorFPCc
lis       r3, ScenarioSwitch_VTable@ha
addi      r3, r3, ScenarioSwitch_VTable@l
stw       r3, 0(r31)
li        r4, 0
stw       r4, 0x90(r31) #bool IsActivate
stw       r4, 0x94(r31) #bool DoNothingOnFail (Obj Arg 1)
stw       r4, 0x98(r31) #int JMap Index (Obj Arg 0)

mr        r3, r31
lwz       r31, 0x0C(r1)
lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr

#==========================================

.ScenarioSwitch_Init:
stwu      r1, -0x30(r1)
mflr      r0
stw       r0, 0x34(r1)
addi r11, r1, 0x30
bl _savegpr_23
mr        r31, r4
mr        r30, r3

bl        connectToSceneMapObjMovement__2MRFP7NameObj
mr        r3, r31
addi      r4, r30, 0x98
bl        getJMapInfoArg0NoInit__2MRFRC12JMapInfoIterPl
mr        r3, r31
addi      r4, r30, 0x94
bl        getJMapInfoArg1NoInit__2MRFRC12JMapInfoIterPl


.ScenarioSwitch_InitSwitches:
mr        r3, r30
mr        r4, r31
bl        useStageSwitchWriteA__2MRFP9LiveActorRC12JMapInfoIter

mr        r3, r30
mr        r4, r31
bl        useStageSwitchWriteB__2MRFP9LiveActorRC12JMapInfoIter

mr        r3, r30
bl        invalidateClipping__2MRFP9LiveActor

mr        r3, r30
lwz       r12, 0(r30)
lwz       r12, 0x2C(r12)
mtctr     r12
bctrl #ScenarioSwitch_Appear

#Only jump here if an error occurs
.ScenarioSwitch_ReturnInit:
addi r11, r1, 0x30
bl _restgpr_23
lwz       r0, 0x34(r1)
mtlr      r0
addi      r1, r1, 0x30
blr

#==========================================

.ScenarioSwitch_Appear:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw r31, 0x0C(r1)
mr r31, r3

bl .ScenarioSwitch_ConditionCheck

mr r3, r31
lwz       r12, 0(r3)
lwz       r12, 0x30(r12)
mtctr     r12
bctrl

lwz r31, 0x0C(r1)
lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr

#==========================================

.ScenarioSwitch_ConditionCheck:
stwu      r1, -0x30(r1)
mflr      r0
stw       r0, 0x34(r1)
addi r11, r1, 0x30
bl _savegpr_27

mr r30, r3  #this

lis r3, ScenarioSwitch_BcsvName@ha
addi r3, r3, ScenarioSwitch_BcsvName@l
crclr     4*cr1+eq
bl tryLoadCsvFromZoneInfo__2MRFPCc
cmpwi r3, 0
beq .ScenarioSwitch_ConditionCheck_Return #Can't find the file

mr r29, r3
bl getCsvDataElementNum__2MRFPC8JMapInfo
mr r28, r3

lwz r4, 0x98(r30)
cmpw r4, r3
bge .ScenarioSwitch_ConditionCheck_Return #Index ouf of Range

mr r3, r29
lwz r4, 0x98(r30)
bl isJMapEntryProgressComplete
stw r3, 0x90(r30) #Check status

.ScenarioSwitch_ConditionCheck_Return:
addi r11, r1, 0x30
bl _restgpr_27
lwz       r0, 0x34(r1)
mtlr      r0
addi      r1, r1, 0x30
blr

#==========================================

.ScenarioSwitch_Control:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
mr        r31, r3
lwz r4, 0x90(r3)
cmpwi r4, 0
beq .ScenarioSwitch_SwitchCaseOff

#Case 1: Checks pass
bl isValidSwitchA__2MRFPC9LiveActor
cmpwi r3, 0
beq .ScenarioSwitch_TryOffSW_B

mr r3, r31
bl onSwitchA__2MRFP9LiveActor

.ScenarioSwitch_TryOffSW_B:
mr r3, r31
bl isValidSwitchB__2MRFPC9LiveActor
cmpwi r3, 0
beq .ScenarioSwitch_KillObj

mr r3, r31
bl offSwitchB__2MRFP9LiveActor
b .ScenarioSwitch_KillObj

#Case 2: Checks fail
.ScenarioSwitch_SwitchCaseOff:
lwz r4, 0x94(r3)
cmpwi r4, 0
bne .ScenarioSwitch_KillObj

bl isValidSwitchA__2MRFPC9LiveActor
cmpwi r3, 0
beq .ScenarioSwitch_TryOnSW_B
mr r3, r31
bl offSwitchA__2MRFP9LiveActor

.ScenarioSwitch_TryOnSW_B:
mr r3, r31
bl isValidSwitchB__2MRFPC9LiveActor
cmpwi r3, 0
beq .ScenarioSwitch_KillObj
mr r3, r31
bl onSwitchB__2MRFP9LiveActor

.ScenarioSwitch_KillObj:
lwz       r12, 0(r31)
mr        r3, r31
lwz       r12, 0x34(r12)
mtctr     r12
bctrl     #LiveActor::kill((void))

.ScenarioSwitch_ReturnControl:
lwz       r0, 0x14(r1)
lwz       r31, 0x0C(r1)
mtlr      r0
addi      r1, r1, 0x10
blr


#Revives all ScenarioSwitches
.ScenarioSwitch_ReviveAll:
lis r3, ScenarioSwitch_ObjName@ha
addi r3, r3, ScenarioSwitch_ObjName@l
lis r4, ScenarioSwitch_VTable@ha
addi r4, r4, ScenarioSwitch_VTable@l
lwz r4, 0x2C(r4)
b .GLE_ForEachNameObj


ScenarioSwitch_ObjName:
ScenarioSwitch_BcsvName:
    .string "ScenarioSwitch"
    
#This is here because yes
.set NPC_AnimTable_BCSVNamePtr, NPC_AnimTable_BcsvName
NPC_AnimTable_BcsvName:
    .string "NPCAnimeFunc" AUTO

ScenarioSwitch_VTable:
.int 0
.int 0
.int __dt__11TimerSwitchFv   #Stealing TimerSwitch's DTor again
.int .ScenarioSwitch_Init
.int .ScenarioSwitch_Control
.int movement__9LiveActorFv
.int draw__7NameObjCFv
.int calcAnim__9LiveActorFv
.int calcViewAndEntry__9LiveActorFv
.int startMovement__7NameObjFv
.int endMovement__7NameObjFv
.int .ScenarioSwitch_Appear
.int makeActorAppeared__9LiveActorFv
.int kill__9LiveActorFv
.int makeActorDead__9LiveActorFv
.int receiveMessage__9LiveActorFUlP9HitSensorP9HitSensor
.int getBaseMtx__9LiveActorCFv
.int getTakingMtx__9LiveActorCFv
.int startClipped__9LiveActorFv
.int endClipped__9LiveActorFv
.int .ScenarioSwitch_Control
.int calcAndSetBaseMtx__9LiveActorFv
.int updateHitSensor__9LiveActorFP9HitSensor
.int attackSensor__9LiveActorFP9HitSensorP9HitSensor
.int receiveMsgPush__9LiveActorFP9HitSensorP9HitSensor
.int receiveMsgPlayerAttack__9LiveActorFUlP9HitSensorP9HitSensor
.int receiveMsgEnemyAttack__9LiveActorFUlP9HitSensorP9HitSensor
.int receiveOtherMsg__9LiveActorFUlP9HitSensorP9HitSensor

.GLE ASSERT sub_804F5550
.GLE ENDADDRESS