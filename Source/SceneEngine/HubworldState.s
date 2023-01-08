#Prevent MarioFaceShipSwitch from ever activating
.GLE ADDRESS onMarioFaceShipSwitches__2MRFv
blr
.GLE ENDADDRESS

.GLE ADDRESS appear__11CoinCounterFv +0x28
nop
.GLE ENDADDRESS

.GLE ADDRESS appear__11StarCounterFv +0x28
nop
.GLE ENDADDRESS


#This file consists of two major parts:
#The StarReturnDataTable and HubworldEventDataTable
#Big keys for the usual star return sequence.

.GLE ADDRESS sub_804C24E0
.MR_GetStarReturnDemoOverride:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)

bl MR_GetHubworldEventDataTable
mr r4, r3
bl MR_GetHubworldStarReturnDataTable
bl .GetReturnDemoOverride

lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr
.GLE ENDADDRESS

.GLE ADDRESS sub_804C2510
li r3, 0
blr
.GLE ENDADDRESS

.GLE ADDRESS sub_804C1AB0
.GetReturnDemoOverride:
#HubworldStarReturnDataTable::getReturnDemoOrOverride
#Returns a char const * to the return demo
#Returns the Galaxy Default if no event overrides it
#Returns the Default if the Galaxy doesn't override it
#Returns 0 if there are no defaults defined
#r3 = HubworldEventDataTable
#r4 = HubworldStarReturnDataTable
stwu      r1, -0x140(r1)
mflr      r0
stw       r0, 0x144(r1)
addi      r11, r1, 0x140
bl        _savegpr_22
mr r22, r3 #HubworldStarReturnDataTable.bcsv
mr r23, r4 #HubworldEventDataTable.bcsv

bl hasStageResultSequence__20GameSequenceFunctionFv
cmpwi r3, 0
beq .ReturnDemoOverride_Return


bl sub_804D6B10
cmpwi r3, 0
beq .ReturnDemoOverride_TryFindGalaxyOverride

addi r3, r1, 0x10
bl initEventArray__23MarioFaceShipEventStateFv
bl registerStarReturnEvents__23MarioFaceShipEventStateFPv
lwz r6, 0x10(r1)
cmpwi r6, -1
beq .ReturnDemoOverride_TryFindGalaxyOverride

addi r3, r1, 0x08
mr r4, r23
lis r5, ReturnDemoOverride_FieldName@ha
addi r5, r5, ReturnDemoOverride_FieldName@l
bl getCsvDataStr__2MRFPPCcPC8JMapInfoPCcl

lwz r3, 0x08(r1)
lis r4, NULLSTRING@ha
addi r4, r4, NULLSTRING@l
bl isEqualString__2MRFPCcPCc
cmpwi r3, 1
lwz r3, 0x08(r1)
bne .ReturnDemoOverride_Return

.ReturnDemoOverride_TryFindGalaxyOverride:
#Lets check the Galaxy Overrides
#Unlike with the events, We'll grab the first instance
#of each default
bl getClearedStageName__20GameSequenceFunctionFv
mr r28, r3
bl getClearedPowerStarId__20GameSequenceFunctionFv
mr r7, r3
mr r3, r22
lis r4, GalaxyName@ha
addi r4, r4, GalaxyName@l
lis r5, ScenarioNo@ha
addi r5, r5, ScenarioNo@l
mr r6, r28
bl .MR_getIndexWithGalaxyName
cmpwi r3, -1
beq .ReturnDemoOverride_TryGetDefaults #No Galaxy override found

#An override was found!
mr r6, r3
addi r3, r1, 0x08
mr r4, r22
lis r5, ReturnType@ha
addi r5, r5, ReturnType@l
bl getCsvDataStr__2MRFPPCcPC8JMapInfoPCcl

lwz r3, 0x08(r1)
lis r4, NULLSTRING@ha
addi r4, r4, NULLSTRING@l
bl isEqualString__2MRFPCcPCc
cmpwi r3, 1
beq .ReturnDemoOverride_TryGetDefaults #For some reason there's an empty string?

lwz r3, 0x08(r1)
b .ReturnDemoOverride_Return

.ReturnDemoOverride_TryGetDefaults:
bl sub_804D5CF0
cmpwi r3, 0
beq .ReturnDemoOverride_PowerStarReturn

bl sub_804D6B10
cmpwi r3, 0
beq .ReturnDemoOverride_GrandStarPlus

#Lets see if an override for the first time exists
mr r3, r22
lis r4, GalaxyName@ha
addi r4, r4, GalaxyName@l
lis r5, GRANDSTAR@ha
addi r5, r5, GRANDSTAR@l
bl isExistElement__8JMapInfoFPCcPCc
cmpwi r3, 0
#No override for first time exists, try the Plus instead
beq .ReturnDemoOverride_GrandStarPlus

