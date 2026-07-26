# This file allows the Life-up shroom to be used in Daredevil comets.
.GLE ADDRESS .SCENARIO_SELECT_CONNECTOR

#-------------------------------------------------------------------

# Make the life-up shroom be spawnable in Daredevil comets
.GLE ADDRESS __ct__17BenefitItemLifeUpFPCc +0x3C
nop
.GLE ENDADDRESS


# Fixes a... bug? With Nintendo's original code, the meter vanishes when triggering the powerup animation...  Also, said animation doesn't exist, so that's fun!
.GLE ADDRESS powerUp__10MarioMeterFv +0x2C
b .GLE_MarioMeter_Powerup_SuddenDeath_Fix
.GLE_MarioMeter_Powerup_SuddenDeath_Fix_Return:
.GLE ENDADDRESS

.GLE_MarioMeter_Powerup_SuddenDeath_Fix:
lwz       r3, 0x18(r31)
lwz       r12, 0(r3)
lwz       r12, 0x2C(r12)
mtctr     r12
bctrl

lwz       r3, 0x18(r31)
bl        requestPowerUp__16SuddenDeathMeterFv

b .GLE_MarioMeter_Powerup_SuddenDeath_Fix_Return



# This fixes the SuddenDeathMeter's animations
.GLE ADDRESS exePowerUp__16SuddenDeathMeterFv +0x58
b .GLE_MarioMeter_Powerup_SuddenDeath_ExePowerup
.GLE_MarioMeter_Powerup_SuddenDeath_ExePowerup_Return:
.GLE ENDADDRESS

.GLE_MarioMeter_Powerup_SuddenDeath_ExePowerup:
mr r3, r31
li r4, 1
bl setAnimFrameAndStopAtEnd__2MRFP11LayoutActorUl

lwz r0, 0x40(r31)
cmpwi r0, 2
bge .GLE_MarioMeter_Powerup_SuddenDeath_ExePowerup_Jump

mr r3, r31
bl isFirstStep__2MRFPC11LayoutActor
cmpwi r3, 0   # do not apply to the first step
bne .GLE_MarioMeter_Powerup_SuddenDeath_ExePowerup_Jump

mr r3, r31
li r4, 7
bl isIntervalStep__2MRFPC11LayoutActorl
cmpwi r3, 0
beq .GLE_MarioMeter_Powerup_SuddenDeath_ExePowerup_Jump

lwz r3, 0x40(r31)
addi r3, r3, 1
stw r3, 0x40(r31)
mr r3, r31
bl setRecoveryCountAnimFrame__16SuddenDeathMeterFv

mr r3, r31
lis r4, Str_SuddenDeathMeter_HitPointNumber@ha
addi r4, r4, Str_SuddenDeathMeter_HitPointNumber@l
li r5, 1
bl setTextBoxNumberRecursive__2MRFP11LayoutActorPCcl

.GLE_MarioMeter_Powerup_SuddenDeath_ExePowerup_Jump:
mr        r3, r31
b .GLE_MarioMeter_Powerup_SuddenDeath_ExePowerup_Return




# This makes it give you 2hp instead of 6hp
.GLE ADDRESS tryChangeMaxLife__10MarioActorFv +0x54
b .GLE_TryChangeMaxLife_PowerupFix
.GLE_TryChangeMaxLife_PowerupFix_Return:
mr r3, r30
.GLE ENDADDRESS

.GLE_TryChangeMaxLife_PowerupFix:
bl isGalaxyDarkCometAppearInCurrentStage__2MRFv
cmpwi r3, 0
li r3, 2    # Double the health, double the fun! Twice the Daredevil is greater than One!
bne .GLE_TryChangeMaxLife_PowerupFix_JumpLoc

bl .GLE_GetPowerupMaxLife

.GLE_TryChangeMaxLife_PowerupFix_JumpLoc:
mr r4, r3
b .GLE_TryChangeMaxLife_PowerupFix_Return



# This makes life mushrooms give you a 1-up when in daredevil mode and you already have one
.GLE ADDRESS changeItemStatus__11MarioAccessFl +0x150
#Ran out of space here
b .GLE_MarioAccess_ChangeItemState_OnLifeUp_Extra
.GLE_MarioAccess_ChangeItemState_OnLifeUp_Extra_Return:
lwz r4, 0x08(r1)
beq .GLE_MarioAccess_ChangeItemState_OnLifeUp_JumpLoc
li r4, 2
.GLE_MarioAccess_ChangeItemState_OnLifeUp_JumpLoc:
lwz       r5, 0x6B0(r3)
cmpw r5, r4
bne .GLE_MarioAccess_ChangeItemState_OnLifeUp_NotAOneUp
li r3, 1
bl addPlayerLeft__2MRFi
b .GLE_MarioAccess_ChangeItemState_OnLifeUp_Break

.GLE_MarioAccess_ChangeItemState_OnLifeUp_NotAOneUp:
.GLE ENDADDRESS

