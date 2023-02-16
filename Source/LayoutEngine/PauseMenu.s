.GLE ADDRESS init__9PauseMenuFRC12JMapInfoIter +0x27C
bl isInvalidBackMarioFaceShipOrWorldMap__23@unnamed@PauseMenu_cpp@Fv
.GLE ENDADDRESS

.GLE ADDRESS init__9PauseMenuFRC12JMapInfoIter +0x310
#Always hide the world pane
#It's pretty much completely useless
nop
.GLE ENDADDRESS

.GLE ADDRESS init__9PauseMenuFRC12JMapInfoIter +0x94
li r3, 2
.GLE ENDADDRESS



.GLE ADDRESS enterPauseMenu__9AudSystemFv +0x18
bl .GetPauseVol
li r0, 1
stw       r0, 0x990(r31)
.GLE ENDADDRESS

.GLE ADDRESS enterPauseMenu__9AudSystemFv +0x34
bl .GetPauseVol
.GLE ENDADDRESS

.GLE ADDRESS updatePauseMenu__9AudSystemFv +0x54
b .AudSystem_DoPauseVol_GLE
.AudSystem_DoPauseVol_GLE_Return:
.GLE ENDADDRESS

.GLE ADDRESS makeActorDead__23MarioFacePlanetPreviousFv
.AudSystem_DoPauseVol_GLE:
bl .GetPauseVol
#if the volume is set to 0.0f, then do the normal pause
stfs f1, 0x08(r1)
lwz r3, 0x08(r1)
cmpwi r3, 0
bne .AudSystem_DoPauseVol_GLE_CustomVol
#Volume is 0.0f, pause music like vanilla
mr r3, r31
bl pause__9AudSystemFv
b .AudSystem_DoPauseVol_GLE_Return

.AudSystem_DoPauseVol_GLE_CustomVol:
#== Don't think this code is needed... ==
#volume is not 0.0, MoveVolume to custom
#li r3, 60 # Time it takes for the volume to move
#f1 is already hosting the number we want!
#bl moveVolumeStageBGM__2MRFfUl
b .AudSystem_DoPauseVol_GLE_Return
.GLE ENDADDRESS