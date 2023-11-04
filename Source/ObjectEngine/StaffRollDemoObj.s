#Replaces the vanilla staff roll with a new one
#one that isn't hardcoded...

#Renaming the nerve addresses
.GLE ADDRESS unk_807D1E78
.GLE TRASH BEGIN

.StaffRollDemoObj_NrvWaitForAppear_sInstance:
.int 0
.StaffRollDemoObj_NrvAppear_sInstance:
.int 0
.StaffRollDemoObj_NrvRun_sInstance:
.int 0
.StaffRollDemoObj_NrvRights_sInstance:
.int 0
.StaffRollDemoObj_NrvEnd_sInstance:
.int 0

.GLE TRASH END
.GLE ENDADDRESS



.GLE ADDRESS init__16StaffRollDemoObjFRC12JMapInfoIter
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
stw       r30, 0x08(r1)

mr        r31, r4
mr        r30, r3
bl initDefaultPos__2MRFP9LiveActorRC12JMapInfoIter

mr        r3, r30
bl        connectToSceneMapObjMovement__2MRFP7NameObj

mr        r3, r30
bl        invalidateClipping__2MRFP9LiveActor

mr        r3, r30
addi      r4, r13, .StaffRollDemoObj_NrvWaitForAppear_sInstance - STATIC_R13
li        r5, 0
bl initNerve__9LiveActorFPC5Nervel

mr r3, r30
mr r4, r31
bl useStageSwitchReadAppear__2MRFP9LiveActorRC12JMapInfoIter

mr r3, r30
mr r4, r31
bl needStageSwitchWriteDead__2MRFP9LiveActorRC12JMapInfoIter

mr r3, r30
mr r4, r31
bl useStageSwitchReadB__2MRFP9LiveActorRC12JMapInfoIter

li        r3, 0x100
bl        __nw__FUl
cmpwi     r3, 0
beq       loc_80144830
bl        __ct__9StaffRollFv

loc_80144830:
stw       r3, 0x90(r30)
bl        initWithoutIter__7NameObjFv

mr r3, r31
lwz r4, 0x90(r30)
addi r4, r4, 0xE8
li r5, 528  #default delay
stw r5, 0x00(r4)
bl getJMapInfoArg0NoInit__2MRFRC12JMapInfoIterPl

mr r3, r31
lwz r4, 0x90(r30)
addi r4, r4, 0xEC
li r5, 729  #default delay
stw r5, 0x00(r4)
bl getJMapInfoArg1NoInit__2MRFRC12JMapInfoIterPl

lwz       r5, 0x90(r30)
lwz       r0, 0xBC(r30)
stw       r0, 0xE4(r5)

mr        r3, r30
lwz       r12, 0(r3)
lwz       r12, 0x30(r12)
mtctr     r12
bctrl  #MakeActorAppeared

lwz       r0, 0x14(r1)
lwz       r31, 0x0C(r1)
lwz       r30, 0x08(r1)
mtlr      r0
addi      r1, r1, 0x10
blr

#=========================================================

.GLE ADDRESS sub_801452F0 +0x04
b .StaffRollDemoObj_NrvWaitForAppear
.GLE ENDADDRESS

.StaffRollDemoObj_NrvWaitForAppear:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
mr        r31, r3

bl isOnSwitchAppear__2MRFPC9LiveActor
cmpwi r3, 0
beq .StaffRollDemoObj_NrvWaitForAppear_Return

mr        r3, r31
addi      r4, r13, .StaffRollDemoObj_NrvAppear_sInstance - STATIC_R13
bl setNerve__9LiveActorFPC5Nerve

.StaffRollDemoObj_NrvWaitForAppear_Return:
lwz       r0, 0x14(r1)
lwz       r31, 0x0C(r1)
mtlr      r0
addi      r1, r1, 0x10
blr


.GLE ADDRESS sub_801452E0 +0x04
b .StaffRollDemoObj_NrvAppear
.GLE ENDADDRESS

.StaffRollDemoObj_NrvAppear:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
mr        r31, r3

#Spawn the layout
lwz       r3, 0x90(r31)
lwz       r12, 0(r3)
lwz       r12, 0x2C(r12)
mtctr     r12
bctrl

mr        r3, r31
addi      r4, r13, .StaffRollDemoObj_NrvRun_sInstance - STATIC_R13
bl setNerve__9LiveActorFPC5Nerve

mr        r3, r31
bl startStarPointerModeEnding__2MRFPv

lwz       r0, 0x14(r1)
lwz       r31, 0x0C(r1)
mtlr      r0
addi      r1, r1, 0x10
blr


.GLE ADDRESS sub_801452D0 +0x04
b .StaffRollDemoObj_NrvRun
.GLE ENDADDRESS

.StaffRollDemoObj_NrvRun:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
mr        r31, r3

bl isValidSwitchB__2MRFPC9LiveActor
cmpwi r3, 0
beq .StaffRollDemoObj_NrvRun_Off_SwitchB

mr r3, r31
bl isOnSwitchB__2MRFPC9LiveActor
cmpwi r3, 0
beq .StaffRollDemoObj_NrvRun_Off_SwitchB

lwz r3, 0x94(r31)
cmpwi r3, 0
bne .StaffRollDemoObj_ForceMovementOff

lwz       r3, 0x90(r31)
bl isAtPageFlip__9StaffRollFv
cmpwi r3, 0
beq .StaffRollDemoObj_NrvRun_Return

