#This file holds code regarding if the player should stay in the level or not
#There are certainly caveots for having this system...

.GLE ADDRESS sub_804E53B0
#This is controlled by a ScenarioSetting. 0 = false, 1 = true.
#The code for it is in ScenarioSettings.s

#.IsScenarioNoBootOut from ScenarioSettings

.MR_IsNoBootActive:
lis r3, .PowerStarPtr@ha
addi r3, r3, .PowerStarPtr@l
lwz r3, 0x00(r3)
cmpwi r3, 0 #If Zero, normal boot out is active, so return false. r3 will always be 0 by this point thankfully.
beqlr
li r3, 1
blr


#Faster wipe to avoid wasting peoples time....
.NBO_DecideWipe:
bl .MR_IsNoBootActive
cmpwi r3, 0
bgt .NBO_WIPE_FAST

.NBO_WIPE_DEFAULT:
li        r3, 0x6E
b .NBO_DECIDE_WIPE_RETURN

.NBO_WIPE_FAST:
li r3, 0x30
b .NBO_DECIDE_WIPE_RETURN

.GLE ADDRESS exePowerStarGetDemo__22GameStageClearSequenceFv +0x8C
b .NBO_DecideWipe
.NBO_DECIDE_WIPE_RETURN:
.GLE ENDADDRESS



#First lets edit the PowerStar object to let us get the pointer to the star
.GLE ADDRESS receiveOtherMsg__9PowerStarFUlP9HitSensorP9HitSensor +0xA4
b .PowerStar_ReceiveOtherMessage_Ex
.PowerStar_ReceiveOtherMessage_Ex_Return:
.GLE ENDADDRESS

.PowerStar_ReceiveOtherMessage_Ex:
lwz       r3, 0x90(r29)
bl .IsScenarioNoBootOut
cmpwi r3, 0
beq .PowerStar_ReceiveOtherMessage_Ex_End
mr r3, r29

.PowerStar_ReceiveOtherMessage_Ex_End:
lis r4, .PowerStarPtr@ha
addi r4, r4, .PowerStarPtr@l
stw r3, 0x00(r4)

lbz       r0, 0x134(r29)
b .PowerStar_ReceiveOtherMessage_Ex_Return


#Now that the PowerStar has been set to the static variable, we can go ahead and edit the results to not kick us out
#This means that whatever star get stage change will not happen, which also means (I think...) that we need to mask the Power Star ourselves

.GLE ADDRESS stageClear__9GameSceneFv

.GLE ENDADDRESS

.MR_NoBootOut_OnRequestChangeStage:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw r31, 0x0C(r1)
stw r30, 0x08(r1)

lis r30, PowerStar_DataStart@ha
addi r30, r30, PowerStar_DataStart@l

#Get the PowerStar from the pointer
lis r3, .PowerStarPtr@ha
addi r3, r3, .PowerStarPtr@l
lwz r31, 0x00(r3)

mr r3, r31
bl endBindAndPlayerWait__2MRFP9LiveActor

#The PowerStar would've called
#MR::startAnimCameraTargetSelf((LiveActor const *,ActorCameraInfo const *,char const *,long,float))
#MR::endAnimCamera((LiveActor const *,ActorCameraInfo const *,char const *,long,bool))
mr        r3, r31
bl        sub_802E0AD0
mr        r5, r3
bl        isPlayerElementModeYoshi__2MRFv  #Confirmed to not use r5
cmpwi     r3, 0
beq       .loc_802E15D0
lbz       r0, 0x134(r31)
addi      r5, r30, (YoshiPowerStarGet - PowerStar_DataStart) # "YoshiPowerStarGet"
cmpwi     r0, 0
beq       .loc_802E15D0
addi      r5, r30, (YoshiGrandStarGet - PowerStar_DataStart) # "YoshiGrandStarGet"
.loc_802E15D0:

lwz       r3, 0x11C(r31)
lwz       r4, 0x13C(r31)
li        r6, -1
li        r7, 1
bl endAnimCamera__2MRFPC9LiveActorPC15ActorCameraInfoPCclb


bl getGameScene__31@unnamed@GameSceneFunction_cpp@Fv
bl setNerveAtStageStart__9GameSceneFv

mr        r3, r31
addi      r4, r13, (sInstance__Q212NrvPowerStar27PowerStarNrvWaitStartAppear - STATIC_R13)
bl        setNerve__9LiveActorFPC5Nerve

mr r3, r31
bl endStarPointerMode__2MRFPv

bl getGameScene__31@unnamed@GameSceneFunction_cpp@Fv
li r4, 0
stb r4, 0x29(r3)

bl startStage__17GameSceneFunctionFv
bl activateDefaultGameLayout__2MRFv


bl getGameScene__31@unnamed@GameSceneFunction_cpp@Fv
lwz       r3, 0x24(r3)
lwz       r3, 0x2C(r3)
bl kill__11LayoutActorFv

bl validateTalkDirector__2MRFv

mr r3, r31
lwz       r3, 0x11C(r3)
bl kill__9LiveActorFv

