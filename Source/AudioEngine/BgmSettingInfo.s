#This code lets users define how multi-channel streams are handled

#3 ints.
.set TrackEntrySize, 4 * 0x04
#8 bytes, 3 bytes, 1 padding byte, 1 float
.set MuteDefinitionSize, 12 * 0x01 + 1 * 0x04

.GLE ADDRESS numStreamChannels__9AudParams
# Change the max AST track num to 6
.int 6
.GLE ENDADDRESS

.GLE ADDRESS WorldmapCodeStart +0x04



.GLE ADDRESS sub_80089480
stwu      r1, -0x80(r1)
mflr      r0
stw       r0, 0x84(r1)
addi      r11, r1, 0x80
bl        _savegpr_24
.GLE ENDADDRESS

.GLE ADDRESS sub_80089480 +0x3C
b .InitBgmSettingsChannelControl
.InitBgmSettingsChannelControl_Return:
.GLE ENDADDRESS

.GLE ADDRESS sub_80089480 +0x150
addi      r11, r1, 0x80
bl        _restgpr_24
lwz       r0, 0x84(r1)
mtlr      r0
addi      r1, r1, 0x80
blr
.GLE ENDADDRESS

.InitBgmSettingsChannelControl:
mr r28, r3 #Keep this


lis r29, .TrackControl@ha
addi r29, r29, .TrackControl@l
addi r4, r29, 0
lwz       r12, 0(r3)
lwz       r12, 0x14(r12)
mtctr     r12
bctrl

#attaching to the same BCSV twice?
#Illegal but required.
mr        r4, r3
addi      r3, r1, 0x38
bl        attach__8JMapInfoFPCv

#ok so here's the plan
#we're gonna make an array and put it where "cBgmSettingInfo__13AudBgmSetting" is.

#Gonna just try to do it normally
lis r30, cBgmSettingInfo__13AudBgmSetting@ha
addi r30, r30, cBgmSettingInfo__13AudBgmSetting@l

addi      r3, r1, 0x38
bl getCsvDataElementNum__2MRFPC8JMapInfo
stw r3, 0x04(r30)  #Gotta keep the entry count
mr r31, r3
mulli r3, r3, TrackEntrySize
bl __nwa__FUl
#Not gonna bother checking for no memory here, as we DEFINITELY should have memory open to us at this point...
stw r3, 0x00(r30)
mr r30, r3  #now r30 has the array pointer

li r27, 0
b .BgmTrackLoop_Start
.BgmTrackLoop:

addi r3, r1, 0x08
addi r4, r1, 0x38
addi r5, r29, .BgmName - .TrackControl
mr r6, r27
bl getCsvDataStr__2MRFPPCcPC8JMapInfoPCcl

mr r3, r30
lwz       r4, sInstance__43AudSingletonHolder_21AudSoundNameConverter_ - STATIC_R13(r13)
lwz r5, 0x08(r1)
bl getSoundID__21AudSoundNameConverterFPiPCc

addi r3, r30, 4
addi r4, r1, 0x38
addi r5, r29, .MuteType - .TrackControl
mr r6, r27
bl getCsvDataS32__2MRFPlPC8JMapInfoPCcl

#Don't yet know if this means anything useful, but the vanilla game always has -1 soooo
li r3, -1
stw r3, 0x08(r30)

addi r3, r30, 0x0C
addi r4, r1, 0x38
addi r5, r29, .ChangeType - .TrackControl
mr r6, r27
bl getCsvDataS32__2MRFPlPC8JMapInfoPCcl

.BgmTrackLoop_Continue:
addi r27, r27, 0x01
addi r30, r30, TrackEntrySize

.BgmTrackLoop_Start:
cmpw r27, r31
blt .BgmTrackLoop


# New to GLE-V4: MuteDefine
# Lets Users control the MuteType values freely
lis r29, .MuteDefine@ha
addi r29, r29, .MuteDefine@l
addi r4, r29, 0
mr r3, r28
lwz       r12, 0(r3)
lwz       r12, 0x14(r12)
mtctr     r12
bctrl

