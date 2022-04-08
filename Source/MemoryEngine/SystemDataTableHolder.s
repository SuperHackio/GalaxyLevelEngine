#======== Strings ========
.GLE ADDRESS SystemDataTableHolder_Strings
SystemDataTable_arc:
    .string "/ObjectData/SystemDataTable.arc"

#The only one named the same from vanilla SMG2
HeapSizeExcept:
    .string "/HeapSizeExcept.bcsv"
    
GalaxyOrderList:
    .string "/GalaxyOrderList.bcsv"
    
GameEventValueTable:
    .string "/GameEventValueTable.bcsv"
    
GameSettings:
    .string "/GameSettings.bcsv"
    
HubworldEventDataTable:
    .string "/HubworldEventDataTable.bcsv"
    
HubworldStarReturnDataTable:
    .string "/HubworldStarReturnDataTable.bcsv"

SavePointList:
    .string "/SavePointList.bcsv" AUTO
    
#.GLE ASSERT 0x806FAE78
.GLE ENDADDRESS

#======== Code ========
.GLE ADDRESS init__20GameSystemDataHolderFv
stwu      r1, -0x20(r1)
mflr      r0
stw       r0, 0x24(r1)
addi      r11, r1, 0x20
bl        _savegpr_28
mr        r28, r3
lis       r31, SystemDataTable_arc@ha
addi      r31, r31, SystemDataTable_arc@l
addi      r3, r31, 0
bl        mountAsyncArchive__2MRFPCc
lwz       r12, 0(r3)
mr        r29, r3
addi      r4, r31, HeapSizeExcept - SystemDataTable_arc
lwz       r30, 0(r28)
lwz       r12, 0x14(r12)
mtctr     r12
bctrl
mr        r4, r3
mr        r3, r30
bl        attach__8JMapInfoFPCv
lwz       r12, 0(r29)
mr        r3, r29
addi      r4, r31, SavePointList - SystemDataTable_arc
lwz       r30, 4(r28)
lwz       r12, 0x14(r12)
mtctr     r12
bctrl
mr        r4, r3
mr        r3, r30
bl        attach__8JMapInfoFPCv
lwz       r12, 0(r29)
mr        r3, r29
addi      r4, r31, HubworldEventDataTable - SystemDataTable_arc
lwz       r30, 8(r28)
lwz       r12, 0x14(r12)
mtctr     r12
bctrl
mr        r4, r3
mr        r3, r30
bl        attach__8JMapInfoFPCv
lwz       r12, 0(r29)
mr        r3, r29
addi      r4, r31, HubworldStarReturnDataTable - SystemDataTable_arc
lwz       r30, 0xC(r28)
lwz       r12, 0x14(r12)
mtctr     r12
bctrl
mr        r4, r3
mr        r3, r30
bl        attach__8JMapInfoFPCv
lwz       r12, 0(r29)
mr        r3, r29
addi      r4, r31, GalaxyOrderList - SystemDataTable_arc
lwz       r30, 0x10(r28)
lwz       r12, 0x14(r12)
mtctr     r12
bctrl
mr        r4, r3
mr        r3, r30
bl        attach__8JMapInfoFPCv
lwz       r12, 0(r29)
mr        r3, r29
addi      r4, r31, GameSettings - SystemDataTable_arc
lwz       r30, 0x14(r28)
lwz       r12, 0x14(r12)
mtctr     r12
bctrl
mr        r4, r3
mr        r3, r30
bl        attach__8JMapInfoFPCv
lwz       r12, 0(r29)
mr        r3, r29
addi      r4, r31, GameEventValueTable - SystemDataTable_arc
lwz       r30, 0x18(r28)
lwz       r12, 0x14(r12)
mtctr     r12
bctrl
mr        r4, r3
mr        r3, r30
bl        attach__8JMapInfoFPCv
addi      r11, r1, 0x20
bl        _restgpr_28
lwz       r0, 0x24(r1)
mtlr      r0
addi      r1, r1, 0x20
blr
#.GLE ASSERT 0x804B7218
.GLE ENDADDRESS

#TODO: Optimize the above code maybe...