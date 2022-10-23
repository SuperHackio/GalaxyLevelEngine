#This file holds General purpose NPC functions



#=========== Flow Checkers ===========
#Got some nice stuff here, mostly more options for MSBF

.GLE ADDRESS branchFuncGameProgress__2MRFi -0x0C

#MR::GlobalEventFunc(NPCActor*, EventData)
#r3 = NPCActor* Caller
#r4 = Event Data Value
#  0xF000 = Event Type
#  0x0FFF = Parameter Value
#returns 0 if the event type is 0, returns 1 otherwise. If 0, then execute the vanilla function of the NPC (like Taking out a star)
.MR_GlobalEventFunc:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
stw       r30, 0x08(r1)

srawi r31, r4, 0x0C #Get the event type
rlwinm r30, r4, 0, 20, 31 #Get the parameter value


#== Event Types ==
#0 = NoEvent
#1 = MR::getCoinNum((void)) (param ignored, sets the message number argument)
#2 = MR::getPurpleCoinNum((void)) (param ignored, sets the message number argument)
#3 = MR::getStarPieceNum((void)) (param ignored, sets the message number argument)
#4 = MR::getStockedCoin((void)) (param ignored, sets the message number argument)
#5 = GameDataFunction::getStockedStarPieceNum((void)) (param ignored, sets the message number argument)
#6 = MR::forceKillPlayerByGroundRace((void)) (param ignored)
#7 = 
#8 = 
#9 = 
#A = 
#B = 
#C = 
#D = 
#E = 
#F = 





lwz       r31, 0x0C(r1)
lwz       r30, 0x08(r1)
lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr

.GLE ASSERT branchFuncGameProgress__2MRFi +0x11C
.GLE ENDADDRESS























#============== NPC FIXES =============
#Verious fixes for NPCs.

#====== PlayAttackMan ======
#Check with ProjMapObj.s to make sure the address aligns correctly
.GLE ADDRESS __sinit_\MarioFacePlanet_cpp +0x20

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

.GLE ADDRESS init__13PlayAttackManFRC12JMapInfoIter +0x28
b .PlayAttackMan_InitEx
.PlayAttackMan_InitEx_Star:
.GLE ENDADDRESS

.GLE ADDRESS init__13PlayAttackManFRC12JMapInfoIter +0x94
.PlayAttackMan_Init_Return:
.GLE ENDADDRESS

#====== PichanRacer ======
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


.GLE ADDRESS init__11PichanRacerFRC12JMapInfoIter +0x1FC
b .PichanRacer_InitEx
.PichanRacer_HasStar:
.GLE ENDADDRESS

.GLE ADDRESS init__11PichanRacerFRC12JMapInfoIter +0x230
.PichanRacer_Init_Return:
.GLE ENDADDRESS


.GLE ADDRESS init__11PichanRacerFRC12JMapInfoIter +0x194
b .PichanRacer_InitEx2
.PichanRacer_HasStar2:
.GLE ENDADDRESS

.GLE ADDRESS init__11PichanRacerFRC12JMapInfoIter +0x1AC
.PichanRacer_Init_Return2:
.GLE ENDADDRESS


.GLE ADDRESS init__11PichanRacerFRC12JMapInfoIter +0x2E0
b .PichanRacer_InitEx3
.PichanRacer_HasStar3:
.GLE ENDADDRESS

.GLE ADDRESS init__11PichanRacerFRC12JMapInfoIter +0x2EC
.PichanRacer_Init_Return3:
.GLE ENDADDRESS


#====== Caretaker ======
.Caretaker_InitAnime:
addi      r3, r31, 0x54
lwz       r5, 0x54(r31)
lwz       r6, 0x04(r3)
mr        r4, r29
lwz       r0, 0x08(r3)
addi      r3, r1, 0x44
stw       r5, 0x14(r1)
addi      r5, r1, 0x14
stw       r6, 0x18(r1)
stw       r0, 0x1C(r1)
lwz       r28, 0x94(r29)
.GLE PRINTADDRESS
bl   TalkMessageFunc<9Caretaker>__FP9CaretakerM9CaretakerFPCvPvUl_b_51TalkMessageFuncM<P9Caretaker,M9CaretakerFPCvPvUl_b>
mr        r3, r28
addi      r4, r1, 0x44
bl        registerAnimeFunc__2MRFP15TalkMessageCtrlRC19TalkMessageFuncBase

addi      r11, r1, 0x170
b .CaretakerReturn

.GLE ADDRESS init__9CaretakerFRC12JMapInfoIter +0x4A8
b .Caretaker_InitAnime
.CaretakerReturn:
.GLE ENDADDRESS



#====== Luigi ======
.GLE ADDRESS init__12LuigiTalkNpcFRC12JMapInfoIter +0x18C
.LuigiTalkNpcInitJumpLoc:
li r3, 0
.GLE ENDADDRESS


.GLE ADDRESS init__12LuigiTalkNpcFRC12JMapInfoIter +0x11C
bl .MR_RegisterTalkToDemo
b .LuigiTalkNpcInitJumpLoc
.GLE ENDADDRESS



#====== Rosalina ======

.GLE ADDRESS init__7RosettaFRC12JMapInfoIter +0x194
nop
mr r3, r27
mr r4, r28
bl .MR_RegisterTalkToDemo
.GLE ENDADDRESS


#===== Toad =====
.GLE ADDRESS init__7KinopioFRC12JMapInfoIter +0x394
bl .MR_RegisterTalkToDemo
.GLE ENDADDRESS


#===== Bank Toad =====
.GLE ADDRESS init__11KinopioBankFRC12JMapInfoIter +0x260
mr        r3, r29
mr        r4, r30
bl .MR_RegisterTalkToDemo
b .BankToadJumpPos
.GLE ENDADDRESS

.GLE ADDRESS init__11KinopioBankFRC12JMapInfoIter +0x2EC
.BankToadJumpPos:
.GLE ENDADDRESS


#===== Peach ======

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

#===== Pianta =====
#As funny as it is, T-posing during hubworld events *is a bug* and needs to somehow be fixed...

#==================

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


#DEBUG
#.DEBUG:
#mr r14, r3
#lwzx      r12, r3, r12
#b .DEBUGRETURN
#
#.GLE ADDRESS 0x8062E02C
#b .DEBUG
#.DEBUGRETURN:
.GLE ASSERT makeActorDead__23MarioFacePlanetPreviousFv
.GLE ENDADDRESS
#============================
.GLE ASSERT __sinit_\MarioFacePlanetPrevious_cpp
.GLE ENDADDRESS