#STILL attaching to the same BCSV twice?
#Twice as Illegal but still required.
mr        r4, r3
addi      r3, r1, 0x38
bl        attach__8JMapInfoFPCv


lis r30, cMuteSettingInfo__13AudBgmSetting@ha
addi r30, r30, cMuteSettingInfo__13AudBgmSetting@l

addi      r3, r1, 0x38
bl getCsvDataElementNum__2MRFPC8JMapInfo
stw r3, 0x04(r30)  #Gotta keep the entry count
mr r31, r3
mulli r3, r3, MuteDefinitionSize
bl __nwa__FUl
#Not gonna bother checking for no memory here, as we DEFINITELY should have memory open to us at this point...
stw r3, 0x00(r30)
mr r30, r3  #now r30 has the array pointer

li r27, 0
b .MuteDefineLoop_Start
.MuteDefineLoop:

# time to create the serialized mute definitions yaaaay...
# I'm not adding failsafes for this since it is mandatory that all fields exist
li r26, 0
li r25, 0

.MuteDefine_BMS_Loop:
addi r3, r1, 0x0C
mr r6, r26
bl ._Create_MuteSeq_Name

addi r3, r1, 0x08
addi r4, r1, 0x38
addi r5, r1, 0x0C
mr r6, r27
bl getCsvDataU8__2MRFPUcPC8JMapInfoPCcl

addi r26, r26, 1   # Since the fields need to get or'd together, we'll do two at a time

addi r3, r1, 0x0C
mr r6, r26
bl ._Create_MuteSeq_Name

addi r3, r1, 0x09
addi r4, r1, 0x38
addi r5, r1, 0x0C
mr r6, r27
bl getCsvDataU8__2MRFPUcPC8JMapInfoPCcl

# Time to get  F a n c y
lbz r3, 0x08(r1)
lbz r4, 0x09(r1)
rlwinm r3, r3, 4, 24, 27
rlwinm r4, r4, 0, 28, 31
or r3, r3, r4
stbx r3, r30, r25


addi r26, r26, 1
addi r25, r25, 1  # Next byte offset

.MuteDefine_BMS_Loop_Start:
cmpwi r26, 16
blt .MuteDefine_BMS_Loop

li r26, 0
# We're keeping the r25 at the same byte since we may as well...
.MuteDefine_AST_Loop:
addi r3, r1, 0x0C
mr r6, r26
bl ._Create_MuteStm_Name

addi r3, r1, 0x38
addi r4, r1, 0x0C
bl isExistItemInfo__8JMapInfoFPCc
cmpwi r3, 0
beq .MuteDefine_AST_Loop_Continue

add r3, r30, r25  #This works and is awesome
addi r4, r1, 0x38
addi r5, r1, 0x0C
mr r6, r27
bl getCsvDataU8__2MRFPUcPC8JMapInfoPCcl

.MuteDefine_AST_Loop_Continue:
addi r25, r25, 1
addi r26, r26, 1

.MuteDefine_AST_Loop_Start:
cmpwi r26, 4
blt .MuteDefine_AST_Loop

add r3, r30, r25
addi r4, r1, 0x38
addi r5, r29, .PitchStm - .MuteDefine
mr r6, r27
bl getCsvDataF32__2MRFPfPC8JMapInfoPCcl

.MuteDefineLoop_Continue:
addi r27, r27, 0x01
addi r30, r30, MuteDefinitionSize

.MuteDefineLoop_Start:
cmpw r27, r31
blt .MuteDefineLoop


mr r3, r28
lwz       r12, 0(r3)
b .InitBgmSettingsChannelControl_Return

#Local function. Do not call elsewhere
#r3 char* destination
#r6 num
._Create_MuteSeq_Name:
addi r5, r29, .MuteSeq_Format - .MuteDefine
li        r4, 0xC
crclr     4*cr1+eq
b        snprintf

#Local function. Do not call elsewhere
#r3 char* destination
#r6 num
._Create_MuteStm_Name:
addi r5, r29, .MuteStm_Format - .MuteDefine
li        r4, 0xC
crclr     4*cr1+eq
b        snprintf



