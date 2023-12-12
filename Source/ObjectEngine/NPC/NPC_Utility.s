#This file holds General purpose NPC functions

#=========== Flow Checkers ===========
#Got some nice stuff here, mostly more options for MSBF

.GLE ADDRESS CareTaker_BranchFuncComet
GlobalBranchFunc_Ptr:
.int 0
.int -1
.int .MR_GlobalBranchFunc
.GLE ENDADDRESS

.GLE ADDRESS CareTaker_EventFuncComet
GlobalEventFunc_Ptr:
.int 0
.int -1
.int .MR_GlobalEventFunc
.GLE ENDADDRESS

.GLE ADDRESS CareTaker_BranchFuncStar
GlobalAnimeFunc_Ptr:
.int 0
.int -1
.int .MR_GlobalAnimeFunc

.set GlobalBranchFunc_Loc, GlobalBranchFunc_Ptr
.set GlobalEventFunc_Loc, GlobalEventFunc_Ptr
.set GlobalAnimeFunc_Loc, GlobalAnimeFunc_Ptr
.set GlobalKillFunc_Loc, GlobalKillFunc_Ptr
.GLE ENDADDRESS

.GLE ADDRESS CareTaker_AnimeFunc
GlobalKillFunc_Ptr:
#Don't know if I'm gonna add this yet or not...
#.int 0
#.int -1
#.int .MR_GlobalKillFunc
.GLE ENDADDRESS



.GLE ADDRESS branchFuncGameProgress__2MRFi -0x0C
#MR::GlobalBranchFunc(NPCActor*, EventData)
#r3 = NPCActor* Caller
#r4 = Event Data Value
#  0xF000 = Event Type
#  0x0FFF = Parameter Value
.MR_GlobalBranchFunc:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
stw       r30, 0x08(r1)

srawi r31, r4, 0x0C #Get the event type
rlwinm r30, r4, 0, 20, 31 #Get the parameter value

#== Branch Types ==
#0x0 = No Branch (Defaults to the LiveActor Specific code, if any!)
#0x1 = Compare Coins
#0x2 = Compare Purple Coins
#0x3 = Compare Starbits
#0x4 = Compare Health
#0x5 = Compare Stars
#0x6 = Compare Powerup (use this if normal flows don't provide access to a given powerup)
#0x7 = JMapProgress Index. For memory purposes, uses the same BCSV as ScenarioSwitch
#0x8 = 
#0x9 = 
#0xA = 
#0xB = 
#0xC = 
#0xD = 
#0xE = 
#0xF = Hooked code

cmpwi r31, 0x01
blt .BranchFunc_Case_0
beq .BranchFunc_Case_1
cmpwi r31, 0x03
blt .BranchFunc_Case_2
beq .BranchFunc_Case_3
cmpwi r31, 0x05
blt .BranchFunc_Case_4
beq .BranchFunc_Case_5
cmpwi r31, 0x07
blt .BranchFunc_Case_6
beq .BranchFunc_Case_7
cmpwi r31, 0x09
blt .BranchFunc_Case_8
beq .BranchFunc_Case_9
cmpwi r31, 0x0B
blt .BranchFunc_Case_A
beq .BranchFunc_Case_B
cmpwi r31, 0x0D
blt .BranchFunc_Case_C
beq .BranchFunc_Case_D
cmpwi r31, 0x0F
blt .BranchFunc_Case_E
beq .BranchFunc_Case_F  #very optimal clamping here

.BranchFunc_Case_0:
b .BranchFunc_Failure

.BranchFunc_Case_1:
bl getCoinNum__2MRFv
b .BranchFunc_EqualityCompare

.BranchFunc_Case_2:
bl getPurpleCoinNum__2MRFv
b .BranchFunc_EqualityCompare

.BranchFunc_Case_3:
bl getStarPieceNum__2MRFv
b .BranchFunc_EqualityCompare

.BranchFunc_Case_4:
bl getPlayerLife__2MRFv
b .BranchFunc_EqualityCompare

.BranchFunc_Case_5:
bl getPowerStarNum__2MRFv
b .BranchFunc_EqualityCompare

.BranchFunc_Case_6:
mr r3, r30
bl .MR_isPlayerElementMode
b .BranchFunc_Return


.BranchFunc_Case_7:
lis r3, ScenarioSwitch_BcsvName@ha
addi r3, r3, ScenarioSwitch_BcsvName@l
crclr     4*cr1+eq
bl tryLoadCsvFromZoneInfo__2MRFPCc
cmpwi r3, 0
beq .BranchFunc_Failure #Can't find the file
#We're actually not going to check for OoB here
mr r4, r30
bl isJMapEntryProgressComplete
b .BranchFunc_Return


.BranchFunc_Case_8:

.BranchFunc_Case_9:

.BranchFunc_Case_A:

.BranchFunc_Case_B:

.BranchFunc_Case_C:

.BranchFunc_Case_D:

.BranchFunc_Case_E:
b .BranchFunc_Success

#This one is reserved for hooks
.BranchFunc_Case_F:
mr r3, r30
b .BranchFunc_Success #replace this line with a function call to custom code.
b .BranchFunc_Return

.BranchFunc_EqualityCompare:
#requires that r3 has the value to compare
cmpw r3, r30
blt .BranchFunc_Failure

.BranchFunc_Success:
li r3, 1
b .BranchFunc_Return

.BranchFunc_Failure:
li r3, 0
#Fallthrough

.BranchFunc_Return:
lwz       r31, 0x0C(r1)
lwz       r30, 0x08(r1)
lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr

.GLE ASSERT branchFuncGameProgress__2MRFi +0x11C
.GLE ENDADDRESS

#-----------------------------------------------------------------------------------------------------------------------

#This is used by the event func and decides how far we can search for the TakeOutStar*
.set TAKEOUTSTAR_SEARCHLIMIT, 0x100
.set TAKEOUTSTAR_SEARCHOFFSET, 0x160

.GLE ADDRESS branchFuncStar__9CaretakerFUl -0x04
#MR::GlobalEventFunc(NPCActor*, EventData)
#r3 = NPCActor* Caller
#r4 = Event Data Value
#  0xF000 = Event Type
#  0x0FFF = Parameter Value

.MR_GlobalEventFunc:
stwu      r1, -0x50(r1)
mflr      r0
stw       r0, 0x54(r1)
addi r11, r1, 0x50
bl _savegpr_26

srawi r31, r4, 0x0C #Get the event type
rlwinm r30, r4, 0, 20, 31 #Get the parameter value
mr r29, r3

#== Event Types ==
#0x00 = No Event. (Defaults to the LiveActor Specific code, if any!)
#0x01 = TakeOutStar (May not support all NPCs, will fail if the TakeOutStar is more than 0x260 from an object's instance (lowest possible is 0x160))
#0x02 = Set Message Parameter
#       0x00 = Stars
#       0x01 = Starbits
#       0x02 = Coins
#       0x03 = Purple Coins
#       0x04 = Current Score
#       Example: 0x2002 will display coins
#0x03 = ForceKillPlayerByGroundRace
#0x04 = Restart current stage
#0x05 = Change Stage. Parameter value is an index into ChangeSceneListInfo (Main Galaxy only)
#0x06 = Add Coins
#0x07 = Add Starbits
#0x08 = Remove Coins
#0x09 = Remove Starbits
#0x0A = NPC Information Nerve
#       (use an NPC switch before calling this, so that a InfoDisplayObj can spawn. Make sure you turn the switch off before turning it back on again or else the info box won't trigger!)
#       0x00 = Start the nerve
#       0x01 = Wait for the nerve to complete
#0x0B = 
#0x0C = 
#0x0D = 
#0x0E = 
#0x0F = Hook

cmpwi r31, 0x01
blt .EventFunc_Case_0
beq .EventFunc_Case_1
cmpwi r31, 0x03
blt .EventFunc_Case_2
beq .EventFunc_Case_3
cmpwi r31, 0x05
blt .EventFunc_Case_4
beq .EventFunc_Case_5
cmpwi r31, 0x07
blt .EventFunc_Case_6
beq .EventFunc_Case_7
cmpwi r31, 0x09
blt .EventFunc_Case_8
beq .EventFunc_Case_9
cmpwi r31, 0x0B
blt .EventFunc_Case_A
beq .EventFunc_Case_B
cmpwi r31, 0x0D
blt .EventFunc_Case_C
beq .EventFunc_Case_D
cmpwi r31, 0x0F
blt .EventFunc_Case_E
beq .EventFunc_Case_F  #very optimal clamping here

.EventFunc_Case_0:
b .EventFunc_ReturnEventComplete

.EventFunc_Case_1:
#Very elaborate "TakeOutStar" search function
addi r28, r29, TAKEOUTSTAR_SEARCHOFFSET #Offset to near the earliest a TakeOutStar* could be.
#The goal here is to find what next 4 bytes leads specifically to the VTAble* of the TakeOutStar

#r28 should NEVER be 0x00000000 at this point

.EventFunc_SearchLoop:
lwz r3, 0x00(r28)
cmpwi r3, 0
beq .EventFunc_Continue  #Make sure it's not 0
rlwinm r4,r3,0,0,0 #(0x80000000)
cmpwi r4, 0
beq .EventFunc_Continue  #Value doesn't corrospond to anything in readable memory if 0
lwz r5, 0x00(r3)
lis r4, __vt__11TakeOutStar@ha
addi r4, r4, __vt__11TakeOutStar@l
cmpw r5, r4
beq .EventFunc_Break  #TakeOutStar found!

.EventFunc_Continue:
addi r28, r28, 4

sub r4, r28, r29
li r3, TAKEOUTSTAR_SEARCHLIMIT
addi r3, r3, TAKEOUTSTAR_SEARCHOFFSET
cmpw r4, r3
blt .EventFunc_SearchLoop
b .EventFunc_ReturnEventComplete #return if we can't find a TakeOutStar instead of crashing the game

.EventFunc_Break:
bl takeOut__11TakeOutStarFv
b .EventFunc_Return #return so that the game doesn't get stucc


.EventFunc_Case_2:
#Set message number tag
cmpwi r30, 0
bgt .EventFunc_SetStarbits
bl getPowerStarNum__2MRFv
b .EventFunc_SetMsgArg

.EventFunc_SetStarbits:
cmpwi r30, 1
bgt .EventFunc_SetCoins
bl getStarPieceNum__2MRFv
b .EventFunc_SetMsgArg

.EventFunc_SetCoins:
cmpwi r30, 2
bgt .EventFunc_SetPurpleCoins
bl getCoinNum__2MRFv
b .EventFunc_SetMsgArg

.EventFunc_SetPurpleCoins:
cmpwi r30, 3
bgt .EventFunc_SetScore
bl getPurpleCoinNum__2MRFv
b .EventFunc_SetMsgArg

.EventFunc_SetScore:
cmpwi r30, 4
bgt .EventFunc_Set_Unused
bl getCurrentScore__2MRFv
b .EventFunc_SetMsgArg

.EventFunc_Set_Unused:
b .EventFunc_ReturnEventComplete


.EventFunc_SetMsgArg:
mr r4, r3
lwz r3, 0x94(r29)
bl setMessageArg__2MRFP15TalkMessageCtrli
b .EventFunc_ReturnEventComplete

.EventFunc_Case_3:
bl forceKillPlayerByGroundRace__2MRFv
b .EventFunc_ReturnEventComplete

.EventFunc_Case_4:
bl requestStageRestart__2MRFv
mr r3, r30 #Both 0 and 1 have been used in-game...so we let the variable decide!
b .EventFunc_Return

.EventFunc_Case_5:
bl isSystemWipeActive__2MRFv
cmpwi r3, 1
beq .EventFunc_ReturnEventInProgress

bl isSystemWipeBlank__2MRFv
cmpwi r3, 1
beq .EventFunc_DoWarp

bl .MR_SystemCircleWipeToCenter
li r3, 60
bl closeSystemWipeCircle__2MRFl
b .EventFunc_ReturnEventInProgress

.EventFunc_DoWarp:
li r3, 0
bl .StageDataHolder_GetSceneChangeList
mr r4, r30
bl .MR_RequestMoveStageFromJMapInfo
b .EventFunc_ReturnEventInProgress

.EventFunc_Case_6:
mr r3, r30
mr r4, r29
bl incCoin__2MRFiP9LiveActor
b .EventFunc_ReturnEventComplete

.EventFunc_Case_7:
mr r3, r30
bl addStarPiece__2MRFi

#Sound effect!
mr r3, r29
lis r4, AddMailStarPiece@ha
addi r4, r4, AddMailStarPiece@l
li r5, -1
li r6, -1
li r7, -1
bl startActionSound__2MRFPC9LiveActorPCclll

b .EventFunc_ReturnEventComplete

.EventFunc_Case_8:
mr r3, r30
bl decCoin__2MRFi
b .EventFunc_ReturnEventComplete

.EventFunc_Case_9:
neg r3, r30
bl addStarPiece__2MRFi
b .EventFunc_ReturnEventComplete

.EventFunc_Case_A:
cmpwi r30, 0
beq .EventFunc_Case_A_Push

mr        r3, r29
addi      r4, r13, sInstance__Q215NrvLuigiTalkNpc26LuigiTalkNpcNrvInformation - STATIC_R13
bl        isNerve__9LiveActorCFPC5Nerve
cntlzw    r0, r3
srwi      r3, r0, 5
b .EventFunc_Return

