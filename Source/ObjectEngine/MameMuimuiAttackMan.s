#The Chimp that hosts ice skating now has some new properties that we'll need to account for.
#Though, technically it's the scorer object that has these new additions, we're still gonna keep them in this file.

#Increase the scorer object size
.GLE ADDRESS createNameObj<16MameMuimuiScorer>__14NameObjFactoryFPCc_P7NameObj +0x14
li        r3, 0x130
.GLE ENDADDRESS

.GLE ADDRESS init__19MameMuimuiAttackManFRC12JMapInfoIter +0x74
nop
li        r3, 0x130
.GLE ENDADDRESS

#NEW as of GLE-V2: We're ditching MameMuimuiScorerLv2
#and replacing it with a system that lets you set the level yourself as an Obj Arg!
#This means that you're allowed to have as many sets of gummits that you want!

#First, edit the init function:
.GLE ADDRESS init__16MameMuimuiScorerFRC12JMapInfoIter +0x3C

#Target Score
mr        r3, r31
addi r4, r30, 0xF4
bl getJMapInfoArg0NoInit__2MRFRC12JMapInfoIterPl

#TimeLimit
li r3, 40   #Default 40 seconds
stw r3, 0x10C(r30)
mr        r3, r31
addi r4, r30, 0x10C
bl getJMapInfoArg1NoInit__2MRFRC12JMapInfoIterPl
lwz r3, 0x10C(r30)
mulli r3, r3, 60
stw r3, 0x10C(r30)

#Level
mr        r3, r31
addi r4, r30, 0xFC
bl getJMapInfoArg2NoInit__2MRFRC12JMapInfoIterPl

#Scenario ID
mr        r3, r31
addi r4, r30, 0x108
bl getJMapInfoArg7NoInit__2MRFRC12JMapInfoIterPl

#Lets make the sequence archive name
bl .LOCAL_CreateScorerArchiveName

addi r3, r1, 0x08
bl createAndAddResourceHolder__2MRFPCc
mr        r27, r3
mr        r3, r30
mr        r4, r27
bl        initPositionList__16MameMuimuiScorerFP14ResourceHolder
bl .LOCAL_InitSequence
bl .LOCAL_InitRemap
#I couldn't fit it in this block of code oof
#this just barely fits. Wowie!

.GLE PRINTADDRESS
.GLE ASSERT init__16MameMuimuiScorerFRC12JMapInfoIter +0xA4
.GLE ENDADDRESS

.GLE ADDRESS MameMuimuiScorerLv2_ObjectName
MameMuimuiScorerLvX:
    .string "MameMuimuiScorerLv%d" AUTO
.GLE ENDADDRESS



.GLE ADDRESS .INFODISPLAYOBJ_CONNECTOR

.LOCAL_CreateScorerArchiveName:
addi r3, r1, 0x08  #Stack should have enough room
li r4, 0x20
lis       r5, MameMuimuiScorerLvX@ha
addi      r5, r5, MameMuimuiScorerLvX@l
lwz r6, 0xFC(r30)
crclr     4*cr1+eq
b         snprintf

.LOCAL_InitSequence:
mr        r3, r30
mr        r4, r27
b         initSequence__16MameMuimuiScorerFP14ResourceHolder

.LOCAL_InitRemap:
mr        r3, r30
mr        r4, r27
b         .InitRemapBcsv

.GLE PRINTADDRESS
.InitRemapBcsv:
#r3 = MameMuimuiScorer
#r4 = ResourceHolder
stwu      r1, -0x100(r1)
mflr      r0
stw       r0, 0x104(r1)
addi      r11, r1, 0x100
bl        _savegpr_25

mr r31, r3
lis       r25, MameMuimuiScorer_RemapList@ha
addi      r25, r25, MameMuimuiScorer_RemapList@l

mr r3, r4 #We only use the resourceholder once
addi r4, r25, 0  #Keeping the classic SMG2 spirit
crclr     4*cr1+eq
bl createCsvParser__2MRFPC14ResourceHolderPCce
mr r30, r3

