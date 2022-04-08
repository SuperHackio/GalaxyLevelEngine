#Fixes the comet medal from always appearing on scenario 1

.GLE ADDRESS isAppearInCurrentScenario__17CometMedalCounterCFv
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)

lis r3, TicoCoin_Jap@ha
addi r3, r3, TicoCoin_Jap@l

bl find__13NameObjFinderFPCc
cmpwi r3, 0
beq .isAppearInCurrentScenario_Return
li r3, 1

.isAppearInCurrentScenario_Return:
lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr

TicoCoin_Jap:
    .string "チココイン" AUTO
.GLE ASSERT exeAppear__17CometMedalCounterFv
.GLE ENDADDRESS

.GLE ADDRESS init__17CometMedalCounterFRC12JMapInfoIter +0x6C
#This one check always needs to return true.
li r3, 1
.GLE ENDADDRESS