.EventFunc_Case_A_Push:
mr        r3, r29
addi      r4, r13, sInstance__Q215NrvLuigiTalkNpc26LuigiTalkNpcNrvInformation - STATIC_R13
bl        isNerve__9LiveActorCFPC5Nerve
cmpwi r3, 0
bne .EventFunc_ReturnEventComplete   #Do not push nerve a second time

mr        r3, r29
addi      r4, r13, sInstance__Q215NrvLuigiTalkNpc26LuigiTalkNpcNrvInformation - STATIC_R13
bl        pushNerve__8NPCActorFPC5Nerve
b .EventFunc_ReturnEventComplete

.EventFunc_Case_B:

.EventFunc_Case_C:

.EventFunc_Case_D:

.EventFunc_Case_E:

.EventFunc_Case_F:
mr r3, r30
mr r4, r29
b .EventFunc_ReturnEventComplete #replace this line for hook
b .EventFunc_Return

.EventFunc_ReturnEventComplete:
li r3, 1 
b .EventFunc_Return

.EventFunc_ReturnEventInProgress:
li r3, 0
#Fallthrough

.EventFunc_Return:
addi r11, r1, 0x50
bl _restgpr_26
lwz       r0, 0x54(r1)
mtlr      r0
addi      r1, r1, 0x50
blr
.GLE PRINTADDRESS
.GLE ASSERT setAnim__9CaretakerFl
.GLE ENDADDRESS

#----------------------------------------------------------------------------------
#this nerve is not required to be specific to Luigi.
#so I re-write it here a bit.
.GLE ADDRESS exeInformation__12LuigiTalkNpcFv
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
mr        r31, r3
li r4, 0x10
bl        isGreaterStep__2MRFPC9LiveActorl
cmpwi     r3, 0
beq       loc_803516E4

bl        isDeadInformationMessage__2MRFv
cmpwi     r3, 0
beq       loc_803516E4
mr        r3, r31
bl        popNerve__8NPCActorFv

loc_803516E4:
lwz       r0, 0x14(r1)
lwz       r31, 0x0C(r1)
mtlr      r0
addi      r1, r1, 0x10
blr
.GLE ENDADDRESS
#----------------------------------------------------------------------------------

.GLE ADDRESS __sinit_\MarioFacePlanet_cpp
blr  #required BLR


#r3 NPCActor*
#r4 = BCSV Index
.MR_GlobalAnimeFunc:
stwu      r1, -0x20(r1)
mflr      r0
stw       r0, 0x24(r1)
addi r11, r1, 0x20
bl _savegpr_29

mr r31, r3
mr r30, r4

lis r3, NPC_AnimTable_BCSVNamePtr@ha
addi r3, r3, NPC_AnimTable_BCSVNamePtr@l
crclr     4*cr1+eq
bl tryLoadCsvFromZoneInfo__2MRFPCc
cmpwi r3, 0
beq .AnimeFunc_Return #Can't find the file

#Had to remove the safety because I ran out of room :(
#bl getCsvDataElementNum__2MRFPC8JMapInfo
#
#cmpw r30, r3
#bge .AnimeFunc_Return #Index ouf of Range

mr r4, r3 #janky hack m8
addi r3, r1, 0x08
lis r5, AnimName@ha
addi r5, r5, AnimName@l
mr r6, r30
bl getCsvDataStrOrNULL__2MRFPPCcPC8JMapInfoPCcl

lwz r4, 0x08(r1)
#cmpwi r4, 0
#beq .AnimeFunc_Return

mr r3, r31
bl startAction__2MRFPC9LiveActorPCc

.AnimeFunc_Return:
addi r11, r1, 0x20
bl _restgpr_29
lwz       r0, 0x24(r1)
mtlr      r0
addi      r1, r1, 0x20
blr


#======================================== NPC GLOBAL FUNCTORS ========================================

#r3 = NPCActor*
#r4 = Type. 0 = Branch, 1 = Event, 2 = Anime, 3 = Kill
#r5 = Functor Address
.MR_RegisterNPCFunc:
stwu      r1, -0x170(r1)
mflr      r0
stw       r0, 0x174(r1)
addi      r11, r1, 0x170
bl        _savegpr_28

mr r31, r3
mr r30, r4

lwz       r3, 0x00(r5) #typically 0
lwz       r4, 0x04(r5) #typically FFFFFFFF
lwz       r0, 0x08(r5) #Func Address
stw       r3, 0x20(r1)
stw       r4, 0x24(r1)
stw       r0, 0x28(r1)

addi      r3, r1, 0x44
mr        r4, r31
addi      r5, r1, 0x20
#We're just gonna always use the caretaker func. They're all the same from what I can tell.
bl        TalkMessageFunc<9Caretaker>__FP9CaretakerM9CaretakerFPCvPvUl_b_51TalkMessageFuncM<P9Caretaker,M9CaretakerFPCvPvUl_b>

lwz       r3, 0x94(r31)
addi      r4, r1, 0x44

cmpwi r30, 0
beq .regBranch
cmpwi r30, 2
blt .regEvent
beq .regAnime
b .regKill

.regBranch:
bl        registerBranchFunc__2MRFP15TalkMessageCtrlRC19TalkMessageFuncBase
b .regEnd

.regEvent:
bl        registerEventFunc__2MRFP15TalkMessageCtrlRC19TalkMessageFuncBase
b .regEnd

.regAnime:
bl        registerAnimeFunc__2MRFP15TalkMessageCtrlRC19TalkMessageFuncBase
b .regEnd

.regKill:
bl        registerKillFunc__2MRFP15TalkMessageCtrlRC19TalkMessageFuncBase

.regEnd:
addi      r11, r1, 0x170
bl        _restgpr_28
lwz       r0, 0x174(r1)
mtlr      r0
addi      r1, r1, 0x170
blr

#----------------------------------------------------------------------------------


.MR_RegisterGlobalBranchFunc:
#r3 = NPCActor*
lis r4, GlobalBranchFunc_Loc@ha
addi r4, r4, GlobalBranchFunc_Loc@l
#fallthrough

.MR_RegisterNPCBranchFunc:
#r3 = NPCActor*
#r4 = Functor Address
mr r5, r4
li r4, 0
b .MR_RegisterNPCFunc


.MR_RegisterGlobalEventFunc:
#r3 = NPCActor*
lis r4, GlobalEventFunc_Loc@ha
addi r4, r4, GlobalEventFunc_Loc@l
#fallthrough

.MR_RegisterNPCEventFunc:
#r3 = NPCActor*
#r4 = Functor Address
mr r5, r4
li r4, 1
b .MR_RegisterNPCFunc


.MR_RegisterGlobalAnimeFunc:
#r3 = NPCActor*
lis r4, GlobalAnimeFunc_Loc@ha
addi r4, r4, GlobalAnimeFunc_Loc@l
#fallthrough

.MR_RegisterNPCAnimeFunc:
#r3 = NPCActor*
#r4 = Functor Address
mr r5, r4
li r4, 2
b .MR_RegisterNPCFunc


.MR_RegisterGlobalKillFunc:
#r3 = NPCActor*
#lis r4, GlobalKillFunc_Loc@ha
#addi r4, r4, GlobalKillFunc_Loc@l
nop
nop
#fallthrough

.MR_RegisterNPCKillFunc:
#r3 = NPCActor*
#r4 = Functor Address
#mr r5, r4
#li r4, 3
#b .MR_RegisterNPCFunc
nop
nop
blr


#r3 = TalkMessageCtrl *
#r4 = TalkMessageFuncBase const &
.MR_RegisterEventAndGlobalAnimeFunc:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw r3, 0x08(r1)
bl registerEventFunc__2MRFP15TalkMessageCtrlRC19TalkMessageFuncBase
b .RegisterGlobalAnimeFunc_JumpLoc


#r3 = TalkMessageCtrl *
#r4 = TalkMessageFuncBase const &
.MR_RegisterBranchAndGlobalAnimeFunc:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw r3, 0x08(r1)
bl registerBranchFunc__2MRFP15TalkMessageCtrlRC19TalkMessageFuncBase

.RegisterGlobalAnimeFunc_JumpLoc:
lwz r3, 0x08(r1)
lwz r3, 0x14(r3) #get the owner of the TalkMessageCtrl
bl .MR_RegisterGlobalAnimeFunc

lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr
#Where does this chunk end again...?
.NPC_Utility_End:

.GLE PRINTADDRESS
.GLE ASSERT __sinit_\MarioFacePlanetPrevious_cpp
.GLE ENDADDRESS
#--------------------------------------------------------------------------------------

.GLE ADDRESS __ct__15MarioFacePlanetFPCc

#MR::RegisterAllGlobalFuncs((LiveActor *))
.MR_RegisterAllGlobalFuncs:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw r3, 0x08(r1)
bl .MR_RegisterGlobalBranchFunc
lwz r3, 0x08(r1)
bl .MR_RegisterGlobalEventFunc
lwz r3, 0x08(r1)
bl .MR_RegisterGlobalAnimeFunc

lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr


#MR::RegisterTalkToDemo((LiveActor *,JMapInfoIter const &))
.MR_RegisterTalkToDemo:
stwu      r1, -0x20(r1)
mflr      r0
stw       r0, 0x24(r1)
stw       r31, 0x1C(r1)
stw       r30, 0x18(r1)
mr        r31, r3
mr        r30, r4
bl tryRegisterDemoCast__2MRFP9LiveActorRC12JMapInfoIter
cmpwi r3, 0
beq .RegisterTalkToDemo_Return

mr r3, r30
addi      r4, r1, 0x08
bl        getJMapInfoMessageID__2MRFRC12JMapInfoIterPl
lwz       r3, 0x08(r1)


cmpwi r3, -2
beq .RegisterTalkToDemo_Return

mr        r3, r31
lwz       r4, 0x94(r31)
bl registerDemoTalkMessageCtrl__12DemoFunctionFP9LiveActorP15TalkMessageCtrl

.RegisterTalkToDemo_Return:
lwz       r0, 0x24(r1)
lwz       r31, 0x1C(r1)
lwz       r30, 0x18(r1)
mtlr      r0
addi      r1, r1, 0x20
blr


#===========================================================================================
#===========================================================================================
#======================================== NPC FIXES ========================================
#===========================================================================================
#===========================================================================================
#Verious fixes and additions to NPCs.


#====== Signboard ======
.GLE ADDRESS init__9SignBoardFRC12JMapInfoIter +0x174
b .Signboard_RegisterGlobals
.Signboard_RegisterGlobals_Return:
.GLE ENDADDRESS

.Signboard_RegisterGlobals:
mr        r3, r30
bl .MR_RegisterAllGlobalFuncs

lwz       r0, 0xD4(r1)
b .Signboard_RegisterGlobals_Return



#====== BombHeiRed ======
.GLE ADDRESS init__10BombHeiRedFRC12JMapInfoIter +0x164
b .BombHeiRed_RegisterGlobals
.BombHeiRed_RegisterGlobals_Return:
.GLE ENDADDRESS

.BombHeiRed_RegisterGlobals:
mr r3, r31
bl .MR_RegisterAllGlobalFuncs

addi      r11, r1, 0xE0
b .BombHeiRed_RegisterGlobals_Return



#====== Caretaker ======
#See Caretaker.s



#====== CaretakerHunter ======
#Not stored in Caretaker.s because yes
.GLE ADDRESS init__15CareTakerHunterFRC12JMapInfoIter +0x1D8
bl .MR_RegisterEventAndGlobalAnimeFunc
.GLE ENDADDRESS

#Keeping the original BranchFunc still accessable
.GLE ADDRESS branchFunc__15CaretakerHunterFUl
b .CaretakerHunter_BranchFunc
.CaretakerHunter_BranchFunc_Vanilla:
.GLE ENDADDRESS

.CaretakerHunter_BranchFunc:
srawi r5, r4, 0x0C #Get the event type

cmpwi r5, 0
beq .CaretakerHunter_BranchFunc_DoVanilla

b .MR_GlobalBranchFunc

.CaretakerHunter_BranchFunc_DoVanilla:
stwu      r1, -0x10(r1)
b .CaretakerHunter_BranchFunc_Vanilla

#Keeping the original EventFunc still accessable
.GLE ADDRESS eventFunc__15CaretakerHunterFUl
b .CaretakerHunter_EventFunc
.CaretakerHunter_EventFunc_Vanilla:
.GLE ENDADDRESS

.CaretakerHunter_EventFunc:
srawi r5, r4, 0x0C #Get the event type

cmpwi r5, 0
beq .CaretakerHunter_EventFunc_DoVanilla

b .MR_GlobalEventFunc

.CaretakerHunter_EventFunc_DoVanilla:
stwu      r1, -0x10(r1)
b .CaretakerHunter_EventFunc_Vanilla



#====== Dreamer ======
#N/A



#====== SuperDreamer ======
#N/A



#====== GliBirdNpc ======
#Can't talk to this NPC anyways. Poor Fluzzard



#====== HoneyBee ======
.GLE ADDRESS init__8HoneyBeeFRC12JMapInfoIter +0x1D8
#Can't reuse the Bob-omb Buddy 'cause different registers
b .HoneyBee_RegisterGlobals
.HoneyBee_RegisterGlobals_Return:
.GLE ENDADDRESS

.HoneyBee_RegisterGlobals:
mr        r3, r29
bl .MR_RegisterAllGlobalFuncs

addi      r11, r1, 0xE0
b .HoneyBee_RegisterGlobals_Return



#====== HoneyQueen ======
.GLE ADDRESS init__10HoneyQueenFRC12JMapInfoIter +0x1D8
#Can't reuse the Bob-omb Buddy 'cause different registers
b .HoneyQueen_RegisterGlobals
.HoneyQueen_RegisterGlobals_Return:
.GLE ENDADDRESS

