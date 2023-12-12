
.GLE ADDRESS startScene__11AudSceneMgrFv +0x44
#Use the AudioEffectArea bruh
nop
.GLE ENDADDRESS

#This fixes the "ReturnBgm" BCSV field inside DemoSound
#Don't have anywhere else to put this so I'm putting it here since it's audio related.
#It was a very dumb mistake by Nintendo -- The read the BCSV as a 4 byte value, but only ever process the 1st of the 4 bytes.
#"ReturnBgm" was never used in SMG1 so I assume they didn't know it was broken because they didn't try to use it.
#For some reason, there's a copy involved, so I "fixed" the copy creation function to read the original as a 4 byte value and then save as a 1 byte value.
#The proper fix would've been to use a function that does not exist in SMG/2
.GLE ADDRESS sub_8013A180 +0x34
lwz r0, 0x10(r4)
.GLE ENDADDRESS

#This function normally checks to see if you are in a specific stage or not, and if you are in the specific stages, it just returns 0.
#Because these specific stages don't stop the music that's playing when you leave them
#For now, I am going to default this to 1 (with a hardcoded exception for the fileselect), but perhaps this could be delegated to a ScenarioSetting?
.GLE ADDRESS sub_804BA470
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)

bl isDestroySceneKeepAllSound__2MRFv
cmpwi r3, 0
bne .IsNeedStopAllBGM_False

bl isStageFileSelect__2MRFv
cmpwi r3, 0
bne .IsNeedStopAllBGM_False
li r3, 1


#Other conditions go here!

#Hooked conditions go here!

.GLE PRINTMESSAGE == GLE_isDestroySceneKeepAllSound Address ==
.GLE PRINTADDRESS
nop



#default option
b .IsNeedStopAllBGM_Return


.IsNeedStopAllBGM_False:
li r3, 0
b .IsNeedStopAllBGM_Return

.IsNeedStopAllBGM_True:
li r3, 1

.IsNeedStopAllBGM_Return:
lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr
.GLE ASSERT sub_804BA470 +0x8C
.GLE ENDADDRESS






.GLE ADDRESS sub_804BC260 +0x20
nop
.GLE ENDADDRESS

.GLE ADDRESS stageClear__9GameSceneFv +0x5C
li r3, 0
.GLE ENDADDRESS

.GLE ADDRESS loadStaticResource__11AudSceneMgrFv +0x58
b .AudSceneMgr_LoadStaticContinue
.GLE ENDADDRESS

.GLE ADDRESS loadStaticResource__11AudSceneMgrFv +0x88
.AudSceneMgr_LoadStaticContinue:
.GLE ENDADDRESS



.GLE ADDRESS sub_8008A430 +0x24
nop
.GLE ENDADDRESS
