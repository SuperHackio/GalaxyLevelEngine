.GLE ADDRESS createStarString__2MRFPwiPCcbb
b .CreateStarString
.GLE ASSERT createStarString__2MRFPwiPCcbb +0x404
#haha 404
.GLE ENDADDRESS
.GLE ADDRESS .BGM_SETTING_INFO_CONNECTOR

#Checks to see if the galaxy string has a space - galaxy names won't ever have spaces in them.
.IsStarStringScenario:
b hasStringSpace__2MRFPCc

.CreateStarString:
stwu      r1, -0x40(r1)
mflr      r0
stw       r0, 0x44(r1)
addi      r11, r1, 0x40
bl _savegpr_25

mr        r27, r5
mr        r26, r3
mr        r28, r6
mr        r29, r7

mr        r3, r27
bl makeGalaxyStatusAccessor__2MRFPCc
stw       r3, 0x08(r1)

mr        r30, r26
li        r31, 1
b         .CreateStarString_Loop_Start

.CreateStarString_Loop:

mr r3, r30
mr r4, r27
mr r5, r31
bl .AddStarToStarString
mr r30, r3

.CreateStarString_Loop_Continue:
addi      r31, r31, 1

.CreateStarString_Loop_Start:
addi      r3, r1, 0x08
bl getPowerStarNum__20GalaxyStatusAccessorCFv
cmpw      r31, r3
ble       .CreateStarString_Loop

subf      r0, r26, r30
li        r3, 0
sth       r3, 0(r30)
srawi     r0, r0, 1
addze     r3, r0

addi      r11, r1, 0x40
bl _restgpr_25
lwz       r0, 0x44(r1)
mtlr      r0
addi      r1, r1, 0x40
blr

#--------------------------------------------------------

#r3 = WChar_T* Destination
#r4 = Galaxy name
#r5 = ScenarioNo
.AddStarToStarString:
stwu      r1, -0x40(r1)
mflr      r0
stw       r0, 0x44(r1)
addi      r11, r1, 0x40
bl _savegpr_25

mr r30, r3
mr r27, r4
mr r31, r5

mr        r3, r27
bl makeGalaxyStatusAccessor__2MRFPCc
stw       r3, 0x08(r1)

#get the colour of the power star.
li r3, 0
mr r4, r31
li r5, 0
mr r6, r27
li r7, 0
bl PowerStar_getColorInStage
mr r25, r3

addi      r3, r1, 0x08
mr r4, r31
bl hasPowerStar__20GalaxyStatusAccessorCFl
cmpwi r3, 0
beq .CreateStarString_Loop_NotHasPowerStar

addi      r3, r1, 0x08
mr r4, r31
bl hasPowerStarAsBronze__20GalaxyStatusAccessorCFl
cmpwi r3, 0
beq .CreateStarString_Loop_NotBronze

addi      r3, r1, 0x08
mr r4, r31
bl IsGrandStar
cmpwi r3, 0
beq .CreateStarString_NotGrandBronze
li r4, 0x75  #Force bronze Grand Star
b .CreateStarString_ApplyPowerStar

.CreateStarString_NotGrandBronze:
addi      r3, r1, 0x08
mr r4, r31
bl isStarComet__20GalaxyStatusAccessorCFl
cmpwi r3, 0
beq .CreateStarString_NotCometBronze

li r4, 0x7D  #Force Bronze power star
b .CreateStarString_ApplyPowerStar

.CreateStarString_NotCometBronze:
li r4, 0x72  #Force Bronze power star
b .CreateStarString_ApplyPowerStar


#===========

.CreateStarString_Loop_NotBronze:
addi      r3, r1, 0x08
mr r4, r31
bl IsGrandStar
cmpwi r3, 0
beq .CreateStarString_NotGrandStar

lis r3, GrandColorStart@ha
addi r3, r3, GrandColorStart@l
li r4, 0
bl .MR_GetGameSetting
add r4, r3, r25
b .CreateStarString_ApplyPowerStar


.CreateStarString_NotGrandStar:
addi      r3, r1, 0x08
mr r4, r31
bl isStarComet__20GalaxyStatusAccessorCFl
cmpwi r3, 0
beq .CreateStarString_NotComet

lis r3, CometColorStart@ha
addi r3, r3, CometColorStart@l
li r4, 0
bl .MR_GetGameSetting
add r4, r3, r25
b .CreateStarString_ApplyPowerStar


.CreateStarString_NotComet:
lis r3, StarColorStart@ha
addi r3, r3, StarColorStart@l
li r4, 0
bl .MR_GetGameSetting
add r4, r3, r25
b .CreateStarString_ApplyPowerStar

#===============

.CreateStarString_Loop_NotHasPowerStar:
addi      r3, r1, 0x08
mr r4, r31
bl isStarComet__20GalaxyStatusAccessorCFl
cmpwi r3, 0
bne .CreateStarString_StarRequireOpenFlag

addi      r3, r1, 0x08
mr r4, r31
bl isStarHiddenOrGreen__20GalaxyStatusAccessorCFv
cmpwi r3, 0
beq .CreateStarString_StarNotRequireOpenFlag