.TrackControl:
    .string "TrackControl.bcsv" 
    
#string field
.BgmName:
    .string "BgmName"

#int field
.MuteType:
    .string "MuteType" 

#int field
.ChangeType:
    .string "ChangeType"



.MuteDefine:
    .string "MuteDefine.bcsv"

#float field
.PitchStm:
    .string "SpeedStm"

#byte field
.MuteStm_Format:
    .string "MuteStm%d"

#byte field
.MuteSeq_Format:
    .string "MuteSeq%d" AUTO















# Yeah that's right, I'm overwriting the ENTIRE FUNCTION MUAHAHAHAHA
.GLE ADDRESS setStreamVolume__11AudMultiBgmFff
stwu      r1, -0x30(r1)
mflr      r0
stw       r0, 0x34(r1)
stfd      f31, 0x18(r1)
fmr       f31, f2
stfd      f30, 0x10(r1)
fmr       f30, f1
stfd      f29, 0x20(r1)
fmr       f29, f3
stw       r31, 0x0C(r1)
stw       r30, 0x08(r1)
mr        r30, r3
bl        OSDisableInterrupts
mr        r31, r3

#Here's where I become optimize prime *Transformer noises*
#Yeah that's right, there's no r3. CRY ABOUT IT
li r4, 0
fmr f1, f30
bl .AudMultiBgm_setStreamVolume_MoveVolumeChild

li r4, 1
fmr f1, f30
bl .AudMultiBgm_setStreamVolume_MoveVolumeChild

li r4, 2
fmr f1, f31
bl .AudMultiBgm_setStreamVolume_MoveVolumeChild

li r4, 3
fmr f1, f31
bl .AudMultiBgm_setStreamVolume_MoveVolumeChild

li r4, 4
fmr f1, f29
bl .AudMultiBgm_setStreamVolume_MoveVolumeChild

li r4, 5
fmr f1, f29
bl .AudMultiBgm_setStreamVolume_MoveVolumeChild

mr        r3, r31
bl        OSRestoreInterrupts
lwz       r0, 0x34(r1)
lfd       f31, 0x18(r1)
lfd       f30, 0x10(r1)
lfd       f29, 0x20(r1)
lwz       r31, 0x0C(r1)
lwz       r30, 0x08(r1)
mtlr      r0
addi      r1, r1, 0x30
blr
.GLE ASSERT 0x800826A0
.GLE ENDADDRESS


#Internal function. Never call from anywhere else
# f1 = new volume
# r4 = Child ID
.AudMultiBgm_setStreamVolume_MoveVolumeChild:
stwu      r1, -0x20(r1)
mflr      r0
stw       r0, 0x24(r1)
stw r29, 0x08(r1)
stfd f28, 0x0C(r1)
fmr f28, f1
#mr r29, r5

lwz       r3, 0x1C(r30)
lwz       r12, 0(r3)
lwz       r12, 0xC(r12)
mtctr     r12
bctrl                   # JAIStream::getChild

fmr f1, f28
li r4, 0
bl moveVolume__18JAISoundParamsMoveFfUl

lwz r29, 0x08(r1)
lfd f28, 0x0C(r1)
lwz       r0, 0x24(r1)
mtlr      r0
addi      r1, r1, 0x20
blr


.set AudFaderNum, 3
# We need anothe AudFader...
# annoyingly this is an inlined array and not a dynamic one
# so we gotta *make* it a dynamic one... BY FORCE

.GLE ADDRESS __ct__11AudMultiBgmFv +0x50
b .AudMultiBgm_CreateAudFaderArray
.AudMultiBgm_CreateAudFaderArray_Return:
.GLE ENDADDRESS

.GLE ADDRESS __ct__11AudMultiBgmFv +0x5C
lwz r3, 0x1E4(r30)
.GLE ENDADDRESS

.GLE ADDRESS __ct__11AudMultiBgmFv +0x6C
li r7, AudFaderNum
.GLE ENDADDRESS