bl .MR_ApplyStarMask
bl getClearedPowerStarId__20GameSequenceFunctionFv
mr r4, r3
bl getClearedStageName__20GameSequenceFunctionFv
bl setPowerStar__16GameDataFunctionFPCcl

#Finally fixing this. Reactivate all ScnearioSwitch objects!
bl .ScenarioSwitch_ReviveAll

#Another interruption. Try to start a special cutscene!
bl .NoBootOut_TryStartDemo
cmpwi r3, 0
beq .NoBootOut_NoDemo
b .NoBootOut_DemoJumpLoc

.NoBootOut_NoDemo:
#This needs to be the last thing we do
li r3, 60
bl openWipeCircle__2MRFl

.NoBootOut_DemoJumpLoc:
bl        getSceneMgr__7AudWrapFv
li        r0, 0
stb       r0, 0xC(r3)


b .NoBootOut_ChangeStageAfterStageClear_Return

.NoBoot_NotHubworld:

.NoBootOut_ChangeStageAfterStageClear_Return:
lwz r31, 0x0C(r1)
lwz r30, 0x08(r1)
lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr



.NoBootOut_TryStartDemo:
stwu      r1, -0x100(r1)
mflr      r0
stw       r0, 0x104(r1)
addi      r11, r1, 0x100
bl _savegpr_29

lis r3, .PowerStarPtr@ha
addi r3, r3, .PowerStarPtr@l
lwz r31, 0x00(r3)

addi      r3, r1, 0x0C
li        r4, 0x90
#We're keeping this string inside SceneStrings.s
lis r5, NoBootOut_DemoFormat@ha
addi r5, r5, NoBootOut_DemoFormat@l
lwz r6, 0x90(r31)  #PowerStar number
crclr     4*cr1+eq
bl        snprintf

addi r3, r1, 0x0C
bl isDemoExist__2MRFPCc
cmpwi r3, 0
beq .NoBootOut_TryStartDemo_Return

#Try to start a cutscene

mr r3, r31
addi r4, r1, 0x0C
li r5, 0
bl tryStartTimeKeepDemoMarioPuppetable__2MRFP7NameObjPCcPCc

.NoBootOut_TryStartDemo_Return:
addi      r11, r1, 0x100
bl _restgpr_29
lwz       r0, 0x104(r1)
mtlr      r0
addi      r1, r1, 0x100
blr








.GLE ADDRESS movement__13BgmChangeAreaFv +0x5C
b .BgmChangeArea_Ex
.BgmChangeArea_Ex_Return:
.GLE ENDADDRESS

.BgmChangeArea_Ex:
bl setCubeBgmChangeInvalid__2MRFv
#Reset the area
li r3, 0
stb       r3, 0x48(r31)
b .BgmChangeArea_Ex_Return


.GLE ADDRESS exeStageClearDemo__9PowerStarFv +0x234
b .PowerStar_SkipMsg
nop
nop
.PowerStar_SkipMsgReturn:
.GLE ENDADDRESS

.PowerStar_SkipMsg:
bl .MR_IsNoBootActive
cmpwi r3, 0
bne .PowerStar_DoSkipMsg
li        r3, 0x82
mr        r4, r28
bl sendMsgToAllLiveActor__2MRFUlP9LiveActor
.PowerStar_DoSkipMsg:
b .PowerStar_SkipMsgReturn




.MR_ApplyStarMask:
stwu      r1, -0x120(r1)
mflr      r0
stw       r0, 0x124(r1)
addi      r11, r1, 0x120
bl _savegpr_29

bl makeCurrentGalaxyStatusAccessor__2MRFv
stw r3, 0x0C(r1)

bl getClearedPowerStarId__20GameSequenceFunctionFv
mr r30, r3
mr r6, r3

addi r3, r1, 0x0C
#Doesn't use any register other than r3
bl getWorldNo__20GalaxyStatusAccessorCFv
lis r4, StarMask@ha
addi r4, r4, StarMask@l
li r5, 2
bl .getActiveEntryFromGalaxyInfo

cmpwi r3, 0
beq .ChangeStageAfterStageClear

lis r4, GalaxyScenario_Format@ha
addi r4, r4, GalaxyScenario_Format@l
addi r5, r1, 0x0C
addi r6, r1, 0x08
crclr     4*cr1+eq
bl sscanf

#We got the values... hopefully the user added a space between the galaxy name and scenario...
bl getScenePlayingResult__2MRFv
addi      r4, r1, 0x0C
bl setStageName__18ScenePlayingResultFPCc

lwz r3, 0x08(r1)
bl setScenePlayingResultStarId__2MRFl
#Should be it...

.ChangeStageAfterStageClear:
addi      r11, r1, 0x120
bl _restgpr_29
lwz       r0, 0x124(r1)
mtlr      r0
addi      r1, r1, 0x120
blr




.GLE PRINTADDRESS
#Wow another GLE TRASH appearance
#Must come after everything due to how GLE TRASH works...or rather, doesn't work.... heh
.GLE TRASH BEGIN
.PowerStarPtr:
.int 0x00000000

#If the above is Zero, then we can just do the normal boot out
#otherwise, this needs a valid pointer to a PowerStar object.
.GLE TRASH END
.GLE ASSERT sub_804E5870
.GLE ENDADDRESS