.HoneyQueen_RegisterGlobals:
mr        r3, r31
bl .MR_RegisterAllGlobalFuncs

addi      r11, r1, 0xE0
b .HoneyQueen_RegisterGlobals_Return



#====== Kinopio ======
.GLE ADDRESS init__7KinopioFRC12JMapInfoIter +0x194
mr r3, r28
bl .MR_RegisterGlobalEventFunc
.GLE ENDADDRESS

.GLE ADDRESS init__7KinopioFRC12JMapInfoIter +0x1D4
bl .MR_RegisterBranchAndGlobalAnimeFunc
.GLE ENDADDRESS

.GLE ADDRESS init__7KinopioFRC12JMapInfoIter +0x394
bl .MR_RegisterTalkToDemo
.GLE ENDADDRESS



#====== KinopioBank ======
.GLE ADDRESS init__11KinopioBankFRC12JMapInfoIter +0x260
mr        r3, r29
mr        r4, r30
bl .MR_RegisterTalkToDemo
b .BankToadJumpPos
.GLE ENDADDRESS

.GLE ADDRESS init__11KinopioBankFRC12JMapInfoIter +0x2EC
.BankToadJumpPos:
.GLE ENDADDRESS

#Keep Vanilla Branchs
.GLE ADDRESS branchFunc__11KinopioBankFUl
b .KinopioBank_BranchFunc
.KinopioBank_BranchFunc_Vanilla:
.GLE ENDADDRESS

.KinopioBank_BranchFunc:
srawi r5, r4, 0x0C #Get the Branch type

cmpwi r5, 0
beq .KinopioBank_BranchFunc_DoVanilla

b .MR_GlobalBranchFunc

.KinopioBank_BranchFunc_DoVanilla:
stwu      r1, -0x10(r1)
b .KinopioBank_BranchFunc_Vanilla

#Keep Vanilla Events
.GLE ADDRESS eventFunc__11KinopioBankFUl
b .KinopioBank_EventFunc
.KinopioBank_EventFunc_Vanilla:
.GLE ENDADDRESS

.KinopioBank_EventFunc:
srawi r5, r4, 0x0C #Get the event type

cmpwi r5, 0
beq .KinopioBank_EventFunc_DoVanilla

b .MR_GlobalEventFunc

.KinopioBank_EventFunc_DoVanilla:
stwu      r1, -0x10(r1)
b .KinopioBank_EventFunc_Vanilla


#Time to fix the issue where vanilla Bank Toad's branches cannot be used

.KinopioBank_RecalcHighCheck:
subi r0, r4, 4  #once the first 4 options are out of the way, we're good.
cmpwi r0, 0
blt .__KinopioBank_Jump_Return_1
b .KinopioBank_RecalcHighCheck_ReturnA

#returns one
.__KinopioBank_Jump_Return_1:
b .KinopioBank_BranchFunc_Return_1_Loc

#return value must be in r3
.__KinopioBank_Jump_Return:
b .KinopioBank_BranchFunc_Return_Loc


.GLE ADDRESS branchFunc__11KinopioBankFUl +0x8C
b .KinopioBank_RecalcHighCheck
nop
.KinopioBank_RecalcHighCheck_ReturnA:
.GLE ENDADDRESS

.GLE ADDRESS branchFunc__11KinopioBankFUl +0x10C
.KinopioBank_BranchFunc_Return_1_Loc:
.GLE ENDADDRESS

.GLE ADDRESS branchFunc__11KinopioBankFUl +0x110
.KinopioBank_BranchFunc_Return_Loc:
.GLE ENDADDRESS



.KinopioBank_RecalcStarpiece:
subi r0, r4, 3  #Yes this is different from above because this is a zero indexed list
b .KinopioBank_RecalcStarpiece_Return

.GLE ADDRESS branchFunc__11KinopioBankFUl +0xA8
b .KinopioBank_RecalcStarpiece
.KinopioBank_RecalcStarpiece_Return:
.GLE ENDADDRESS

#====== KinopioPostman ======
#-- NPC Removed from the game --



#====== KoopaNpc ======
#???????????


#====== LuigiTalkNpc ======
#GLE-V3 adds back his ability to spawn stars!
.GLE ADDRESS init__12LuigiTalkNpcFRC12JMapInfoIter +0x110
bl .MR_RegisterEventAndGlobalAnimeFunc
#This leads right into the next GLE ADDRESS right under this
.GLE ENDADDRESS

.GLE ADDRESS init__12LuigiTalkNpcFRC12JMapInfoIter +0x11C
bl .MR_RegisterTalkToDemo
b .LuigiTalkNpcInitJumpLoc
.GLE ENDADDRESS

.GLE ADDRESS init__12LuigiTalkNpcFRC12JMapInfoIter +0x18C
.LuigiTalkNpcInitJumpLoc_Return:
li r3, 0
.GLE ENDADDRESS

.GLE ADDRESS init__12LuigiTalkNpcFRC12JMapInfoIter +0x32C
mr r3, r29
bl .MR_RegisterGlobalBranchFunc
.GLE ENDADDRESS

#Keep Vanilla Events
.GLE ADDRESS eventFunc__16LuigiIntrusivelyFUl
b .LuigiTalkNPC_EventFunc
.LuigiTalkNPC_EventFunc_Vanilla:
.GLE ENDADDRESS

.LuigiTalkNPC_EventFunc:
srawi r5, r4, 0x0C #Get the event type

cmpwi r5, 0
beq .LuigiTalkNPC_EventFunc_DoVanilla

b .MR_GlobalEventFunc

.LuigiTalkNPC_EventFunc_DoVanilla:
stwu      r1, -0x60(r1)
b .LuigiTalkNPC_EventFunc_Vanilla


#====== MameMuimuiAttackMan ======
.GLE ADDRESS init__19MameMuimuiAttackManFRC12JMapInfoIter +0x20C
mr r3, r30
bl .MR_RegisterGlobalAnimeFunc
.GLE ENDADDRESS



#====== Meister ======
#see Meister.s



#====== Moc ======
.GLE ADDRESS init__3MocFRC12JMapInfoIter +0xDC
mr r3, r29
bl .MR_RegisterGlobalBranchFunc
.GLE ENDADDRESS

.GLE ADDRESS init__3MocFRC12JMapInfoIter +0x118
mr r3, r29
bl .MR_RegisterGlobalEventFunc
.GLE ENDADDRESS

.GLE ADDRESS init__3MocFRC12JMapInfoIter +0x120
mr r3, r29
bl .MR_RegisterGlobalAnimeFunc
b .Moc_InitSkip
.GLE ENDADDRESS

.GLE ADDRESS init__3MocFRC12JMapInfoIter +0x1AC
.Moc_InitSkip:
.GLE ENDADDRESS



#====== Monte ======
#As funny as it is, T-posing during hubworld events *is a bug* and needs to somehow be fixed...
.GLE ADDRESS init__5MonteFRC12JMapInfoIter +0x1B8
#Can't reuse the Bob-omb Buddy 'cause different registers
b .Monte_RegisterGlobals
.Monte_RegisterGlobals_Return:
.GLE ENDADDRESS

.Monte_RegisterGlobals:
mr        r3, r29
bl .MR_RegisterAllGlobalFuncs

addi      r11, r1, 0xD0
b .Monte_RegisterGlobals_Return



#====== Peach ======
.GLE ADDRESS init__5PeachFRC12JMapInfoIter +0xCC
#Can't reuse the Bob-omb Buddy 'cause different registers
b .Peach_RegisterGlobals
.Peach_RegisterGlobals_Return:
.GLE ENDADDRESS

.Peach_RegisterGlobals:
mr        r3, r29
bl .MR_RegisterAllGlobalFuncs

mr r3, r29
mr r4, r30
bl .MR_RegisterTalkToDemo

addi      r11, r1, 0xC0
b .Peach_RegisterGlobals_Return

.GLE ADDRESS __vt__5Peach +0x10
.int .Peach_NewInitAfterPlacement
.GLE ENDADDRESS

#A fix for her umbrella
.Peach_NewInitAfterPlacement:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
mr r31, r3
bl initAfterPlacement__8NPCActorFv

lwz       r3, 0x98(r31)
cmpwi     r3, 0
beq .Peach_NewInitAfterPlacement_Return
bl hideModelIfShown__2MRFP9LiveActor

.Peach_NewInitAfterPlacement_Return:
lwz       r31, 0x0C(r1)
lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr



#====== Penguin ======
.GLE ADDRESS init__7PenguinFRC12JMapInfoIter +0x320
#Can't reuse the Bob-omb Buddy 'cause different registers
b .Penguin_RegisterGlobals
.Penguin_RegisterGlobals_Return:
.GLE ENDADDRESS

.Penguin_RegisterGlobals:
mr        r3, r30
bl .MR_RegisterAllGlobalFuncs

addi      r11, r1, 0xE0
b .Penguin_RegisterGlobals_Return


#====== PenguinCoach ======
.GLE ADDRESS init__12PenguinCoachFRC12JMapInfoIter +0x18C
#Can't reuse the Bob-omb Buddy 'cause different registers
b .PenguinCoach_RegisterGlobals
.PenguinCoach_RegisterGlobals_Return:
.GLE ENDADDRESS

.PenguinCoach_RegisterGlobals:
mr        r3, r31
bl .MR_RegisterAllGlobalFuncs

addi      r11, r1, 0xE0
b .PenguinCoach_RegisterGlobals_Return



#====== PenguinMaster ======
.GLE ADDRESS init__13PenguinMasterFRC12JMapInfoIter +0xD8
#Can't reuse the Bob-omb Buddy 'cause different registers
b .PenguinMaster_RegisterGlobals
.PenguinMaster_RegisterGlobals_Return:
.GLE ENDADDRESS

.PenguinMaster_RegisterGlobals:
mr        r3, r29
bl .MR_RegisterAllGlobalFuncs

addi      r11, r1, 0xD0
b .PenguinMaster_RegisterGlobals_Return

#Ran out of room
.GLE ASSERT __sinit_\MarioFacePlanet_cpp
.GLE ENDADDRESS





.GLE ADDRESS .MINI_COMET_CONNECTOR
#====== Pichan ======
.GLE ADDRESS init__6PichanFRC12JMapInfoIter +0x158
mr        r3, r29
bl .MR_RegisterGlobalAnimeFunc
.GLE ENDADDRESS

#Keep Vanilla Events
.GLE ADDRESS branchFunc__6PichanFUl
b .Pichan_BranchFunc
.Pichan_BranchFunc_Vanilla:
.GLE ENDADDRESS

.Pichan_BranchFunc:
srawi r5, r4, 0x0C #Get the event type
cmpwi r5, 0
beq .Pichan_BranchFunc_DoVanilla
b .MR_GlobalBranchFunc
.Pichan_BranchFunc_DoVanilla:
stwu      r1, -0x10(r1)
b .Pichan_BranchFunc_Vanilla

.GLE ADDRESS eventFunc__6PichanFUl
b .Pichan_EventFunc
.Pichan_EventFunc_Vanilla:
.GLE ENDADDRESS

.Pichan_EventFunc:
srawi r5, r4, 0x0C #Get the event type
cmpwi r5, 0
beq .Pichan_EventFunc_DoVanilla
b .MR_GlobalEventFunc
.Pichan_EventFunc_DoVanilla:
stwu      r1, -0x10(r1)
b .Pichan_EventFunc_Vanilla



#====== PichanRacer ======
#Add new AnimeFunc
.GLE ADDRESS init__11PichanRacerFRC12JMapInfoIter +0xE4
bl .MR_RegisterBranchAndGlobalAnimeFunc
.GLE ENDADDRESS


.GLE ADDRESS init__11PichanRacerFRC12JMapInfoIter +0x1FC
b .PichanRacer_InitEx
.PichanRacer_HasStar:
.GLE ENDADDRESS

.GLE ADDRESS init__11PichanRacerFRC12JMapInfoIter +0x230
.PichanRacer_Init_Return:
.GLE ENDADDRESS

.PichanRacer_InitEx:
lwz       r3, 4(r29)
bl findStarID__2MRFPCc
#if no star ID is found, then we can just skip everything!
cmpwi r3, 0
ble .PichanRacer_NoStar
mr        r3, r29
b .PichanRacer_HasStar

.PichanRacer_NoStar:
b .PichanRacer_Init_Return


.GLE ADDRESS init__11PichanRacerFRC12JMapInfoIter +0x194
b .PichanRacer_InitEx2
.PichanRacer_HasStar2:
.GLE ENDADDRESS

.GLE ADDRESS init__11PichanRacerFRC12JMapInfoIter +0x1AC
.PichanRacer_Init_Return2:
.GLE ENDADDRESS

.PichanRacer_InitEx2:
stw       r3, 0x1F8(r1)
lwz       r3, 4(r29)
bl findStarID__2MRFPCc
#if no star ID is found, then we can just skip everything!
cmpwi r3, 0
ble .PichanRacer_NoStar2
lwz       r3, 0x1F8(r1)
cmpwi     r29, 0
b .PichanRacer_HasStar2

.PichanRacer_NoStar2:
b .PichanRacer_Init_Return2


.GLE ADDRESS init__11PichanRacerFRC12JMapInfoIter +0x2E0
b .PichanRacer_InitEx3
.PichanRacer_HasStar3:
.GLE ENDADDRESS

