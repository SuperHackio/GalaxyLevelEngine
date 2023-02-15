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
#0x00 = No Branch (Defaults to the LiveActor Specific code, if any!)
#0x01 = Compare Coins
#0x02 = Compare Purple Coins
#0x03 = Compare Starbits
#0x04 = Compare Health
#0x05 = Compare Stars
#0x06 = Compare Powerup (use this if normal flows don't provide access to a given powerup)
#0x07 = JMapProgress Index. For memory purposes, uses the same BCSV as ScenarioSwitch
#0x08 = 
#0x09 = 
#0x0A = 
#0x0B = 
#0x0C = 
#0x0D = 
#0x0E = 
#0x0F = 

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

.BranchFunc_Case_F:
b .BranchFunc_Success

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
#       Example: 0x3002 will display coins
#0x03 = ForceKillPlayerByGroundRace
#0x04 = Restart current stage
#0x05 = Change Stage. Parameter value is an index into ChangeSceneListInfo (Main Galaxy only)
#0x06 = Add Coins
#0x07 = Add Starbits
#0x08 = Remove Coins
#0x09 = Remove Starbits
#0x0A = 
#0x0B = 
#0x0C = 
#0x0D = 
#0x0E = 
#0x0F = 

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

.EventFunc_Case_B:

.EventFunc_Case_C:

.EventFunc_Case_D:

.EventFunc_Case_E:

.EventFunc_Case_F:

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
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
stw       r30, 0x08(r1)
mr        r31, r3
bl tryRegisterDemoCast__2MRFP9LiveActorRC12JMapInfoIter
cmpwi r3, 0
beq .RegisterTalkToDemo_Return

mr        r3, r31
lwz       r4, 0x94(r31)
bl registerDemoTalkMessageCtrl__12DemoFunctionFP9LiveActorP15TalkMessageCtrl

.RegisterTalkToDemo_Return:
lwz       r0, 0x14(r1)
lwz       r31, 0x0C(r1)
lwz       r30, 0x08(r1)
mtlr      r0
addi      r1, r1, 0x10
blr


#======================================== NPC FIXES ========================================
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
.Rabbit_RegisterGlobals:
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



#====== KinopioPostman ======
#-- NPC Removed from the game --



#====== KoopaNpc ======
#???????????


#====== LuigiTalkNpc ======
.GLE ADDRESS init__12LuigiTalkNpcFRC12JMapInfoIter +0x110
bl .MR_RegisterEventAndGlobalAnimeFunc
b .LuigiTalkNpcInitJumpLoc
.GLE ENDADDRESS

.GLE ADDRESS init__12LuigiTalkNpcFRC12JMapInfoIter +0x11C
bl .MR_RegisterTalkToDemo
b .LuigiTalkNpcInitJumpLoc
.GLE ENDADDRESS

.GLE ADDRESS init__12LuigiTalkNpcFRC12JMapInfoIter +0x18C
.LuigiTalkNpcInitJumpLoc:
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
#N/A



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



.GLE ADDRESS .Caretaker_InitEnd
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
#Shared with HoneyBee!
b .Rabbit_RegisterGlobals
.Rabbit_RegisterGlobals_Return:
.GLE ENDADDRESS



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
#???????????



#====== TicoFatStarPiece ======
#???????????



#====== TicoRail ======
#This NPC Cannot talk



#====== TicoShop ======
#This NPC has hardcoded dialogue



#====== TicoShopDice ======
#This NPC has hardcoded dialogue



#====== TogepinAttackMan ======
.GLE ADDRESS init__16TogepinAttackManFRC12JMapInfoIter +0x1BC
mr r3, r28
bl .MR_RegisterGlobalAnimeFunc
.GLE ENDADDRESS



#====== TrickRabbit ======
#This NPC has hardcoded behaviour


.GLE PRINTADDRESS
.GLE ASSERT TalkMessageFunc<9Caretaker>__FP9CaretakerM9CaretakerFPCvPvUl_b_51TalkMessageFuncM<P9Caretaker,M9CaretakerFPCvPvUl_b>
.GLE ENDADDRESS
