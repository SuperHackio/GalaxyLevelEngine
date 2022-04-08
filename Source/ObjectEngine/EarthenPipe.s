#Pipes don't update their materials in time for the Hubworld event system to allow them to change colours
#before the cutscene actually plays

#Lets fix that by replacing the (not used by EarthenPipe) NameObj::initAfterPlacement((void))
#Works rather nicely
.GLE ADDRESS __vt__11EarthenPipe +0x10
.int updateMaterial__2MRFP9LiveActor
.GLE ENDADDRESS