.GLE ADDRESS init__11PichanRacerFRC12JMapInfoIter +0x2EC
.PichanRacer_Init_Return3:
.GLE ENDADDRESS

#this one isn't even in the init function.... bruh
.PichanRacer_InitEx3:
lwz       r3, 4(r31)
bl findStarID__2MRFPCc
#if no star ID is found, then we can just skip everything!
cmpwi r3, 0
ble .PichanRacer_NoStar3
mr        r3, r31
b .PichanRacer_HasStar3

.PichanRacer_NoStar3:
b .PichanRacer_Init_Return3



#====== PlayAttackMan ======
.PlayAttackMan_InitEx:
lwz       r3, 4(r30)
bl findStarID__2MRFPCc
#if no star ID is found, then we can just skip everything!
cmpwi r3, 0
ble .PlayAttackMan_InitEx_NoStar
li        r3, 0x20
b .PlayAttackMan_InitEx_Star

.PlayAttackMan_InitEx_NoStar:
b .PlayAttackMan_Init_Return
#Skip everything - including the eventfunc registration 'cause there's no star lol
#UPDATE 2022-10-17: Do NOT skip the EventFunc! The new NPC Stuff is here!

.GLE ADDRESS init__13PlayAttackManFRC12JMapInfoIter +0x28
b .PlayAttackMan_InitEx
.PlayAttackMan_InitEx_Star:
.GLE ENDADDRESS

.GLE ADDRESS init__13PlayAttackManFRC12JMapInfoIter +0x5C
.PlayAttackMan_Init_Return:
.GLE ENDADDRESS

.GLE ADDRESS init__13PlayAttackManFRC12JMapInfoIter +0x8C
mr        r3, r30
bl .MR_RegisterAllGlobalFuncs
.GLE ENDADDRESS



#====== Rabbit ======
.GLE ADDRESS init__6RabbitFRC12JMapInfoIter +0x200
#NOT Shared with HoneyBee! They don't use the same register...
b .Rabbit_RegisterGlobals
.Rabbit_RegisterGlobals_Return:
.GLE ENDADDRESS

.Rabbit_RegisterGlobals:
mr        r3, r31
bl .MR_RegisterAllGlobalFuncs

addi      r11, r1, 0xE0
b .Rabbit_RegisterGlobals_Return


#====== Rosetta ======
.GLE ADDRESS init__7RosettaFRC12JMapInfoIter +0x194
b .Rosetta_InitAnime
.Rosetta_InitAnime_Return:
mr r3, r27
mr r4, r28
bl .MR_RegisterTalkToDemo
.GLE ENDADDRESS

.Rosetta_InitAnime:
mr r3, r27
bl .MR_RegisterAllGlobalFuncs
b .Rosetta_InitAnime_Return



#====== ScoreAttackMan ======
.GLE ADDRESS init__14ScoreAttackManFRC12JMapInfoIter +0x12C
mr r3, r30
bl .MR_RegisterGlobalAnimeFunc
.GLE ENDADDRESS



#====== Tico ======
.GLE ADDRESS eventFunc__4TicoFUl
srawi r5, r4, 0x0C #Get the event type
cmpwi r5, 0
bne .Tico_DoGlobalEventFunc
li        r0, 1
stb       r0, 0x19D(r3)
li        r3, 1
blr


.Tico_DoGlobalEventFunc:
b .MR_GlobalEventFunc
.GLE ASSERT exeReaction__4TicoFv
.GLE ENDADDRESS

.GLE ADDRESS init__4TicoFRC12JMapInfoIter +0x17C
bl .MR_RegisterTalkToDemo
.GLE ENDADDRESS

#====== TicoBaby ======
#This NPC Cannot talk



#====== TicoBig ======
.GLE ADDRESS init__7TicoBigFRC12JMapInfoIter +0xE0
#Don't need custom space for this one!
mr r3, r29
bl .MR_RegisterAllGlobalFuncs

addi      r11, r1, 0xC0
bl        _restgpr_29
lwz       r0, 0xC4(r1)
mtlr      r0
addi      r1, r1, 0xC0
blr
.GLE ENDADDRESS



#====== TicoFatCoin ======
#Changed to have a new Obj Arg (Obj arg 0) which determines the Save Data ID to use.
#These Save Data IDs are global
#Obj arg goes in 0x1D0

.GLE ADDRESS createNameObj<11TicoFatCoin>__14NameObjFactoryFPCc_P7NameObj +0x14
li r3, 0x1DC   #Increase Memory
.GLE ENDADDRESS

.GLE ADDRESS init__11TicoFatCoinFRC12JMapInfoIter +0xC8
b .TicoCoinFat_InitExt
.TicoCoinFat_InitExt_Return:
.GLE ENDADDRESS

.TicoCoinFat_InitExt:
bl getJMapInfoArg1NoInit__2MRFRC12JMapInfoIterPl

#An actual rare use of the "WithInit" version???
mr        r3, r30
addi      r4, r29, 0x1D0
bl getJMapInfoArg0WithInit__2MRFRC12JMapInfoIterPl

mr        r3, r30
addi      r4, r29, 0x1D4
bl getJMapInfoArg2WithInit__2MRFRC12JMapInfoIterPb

mr        r3, r30
addi      r4, r29, 0x1D8
bl getJMapInfoArg6WithInit__2MRFRC12JMapInfoIterPl
b .TicoCoinFat_InitExt_Return


.GLE ADDRESS init__11TicoFatCoinFRC12JMapInfoIter +0x284
b .TicoCoinFat_Init_FixAppearIfSwAppear
.TicoCoinFat_Init_FixAppearIfSwAppear_Return:
.GLE ENDADDRESS

.TicoCoinFat_Init_FixAppearIfSwAppear:
bl isValidSwitchAppear__2MRFPC9LiveActor
cmpwi r3, 0
mr        r3, r29
lwz       r12, 0(r29)
beq .TicoCoinFat_Init_FixAppearIfSwAppear_DoAppear
lwz       r12, 0x38(r12)
b .TicoCoinFat_Init_FixAppearIfSwAppear_Return

.TicoCoinFat_Init_FixAppearIfSwAppear_DoAppear:
lwz       r12, 0x30(r12)
b .TicoCoinFat_Init_FixAppearIfSwAppear_Return



.GLE ADDRESS initAfterPlacement__11TicoFatCoinFv
b .TicoCoinFat_NewInitAfterPlacement
.GLE ENDADDRESS

.TicoCoinFat_NewInitAfterPlacement:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
mr        r31, r3
lbz r4, 0x1D4(r31)
cmpwi r4, 0
bne .TicoCoinFat_NewInitAfterPlacement_Return

bl        .GLE_getTicoFatCoinFromStorage
lwz r4, 0x164(r31)
cmpw r3, r4
blt       .TicoCoinFat_NewInitAfterPlacement_Return
mr        r3, r31
bl        callMakeActorAppearedAllGroupMember__2MRFPC9LiveActor
mr        r3, r31
bl        onSwitchA__2MRFP9LiveActor

lwz       r12, 0(r31)
mr        r3, r31
lwz       r12, 0x38(r12)
mtctr     r12
bctrl

.TicoCoinFat_NewInitAfterPlacement_Return:
lwz       r0, 0x14(r1)
lwz       r31, 0x0C(r1)
mtlr      r0
addi      r1, r1, 0x10
blr


#New APPEAR function to allow appearing hungry lumas
#surprised this didn't work in vanilla but oh well
#THIS IS SHARED between both hungry lumas
.GLE ADDRESS __vt__11TicoFatCoin +0x2C
.int .TicoCoinFat_Appear_New
.GLE ENDADDRESS

.TicoCoinFat_Appear_New:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
mr        r31, r3

bl isOnSwitchA__2MRFPC9LiveActor
cmpwi r3, 0
bne .TicoCoinFat_Appear_New_Return

mr r3, r31
bl appear__9LiveActorFv

.TicoCoinFat_Appear_New_Return:
lwz       r31, 0x0C(r1)
lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr


.GLE ADDRESS sub_80368FA0 +0x54
lbz r4, 0x1D4(r31)
.GLE ENDADDRESS

.GLE ADDRESS sub_803691E0
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
mr        r31, r3
cmpwi     r4, 0
bne       loc_8036921C
#bl        .GLE_IsEnableDebug
li r3, 0
cmpwi     r3, 0
bne       loc_80369210
mr r3, r31
lwz r4, 0x164(r31)
bl        .GLE_setTicoFatCoinFromStorage

loc_80369210:
loc_8036921C:
mr        r3, r31
bl        callAppearAllGroupMember__2MRFPC9LiveActor
b         loc_80369228
                
bl        callMakeActorAppearedAllGroupMember__2MRFPC9LiveActor
mr        r3, r31
bl        onSwitchA__2MRFP9LiveActor
                
loc_80369228:
lwz       r0, 0x14(r1)
lwz       r31, 0x0C(r1)
mtlr      r0
addi      r1, r1, 0x10
blr
.GLE ASSERT __cl__57TalkMessageFuncM<P11TicoFatCoin,M11TicoFatCoinFPCvPvUl_b>CFUl
.GLE ENDADDRESS


#r3 = TicoCoinFat*
.GLE_getTicoFatCoinFromStorage:
stwu      r1, -0x150(r1)
mflr      r0
stw       r0, 0x154(r1)
addi      r11, r1, 0x150
bl _savegpr_29

mr r31, r3

bl .GLE_GetCurrentStageName_Guarantee
mr r5, r3
lwz r6, 0x1D0(r31)
addi r3, r1,0x0C
li r4, 0x110
bl .GLE_getTicoFatCoinStorageName

bl getGameEventValueChecker__16GameDataFunctionFv
addi r4, r1,0x0C
bl getValue__21GameEventValueCheckerCFPCc

addi      r11, r1, 0x150
bl _restgpr_29
lwz       r0, 0x154(r1)
mtlr      r0
addi      r1, r1, 0x150
blr


#r3 = TicoCoinFat*
#r4 = int Coin Num Fed (usually this is the same as the set number of coins)
.GLE_setTicoFatCoinFromStorage:
stwu      r1, -0x150(r1)
mflr      r0
stw       r0, 0x154(r1)
addi      r11, r1, 0x150
bl _savegpr_29

mr r31, r3
mr r30, r4

bl .GLE_GetCurrentStageName_Guarantee
mr r5, r3
lwz r6, 0x1D0(r31)
addi r3, r1,0x0C
li r4, 0x110
bl .GLE_getTicoFatCoinStorageName

bl getGameEventValueChecker__16GameDataFunctionFv
addi r4, r1,0x0C
mr r5, r30
bl setValue__21GameEventValueCheckerFPCcUs

addi      r11, r1, 0x150
bl _restgpr_29
lwz       r0, 0x154(r1)
mtlr      r0
addi      r1, r1, 0x150
blr


#r3 = Char* Dest
#r4 = int DestSize
#r5 = Const Char* StageName
#r6 = int ID
.GLE_getTicoFatCoinStorageName:
mr r7, r6
mr r6, r5
lis       r5, TicoFatCoin_EventValue_Format@ha
addi      r5, r5, TicoFatCoin_EventValue_Format@l
b .GLE_getTicoFatStorageName

TicoFatCoin_EventValue_Format:
    .string "TicoFatCoin[%s_%d]" AUTO



.GLE ADDRESS sub_80368F30 +0x2C
b .TicoFatCoin_GetInformationMessage
.TicoFatCoin_GetInformationMessage_Return:
.GLE ENDADDRESS
.TicoFatCoin_GetInformationMessage:
lwz r4, 0x1D8(r31)
bl .GLE_GetTicoFatMessageOrDefaultStr
b .TicoFatCoin_GetInformationMessage_Return










#====== TicoFatStarPiece ======
#TicoFatStarPiece rewrite for GLE

#Obj Arg 0 = ID. Works just like the Coin Hungry Luma. -1 = Always respawn
#Obj Arg 1 = Required Starbits. Default 100

#Address Remapping
# TicoFatCoin --> TicoFatStarPiece

# 0x164 int "Required coin num"    --> 0x16C int "Starbit request amount"
# 0x168 MultiActorCamera* "Flight" --> 0x190 > 0x10  "MultiActorCamera* "Flight"
# 0x16C CoinSuccState*             --> N/A
# 0x170 Matrix &                   --> 0x194 Matrix & (new memory)
# 0x1A0 Matrix &                   --> 0x1C4 Matrix & (new memory)

.GLE ADDRESS createNameObj<16TicoFatStarPiece>__14NameObjFactoryFPCc_P7NameObj +0x14
li r3, 0x204
.GLE ENDADDRESS


.GLE ADDRESS __ct__16TicoFatStarPieceFPCc +0x5C
b .TicoFatStarPiece_InitEx
.TicoFatStarPiece_InitEx_Return:
.GLE ENDADDRESS

.TicoFatStarPiece_InitEx:
stw       r4, 0x190(r31)
addi      r3, r31, 0x194
bl identity__Q29JGeometry38TMatrix34<Q29JGeometry13SMatrix34C<f>>Fv
addi      r3, r31, 0x1C4
bl identity__Q29JGeometry38TMatrix34<Q29JGeometry13SMatrix34C<f>>Fv

lis r3, .TicoFatStarPiece_ActiveStaticLoc@ha
addi r3, r3, .TicoFatStarPiece_ActiveStaticLoc@l
li r0, 0
stw r0, 0x00(r3)

stw r0, 0x200(r31)

mr r3, r31
b .TicoFatStarPiece_InitEx_Return