lis r6, GRANDSTAR@ha
addi r6, r6, GRANDSTAR@l
b .ReturnDemoOverride_ReadDefault

.ReturnDemoOverride_GrandStarPlus:
#Case used for any time you grab a Grand Star you've already gotten
mr r3, r22
lis r4, GalaxyName@ha
addi r4, r4, GalaxyName@l
lis r5, GRANDSTARPLUS@ha
addi r5, r5, GRANDSTARPLUS@l
bl isExistElement__8JMapInfoFPCcPCc
cmpwi r3, 0
#No override for Grand Stars 2nd time exists....
#guess we'll try to get the PowerStar one
beq .ReturnDemoOverride_PowerStarReturn

lis r6, GRANDSTARPLUS@ha
addi r6, r6, GRANDSTARPLUS@l
b .ReturnDemoOverride_ReadDefault

.ReturnDemoOverride_PowerStarReturn:
mr r3, r22
lis r4, GalaxyName@ha
addi r4, r4, GalaxyName@l
lis r5, POWERSTAR@ha
addi r5, r5, POWERSTAR@l
bl isExistElement__8JMapInfoFPCcPCc
cmpwi r3, 0
#Really? No overrides? Fine then, return 0
beq .ReturnDemoOverride_Return

lis r6, POWERSTAR@ha
addi r6, r6, POWERSTAR@l

.ReturnDemoOverride_ReadDefault:
#Lets use one of SMG2's more obscure BCSV Reading techniques
addi r3, r1, 0x0C
mr r4, r22
lis r5, GalaxyName@ha
addi r5, r5, GalaxyName@l

lis r7, ReturnType@ha
addi r7, r7, ReturnType@l
bl findElement_PCc_PCc___8JMapInfoCFPCcli_12JMapInfoIter

#Well here we have access to a string, lets make sure it's
#not en empty string...
lwz r3, 0x0C(r1)
lis r4, NULLSTRING@ha
addi r4, r4, NULLSTRING@l
bl isEqualString__2MRFPCcPCc
cmpwi r3, 0
lwz r3, 0x0C(r1)
beq .ReturnDemoOverride_Return #Return with the non-empty string

li r3, 0 #Well now there's nothing else we can do

.ReturnDemoOverride_Return:
addi      r11, r1, 0x140
bl        _restgpr_22
lwz       r0, 0x144(r1)
mtlr      r0
addi      r1, r1, 0x140
blr


.GLE ADDRESS sub_804D5CF0 +0x50
li r3, 0
.GLE ENDADDRESS

#MR::getIndexWithGalaxyName
#Returns the index of the JMap Entry
#r3 = JMapInfo* (Only works for HubworldStarReturnDataTable)
#r4 = Galaxy Name Field Name
#r5 = Scenario No Field Name
#r6 = Galaxy Name
#r7 = ScenarioNo
.MR_getIndexWithGalaxyName:
stwu      r1, -0x100(r1)
mflr      r0
stw       r0, 0x104(r1)
addi      r11, r1, 0x100
bl        _savegpr_18

mr r31, r3 #JMapInfo
mr r30, r4 #Galaxy Name Field Name
mr r29, r5 #Scenario No Field Name
mr r28, r6 #Current GalaxyName
mr r27, r7 #Current ScenarioNo
li r26, 0  #i
li r25, -1 #GalaxyDefault
bl getCsvDataElementNum__2MRFPC8JMapInfo
mr r24, r3
b .getIndexWithGalaxyName_Loop_Start

.getIndexWithGalaxyName_Loop:
addi r3, r1, 0x08
mr r4, r31
mr r5, r30
mr r6, r26
bl getCsvDataStr__2MRFPPCcPC8JMapInfoPCcl

lwz r3, 0x08(r1)
mr r4, r28
bl isEqualString__2MRFPCcPCc
cmpwi r3, 0
#Galaxy Names do not match. Continue
beq .getIndexWithGalaxyName_Continue

addi r3, r1, 0x0C
mr r4, r31
mr r5, r29
mr r6, r26
bl getCsvDataS32__2MRFPlPC8JMapInfoPCcl

lwz r3, 0x0C(r1)
cmpw r3, r27
#Scenario No's do not match, test for default
bne .getIndexWithGalaxyName_MismatchScenario
mr r3, r26
b .getIndexWithGalaxyName_Return #Leave right away since
#we found a matching BCSV Entry

.getIndexWithGalaxyName_MismatchScenario:
cmpwi r3, -1
#ScenarioNo is not -1, we're looking at
#a different scenario's override
bgt .getIndexWithGalaxyName_Continue
mr r25, r26 #This is the Galaxy Default

.getIndexWithGalaxyName_Continue:
addi r26, r26, 1

