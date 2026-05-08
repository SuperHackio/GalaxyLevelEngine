# This file allows the PurpleCoinCounter to be automatically updated to match the new Purple Coin amount ScenarioSetting

# ShaTarget and TxtTarget always need to hold the character ／ which is 0xFF0F (Fullwidth Solidus)
# ShaTargetNumber and TxtTargetNumber need to hold the target amount of Purple Coins in Fullwidth format, like ２５６
# There is a new animation MoveTarget.brlan that has 3 frames: Frame 0 is for single digit, 1 is for two digit and 2 for three digit

.GLE ADDRESS .PAUSE_MENU_CONNECTOR
.GLE PRINTADDRESS

.GLE ADDRESS init__17PurpleCoinCounterFRC12JMapInfoIter +0x34
b .GLE_PurpleCoinCounter_Init_ExtPaneControl
.GLE_PurpleCoinCounter_Init_ExtPaneControl_Return:
.GLE ENDADDRESS

.GLE_PurpleCoinCounter_NumberFormat:
    .string "%d"
.GLE_PurpleCoinCounter_ShaTarget:
    .string "ShaTarget"
.GLE_PurpleCoinCounter_ShaTargetNumber:
    .string "ShaTargetNumber" AUTO
.GLE_PurpleCoinCounter_FullWidthSolidus:
    .int 0xFF0F0000


.GLE_PurpleCoinCounter_Init_ExtPaneControl:
bl createAndAddPaneCtrl__2MRFP11LayoutActorPCcUl

#mr r3, r31
#lis r4, .GLE_PurpleCoinCounter_ShaTarget@ha
#addi r4, r4, .GLE_PurpleCoinCounter_ShaTarget@l
#li r5, 1
#bl createAndAddPaneCtrl__2MRFP11LayoutActorPCcUl
#
#mr r3, r31
#lis r4, .GLE_PurpleCoinCounter_ShaTargetNumber@ha
#addi r4, r4, .GLE_PurpleCoinCounter_ShaTargetNumber@l
#li r5, 1
#bl createAndAddPaneCtrl__2MRFP11LayoutActorPCcUl

mr r3, r31
lis r4, .GLE_PurpleCoinCounter_ShaTarget@ha
addi r4, r4, .GLE_PurpleCoinCounter_ShaTarget@l
lis r5, .GLE_PurpleCoinCounter_FullWidthSolidus@ha
addi r5, r5, .GLE_PurpleCoinCounter_FullWidthSolidus@l
bl setTextBoxMessageRecursive__2MRFP11LayoutActorPCcPCw

# Does it look like I need *your* power?
# *makes a literally inlined function*
# Just pretend that the LR save is here lol
stwu      r1, -0x50(r1)

bl .GLE_GetPurpleCoinNumScenarioSetting
mr r6, r3

addi r3, r1, 0x08
li r4, 0x08  # Yes this is double the size I would technically need but.... whatever
lis       r5, .GLE_PurpleCoinCounter_NumberFormat@ha
addi      r5, r5, .GLE_PurpleCoinCounter_NumberFormat@l
crclr     4*cr1+eq
bl         snprintf

addi r3, r1, 0x08
addi r4, r1, 0x10
bl .GLE_ConvertNumberStringToFullWidth

mr r3, r31
lis r4, .GLE_PurpleCoinCounter_ShaTargetNumber@ha
addi r4, r4, .GLE_PurpleCoinCounter_ShaTargetNumber@l
addi r5, r1, 0x10
bl setTextBoxMessageRecursive__2MRFP11LayoutActorPCcPCw

addi      r1, r1, 0x50

b .GLE_PurpleCoinCounter_Init_ExtPaneControl_Return







.PURPLE_COIN_COUNTER_CONNECTOR:
.GLE ENDADDRESS