#First, write a new init function that uses Obj Args and the custom GLE flag system
.GLE ADDRESS init__16TicoFatStarPieceFRC12JMapInfoIter
.TicoFatStarPiece_Init_Replacement:
stwu      r1, -0x130(r1)
mflr      r0
stw       r0, 0x134(r1)
addi      r11, r1, 0x130
bl        _savegpr_29

mr r29, r3  #TicoFatStarPiece*
mr r30, r4  #JMapInfoIter
lis r31, TicoFatStarPiece_Reaction@ha
addi r31, r31, TicoFatStarPiece_Reaction@l

addi r3, r1, 0x7C
addi r4, r31, TicoFatStarPiece_Str - TicoFatStarPiece_Reaction
bl __ct__12NPCActorCapsFPCc
addi r3, r1, 0x7C
bl setDefault__12NPCActorCapsFv

addi r3, r13, TicoFatStarPieceNrvPrep - STATIC_R13
stw r3, 0x0114(r1)
li r5, 1
stw r5, 0xB8(r1)
li r0, 0
stb r0, 0x8A(r1)
stb r0, 0x0111(r1)

mr r3, r29
mr r4, r30
addi r5, r1, 0x7C
addi r6, r31, TicoFatStarPiece_Str - TicoFatStarPiece_Reaction
li r7, 0
li r8, 0
bl initialize__8NPCActorFRC12JMapInfoIterRC12NPCActorCapsPCcPCcb

mr        r3, r29
bl moveCoordToStartPos__2MRFP9LiveActor

mr        r3, r29
bl onCalcShadowAll__2MRFP9LiveActor

li        r3, 0x2C
bl __nw__FUl
cmpwi     r3, 0
mr        r4, r3
beq .TicoFatStarPieceTransformation_FailedNew
mr        r4, r29
mr        r5, r30
bl __ct__30TicoFatStarPieceTransformationFP16TicoFatStarPieceRC12JMapInfoIter
mr        r4, r3

.TicoFatStarPieceTransformation_FailedNew:
stw       r4, 0x190(r29)

mr        r3, r29
addi      r5, r13, TicoFatStarPieceNrvTransform - STATIC_R13
addi      r6, r31, TicoFatStarPiece_Demo_Str - TicoFatStarPiece_Reaction
bl initActorState__2MRFP9LiveActorP23ActorStateBaseInterfacePC5NervePCc

mr r3, r30
addi r4, r29, 0x184    #-1 means "Reset each time the level loads"
bl getJMapInfoArg0WithInit__2MRFRC12JMapInfoIterPl

li r5, 0x19  #default 25
stw r5, 0x16C(r29)

mr r3, r30
addi r4, r29, 0x16C
bl getJMapInfoArg1NoInit__2MRFRC12JMapInfoIterPl

mr r3, r30
addi r4, r29, 0x200
bl getJMapInfoArg2NoInit__2MRFRC12JMapInfoIterPl

mr r3, r30
addi r4, r29, 0x1FC
bl getJMapInfoArg6WithInit__2MRFRC12JMapInfoIterPl

li        r0, 0
stw       r0, 0x174(r29)

lwz r3, 0x184(r29)
cmpwi r3, -1
li r3, 0
beq .TicoFatStarPiece_DoResetCheck

.TicoFatStarPiece_UseStorageForRemainingCalc:
#Get the value from the EventValues
mr r3, r29
bl .GLE_getTicoFatStarPieceFromStorage

.TicoFatStarPiece_DoResetCheck:
lwz r4, 0x200(r29)
cmpwi r4, 0
beq .TicoFatStarPiece_DoRemainingCalc

lwz       r4, 0x16C(r29)
cmpw r3, r4
beq .TicoFatStarPiece_DoRemainingCalc
li r3, 0 #This special mode lets it work like it does in SMG1. You must complete it for it to save

.TicoFatStarPiece_DoRemainingCalc:
lwz       r4, 0x16C(r29)
subf      r4, r3, r4
neg       r0, r4
orc       r0, r4, r0
srawi     r0, r0, 0x1F
andc      r4, r4, r0
stw       r4, 0x170(r29)

mr        r3, r29
bl declareStarPieceReceiver__2MRFPC7NameObjl

lfs       f1, TicoFatStarPiece_0f - STATIC_R2(r2)
lfs       f0, TicoFatStarPiece_220f - STATIC_R2(r2)
stfs      f1, 0x14(r1)
stfs      f0, 0x18(r1)
stfs      f1, 0x1C(r1)

mr        r3, r29
mr        r4, r30
addi      r5, r31, TicoFat_Request000 - TicoFatStarPiece_Reaction
addi      r6, r1, 0x14
li        r7, 0
bl initTalkCtrlDirect__8NPCActorFRC12JMapInfoIterPCcRCQ29JGeometry8TVec3<f>PA4_f

lfs       f1, TicoFatStarPiece_0f - STATIC_R2(r2)
lfs       f0, TicoFatStarPiece_220f - STATIC_R2(r2)
stfs      f1, 0x08(r1)
stfs      f0, 0x0C(r1)
stfs      f1, 0x10(r1)

mr        r3, r29
mr        r4, r30
addi      r5, r31, TicoFat_StarPiece000 - TicoFatStarPiece_Reaction
addi      r6, r1, 0x08
li        r7, 0
bl createTalkCtrlDirect__2MRFP9LiveActorRC12JMapInfoIterPCcRCQ29JGeometry8TVec3<f>PA4_f
stw       r3, 0x168(r29)

lwz       r3, 0x94(r29)
lfs       f1, TicoFatStarPiece_280f - STATIC_R2(r2)
bl setDistanceToTalk__2MRFP15TalkMessageCtrlf

lwz       r3, 0x168(r29)
lfs       f1, TicoFatStarPiece_280f - STATIC_R2(r2)
bl setDistanceToTalk__2MRFP15TalkMessageCtrlf

lwz       r3, 0x94(r29)
bl sub_800614B0

lwz       r3, 0x168(r29)
bl sub_800614B0

lwz       r3, 0x94(r29)
bl onRootNodeAutomatic__2MRFP15TalkMessageCtrl

addi      r3, r31, TicoFatStarPiece_EventFunc - TicoFatStarPiece_Reaction
lwz       r6, TicoFatStarPiece_EventFunc - TicoFatStarPiece_Reaction(r31)
lwz       r5, TicoFatStarPiece_EventFunc+4 - TicoFatStarPiece_Reaction(r31)
lis r4, TicoFatStarPiece_FunctorPtr@ha
addi r4, r4, TicoFatStarPiece_FunctorPtr@l
lwz       r0, TicoFatStarPiece_EventFunc+8 - TicoFatStarPiece_Reaction(r31)
stw       r4, 0x20(r1)
addi      r4, r1, 0x20
stw       r29, 0x24(r1)
stw       r6, 0x28(r1)
stw       r5, 0x2C(r1)
stw       r0, 0x30(r1)
lwz       r3, 0x94(r29)
bl registerEventFunc__2MRFP15TalkMessageCtrlRC19TalkMessageFuncBase

lwz       r3, 0x94(r29)
lwz       r4, 0x170(r29)
bl setMessageArg__2MRFP15TalkMessageCtrli

lwz       r3, TicoFatCamera_Ptr - STATIC_R13(r13)
bl declareEventCameraProgrammable__2MRFPCc

addi      r3, r1, 0x48
bl __ct__14AnimScaleParamFv

lfs f1, TicoFatStarPiece_012 - STATIC_R2(r2)
lfs f0, TicoFatStarPiece_089999998 - STATIC_R2(r2)

stfs      f1, 0x68(r1)
stfs      f1, 0x6C(r1)
stfs      f1, 0x70(r1)

li        r3, 0x1C
bl __nw__FUl
cmpwi     r3, 0
beq .TicoFatStarPiece_AnimScaleController_NewFail
li        r4, 0
bl __ct__19AnimScaleControllerFP14AnimScaleParam

.TicoFatStarPiece_AnimScaleController_NewFail:
stw       r3, 0x144(r29)

lfs f0, TicoFatStarPiece_1000 - STATIC_R2(r2)
addi r8, r31, TicoFatStarPiece_Spin - TicoFatStarPiece_Reaction
addi r7, r31, TicoFatStarPiece_Trampled - TicoFatStarPiece_Reaction
addi r6, r31, TicoFatStarPiece_Pointing - TicoFatStarPiece_Reaction
addi r5, r31, TicoFatStarPiece_Reaction - TicoFatStarPiece_Reaction
stw       r8, 0x134(r29)
stw       r7, 0x138(r29)
stw       r6, 0x13C(r29)
stw       r5, 0x140(r29)
stfs      f0, 0x130(r29)

mr        r3, r29
addi r4, r31, TicoFatStarPiece_Wait - TicoFatStarPiece_Reaction
bl getActionName__16TicoFatStarPieceFPCc
stw       r3, 0x100(r29)
stw       r3, 0x104(r29)

mr        r3, r29
addi r4, r31, TicoFatStarPiece_Talk - TicoFatStarPiece_Reaction
bl getActionName__16TicoFatStarPieceFPCc
stw       r3, 0x108(r29)
stw       r3, 0x10C(r29)

addi r4, r31, TicoFatStarPiece_Str - TicoFatStarPiece_Reaction
addi r7, r13, NULLSTRING - STATIC_R13
addi r6, r13, NULLSTRING - STATIC_R13
addi r5, r13, NULLSTRING - STATIC_R13
addi r0, r13, NULLSTRING - STATIC_R13

stw       r4, 0x34(r1)
stw       r7, 0x38(r1)
stw       r6, 0x3C(r1)
stw       r5, 0x40(r1)
stw       r0, 0x44(r1)

addi      r3, r1, 0x34
li        r4, 0
bl getNPCItemData__2MRFP12NPCActorIteml

mr        r3, r29
addi      r4, r1, 0x34
li        r5, 0
bl equipment__8NPCActorFRC12NPCActorItemb

lwz       r3, 0x98(r29)
addi      r4, r31, TicoFatGoodsStarPiece - TicoFatStarPiece_Reaction
bl startAction__2MRFPC9LiveActorPCc

lwz       r3, 0x9C(r29)
addi      r4, r31, TicoFatGoodsStarPiece - TicoFatStarPiece_Reaction
bl startAction__2MRFPC9LiveActorPCc

lwz       r3, 0x98(r29)
lfs f1, TicoFatStarPiece_0f - STATIC_R2(r2)
bl setBpkFrame__2MRFPC9LiveActorf

lwz       r3, 0x9C(r29)
lfs f1, TicoFatStarPiece_100 - STATIC_R2(r2)
bl setBpkFrame__2MRFPC9LiveActorf

mr        r3, r29
addi      r4, r31, TicoFatStarPiece_Small0 - TicoFatStarPiece_Reaction
bl startBva__2MRFPC9LiveActorPCc

mr        r3, r29
addi      r4, r31, TicoFatStarPiece_Normal - TicoFatStarPiece_Reaction
bl startBrk__2MRFPC9LiveActorPCc

mr        r3, r29
lfs f1, TicoFatStarPiece_0f - STATIC_R2(r2)
bl setBrkFrameAndStop__2MRFPC9LiveActorf

mr        r3, r29
bl        sub_8036AA20

mr        r3, r29
bl        sub_8036AA90

li        r3, 0x3C
bl __nw__FUl
cmpwi     r3, 0
beq .TicoFatStarPiece_FullnessMeter_NewFail
mr        r4, r29
lwz       r5, 0x16C(r29)
lwz       r0, 0x170(r29)
subf      r6, r0, r5
bl __ct__13FullnessMeterFP9LiveActorll

.TicoFatStarPiece_FullnessMeter_NewFail:
stw       r3, 0x164(r29)
bl initWithoutIter__7NameObjFv

lwz       r4, 0x170(r29)
lwz       r0, 0x16C(r29)
lwz       r3, 0x164(r29)
subf      r4, r4, r0
bl setNumber__13FullnessMeterFl

mr        r3, r29
mr        r4, r30
lis r5, PlanetaryAppearance_Jp@ha
addi r5, r5, PlanetaryAppearance_Jp@l
li        r6, 32
bl joinToGroupArray__2MRFP9LiveActorRC12JMapInfoIterPCcl

#don't have enough space here to fit all the new stuff oops
mr        r3, r29
b .TicoFatStarPiece_Init_FixAppearIfSwAppear
.TicoFatStarPiece_Init_FixAppearIfSwAppear_Return:
mtctr     r12
bctrl

addi      r11, r1, 0x130
bl        _restgpr_29
lwz       r0, 0x134(r1)
mtlr      r0
addi      r1, r1, 0x130
blr
.GLE PRINTADDRESS
.GLE ASSERT init__16TicoFatStarPieceFRC12JMapInfoIter +0x3DC
.GLE ENDADDRESS


.TicoFatStarPiece_Init_FixAppearIfSwAppear:
bl isValidSwitchAppear__2MRFPC9LiveActor
cmpwi r3, 0
mr        r3, r29
lwz       r12, 0(r29)
beq .TicoFatStarPiece_Init_FixAppearIfSwAppear_DoAppear
lwz       r12, 0x38(r12)
b .TicoFatStarPiece_Init_FixAppearIfSwAppear_Return

.TicoFatStarPiece_Init_FixAppearIfSwAppear_DoAppear:
lwz       r12, 0x30(r12)
b .TicoFatStarPiece_Init_FixAppearIfSwAppear_Return



#New function
.TicoFatStarPiece_InitAfterPlacement:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
mr        r31, r3

lwz r3, 0x184(r31)
cmpwi r3, -1  #If we always want it to respawn
beq loc_80369068