.getIndexWithGalaxyName_Loop_Start:
cmpw r26, r24
blt .getIndexWithGalaxyName_Loop

#So now we got out of the loop, and this means we
#didn't find a suitable entry.
#Lets check to see if a default was found
cmpwi r25, -1
li r3, -1
ble .getIndexWithGalaxyName_Return #No default found
mr r3, r25

.getIndexWithGalaxyName_Return:
addi      r11, r1, 0x100
bl        _restgpr_18
lwz       r0, 0x104(r1)
mtlr      r0
addi      r1, r1, 0x100
blr
.GLE ENDADDRESS
#==================================================================
#==================================================================
#==================================================================
#==================================================================
#==================================================================
#==================================================================
#==================================================================
#==================================================================
#==================================================================
#==================================================================
#==================================================================
#==================================================================
#==================================================================
#==================================================================
#==================================================================
#==================================================================
.GLE ADDRESS appear__23MarioFaceShipEventStateFv
stwu      r1, -0x90(r1)
mflr      r0
stw       r0, 0x94(r1)
addi r11, r1, 0x90
bl _savegpr_29

mr r30, r3

li r31, 0
stb r31, 0x08(r30)

bl hasStageResultSequence__20GameSequenceFunctionFv
cmpwi     r3, 0
beq       .loc_804B4BFC
bl sub_804D6D70
cmpwi     r3, 0
beq       .loc_804B4BB0
li        r31, 1
.loc_804B4BB0:

cmpwi     r31, 0
beq       .EventState_Appear_OpenWipe
bl        forceCloseWipeCircle__2MRFv
b         .loc_804B4C04

.loc_804B4BFC:
addi      r3, r1, 0x08 #Init a temporary event array
bl initEventArray__23MarioFaceShipEventStateFv
mr r3, r30
addi r4, r1, 0x08
bl registerStartEvents__23MarioFaceShipEventStateFPv
lwz       r29, 0x08(r1) #Get the first event name
#Only one demo can be shown at this time

mr r3, r29
bl findDemoExecutor__12DemoFunctionFPCc
cmpwi r3, 0
bne .EventState_Appear_StartDemo
.EventState_Appear_OpenWipe:
li        r3, -1
bl       .MR_OpenCurrentWipe
.EventState_Appear_StartDemo:
.loc_804B4C04:

bl isGameSaveEnabled__2MRFv
cmpwi     r3, 0
beq       .loc_804B4C2C
lwz       r3, 0x10(r30)
lwz       r4, SaveDemoLoc - STATIC_R13(r13)
bl        tryStartDemoMarioPuppetableWithoutCinemaFrame__2MRFP7NameObjPCc
mr        r3, r30
addi      r4, r13, sInstance__Q226NrvMarioFaceShipEventState26HostTypeNrvWaitForOpenWipe - STATIC_R13
bl        setNerve__13NerveExecutorFPC5Nerve
b         .loc_804B4C6C

.loc_804B4C2C:
bl        hasStageResultSequence__20GameSequenceFunctionFv
cmpwi     r3, 0
bne       .loc_804B4C48
mr        r3, r30
addi      r4, r13, sInstance__Q226NrvMarioFaceShipEventState25HostTypeNrvStartingEvents - STATIC_R13
bl        setNerve__13NerveExecutorFPC5Nerve
b         .loc_804B4C6C

.loc_804B4C48:
cmpwi     r31, 0
beq       .loc_804B4C60
mr        r3, r30
addi      r4, r13, sInstance__Q226NrvMarioFaceShipEventState28HostTypeNrvStartGrandStarBgm - STATIC_R13
bl        setNerve__13NerveExecutorFPC5Nerve
b         .loc_804B4C6C
.loc_804B4C60:
mr        r3, r30
addi      r4, r13, sInstance__Q226NrvMarioFaceShipEventState25HostTypeNrvStarReturnDemo - STATIC_R13
bl        setNerve__13NerveExecutorFPC5Nerve

.loc_804B4C6C:
addi      r11, r1, 0x90
bl        _restgpr_29
lwz       r0, 0x94(r1)
mtlr      r0
addi      r1, r1, 0x90
blr

.GLE ENDADDRESS


.GLE ADDRESS exeStartingEvents__23MarioFaceShipEventStateFv
stwu      r1, -0x70(r1)
mflr      r0
stw       r0, 0x74(r1)
addi      r11, r1, 0x70
bl        _savegpr_28

mr        r28, r3
bl isFirstStep__2MRFPC13NerveExecutor
cmpwi     r3, 0
beq       .loc_804B5BB0

addi      r3, r1, 0x08 #Init a temporary event array
bl initEventArray__23MarioFaceShipEventStateFv
mr r3, r28
addi r4, r1, 0x08
bl registerStartEvents__23MarioFaceShipEventStateFPv
lwz       r29, 0x08(r1) #Get the first event name
#Only one demo can be shown at this time

