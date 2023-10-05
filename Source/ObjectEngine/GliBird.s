#Fluzzard stuff

.GLE ADDRESS getRaceBestTime__2MRFi
stwu      r1, -0x120(r1)
mflr      r0
stw       r0, 0x124(r1)
addi r4, r1, 0x0C
bl       .getRaceName
addi r3, r1, 0x0C
bl       getRaceBestTime__16GameDataFunctionFPCc
lwz       r0, 0x124(r1)
mtlr      r0
addi      r1, r1, 0x120
blr
.GLE ENDADDRESS


.GLE ADDRESS setRaceBestTime__2MRFiUl
stwu      r1, -0x130(r1)
mflr      r0
stw       r0, 0x134(r1)
stw       r31, 0x12C(r1)
mr        r31, r4
addi r4, r1, 0x0C
bl       .getRaceName
addi r3, r1, 0x0C
mr        r4, r31
bl       setRaceBestTime__16GameDataFunctionFPCcUl
lwz       r0, 0x134(r1)
lwz       r31, 0x12C(r1)
mtlr      r0
addi      r1, r1, 0x130
blr
.GLE ENDADDRESS


.GLE ADDRESS getRaceName__19RaceManagerFunctionFi
.getRaceId:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)

lis r3, RaceId@ha
addi r3, r3, RaceId@l
#don't set r4, it's already set to what we want
li r5, 0
bl .MR_GetScenarioSetting
cmpwi r3, 0
bgt .Found
li r3, -1

.Found:
lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr



.getRaceName:
stwu      r1, -0x80(r1)
mflr      r0
stw       r0, 0x84(r1)
addi      r11, r1, 0x80
bl _savegpr_29

mr r6, r3
mr r3, r4
li r4, 0x50
lis       r5, Glider_Format@ha
addi      r5, r5, Glider_Format@l
crclr     4*cr1+eq
bl       snprintf

addi      r11, r1, 0x80
bl _restgpr_29
lwz       r0, 0x84(r1)
mtlr      r0
addi      r1, r1, 0x80
blr

#just enough space for this lol
.tryValidateRaceSensorOrSomething:
cmpwi r3, 0
beq .SkipSensorValidate
bl validateHitSensors__2MRFP9LiveActor
.SkipSensorValidate:
b .tryValidateRaceSensorOrSomething_Return

#is this offset really a good idea??
.GLE ADDRESS renewTime__11RaceManagerFv +0x68
b .tryValidateRaceSensorOrSomething
.tryValidateRaceSensorOrSomething_Return:
.GLE ENDADDRESS

.GLE PRINTADDRESS
.GLE ASSERT sub_80265470
.GLE ENDADDRESS

.GLE ADDRESS hasRecordedRaceTimeInScenario__2MRFi +0x5C
bl .getRaceId
.GLE ENDADDRESS

.GLE ADDRESS exeIntro__11RaceManagerFv +0x34
#Unused star pointer functionality
li r0,0
.GLE ENDADDRESS
