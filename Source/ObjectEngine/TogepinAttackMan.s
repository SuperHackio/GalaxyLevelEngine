#Thank goodness this one doesn't need to change between GLE-V1 and GLE-V2

.GLE ADDRESS createNameObj<13TogepinScorer>__14NameObjFactoryFPCc_P7NameObj +0x14
li r3, 0xB0
.GLE ENDADDRESS

.GLE ADDRESS init__16TogepinAttackManFRC12JMapInfoIter +0x78
li r3, 0xB0
.GLE ENDADDRESS

.GLE ADDRESS init__13TogepinScorerFRC12JMapInfoIter +0x198
#Obj Args
b .TogepinArgs
.TogepinArgsReturn:
.GLE ENDADDRESS

#This might only work because Togepin is lower in the alphabet than MameMuimui
.GLE ADDRESS .SUPER_SPIN_DRIVER_CONNECTOR
.TogepinArgs:
li r3, 0x1388 #5000
stw r3, 0xA8(r26)

mr        r3, r27
addi r4, r26, 0xA8
bl getJMapInfoArg0NoInit__2MRFRC12JMapInfoIterPl

mr        r3, r27
addi r4, r26, 0xAC
bl getJMapInfoArg7NoInit__2MRFRC12JMapInfoIterPl

li r3, 0
lwz r4, 0xAC(r26)
b .TogepinArgsReturn


.TogepinSetScore:
lwz r4, 0xAC(r31)
b setBestScoreAttackCurrentStage__16GameDataFunctionFv

.GLE PRINTADDRESS
.TOGEPIN_ATTACK_MAN_CONNECTOR:
.GLE ENDADDRESS

#Load the requested score
.GLE ADDRESS init__13TogepinScorerFRC12JMapInfoIter +0x1A8
lwz r5, 0xA8(r26)
.GLE ENDADDRESS

.GLE ADDRESS updateHighScore__13TogepinScorerFv +0x50
bl .TogepinSetScore
.GLE ENDADDRESS