.CreateStarString_StarRequireOpenFlag:
addi      r3, r1, 0x08
mr r4, r31
bl isOpenScenario__20GalaxyStatusAccessorCFl
cmpwi r3, 0
mr r3, r30
beq .AddStarToStarString_Return

.CreateStarString_StarNotRequireOpenFlag:
addi      r3, r1, 0x08
mr r4, r31
bl isStarComet__20GalaxyStatusAccessorCFl
cmpwi r3, 0
bne .CreateStarString_StarIsOpen_Comet

addi      r3, r1, 0x08
mr r4, r31
bl isStarHiddenOrGreen__20GalaxyStatusAccessorCFv
cmpwi r3, 0
beq .CreateStarString_StarIsOpen

.CreateStarString_StarIsOpen_HiddenOrSeeker:
li r4, 0x71
b .CreateStarString_ApplyPowerStar

.CreateStarString_StarIsOpen_Comet:
li r4, 0x70
b .CreateStarString_ApplyPowerStar

.CreateStarString_StarIsOpen:
li r4, 0x6E


.CreateStarString_ApplyPowerStar:
mr r3, r30
bl addPictureFontCode__2MRFPwi

.AddStarToStarString_Return:

addi      r11, r1, 0x40
bl _restgpr_25
lwz       r0, 0x44(r1)
mtlr      r0
addi      r1, r1, 0x40
blr


#================================================


.GLE PRINTADDRESS
.ScenarioMode_Extension:
addi r3, r1, 0x0C
mr r4, r28
addi r5, r31, GalaxyPane - AllStarList_NewString
mr r6, r26
bl getCsvDataStr__2MRFPPCcPC8JMapInfoPCcl

lwz r3, 0x1C(r1)
addi      r4, r1, 0xB50
bl .GLE_GetGalaxyAndScenarioFromString
#Scenario = 0xB50
#Galaxy = 0xB54

addi      r3, r1, 0xB54
mr r25, r3
bl makeGalaxyStatusAccessor__2MRFPCc
stw r3, 0x08(r1)

addi r3, r1, 0x08
lwz r4, 0xB50(r1)
bl hasPowerStar__20GalaxyStatusAccessorCFl
cmpwi r3, 0
bne .ScenarioMode_ShowScenario

#The player doesn't already have a star here, lets see if
#it should show up or not
mr r3, r28
mr r4, r26
bl isJMapEntryProgressComplete
cmpwi r3, 0
beq .ScenarioMode_HideScenario

mr r3, r28
lis r4, PowerStarNum@ha
addi r4, r4, PowerStarNum@l
bl isExistItemInfo__8JMapInfoFPCc
cmpwi r3, 0
beq .ScenarioMode_ShowScenario

addi r3, r1, 0x10
mr r4, r28
lis r5, PowerStarNum@ha
addi r5, r5, PowerStarNum@l
mr r6, r26
bl getCsvDataS32__2MRFPlPC8JMapInfoPCcl

lwz r3, 0x10(r1)
cmpwi r3, -1
beq .ScenarioMode_HideScenario #Secret galaxies


.ScenarioMode_ShowScenario:
addi r3, r1, 0x10
mr r4, r28
addi r5, r31, StarPane - AllStarList_NewString
mr r6, r26
bl getCsvDataStr__2MRFPPCcPC8JMapInfoPCcl
addi r3, r1, 0x14
mr r4, r28
addi r5, r31, CompletePane - AllStarList_NewString
mr r6, r26
bl getCsvDataStrOrNULL__2MRFPPCcPC8JMapInfoPCcl
addi r3, r1, 0x18
mr r4, r28
addi r5, r31, MedalPane - AllStarList_NewString
mr r6, r26
bl getCsvDataStrOrNULL__2MRFPPCcPC8JMapInfoPCcl


#Alright, all parameters loaded. Lets do this

#First Up: Completion Status
#Unlike Galaxies, you don't need to have this icon for single scenarios
lwz r4, 0x14(r1)
cmpwi r4, 0
beq .ScenarioMode_SkipCompletion


addi r3, r1, 0x08
bl isCompleteAllScenario__20GalaxyStatusAccessorCFv
cmpwi r3, 0
beq .ScenarioMode_NotCompleteAllScenario
li r4, 0x50
b .ScenarioMode_AssignCompleteIcon

.ScenarioMode_NotCompleteAllScenario:
#Interuption - Bronze Stars will have no crown
addi r3, r1, 0x08
lwz r4, 0xB50(r1)
bl hasPowerStarAsBronze__20GalaxyStatusAccessorCFl
cmpwi r3, 0
bne .ScenarioMode_NotCompleteNormalScenario

addi r3, r1, 0x08
lwz r4, 0xB50(r1)
bl hasPowerStar__20GalaxyStatusAccessorCFl
cmpwi r3, 0
beq .ScenarioMode_NotCompleteNormalScenario
li r4, 0x6B
b .ScenarioMode_AssignCompleteIcon

.ScenarioMode_NotCompleteNormalScenario:
li r4, 0x20

.ScenarioMode_AssignCompleteIcon:
addi r3, r1, 0xC0
bl addPictureFontCode__2MRFPwi

mr r3, r30
lwz r4, 0x14(r1)
addi r5, r1, 0xC0
bl setTextBoxMessageRecursive__2MRFP11LayoutActorPCcPCw



