#Change a value from a bool to an int. (the other bytes aren't in use by anything anyways)

.GLE ADDRESS __ct__23PlayResultInStageHolderFv +0xA0
stw r5, 0x88(r29)  #changing this to be a bitfield. If a bit is set, that star is now bronze
.GLE ENDADDRESS


.GLE ADDRESS createNameObj<12SuperDreamer>__14NameObjFactoryFPCc_P7NameObj +0x14
li        r3, 0x1E8   #We just need a bit more for the new Obj Arg 7
.GLE ENDADDRESS


.GLE ADDRESS sub_804D7EE0
#r3 = Power Star Id
.MR_IsSuperDreamerStarBronze:
mflr      r5
subi r4, r3, 1
bl .GLE_GetPlayResultInStageHolder
lwz r3, 0x88(r3)
sraw r4, r3, r4
rlwinm r3, r4, 0, 31, 31
mtlr      r5
blr
#there's 12 lines availible here
#.GLE ASSERT 0x804D7F10
.GLE ENDADDRESS


.GLE ADDRESS reset__23PlayResultInStageHolderFv +0xAC
#Clear the bronze star flags upon reset
stw       r31, 0x88(r30)
.GLE ENDADDRESS


.GLE ADDRESS clearAfterMiss__23PlayResultInStageHolderFv +0x30
#Clear the bronze star flags after death
stw       r5, 0x88(r3)
.GLE ENDADDRESS


#This function is poorly named as it only applies to SuperDreamer
.GLE ADDRESS initPlayerHealth__23PlayResultInStageHolderFv
#r3 = PlayResultInStageHolder*
#r4 = int "SuperDreamer new Obj Arg 7"
.GLE_InitPlayResultSuperDreamer:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)

mr        r31, r3

lwz r5, 0x88(r31)
or r5, r4, r5  #Update the stars flag
stw r5, 0x88(r31)

li r5, 2
stw r5, 0x84(r31)

li r0, 0
stb r0, 0x74(r31)

bl getPlayerLife__2MRFv
cmpwi     r3, 3
li        r0, 3
ble       loc_804C93B0
li        r0, 6

loc_804C93B0:
stw       r0, 0x78(r31)

lwz       r31, 0x0C(r1)
lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr
#.GLE ASSERT 0x804C93D0
.GLE ENDADDRESS


.GLE ADDRESS sub_804D7C40
#Just gonna replace this completely even though it's just vanilla code still
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
stw       r30, 0x08(r1)
mr        r31, r4
mr        r30, r3
bl .GLE_GetPlayResultInStageHolder
lwz r4, 0x1E4(r30)
bl        .GLE_InitPlayResultSuperDreamer
mr        r3, r30
mr        r4, r31
bl        requestChangeStageDreamer__2MRFP7UNKNOWNl
lwz       r0, 0x14(r1)
lwz       r31, 0x0C(r1)
lwz       r30, 0x08(r1)
mtlr      r0
addi      r1, r1, 0x10
blr
.GLE ENDADDRESS


.GLE ADDRESS .NPC_UTILITY_CONNECTOR


.GLE ADDRESS init__12SuperDreamerFRC12JMapInfoIter +0x90
b .SuperDreamer_Init_ReadArg7
.SuperDreamer_Init_ReadArg7_Return:
.GLE ENDADDRESS

.SuperDreamer_Init_ReadArg7:
bl getJMapInfoArg0NoInit__2MRFRC12JMapInfoIterPl

#Brand new Arg 7 will determine which stars get turned to bronze. Default -1 for "All Stars
li r5, -1
stw r5, 0x1E4(r29)

mr        r3, r30
addi      r4, r29, 0x1E4
bl getJMapInfoArg7NoInit__2MRFRC12JMapInfoIterPl
b .SuperDreamer_Init_ReadArg7_Return



.GLE ADDRESS endStage__18ScenePlayingResultFv +0x44
bl .__endStage_IsStarBronze
.GLE ENDADDRESS

.GLE ADDRESS endStage__18ScenePlayingResultFv +0x80
bl .__endStage_IsStarBronze
.GLE ENDADDRESS

.GLE ADDRESS endStage__18ScenePlayingResultFv +0xC8
bl .__endStage_IsStarBronze
.GLE ENDADDRESS


.__endStage_IsStarBronze:
subi r4, r28, 1
lwz r3, 0x88(r27)

#r3 = Flags value
#r4 = PowerStarID
.__Decide_IsBronze:
sraw r4, r3, r4
rlwinm r3, r4, 0, 31, 31
mr r0, r3   #The game wants it in r0 each time phew
blr




.GLE ADDRESS sub_804D8690 +0x70
bl .__sub_804D8690_SetStarBronze
.GLE ENDADDRESS

.__sub_804D8690_SetStarBronze:
subi r4, r28, 1
lwz r3, 0x88(r30)
b .__Decide_IsBronze

.SUPERDREAMER_CONNECTOR:
.GLE ENDADDRESS
