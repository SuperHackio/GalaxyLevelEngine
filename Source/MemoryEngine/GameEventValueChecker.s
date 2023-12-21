#New system for saving event values.
#Users are able to customize which fields exist or not by using a BCSV


#Most things here override WorldMapHolder
.GLE ADDRESS .SCENARIO_SELECT_CONNECTOR
.GameEventValueChecker_Ctor:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
li        r0, 0
lis       r4, __vt__21GameEventValueChecker@ha
addi      r4, r4, __vt__21GameEventValueChecker@l
stw       r31, 0x0C(r1)
#stw       r30, 0x08(r1)

mr        r31, r3
stw       r4, 0(r3)     # Vtable*
stw       r0, 4(r3)     # int[] Values
stw       r0, 8(r3)     # int EventValueCount
#MR::getWorldMapHeapResource((void)) replaced by
#MR::getGameEventValueChecker((void))
bl MR_GetGameEventValueTable
bl getCsvDataElementNum__2MRFPC8JMapInfo
stw       r3, 8(r31)

slwi r3, r3, 1 #Quick multiply by 2
bl        __nwa__FUl
stw       r3, 4(r31)

mr        r3, r31
lwz       r12, 0(r31)
lwz       r12, 0x18(r12)
mtctr     r12
bctrl     #GameEventValueChecker::initializeData

mr        r3, r31
#lwz       r30, 0x08(r1)
lwz       r31, 0x0C(r1)
lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr

.GLE ADDRESS __ct__21GameEventValueCheckerFv
b .GameEventValueChecker_Ctor
.GLE ENDADDRESS


.GameEventValueChecker_FindIndex:
#Returns -1 if entry not found
stwu      r1, -0x20(r1)
mflr      r0
stw       r0, 0x24(r1)
addi      r11, r1, 0x20
bl        _savegpr_27
mr        r27, r3
mr        r28, r4
li        r29, 0

bl MR_GetGameEventValueTable
mr r30, r3

b         .loc_804DCD84

.loc_804DCD60:
addi r3, r1, 0x08
mr r4, r30
lis r5, ValueName@ha
addi r5, r5, ValueName@l
mr r6, r29
bl getCsvDataStr__2MRFPPCcPC8JMapInfoPCcl

mr        r3, r28
lwz r4, 0x08(r1)
bl        isEqualString__2MRFPCcPCc
cmpwi     r3, 0
beq       .loc_804DCD7C
mr        r3, r29
b         .loc_804DCD94

.loc_804DCD7C:
addi      r29, r29, 1

.loc_804DCD84:
lwz       r0, 8(r27)
cmpw      r29, r0
blt       .loc_804DCD60
li        r3, -1

.loc_804DCD94:
addi      r11, r1, 0x20
bl        _restgpr_27
lwz       r0, 0x24(r1)
mtlr      r0
addi      r1, r1, 0x20
blr

.GLE ADDRESS findIndex__21GameEventValueCheckerCFPCc
b .GameEventValueChecker_FindIndex
.GLE ENDADDRESS


.GameEventValueChecker_findIndexFromHashCode:
#returns -1 if entry not found
stwu      r1, -0x40(r1)
mflr      r0
stw       r0, 0x44(r1)
addi      r11, r1, 0x40
bl        _savegpr_27
mr        r27, r3
mr        r28, r4
li        r29, 0

bl MR_GetGameEventValueTable
mr r30, r3

b         .loc_804DCE04

.loc_804DCDE0:
addi r3, r1, 0x18
mr r4, r30
lis r5, ValueName@ha
addi r5, r5, ValueName@l
mr r6, r29
bl getCsvDataStr__2MRFPPCcPC8JMapInfoPCcl

lwz r3, 0x18(r1)
bl        getHashCode__2MRFPCc
clrlwi    r0, r3, 16
cmplw     r28, r0
bne       .loc_804DCDFC
mr        r3, r29
b         .loc_804DCE14

.loc_804DCDFC:
addi      r29, r29, 1
;addi      r31, r31, 8

