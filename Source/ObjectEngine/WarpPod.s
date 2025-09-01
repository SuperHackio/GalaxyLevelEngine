# New updates to WarpPod in GLE
# Allows them to be used for hubworld progression once again
# Of maybe you just like the light trails. I'm not here to judge.

.GLE ADDRESS .TOGEPIN_ATTACK_MAN_CONNECTOR

# First, we need to restore WarpPodMgr::draw(const(void))
# Function is still in the game, but half of it is stripped out, so I just replace it entirely
.WarpPodMgr_draw:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
stw       r30, 0x08(r1)


li        r31, 0
mr        r30, r3
b         loc_80250EFC

loc_80250EE8:
mr        r4, r31
bl        getActor__14LiveActorGroupCFi
lwz       r4, mDrawTimer__2MR - STATIC_R13(r13)
bl        .WarpPod_drawCylinder
addi      r31, r31, 1

loc_80250EFC:
lwz       r3, 0x18(r30)
lwz       r0, 0x18(r3)
cmplw     r31, r0
blt       loc_80250EE8


# This was the only part leftover in vanilla SMG2. How sad.
lwz       r3, mDrawTimer__2MR - STATIC_R13(r13)
addi      r0, r3, 1
stw       r0, mDrawTimer__2MR - STATIC_R13(r13)


lwz       r31, 0x0C(r1)
lwz       r30, 0x08(r1)
lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr

.GLE ADDRESS draw__10WarpPodMgrCFv
b .WarpPodMgr_draw
.GLE ENDADDRESS


# WarpPod::drawCylinder(const(ulong)) is also missing from SMG2
# Gotta add that as well
.WarpPod_drawCylinder:
stwu      r1, -0x200(r1)
mflr      r0
stw       r0, 0x204(r1)
stfd      f31, 0x1F0(r1)
psq_st    f31, 0x1F8(r1), 0, 0
stfd      f30, 0x1E0(r1)
psq_st    f30, 0x1E8(r1), 0, 0
stfd      f29, 0x1D0(r1)
psq_st    f29, 0x1D8(r1), 0, 0
stfd      f28, 0x1C0(r1)
psq_st    f28, 0x1C8(r1), 0, 0
stfd      f27, 0x1B0(r1)
psq_st    f27, 0x1B8(r1), 0, 0
addi      r11, r1, 0x1B0
bl        _savegpr_26
lbz       r0, 0xCE(r3)
lis       r4, 0x4330
stw       r4, 0x188(r1)
mr        r30, r3
cmpwi     r0, 0
stw       r4, 0x190(r1)

lis r4, .WarpPod_30_0f@ha
lfs f31, .WarpPod_30_0f@l(r4)

beq       loc_80252324
lwz       r4, 0xD4(r3)
lbz       r0, 0xCF(r4)
cmpwi     r0, 0
bne       loc_80252324
lbz       r0, 0xCF(r3)
cmpwi     r0, 0
bne       loc_80252324
lwz       r0, 0xAC(r3)
cmpwi     r0, 1
bne       loc_80252324
li        r3, 0
li        r4, 1
li        r5, 0
bl        setup__6TDDrawFUlUlUc
li        r3, 1         # compare_enable
li        r4, 3         # func
li        r5, 0         # update_enable
bl        GXSetZMode
li        r3, 2
bl        ddSetVtxFormat__2MRFUl
bl        ddLightingOff__2MRFv
li        r3, 0         # stage
li        r4, 2         # a
li        r5, 0xC       # b
li        r6, 9         # c
li        r7, 0xF       # d
bl        GXSetTevColorIn
li        r3, 0         # stage
li        r4, 0         # op
li        r5, 0         # bias
li        r6, 0         # scale
li        r7, 1         # clamp
li        r8, 0         # out_reg
bl        GXSetTevColorOp
li        r3, 0         # stage
li        r4, 7         # a
li        r5, 4         # b
li        r6, 6         # c
li        r7, 7         # d
bl        GXSetTevAlphaIn
li        r3, 0         # stage
li        r4, 0         # op
li        r5, 0         # bias
li        r6, 1         # scale
li        r7, 1         # clamp
li        r8, 0         # out_reg
bl        GXSetTevAlphaOp
# TODO: Replace this with the ability to put any colour in
lwz       r0, 0xC4(r30)
lis       r5, WarpPod_ColorTable@ha
addi      r5, r5, WarpPod_ColorTable@l
addi      r4, r1, 8     # color
slwi      r0, r0, 2
li        r3, 1         # id
add       r8, r5, r0
lbzx      r7, r5, r0
lbz       r6, 1(r8)
lbz       r5, 2(r8)
lbz       r0, 3(r8)
stb       r7, 8(r1)
stb       r6, 9(r1)
stb       r5, 0xA(r1)
stb       r0, 0xB(r1)
bl        GXSetTevColor
li        r3, 1         # type
li        r4, 4         # src_factor
li        r5, 1         # dst_factor
li        r6, 5         # op
bl        GXSetBlendMode
lwz       r3, 0xD8(r30) # _DWORD
li        r4, 0         # _GXTexMapID
bl        load__10JUTTextureF11_GXTexMapID
lwz       r3, 0xDC(r30) # _DWORD
li        r4, 1         # _GXTexMapID
bl        load__10JUTTextureF11_GXTexMapID
lhz       r0, 0xAA(r30)
lhz       r31, 0xCC(r30)
cmpwi     r0, 0
lwz       r6, 0xC0(r30)
bne       loc_80251F1C
lwz       r3, 0xD4(r30)
lhz       r0, 0xAA(r3)
lwz       r6, 0xC0(r3)

