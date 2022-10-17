#A Collection of everything that uses the ScenarioSettings
#This file used to be global, but is now inside each map file. It does not need to exist.

#ScoreAttack is kept inside ScoreAttackMan.s

.GLE ADDRESS isStageStoryBook__2MRFv
lis r3, StoryLayout@ha
addi r3, r3, StoryLayout@l
li r4, 0
b .MR_GetCurrentScenarioSetting
.GLE ENDADDRESS

#This code executes before the Project Template's code, meaning the PT's code is never run
.GLE ADDRESS isStagePlayStarChance__2MRFl
#Unlike other situations, this function has a scenario passed into it
mr r4, r3
lis r3, NoStarChance@ha
addi r3, r3, NoStarChance@l
li r5, 1 #Ask to flip the bit
b .MR_GetScenarioSetting
.GLE ENDADDRESS

.GLE ADDRESS isStageScoreAttack__2MRFv
lis r3, ScoreAttack@ha
addi r3, r3, ScoreAttack@l
li r4, 0
b .MR_GetCurrentScenarioSetting
.GLE ENDADDRESS

#Note: This function name isn't really good.
#Something like isStagePurpleCoinNoSpawn__2MRFPCc
#Because this actually just controls if the star is spawned automatically or not
.GLE ADDRESS isStagePurpleCoinsMoreThan100__2MRFPCc
lis r3, ManualPurpleCoin@ha
addi r3, r3, ManualPurpleCoin@l
li r4, 0
b .MR_GetCurrentScenarioSetting
.GLE ENDADDRESS

.GLE ADDRESS isInvalidBackMarioFaceShipOrWorldMap__23@unnamed@PauseMenu_cpp@Fv
lis r3, NoPauseReturn@ha
addi r3, r3, NoPauseReturn@l
li r4, 0
b .MR_GetCurrentScenarioSetting
.GLE ENDADDRESS

.GLE ADDRESS trySkipTrigger__15ScenarioStarterCFv +0x18
bl isInvalidBackMarioFaceShipOrWorldMap__23@unnamed@PauseMenu_cpp@Fv
.GLE ENDADDRESS

#=======================
.GLE ADDRESS isStageForbidLeave__2MRFv
lis r3, NoPauseExit@ha
addi r3, r3, NoPauseExit@l
li r4, 0
b .MR_GetCurrentScenarioSetting

.isStageNoWelcome:
lis r3, NoWelcome@ha
addi r3, r3, NoWelcome@l
li r4, 0
b .MR_GetCurrentScenarioSetting
.GLE ENDADDRESS

#Not making a whole new file for these!


#CinemaFrame patch
.GLE ADDRESS exeRailMove__15ScenarioStarterFv +0x3C
li r3, 0
.GLE ENDADDRESS

.GLE ADDRESS exeRailMove__15ScenarioStarterFv +0x284
li r3, 0
.GLE ENDADDRESS

.GLE ADDRESS exeRailMove__15ScenarioStarterFv +0x2EC
li r3, 0
.GLE ENDADDRESS


.GLE ADDRESS getStarPieceNum__2MRFv +0x20
li r3, 0
.GLE ENDADDRESS

.GLE ADDRESS addStarPiece__2MRFi +0x40
li r3, 0
.GLE ENDADDRESS

.GLE ADDRESS incCoin__2MRFiP9LiveActor +0x40
li r3, 0
.GLE ENDADDRESS

.GLE ADDRESS sub_80023B00 +0x28
li r3, 0
.GLE ENDADDRESS

.GLE ADDRESS getCoinNum__2MRFv +0x20
li r3, 0
.GLE ENDADDRESS
#=======================

.GLE ADDRESS exeShowWelcomeLayout__15ScenarioStarterFv +0xBC
bl .isStageNoWelcome
.GLE ENDADDRESS


.GLE ADDRESS isStageGlider__2MRFv
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)

lis r3, RaceId@ha
addi r3, r3, RaceId@l
li r4, 0
bl .MR_GetCurrentScenarioSetting

cmpwi r3, 0
beq .end
li r3, 1

.end:
lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr
.GLE ENDADDRESS

.GLE ADDRESS isStageJungleGliderGalaxyExplainDemo__2MRFv
lis r3, RaceTutorial@ha
addi r3, r3, RaceTutorial@l
li r4, 0
b .MR_GetCurrentScenarioSetting


.IsStageNoStopCometClock:
lis r3, NoStopClock@ha
addi r3, r3, NoStopClock@l
li r4, 0
b .MR_GetCurrentScenarioSetting

.CheckNoStopClock:
bl .IsStageNoStopCometClock
cmpwi r3, 0
bne .CheckNoStopClock_True

.CheckNoStopClock_False:
lwz       r12, 0(r31)
b .CheckNoStopClock_Return

.CheckNoStopClock_True:
bl isPowerStarGetDemoActive__2MRFv
cmpwi r3, 0
#If the star get cutscene is playing, kill the timer anyways
bne .CheckNoStopClock_False

b .CheckNoStopClock_DontStopClock
.GLE ENDADDRESS

.GLE ADDRESS endEvent__27CometEventExecutorTimeLimitFv +0x20
b .CheckNoStopClock
.CheckNoStopClock_Return:
.GLE ENDADDRESS
.GLE ADDRESS endEvent__27CometEventExecutorTimeLimitFv +0x48
.CheckNoStopClock_DontStopClock:
.GLE ENDADDRESS




.GLE ADDRESS isStageKoopaVs3__2MRFv
lis r3, PeachStarGet@ha
addi r3, r3, PeachStarGet@l
li r4, 0
b .MR_GetCurrentScenarioSetting

.IsScenarioNoBootOut:
#Unlike other situations, this function has a scenario passed into it
mr r4, r3
lis r3, NoBootOut@ha
addi r3, r3, NoBootOut@l
li r5, 0
b .MR_GetScenarioSetting

.GetPauseVol:
lis r3, PauseVol@ha
addi r3, r3, PauseVol@l
li r4, 0
li r5, 1
b .MR_GetCurrentScenarioSetting_Type


.GLE ASSERT isStageKoopaVs__2MRFv
.GLE ENDADDRESS







