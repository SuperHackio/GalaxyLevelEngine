#Out of the 3 monkeys in this game, the ScoreAttackMan is probably the one with the least changes made to it

.GLE ADDRESS hasRecordedScoreInScenario__2MRFi
#Just overwrite the original function. It's large enough to do so.
stwu      r1, -0x30(r1)
mflr      r0
stw       r0, 0x34(r1)
addi      r11, r1, 0x30
bl        _savegpr_27

mr        r27, r3
bl makeCurrentGalaxyStatusAccessor__2MRFv
stw       r3, 0x08(r1)
mr        r4, r27
addi      r3, r1, 0x08
bl hasPowerStar__20GalaxyStatusAccessorCFl
cmpwi r3, 0
beq .hasRecordedScore_Return

#Thankfully this is possible now because of the fact that StageDataHolder will load the ScenarioSettings before
#we actually get to the ScenarioSelect.
lis r3, PlayAttackMan@ha
addi r3, r3, PlayAttackMan@l
mr r4, r27
li r5, 0
bl .MR_GetScenarioSetting
cmpwi r3, 0
beq .hasRecordedScore_Return

mr r3, r29
mr r4, r27
bl getBestScoreAttackCurrentStage__16GameDataFunctionFv
addic     r0, r3, -1
subfe     r3, r0, r3

.hasRecordedScore_Return:
addi      r11, r1, 0x30
bl        _restgpr_27
lwz       r0, 0x34(r1)
mtlr      r0
addi      r1, r1, 0x30
blr
.GLE ENDADDRESS

#Due to changes of how the GameEventValueChecker works, we'll need to branch to an alternative
#location in the GLE code so we don't have to re-write the entire chimp code.
#BTW don't put The Chimp in levels as a secret star.

.GLE ADDRESS isBeatHighScore__18ScoreAttackCounterFv +0x1C
bl .getGalaxyHighScoreOnCurrentScenario
.GLE ENDADDRESS

.GLE ADDRESS updateHighScore__18ScoreAttackCounterFv +0x24
bl .getGalaxyHighScoreOnCurrentScenario
.GLE ENDADDRESS

.GLE ADDRESS init__18ScoreAttackCounterFRC12JMapInfoIter +0x64
bl .getGalaxyHighScoreOnCurrentScenario
.GLE ENDADDRESS


.GLE ADDRESS updateHighScore__18ScoreAttackCounterFv +0x40
bl .setGalaxyHighScoreOnCurrentScenario
.GLE ENDADDRESS