#Now lets set the galaxy name
.ScenarioMode_SkipCompletion:
mr r3, r25
lwz r4, 0xB50(r1)
bl getScenarioNameOnCurrentLanguage__2MRFPCcl
cmpwi r3, 0
beq .ScenarioMode_HideScenario
mr r5, r3
mr r3, r30
lwz r4, 0x0C(r1)
bl setTextBoxMessageRecursive__2MRFP11LayoutActorPCcPCw

#Now lets make the "star string" (It's a single star)
addi r24, r1, 0x20
mr r3, r24
mr r4, r25
lwz r5, 0xB50(r1)
bl .AddStarToStarString
mr r23, r3

subf      r0, r24, r23
li        r3, 0
sth       r3, 0(r23)
srawi     r0, r0, 1
addze     r3, r0

mr r3, r30
lwz r4, 0x10(r1)
addi r5, r1, 0x20
bl setTextBoxMessageRecursive__2MRFP11LayoutActorPCcPCw

#And Finally, the Comet Medal Status
mr r3, r25
bl isOnGalaxyFlagTicoCoin__16GameDataFunctionFPCc
cmpwi r3, 0
li r4, 0x6F
beq .ScenarioMode_NoTicoCoin
li r4, 0x6A
.ScenarioMode_NoTicoCoin:
addi r3, r1, 0x14C
bl addPictureFontCode__2MRFPwi

mr r3, r30
lwz r4, 0x18(r1)
cmpwi r4, 0
beq .ScenarioMode_Continue #Stage has no comet medal!
addi r5, r1, 0x14C
bl setTextBoxMessageRecursive__2MRFP11LayoutActorPCcPCw
b .ScenarioMode_Continue

.ScenarioMode_HideScenario:
mr r3, r30
lwz r4, 0x0C(r1)
addi r5, r31, HideGalaxyText - AllStarList_NewString
bl setTextBoxGameMessageRecursive__2MRFP11LayoutActorPCcPCc

.ScenarioMode_Continue:
b .loadGalaxyNames_Loop_Continue

#.GLE ASSERT createStarString__2MRFPwiPCcbb +0x410


.GLE ADDRESS exeNextPage__11AllStarListFv +0x50
#We're not doing any saftey checks here as they should've been done already.
lwz       r3, 0x38(r31)
bl .AllStarList_GetOpenPageOnRight
stw       r3, 0x38(r31)
mr        r3, r31
.GLE ENDADDRESS

.GLE ADDRESS exePreviousPage__11AllStarListFv +0x50
#We're not doing any saftey checks here as they should've been done already.
lwz       r3, 0x38(r31)
bl .AllStarList_GetOpenPageOnLeft
stw       r3, 0x38(r31)
mr        r3, r31
.GLE ENDADDRESS

.AllStarList_GetOpenPageOnRight:
li r4, 1
b .AllStarList_GetOpenPageNext

.AllStarList_GetOpenPageOnLeft:
li r4, -1
b .AllStarList_GetOpenPageNext

#Tries to get the index of the first availible Page. Returns -1 if not found.
.AllStarList_GetOpenPageFirst:
li r3, 0
li r4, 1

#This function will get the next unlocked AllStarListPage.
#
#r3 = Current Page Index (NOT ZERO BASED! WE START AT 1 AND NOT 0)
#r4 = Direction (-1 = Left, 1 = Right)
#r5 = Disable Z check. Internal use. 0 = No, 1 = yes
#RETURNS: The index of the next located page. -1 if not found.
.AllStarList_GetOpenPageNext:
li r5, 0

.AllStarList_GetOpenPageNextWithZ:
stwu      r1, -0x40(r1)
mflr      r0
stw       r0, 0x44(r1)
addi      r11, r1, 0x40
bl _savegpr_25

mr r29, r3
mr r28, r4
mr r25, r5

bl MR_GetGalaxyOrderList
mr r31, r3

bl .GetMaxAllStarListPageNo
mr r30, r3


#Quick optimization:
#If we are on Page 1 (which is the absolute limit for leftward pages)
#we can just exit with -1 right away.
cmpwi r29, 1
bne .AllStarList_GetOpenPageNext_BeginSearch
cmpwi r28, -1
beq .AllStarList_GetOpenPageNext_ReturnNotFound


#Quick optimization:
#If we are on Page ??? (which would be the absolute limit for rightward pages)
#we can just exit with -1 right away.
cmpw r29, r30
bne .AllStarList_GetOpenPageNext_BeginSearch
cmpwi r28, 1
beq .AllStarList_GetOpenPageNext_ReturnNotFound


.AllStarList_GetOpenPageNext_BeginSearch:
#Interruption!
#If the player is holding [Z], then change the target to be the ends of the lists

cmpwi r25, 0
bne .AllStarList_GetOpenPageNext_StartSearch_Loc

li r3, 0
bl testSubPadButtonZ__2MRFl
cmpwi r3, 0
beq .AllStarList_GetOpenPageNext_StartSearch_Loc


#if we want the first open page, just use Zero lol
cmpwi r28, -1
bne .AllStarList_GetOpenPageNext_JumpRight
li r29, 0
li r28, 1
b .AllStarList_GetOpenPageNext_StartSearch_Loc

.AllStarList_GetOpenPageNext_JumpRight:
addi r29, r30, 1
li r28, -1