.StaffRollDemoObj_ForceMovementOff:
lwz       r3, 0x90(r31)
bl requestMovementOff__2MRFP11LayoutActor
li r3, 1
stw r3, 0x94(r31)
b .StaffRollDemoObj_NrvRun_Return


.StaffRollDemoObj_NrvRun_Off_SwitchB:
lwz       r3, 0x90(r31)
bl requestMovementOn__2MRFP11LayoutActor
li r3, 0
stw r3, 0x94(r31)

.StaffRollDemoObj_NrvRun_Return:
bl deactivateDefaultGameLayout__2MRFv

lwz       r3, 0x90(r31)
addi r4, r13, unk_807D5834 - STATIC_R13
bl isNerve__11LayoutActorCFPC5Nerve
cmpwi r3, 0
beq .StaffRollDemoObj_NrvRun_Return_Real

mr        r3, r31
addi      r4, r13, .StaffRollDemoObj_NrvRights_sInstance - STATIC_R13
bl setNerve__9LiveActorFPC5Nerve

lwz       r3, 0x90(r31)
bl requestMovementOn__2MRFP11LayoutActor
li r3, 0
stw r3, 0x94(r31)

.StaffRollDemoObj_NrvRun_Return_Real:
lwz       r0, 0x14(r1)
lwz       r31, 0x0C(r1)
mtlr      r0
addi      r1, r1, 0x10
blr


.GLE ADDRESS sub_801452C0 +0x04
b .StaffRollDemoObj_NrvRights
.GLE ENDADDRESS

.StaffRollDemoObj_NrvRights:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
mr        r31, r3

li r4, 300
bl isGreaterStep__2MRFPC9LiveActorl
cmpwi r3, 0
beq .StaffRollDemoObj_NrvRights_Return

mr        r3, r31
addi      r4, r13, .StaffRollDemoObj_NrvEnd_sInstance - STATIC_R13
bl setNerve__9LiveActorFPC5Nerve

.StaffRollDemoObj_NrvRights_Return:
lwz       r0, 0x14(r1)
lwz       r31, 0x0C(r1)
mtlr      r0
addi      r1, r1, 0x10
blr


.GLE ADDRESS sub_80145270
lwz       r3, 0(r4)
b .StaffRollDemoObj_NrvEnd
.GLE ENDADDRESS

.StaffRollDemoObj_NrvEnd:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
mr        r31, r3

li r4, 360
bl isGreaterStep__2MRFPC9LiveActorl
cmpwi r3, 0
beq .StaffRollDemoObj_NrvEnd_Return

mr r3, r31
bl isValidSwitchDead__2MRFPC9LiveActor
cmpwi r3, 0
beq .StaffRollDemoObj_NrvEnd_Return

mr r3, r31
bl onSwitchDead__2MRFP9LiveActor

.StaffRollDemoObj_NrvEnd_Return:
mr r3, r31
lwz       r12, 0(r3)
lwz       r12, 0x38(r12)
mtctr     r12
bctrl  #Kill?

lwz       r0, 0x14(r1)
lwz       r31, 0x0C(r1)
mtlr      r0
addi      r1, r1, 0x10
blr
.GLE ENDADDRESS

.GLE ADDRESS sub_80492BF0
#just gonna replace this...
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0xC(r1)
mr        r31, r3

li r4, 120
bl isGreaterStep__2MRFPC11LayoutActorl
cmpwi r3, 0
beq .sub_80492BF0_Return

mr        r3, r31
addi      r4, r13, unk_807D5858 - STATIC_R13
bl        setNerve__11LayoutActorCFPC5Nerve

.sub_80492BF0_Return:
lwz       r0, 0x14(r1)
lwz       r31, 0xC(r1)
mtlr      r0
addi      r1, r1, 0x10
blr
.GLE ENDADDRESS

.GLE ADDRESS sub_80492C40
#just gonna replace this too...
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0xC(r1)
mr        r31, r3

li r4, 180  #The amount of time between the last credit and "The End"
bl isGreaterStep__2MRFPC11LayoutActorl
cmpwi r3, 0
beq .sub_80492C40_Return

mr        r3, r31
addi      r4, r13, unk_807D585C - STATIC_R13
bl        setNerve__11LayoutActorCFPC5Nerve

.sub_80492C40_Return:
lwz       r0, 0x14(r1)
lwz       r31, 0xC(r1)
mtlr      r0
addi      r1, r1, 0x10
blr
.GLE ENDADDRESS

.GLE ADDRESS sub_80492CB0
#also just gonna replace this...
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0xC(r1)
mr        r31, r3

li r4, 120
bl isGreaterStep__2MRFPC11LayoutActorl
cmpwi r3, 0
beq .sub_80492CB0_Return

mr        r3, r31
addi      r4, r13, unk_807D5834 - STATIC_R13
bl        setNerve__11LayoutActorCFPC5Nerve

.sub_80492CB0_Return:
lwz       r0, 0x14(r1)
lwz       r31, 0xC(r1)
mtlr      r0
addi      r1, r1, 0x10
blr
.GLE ENDADDRESS

.GLE ADDRESS sub_80492B20 +0x28
#lwz r4, 0xE8(r31)
.GLE ENDADDRESS

.GLE ADDRESS sub_80492970 +0x3C
#lwz r29, 0xEC(r28)
.GLE ENDADDRESS

.GLE ADDRESS .SCENARIO_SWITCH_CONNECTOR
nop
.STAFFROLL_CONNECTOR:
.GLE ENDADDRESS