mr r3, r29
bl findDemoExecutor__12DemoFunctionFPCc
cmpwi r3, 0
beq .SkipDemo

lwz       r3, 0x10(r28)
mr r4, r29
bl tryStartTimeKeepDemoMarioPuppetableWithoutCinemaFrame__2MRFP7NameObjPCc

.SkipDemo:
#Start Music
li r3, 1
bl startMarioFaceShipBGM__2MRFv


.loc_804B5BB0:
bl        isTimeKeepDemoActive__2MRFv
cmpwi     r3, 0
bne       .loc_804B5BEC
bl        isWipeBlank__2MRFv
cmpwi     r3, 0
beq       .loc_804B5BD0
li        r3, 0x1E
bl        openWipeFade__2MRFl


.loc_804B5BD0:
bl        endStartEvents__23MarioFaceShipEventStateFv

mr        r3, r28
lwz       r12, 0(r28)
lwz       r12, 0x14(r12)
mtctr     r12
bctrl

.loc_804B5BEC:
addi      r11, r1, 0x70
bl        _restgpr_28
lwz       r0, 0x74(r1)
mtlr      r0
addi      r1, r1, 0x70
blr
.GLE ENDADDRESS

.GLE ADDRESS endStartEvents__23MarioFaceShipEventStateFv
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)

bl isRunMarioFaceShipOpeningCamera__2MRFv
cmpwi r3, 0
beq .EndStartEvents_SkipOpeningDemo:
bl disableMarioFaceShipOpeningCamera__2MRFv

.EndStartEvents_SkipOpeningDemo:
bl isPlayGameOverDemo__2MRFv
cmpwi r3, 0
beq .EndStartEvents_SkipGameOverDemo
bl disablePlayGameOverDemo__2MRFv

.EndStartEvents_SkipGameOverDemo:
#Can add more here if needed...

.EndStartEvents_Return:
lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr
.GLE ENDADDRESS

.GLE ADDRESS registerStartEvents__23MarioFaceShipEventStateFPv
stwu      r1, -0x50(r1)
mflr      r0
stw       r0, 0x54(r1)
stw       r31, 0x4C(r1)
stw       r30, 0x48(r1)

mr        r31, r4

li        r0, 0
stw       r0, 0x20(r31)

bl isRunMarioFaceShipOpeningCamera__2MRFv
cmpwi r3, 0
beq .registerStartEvents_NoOpeningCam

mr r3, r31
lis r4, StartFromFileSelect@ha
addi r4, r4, StartFromFileSelect@l
bl .RegisterEvent

.registerStartEvents_NoOpeningCam:
bl isPlayGameOverDemo__2MRFv
cmpwi r3, 0
beq .registerStartEvents_NoGameOver

mr r3, r31
lis r4, DemoAfterGameOver@ha
addi r4, r4, DemoAfterGameOver@l
bl .RegisterEvent

.registerStartEvents_NoGameOver:

#This is where more events can be added.
#I'm considering adding one for when you press
#(BACK) on the Scenario Select

lwz       r0, 0x54(r1)
lwz       r31, 0x4C(r1)
lwz       r30, 0x48(r1)
mtlr      r0
addi      r1, r1, 0x50
blr
.GLE ENDADDRESS

.GLE ADDRESS initEventArray__23MarioFaceShipEventStateFv
addi      r0, r3, 0x20
mr        r5, r3
li        r4, -1

.loc_804B4B40:
stw       r4, 0(r5)
addi      r5, r5, 4
cmplw     r5, r0
blt       .loc_804B4B40
li        r0, 0
stw       r0, 0x20(r3) #Reset Max Count
blr
.GLE ENDADDRESS

.GLE ADDRESS registerEvent__23MarioFaceShipEventStateFP5Event
.RegisterEvent:
lwz       r7, 0x20(r3)
addi      r6, r7, 1
cmpwi r6, 8
bgtlr  #Don't add more than 8 events

stw       r6, 0x20(r3) #Increase event count
slwi      r0, r7, 2 #Shift to get the pointer
add       r3, r3, r0
stw       r4, 0(r3)
blr
.GLE ENDADDRESS

.GLE ADDRESS exeStarReturnDemo__23MarioFaceShipEventStateFv
stwu      r1, -0x20(r1)
mflr      r0
stw       r0, 0x24(r1)
addi      r11, r1, 0x20
bl _savegpr_28

mr        r29, r3

bl isFirstStep__2MRFPC13NerveExecutor
cmpwi     r3, 0
beq       .loc_804B5770

bl sub_804D6D70
cmpwi r3, 0
beq       .loc_804B5700
lwz       r3, 0x10(r29)
lwz       r4, BGMPrepareLoc - STATIC_R13(r13)
bl        endDemo__2MRFP7NameObjPCc