.AllStarList_GetOpenPageNext_StartSearch_Loc:
li r27, 0 #Page Max Index "i"
mr r26, r29 #CurrentTarget.
b .AllStarList_GetOpenPageNext_LoopA_IntroJumpLoc




.AllStarList_GetOpenPageNext_LoopA:
cmpwi r26, 0   #Zero is an invalid page, so if we get here, we didn't find it
ble .AllStarList_GetOpenPageNext_ReturnNotFound
cmpw r26, r30 #MaxPages > X is an invalid page, so if we get here, we didn't find it.
bgt .AllStarList_GetOpenPageNext_ReturnNotFound


mr r3, r26
mr r4, r31
bl .__AllStarList_IsExistPageLock_JMapIndex
cmpwi r3, 0
mr r3, r26
beq .AllStarList_GetOpenPageNext_Return


#mr r3, r26 #This instruction is just above
mr r4, r31
bl .__AllStarList_IsPageUnlocked
cmpwi r3, 0
mr r3, r26
bne .AllStarList_GetOpenPageNext_Return


.AllStarList_GetOpenPageNext_LoopAContinue:
addi r27, r27, 1

.AllStarList_GetOpenPageNext_LoopA_IntroJumpLoc:
cmpwi r28, 1
beq .AllStarList_GetOpenPageNext_AddOne
subi r26, r26, 1
b .AllStarList_GetOpenPageNext_LoopAStart

.AllStarList_GetOpenPageNext_AddOne:
addi r26, r26, 1

.AllStarList_GetOpenPageNext_LoopAStart:
cmpw r27, r30
blt .AllStarList_GetOpenPageNext_LoopA





.AllStarList_GetOpenPageNext_ReturnNotFound:
li r3, -1

.AllStarList_GetOpenPageNext_Return:
addi      r11, r1, 0x40
bl _restgpr_25
lwz       r0, 0x44(r1)
mtlr      r0
addi      r1, r1, 0x40
blr


#r3 = Page Entry to find
#r4 = JMapInfo* GalaxyOrderList.bcsv ptr
#RETURNS: 0 if it cannot be found, 1 if it can
.__AllStarList_IsPageUnlocked:
stwu      r1, -0x40(r1)
mflr      r0
stw       r0, 0x44(r1)
addi      r11, r1, 0x40
bl _savegpr_25

mr r31, r3  #target
mr r30, r4  #JMapInfo*

li r29, 0
b .__AllStarList_IsPageUnlocked_LoopStart

.__AllStarList_IsPageUnlocked_Loop:

addi r3, r1, 0x08
mr r4, r30
lis r5, PageNumber@ha
addi r5, r5, PageNumber@l
mr r6, r29
bl getCsvDataS32__2MRFPlPC8JMapInfoPCcl

lwz r3, 0x08(r1)
cmpw r3, r31
bne .__AllStarList_IsPageUnlocked_LoopContinue

addi r3, r1, 0x0C
mr r4, r30
lis r5, GalaxyName@ha
addi r5, r5, GalaxyName@l
mr r6, r29
bl getCsvDataStr__2MRFPPCcPC8JMapInfoPCcl

lwz r3, 0x0C(r1)
lis r4, NULLSTRING@ha
addi r4, r4, NULLSTRING@l
bl isEqualString__2MRFPCcPCc
cmpwi r3, 1
bne .__AllStarList_IsPageUnlocked_LoopContinue

#We found the entry!
#If this entry returns FALSE, we can keep looking to see if there is another entry for this page. This will act as our "OR functionality". GENIUS!!

mr r3, r30
mr r4, r29
bl isJMapEntryProgressComplete
cmpwi r3, 0
beq .__AllStarList_IsPageUnlocked_LoopContinue

b .__AllStarList_IsPageUnlocked_Return


.__AllStarList_IsPageUnlocked_LoopContinue:
addi r29, r29, 1
.__AllStarList_IsPageUnlocked_LoopStart:
mr r3, r30
bl getCsvDataElementNum__2MRFPC8JMapInfo
cmpw r29, r3
blt .__AllStarList_IsPageUnlocked_Loop

#Cannot be found!
li r3, 0

.__AllStarList_IsPageUnlocked_Return:
addi      r11, r1, 0x40
bl _restgpr_25
lwz       r0, 0x44(r1)
mtlr      r0
addi      r1, r1, 0x40
blr



.__AllStarList_IsExistPageLock_JMapIndex:
stwu      r1, -0x40(r1)
mflr      r0
stw       r0, 0x44(r1)
addi      r11, r1, 0x40
bl _savegpr_25

mr r31, r3  #target
mr r30, r4  #JMapInfo*


mr r31, r3  #target
mr r30, r4  #JMapInfo*

li r29, 0
b .__AllStarList_IsExistPageLock_JMapIndex_LoopStart

.__AllStarList_IsExistPageLock_JMapIndex_Loop:

addi r3, r1, 0x08
mr r4, r30
lis r5, PageNumber@ha
addi r5, r5, PageNumber@l
mr r6, r29
bl getCsvDataS32__2MRFPlPC8JMapInfoPCcl

lwz r3, 0x08(r1)
cmpw r3, r31
bne .__AllStarList_IsExistPageLock_JMapIndex_LoopContinue

