# This is a new GLE-V4 feature where you can access the otherwise hardcoded MR::isStageStarPieceFollowGroupLimit via ScenarioSetting
# <=0 : Disabled. Any higher value means the starbits you can get will be limited to that amount. For example, if you set 101, you can only get 100 starbits from it, like in Good Egg 2.


# Just straight up overwrite the original function. May as well ¯\_(ツ)_/¯
.GLE ADDRESS beginFollowPieces__20StarPieceFollowGroupFv
stwu      r1, -0x20(r1)
mflr      r0
stw       r0, 0x24(r1)
addi      r11, r1, 0x20
bl        _savegpr_29

mr        r29, r3

bl isValidSwitchB__2MRFPC9LiveActor
cmpwi r3, 0
beq .beginFollowPieces_DoLimiterCheck

mr        r3, r29
bl isOnSwitchB__2MRFPC9LiveActor
cmpwi r3, 0
li r3, 0
bne .beginFollowPieces_Return

.beginFollowPieces_DoLimiterCheck:
# OK, here's where things change
# We're using a ScenarioSetting now, after all
bl getStarPieceNum__2MRFv
mr r31, r3

bl .GLE_getStageStarPieceFollowGroupLimit
subi r4, r3, 1
cmpwi r4, 0
lwz       r0, 0x98(r29)
blt .beginFollowPieces_SetSpawnStarPiece

cmpw r31, r4
li r3, 0
bge .beginFollowPieces_Return

subfc    r3, r31, r4  # Find how many remain before the limit is reached.
cmpw      r0, r3
blt .beginFollowPieces_SetSpawnStarPiece
mr        r0, r3  # Put the remainder in as the number of starbits to spawn

.beginFollowPieces_SetSpawnStarPiece:
stw       r0, 0x9C(r29)

.beginFollowPieces_SpawnStarPiece:
li        r30, 0
li        r31, 0
b         loc_80317C44

loc_80317C30:
lwz       r3, 0x90(r29)
lwzx      r3, r3, r31
bl        setFollowPlayerAndAppear__9StarPieceFv
addi      r30, r30, 1
addi      r31, r31, 4

loc_80317C44:
lwz       r4, 0x9C(r29)
cmplw     r30, r4
blt       loc_80317C30
mr        r3, r29
bl        placementPiece__20StarPieceFollowGroupFl
li        r3, 1

.beginFollowPieces_Return:
addi      r11, r1, 0x20
bl        _restgpr_29
lwz       r0, 0x24(r1)
mtlr      r0
addi      r1, r1, 0x20
blr
.GLE ASSERT placementPiece__20StarPieceFollowGroupFl
.GLE ENDADDRESS