loc_80251F1C:
cmpwi     r0, 0
beq       loc_80251F78
stw       r31, 0x18C(r1)
xoris     r3, r0, 0x8000
lis       r5, .WarpPod_DoubleA@ha
lis       r4, .WarpPod_DoubleB@ha
lfd       f0, 0x188(r1)
xoris     r0, r6, 0x8000
lfd       f1, .WarpPod_DoubleA@l(r5)
stw       r3, 0x194(r1)
fsubs     f4, f0, f1
lfd       f3, .WarpPod_DoubleB@l(r4)
stw       r0, 0x18C(r1)
lfd       f0, 0x190(r1)
lfd       f1, 0x188(r1)
fsubs     f2, f0, f3
lis r3, .WarpPod_1_0f@ha
lfs       f0, .WarpPod_1_0f@l(r3)
fsubs     f1, f1, f3
fdivs     f1, f2, f1
fsubs     f0, f0, f1
fmuls     f1, f4, f0
bl        __cvt_fp2unsigned
mr        r31, r3

loc_80251F78:
lis       r3, .WarpPod_DoubleA@ha
lfd       f27, .WarpPod_DoubleA@l(r3)

lis r3, .WarpPod_2_0f@ha
lfs       f28, .WarpPod_2_0f@l(r3)

li        r27, 0

lis r3, .WarpPod_1_0f@ha
lfs       f29, .WarpPod_1_0f@l(r3)

li        r29, 0

lis r3, .WarpPod_0_0f@ha
lfs       f30, .WarpPod_0_0f@l(r3)

b         loc_8025231C

loc_80251F98:
cmpwi     r27, 0
bne       loc_802520F4
li        r26, 1
li        r28, 0xC
b         loc_802520C4

