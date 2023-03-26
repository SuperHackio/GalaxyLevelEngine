#This file pretty much only contains AudBgmConductor::movement((void))

.GLE ADDRESS movement__15AudBgmConductorFv
stwu      r1, -0x30(r1)
mflr      r0
stw       r0, 0x34(r1)
addi      r11, r1, 0x20
stfd      f31, 0x20(r1)
psq_st    f31, 0x28(r1), 0, 0
bl        _savegpr_29
mr        r30, r3
bl        movementMorphBgm__15AudBgmConductorFv
bl        getStageBgm__7AudWrapFv
cmpwi     r3, 0
mr        r31, r3
beq .AudBgmConductor_Movement_Return

addi      r3, r1, 0x0C
mr        r4, r31
lwz       r12, 0(r31)
lwz       r12, 0x4C(r12)
mtctr     r12
bctrl                   # AudMultiBgm::getStreamID(const(void))
lwz       r3, 0x0C(r1)
lwz       r0, 0x14(r30)
cmplw     r3, r0
beq       loc_80220DE4
li        r0, -1
stw       r0, 0x1C(r30)

loc_80220DE4:
#Here's where things take a dramatic turn

li        r4, 0x5A
stw       r4, 0x08(r1)

addi      r3, r1, 0x0C
mr        r4, r31
lwz       r12, 0(r31)
lwz       r12, 0x50(r12)
mtctr     r12
bctrl                   # AudMultiBgm::getSequenceID(const(void))

lwz       r3, 0x0C(r1)
bl getSettingInfo__14AudBgmSettingsFl

#r3 now has a pointer to the correct entry for this song... assuming it's on the list
#If it's not on the list, then we can't do anything with it...
cmpwi r3, 0 
beq .AudBgmConductor_Movement_Cancel
lwz       r3, 0x0C(r3) #Get the change type
cmpwi r3, 0 
ble .AudBgmConductor_Movement_Cancel

# Automatic Change Types
# 0 = None
# 1 = Yoshi Drums (Normal)
# 2 = Water Music (koopa shell, Yoshi Drums, etc. Think Starshine Beach)
# 3 = Slowdown Switch
# 4 = Yoshi Drums (Dash Yoshi Support, needs a sequenced song)
# 5 = Fire Flower (Used by Squizzard only pretty much)
# 6 = Bowser Meteors
# 7 = Worldmap  (This only exists for future proofing, as worldmaps will never be added back... removing them was the whole point, after all)
cmpwi r3, 0
ble .AudBgmConductor_Movement_Cancel
cmpwi r3, 2
blt .YoshiNormal
beq .WaterMusic
cmpwi r3, 4
blt .SlowdownSwitch
beq .DashYoshi
cmpwi r3, 6
blt .FireFlower
beq .BowserMeteors
bgt .WorldmapMusic
#Unlikely that we get here, but just in case...
b .AudBgmConductor_Movement_Cancel

.YoshiNormal:
lwz       r4, 0x1C(r30)
addi      r3, r1, 0x08
lwz       r5, 0x18(r30)
bl setBgmStateYoshi
mr        r29, r3
b .AudBgmConductor_Movement_UpdateValues


.WaterMusic:
lwz       r3, 0x18(r30)
rlwinm.   r0, r3, 0,30,30
beq .WaterMusic_AboveWater
rlwinm.   r0, r3, 0,29,29
beq       .WaterMusic_Underwater

#This part was used in SMG1's Beach Bowl galaxy for the bongos that played when you have a koopa shell
#While this music state bit still does trigger when you grab a koopa shell,
#There appears to be no programming to turn on any midi tracks. If someone gets this working again let me know...
li        r4, 0x14
stw       r4, 0x08(r1)
li        r29, 6
b .ChangeBgmState

.WaterMusic_AboveWater:
rlwinm.   r0, r3, 0,29,29
beq .YoshiNormal

#This part was used in SMG1's Beach Bowl galaxy for the bongos that played when you have a koopa shell
#While this music state bit still does trigger when you grab a koopa shell,
#There appears to be no programming to turn on any midi tracks. If someone gets this working again let me know...
li        r4, 0x14
stw       r4, 0x08(r1)
li        r29, 4
b .ChangeBgmState

.WaterMusic_Underwater:
li r29, 5
b .ChangeBgmState


.SlowdownSwitch:
#Changed this one from the original game since it used to be
#hardcoded to stone cyclone to use slowdown switch with that one song galaxy22
#Now, if the slowdown switch is active, it will prioritize that and the yoshi drums
#will likely shut off. They should resume when the slowdown effect stops.
rlwinm.   r0, r5, 0,25,25
bne .YoshiNormal
lwz       r4, 0x1C(r30)
addi      r3, r1, 0x08
lwz       r5, 0x18(r30)
bl        setBgmStateSlowdownTime
mr        r29, r3
b .AudBgmConductor_Movement_UpdateValues