.loc_804B5700:
bl .MR_GetStarReturnDemoOverride
cmpwi r3, 0
beq .exeStarReturnDemo_SkipDemo
mr r28, r3
bl findDemoExecutor__12DemoFunctionFPCc
cmpwi r3, 0
beq .exeStarReturnDemo_SkipDemo

lwz       r3, 0x10(r29)
mr r4, r28
li        r5, 0
bl tryStartTimeKeepDemoMarioPuppetable__2MRFP7NameObjPCcPCc
mr        r3, r29
bl tryStartSaveDemo__23MarioFaceShipEventStateFv
.exeStarReturnDemo_SkipDemo:

.loc_804B5770:
bl        isTimeKeepDemoActive__2MRFv
cmpwi     r3, 0
bne       .loc_804B5784
mr        r3, r29
bl startStarReturnEvents__23MarioFaceShipEventStateFv

.loc_804B5784:
addi      r11, r1, 0x20
bl        _restgpr_28
lwz       r0, 0x24(r1)
mtlr      r0
addi      r1, r1, 0x20
blr
.GLE ENDADDRESS

.GLE ADDRESS tryStartSaveDemo__23MarioFaceShipEventStateFv +0x20
addi r3, r1, 0x08
.GLE ENDADDRESS

.GLE ADDRESS hasEventQueued__23MarioFaceShipEventStateFv +0x20
addi r3, r1, 0x08
.GLE ENDADDRESS

.GLE ADDRESS registerStarReturnEvents__23MarioFaceShipEventStateFPv
.GLE PRINTMESSAGE RegisterStarReturnEvents
.GLE PRINTADDRESS
stwu      r1, -0x70(r1)
mflr      r0
stw       r0, 0x74(r1)
addi      r11, r1, 0x70
bl        _savegpr_18
mr        r31, r3
bl initEventArray__23MarioFaceShipEventStateFv
bl MR_GetHubworldEventDataTable
mr r30, r3

#We need to find and register all events that got activated
#by grabbing this star. We need to iterate through all
#events to see if they have been activated yet or not
#and if they meet the requirements to be queued.
#Up to 8 events can be queued at once
li r27, 0   #i
b .RegisterStarReturnEvents_Loop_Start

.RegisterStarReturnEvents_Loop:
#Lets first get the EventNo
addi r3, r1, 0x08
mr r4, r30
lis r5, EventNo@ha
addi r5, r5, EventNo@l
mr r6, r27
bl getCsvDataS32__2MRFPlPC8JMapInfoPCcl
lwz r26, 0x08(r1)

#Lets first check to see if the event has already been
#activated before
mr r3, r26
bl getGameEventFlagFaceShipEvent__2MRFi
cmpwi r3, 1
beq .RegisterStarReturnEvents_Loop_Continue #Event has already been activated

#The event has not been activated yet
#Lets see if it meets the requirements

#First we check to see if this eventno has already been
#registered
li r18, 0 #x
lwz r19, 0x20(r31)
b .NoDupeLoopStart

.NoDupeLoop:
slwi      r0, r18, 2 #Shift to get the pointer
add       r3, r31, r0
lwz       r6, 0(r3)

addi r3, r1, 0x08
mr r4, r30
lis r5, EventNo@ha
addi r5, r5, EventNo@l
bl getCsvDataS32__2MRFPlPC8JMapInfoPCcl
lwz r3, 0x08(r1)

cmpw r26, r3
beq .RegisterStarReturnEvents_Loop_Continue #BCSV Entry has already had it's event added!

addi r18, r18, 1
.NoDupeLoopStart:
cmpw r18, r19
blt .NoDupeLoop


addi r3, r1, 0x08
mr r4, r30
lis r5, StageName@ha
addi r5, r5, StageName@l
mr r6, r27
bl getCsvDataStr__2MRFPPCcPC8JMapInfoPCcl

#Lets check if the name is empty
lwz r3, 0x08(r1)
lis r4, NULLSTRING@ha
addi r4, r4, NULLSTRING@l
bl isEqualString__2MRFPCcPCc
cmpwi r3, 1
beq .RegisterStarReturnEvents_CheckScenario #No Galaxy Name defined. Skip!

#Lets match the stage names
bl getClearedStageName__20GameSequenceFunctionFv
lwz r4, 0x08(r1)
bl isEqualString__2MRFPCcPCc
cmpwi r3, 1
bne .RegisterStarReturnEvents_Loop_Continue #Galaxy names do not match. Event will
#not be activated