loc_80251FAC:
lwz       r0, 0xC8(r30)
addi      r3, r1, 0xF0
add       r4, r0, r28
add       r5, r0, r29
bl        __mi__Q29JGeometry8TVec3<f>CFRCQ29JGeometry8TVec3<f>
addi      r3, r1, 0x90  # retstr
bl        getCamZdir__2MRFv
addi      r3, r1, 0xF0  # a1
addi      r4, r1, 0x90  # a2
addi      r5, r1, 0xE4  # a3
bl        vecKillElement__2MRFRCQ29JGeometry8TVec3<f>RCQ29JGeometry8TVec3<f>PQ29JGeometry8TVec3<f>
addi      r3, r1, 0xE4  # _DWORD
bl        normalizeOrZero__2MRFPQ29JGeometry8TVec3<f>
cmpwi     r3, 0
bne       loc_802520BC
addi      r3, r1, 0x84  # retstr
bl        getCamZdir__2MRFv
addi      r3, r1, 0xE4
addi      r4, r1, 0x84
addi      r5, r1, 0xD8 
bl        PSVECCrossProduct
addi      r3, r1, 0xD8  # _DWORD
bl        normalizeOrZero__2MRFPQ29JGeometry8TVec3<f>
addi      r3, r1, 0xD8 
addi      r4, r1, 0xE4
addi      r5, r1, 0xCC 
bl        PSVECCrossProduct
addi      r3, r1, 0xCC  # _DWORD
bl        normalizeOrZero__2MRFPQ29JGeometry8TVec3<f>
fmr       f1, f31
addi      r3, r1, 0xD8 
bl        setLength__Q29JGeometry8TVec3<f>Ff
fmr       f1, f31
addi      r3, r1, 0xCC 
bl        setLength__Q29JGeometry8TVec3<f>Ff
lwz       r0, 0xC8(r30)
addi      r3, r1, 0x78 
addi      r5, r1, 0xD8 
add       r4, r0, r29
bl        __pl__Q29JGeometry8TVec3<f>CFRCQ29JGeometry8TVec3<f>
addi      r3, r1, 0x158
addi      r4, r1, 0x78 
bl        __as__Q29JGeometry8TVec3<f>FRCQ29JGeometry8TVec3<f>
lwz       r0, 0xC8(r30)
addi      r3, r1, 0x6C 
addi      r5, r1, 0xD8 
add       r4, r0, r29
bl        __mi__Q29JGeometry8TVec3<f>CFRCQ29JGeometry8TVec3<f>
addi      r3, r1, 0x164
addi      r4, r1, 0x6C 
bl        __as__Q29JGeometry8TVec3<f>FRCQ29JGeometry8TVec3<f>
lwz       r0, 0xC8(r30)
addi      r3, r1, 0x60 
addi      r5, r1, 0xCC 
add       r4, r0, r29
bl        __pl__Q29JGeometry8TVec3<f>CFRCQ29JGeometry8TVec3<f>
addi      r3, r1, 0x170
addi      r4, r1, 0x60 
bl        __as__Q29JGeometry8TVec3<f>FRCQ29JGeometry8TVec3<f>
lwz       r0, 0xC8(r30)
addi      r3, r1, 0x54 
addi      r5, r1, 0xCC 
add       r4, r0, r29
bl        __mi__Q29JGeometry8TVec3<f>CFRCQ29JGeometry8TVec3<f>
addi      r3, r1, 0x17C
addi      r4, r1, 0x54 
bl        __as__Q29JGeometry8TVec3<f>FRCQ29JGeometry8TVec3<f>
b         loc_802520CC

loc_802520BC:
addi      r26, r26, 1
addi      r28, r28, 0xC

loc_802520C4:
cmplw     r26, r31
blt       loc_80251FAC

loc_802520CC:
cmplw     r26, r31
bge       loc_80252324
lwz       r4, 0xC8(r30)
addi      r3, r1, 0x11C
bl        __as__Q29JGeometry8TVec3<f>FRCQ29JGeometry8TVec3<f>
stfs      f30, 0xFC(r1)
stfs      f29, 0x100(r1)
stfs      f29, 0x104(r1)
stfs      f29, 0x108(r1)
b         loc_80252314

loc_802520F4:
addi      r0, r27, 1
stw       r31, 0x18C(r1)
stw       r0, 0x194(r1)
lfd       f0, 0x188(r1)
lfd       f1, 0x190(r1)
fsubs     f0, f0, f27
fsubs     f1, f1, f27
fdivs     f0, f1, f0
fmuls     f0, f28, f0
fsubs     f0, f0, f29
fcmpo     cr0, f0, f30
bge       loc_80252128
fneg      f0, f0

