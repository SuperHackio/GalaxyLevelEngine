.GLE IGNORE
#2023-02-14
#Goodbye Mini Comet
#You served your time in GLE-V2, but unfortunately you were part of the worldmap code. And I have overwritten you now.
#top 10 anime deaths




#Lovely comet that was previously used in SMG2's world maps
#A bit finiky to work with, but it's good enough for the GLE Template hack
#Replaces ItemRoomDoor because that object is broken now anyways I think

.GLE ADDRESS .MAME_MUIMUI_ATTACK_MAN_CONNECTOR

.RegisterForDemo:
stwu      r1, -0x20(r1)
mflr      r0
li        r6, 0
stw       r0, 0x24(r1)
stw       r31, 0x1C(r1)
stw       r30, 0x18(r1)
mr        r31, r3
mr        r30, r4

lis       r5, MiniComet@ha
addi      r5, r5, MiniComet@l
bl processInitFunction__2MRFP9LiveActorRC12JMapInfoIterPCcb
mr        r3, r31
addi      r4, r13, MiniCometWaitNerve - STATIC_R13
li        r5, 0
bl        initNerve__9LiveActorFPC5Nervel
mr        r3, r31
bl        invalidateClipping__2MRFP9LiveActor
mr        r3, r31
mr r4, r30
bl tryRegisterDemoCast__2MRFP9LiveActorRC12JMapInfoIter
lwz       r12, 0(r31)
mr        r3, r31
lwz       r12, 0x30(r12)
mtctr     r12
#bctrl                   #MakeActorAppeared
lwz       r0, 0x24(r1)
lwz       r31, 0x1C(r1)
lwz       r30, 0x18(r1)
mtlr      r0
addi      r1, r1, 0x20
blr

.MINI_COMET_CONNECTOR:
.GLE ENDADDRESS

.GLE ADDRESS cCreateTable__14NameObjFactory +0x1570
.int MiniComet
.GLE ENDADDRESS

.GLE ADDRESS createNameObj<12ItemRoomDoor>__14NameObjFactoryFPCc_P7NameObj +0x28
bl __ct__13WorldMapCometFPCc
.GLE ENDADDRESS

.GLE ADDRESS init__13WorldMapCometFRC12JMapInfoIter
b .RegisterForDemo
.GLE ENDADDRESS

.GLE ADDRESS sub_804E31A0
.MINI_COMET_STATIC_INIT:
.GLE ENDADDRESS