mr r3, r31
bl .GLE_getTicoFatStarPieceFromStorage
lwz r4, 0x16C(r31)
cmpw r3, r4
blt       loc_80369068

mr        r3, r31
bl        callMakeActorAppearedAllGroupMember__2MRFPC9LiveActor
mr        r3, r31
bl        onSwitchA__2MRFP9LiveActor
lwz       r12, 0(r31)
mr        r3, r31
lwz       r12, 0x38(r12)
mtctr     r12
bctrl

loc_80369068:
lwz       r0, 0x14(r1)
lwz       r31, 0x0C(r1)
mtlr      r0
addi      r1, r1, 0x10
blr

.GLE ADDRESS __vt__16TicoFatStarPiece +0x10
.int .TicoFatStarPiece_InitAfterPlacement
.GLE ENDADDRESS

.GLE ADDRESS __vt__16TicoFatStarPiece +0x2C
.int .TicoCoinFat_Appear_New
.GLE ENDADDRESS

.GLE ADDRESS depleteStarPiece__16TicoFatStarPieceFv +0x9C
bl .TicoFatStarPiece_CalcDepleteStarPieceNum
mr r31, r3
nop
nop
nop
nop
.GLE ENDADDRESS

#r3 = Full request number
#Returns: How many starbits 1 starbit should count as
.TicoFatStarPiece_CalcDepleteStarPieceNum:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
mr        r31, r3

#    0 -  100 starbits: 1 starbit visual =  1 starbit
#  100 -  500 starbits: 1 starbit visual =  2 starbits
#  500 - 1000 starbits: 1 starbit visual =  5 starbits
# 1000 - 2500 starbits: 1 starbit visual = 10 starbits
#    2500+    starbits: 1 starbit visual = 15 starbits

cmpwi r31, 100
li r3, 1
ble .TicoFatStarPiece_CalcDepleteStarPieceNum_Return

cmpwi r31, 200
li r3, 2
ble .TicoFatStarPiece_CalcDepleteStarPieceNum_Return

cmpwi r31, 1000
li r3, 5
ble .TicoFatStarPiece_CalcDepleteStarPieceNum_Return

cmpwi r31, 2500
li r3, 10
ble .TicoFatStarPiece_CalcDepleteStarPieceNum_Return

cmpwi r31, 5000
li r3, 15

.TicoFatStarPiece_CalcDepleteStarPieceNum_Return:
lwz       r0, 0x14(r1)
lwz       r31, 0x0C(r1)
mtlr      r0
addi      r1, r1, 0x10
blr


.GLE ADDRESS getDanceSeTranspose__16TicoFatStarPieceCFv
b .TicoFatStarPiece_CalcDanceSe_New
.GLE ENDADDRESS

.TicoFatStarPiece_CalcDanceSe_New:
lwz       r4, 0x170(r3)
lwz       r3, 0x16C(r3)

cmpwi r3, 500
li        r0, 25
ble .TicoFatStarPiece_CalcDanceSe_New_DoCalc

cmpwi r3, 1000
li        r0, 50
ble .TicoFatStarPiece_CalcDanceSe_New_DoCalc

cmpwi r3, 2500
li        r0, 100
ble .TicoFatStarPiece_CalcDanceSe_New_DoCalc

li        r0, 250

.TicoFatStarPiece_CalcDanceSe_New_DoCalc:
subf      r3, r4, r3
addi      r3, r3, -1
divw.     r3, r3, r0
bge       loc_8036AC60
li        r3, 0

loc_8036AC60:
cmpwi     r3, 32
blelr
li        r3, 32
blr


.GLE ADDRESS depleteStarPiece__16TicoFatStarPieceFv +0x3C
bl .TicoFatStarPiece_CalcInterval
.GLE ENDADDRESS

#    0 -  100 starbits: 5 frames per starbit shot
#  500 - 1000 starbits: 4 frames per starbit shot
# 1000 - 2500 starbits: 3 frames per starbit shot
#    2500+    starbits: 1 frame per starbit shot

.TicoFatStarPiece_CalcInterval:
lwz       r5, 0x16C(r3)

cmpwi r5, 100
li r4, 5
blelr

cmpwi r5, 1000
li r4, 4
blelr

cmpwi r5, 2500
li r4, 3
blelr

li r4, 1
blr




#Now to fix a rather annoying bug...
#So, basically, these lumas will fight over the active GlobalEventCamera if they are allowed to be fed.
#The solution that I have implemented, goes as follows:
#
# - Create a static variable which will hold a LiveActor* (pointer to a TicoFatStarPiece, in this case)
# - If the luma in that pointer does not match the current luma, do not pass 0x8036A290, and do not collect 200 dollars
# - The currently active luma will be the only one allowed to manage the Global Event Camera.
# - A luma will register itself to the static variable when mario walks in range, and the variable is not set to Zero. (NullPtr)
# - If the static variable is set to Zero, pass 0x8036A290.

.GLE ADDRESS control__16TicoFatStarPieceFv +0xCC
lwz       r3, 0x18C(r31)
addi      r0, r3, -1
stw       r0, 0x18C(r31)
b .TicoFatStarPiece_TryStartEventCamera
nop
nop
.TicoFatStarPiece_Control_ContinueNormal:
.GLE ENDADDRESS

.GLE ADDRESS control__16TicoFatStarPieceFv +0xFC
.TicoFatStarPiece_Control_Return:
.GLE ENDADDRESS

.GLE ADDRESS control__16TicoFatStarPieceFv +0x114
.TicoFatStarPiece_Control_FullReturn:
.GLE ENDADDRESS

##

.TicoFatStarPiece_TryStartEventCamera:
lbz       r0, 0x180(r31)
cmpwi     r0, 0
beq .TicoFatStarPiece_TryStartEventCamera_Return_NoActivateFull
#Don't bother if it's not even activated yet


lis r3, .TicoFatStarPiece_ActiveStaticLoc@ha
addi r3, r3, .TicoFatStarPiece_ActiveStaticLoc@l
lwz r3, 0x00(r3)
cmpwi r3, 0 #If it's Zero, it's open!
beq .TicoFatStarPiece_TryStartEventCamera_Return_Activate

cmpw r3, r31 #If we match, then we are authorized to use it
beq .TicoFatStarPiece_TryStartEventCamera_Return_Activate
#Otherwise, just return
lwz       r3, 0x168(r31)
lfs       f1, TicoFatStarPiece__1 - STATIC_R2(r2)
bl isNearPlayer__15TalkMessageCtrlCFf
cmpwi r3, 0
bne .TicoFatStarPiece_TryStartEventCamera_Return_NoActivate
lwz       r3, 0x164(r31)
bl requestDisappear__13FullnessMeterFv

.TicoFatStarPiece_TryStartEventCamera_Return_NoActivate:
b .TicoFatStarPiece_Control_Return

.TicoFatStarPiece_TryStartEventCamera_Return_NoActivateFull:
b .TicoFatStarPiece_Control_FullReturn

.TicoFatStarPiece_TryStartEventCamera_Return_Activate:
lwz       r3, 0x168(r31)
lfs       f1, TicoFatStarPiece__1 - STATIC_R2(r2)
bl isNearPlayer__15TalkMessageCtrlCFf
cmpwi r3, 0
lis r5, .TicoFatStarPiece_ActiveStaticLoc@ha
addi r5, r5, .TicoFatStarPiece_ActiveStaticLoc@l
beq .TicoFatStarPiece_NoNearPlayer

.TicoFatStarPiece_YesNearPlayer:
stw r31, 0x00(r5) #Store ourselves if the static is free
mr r3, r31
bl invalidateClipping__2MRFP9LiveActor  #Invalidate clipping to ensure that this ticofat will free itself from being fed before it gets clipped
b .TicoFatStarPiece_Control_ContinueNormal

.TicoFatStarPiece_NoNearPlayer:
lwz r3, 0x00(r5)
cmpw r3, r31 # If we are the luma here, we are authorized to clear the static
bne .TicoFatStarPiece_SkipFreeStatic

.TicoFatStarPiece_FreeStatic:
li r4, 0
stw r4, 0x00(r5)  #Free the static if the player is too far away

.TicoFatStarPiece_SkipFreeStatic:
mr r3, r31
bl validateClipping__2MRFP9LiveActor
b .TicoFatStarPiece_Control_ContinueNormal





.GLE ADDRESS control__16TicoFatStarPieceFv +0x24
b .TicoFatStarPiece_TryStartEventCamera_OnComplete
.TicoFatStarPiece_TryStartEventCamera_OnComplete_Return:
.GLE ENDADDRESS

.TicoFatStarPiece_TryStartEventCamera_OnComplete:
lis r5, .TicoFatStarPiece_ActiveStaticLoc@ha
addi r5, r5, .TicoFatStarPiece_ActiveStaticLoc@l
lwz r3, 0x00(r5)
cmpw r3, r31 #If we match, then we are authorized to use it
bne .TicoFatStarPiece_TryStartEventCamera_SkipCompleteClear
li r4, 0
stw r4, 0x00(r5)  #Free the static if the luma is completed!
lwz       r3, 0x164(r31)
bl requestDisappear__13FullnessMeterFv

.TicoFatStarPiece_TryStartEventCamera_SkipCompleteClear:
mr r3, r31
b .TicoFatStarPiece_TryStartEventCamera_OnComplete_Return






#We now must replace the second half of the luma execution with a copy of the coin luma's execution
#we cannot use the exact same code, unfortunately.


.GLE ADDRESS control__16TicoFatStarPieceFv +0x40
b .TicoFatStarPiece_IsNeedSkipControl
.TicoFatStarPiece_IsNeedSkipControl_No_JumpLoc:
.GLE ENDADDRESS
.GLE ADDRESS control__16TicoFatStarPieceFv +0x114
.TicoFatStarPiece_IsNeedSkipControl_Yes_JumpLoc:
.GLE ENDADDRESS


.TicoFatStarPiece_IsNeedSkipControl:
mr        r3, r31
addi      r4, r13, .TicoFatStarPiece_NrvFlight_sInstance - STATIC_R13
bl isNerve__9LiveActorCFPC5Nerve
cmpwi r3, 0
bne .TicoFatStarPiece_IsNeedSkipControl_Yes

mr        r3, r31
addi      r4, r13, .TicoFatStarPiece_NrvWipeOut_sInstance - STATIC_R13
bl isNerve__9LiveActorCFPC5Nerve
cmpwi r3, 0
bne .TicoFatStarPiece_IsNeedSkipControl_Yes

mr        r3, r31
addi      r4, r13, .TicoFatStarPiece_NrvWipeHold_sInstance - STATIC_R13
bl isNerve__9LiveActorCFPC5Nerve
cmpwi r3, 0
bne .TicoFatStarPiece_IsNeedSkipControl_Yes

mr        r3, r31
addi      r4, r13, .TicoFatStarPiece_NrvWipeIn_sInstance - STATIC_R13
bl isNerve__9LiveActorCFPC5Nerve
cmpwi r3, 0
bne .TicoFatStarPiece_IsNeedSkipControl_Yes

mr        r3, r31
addi      r4, r13, .TicoFatStarPiece_NrvInformation_sInstance - STATIC_R13
bl isNerve__9LiveActorCFPC5Nerve
cmpwi r3, 0
bne .TicoFatStarPiece_IsNeedSkipControl_Yes

mr        r3, r31
addi      r4, r13, .TicoFatStarPiece_NrvInformationHold_sInstance - STATIC_R13
bl isNerve__9LiveActorCFPC5Nerve
cmpwi r3, 0
bne .TicoFatStarPiece_IsNeedSkipControl_Yes

mr        r3, r31
addi      r4, r13, .TicoFatStarPiece_NrvEnd_sInstance - STATIC_R13
bl isNerve__9LiveActorCFPC5Nerve
cmpwi r3, 0
bne .TicoFatStarPiece_IsNeedSkipControl_Yes

mr        r3, r31
addi      r4, r13, .TicoFatStarPiece_NrvNull_sInstance - STATIC_R13
bl isNerve__9LiveActorCFPC5Nerve
cmpwi r3, 0
beq .TicoFatStarPiece_IsNeedSkipControl_No

.TicoFatStarPiece_IsNeedSkipControl_Yes:
b .TicoFatStarPiece_IsNeedSkipControl_Yes_JumpLoc

.TicoFatStarPiece_IsNeedSkipControl_No:
mr        r3, r31
addi      r4, r13, TicoFatStarPieceNrvReaction - STATIC_R13
bl isNerve__9LiveActorCFPC5Nerve
b .TicoFatStarPiece_IsNeedSkipControl_No_JumpLoc


#Static addresses
.GLE ADDRESS unk_807D5E10 +0x28
.GLE TRASH BEGIN

.TicoFatStarPiece_NrvFlight_sInstance:
.int 0

.TicoFatStarPiece_NrvWipeOut_sInstance:
.int 0

.TicoFatStarPiece_NrvWipeHold_sInstance:
.int 0

.TicoFatStarPiece_NrvWipeIn_sInstance:
.int 0

.TicoFatStarPiece_NrvInformation_sInstance:
.int 0

.TicoFatStarPiece_NrvInformationHold_sInstance:
.int 0

.TicoFatStarPiece_NrvEnd_sInstance:
.int 0

#Granted, this is just a BLR...
.TicoFatStarPiece_NrvNull_sInstance:
.int 0

.TicoFatStarPiece_ActiveStaticLoc:
.int 0

.GLE TRASH END
.GLE ENDADDRESS