.AudMultiBgm_CreateAudFaderArray:
# I spent 9 hours trying to figure out that I forgot to add this line of code..........................
bl __construct_array

bl getCurrentHeap__2MRFv
mr r4, r3
li r3, 0x0C * AudFaderNum
li r5, 0
stw r5, 0x1F0(r30)  # Setting this here because it's convinient to do so.
bl __nw__FUlP7JKRHeapi
stw r3, 0x1E4(r30)

b .AudMultiBgm_CreateAudFaderArray_Return


.GLE ADDRESS init__11AudMultiBgmFv +0x24
li r30, 0
lfs       f1, AudMultiBgm_1_0 - STATIC_R2(r2)  # We never actually change f1 so we can keep this out of the loop for PERFORMANCE

.AudMultiBgm_Init_Loop:
lwz       r3, 0x1E4(r29)
mulli r4, r30, 0x0C
add r3, r3, r4
li r4, 0
bl set__8AudFaderFfl

addi r30, r30, 1
cmpwi r30, AudFaderNum
blt .AudMultiBgm_Init_Loop

nop
.GLE ENDADDRESS

.GLE ADDRESS movement__11AudMultiBgmFv +0x40
li r30, 0

.AudMultiBgm_movement_Loop2:
lwz       r3, 0x1E4(r29)
mulli r4, r30, 0x0C
add r3, r3, r4
bl update__8AudFaderFv

addi r30, r30, 1
cmpwi r30, AudFaderNum
blt .AudMultiBgm_movement_Loop2

nop
.GLE ENDADDRESS

.GLE ADDRESS movement__11AudMultiBgmFv +0xB4
li r30, 0
lfs       f1, AudMultiBgm_1_0 - STATIC_R2(r2)  # We never actually change f1 so we can keep this out of the loop for PERFORMANCE

.AudMultiBgm_Init_Loop3:
lwz       r3, 0x1E4(r29)
mulli r4, r30, 0x0C
add r3, r3, r4
li r4, 0
bl set__8AudFaderFfl

addi r30, r30, 1
cmpwi r30, AudFaderNum
blt .AudMultiBgm_Init_Loop3

nop
.GLE ENDADDRESS

# Yeah, despite the fact I made the other functions not hardcoded to a fixed amount, for now I'm hardcoding this.
.GLE ADDRESS movement__11AudMultiBgmFv +0xE4
mr        r3, r29
lwz       r4, 0x1E4(r29)
lfs f1, 0x00(r4)
lfs f2, 0x0C(r4)
lfs f3, 0x18(r4)
bl .AudMultiBgm_Movement_setStreamVolumeFinal
.GLE ENDADDRESS

.AudMultiBgm_Movement_setStreamVolumeFinal:
fmuls     f1, f31, f1
fmuls     f2, f31, f2
fmuls     f3, f31, f3
b setStreamVolume__11AudMultiBgmFff


# Same for this one
.GLE ADDRESS prepare__11AudMultiBgmFUl +0x144
b .AudMultiBgm_PrepareExt
.GLE ENDADDRESS
.GLE ADDRESS prepare__11AudMultiBgmFUl +0x16C
.AudMultiBgm_PrepareExt_Return:
.GLE ENDADDRESS

.AudMultiBgm_PrepareExt:
bl getVolume__22AudBgmVolumeControllerCFv
lwz       r4, 0x1E4(r28)
lfs       f2, 0x00(r4)
fmuls     f30, f1, f2

lwz       r3, 4(r28)
bl getVolume__22AudBgmVolumeControllerCFv
lwz       r4, 0x1E4(r28)
lfs       f2, 0x0C(r4)
fmuls     f31, f1, f2

lwz       r3, 4(r28)
bl getVolume__22AudBgmVolumeControllerCFv
lwz       r4, 0x1E4(r28)
lfs       f2, 0x18(r4)
fmuls     f3, f1, f2

mr        r3, r28
fmr       f1, f30
fmr       f2, f31
bl setStreamVolume__11AudMultiBgmFff