.RegisterStarReturnEvents_CheckScenario:
addi r3, r1, 0x08
mr r4, r30
lis r5, ScenarioNo@ha
addi r5, r5, ScenarioNo@l
mr r6, r27
bl getCsvDataS32__2MRFPlPC8JMapInfoPCcl
lwz r3, 0x08(r1)
cmpwi r3, -1
beq .RegisterStarReturnEvents_CheckPowerStarNum #ScenarioNo doesn't matter. Skip!

bl getClearedPowerStarId__20GameSequenceFunctionFv
lwz r4, 0x08(r1)
cmpw r3, r4
bne .RegisterStarReturnEvents_Loop_Continue #Scenario's do not match. Event will not be activated

.RegisterStarReturnEvents_CheckPowerStarNum:

mr r3, r30
mr r4, r27
bl isJMapEntryProgressComplete
cmpwi r3, 0
beq .RegisterStarReturnEvents_Loop_Continue

#Lets check to see if the demo exists or not
#If not we need to flag it as watched to avoid issues
addi r3, r1, 0x08
mr r4, r30
lis r5, DemoName@ha
addi r5, r5, DemoName@l
mr r6, r27
bl getCsvDataStrOrNULL__2MRFPPCcPC8JMapInfoPCcl

lwz r3, 0x08(r1)
cmpwi r3, 0
beq .RegisterStarReturnEvents_Loop_Continue #Empty string bruh

bl findDemoExecutor__12DemoFunctionFPCc
cmpwi r3, 0
bne .DoRegisterEvent

#flag the event as watched
mr r3, r26
li r4, 1
bl .setGameEventFlagFaceShipEvent
b .RegisterStarReturnEvents_Loop_Continue

.DoRegisterEvent:
mr r3, r31
mr r4, r27
bl .RegisterEvent
#Event triggered! Lets continue and see if we have any more events to add...
#hopefully there won't be more than 8...

.RegisterStarReturnEvents_Loop_Continue:
addi r27, r27, 1

.RegisterStarReturnEvents_Loop_Start:
mr r3, r30
bl getCsvDataElementNum__2MRFPC8JMapInfo
cmpw r27, r3
blt .RegisterStarReturnEvents_Loop

addi      r11, r1, 0x70
bl        _restgpr_18
lwz       r0, 0x74(r1)
mtlr      r0
addi      r1, r1, 0x70
blr
.GLE ENDADDRESS


.GLE ADDRESS startStarReturnEvents__23MarioFaceShipEventStateFv
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
stw       r30, 0x08(r1)
mr        r30, r3

addi      r3, r30, 0x14
bl registerStarReturnEvents__23MarioFaceShipEventStateFPv
lwz       r0, 0x34(r30) #Load the event count
li        r3, -1
stw       r3, 0x38(r30) #Set the event counter

cmpwi     r0, 0
ble       .loc_804B5228
mr        r3, r30
bl startNextEvent__23MarioFaceShipEventStateFv
b         .loc_804B5230

.loc_804B5228:
mr        r3, r30
bl       sub_804B5530


.loc_804B5230:
lwz       r0, 0x14(r1)
lwz       r31, 0x0C(r1)
lwz       r30, 0x08(r1)
mtlr      r0
addi      r1, r1, 0x10
blr
.GLE ENDADDRESS

.GLE ADDRESS startNextEvent__23MarioFaceShipEventStateFv
stwu      r1, -0x40(r1)
mflr      r0
stw       r0, 0x44(r1)
addi      r11, r1, 0x40
bl        _savegpr_28
li        r31, 0
li        r30, 0
mr        r29, r3

lwz       r28, 0x38(r3) #Count
cmpwi r28, -1
beq .NextEvent
#Here we save the fact that the event has been run

slwi      r0, r28, 2
add       r4, r29, r0
lwz       r30, 0x14(r4)

bl MR_GetHubworldEventDataTable
mr r4, r3
addi r3, r1, 0x08
lis r5, EventNo@ha
addi r5, r5, EventNo@l
mr r6, r30
bl getCsvDataS32__2MRFPlPC8JMapInfoPCcl

lwz r3, 0x08(r1)
li r4, 1
bl sub_804D4100


.NextEvent:
addi      r4, r28, 1
stw       r4, 0x38(r29)
lwz       r0, 0x34(r29) #Max
cmpw      r4, r0
bge       .loc_804B52F0

lwz       r3, 0x10(r29)
lwz       r4, EventStartWaitLoc - STATIC_R13(r13)
bl        tryStartDemo__2MRFP9LiveActorPCc
mr        r3, r29
addi      r4, r13, sInstance__Q226NrvMarioFaceShipEventState18HostTypeNrvDoEvent - STATIC_R13
bl        setNerve__13NerveExecutorFPC5Nerve

.loc_804B52CC:
li        r31, 1
b         .loc_804B5304

.loc_804B52F0:
lwz       r3, 0x10(r29)
lwz       r4, SaveDemoLoc - STATIC_R13(r13)
bl tryStartDemo__2MRFP9LiveActorPCc

