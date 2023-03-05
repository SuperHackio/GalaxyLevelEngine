.GLE ADDRESS init__21StarReturnDemoStarterFRC12JMapInfoIter +0x104
b .InitReturnDemoCamera
.InitReturnDemoCamera_Return:
mr        r3, r27
mr        r4, r28
bl tryRegisterDemoCast__2MRFP9LiveActorRC12JMapInfoIter
cmpwi r3, 0
beq .StarReturnDemoStarter_Failed
lwz       r3, 0xE0(r27)
mr        r4, r28
bl tryRegisterDemoCast__2MRFP9LiveActorRC12JMapInfoIter
lwz       r3, 0xE4(r27)
mr        r4, r28
bl tryRegisterDemoCast__2MRFP9LiveActorRC12JMapInfoIter

.StarReturnDemoStarter_Failed:
.GLE ENDADDRESS

#This file will also include the ReturnDemoCamera
#Which is kinda a copy-paste of the normal spindrivercamera
#but instead it gets it's path ID from the path itself.

.GLE ADDRESS createNameObj<21StarReturnDemoStarter>__14NameObjFactoryFPCc_P7NameObj +0x14
li r3, 0x114
.GLE ENDADDRESS

.GLE ADDRESS __ct__21StarReturnDemoStarterFPCc +0x6C
b .StarReturnDemoStarter_InitEx
.StarReturnDemoStarter_InitEx_Return:
.GLE ENDADDRESS

.GLE ADDRESS .MINI_COMET_CONNECTOR

.StarReturnDemoStarter_InitEx:
#Gonna borrow ScenarioStarter's floats
lfs       f1, ScenarioStarter_0flt - STATIC_R2(r2)
lfs       f2, ScenarioStarter_1flt - STATIC_R2(r2)

stfs f1, 0xE8(r31) #0.0
stfs f2, 0xEC(r31) #1.0
stfs f1, 0xF0(r31) #0.0

stfs f1, 0xF4(r31) #0.0
stfs f1, 0xF8(r31) #0.0
stfs f2, 0xFC(r31) #1.0

stfs f1, 0x104(r31) #0.0
stfs f2, 0x108(r31) #1.0
stfs f1, 0x10C(r31) #0.0

li        r3, 0x10
bl __nw__FUl
bl .ReturnDemoCamera_Ctor
stw r3, 0x100(r31)

mr r3, r31
b .StarReturnDemoStarter_InitEx_Return


#Just use the SpinDriverCamera's Ctor
.ReturnDemoCamera_Ctor:
b __ct__16SpinDriverCameraFv





.InitReturnDemoCamera:
mr r3, r27
mr r4, r28
lwz r5, 0x100(r27)
bl .ReturnDemoCamera_Init
b .InitReturnDemoCamera_Return



.ReturnDemoCamera_Init:
stwu      r1, -0x30(r1)
mflr      r0
stw       r0, 0x34(r1)
addi      r11, r1, 0x30
bl        _savegpr_29
mr        r31, r3 #StarReturnDemoStarter
mr        r30, r4 #JMapInfoIter
mr        r29, r5 #ReturnDemoCamera

mr r3, r31
bl initRailRider__9LiveActorFRC12JMapInfoIter

mr        r3, r31
addi      r4, r1, 0x10
bl getRailArg0NoInit__2MRFPC9LiveActorPl
cmpwi r3, 0
beq .ReturnDemoCamera_InitReturn  #Rail arg 0 is -1, no camera wanted

mr        r3, r30
bl getPlacedZoneId__2MRFRC12JMapInfoIter
stw r3, 0x14(r1)

li r0, 1
stw r0, 0x08(r1)

mr r3, r31
addi r4, r1, 0x08
bl getRailArg1NoInit__2MRFPC9LiveActorPl

li r3, 0x2C
bl __nw__FUl
cmpwi r3, 0
beq .ReturnDemoCamera_MultiEventCameraCreateFail
bl __ct__16MultiEventCameraFv
.ReturnDemoCamera_MultiEventCameraCreateFail:
stw r3, 0(r29)

li r3, 0x08
bl __nw__FUl
cmpwi r3, 0
beq .ReturnDemoCamera_ActorCameraInfoCreateFail
lwz r4, 0x10(r1)
lwz r5, 0x14(r1)
bl __ct__15ActorCameraInfoFll
.ReturnDemoCamera_ActorCameraInfoCreateFail:

mr r5, r3
lwz r3, 0x00(r29)
lwz r4, 0x04(r31)
lwz r6, 0x08(r1)
bl setUp__16MultiEventCameraFPCcPC15ActorCameraInfol

li        r3, 0x94
bl __nw__FUl
cmpwi r3, 0
beq .ReturnDemoCamera_CameraTargetMtxCreateFail

lis r4, CameraTargetDummy@ha
addi r4, r4, CameraTargetDummy@l
bl __ct__15CameraTargetMtxFPCc
.ReturnDemoCamera_CameraTargetMtxCreateFail:
stw r3, 0x04(r29)

.ReturnDemoCamera_InitReturn:
addi      r11, r1, 0x30
bl        _restgpr_29
lwz       r0, 0x34(r1)
mtlr      r0
addi      r1, r1, 0x30
blr



.GLE ADDRESS exeAppearWait__21StarReturnDemoStarterFv +0x20
b .StartReturnCamera
.StartReturnCamera_Return:
.GLE ENDADDRESS

.StartReturnCamera:
bl getPlayerPos__2MRFv
mr r6, r3
lwz r3, 0x100(r31)
addi r4, r31, 0xE8
addi r5, r31, 0xF4
#addi r6, r31, 0x14
bl start__16SpinDriverCameraFRCQ29JGeometry8TVec3<f>RCQ29JGeometry8TVec3<f>RCQ29JGeometry8TVec3<f>

bl hidePlayer__2MRFv
b .StartReturnCamera_Return




.GLE ADDRESS exeMove__21StarReturnDemoStarterFv +0x60
b .UpdateReturnCamera
.UpdateReturnCamera_Return:
.GLE ENDADDRESS

.UpdateReturnCamera:
bl getPlayerPos__2MRFv
mr r5, r3
lwz       r3, 0x100(r29)
addi      r4, r3, 0x18
#addi      r5, r29, 0x14
bl update__16SpinDriverCameraFRCQ29JGeometry8TVec3<f>RCQ29JGeometry8TVec3<f>

lwz r3, 0x100(r29)
lwz r3, 0x00(r3)
cmpwi r3, 0
beq .NotUpdateYet
bl changeTargetPlayer__16MultiEventCameraFv

.NotUpdateYet:
lwz       r3, 0xE0(r29)
b .UpdateReturnCamera_Return



.GLE ADDRESS exeLand__21StarReturnDemoStarterFv +0x40
b .EndReturnCamera
.EndReturnCamera_Return:
.GLE ENDADDRESS

.EndReturnCamera:
bl tryRumblePadMiddle__2MRFPCvl

lwz r3, 0x100(r29)
lwz r3, 0x00(r3)
cmpwi r3, 0
beq .NotYetCancel
bl changeTargetPlayer__16MultiEventCameraFv


.NotYetCancel:
b .EndReturnCamera_Return

.POWER_STAR_RETURN_DEMO_STARTER_CONNECTOR:
.GLE ENDADDRESS

.GLE ADDRESS exeStageResultAfter__21StarReturnDemoStarterFv +0x34
#Don't start the music here...this doesn't even do anything in the original game Nintendo whyyyy
nop
.GLE ENDADDRESS