.GLE_MarioAccess_ChangeItemState_OnLifeUp_Extra:
bl .GLE_GetPowerupMaxLife
stw r3, 0x08(r1)

bl isGalaxyDarkCometAppearInCurrentStage__2MRFv
cmpwi r3, 0
#Okay now this is crazy. I'm holding a comparator through many function calls
#I know, I know, I'm CRAZY
bl getMarioHolder__2MRFv
bl getMarioActor__11MarioHolderCFv
b .GLE_MarioAccess_ChangeItemState_OnLifeUp_Extra_Return


.GLE ADDRESS changeItemStatus__11MarioAccessFl +0x1E0
.GLE_MarioAccess_ChangeItemState_OnLifeUp_Break:
.GLE ENDADDRESS


# Fixes mario from being able to pant (DamageWait) in Daredevil
.GLE ADDRESS decideWalkAnimation__5MarioFv +0x50C
b .GLE_Mario_DecideWalkAnimation_DarkCometFix
.GLE_Mario_DecideWalkAnimation_DarkCometFix_Return:
.GLE ENDADDRESS
.GLE ADDRESS decideWalkAnimation__5MarioFv +0x594
.GLE_Mario_DecideWalkAnimation_DarkCometFix_JumpLoc:
.GLE ENDADDRESS

.GLE_Mario_DecideWalkAnimation_DarkCometFix:
bl isGalaxyDarkCometAppearInCurrentStage__2MRFv
cmpwi r3, 0
bne .GLE_Mario_DecideWalkAnimation_DarkCometFix_Nope

bl .GLE_GetMaxLife
cmpwi r3, 1  # If the user set the max health to 1, we don't need to pant since we can't be high health
beq .GLE_Mario_DecideWalkAnimation_DarkCometFix_Nope

lwz       r3, 4(r29)
b .GLE_Mario_DecideWalkAnimation_DarkCometFix_Return

.GLE_Mario_DecideWalkAnimation_DarkCometFix_Nope:
b .GLE_Mario_DecideWalkAnimation_DarkCometFix_JumpLoc





# For whatever reason Nintendo just didn't make particles for this layout.
# So I'm going to fix that as long as I'm here
# Just by re-using the same ones the normal HitPointMeter uses

.GLE ADDRESS init__16SuddenDeathMeterFRC12JMapInfoIter +0xE8
b .GLE_SuddenDeathMeter_Init_EffectExt
.GLE_SuddenDeathMeter_Init_EffectExt_Return:
.GLE ENDADDRESS

.GLE_SuddenDeathMeter_Init_EffectExt:
lis r5, Str_HitPointMeter@ha
addi r5, r5, Str_HitPointMeter@l
b .GLE_SuddenDeathMeter_Init_EffectExt_Return



.GLE ADDRESS exeBreakMeter__16SuddenDeathMeterFv +0x90
b .GLE_SuddenDeathMeter_EffectBreak
.GLE_SuddenDeathMeter_EffectBreak_Return:
.GLE ENDADDRESS

.GLE_SuddenDeathMeter_EffectBreak:
mr        r3, r30
lis r4, Str_HitPointMeter_Break@ha
addi r4, r4, Str_HitPointMeter_Break@l
bl emitEffect__2MRFP11LayoutActorPCc

mr        r3, r30
b .GLE_SuddenDeathMeter_EffectBreak_Return


.GLE ADDRESS exeZeroMeterBreak__16SuddenDeathMeterFv +0x40
b .GLE_SuddenDeathMeter_EffectBreak123
.GLE_SuddenDeathMeter_EffectBreak123_Return:
.GLE ENDADDRESS

.GLE_SuddenDeathMeter_EffectBreak123:
mr        r3, r31
lis r4, Str_HitPointMeter_Break123@ha
addi r4, r4, Str_HitPointMeter_Break123@l
bl emitEffect__2MRFP11LayoutActorPCc

mr        r3, r31
b .GLE_SuddenDeathMeter_EffectBreak123_Return



# This is fixing the final hit not shaking the meter in sudden death mode
.GLE ADDRESS exeZeroMeter__16SuddenDeathMeterFv +0x30
b .GLE_SuddenDeathMeter_ShakeFix
.GLE_SuddenDeathMeter_ShakeFix_Return:
.GLE ENDADDRESS


.GLE_SuddenDeathMeter_ShakeFix:
bl setCountAnimFrame__16SuddenDeathMeterFv

mr        r3, r31
lis r4, Str_HitPointMeter_Damage1@ha
addi r4, r4, Str_HitPointMeter_Damage1@l
li        r5, 1
bl startAnim__2MRFP11LayoutActorPCcUl
b .GLE_SuddenDeathMeter_ShakeFix_Return

#-------------------------------------------------------------------

#END WORLDMAP CODE
.SUDDEN_DEATH_METER_CONNECTOR:
.GLE ENDADDRESS