addi r3, r1, 0x0C
mr r4, r30
lis r5, GalaxyName@ha
addi r5, r5, GalaxyName@l
mr r6, r29
bl getCsvDataStr__2MRFPPCcPC8JMapInfoPCcl

lwz r3, 0x0C(r1)
lis r4, NULLSTRING@ha
addi r4, r4, NULLSTRING@l
bl isEqualString__2MRFPCcPCc
cmpwi r3, 0
beq .__AllStarList_IsExistPageLock_JMapIndex_LoopContinue

#We found the entry!
li r3, 1
b .__AllStarList_IsExistPageLock_JMapIndex_Return


.__AllStarList_IsExistPageLock_JMapIndex_LoopContinue:
addi r29, r29, 1
.__AllStarList_IsExistPageLock_JMapIndex_LoopStart:
mr r3, r30
bl getCsvDataElementNum__2MRFPC8JMapInfo
cmpw r29, r3
blt .__AllStarList_IsExistPageLock_JMapIndex_Loop

#Cannot be found!
li r3, 0

.__AllStarList_IsExistPageLock_JMapIndex_Return:
addi      r11, r1, 0x40
bl _restgpr_25
lwz       r0, 0x44(r1)
mtlr      r0
addi      r1, r1, 0x40
blr







.GLE ADDRESS sub_8045DB80
b .NewAllStarListChangePager
.GLE ENDADDRESS


.NewAllStarListChangePager:
stwu      r1, -0x20(r1)
mflr      r0
stw       r0, 0x24(r1)
addi      r11, r1, 0x20
bl        _savegpr_29

mr        r29, r3

.TryTurnPageRight:
lwz       r4, 0x2C(r3)
lbz       r0, 0x24(r4)
cmpwi     r0, 0
beq .TryTurnPageLeft

#Try turning the page to the right:
lwz       r3, 0x38(r29)  #Current Page
li r4, 1
bl .AllStarList_GetOpenPageNext

cmpwi r3, -1
beq .RejectPageTurnRight

.AcceptPageTurnRight:
addi      r4, r13, (sInstance__Q214NrvAllStarList22AllStarListNrvPageNext - STATIC_R13)
b .DoPageTurnRight
.RejectPageTurnRight:
addi      r4, r13, (sInstance__Q214NrvAllStarList26AllStarListNrvPageNextOver - STATIC_R13)

.DoPageTurnRight:
mr        r3, r29
bl setNerve__11LayoutActorCFPC5Nerve
b .NewAllStarListChangePager_Return


.TryTurnPageLeft:
lwz       r4, 0x30(r3)
lbz       r0, 0x24(r4)
cmpwi     r0, 0
beq .TryBackButton

#Try turning the page to the right:
lwz       r3, 0x38(r29)  #Current Page
li r4, -1
bl .AllStarList_GetOpenPageNext

cmpwi r3, -1
beq .RejectPageTurnLeft

.AcceptPageTurnLeft:
addi      r4, r13, (sInstance__Q214NrvAllStarList26AllStarListNrvPagePrevious - STATIC_R13)
b .DoPageTurnLeft

.RejectPageTurnLeft:
addi      r4, r13, (sInstance__Q214NrvAllStarList30AllStarListNrvPagePreviousOver - STATIC_R13)


.DoPageTurnLeft:
mr        r3, r29
bl setNerve__11LayoutActorCFPC5Nerve
b .NewAllStarListChangePager_Return


.TryBackButton:
lwz       r3, 0x34(r3)
bl        sub_8045E9D0
cmpwi     r3, 0
beq .NewAllStarListChangePager_Return

lwz       r3, 0x34(r29)
bl        isHidden__10BackButtonCFv
cmpwi     r3, 0
beq       .NewAllStarListChangePager_Return
mr        r3, r29
addi      r4, r13, (unk_807D53B4 - STATIC_R13)
bl        setNerve__11LayoutActorCFPC5Nerve


.NewAllStarListChangePager_Return:
addi      r11, r1, 0x20
bl        _restgpr_29
lwz       r0, 0x24(r1)
mtlr      r0
addi      r1, r1, 0x20
blr



#Will take a page ID and inverse clamp it. This means that if the given page is locked, we'll find another page to go to. If there are no pages availible, return 0 for the Error page.
#r3 = PageID
#RETURNS: A new PageID
.AllStarList_InverseClampOrZero:
stwu      r1, -0x20(r1)
mflr      r0
stw       r0, 0x24(r1)
addi      r11, r1, 0x20
bl        _savegpr_29

mr        r29, r3
bl MR_GetGalaxyOrderList
mr r31, r3

bl .GetMaxAllStarListPageNo
mr r30, r3

cmpwi r29, -1
beq .AllStarList_InverseClampOrZero_StartHunting

mr r3, r29
mr r4, r31
bl .__AllStarList_IsExistPageLock_JMapIndex
cmpwi r3, 0
mr r3, r29
beq .AllStarList_InverseClampOrZero_Return

mr r3, r29
mr r4, r31
bl .__AllStarList_IsPageUnlocked
cmpwi r3, 0
mr r3, r29
bne .AllStarList_InverseClampOrZero_Return