mr        r3, r29
bl        sub_804B5530 #Runs after all events have been played

.loc_804B5304:
li        r3, 3
bl overlayWithPreviousScreen__2MRFUl
bl resetCameraMan__2MRFv

#Normally there'd be a volume thing here but it's not needed
mr        r3, r31
addi      r11, r1, 0x40
bl        _restgpr_28
lwz       r0, 0x44(r1)
mtlr      r0
addi      r1, r1, 0x40
blr
.GLE ENDADDRESS

.GLE ADDRESS sub_804B5530
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
stw       r30, 0x08(r1)
mr        r30, r3

bl        setPlayerStateWait__2MRFv

bl        isSystemWipeActive__2MRFv
cmpwi     r3, 0
bne       .loc_804B55EC
bl        isWipeOpen__2MRFv
cmpwi     r3, 0
beq       .loc_804B55FC
bl        isSystemWipeOpen__2MRFv
cmpwi     r3, 0
beq       .loc_804B55FC

.loc_804B55EC:
mr        r3, r30
addi      r4, r13, sInstance__Q226NrvMarioFaceShipEventState26HostTypeNrvWaitForOpenWipe - STATIC_R13
bl        setNerve__13NerveExecutorFPC5Nerve
b         .loc_804B5608


.loc_804B55FC:
mr        r3, r30
addi      r4, r13, sInstance__Q226NrvMarioFaceShipEventState27HostTypeNrvSaveAndEndEvents - STATIC_R13
bl        setNerve__13NerveExecutorFPC5Nerve

.loc_804B5608:
lwz       r0, 0x14(r1)
lwz       r31, 0x0C(r1)
lwz       r30, 0x08(r1)
mtlr      r0
addi      r1, r1, 0x10
blr
.GLE ENDADDRESS

.GLE ADDRESS exeDoEvent__23MarioFaceShipEventStateFv +0x18
b .RetargetLocationA
.GLE ENDADDRESS
.GLE ADDRESS exeDoEvent__23MarioFaceShipEventStateFv +0x88
.RetargetLocationA:
.GLE ENDADDRESS

.GLE ADDRESS sub_804B5860
blr
.GLE ENDADDRESS


.GLE ADDRESS startEvents__23MarioFaceShipEventStateFPCc
stwu      r1, -0x30(r1)
mflr      r0
stw       r0, 0x34(r1)
addi      r11, r1, 0x30
bl        _savegpr_29
mr        r29, r3
lwz       r3, 0x10(r3)
bl endDemo__2MRFP7NameObjPCc

lwz       r0, 0x38(r29)
slwi      r0, r0, 2
add       r4, r29, r0
lwz       r31, 0x14(r4)

bl MR_GetHubworldEventDataTable
mr r4, r3
addi r3, r1, 0x08
lis r5, DemoName@ha
addi r5, r5, DemoName@l
mr r6, r31
bl getCsvDataStr__2MRFPPCcPC8JMapInfoPCcl

#Start Music
li r3, 1
bl startMarioFaceShipBGM__2MRFv

lwz       r3, 0x10(r29)
lwz r4, 0x08(r1)
li        r5, 0
bl        tryStartTimeKeepDemoMarioPuppetable__2MRFP7NameObjPCcPCc
mr        r3, r29
addi      r4, r13, sInstance__Q226NrvMarioFaceShipEventState27HostTypeNrvWaitDemoComplete - STATIC_R13
bl        setNerve__13NerveExecutorFPC5Nerve

addi      r11, r1, 0x30
bl        _restgpr_29
lwz       r0, 0x34(r1)
mtlr      r0
addi      r1, r1, 0x30
blr
.GLE ENDADDRESS

.GLE ADDRESS exeWaitDemoComplete__23MarioFaceShipEventStateFv +0x28
li r3, 0
.GLE ENDADDRESS

.GLE ADDRESS exeWaitDemoComplete__23MarioFaceShipEventStateFv +0x70
b .CheckWipe
.DoDefaultEndWipe:
bl       closeWipeFade__2MRFl
.SkipEndWipe:
.GLE ENDADDRESS

.GLE ADDRESS exeWaitConversationComplete__23MarioFaceShipEventStateFv
#Overwrite MarioFaceShipEventState::exeWaitConversationComplete((void))
.CheckWipe:
bl isWipeActive__2MRFv
cmpwi r3, 1
beq .ResultNo
bl isWipeOpen__2MRFv
cmpwi r3, 1
bne .ResultNo

.ResultYes:
li r3, 30
b .DoDefaultEndWipe
.ResultNo:
b .SkipEndWipe #Skip wipe 'cause demo already did one
.GLE ENDADDRESS