li r26, 0
b .RemapFieldLoop_Start

.RemapFieldLoop:
addi      r3, r1, 0x08
li        r4, 0x30
addi      r5, r25, Pattern_Format - MameMuimuiScorer_RemapList
addi r6, r26, 1
crclr     4*cr1+eq
bl        snprintf

mr r3, r30
addi      r4, r1, 0x08
bl isExistItemInfo__8JMapInfoFPCc
cmpwi r3, 0
beq .RemapFieldLoop_Break

.RemapFieldLoop_Continue:
addi r26, r26, 1
.RemapFieldLoop_Start:
b .RemapFieldLoop

.RemapFieldLoop_Break:

#r26 now has how many fields there are
mr r3, r30
bl getCsvDataElementNum__2MRFPC8JMapInfo
mr r29, r3
subi r4, r26, 1   #Subtract 1 so we can use this number in the getRandom function
stw r4, 0x114(r31) #Gotta keep track of the field count

mullw r3, r3, r26  #Entry Count * Field Count
slwi r3, r3, 2 #Multiply by 4
bl __nwa__FUl
.GLE PRINTADDRESS
stw r3, 0x110(r31)


#Now lets pupulate the list
li r27, 0 #i
b .RemapEntryFieldLoop_Start

.RemapEntryFieldLoop:
addi      r3, r1, 0x0C
li        r4, 0x30
addi      r5, r25, Pattern_Format - MameMuimuiScorer_RemapList
addi r6, r27, 1
crclr     4*cr1+eq
bl        snprintf


li r28, 0 #x
b .RemapEntryLoop_Start

.RemapEntryLoop:
addi r3, r1, 0x08
mr r4, r30
addi      r5, r1, 0x0C
mr r6, r28
bl getCsvDataS32__2MRFPlPC8JMapInfoPCcl
mullw r4, r27, r29  # i * EntryCount
mulli r4, r4, 0x04
slwi r0, r28, 2
add r0, r0, r4

lwz r5, 0x110(r31)
lwz r3, 0x08(r1)
stwx r3, r5, r0
#Whew that math took some thinking

addi r28, r28, 1
.RemapEntryLoop_Start:
mr r3, r30
bl getCsvDataElementNum__2MRFPC8JMapInfo
cmpw r28, r3
blt .RemapEntryLoop


.RemapEntryFieldLoop_Continue:
addi r27, r27, 1

.RemapEntryFieldLoop_Start:
cmpw r27, r26
blt .RemapEntryFieldLoop

addi      r11, r1, 0x100
bl        _restgpr_25
lwz       r0, 0x104(r1)
mtlr      r0
addi      r1, r1, 0x100
blr

.GLE ADDRESS MameMuimuiScorer_RemapList
RemapList:
    .string "RemapList"
    
Time:
    .string "Time"

Pattern_Format:
    .string "Pattern%d" AUTO
    
.GLE ASSERT MameMuimuiScorer_RemapList +0x90
.GLE ENDADDRESS


#Additional code to make sure we can add new entries to sequences
.LOCAL_initSequence_CreateArrayLength:
#r3 = CsvDataElementNum
#r24 = MameMuimuiScorer
bl .LOCAL_initSequence_GetPosHolderNum
mulli     r4, r4, 0x04  #PositionNum * 4 = Size of all positions.
lwz r3, 0xEC(r24)
mullw r3, r3, r4        #Multiply by the number of BCSV rows
b .initSequence_CreateArrayLength_Return


.LOCAL_initSequence_CheckArrayLength:
addi      r25, r25, 1
bl .LOCAL_initSequence_GetPosHolderNum
b .LOCAL_initSequence_CheckArrayLength_Return


.LOCAL_initSequence_AddArrayLength:
bl .LOCAL_initSequence_GetPosHolderNum
mulli     r3, r4, 0x04  #PositionNum * 4 = Size of all positions.
add r31, r31, r3
b .LOCAL_initSequence_AddArrayLength_Return


.LOCAL_initSequence_GetPosHolderNum:
lwz       r4, 0xA0(r24)
lwz       r4, 4(r4)
blr


