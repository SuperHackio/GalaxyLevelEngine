#Additions to the Launch Star to allow the empty model to be used regularily

.GLE ADDRESS requestHide__15SuperSpinDriverFv +0x34
mr        r3, r31
addi      r4, r13, sInstance__Q218NrvSuperSpinDriver32SuperSpinDriverNrvEmptyNonActive - STATIC_R13
bl        setNerve__9LiveActorFPC5Nerve
mr        r3, r31
bl .SuperSpinDriver_Off
.GLE ENDADDRESS

.GLE ADDRESS init__15SuperSpinDriverFRC12JMapInfoIter +0x1B0
bl .SuperSpinDriver_InitEmptyModel_New
.GLE ENDADDRESS

.GLE ADDRESS initEmptyModel__15SuperSpinDriverFv -0x04
.SuperSpinDriver_InitEmptyModel_New:
mr r3, r29
.GLE ENDADDRESS

.GLE ADDRESS initEmptyModel__15SuperSpinDriverFv +0x28
nop   #We don't care if we don't need the empty model or not because we'll always load it
.GLE ENDADDRESS

.GLE ADDRESS exeEmptyNonActive__15SuperSpinDriverFv +0x2C
lis r4, EndGlow@ha
addi r4, r4, EndGlow@l
bl deleteEffect__2MRFP9LiveActorPCc
b .SuperSpinDriver_CalcAnim
.SuperSpinDriver_CalcAnimReturn:
.GLE ENDADDRESS


.GLE ADDRESS requestShow__15SuperSpinDriverFv +0x1C
bne .requestShow_Return
mr        r3, r31
bl onUse__15SuperSpinDriverFv
mr        r3, r31
addi      r4, r13, sInstance__Q218NrvSuperSpinDriver22SuperSpinDriverNrvWait - STATIC_R13
b .SuperSpinDriver_Emit
.SuperSpinDriver_EmitReturn:
.GLE ENDADDRESS

.GLE ADDRESS requestShow__15SuperSpinDriverFv +0x34
.requestShow_Return:
.GLE ENDADDRESS


.GLE ADDRESS .STAFFROLL_CONNECTOR

.SuperSpinDriver_Off:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0xC(r1)
mr        r31, r3
lwz       r3, 0xA0(r3)
cmpwi     r3, 0
beq       .loc_80248808
lwz       r12, 0(r3)
lwz       r12, 0x2C(r12)
mtctr     r12
bctrl

.loc_80248808:
mr        r3, r31
bl        hideModelAndOnCalcAnim__2MRFP9LiveActor
lwz       r0, 0x14(r1)
lwz       r31, 0xC(r1)
mtlr      r0
addi      r1, r1, 0x10
blr


.SuperSpinDriver_Emit:
bl      setNerve__9LiveActorFPC5Nerve
mr r3, r31
lis r4, EndGlow@ha
addi r4, r4, EndGlow@l
bl emitEffect__2MRFP9LiveActorPCc

bl isTimeKeepDemoActive__2MRFv
cmpwi r3, 0
beq .SuperSpinDriver_SkipAppear
mr        r3, r31
addi      r4, r13, sInstance__Q218NrvSuperSpinDriver24SuperSpinDriverNrvAppear - STATIC_R13
bl        setNerve__9LiveActorFPC5Nerve
.SuperSpinDriver_SkipAppear:
b .SuperSpinDriver_EmitReturn

.SuperSpinDriver_CalcAnim:
lfs       f1, 0x178(r31)
lfs       f2, VeryCloseToZero - STATIC_R2(r2)
bl isNearZero__2MRFff
cmpwi r3, 0
beq .SuperSpinDriver_CalcReturn
mr        r3, r31
bl offCalcAnim__2MRFP9LiveActor

.SuperSpinDriver_CalcReturn:
b .SuperSpinDriver_CalcAnimReturn

.SUPER_SPIN_DRIVER_CONNECTOR:
.GLE ENDADDRESS

.GLE ADDRESS init__15SuperSpinDriverFRC12JMapInfoIter +0xD8
#Remove the panic animation
li r3, 0
.GLE ENDADDRESS