bl .GLE_ResetAudioComponents


b .AudMultiBgm_PrepareExt_Return



.GLE ADDRESS start__12AudSingleBgmFUlb +0x134
b .AudSingleBgm_Start_Ext_Reset
.AudSingleBgm_Start_Ext_Reset_Return:
.GLE ENDADDRESS

.AudSingleBgm_Start_Ext_Reset:
bl .GLE_ResetAudioComponents

addi      r11, r1, 0x30
b .AudSingleBgm_Start_Ext_Reset_Return


.GLE_ResetAudioComponents:
stwu r1, -0x10(r1)
mflr r0
stw r0, 0x14(r1)

li r3, 0
li r4, 0
bl .GLE_addStageBGMState

li r3, 1
lis r4, AudMultiBgm_1_0@ha
lfs f1, AudMultiBgm_1_0@l(r4)
bl .GLE_setAudioSpeed


lwz r0, 0x14(r1)
mtlr r0
addi r1, r1, 0x10
blr


.GLE ADDRESS changeTrackMuteState__12AudSingleBgmFll +0xC4
b .AudSingleBgm_ChangeSpeed
.AudSingleBgm_ChangeSpeed_Return:
.GLE ENDADDRESS

.AudSingleBgm_ChangeSpeed:
mr        r3, r31
cmpwi r27, 0
beq .AudSingleBgm_ChangeSpeed_End
lfs f1, 0x0C(r27)
lwz r0, 0x0C(r27)
andi. r0, r0, 1
beq .AudSingleBgm_ChangeSpeed_End
bl .GLE_setAudioSpeed

.AudSingleBgm_ChangeSpeed_End:
addi      r11, r1, 0x30
b .AudSingleBgm_ChangeSpeed_Return



.GLE ADDRESS changeTrackMuteState__11AudMultiBgmFll +0xB8
li r3, 0
lbz       r4, 0x08(r26)
bl .changeTrackMuteStateStm
li r3, 1
lbz       r4, 0x09(r26)
bl .changeTrackMuteStateStm
li r3, 2
lbz       r4, 0x0A(r26)
bl .changeTrackMuteStateStm

# Brand new Stream Speed!
mr        r3, r30
lfs f1, 0x0C(r26)
bl .GLE_setAudioSpeed

b .changeTrackMuteStateStm_JumpLoc

# A literal inline function LOL
#r3 = AudFader ID
#r4 = Stream Volume Value
.changeTrackMuteStateStm:
cmplwi    r4, 0xFF
beqlr
lis       r0, 0x4330
stw       r4, 0x1C(r1)
lfs       f0, AudMultiBgm_254_0 - STATIC_R2(r2)
stw       r0, 0x18(r1)
mr        r4, r30
lis       r5, AudMultiBgm_FloatConversion@ha
lfd       f2, AudMultiBgm_FloatConversion@l(r5)
lfd       f1, 0x18(r1)
fsubs     f1, f1, f2
fdivs     f1, f1, f0
mulli     r5, r3, 0x0C
lwz       r3, 0x1E4(r28)
add       r3, r3, r5
b        set__8AudFaderFfl
#.GLE ASSERT 0x80081F60
.GLE ENDADDRESS


.GLE ADDRESS changeTrackMuteState__11AudMultiBgmFll +0x130
.changeTrackMuteStateStm_JumpLoc:
.GLE ENDADDRESS

# This removes the ability for different chords to be used based on mute group selection
# Why remove it? Because A, nobody knows how to use it, and B, NINTENDO DIDN'T USE IT IN EITHER GAME
# Like, I can see what they were going for. They just.....didn't... And it causes issues for me so away it goes
.GLE ADDRESS changeTrackMuteState__11AudMultiBgmFll +0x134
b changeTrackMuteState__11AudMultiBgmFll_SkipExtraChords
.GLE ENDADDRESS

.GLE ADDRESS changeTrackMuteState__11AudMultiBgmFll +0x16C
changeTrackMuteState__11AudMultiBgmFll_SkipExtraChords:
.GLE ENDADDRESS