.loc_804DCE04:
lwz       r0, 8(r27)
cmpw      r29, r0
blt       .loc_804DCDE0
li        r3, -1

.loc_804DCE14:
addi      r11, r1, 0x40
bl        _restgpr_27
lwz       r0, 0x44(r1)
mtlr      r0
addi      r1, r1, 0x40
blr

.GLE ADDRESS findIndexFromHashCode__21GameEventValueCheckerCFUs
b .GameEventValueChecker_findIndexFromHashCode
.GLE ENDADDRESS



.GameEventValueChecker_initializeData:
stwu      r1, -0x20(r1)
mflr      r0
stw       r0, 0x24(r1)
addi      r11, r1, 0x20
bl        _savegpr_28
mr r28, r3

bl MR_GetGameEventValueTable
mr r31, r3
li        r30, 0
b         .loc_804DCD14

.loc_804DCCF8:
;add       r7, r8, r4
addi r3, r1, 0x08
mr r4, r31
lis r5, Value@ha
addi r5, r5, Value@l
mr r6, r30
#Using the S16 is actually an improvement over the original code
bl getCsvDataS16__2MRFPsPC8JMapInfoPCcl
lwz       r6, 4(r28) #Load Data Array
lhz r0, 0x08(r1)
slwi r3, r30, 1
sthx      r0, r6, r3 #Store default into array
addi      r30, r30, 1

.loc_804DCD14:
lwz       r0, 8(r28)
cmpw      r30, r0
blt       .loc_804DCCF8

addi      r11, r1, 0x20
bl        _restgpr_28
lwz       r0, 0x24(r1)
mtlr      r0
addi      r1, r1, 0x20
blr

.GLE ADDRESS initializeData__21GameEventValueCheckerFv
b .GameEventValueChecker_initializeData
.GLE ENDADDRESS



.GameEventValueChecker_serialize:
stwu      r1, -0x40(r1)
mflr      r0
stw       r0, 0x44(r1)
addi      r11, r1, 0x40
bl        _savegpr_26
lis       r6, __vt__21JSUMemoryOutputStream@ha
li        r28, 0
addi      r6, r6, __vt__21JSUMemoryOutputStream@l
stb       r28, 0x10(r1)
mr        r26, r3
addi      r3, r1, 0x0C
stw       r6, 0x0C(r1)
bl setBuffer__21JSUMemoryOutputStreamFPvl
li        r27, 0

bl MR_GetGameEventValueTable
mr r29, r3
li        r31, 0
b         .loc_804DCBAC

.loc_804DCB68:
;lwzx      r3, r29, r31
addi r3, r1, 0x08
mr r4, r29
lis r5, ValueName@ha
addi r5, r5, ValueName@l
mr r6, r27
bl getCsvDataStr__2MRFPPCcPC8JMapInfoPCcl

lwz r3, 0x08(r1)
bl        getHashCode__2MRFPCc
sth       r3, 0x0A(r1)
addi      r3, r1, 0x0C
addi      r4, r1, 0x0A
li        r5, 2
bl write__15JSUOutputStreamFPCvl

lwz       r6, 4(r26) #Load the Data Array
lhzx      r30, r6, r28
sth       r30, 0x08(r1)
addi      r3, r1, 0x0C
addi      r4, r1, 0x08
li        r5, 2
bl write__15JSUOutputStreamFPCvl
addi      r27, r27, 1
addi      r28, r28, 2

.loc_804DCBAC:
lwz       r0, 8(r26)
cmpw      r27, r0
blt       .loc_804DCB68
lwz       r28, 0x1C(r1)
addi      r3, r1, 0x0C
li        r4, -1
bl        __dt__21JSUMemoryOutputStreamFv
addi      r11, r1, 0x40
mr        r3, r28
bl        _restgpr_26
lwz       r0, 0x44(r1)
mtlr      r0
addi      r1, r1, 0x40
blr

.GLE ADDRESS serialize__21GameEventValueCheckerCFPUcUl
b .GameEventValueChecker_serialize
.GLE ENDADDRESS