loc_80252128:
lwz       r0, 0xC8(r30)
addi      r3, r1, 0xC0 # 'ﾀ'
stfs      f30, 0x10C(r1)
addi      r5, r1, 0x11C
add       r4, r0, r29
stfs      f0, 0x110(r1)
stfs      f29, 0x114(r1)
stfs      f0, 0x118(r1)
bl        __mi__Q29JGeometry8TVec3<f>CFRCQ29JGeometry8TVec3<f>
addi      r3, r1, 0x48 # 'H' # retstr
bl        getCamZdir__2MRFv
addi      r3, r1, 0xC0 # 'ﾀ' # a1
addi      r4, r1, 0x48 # 'H' # a2
addi      r5, r1, 0xB4 # 'ｴ' # a3
bl        vecKillElement__2MRFRCQ29JGeometry8TVec3<f>RCQ29JGeometry8TVec3<f>PQ29JGeometry8TVec3<f>
addi      r3, r1, 0xB4 # 'ｴ' # _DWORD
bl        normalizeOrZero__2MRFPQ29JGeometry8TVec3<f>
cmpwi     r3, 0
bne       loc_80252314
addi      r3, r1, 0x3C # '<' # retstr
bl        getCamZdir__2MRFv
addi      r3, r1, 0xB4 # 'ｴ'
addi      r4, r1, 0x3C # '<'
addi      r5, r1, 0xA8 # 'ｨ'
bl        PSVECCrossProduct
addi      r3, r1, 0xA8 # 'ｨ' # _DWORD
bl        normalizeOrZero__2MRFPQ29JGeometry8TVec3<f>
addi      r3, r1, 0xA8 # 'ｨ'
addi      r4, r1, 0xB4 # 'ｴ'
addi      r5, r1, 0x9C
bl        PSVECCrossProduct
addi      r3, r1, 0x9C  # _DWORD
bl        normalizeOrZero__2MRFPQ29JGeometry8TVec3<f>
fmr       f1, f31
addi      r3, r1, 0xA8 # 'ｨ'
bl        setLength__Q29JGeometry8TVec3<f>Ff
fmr       f1, f31
addi      r3, r1, 0x9C
bl        setLength__Q29JGeometry8TVec3<f>Ff
lwz       r0, 0xC8(r30)
addi      r3, r1, 0x30 # '0'
addi      r5, r1, 0xA8 # 'ｨ'
add       r4, r0, r29
bl        __pl__Q29JGeometry8TVec3<f>CFRCQ29JGeometry8TVec3<f>
addi      r3, r1, 0x128
addi      r4, r1, 0x30 # '0'
bl        __as__Q29JGeometry8TVec3<f>FRCQ29JGeometry8TVec3<f>
lwz       r0, 0xC8(r30)
addi      r3, r1, 0x24 # '$'
addi      r5, r1, 0xA8 # 'ｨ'
add       r4, r0, r29
bl        __mi__Q29JGeometry8TVec3<f>CFRCQ29JGeometry8TVec3<f>
addi      r3, r1, 0x134
addi      r4, r1, 0x24 # '$'
bl        __as__Q29JGeometry8TVec3<f>FRCQ29JGeometry8TVec3<f>
lwz       r0, 0xC8(r30)
addi      r3, r1, 0x18
addi      r5, r1, 0x9C
add       r4, r0, r29
bl        __pl__Q29JGeometry8TVec3<f>CFRCQ29JGeometry8TVec3<f>
addi      r3, r1, 0x140
addi      r4, r1, 0x18
bl        __as__Q29JGeometry8TVec3<f>FRCQ29JGeometry8TVec3<f>
lwz       r0, 0xC8(r30)
addi      r3, r1, 0xC
addi      r5, r1, 0x9C
add       r4, r0, r29
bl        __mi__Q29JGeometry8TVec3<f>CFRCQ29JGeometry8TVec3<f>
addi      r3, r1, 0x14C
addi      r4, r1, 0xC
bl        __as__Q29JGeometry8TVec3<f>FRCQ29JGeometry8TVec3<f>
li        r3, 0x80      # type
li        r4, 0         # vtxfmt
li        r5, 8         # nverts
bl        GXBegin
addi      r3, r1, 0x158
addi      r4, r1, 0xFC
bl        ddSendVtxData__2MRFRCQ29JGeometry8TVec3<f>RCQ29JGeometry8TVec2<f>
addi      r3, r1, 0x128
addi      r4, r1, 0x10C
bl        ddSendVtxData__2MRFRCQ29JGeometry8TVec3<f>RCQ29JGeometry8TVec2<f>
addi      r3, r1, 0x134
addi      r4, r1, 0x114
bl        ddSendVtxData__2MRFRCQ29JGeometry8TVec3<f>RCQ29JGeometry8TVec2<f>
addi      r3, r1, 0x164
addi      r4, r1, 0x104
bl        ddSendVtxData__2MRFRCQ29JGeometry8TVec3<f>RCQ29JGeometry8TVec2<f>
addi      r3, r1, 0x170
addi      r4, r1, 0xFC
bl        ddSendVtxData__2MRFRCQ29JGeometry8TVec3<f>RCQ29JGeometry8TVec2<f>
addi      r3, r1, 0x140
addi      r4, r1, 0x10C
bl        ddSendVtxData__2MRFRCQ29JGeometry8TVec3<f>RCQ29JGeometry8TVec2<f>
addi      r3, r1, 0x14C
addi      r4, r1, 0x114
bl        ddSendVtxData__2MRFRCQ29JGeometry8TVec3<f>RCQ29JGeometry8TVec2<f>
addi      r3, r1, 0x17C
addi      r4, r1, 0x104
bl        ddSendVtxData__2MRFRCQ29JGeometry8TVec3<f>RCQ29JGeometry8TVec2<f>
addi      r3, r1, 0x158
addi      r4, r1, 0x128
bl        __as__Q29JGeometry8TVec3<f>FRCQ29JGeometry8TVec3<f>
lfs       f1, 0x10C(r1)
addi      r3, r1, 0x164
lfs       f0, 0x110(r1)
addi      r4, r1, 0x134
stfs      f1, 0xFC(r1)
stfs      f0, 0x100(r1)
bl        __as__Q29JGeometry8TVec3<f>FRCQ29JGeometry8TVec3<f>
lfs       f1, 0x114(r1)
addi      r3, r1, 0x170
lfs       f0, 0x118(r1)
addi      r4, r1, 0x140
stfs      f1, 0x104(r1)
stfs      f0, 0x108(r1)
bl        __as__Q29JGeometry8TVec3<f>FRCQ29JGeometry8TVec3<f>
addi      r3, r1, 0x17C
addi      r4, r1, 0x14C
bl        __as__Q29JGeometry8TVec3<f>FRCQ29JGeometry8TVec3<f>
lwz       r0, 0xC8(r30)
addi      r3, r1, 0x11C
add       r4, r0, r29
bl        __as__Q29JGeometry8TVec3<f>FRCQ29JGeometry8TVec3<f>