# Not using r3 because IT'S LESS CODE YAAAAAAAAA
# r0 = MuteType (TrackControl.bcsv)
# r5 = MuteState (The actual game mute state value lol)
.GLE_GetMuteDefineByMuteType:
lis       r4, cMuteSettingInfo__13AudBgmSetting@ha
addi      r4, r4, cMuteSettingInfo__13AudBgmSetting@l
lwz r6, 0x04(r4)
lwz r4, 0x00(r4) #Load the array
cmpw r0, r6
li r3, 0
bgelr
cmpwi r0, 0
bltlr

lis r7, Static_AdditiveBgmState@ha
addi r7, r7, Static_AdditiveBgmState@l
lwz r7, 0x00(r7)

#I'm just realizing now that we're inheriting r0 from the caller..... oops
mulli     r0, r0, MuteDefinitionSize  #Navigate to the Primary
mulli     r3, r5, MuteDefinitionSize  #Navigate to the Target
mulli     r7, r7, MuteDefinitionSize  #Navigate to the Additive
add       r0, r4, r0
add       r3, r3, r0
add       r3, r3, r7
blr





# This function is here to replace a useless function inside AudMultiBgm
# Yes we need to replace the whole thing
.GLE ADDRESS sub_80081CC0
b .AudMultiBgm_TempoReplacementFunction
.GLE ENDADDRESS
.AudMultiBgm_TempoReplacementFunction:
stwu      r1, -0x30(r1)
mflr      r0
stw       r0, 0x34(r1)
stfd      f31, 0x20(r1)
psq_st    f31, 0x28(r1), 0, 0
fmr       f31, f1
stw       r31, 0x1C(r1)
mr        r31, r4
lwz       r3, 0x20(r3)
cmpwi     r3, 0
bne       loc_800812B4
li        r3, 0
b         loc_80081330
loc_800812B4:
lwz       r12, 0(r3)
lwz       r12, 0x28(r12)
mtctr     r12
bctrl
cmpwi     r3, 0
beq       loc_8008132C
cmpwi     r31, 0
bne       loc_800812F0
stfs      f31, 0(r3)
li        r0, 0
lfs       f0, AudSingleBgm_0_0 - STATIC_R2(r2)
stfs      f0, 4(r3)
stw       r0, 0xC(r3)
stfs      f0, 8(r3)
b         loc_80081324
loc_800812F0:
lfs       f0, 0(r3)
lis       r0, 0x4330
lis       r4, AudSingleBgm_FloatConversion@ha
stw       r31, 0xC(r1)
lfd       f1, AudSingleBgm_FloatConversion@l(r4)
fsubs     f2, f31, f0
stw       r0, 8(r1)
lfd       f0, 8(r1)
stw       r31, 0xC(r3)
fsubs     f0, f0, f1
fdivs     f0, f2, f0
stfs      f0, 4(r3)
stfs      f31, 8(r3)

loc_80081324:
li        r3, 1
b         loc_80081330
loc_8008132C:
li        r3, 0

loc_80081330:
lwz       r0, 0x34(r1)
psq_l     f31, 0x28(r1), 0, 0
lfd       f31, 0x20(r1)
lwz       r31, 0x1C(r1)
mtlr      r0
addi      r1, r1, 0x30
blr




.GLE SYMBOL START
.GLE SYMBOL NAME setAudioSpeed__3GLEFfl
.GLE SYMBOL DESC #Changes the playback speed of the currently playing song (both AST and BMS).
.GLE SYMBOL PARA 0 speed #The new playback speed. Default speed is 1.0f
.GLE SYMBOL PARA 1 time #The number of frames it takes to change to the new speed
.GLE SYMBOL END
# f1 = new speed
# r3 = time
.GLE_setAudioSpeed:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)