.GLE ADDRESS sub_804D4100
.setGameEventFlagFaceShipEvent:
stwu      r1, -0x20(r1)
mflr      r0
stw       r0, 0x24(r1)
addi      r11, r1, 0x20
bl        _savegpr_29
mr        r30, r3
mr        r29, r4

bl        getGameEventValueChecker__16GameDataFunctionFv
mr        r5, r30
lis       r31, FaceShipEventNo@ha
addi      r4, r31, FaceShipEventNo@l
clrlwi    r6, r29, 16
bl        setDemoValue__21GameEventValueCheckerFPCciUl

addi      r11, r1, 0x20
bl        _restgpr_29
lwz       r0, 0x24(r1)
mtlr      r0
addi      r1, r1, 0x20
blr
.GLE ENDADDRESS

.GLE ADDRESS sub_804D4210
blr
.GLE ENDADDRESS


.GLE ADDRESS exeStart__29MarioFaceShipInGameActorStateFv +0x34
li r31, 0
.GLE ENDADDRESS


.GLE ADDRESS startMarioFaceShipBGM__2MRFv
stwu      r1, -0x20(r1)
mflr      r0
stw       r0, 0x24(r1)
addi      r11, r1, 0x20
bl        _savegpr_29

#Re-writing this so the hubworld music acts more like normal stages
bl isPlayingStageBgm__2MRFv
cmpwi r3, 0
bne .StartHubworldMusic_Return

bl hasStageResultSequence__20GameSequenceFunctionFv
cmpwi r3, 0
bne .StartHubworldMusic_Return

bl sub_804D6D70
cmpwi r3, 0
bne .StartHubworldMusic_Return

bl        getCurrentScenarioNo__2MRFv
mr        r31, r3
bl        getCurrentStageName__2MRFv
mr        r4, r3
mr        r5, r31
lis r3, Game@ha
addi      r3, r3, Game@l
li        r6, 0
li        r7, 0
bl        startStageBGMFromStageName__2MRFPCcPCcl

.StartHubworldMusic_Return:
addi      r11, r1, 0x20
bl        _restgpr_29
lwz       r0, 0x24(r1)
mtlr      r0
addi      r1, r1, 0x20
blr

#May as well use this space...
#From GameScene.s
.GameScene_Extra:
bl isStageFileSelect__2MRFv
cmpwi r3, 0
bne .ForceClose

li        r3, 0x5A
bl .MR_OpenCurrentWipe
b .GameScene_Extra_Return

.ForceClose:
bl        forceOpenSystemWipeFade__2MRFv
b .GameScene_Extra_Return
#//////////////
.GameScene_Extra2:
bl .MR_IsGameStateHubworld
cmpwi r3, 0
bne .NoBgm
b .GameScene_Extra2_Return

.NoBgm:
b loc_8045186C
#//////////////
.GameScene_Extra3:
bl .MR_IsGameStateHubworld
cmpwi r3, 0
bne .NoBgm2
bl .EndScenarioSelectBgm
bl getCurrentScenarioNo__2MRFv
b .GameScene_Extra3_Return

.NoBgm2:
b loc_80452684





#Needed to put this here 'cause I couldn't fit inside SceneUtility.s
.GLE ADDRESS sub_804D5DF0 +0x14
b .ResetForGameOver
nop
.GameOverReturn:
.GLE ENDADDRESS

.ResetForGameOver:

bl forceCloseSystemWipeFade__2MRFv
bl resetPlayResultInStageHolder__2MRFv

lis r3, PlayerLeft_Setting@ha
addi r3, r3, PlayerLeft_Setting@l
li r4, 0
bl .MR_GetGameSetting
bl addPlayerLeft__16GameDataFunctionFi
b .GameOverReturn
.GLE ASSERT startGrandStarReturnBGM__2MRFv
.GLE ENDADDRESS



.GLE ADDRESS HubworldState_Strings
#String table
ReturnDemoOverride_FieldName:
    .string "ReturnDemoOverride"
    
POWERSTAR:
    .string "POWERSTAR"

GRANDSTAR:
    .string "GRANDSTAR"
    
GRANDSTARPLUS:
    .string "GRANDSTARPLUS"
    
StageName:
    .string "StageName"

DemoName:
    .string "DemoName"

EventNo:
    .string "EventNo" AUTO

.GLE ENDADDRESS

.GLE ADDRESS sub_804D8690 +0x190
#Prevents the Luigi ghosts from spawning in.
#Might remove this once making custom luigi ghosts in SMG2 becomes a thing that everyone can access
li r3, 0
.GLE ENDADDRESS

.GLE ADDRESS execute__Q232NrvMarioFaceShipInGameActorState15HostTypeNrvWaitCFP5Spine +0x20
#There's conviniently a li r3, 0 right above this.
#bl startCurrentStageBGM__2MRFi
.GLE ENDADDRESS