.DashYoshi:
#This case is specifically for Hightail falls music. Could technically apply to any sequenced track maybe?
lwz       r3, 0x18(r30)
rlwinm.   r0, r3, 0,27,27
beq       loc_80221080
li        r4, 0x14
stw       r4, 0x08(r1)
lfs       f31, DashBgmTempoUp_flt - STATIC_R2(r2)
li        r29, 9
b         loc_802210AC

loc_80221080:
rlwinm.   r0, r3, 0,28,28 # Yoshi Drums
beq       loc_8022109C
li        r4, 0x14
stw       r4, 0x08(r1)
lfs       f31, DashBgmTempo_flt - STATIC_R2(r2)
li        r29, 8
b         loc_802210AC

loc_8022109C:
li        r4, 0x14
stw       r4, 0x08(r1)
lfs       f31, DashBgmTempo_flt - STATIC_R2(r2)
li        r29, 0

loc_802210AC:
lwz       r0, 0x1C(r30)
cmpw      r29, r0
beq       .AudBgmConductor_Movement_UpdateValues
mr        r3, r29
bl        setStageBGMState__2MRFlUl
lfs       f0, DashBgmTempo_flt - STATIC_R2(r2)
mr        r3, r31
lwz       r4, 0x08(r1)
fdivs     f1, f31, f0
lwz       r12, 0(r31)
lwz       r12, 0x2C(r12)
mtctr     r12
bctrl     # Changes Tempo
b         .AudBgmConductor_Movement_UpdateValues


.FireFlower:
lwz       r0, 0x18(r30)
lfs       f31, Boss04Tempo_flt - STATIC_R2(r2)
rlwinm.   r0, r0, 0,26,26
beq       loc_80221104
li        r4, 6
stw       r4, 0x08(r1)
li        r29, 2
b         loc_80221110

loc_80221104:
li        r4, 6
stw       r4, 0x08(r1)
li        r29, 0

loc_80221110:
lwz       r0, 0x1C(r30)
cmpw      r29, r0
beq       .AudBgmConductor_Movement_UpdateValues
mr        r3, r29
bl        setStageBGMState__2MRFlUl
lfs       f0, Boss04Tempo_flt - STATIC_R2(r2)
mr        r3, r31
lwz       r12, 0(r31)
fdivs     f1, f31, f0
lwz       r4, 0x08(r1)
lwz       r12, 0x2C(r12)
mtctr     r12
bctrl     # Changes Tempo
b         .AudBgmConductor_Movement_UpdateValues


.BowserMeteors:
lwz       r0, 0x18(r30)
rlwinm.   r0, r0, 0,24,24
beq .BowserMeteors_Off
li        r4, 0x1E
stw       r4, 0x08(r1)
li        r29, 2
b .ChangeBgmState

.BowserMeteors_Off:
li        r4, 0xB4
stw       r4, 0x08(r1)
li        r29, 1
b .ChangeBgmState

.WorldmapMusic:
#This may never be used in the GLE
lwz       r0, 0x18(r30)
rlwinm.   r0, r0, 0,23,23
beq .WorldmapMusic_Off
li        r4, 0x3C
stw       r4, 0x08(r1)
li        r29, 2
b .ChangeBgmState

.WorldmapMusic_Off:
li        r4, 0x5A
stw       r4, 0x08(r1)
li        r29, 1
b .ChangeBgmState  
#In case we add more?

.ChangeBgmState:
lwz       r0, 0x1C(r30)
cmpw      r29, r0
beq       .AudBgmConductor_Movement_UpdateValues
mr        r3, r29
bl        setStageBGMState__2MRFlUl
b .AudBgmConductor_Movement_UpdateValues


.AudBgmConductor_Movement_Cancel:
li r29, 0

.AudBgmConductor_Movement_UpdateValues:
lwz       r3, 0x0C(r1)
stw       r3, 0x14(r30)
stw       r29, 0x1C(r30)
li        r0, 0
stw       r0, 0x18(r30)

.AudBgmConductor_Movement_Return:
addi      r11, r1, 0x20
psq_l     f31, 0x28(r1), 0, 0
lfd       f31, 0x20(r1)
bl        _restgpr_29
lwz       r0, 0x34(r1)
mtlr      r0
addi      r1, r1, 0x30
blr
.GLE ASSERT movement__15AudBgmConductorFv +0x4F4
.GLE ENDADDRESS