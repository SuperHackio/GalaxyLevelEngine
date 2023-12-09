.GLE ADDRESS __ct__15StageDataHolderFPCcib -0x04
#StageDataHolder::StageDataHolder((char const *, int, bool))
.StageDataHolder_Ctor:
stwu      r1, -0x20(r1)
mflr      r0
stw       r0, 0x24(r1)
addi      r11, r1, 0x20
bl _savegpr_28
mr        r29, r4
mr        r28, r3
mr        r30, r5
mr        r31, r6
lis r4, StageDataHolder@ha
addi r4, r4, StageDataHolder@l
bl __ct__7NameObjFPCc
lis       r3, __vt__15StageDataHolder@ha
addi      r3, r3, __vt__15StageDataHolder@l

stw       r3, 0(r28)    # VTable*
li        r0, 0
stw       r0, 0x14(r28) # JMapInfo* "ObjNameTable"
stw       r0, 0x18(r28)
stw       r29, 0x7C(r28)
stw       r30, 0xB0(r28)
stb       r31, 0xB4(r28)
stw       r0, 0xB8(r28)
stw       r0, 0xBC(r28)
stw       r0, 0xC0(r28) # PlacementInfoOrdered*
stw       r0, 0xC4(r28) # GalaxyArchiveHolder*

addi      r3, r28, 0xC8 # MR::AssignableArray<JMapInfo>* "/jmp/Placement" & "jmp/MapParts"
bl initiate__Q22MR14BothDirPtrListFv

addi      r3, r28, 0xD4 # MR::AssignableArray<JMapInfo>* "/jmp/Start"
bl initiate__Q22MR14BothDirPtrListFv

addi      r3, r28, 0xE0 # MR::AssignableArray<JMapInfo>* "/jmp/GeneralPos"
bl initiate__Q22MR14BothDirPtrListFv

addi      r3, r28, 0xEC # MR::AssignableArray<JMapInfo>* "/jmp/Path"
bl initiate__Q22MR14BothDirPtrListFv

addi      r3, r28, 0xF8 # MR::AssignableArray<JMapInfo>* "/jmp/List"
bl initiate__Q22MR14BothDirPtrListFv

addi      r3, r28, 0x1C
li        r4, 0x60
bl zeroMemory__2MRFPvUl
addi      r3, r28, 0x80
bl identity__Q29JGeometry38TMatrix34<Q29JGeometry13SMatrix34C<f>>Fv

li        r3, 0x18
bl __nw__FUl
cmpwi     r3, 0
beq       .loc_8045B6A0
mr        r4, r29
bl __ct__19GalaxyArchiveHolderFPCc
.loc_8045B6A0:
stw       r3, 0xC4(r28)

lwz       r0, 0xB0(r28)
cmpwi     r0, 0
bne       .loc_8045B6C8

li        r3, 0x14
bl __nw__FUl
cmpwi     r3, 0
beq       .loc_8045B6C4
bl __ct__20PlacementInfoOrderedFv
.loc_8045B6C4:
stw       r3, 0xC0(r28)

.loc_8045B6C8:
addi      r11, r1, 0x20
mr        r3, r28
bl _restgpr_28
lwz       r0, 0x24(r1)
mtlr      r0
addi      r1, r1, 0x20
blr

.GLE ASSERT init__15StageDataHolderFRC12JMapInfoIter
.GLE ENDADDRESS

.GLE ADDRESS calcDataAddress__15StageDataHolderFv
#StageDataHolder::calcDataAddress((void))
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
mr        r31, r3
li        r4, -1
stw       r4, 0xB8(r3)
li        r0, 0
stw       r0, 0xBC(r3)
addi      r4, r3, 0xC8
bl updateDataAddress__15StageDataHolderFPCQ22MR26AssignableArray<8JMapInfo>
mr        r3, r31
addi      r4, r31, 0xD4
bl updateDataAddress__15StageDataHolderFPCQ22MR26AssignableArray<8JMapInfo>
mr        r3, r31
addi      r4, r31, 0xE0
bl updateDataAddress__15StageDataHolderFPCQ22MR26AssignableArray<8JMapInfo>
mr        r3, r31
addi      r4, r31, 0xEC
bl updateDataAddress__15StageDataHolderFPCQ22MR26AssignableArray<8JMapInfo>
lwz       r0, 0x14(r1)
lwz       r31, 0x0C(r1)
mtlr      r0
addi      r1, r1, 0x10
blr
.GLE ASSERT updateDataAddress__15StageDataHolderFPCQ22MR26AssignableArray<8JMapInfo>
.GLE ENDADDRESS

.GLE ADDRESS newEachObj__14SceneObjHolderFi +0x108
li r3, 0x108
.GLE ENDADDRESS

.GLE ADDRESS newEachObj__14SceneObjHolderFi +0x130
bl .StageDataHolder_Ctor
.GLE ENDADDRESS

.GLE ADDRESS createLocalStageDataHolder__15StageDataHolderFRCQ22MR26AssignableArray<8JMapInfo>b +0x8C
li r3, 0x108
.GLE ENDADDRESS

.GLE ADDRESS createLocalStageDataHolder__15StageDataHolderFRCQ22MR26AssignableArray<8JMapInfo>b +0xA8
bl .StageDataHolder_Ctor
.GLE ENDADDRESS


