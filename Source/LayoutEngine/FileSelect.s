#Always show the lives counter
.GLE ADDRESS getMissCount__12FileSelectorCFl +0x10
nop
.GLE ENDADDRESS

.GLE ADDRESS reflectMissCounter__14FileSelectInfoFv +0x20
nop
.GLE ENDADDRESS


#The ability to change the messages that get displayed on the file select
.GLE ADDRESS reflectTrySetSpecialMessage__14FileSelectInfoFv
#Some extra space
stwu      r1, -0x20(r1)
mflr      r0
stw       r0, 0x24(r1)
addi      r11, r1, 0x20
bl _savegpr_28

mr r31, r3

bl MR_GetGameSettingsJMap
mr r30, r3

lwz r29, 0x30(r31)  #Star Count
li r28, 0
b .Message_LoopStart

#May as well use this space
.Message_Return:
addi      r11, r1, 0x20
bl _restgpr_28
lwz       r0, 0x24(r1)
mtlr      r0
addi      r1, r1, 0x20
blr

.GLE ASSERT __ct__Q217FileSelectInfoSub10SlideStateFP14FileSelectInfo
.GLE ENDADDRESS

.GLE ADDRESS .ALLSTARLIST_CONNECTOR

.Message_Loop:
#Iterate each BCSV Entry to find message entries
addi r3, r1, 0x08
mr r4, r30
lis r5, Type@ha
addi r5, r5, Type@l
mr r6, r28
bl getCsvDataStr__2MRFPPCcPC8JMapInfoPCcl

lwz r3, 0x08(r1)
lis r4, MessageStr@ha
addi r4, r4, MessageStr@l
bl isEqualString__2MRFPCcPCc
cmpwi r3, 0
beq .Message_LoopContinue

#We have a message entry!
addi r3, r1, 0x08
mr r4, r30
lis r5, Param00Int@ha
addi r5, r5, Param00Int@l
mr r6, r28
bl getCsvDataS32__2MRFPlPC8JMapInfoPCcl

#Check to see if the Star Count is greater than or equal to the requested amount
lwz r3, 0x08(r1)
cmpw r29, r3
blt .Message_LoopContinue

#Check passed! Set the message
addi r3, r1, 0x08
mr r4, r30
lis r5, Data@ha
addi r5, r5, Data@l
mr r6, r28
bl getCsvDataStrOrNULL__2MRFPPCcPC8JMapInfoPCcl

lwz r3, 0x08(r1)
cmpwi r3, 0
#Invalid if null pointer
beq .Message_LoopContinue

mr r5, r3
mr r3, r31
lis r4, FileSelectInfo_Message@ha
addi r4, r4, FileSelectInfo_Message@l
bl setTextBoxGameMessageRecursive__2MRFP11LayoutActorPCcPCc

.Message_LoopContinue:
addi r28, r28, 1
.Message_LoopStart:
mr r3, r30
bl getCsvDataElementNum__2MRFPC8JMapInfo
cmpw r28, r3
blt .Message_Loop

b .Message_Return

MessageStr:
    .string "Message"
    
PlayerLeft_Setting:
    .string "PlayerLeft"
    
Player_Setting:
    .string "Player"
    
Luigi_Setting:
    .string "Luigi" AUTO
    
.GLE PRINTADDRESS


.GLE ADDRESS initializeData__20GameDataPlayerStatusFv
b .NewSetPlayerStatus
.GLE ENDADDRESS

.GLE ADDRESS sub_804DE190 +0x0C
#side effect of allowing lives to be saved and restored
nop
.GLE ENDADDRESS

.NewSetPlayerStatus:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)

mr r31, r3

lis r3, PlayerLeft_Setting@ha
addi r3, r3, PlayerLeft_Setting@l
li r4, 0
bl .MR_GetGameSetting
stb       r3, 8(r31)

li r0, 0
sth       r0, 0xA(r31)
sth       r0, 0xC(r31)
sth       r0, 0xE(r31)
stb       r0, 0x10(r31)
stw       r0, 0x14(r31)

lis r3, Player_Setting@ha
addi r3, r3, Player_Setting@l
li r4, 2
bl .MR_GetGameSetting

lis r4, Luigi_Setting@ha
addi r4, r4, Luigi_Setting@l
bl isEqualString__2MRFPCcPCc
cmpwi r3, 0
beq .SkipPlayer
lbz       r0, 0x10(r31)
ori       r0, r0, 1
stb       r0, 0x10(r31)
.SkipPlayer:
#dunno if this is needed or not
mr r3, r31

lwz       r31, 0x0C(r1)
lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr

#END WORLDMAP CODE
.FILE_SELECT_CONNECTOR:
.GLE ENDADDRESS