loc_80252314:

addi      r27, r27, 1
addi      r29, r29, 0xC

loc_8025231C:
cmplw     r27, r31
blt       loc_80251F98

loc_80252324:
psq_l     f31, 0x1F8(r1), 0, 0
lfd       f31, 0x1F0(r1)
psq_l     f30, 0x1E8(r1), 0, 0
lfd       f30, 0x1E0(r1)
psq_l     f29, 0x1D8(r1), 0, 0
lfd       f29, 0x1D0(r1)
psq_l     f28, 0x1C8(r1), 0, 0
lfd       f28, 0x1C0(r1)
psq_l     f27, 0x1B8(r1), 0, 0
addi      r11, r1, 0x1B0
lfd       f27, 0x1B0(r1)
bl        _restgpr_26
lwz       r0, 0x204(r1)
mtlr      r0
addi      r1, r1, 0x200
blr




# Because GLE doesn't have a concept of "Grand Star Order"
# We instead will use a JMapProgress check inside ScenarioSwitch.
# Recycling :100:
.WarpPod_Init_ExA:
li r28, 0
lwz r0, 0xB0(r29) # ObjArg2. Conviniently, read by the vanilla game, just never used for anything.
cmpwi r0, 0
beq .WarpPod_Init_ExA_Return
lwz r4, 0xBC(r29) # ObjArg4. Used to be "Required Grand Stars" in SMG1. Now it indexes ScenarioSwitch.bcsv
cmpwi r4, -2 # If set to -2, make it think it's always passed the condition. Shortcut to always having the light enabled.
beq .WarpPod_Init_ExA_SetTrue
cmpwi r4, -1
beq .WarpPod_Init_ExA_Return
lis r3, .WarpPod_str_ScenarioSwitch@ha
addi r3, r3, .WarpPod_str_ScenarioSwitch@l
crclr     4*cr1+eq
bl tryLoadCsvFromZoneInfo__2MRFPCc
cmpwi r3, 0  # No BCSV? Skip all this then.
beq .WarpPod_Init_ExA_Return
lwz r4, 0xBC(r29)
bl isJMapEntryProgressComplete
cmpwi r3, 0
bne .WarpPod_Init_ExA_Return

.WarpPod_Init_ExA_SetTrue:
li r28, 1
.WarpPod_Init_ExA_Return:
b .WarpPod_Init_ExA_JumpLoc


.GLE ADDRESS init__7WarpPodFRC12JMapInfoIter +0x2E8
b .WarpPod_Init_ExA
li        r28, 0    # Is this needed??
.WarpPod_Init_ExA_JumpLoc:
.GLE ENDADDRESS