.GLE ADDRESS initSequence__16MameMuimuiScorerFP14ResourceHolder +0x38
b .LOCAL_initSequence_CreateArrayLength
.initSequence_CreateArrayLength_Return:
.GLE ENDADDRESS


.GLE ADDRESS initSequence__16MameMuimuiScorerFP14ResourceHolder +0x94
b .LOCAL_initSequence_CheckArrayLength
.LOCAL_initSequence_CheckArrayLength_Return:
cmpw r25, r4
.GLE ENDADDRESS


.GLE ADDRESS initSequence__16MameMuimuiScorerFP14ResourceHolder +0xB4
b .LOCAL_initSequence_AddArrayLength
.LOCAL_initSequence_AddArrayLength_Return:
.GLE ENDADDRESS


.initSequence_InitTimeArray:
lwz r3, 0xEC(r24)
slwi r3, r3, 2
bl __nwa__FUl
stw r3, 0x118(r24)

#Need to do this before returning
li r26, 0
b .initSequence_InitTimeArray_Return


.GLE ADDRESS initSequence__16MameMuimuiScorerFP14ResourceHolder +0x44
b .initSequence_InitTimeArray
.initSequence_InitTimeArray_Return:
.GLE ENDADDRESS


.initSequence_LoadTimeValue:
lwz r3, 0x118(r24)
mulli r4, r26, 4
add r3, r3, r4  #Genius??
mr r4, r27
lis r5, Time@ha
addi r5, r5, Time@l
mr r6, r26
bl getCsvDataS32__2MRFPlPC8JMapInfoPCcl

mr r6, r25
b .initSequence_LoadTimeValue_Return


.GLE ADDRESS initSequence__16MameMuimuiScorerFP14ResourceHolder +0x60
b .initSequence_LoadTimeValue
.initSequence_LoadTimeValue_Return:
.GLE ENDADDRESS


.GLE ADDRESS setRandomRemap__16MameMuimuiScorerFv +0x30
lwz r4, 0x114(r31)
.GLE ENDADDRESS

.GLE ADDRESS appearNextSequence__16MameMuimuiScorerFv
#Completely overwriting this one...
stwu      r1, -0x70(r1)
mflr      r0
stw       r0, 0x74(r1)
addi      r11, r1, 0x70
bl        _savegpr_26

mr r31, r3

#So the goal of this function is to make gummits appear

lwz       r0, 0xF0(r3)  #Get the current sequence
lwz       r4, 0xB8(r3)  #Get the sequence Array
lwz       r5, 0xA0(r3)
lwz       r5, 4(r5)     #Get the number of positions
mulli     r5, r5, 0x04  #PositionNum * 4 = Size of a sequence entry
mullw     r0, r0, r5    #Sequence index * Entry Size = Current Entry start index
lwzx      r3, r4, r0    #Get the current position ID. This will be -1 if we need to loop
cmpwi     r3, -1
bgt .NextPattern
blt .EndMinigameEarly

#If the thing gives us -1, we need to read the time to know where to go to
lwz       r4, 0x118(r31)
lwz       r0, 0xF0(r31)
slwi r0, r0, 2
lwzx r3, r4, r0  #Unlike the normal sequence list, the time list is true 1D and not pretend 2D.
#So we now have our next id in r3. Branch if less than 0
cmpwi r3, 0
blt .EndMinigameEarly
stw       r3, 0xF0(r31)
b .NextPattern

.EndMinigameEarly:
lwz       r3, 0xA4(r31)
li r4, 1  #Get the timer to Time Up
stw       r4, 0x2C(r3)
b .AppearNextSequence_Return

.NextPattern:
#Lets get the lifetime of this sequence
lwz       r4, 0x118(r31)
lwz       r0, 0xF0(r31)
slwi r0, r0, 2
lwzx r30, r4, r0


li r27, 0
li r29, 0
b .AppearLoop_Start

.AppearLoop:

