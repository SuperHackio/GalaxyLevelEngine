
.GLE ADDRESS startScene__11AudSceneMgrFv +0x44
#Use the AudioEffectArea bruh
nop
.GLE ENDADDRESS






#This function normally checks to see if you are in a specific stage or not, and if you are in the specific stages, it just returns 0.
#Because these specific stages don't stop the music that's playing when you leave them
#For now, I am going to default this to 1 (with a hardcoded exception for the fileselect), but perhaps this could be deletaged to a ScenarioSetting?
.GLE ADDRESS sub_804BA470
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)

bl isStageFileSelect__2MRFv
cmpwi r3, 0
bne .IsNeedStopAllBGM_False




#Other conditions go here!




#default option
b .IsNeedStopAllBGM_True


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
