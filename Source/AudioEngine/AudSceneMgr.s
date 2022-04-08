
.GLE ADDRESS startScene__11AudSceneMgrFv +0x44
#Use the AudioEffectArea bruh
nop
.GLE ENDADDRESS







#Remove some "required files"
.GLE ADDRESS sub_804BA470
li r3, 0
blr
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