mr r4, r3
# Verified to only edit r3
bl getAudSystemWrapper__32@unnamed@GameSystemFunction_cpp@Fv
lwz r3, 0x00(r3)       # Get the AudSystem from the Wrapper
addi r3, r3, 0x7A4     # Move to the inbuilt JAIStreamMgr
lfs f2, 0x0C(r3)       # Load the current pitch value
addi r3, r3, 0x24      # Move to the JAIStreamMgr's inbuilt Pitch translation param
bl set__Q224JAISoundParamsTransition11TTransitionFffUl

# Thankfully r4 & f1 are never changed until this point, so we can safely reuse them
bl getStageBgm__7AudWrapFv

cmpwi r3, 0  # Better NULL check just in case...
beq .GLE_setAudioSpeed_Return

lwz       r12, 0(r3)
lwz       r12, 0x2C(r12)
mtctr     r12
bctrl     # Changes BMS Tempo

.GLE_setAudioSpeed_Return:
lwz       r0, 0x14(r1)
lwz       r31, 0x0C(r1)
mtlr      r0
addi      r1, r1, 0x10
blr


.GLE SYMBOL START
.GLE SYMBOL NAME addStageBGMState__3GLEFlUl
.GLE SYMBOL DESC #Changes the current BGM State based on what it's currently set to
.GLE SYMBOL PARA 0 state #The state to switch to relative to the current state
.GLE SYMBOL PARA 1 time #The number of frames it takes to switch states fully
.GLE SYMBOL END
.GLE_addStageBGMState:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)

# Avoiding r4 so we don't need to save or re-set it...
lis r5, Static_AdditiveBgmState@ha
addi r5, r5, Static_AdditiveBgmState@l
stw r3, 0x00(r5)

bl getStageBgm__7AudWrapFv
cmpwi r3, 0
beq .GLE_addStageBGMState_NoBgmActive
lwz r3, 0x18(r3)
bl setStageBGMState__2MRFlUl

.GLE_addStageBGMState_NoBgmActive:
# We only need the value to be set during this function.
lis r5, Static_AdditiveBgmState@ha
addi r5, r5, Static_AdditiveBgmState@l
li r4, 0
stw r4, 0x00(r5)

lwz       r0, 0x14(r1)
lwz       r31, 0x0C(r1)
mtlr      r0
addi      r1, r1, 0x10
blr


#End worldmap code
.BGM_SETTING_INFO_CONNECTOR:
.GLE ENDADDRESS



















#now to override the getting function
#should be easy

.GLE ADDRESS getSettingInfo__14AudBgmSettingsFl
lis       r5, cBgmSettingInfo__13AudBgmSetting@ha
lwz r0, cBgmSettingInfo__13AudBgmSetting@l + 0x04(r5)
#addi      r5, r5, AudBgmSetting::cBgmSettingInfo(void)@l
lwz r5, cBgmSettingInfo__13AudBgmSetting@l(r5)
li        r4, 0
mtctr     r0

loc_800838A4:
lwzx      r0, r5, r4
cmplw     r3, r0
bne       loc_800838B8
add       r3, r5, r4
blr

loc_800838B8:
addi      r4, r4, TrackEntrySize
bdnz      loc_800838A4
li        r3, 0
blr

.GLE TRASH BEGIN
Static_AdditiveBgmState:
.int 0
.GLE TRASH END
#.GLE ASSERT 0x800838D0
.GLE ENDADDRESS

.GLE ADDRESS getMuteState__13AudBgmSettingF10JAISoundIDl
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
mr        r31, r4
lwz       r3, 0(r3)
bl        getSettingInfo__14AudBgmSettingsFl
cmpwi     r3, 0
bne       loc_80083D9C
li        r3, 0
b         loc_80083DC8

loc_80083D9C:
lwz       r0, 4(r3)
cmpwi     r0, 0
bge       loc_80083DB0
li        r3, 0
b         loc_80083DC8
                
loc_80083DB0:
mr r5, r31,
bl .GLE_GetMuteDefineByMuteType

loc_80083DC8:
lwz       r0, 0x14(r1)
lwz       r31, 0x0C(r1)
mtlr      r0
addi      r1, r1, 0x10
blr
#.GLE ASSERT 0x80083DDC
.GLE ENDADDRESS