bl .LOCAL_GetPositionIndex
lwz       r5, 0xB8(r31)  #Sequence array
lwzx      r26, r5, r4
cmpwi     r26, 0
beq .AppearLoop_Continue

b .LOCAL_GetPositionRemap
.LOCAL_GetPositionRemap_Return:

cmpwi     r26, 1
li        r3, 0
beq .SpawnGreen
cmpwi     r26, 2
beq .SpawnYellow
cmpwi     r26, 3
beq .SpawnSpikey
b .SetLifeTime

.SpawnGreen:
lwz       r3, 0x94(r31)
bl        getDeadMameMuimui__15MameMuimuiGroupFv
b .SetLifeTime

.SpawnYellow:
lwz       r3, 0x98(r31)
bl        getDeadMameMuimui__15MameMuimuiGroupFv
b .SetLifeTime

.SpawnSpikey:
lwz       r3, 0x9C(r31)
bl        getDeadMameMuimui__15MameMuimuiGroupFv

.SetLifeTime:
cmpwi     r3, 0
beq .AppearLoop_Continue
mr        r5, r30
addi      r4, r1, 0x08
bl        setPosAndLifetime__10MameMuimuiFRCQ29JGeometry8TVec3_f_l

.AppearLoop_Continue:
addi      r27, r27, 1
addi      r29, r29, 4

.AppearLoop_Start:
lwz       r5, 0xA0(r31)
lwz       r5, 4(r5)
cmpw r27, r5
blt .AppearLoop

mr        r3, r31
addi      r4, r13, unk_807D2AB4 - STATIC_R13
bl setNerve__9LiveActorFPC5Nerve

lwz       r3, 0xF0(r31)
addi      r0, r3, 1
stw       r0, 0xF0(r31)

.AppearNextSequence_Return:
addi      r11, r1, 0x70
bl        _restgpr_26
lwz       r0, 0x74(r1)
mtlr      r0
addi      r1, r1, 0x70
blr
.GLE PRINTADDRESS
.GLE ASSERT appearNextSequence__16MameMuimuiScorerFv +0x150
.GLE ENDADDRESS

.LOCAL_GetPositionIndex:
lwz       r0, 0xF0(r31)  #Current sequence
lwz       r5, 0xA0(r31)
lwz       r5, 4(r5)      #Number of positions

slwi      r5, r5, 2      #PosNum *= 4
mullw     r5, r5, r0     #PosNum * Current Sequence
add       r4, r29, r5     #Add em up
.GLE PRINTADDRESS
blr

.LOCAL_GetPositionRemap:
lwz r5, 0x110(r31)       #Remap array
lwz       r6, 0xA0(r31)
lwz       r6, 4(r6)      #Number of positions
slwi      r6, r6, 2
lwz       r0, 0x100(r31)
mullw r0, r0, r6

slwi r4, r27, 2
add r4, r4, r0
lwzx      r4, r5, r4
addi r5, r1, 0x08
lwz       r3, 0xA0(r31)
bl getPosition__24MameMuimuiPositionHolderFlRCQ29JGeometry8TVec3_f_
b .LOCAL_GetPositionRemap_Return


.GLE ADDRESS start__16MameMuimuiScorerFv +0x28
lwz       r4, 0x10C(r31)
.GLE ENDADDRESS


#High Score fixes

.MameMuimuiGetHighScore:
lwz r4, 0x108(r30)
b getBestScoreAttackCurrentStage__16GameDataFunctionFv

.GLE ADDRESS init__16MameMuimuiScorerFRC12JMapInfoIter +0x428
bl .MameMuimuiGetHighScore
.GLE ENDADDRESS

.MameMuimuiSetHighScore:
lwz r4, 0x108(r31)
b setBestScoreAttackCurrentStage__16GameDataFunctionFv

.GLE ADDRESS updateHighScore__16MameMuimuiScorerFv +0xC4
bl .MameMuimuiSetHighScore
.GLE ENDADDRESS

.GLE PRINTADDRESS


.MAME_MUIMUI_ATTACK_MAN_CONNECTOR:
.GLE ENDADDRESS

