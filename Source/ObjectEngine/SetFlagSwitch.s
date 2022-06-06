#An object to let users better control flags.
#This also lets you make and use custom game flags via the GameEventValueTable!
#Note that this only sets the values. To read them, use ScenarioSwitch.
#
#Obj Arg 0 = BCSV Entry ID
#Obj Arg 1 = Flag Bool (-1/0 = OFF, 0> = ON)
#Obj Arg 2 = Event Value. Default 0

.GLE ADDRESS MarioFacePlanetTakeOffDemoObj
SetFlagSwitch_ObjName:
SetFlagSwitch_BCSVName:
    .string "SetFlagSwitch" AUTO
    
.GLE ENDADDRESS

.GLE ADDRESS createNameObj<29MarioFacePlanetTakeOffDemoObj>__14NameObjFactoryFPCc_P7NameObj
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
mr        r31, r3

li        r3, 0xA0
bl __nw__FUl
cmpwi     r3, 0
beq       .SetFlagSwitch_Return
mr        r4, r31
bl .SetFlagSwitch_Ctor

.SetFlagSwitch_Return:
lwz       r0, 0x14(r1)
lwz       r31, 0x0C(r1)
mtlr      r0
addi      r1, r1, 0x10
blr
.GLE ENDADDRESS

.GLE ADDRESS __ct__29MarioFacePlanetTakeOffDemoObjFPCc
.SetFlagSwitch_Ctor:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
mr        r31, r3

bl        __ct__9LiveActorFPCc
lis       r3, .SetFlagSwitch_VTable@ha
addi      r3, r3, .SetFlagSwitch_VTable@l
stw       r3, 0(r31)
li        r4, 0
stw       r4, 0x90(r31) #int32 BCSV Entry ID
stw       r4, 0x94(r31) #bool value. Only used if the BCSV Entry defines a FlagName. -1 = OFF, >* = ON
stw       r4, 0x98(r31) #uint16 Value. Only used if the BCSV entry defines an EventValue
stw       r4, 0x9C(r31) #BCSV*

mr        r3, r31
lwz       r31, 0x0C(r1)
lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr
#======================================
.SetFlagSwitch_Init:
stwu      r1, -0x20(r1)
mflr      r0
stw       r0, 0x24(r1)
addi r11, r1, 0x20
bl _savegpr_26
mr        r31, r4 #JMapInfo
mr        r30, r3 #this

bl        connectToSceneMapObjMovement__2MRFP7NameObj

mr        r3, r31
addi      r4, r30, 0x90
bl        getJMapInfoArg0NoInit__2MRFRC12JMapInfoIterPl
mr        r3, r31
addi      r4, r30, 0x94
bl        getJMapInfoArg1NoInit__2MRFRC12JMapInfoIterPl
mr        r3, r31
addi      r4, r30, 0x98
bl        getJMapInfoArg2NoInit__2MRFRC12JMapInfoIterPl

lis r3, SetFlagSwitch_BCSVName@ha
addi r3, r3, SetFlagSwitch_BCSVName@l
crclr     4*cr1+eq
bl tryLoadCsvFromZoneInfo__2MRFPCc
cmpwi r3, 0
beq .SetFlagSwitch_ReturnInit #Can't find the file

stw r3, 0x9C(r30) #Store the BCSV

mr r3, r30
mr r4, r31
bl useStageSwitchReadA__2MRFP9LiveActorRC12JMapInfoIter
mr r3, r30
mr r4, r31
bl tryRegisterDemoCast__2MRFP9LiveActorRC12JMapInfoIter

.SetFlagSwitch_ReturnInit:
addi r11, r1, 0x20
bl _restgpr_26
lwz       r0, 0x24(r1)
mtlr      r0
addi      r1, r1, 0x20
blr
#======================================
.SetFlagSwitch_Control:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
mr        r31, r3

bl isOnSwitchA__2MRFPC9LiveActor
cmpwi r3, 0
beq .SetFlagSwitch_ReturnControl

addi r3, r1, 0x08
lwz r4, 0x9C(r31)
lis r5, .SetFlagSwitch_FlagName@ha
addi r5, r5, .SetFlagSwitch_FlagName@l
lwz r6, 0x90(r31)
bl getCsvDataStrOrNULL__2MRFPPCcPC8JMapInfoPCcl

lwz r3, 0x08(r1)
cmpwi r3, 0
beq .SetFlagSwitch_TryEventValue
#Skip the flag set if it is blank

lwz r4, 0x94(r31)
cmpwi r4, 0
ble .FlagOff

bl onGameEventFlag__16GameDataFunctionFPCc
b .SetFlagSwitch_TryEventValue

.FlagOff:
bl offGameEventFlag__16GameDataFunctionFPCc

.SetFlagSwitch_TryEventValue:
addi r3, r1, 0x08
lwz r4, 0x9C(r31)
lis r5, .SetFlagSwitch_EventValueName@ha
addi r5, r5, .SetFlagSwitch_EventValueName@l
lwz r6, 0x90(r31)
bl getCsvDataStrOrNULL__2MRFPPCcPC8JMapInfoPCcl

lwz r3, 0x08(r1)
cmpwi r3, 0
beq .SetFlagSwitch_KillObj
#Skip the Event Value if it's empty

bl getGameEventValueChecker__16GameDataFunctionFv
lwz r4, 0x08(r1)
lwz r5, 0x98(r31)
bl setValue__21GameEventValueCheckerFPCcUs

.SetFlagSwitch_KillObj:
lwz       r12, 0(r31)
mr        r3, r31
lwz       r12, 0x34(r12)
mtctr     r12
bctrl     #LiveActor::kill((void))

.SetFlagSwitch_ReturnControl:
lwz       r0, 0x14(r1)
lwz       r31, 0x0C(r1)
mtlr      r0
addi      r1, r1, 0x10
blr

.GLE ASSERT __dt__29MarioFacePlanetTakeOffDemoObjFv
.GLE ENDADDRESS

.GLE ADDRESS __vt__29MarioFacePlanetTakeOffDemoObj
.SetFlagSwitch_FlagName:
.string "FlagName"
.SetFlagSwitch_EventValueName:
.string "EventValueName" AUTO

.SetFlagSwitch_VTable:
.int 0
.int 0
.int __dt__11TimerSwitchFv   #Stealing because I can
.int .SetFlagSwitch_Init
.int initAfterPlacement__7NameObjFv
.int .SetFlagSwitch_Control
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
.int .SetFlagSwitch_Control
.int calcAndSetBaseMtx__9LiveActorFv
.int updateHitSensor__9LiveActorFP9HitSensor
.int attackSensor__9LiveActorFP9HitSensorP9HitSensor
.int receiveMsgPush__9LiveActorFP9HitSensorP9HitSensor
.int receiveMsgPlayerAttack__9LiveActorFUlP9HitSensorP9HitSensor
.int receiveMsgEnemyAttack__9LiveActorFUlP9HitSensorP9HitSensor
.int receiveOtherMsg__9LiveActorFUlP9HitSensorP9HitSensor

.GLE ENDADDRESS