#r3 = const char* Flag to look for
#returns -1 if not found
.GLE_IsExistGameEventValue:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)

mr r4, r3
#confirmed to not use r4
bl getGameEventValueChecker__16GameDataFunctionFv
bl findIndex__21GameEventValueCheckerCFPCc

lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr


#======== Best Score Corrections ========
#Because the GLE now assigns best scores to scenarios and not galaxies, we need to alter how we format
#the score strings by adding a scenario no. if the scenario is 0, we'll use the current scenario no.
#This pretty much only applies to The Chimp.

.GetBestScore:
mr r7, r4
cmpwi r7, 0
bne .GetBestScore_Skip
bl getCurrentSelectedScenarioNo__2MRFv
mr r7, r3

.GetBestScore_Skip:
addi r3, r1, 0x08
b .GetBestScore_Return


.GLE ADDRESS getBestScoreAttackCurrentStage__16GameDataFunctionFv +0x24
b .GetBestScore
.GetBestScore_Return:
.GLE ENDADDRESS


.SetBestScore:
mr r7, r4
cmpwi r7, 0
bne .SetBestScore_Skip
bl getCurrentSelectedScenarioNo__2MRFv
mr r7, r3

.SetBestScore_Skip:
addi r3, r1, 0x08
b .SetBestScore_Return

.GLE ADDRESS setBestScoreAttackCurrentStage__16GameDataFunctionFv +0x20
b .SetBestScore
.SetBestScore_Return:
.GLE ENDADDRESS

#So now we need to make a couple additional corrections...
.GLE ADDRESS getBestScoreAttackCurrentStage__16GameDataFunctionFv -0x04
#This is here so we can redirect all the existing calls so we don't get left
#with some bizzare random number that ends up being our scenario no
.getGalaxyHighScoreOnCurrentScenario:
li r4, 0
#The code will fall through to the normal function here
.GLE ENDADDRESS

#We also need to do the same for SetBestScore
.GLE ADDRESS setBestScoreAttackCurrentStage__16GameDataFunctionFv -0x04
.setGalaxyHighScoreOnCurrentScenario:
li r4, 0
.GLE ENDADDRESS


.GLE ADDRESS initAfterStationedResourceLoaded__10GameSystemFv +0x44
#Because reasons, we need to swap the load order here...
lwz       r3, 0x34(r31)
bl init__20GameSystemDataHolderFv
lwz       r3, 0xC(r31)
bl initAfterResourceLoaded__20GameSequenceDirectorFv
.GLE ENDADDRESS

#r3 = Address to check
#returns 0 or 1 if the address is a valid pointer
.GLE_IsValidPointerAddress:
cmpwi r3, 0
beq .GLE_IsValidPointerAddress_Return_False  #Make sure it's not 0
rlwinm r4,r3,0,0,0 #(0x80000000)
cmpwi r4, 0
beq .GLE_IsValidPointerAddress_Return_False  #Value doesn't corrospond to anything in readable memory if 0
rlwinm r4,r3,0,1,1 #(0x40000000)
cmpwi r4, 0
bne .GLE_IsValidPointerAddress_Return_False  #Block bad values like 0xFFFFFFFF

.GLE_IsValidPointerAddress_Return_True:
li r3, 1
blr

.GLE_IsValidPointerAddress_Return_False:
li r3, 0
blr

ValueName:
    .string "ValueName"
    
Value:
    .string "Value"
    
#Changed from GLE-V1
#Now we put the race ID inside the brackets instead of a galaxy name/scenario
Glider_Format:
    .string "グライダー[%d]" AUTO
    
.GLE ADDRESS BestScoreString
#Because the GLE now assigns best scores to scenarios and not galaxies, we need to alter the string
#For simplicities sake, (and because I can) I am overwriting the original string.
#We just barely have enough space for this addition. we have only 1 byte left, thankfully it can serve as our null terminator.
BestScore:
    .string "ベストスコア[%s_%d]" AUTO
.GLE ENDADDRESS

#EndWorldmapCode
.GAME_EVENT_VALUE_CHECKER_CONNECTOR:
.GLE ENDADDRESS