.AllStarList_InverseClampOrZero_StartHunting:
#Hunt left first, then right.
mr r3, r29
bl .AllStarList_GetOpenPageOnLeft
cmpwi r3, -1
bne .AllStarList_InverseClampOrZero_Return

mr r3, r29
bl .AllStarList_GetOpenPageOnRight
cmpwi r3, -1
bne .AllStarList_InverseClampOrZero_Return

li r3, 0 #Can't find anything rip.

.AllStarList_InverseClampOrZero_Return:
addi      r11, r1, 0x20
bl        _restgpr_29
lwz       r0, 0x24(r1)
mtlr      r0
addi      r1, r1, 0x20
blr



.GLE PRINTMESSAGE EndWorldmapCode
.ALLSTARLIST_CONNECTOR:
.GLE ENDADDRESS



#Now for the actual AllStarList layout...

.GLE ADDRESS appear__11AllStarListFv
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
mr        r31, r3
lis r4, Appear@ha
addi r4, r4, Appear@l
li        r5, 0
bl startAnim__2MRFP11LayoutActorPCcUl

lbz       r0, 0x40(r31)
cmpwi     r0, 0
bne       .loc_8045D738
mr        r3, r31
bl startStarPointerModeChooseYesNo__2MRFPv

.loc_8045D738:
#New! You can now set what the page is set to by default
bl .GetStartAllStarListPageNo
stw       r3, 0x38(r31)

lwz       r3, 0x2C(r31)
bl forceToHide__20ButtonPaneControllerFv
lwz       r3, 0x30(r31)
bl forceToHide__20ButtonPaneControllerFv
lwz       r4, 0x38(r31)
mr        r3, r31
bl appearArrows__11AllStarListFi
lwz       r4, 0x38(r31)
mr        r3, r31
bl loadGalaxyNames__11AllStarListFi
lwz       r3, 0x34(r31)
lwz       r12, 0(r3)
lwz       r12, 0x2C(r12)
mtctr     r12
bctrl
mr        r3, r31
addi      r4, r13, sInstance__Q214NrvAllStarList18AllStarListNrvInit - STATIC_R13
bl setNerve__11LayoutActorCFPC5Nerve

mr        r3, r31
bl appear__11LayoutActorFv
lbz       r0, 0x40(r31)
li        r3, 0
stw       r3, 0x3C(r31)
cmpwi     r0, 0
bne       .loc_8045D7B8
bl sub_80486AA0

.loc_8045D7B8:
lwz       r0, 0x14(r1)
lwz       r31, 0x0C(r1)
mtlr      r0
addi      r1, r1, 0x10
blr
#.GLE ASSERT 0x8045D7D0
.GLE ENDADDRESS


.GLE ADDRESS appearArrows__11AllStarListFi
stwu      r1, -0x20(r1)
mflr      r0
stw       r0, 0x24(r1)
addi      r11, r1, 0x20
bl _savegpr_29

#lwz       r3, 0x2C(r31)
#lbz       r0, 0x28(r3)
#cmpwi     r0, 0
#beq       .loc_8045E054

#bl isHidden__20ButtonPaneControllerCFv
#Try Show Right Button
lwz       r3, 0x38(r31)
li r4, 1
li r5, 1
bl .AllStarList_GetOpenPageNextWithZ
cmpwi     r3, 0
ble       .AppearArrows_ForceRightHide

.loc_8045E054:
lwz       r3, 0x2C(r31)
bl appear__20ButtonPaneControllerFv
b .loc_8045E05C

.AppearArrows_ForceRightHide:
lwz       r3, 0x2C(r31)
bl forceToHide__20ButtonPaneControllerFv

.loc_8045E05C:

#lwz       r3, 0x30(r31)
#lbz       r0, 0x28(r3)
#cmpwi     r0, 0
#beq       .loc_8045E064


#bl isHidden__20ButtonPaneControllerCFv
#Try Show Left Button
lwz       r3, 0x38(r31)
li r4, -1
li r5, 1
bl .AllStarList_GetOpenPageNextWithZ
cmpwi     r3, 0
ble       .AppearArrows_ForceLeftHide

.loc_8045E064:
lwz       r3, 0x30(r31)
bl appear__20ButtonPaneControllerFv
b .loc_8045E06C

.AppearArrows_ForceLeftHide:
lwz       r3, 0x30(r31)
bl forceToHide__20ButtonPaneControllerFv


.loc_8045E06C:
addi      r11, r1, 0x20
bl _restgpr_29
lwz       r0, 0x24(r1)
mtlr      r0
addi      r1, r1, 0x20
blr
.GLE ASSERT loadGalaxyNames__11AllStarListFi
.GLE ENDADDRESS


.GLE ADDRESS sub_804D3F80
.GetMaxAllStarListPageNo:
lis r3, MaxPages@ha
addi r3, r3, MaxPages@l
li r4, 0
b .MR_GetGameSetting


#This is set inside the Galaxy's GalaxyInfo
.GLE PRINTADDRESS
.GetStartAllStarListPageNo:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)