.TicoFatStarPiece_STATIC_INIT_EX:
#stwu      r1, -0x10(r1)
#mflr      r0
#stw       r0, 0x14(r1)

lis r5, .TicoFatStarPiece_NrvFlight@ha
addi r5, r5, .TicoFatStarPiece_NrvFlight@l
addi r3, r13, .TicoFatStarPiece_NrvFlight_sInstance - STATIC_R13

addi r4, r5, .TicoFatStarPiece_NrvFlight - .TicoFatStarPiece_NrvFlight    #Typical SMG stuff
stw r4, 0x00(r3)

addi r4, r5, .TicoFatStarPiece_NrvWipeOut - .TicoFatStarPiece_NrvFlight
stw r4, 0x04(r3)

addi r4, r5, .TicoFatStarPiece_NrvWipeHold - .TicoFatStarPiece_NrvFlight
stw r4, 0x08(r3)

addi r4, r5, .TicoFatStarPiece_NrvWipeIn - .TicoFatStarPiece_NrvFlight
stw r4, 0x0C(r3)

addi r4, r5, .TicoFatStarPiece_NrvInformation - .TicoFatStarPiece_NrvFlight
stw r4, 0x10(r3)

addi r4, r5, .TicoFatStarPiece_NrvInformationHold - .TicoFatStarPiece_NrvFlight
stw r4, 0x14(r3)

addi r4, r5, .TicoFatStarPiece_NrvEnd - .TicoFatStarPiece_NrvFlight
stw r4, 0x18(r3)

addi r4, r5, .TicoFatStarPiece_NrvNull - .TicoFatStarPiece_NrvFlight
stw r4, 0x1C(r3)

#lwz       r0, 0x14(r1)
#mtlr      r0
#addi      r1, r1, 0x10
blr

.GLE ADDRESS sub_8036B860 +0x04
b kill__23ActorStateBaseInterfaceFv
.GLE ENDADDRESS

.GLE ADDRESS sub_8036AF90 +0x24
mr        r3, r31
addi      r4, r13, .TicoFatStarPiece_NrvFlight_sInstance - STATIC_R13
bl setNerve__9LiveActorFPC5Nerve
nop
nop
.GLE ENDADDRESS


#-----------------------------------
#VTable
.TicoFatStarPiece_NrvFlight:
.int 0
.int 0
.int .TicoFatStarPiece_exeFlight
.int executeOnEnd__5NerveCFP5Spine

.TicoFatStarPiece_NrvWipeOut:
.int 0
.int 0
.int .TicoFatStarPiece_exeWipeOut
.int executeOnEnd__5NerveCFP5Spine

.TicoFatStarPiece_NrvWipeHold:
.int 0
.int 0
.int .TicoFatStarPiece_exeWipeHold
.int executeOnEnd__5NerveCFP5Spine

.TicoFatStarPiece_NrvWipeIn:
.int 0
.int 0
.int .TicoFatStarPiece_exeWipeIn
.int executeOnEnd__5NerveCFP5Spine

.TicoFatStarPiece_NrvInformation:
.int 0
.int 0
.int .TicoFatStarPiece_exeInformation
.int executeOnEnd__5NerveCFP5Spine

.TicoFatStarPiece_NrvInformationHold:
.int 0
.int 0
.int .TicoFatStarPiece_exeInformationHold
.int executeOnEnd__5NerveCFP5Spine

.TicoFatStarPiece_NrvEnd:
.int 0
.int 0
.int .TicoFatStarPiece_exeEnd
.int executeOnEnd__5NerveCFP5Spine

.TicoFatStarPiece_NrvNull:
.int 0
.int 0
.int .TicoFatStarPiece_exeNull
.int executeOnEnd__5NerveCFP5Spine

#-----------------------------------

.set TicoFatStarPiece_NrvLength, 0x5A
.TicoFatStarPiece_exeFlight:
.GLE PRINTADDRESS
lwz       r3, 0(r4)

stwu      r1, -0x30(r1)
mflr      r0
stw       r0, 0x34(r1)
stw       r31, 0x2C(r1)
mr        r31, r3

bl isFirstStep__2MRFPC9LiveActor
cmpwi r3, 0
beq .TicoFatStarPiece_exeFlight_FirstStepSkip

mr        r3, r31
li        r4, 0
bl tryRumblePadMiddle__2MRFPCvl

mr        r3, r31
bl hideModelAndOnCalcAnim__2MRFP9LiveActor

mr        r3, r31
bl invalidateShadowAll__2MRFP9LiveActor

mr        r3, r31
bl invalidateClipping__2MRFP9LiveActor

mr r3, r31
addi r4, r13, TicoFat_Fly_Str - STATIC_R13
bl startAction__2MRFPC9LiveActorPCc

mr        r3, r31
addi r4, r13, TicoFat_Fly_Str - STATIC_R13
li        r5, -1
li        r6, -1
li        r7, -1
bl startActionSound__2MRFPC9LiveActorPCclll

mr r3, r31
lwz r4, 0x190(r31)
lwz r4, 0x10(r4)
lis r5, TicoFatCoin_FlightJp@ha
addi r5, r5, TicoFatCoin_FlightJp@l
li r6, -1
bl startMultiActorCameraTargetSelf__2MRFPC9LiveActorPC15ActorCameraInfoPCcl

.TicoFatStarPiece_exeFlight_FirstStepSkip:
mr r3, r31
lis r4, TicoFatCoin_VolDownBgm@ha
addi r4, r4, TicoFatCoin_VolDownBgm@l
li r5, -1
li r6, -1
li r7, -1
bl startActionSound__2MRFPC9LiveActorPCclll

mr        r3, r31
bl getRailTotalLength__2MRFPC9LiveActor
fmr       f2, f1
lfs       f1, TicoFatStarPiece_0f - STATIC_R2(r2)
mr        r3, r31
li        r4, TicoFatStarPiece_NrvLength
bl calcNerveEaseOutValue__2MRFPC9LiveActorlff

mr        r3, r31
bl setRailCoord__2MRFP9LiveActorf

mr        r3, r31
bl moveTransToCurrentRailPos__2MRFP9LiveActor

.GLE PRINTADDRESS
#Make rail direction
addi r3, r1, 0x14
mr        r4, r31
bl calcRailDirection__2MRFPQ29JGeometry8TVec3<f>PC9LiveActor
addi r3, r1, 0x08
mr        r4, r31
bl calcUpVec__2MRFPQ29JGeometry8TVec3<f>PC9LiveActor
addi      r3, r31, 0xA4
lis r4, .TicoFatStarPiece_01@ha
addi r4, r4, .TicoFatStarPiece_01@l
lfs f1, 0x00(r4)
lfs f2, TicoFatStarPiece_0f - STATIC_R2(r2)
mr r4, r3
addi r5, r1, 0x14
addi r6, r1, 0x08
bl AlternateBlendQuatFrontUp


mr        r3, r31
li        r4, TicoFatStarPiece_NrvLength
bl isGreaterEqualStep__2MRFPC9LiveActorl
cmpwi     r3, 0
beq .TicoFatStarPiece_exeFlight_Return

mr        r3, r31
addi r4, r13, .TicoFatStarPiece_NrvWipeOut_sInstance - STATIC_R13
bl setNerve__9LiveActorFPC5Nerve

.TicoFatStarPiece_exeFlight_Return:
lwz       r0, 0x34(r1)
lwz       r31, 0x2C(r1)
mtlr      r0
addi      r1, r1, 0x30
blr

.TicoFatStarPiece_01:
.float 0.5
#######

.TicoFatStarPiece_exeWipeOut:
lwz       r3, 0(r4)

stwu      r1, -0xA0(r1)
mflr      r0
stw       r0, 0xA4(r1)
addi      r11, r1, 0xA0
bl        _savegpr_28
mr        r28, r3
lis       r31, TicoFatCoin_DataStart@ha
addi      r31, r31, TicoFatCoin_DataStart@l
bl isFirstStep__2MRFPC9LiveActor
cmpwi     r3, 0
beq .TicoFatStarPiece_exeWipeOut_FirstStepSkip

li        r3, 0x3C
bl        closeWipeWhiteFade__2MRFl
mr        r3, r28
li        r4, 0
bl        tryRumblePadVeryStrong__2MRFPCvl
bl        shakeCameraNormal__2MRFv
mr        r3, r28
addi      r4, r31, DmTicofatMorphWipeOut - TicoFatCoin_DataStart
li        r5, -1
li        r6, -1
li        r7, -1
bl        startActionSound__2MRFPC9LiveActorPCclll
mr        r3, r28
addi      r4, r31, ScreenEffect - TicoFatCoin_DataStart
bl        emitEffect__2MRFP9LiveActorPCc
addi      r4, r28, 0x194
bl        setHostMtx__12MultiEmitterFPA4_f
mr        r3, r28
addi      r4, r31, ScreenEffectLight - TicoFatCoin_DataStart
bl        emitEffect__2MRFP9LiveActorPCc
addi      r4, r28, 0x1C4
bl        setHostMtx__12MultiEmitterFPA4_f

.TicoFatStarPiece_exeWipeOut_FirstStepSkip:
mr        r3, r28
addi      r4, r31, TicoFatCoin_VolDownBgm - TicoFatCoin_DataStart
li        r5, -1
li        r6, -1
li        r7, -1
bl startActionSound__2MRFPC9LiveActorPCclll

#Camera stuff wooo
addi      r3, r1, 0x74
bl getCamPos__2MRFv

addi      r30, r1, 0x74
addi      r4, r28, 0x14
addi      r3, r1, 0x80
bl __ct__Q29JGeometry8TVec3<f>FRCQ29JGeometry8TVec3<f>

addi      r29, r1, 0x80
psq_l     f1, 0(r30), 0, 0
psq_l     f0, 0(r29), 0, 0
mr        r3, r29
psq_l     f2, 8(r29), 1, 0
ps_sub    f0, f0, f1
psq_l     f3, 8(r30), 1, 0
ps_sub    f1, f2, f3
psq_st    f0, 0(r29), 0, 0
psq_st    f1, 8(r29), 1, 0
bl normalizeOrZero__2MRFPQ29JGeometry8TVec3<f>

mr        r4, r29
addi      r3, r1, 0x2C
bl __ct__Q29JGeometry8TVec3<f>FRCQ29JGeometry8TVec3<f>

lfs       f2, 0x2C(r1)
lfs       f3, TicoFatCoin_500 - STATIC_R2(r2)
lfs       f1, 0x30(r1)
lfs       f0, 0x34(r1)
fmuls     f2, f2, f3
fmuls     f1, f1, f3
fmuls     f0, f0, f3
stfs      f2, 0x2C(r1)
stfs      f1, 0x30(r1)
stfs      f0, 0x34(r1)

addi      r3, r1, 0x38
bl getCamPos__2MRFv

addi      r29, r1, 0x44
addi      r4, r1, 0x38
mr        r3, r29
bl __ct__Q29JGeometry8TVec3<f>FRCQ29JGeometry8TVec3<f>

addi      r4, r1, 0x2C
psq_l     f0, 0(r29), 0, 0
psq_l     f1, 0(r4), 0, 0
psq_l     f2, 8(r29), 1, 0
ps_add    f0, f0, f1
psq_l     f3, 8(r4), 1, 0
ps_add    f1, f2, f3
psq_st    f0, 0(r29), 0, 0
psq_st    f1, 8(r29), 1, 0

addi      r3, r1, 0x50
bl getCamYdir__2MRFv

addi      r3, r1, 0x5C
bl getCamZdir__2MRFv

addi      r3, r1, 0x68
addi      r4, r1, 0x5C
bl __mi__Q29JGeometry8TVec3<f>CFv

mr        r6, r29
addi      r3, r28, 0x194
addi      r4, r1, 0x68
addi      r5, r1, 0x50
bl makeMtxFrontUpPos__2MRFPQ29JGeometry64TPosition3<Q29JGeometry38TMatrix34<Q29JGeometry13SMatrix34C<f>>>RCQ29JGeometry8TVec3<f>RCQ29JGeometry8TVec3<f>RCQ29JGeometry8TVec3<f>


addi      r3, r1, 0x08
bl        getCamYdir__2MRFv

addi      r3, r1, 0x14
bl        getCamZdir__2MRFv

addi      r3, r1, 0x20
addi      r4, r1, 0x14
bl __mi__Q29JGeometry8TVec3<f>CFv

addi      r3, r28, 0x1C4
addi      r4, r1, 0x20
addi      r5, r1, 0x08
addi      r6, r28, 0x14
bl makeMtxFrontUpPos__2MRFPQ29JGeometry64TPosition3<Q29JGeometry38TMatrix34<Q29JGeometry13SMatrix34C<f>>>RCQ29JGeometry8TVec3<f>RCQ29JGeometry8TVec3<f>RCQ29JGeometry8TVec3<f>

bl isWipeActive__2MRFv
cmpwi r3, 0
bne .TicoFatStarPiece_exeWipeOut_Return

mr        r3, r28
bl stopBck__2MRFPC9LiveActor

mr        r3, r28
addi      r4, r31, ScreenEffectFog - TicoFatCoin_DataStart
bl emitEffect__2MRFP9LiveActorPCc

addi      r4, r28, 0x194
bl setHostMtx__12MultiEmitterFPA4_f

mr        r3, r28
addi      r4, r31, ScreenEffect - TicoFatCoin_DataStart
bl deleteEffect__2MRFP9LiveActorPCc

mr        r3, r28
addi      r4, r13, .TicoFatStarPiece_NrvWipeHold_sInstance - STATIC_R13
bl setNerve__9LiveActorFPC5Nerve