.GLE ADDRESS init__15StageDataHolderFRC12JMapInfoIter +0x94
#Check SceneUtility.s
b .InitListInfo
.InitListInfo_Return:
.GLE ENDADDRESS


#These belong here probably
.GLE ADDRESS sub_8045AA60 +0x18C
nop
.GLE ENDADDRESS

.GLE ADDRESS sub_8045AA60 +0xDC
nop
nop
nop
nop
.GLE ENDADDRESS





.GLE ADDRESS sub_8045AA60 +0x1D8
b .ArchiveHotswapping
.ArchiveHotswapping_ReturnNoSwap:
.GLE ENDADDRESS
.GLE ADDRESS sub_8045AA60 +0x208
.ArchiveHotswapping_ReturnYesSwap:
.GLE ENDADDRESS




.GLE ADDRESS .SCENEUTILITY_CONNECTOR
.ArchiveHotswapping:
addi      r3, r1, 0x18
lis r4, ResourceMask_Str@ha
addi r4, r4, ResourceMask_Str@l
bl searchItemInfo__8JMapInfoCFPCc
cmpwi r3, 0    #If the field is not present, just proceed as normal and pretend nothing happened
blt .ArchiveHotswapping_NoSwap

mr        r5, r3
mr        r4, r21
addi      r3, r1, 0x18
addi      r6, r1, 0x14
bl        getValueFast__8JMapInfoCFiiPPCc

lwz r3, 0x14(r1)
lis r4, NULLSTRING@ha
addi r4, r4, NULLSTRING@l
bl isEqualString__2MRFPCcPCc
cmpwi r3, 0
bne .ArchiveHotswapping_NoSwap


.ArchiveHotswapping_DoSwap:
#First up
#CHECK to see if the target has already been loaded. If it has been loaded already, DO NOT RELOAD IT.
#Dying is the only way that this would matter, but that's still rather important!!
lwz       r3, sInstance__29SingletonHolder_10FileLoader_ - STATIC_R13(r13)
mr r4, r30
bl isNeedToLoad__10FileLoaderCFPCc
cmpwi r3, 0
beq .ArchiveHotswapping_NoSwap

#Tell the file loader to load the mask instead of the actual file
#this is done normally
cmpwi     r27, 0
mr        r4, r25
beq       loc_8045AC4C 
mr        r4, r23
b         loc_8045AC58

loc_8045AC4C:
cmpwi     r26, 0
beq       loc_8045AC58
mr        r4, r24
loc_8045AC58:
lwz r3, 0x14(r1)
li        r5, 0
li        r6, 1
bl        mountAsyncArchive__2MRFPCcP7JKRHeap

lwz r3, 0x14(r1)
bl .GLE_GetFileHolderFileEntry
stw r3, 0x0C(r1)

cmpwi r3, 0  #Is this even possible?
nop

mr r3, r30
bl .GLE_CreateFileHash
lwz r4, 0x0C(r1)
stw r3, 0x00(r4)

#Hash replaced, Awesome.
#Now we need to update the read path that's stored
lwz       r3, sInstance__29SingletonHolder_10FileLoader_ - STATIC_R13(r13)
lwz r4, 0x14(r1)
bl getRequestFileInfoConst__10FileLoaderCFPCc
addi r3, r3, 0x08
mr r4, r30
bl strcpy


lwz       r3, sInstance__29SingletonHolder_10FileLoader_ - STATIC_R13(r13)
mr r4, r30
bl getRequestFileInfoConst__10FileLoaderCFPCc
lwz       r3, 0x8C(r3)
bl waitReadDone__19FileHolderFileEntryFv

b .ArchiveHotswapping_ReturnYesSwap

.ArchiveHotswapping_NoSwap:
cmpwi     r27, 0
b .ArchiveHotswapping_ReturnNoSwap








#r3 = Const Char* Filepath string
.GLE_GetFileHolderFileEntry:
stwu      r1, -0x110(r1)
mflr      r0
stw       r0, 0x114(r1)

mr        r5, r3
li        r4, 0x100
addi      r3, r1, 0x08
li        r6, 0
bl        convertPathToEntrynumConsideringLanguage__2MRFPCc

lwz       r3, sInstance__29SingletonHolder_10FileLoader_ - STATIC_R13(r13)
lwz       r3, 0x24(r3)
addi      r4, r1, 0x08
bl findEntry__10FileHolderCFPCc

lwz       r0, 0x114(r1)
mtlr      r0
addi      r1, r1, 0x110
blr

#r3 = Const Char* Filepath string
.GLE_CreateFileHash:
stwu      r1, -0x110(r1)
mflr      r0
stw       r0, 0x114(r1)

mr        r5, r3
li        r4, 0x100
addi      r3, r1, 0x08
li        r6, 0
bl        convertPathToEntrynumConsideringLanguage__2MRFPCc

addi      r3, r1, 0x08
#bl getBasename__2MRFPCc
bl getHashCodeLower__2MRFPCc

lwz       r0, 0x114(r1)
mtlr      r0
addi      r1, r1, 0x110
blr

.STAGEDATAHOLDER_CONNECTOR:
.GLE ENDADDRESS

