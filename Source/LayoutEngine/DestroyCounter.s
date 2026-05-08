.GLE ADDRESS .ALLSTARLIST_CONNECTOR


.GLE ADDRESS init__14DestroyCounterFRC12JMapInfoIter +0xDC
b .GLE_DestroyCounter_Init_ExtPaneControl
.GLE ENDADDRESS
.GLE ADDRESS init__14DestroyCounterFRC12JMapInfoIter +0x114
.GLE_DestroyCounter_Init_ExtPaneControl_Return:
.GLE ENDADDRESS

.GLE_DestroyCounter_NumberFormat:
    .string "%d"
.GLE_DestroyCounter_ShaTarget:
    .string "ShaTarget"
.GLE_DestroyCounter_ShaTargetNumber:
    .string "ShaTargetNumber" AUTO
.GLE_DestroyCounter_FullWidthSolidus:
    .int 0xFF0F0000


.GLE_DestroyCounter_Init_ExtPaneControl:
mr r3, r30
lis r4, .GLE_DestroyCounter_ShaTarget@ha
addi r4, r4, .GLE_DestroyCounter_ShaTarget@l
lis r5, .GLE_DestroyCounter_FullWidthSolidus@ha
addi r5, r5, .GLE_DestroyCounter_FullWidthSolidus@l
bl setTextBoxMessageRecursive__2MRFP11LayoutActorPCcPCw

# Does it look like I need *your* power?
# *makes a literally inlined function*
# Just pretend that the LR save is here lol
stwu      r1, -0x50(r1)

lwz r6, 0x2C(r30)

addi r3, r1, 0x08
li r4, 0x08  # Yes this is double the size I would technically need but.... whatever
lis       r5, .GLE_DestroyCounter_NumberFormat@ha
addi      r5, r5, .GLE_DestroyCounter_NumberFormat@l
crclr     4*cr1+eq
bl         snprintf

addi r3, r1, 0x08
addi r4, r1, 0x10
bl .GLE_ConvertNumberStringToFullWidth

mr r3, r30
lis r4, .GLE_DestroyCounter_ShaTargetNumber@ha
addi r4, r4, .GLE_DestroyCounter_ShaTargetNumber@l
addi r5, r1, 0x10
bl setTextBoxMessageRecursive__2MRFP11LayoutActorPCcPCw

addi      r1, r1, 0x50

b .GLE_DestroyCounter_Init_ExtPaneControl_Return

.DESTROYCOUNTER_CONNECTOR:
.GLE ENDADDRESS