.TicoFatStarPiece_exeWipeOut_Return:
addi      r11, r1, 0xA0
bl        _restgpr_28
lwz       r0, 0xA4(r1)
mtlr      r0
addi      r1, r1, 0xA0
blr

#######

.TicoFatStarPiece_exeWipeHold:
lwz       r3, 0(r4)

stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
mr        r31, r3
bl        isFirstStep__2MRFPC9LiveActor
cmpwi     r3, 0
beq       loc_80368E4C
mr        r3, r31
lis       r4, DmTicofatMorphWipeIn@ha
addi      r4, r4, DmTicofatMorphWipeIn@l
li        r5, -1
li        r6, -1
li        r7, -1
bl        startActionSound__2MRFPC9LiveActorPCclll

loc_80368E4C:
mr        r3, r31
lis       r4, TicoFatCoin_VolDownBgm@ha
addi      r4, r4, TicoFatCoin_VolDownBgm@l
li        r5, -1
li        r6, -1
li        r7, -1
bl        startActionSound__2MRFPC9LiveActorPCclll
mr        r3, r31
li        r4, 0x5A
bl        isGreaterEqualStep__2MRFPC9LiveActorl
cmpwi     r3, 0
beq       loc_80368E88
mr        r3, r31
addi      r4, r13, .TicoFatStarPiece_NrvWipeIn_sInstance - STATIC_R13
bl        setNerve__9LiveActorFPC5Nerve

loc_80368E88:
lwz       r0, 0x14(r1)
lwz       r31, 0x0C(r1)
mtlr      r0
addi      r1, r1, 0x10
blr



.TicoFatStarPiece_exeWipeIn:
lwz       r3, 0(r4)

stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
mr        r31, r3
bl        isFirstStep__2MRFPC9LiveActor
cmpwi     r3, 0
beq       loc_80368ED0
mr        r3, r31
bl        onSwitchA__2MRFP9LiveActor
li        r3, 0x3C # '<'
bl        openWipeWhiteFade__2MRFl

loc_80368ED0:
mr        r3, r31
li        r4, 0x2E # '.'
bl        isLessStep__2MRFPC9LiveActorl
cmpwi     r3, 0
beq       loc_80368F00
mr        r3, r31
lis       r4, TicoFatCoin_VolDownBgm@ha
addi      r4, r4, TicoFatCoin_VolDownBgm@l # "VolDownBgm"
li        r5, -1
li        r6, -1
li        r7, -1
bl        startActionSound__2MRFPC9LiveActorPCclll

loc_80368F00:
bl        isWipeActive__2MRFv
cmpwi     r3, 0
bne       loc_80368F18
mr        r3, r31
addi      r4, r13, .TicoFatStarPiece_NrvInformation_sInstance - STATIC_R13
bl        setNerve__9LiveActorFPC5Nerve

loc_80368F18:
lwz       r0, 0x14(r1)
lwz       r31, 0x0C(r1)
mtlr      r0
addi      r1, r1, 0x10
blr



.TicoFatStarPiece_exeInformation:
lwz       r3, 0(r4)

stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
mr r31, r3
bl        isFirstStep__2MRFPC9LiveActor
cmpwi     r3, 0
beq       loc_80368F68

bl        startAppearPlanetJingle__2MRFv
lis       r3, InformationGalaxy_Format@ha
addi      r3, r3, InformationGalaxy_Format@l
lwz r4, 0x1FC(r31)
bl        .GLE_GetTicoFatMessageOrDefaultStr
li        r4, 1
bl        appearInformationMessage__2MRFPCwb

loc_80368F68:
bl        isDeadInformationMessage__2MRFv
cmpwi     r3, 0
beq       loc_80368F80
mr        r3, r31
addi      r4, r13, .TicoFatStarPiece_NrvInformationHold_sInstance - STATIC_R13
bl        setNerve__9LiveActorFPC5Nerve

loc_80368F80:
lwz       r0, 0x14(r1)
lwz       r31, 0x0C(r1)
mtlr      r0
addi      r1, r1, 0x10
blr

.TicoFatStarPiece_exeInformationHold:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
lwz       r31, 0(r4)
li        r4, 0x14
mr        r3, r31
bl        isGreaterEqualStep__2MRFPC9LiveActorl
cmpwi     r3, 0
beq       loc_80369514
mr        r3, r31
addi      r4, r13, .TicoFatStarPiece_NrvEnd_sInstance - STATIC_R13
bl        setNerve__9LiveActorFPC5Nerve

loc_80369514:
lwz       r0, 0x14(r1)
lwz       r31, 0x0C(r1)
mtlr      r0
addi      r1, r1, 0x10
blr

######

.GLE PRINTADDRESS
.TicoFatStarPiece_exeEnd:
lwz       r3, 0(r4)

stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
mr        r31, r3
bl isFirstStep__2MRFPC9LiveActor
cmpwi r3, 0
beq .TicoFatStarPiece_exeEnd_SkipFirstStep

mr        r3, r31
lwz       r4, 0x190(r31)
lwz       r4, 0x10(r4)
lis r5, TicoFatCoin_FlightJp@ha
addi r5, r5, TicoFatCoin_FlightJp@l
li        r6, 0
li        r7, -1
bl endMultiActorCamera__2MRFPC9LiveActorPC15ActorCameraInfoPCcbl

mr        r3, r31
lis r4, TicoFatStarPiece_TransformJp@ha
addi r4, r4, TicoFatStarPiece_TransformJp@l
bl endDemo__2MRFP7NameObjPCc

.TicoFatStarPiece_exeEnd_SkipFirstStep:
mr        r3, r31
li        r4, 0x3C
bl isGreaterEqualStep__2MRFPC9LiveActorl
cmpwi r3, 0
beq .TicoFatStarPiece_exeEnd_Return

lwz r3, 0x184(r31)
cmpwi r3, -1
beq .TicoFatStarPiece_exeEnd_SkipSaveData
mr r3, r31
lwz r4, 0x16C(r31)
bl .GLE_setTicoFatStarPieceFromStorage

.TicoFatStarPiece_exeEnd_SkipSaveData:
mr        r3, r31
bl callAppearAllGroupMember__2MRFPC9LiveActor

mr        r3, r31
addi      r4, r13, .TicoFatStarPiece_NrvNull_sInstance - STATIC_R13
bl        setNerve__9LiveActorFPC5Nerve

lwz       r12, 0(r31)
mr        r3, r31
lwz       r12, 0x34(r12)
mtctr     r12
bctrl   #Kill

.TicoFatStarPiece_exeEnd_Return:
lwz       r0, 0x14(r1)
lwz       r31, 0x0C(r1)
mtlr      r0
addi      r1, r1, 0x10
blr


#GENIUS FALLTHROUGH????
.TicoFatStarPiece_exeNull:
blr


#-----------------------------------

.GLE ADDRESS sub_8036A380 +0x24
lwz       r5, 0x174(r3)
lwz       r0, 0x170(r3)
subf      r5, r6, r5
stw       r5, 0x174(r3)
subf      r0, r6, r0
stw       r0, 0x170(r3)
lwz r0, 0x184(r31)
cmpwi r0, -1
b .TicoFatStarPiece_UpdateGameStorage
.TicoFatStarPiece_UpdateGameStorage_Return:
.GLE ENDADDRESS

.TicoFatStarPiece_UpdateGameStorage:
beq .TicoFatStarPiece_UpdateGameStorage_Skip


mr r3, r31
lwz r4, 0x16C(r31)
lwz r5, 0x170(r31)
sub r4, r4, r5
bl .GLE_setTicoFatStarPieceFromStorage

.TicoFatStarPiece_UpdateGameStorage_Skip:
b .TicoFatStarPiece_UpdateGameStorage_Return





#r3 = TicoFatStarPiece*
.GLE_getTicoFatStarPieceFromStorage:
stwu      r1, -0x150(r1)
mflr      r0
stw       r0, 0x154(r1)
addi      r11, r1, 0x150
bl _savegpr_29

mr r31, r3

bl .GLE_GetCurrentStageName_Guarantee
mr r5, r3
lwz r6, 0x184(r31)
addi r3, r1,0x0C
li r4, 0x110
bl .GLE_getTicoFatStarPieceStorageName

bl getGameEventValueChecker__16GameDataFunctionFv
addi r4, r1,0x0C
bl getValue__21GameEventValueCheckerCFPCc

addi      r11, r1, 0x150
bl _restgpr_29
lwz       r0, 0x154(r1)
mtlr      r0
addi      r1, r1, 0x150
blr


#r3 = TicoFatStarPiece*
#r4 = int Starbits Fed
.GLE_setTicoFatStarPieceFromStorage:
stwu      r1, -0x150(r1)
mflr      r0
stw       r0, 0x154(r1)
addi      r11, r1, 0x150
bl _savegpr_29

mr r31, r3
mr r30, r4

bl .GLE_GetCurrentStageName_Guarantee
mr r5, r3
lwz r6, 0x184(r31)
addi r3, r1,0x0C
li r4, 0x110
bl .GLE_getTicoFatStarPieceStorageName

bl getGameEventValueChecker__16GameDataFunctionFv
addi r4, r1,0x0C
mr r5, r30
bl setValue__21GameEventValueCheckerFPCcUs

addi      r11, r1, 0x150
bl _restgpr_29
lwz       r0, 0x154(r1)
mtlr      r0
addi      r1, r1, 0x150
blr


#r3 = Char* Dest
#r4 = int DestSize
#r5 = Const Char* StageName
#r6 = int ID
.GLE_getTicoFatStarPieceStorageName:
mr r7, r6
mr r6, r5
lis       r5, TicoFatStarPiece_EventValue_Format@ha
addi      r5, r5, TicoFatStarPiece_EventValue_Format@l
b .GLE_getTicoFatStorageName

TicoFatStarPiece_EventValue_Format:
    .string "TicoFatStarPiece[%s_%d]"
    
InformationGalaxy_Format:
    .string "InformationGalaxy"
    
InformationTicoFat_Format:
    .string "InformationTicoFat%03d" AUTO



#==============================
#r3 = Char* Dest
#r4 = int DestSize
#r5 = Format
#r6 = Const Char* StageName
#r7 = int ID
.GLE_getTicoFatStorageName:
crclr     4*cr1+eq
b       snprintf


.GLE PRINTADDRESS
#r3 = Default message const char *
#r4 = int. If -1, the value in r3 is returned
#Returns: WChar_t*
.GLE_GetTicoFatMessageOrDefaultStr:
cmpwi r4, -1
bne .GLE_GetTicoFatMessageOrDefaultStr_Custom
b        getGameMessageDirect__2MRFPCc

.GLE_GetTicoFatMessageOrDefaultStr_Custom:
stwu      r1, -0x150(r1)
mflr      r0
stw       r0, 0x154(r1)

mr r6, r4
addi r3, r1, 0x08
li r4, 0x120
lis       r5, InformationTicoFat_Format@ha
addi      r5, r5, InformationTicoFat_Format@l
bl .GLE_getTicoFatStorageName

addi r3, r1, 0x08
bl        getGameMessageDirect__2MRFPCc

lwz       r0, 0x154(r1)
mtlr      r0
addi      r1, r1, 0x150
blr

#====== TicoRail ======
#This NPC Cannot talk



#====== TicoShop ======
#This NPC has hardcoded dialogue



#====== TicoShopDice ======
#This NPC has hardcoded dialogue



#====== TogepinAttackMan ======
.GLE ADDRESS init__16TogepinAttackManFRC12JMapInfoIter +0x1BC
mr r3, r31
bl .MR_RegisterGlobalAnimeFunc
.GLE ENDADDRESS



#====== TrickRabbit ======
#This NPC has hardcoded behaviour


.GLE PRINTADDRESS
#Had to move this down here
.LuigiTalkNpcInitJumpLoc:
mr        r3, r30
addi r4, r1, 0x54
bl getJMapInfoArg7NoInit__2MRFRC12JMapInfoIterPb
cmpwi r3, 0
ble .LuigiTalkNpcInitJumpLoc_FINISH

lbz r3, 0x54(r1)
cmpwi r3, 0
ble .LuigiTalkNpcInitJumpLoc_FINISH

#Shares a TakeOutStar nerve with Rosalina
li        r3, 0x20
bl __nw__FUl
cmpwi r3, 0
beq .LuigiTalkNpcInitJumpLoc_Failure

mr        r4, r29
lis r5, .LuigiTalkNPC_TakeOutStar@ha
addi r5, r5, .LuigiTalkNPC_TakeOutStar@l
mr r6, r5
addi      r7, r13, sInstance__Q210NrvRosetta14RosettaNrvWait - STATIC_R13
li        r8, 0
bl __ct__11TakeOutStarFP8NPCActorPCcPCcPC5Nervel

.LuigiTalkNpcInitJumpLoc_Failure:
stw r3, 0x164(r29)

mr        r3, r29
bl declarePowerStar__2MRFPC7NameObj

.LuigiTalkNpcInitJumpLoc_FINISH:
b .LuigiTalkNpcInitJumpLoc_Return

.LuigiTalkNPC_TakeOutStar:
.string "TakeOutStar" AUTO
#.GLE ASSERT TalkMessageFunc<9Caretaker>__FP9CaretakerM9CaretakerFPCvPvUl_b_51TalkMessageFuncM<P9Caretaker,M9CaretakerFPCvPvUl_b>
.NPC_UTILITY_CONNECTOR:
.GLE ENDADDRESS