# Validate if the Glow should be enabled or not
.WarpPod_Init_ExB:
cmpwi r28, 0
beq .WarpPod_Init_ExB_ReturnGlow
b .WarpPod_Init_ExB_JumpLoc
.WarpPod_Init_ExB_ReturnGlow:
mr r3, r29
b .WarpPod_Init_ExB_JumpGlow

.GLE ADDRESS init__7WarpPodFRC12JMapInfoIter +0x314
b .WarpPod_Init_ExB
.WarpPod_Init_ExB_JumpGlow:
.GLE ENDADDRESS

.GLE ADDRESS init__7WarpPodFRC12JMapInfoIter +0x31C
.WarpPod_Init_ExB_JumpLoc:
.GLE ENDADDRESS



# Used when the Warp Pods are the ones that you can unlock by stepping on them
.WarpPod_Init_ExC:
lwz r4, 0xBC(r29)
cmpwi r4, -1
beq .WarpPod_Init_ExB_Return
mr r3, r29
bl .GLE_getWarpPodFromStorage
cmpwi r3, 0
beq .WarpPod_Init_ExB_True
li r28, 0
b .WarpPod_Init_ExB_Return

.WarpPod_Init_ExB_True:
li r28, 1

.WarpPod_Init_ExB_Return:
# Intentional re-use of this address
b .WarpPod_Init_ExB_JumpLoc

.GLE ADDRESS init__7WarpPodFRC12JMapInfoIter +0x310
b .WarpPod_Init_ExC
.GLE ENDADDRESS



# Restores the ability to have the appearance demo work
.WarpPod_AppearWithDemo_Ex:
lwz r3, 0xB0(r31)
cmpwi r3, 0
bne .WarpPod_AppearWithDemo_Ex_Return
lwz r3, 0xBC(r31)
cmpwi r3, -1
beq .WarpPod_AppearWithDemo_Ex_Return
mr r3, r31
bl .GLE_setWarpPodFromStorage

.WarpPod_AppearWithDemo_Ex_Return:
li r0, 0
b .WarpPod_AppearWithDemo_Ex_JumpLoc

.GLE ADDRESS appearWithDemo__7WarpPodFv +0x44
b .WarpPod_AppearWithDemo_Ex
.WarpPod_AppearWithDemo_Ex_JumpLoc:
.GLE ENDADDRESS


# Save data stuff

#r3 = TicoFatStarPiece*
.GLE_getWarpPodFromStorage:
stwu      r1, -0x150(r1)
mflr      r0
stw       r0, 0x154(r1)
addi      r11, r1, 0x150
bl _savegpr_29

mr r31, r3

bl .GLE_GetCurrentStageName_Guarantee
mr r5, r3
lwz r6, 0xBC(r31)
addi r3, r1,0x0C
li r4, 0x110
bl .GLE_getWarpPodStorageName

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
.GLE_setWarpPodFromStorage:
li r4, 1 # We're always wanting to set it to 1... for now...

stwu      r1, -0x150(r1)
mflr      r0
stw       r0, 0x154(r1)
addi      r11, r1, 0x150
bl _savegpr_29

mr r31, r3
mr r30, r4

bl .GLE_GetCurrentStageName_Guarantee
mr r5, r3
lwz r6, 0xBC(r31)
addi r3, r1,0x0C
li r4, 0x110
bl .GLE_getWarpPodStorageName

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
.GLE_getWarpPodStorageName:
mr r7, r6
mr r6, r5
lis       r5, .WarpPod_str_SaveDataFormat@ha
addi      r5, r5, .WarpPod_str_SaveDataFormat@l
b .GLE_getTicoFatStorageName
# Recycled this for now...
# Should probably refractor the system so that there's only one instance of this that takes in the event value name format string.



# Strings
.WarpPod_str_SaveDataFormat:
.string "WarpPodSave[%s_%d]"

.WarpPod_str_ScenarioSwitch:
.string "ScenarioSwitch" AUTO


# WarpPod floats
.WarpPod_30_0f:
.float 30.0

.WarpPod_DoubleA:
.int 0x43300000
.int 0x00000000
.WarpPod_DoubleB:
.int 0x43300000
.int 0x80000000

.WarpPod_0_0f:
.float 0.0
.WarpPod_1_0f:
.float 1.0
.WarpPod_2_0f:
.float 2.0



.GLE PRINTADDRESS
.WARPPOD_CONNECTOR:
.GLE ENDADDRESS