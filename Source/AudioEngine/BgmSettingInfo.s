#This code lets users define how multi-channel streams are handled

#3 ints.
.set TrackEntrySize, 4 * 0x04

.GLE ADDRESS sub_804E8FD0
blr

.InitBgmSettingsChannelControl:
mr r27, r3 #Keep this
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
lis r28, cBgmSettingInfo__13AudBgmSetting@ha
addi r28, r28, cBgmSettingInfo__13AudBgmSetting@l

addi      r3, r1, 0x38
bl getCsvDataElementNum__2MRFPC8JMapInfo
stw r3, 0x04(r28)  #Gotta keep the entry count
mr r31, r3
mulli r3, r3, TrackEntrySize
bl __nwa__FUl
#Not gonna bother checking for no memory here, as we DEFINITELY should have memory open to us at this point...
stw r3, 0x00(r28)
mr r28, r3  #now r28 has the array pointer

mr r30, r28
mr r28, r27
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

mr r3, r28
lwz       r12, 0(r3)
b .InitBgmSettingsChannelControl_Return

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
    .string "ChangeType" AUTO


.GLE ENDADDRESS


.GLE ADDRESS sub_80089480 +0x3C
b .InitBgmSettingsChannelControl
.InitBgmSettingsChannelControl_Return:
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

#.GLE ASSERT 0x800838D0
.GLE ENDADDRESS