bl makeCurrentGalaxyStatusAccessor__2MRFv
stw r3, 0x08(r1)
addi r3, r1, 0x08
bl getWorldNo__20GalaxyStatusAccessorCFv
lis r4, PageNumber@ha
addi r4, r4, PageNumber@l
li r5, 1
li r6, 0
bl .getActiveEntryFromGalaxyInfo
cmpwi r3, 0
bgt .PageIsSet
#li        r3, 1 #default page is page 1
bl .AllStarList_GetOpenPageFirst
.PageIsSet:
stw r3, 0x08(r1)
bl .GetMaxAllStarListPageNo
mr r4, r3
lwz r3, 0x08(r1)
cmpw r3, r4
ble .ReturnPage
mr r3, r4
.ReturnPage:
bl .AllStarList_InverseClampOrZero

lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr
.GLE ASSERT isOnGameEventFlagWorld1Entered__16GameDataFunctionFv
.GLE ENDADDRESS

#Help I can't remember why I wanted to delete these
#Edit 2023-03-11: I REMEMBERED!!

#.GLE PRINTMESSAGE REMINDER!!! DELETE THIS!!! (0x8045DBBC)
#.GLE ADDRESS sub_8045DB80 +0x3C
#bl .GetMaxAllStarListPageNo
#.GLE ENDADDRESS
##.GLE PRINTMESSAGE REMINDER!!! DELETE THIS!!! (0x8045DC1C)
#.GLE ADDRESS sub_8045DB80 +0x9C
#bl .GetMaxAllStarListPageNo
#.GLE ENDADDRESS


#=======================================================================


.GLE ADDRESS loadGalaxyNames__11AllStarListFi
stwu      r1, -0xC50(r1)
mflr      r0
stw       r0, 0xC54(r1)
addi      r11, r1, 0xC50
bl __save_gpr

lis r31, AllStarList_NewString@ha
addi r31, r31, AllStarList_NewString@l

mr r30, r3 #AllStarList
mr r29, r4 #Desired page

bl MR_GetGalaxyOrderList
mr r28, r3 #JMapInfo GalaxyOrderList
bl getCsvDataElementNum__2MRFPC8JMapInfo
mr r27, r3 #Count

#Clear all text panes
mr r3, r30
mr r4, r31
bl clearTextBoxMessageRecursive__2MRFP11LayoutActorPCc

#0x20 will hold the CurrentGalaxyStars WideString
#0xC0 will hold the GalaxyCompletion WideString
#0x14C will hold the HasTicoCoin WideString
#0x2F0 will hold the Stars WideString
addi      r3, r1, 0x2F0
li        r4, 0x1A4
addi      r5, r13, NULLWSTRING - STATIC_R13
crclr     4*cr1+eq
bl       swprintf

addi      r3, r1, 0x14C
li        r4, 0x1A4
addi      r5, r13, NULLWSTRING - STATIC_R13
crclr     4*cr1+eq
bl       swprintf

li r26, 0 #i
#This loop will iterate through all the entries
#and only do stuff if the page number matches
#the requested page number
b .loadGalaxyNames_Loop_Start

.loadGalaxyNames_Loop:
addi r3, r1, 0x08
mr r4, r28
addi r5, r31, PageNumber - AllStarList_NewString
mr r6, r26
bl getCsvDataS32__2MRFPlPC8JMapInfoPCcl

lwz r3, 0x08(r1)
cmpw r3, r29
bne .loadGalaxyNames_Loop_Continue #Entry is for the wrong page, Skip!

addi r3, r1, 0x1C
mr r4, r28
lis r5, GalaxyName@ha
addi r5, r5, GalaxyName@l
mr r6, r26
bl getCsvDataStr__2MRFPPCcPC8JMapInfoPCcl

lwz r3, 0x1C(r1)
lis r4, NULLSTRING@ha
addi r4, r4, NULLSTRING@l
bl isEqualString__2MRFPCcPCc
cmpwi r3, 1
beq .loadGalaxyNames_Loop_Continue #No Galaxy Defined, meaning this entry is likely a page unlock entry




#interruption! We need to find out if this is a ScenarioMode string or not
lwz r3, 0x1C(r1)
bl .IsStarStringScenario
cmpwi r3, 0
beq .NormalGalaxyInAllStarList
b .ScenarioMode_Extension






.NormalGalaxyInAllStarList:
lwz r3, 0x1C(r1)
mr r25, r3
bl makeGalaxyStatusAccessor__2MRFPCc
stw r3, 0x08(r1)

addi r3, r1, 0x0C
mr r4, r28
addi r5, r31, GalaxyPane - AllStarList_NewString
mr r6, r26
bl getCsvDataStr__2MRFPPCcPC8JMapInfoPCcl

#Lets check to see if the player has any stars in this stage
addi r3, r1, 0x08
bl getPowerStarNumOwned__20GalaxyStatusAccessorCFv
cmpwi r3, 0
bgt .loadGalaxyNames_ShowGalaxy #Force Show the galaxy because the player has a star from it already

#The player doesn't already have a star here, lets see if
#it should show up or not
mr r3, r28
mr r4, r26
bl isJMapEntryProgressComplete
cmpwi r3, 0
beq .loadGalaxyNames_HideGalaxy

mr r3, r28
lis r4, PowerStarNum@ha
addi r4, r4, PowerStarNum@l
bl isExistItemInfo__8JMapInfoFPCc
cmpwi r3, 0
beq .loadGalaxyNames_ShowGalaxy

addi r3, r1, 0x10
mr r4, r28
lis r5, PowerStarNum@ha
addi r5, r5, PowerStarNum@l
mr r6, r26
bl getCsvDataS32__2MRFPlPC8JMapInfoPCcl

lwz r3, 0x10(r1)
cmpwi r3, -1
beq .loadGalaxyNames_HideGalaxy #Secret galaxies

.loadGalaxyNames_ShowGalaxy:
addi r3, r1, 0x10
mr r4, r28
addi r5, r31, StarPane - AllStarList_NewString
mr r6, r26
bl getCsvDataStr__2MRFPPCcPC8JMapInfoPCcl
addi r3, r1, 0x14
mr r4, r28
addi r5, r31, CompletePane - AllStarList_NewString
mr r6, r26
bl getCsvDataStr__2MRFPPCcPC8JMapInfoPCcl
addi r3, r1, 0x18
mr r4, r28
addi r5, r31, MedalPane - AllStarList_NewString
mr r6, r26
bl getCsvDataStrOrNULL__2MRFPPCcPC8JMapInfoPCcl

#Alright, all parameters loaded. Lets do this

#First Up: Completion Status
addi r3, r1, 0x08
bl isCompleteAllScenario__20GalaxyStatusAccessorCFv
cmpwi r3, 0
beq .loadGalaxyNames_NotCompleteAllScenario
li r4, 0x50
b .loadGalaxyNames_AssignCompleteIcon

.loadGalaxyNames_NotCompleteAllScenario:
addi r3, r1, 0x08
bl isCompleteAllNormalScenario__20GalaxyStatusAccessorCFv
cmpwi r3, 0
beq .loadGalaxyNames_NotCompleteNormalScenario
li r4, 0x6B
b .loadGalaxyNames_AssignCompleteIcon

.loadGalaxyNames_NotCompleteNormalScenario:
li r4, 0x20

.loadGalaxyNames_AssignCompleteIcon:
addi r3, r1, 0xC0
bl addPictureFontCode__2MRFPwi

mr r3, r30
lwz r4, 0x14(r1)
addi r5, r1, 0xC0
bl setTextBoxMessageRecursive__2MRFP11LayoutActorPCcPCw

#Now lets set the galaxy name
lwz r3, 0x1C(r1)
bl getGalaxyNameShortOnCurrentLanguage__2MRFPCc
cmpwi r3, 0
beq .loadGalaxyNames_HideGalaxy
mr r5, r3
mr r3, r30
lwz r4, 0x0C(r1)
bl setTextBoxMessageRecursive__2MRFP11LayoutActorPCcPCw

#Now lets make the star string
addi r3, r1, 0x20
li        r4, 0xA0
lwz r5, 0x1C(r1)
li r6, 0
li r7, 0
bl createStarString__2MRFPwiPCcbb

mr r3, r30
lwz r4, 0x10(r1)
addi r5, r1, 0x20
bl setTextBoxMessageRecursive__2MRFP11LayoutActorPCcPCw

#And Finally, the Comet Medal Status
lwz r3, 0x1C(r1)
bl isOnGalaxyFlagTicoCoin__16GameDataFunctionFPCc
cmpwi r3, 0
li r4, 0x6F
beq .loadGalaxyNames_NoTicoCoin
li r4, 0x6A
.loadGalaxyNames_NoTicoCoin:
addi r3, r1, 0x14C
bl addPictureFontCode__2MRFPwi

mr r3, r30
lwz r4, 0x18(r1)
cmpwi r4, 0
beq .loadGalaxyNames_Loop_Continue #Stage has no comet medal!
addi r5, r1, 0x14C
bl setTextBoxMessageRecursive__2MRFP11LayoutActorPCcPCw
b .loadGalaxyNames_Loop_Continue #Continue!

.loadGalaxyNames_HideGalaxy:
mr r3, r30
lwz r4, 0x0C(r1)
addi r5, r31, HideGalaxyText - AllStarList_NewString
bl setTextBoxGameMessageRecursive__2MRFP11LayoutActorPCcPCc

.loadGalaxyNames_ShowEmpty:
#Do nothing because the panes should already be empty
#Lol

.loadGalaxyNames_Loop_Continue:
addi r26, r26, 1
.loadGalaxyNames_Loop_Start:
cmpw r26, r27
blt .loadGalaxyNames_Loop


#New as of GLE-V2! Page titles!
#If a title is missing, nothing will be displayed!
#This is NOT 0 indexed! Page titles start at 1
addi      r3, r1, 0x0C
li        r4, 0x100
addi r5, r31, PageTitle_Format - AllStarList_NewString
mr        r6, r29
crclr     4*cr1+eq
bl        snprintf

addi      r3, r1, 0x0C
bl getGameMessageDirect__2MRFPCc
cmpwi r3, 0
beq .loadGalaxyNames_NoTitle

mr r3, r30
addi r4, r31, Title - AllStarList_NewString
addi r5, r1, 0x0C
bl setTextBoxGameMessageRecursive__2MRFP11LayoutActorPCcPCc

.loadGalaxyNames_NoTitle:

.loadGalaxyNames_Return:
addi      r11, r1, 0xC50
bl __restore_gpr
lwz       r0, 0xC54(r1)
mtlr      r0
addi      r1, r1, 0xC50
blr
.GLE ENDADDRESS
