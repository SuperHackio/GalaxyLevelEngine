#overwrites WorldMap01Model
#at least, in the object table it does
#You can't use the world map models anymore anyways so...

.GLE ADDRESS cCreateTable__14NameObjFactory +0x10B8
.int GalaxyInfoArea_ObjNameString
.int .CreateGalaxyInfoArea
.GLE ENDADDRESS

.GLE ADDRESS cCreateTable__16AreaObjContainer +0x438
.int GalaxyInfoArea_ObjNameString
.int 0x00000030
.GLE ENDADDRESS

.GLE ADDRESS .COLLECTTICO_CONNECTOR
.CreateGalaxyInfoArea:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
mr        r31, r3
li        r3, 0x4C
bl        __nw__FUl
cmpwi     r3, 0
beq       .GalaxyInfoArea_Create_Return
mr        r4, r31
bl        .GalaxyInfoArea_Ctor

.GalaxyInfoArea_Create_Return:
lwz       r0, 0x14(r1)
lwz       r31, 0x0C(r1)
mtlr      r0
addi      r1, r1, 0x10
blr

#==============================
.GalaxyInfoArea_Ctor:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
mr        r31, r3

bl        __ct__7AreaObjFPCc
lis       r4, GalaxyInfoArea_VTable@ha
addi      r4, r4, GalaxyInfoArea_VTable@l
stw       r4, 0(r31)

li r3, 0x100
bl __nwa__FUl
stw r3, 0x48(r31)
mr r3, r31

lwz       r31, 0x0C(r1)
lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr

#==============================
.GalaxyInfoArea_Init:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
mr        r31, r3
bl init__7AreaObjFRC12JMapInfoIter
mr        r3, r31
bl connectToSceneAreaObj__2MRFP7NameObj

#Now lets deal with the SceneObj
li r3, 52
bl isExistSceneObj__2MRFi
cmpwi r3, 0
bne .GalaxyInfoArea_ObjectExists

li r3, 52
bl createSceneObj__2MRFi

.GalaxyInfoArea_ObjectExists:
lwz       r0, 0x14(r1)
lwz       r31, 0x0C(r1)
mtlr      r0
addi      r1, r1, 0x10
blr

#==============================
.GLE PRINTADDRESS
.GalaxyInfoArea_Movement:
stwu      r1, -0x100(r1)
mflr      r0
stw       r0, 0x104(r1)
addi      r11, r1, 0x100
bl _savegpr_25

mr        r31, r3
bl getPlayerPos__2MRFv
lwz       r12, 0(r31)
mr        r4, r3
mr        r3, r31
lwz       r12, 0x2C(r12)
mtctr     r12
bctrl     # AreaObj::isInVolume(const(JGeometry::TVec3_f_ const &))
cmpwi     r3, 0
beq      .GalaxyInfoArea_Movement_Return

lbz r3, 0x1C(r31)
cmpwi r3, 0
beq .GalaxyInfoArea_Movement_Return

bl MR_GetGalaxyOrderList
mr r30, r3
mr r4, r3
addi r3, r1, 0x08
lis r5, GalaxyName@ha
addi r5, r5, GalaxyName@l
lwz r6, 0x20(r31)
bl getCsvDataStr__2MRFPPCcPC8JMapInfoPCcl

li r3, 52
bl .GLE_GetSceneObj
mr r29, r3

.NormalGalaxy_GalaxyInfoArea:
#Re-written from GLE-V1
mr r3, r30
lwz r4, 0x20(r31)
bl isJMapEntryProgressComplete
cmpwi r3, 0
beq .GalaxyInfoArea_Movement_HideGalaxy

.GalaxyInfoArea_Movement_ShowGalaxy:
mr r3, r29
lwz r4, 0x08(r1)
li r5, 4
li r6, 0
bl .GalaxySelectInfo_show

addi r3, r1, 0x08
mr r4, r30
lis r5, MedalPane@ha
addi r5, r5, MedalPane@l
lwz r6, 0x20(r31)
bl getCsvDataStrOrNULL__2MRFPPCcPC8JMapInfoPCcl

lwz r4, 0x08(r1)
cmpwi r4, 0

mr r3, r29
bne .GalaxySelectInfo_ShowTicoCoin
lis r4, GalaxyInfoArea_Medal@ha
addi r4, r4, GalaxyInfoArea_Medal@l
bl hidePaneRecursive__2MRFP11LayoutActorPCc
b .GalaxyInfoArea_Movement_Return

.GalaxySelectInfo_ShowTicoCoin:

#lis r4, GalaxyInfoArea_TxtMedal@ha
#addi r4, r4, GalaxyInfoArea_TxtMedal@l
#bl showPaneRecursive__2MRFP11LayoutActorPCc
b .GalaxyInfoArea_Movement_Return

.GalaxyInfoArea_Movement_HideGalaxy:
#Here's where we get some new functionality
#As of GLE-V2, users can have custom messages
#for their locked galaxies
#The banner will match the name that was inserted in the BCSV
#If the user has added a custom message in the MSBT, we can use the custom lock banner
#Otherwise, we cannot, and we'll use default messages.

lwz r3, 0x48(r31)
li        r4, 0x70
lis r5, GalaxyInfoArea_UnknownSpecific_Format@ha
addi r5, r5, GalaxyInfoArea_UnknownSpecific_Format@l
lwz r6, 0x08(r1)
crclr     4*cr1+eq
bl        snprintf

#now that we are done with the value at 0x08(r1)
#we can replace it
li r3, 2
stw r3, 0x08(r1)

mr r3, r30
lis r4, PowerStarNum@ha
addi r4, r4, PowerStarNum@l
bl isExistItemInfo__8JMapInfoFPCc
cmpwi r3, 0
beq .GalaxyInfoArea_Movement_SkipStarNum

addi r3, r1, 0x08
mr r4, r30
lis r5, PowerStarNum@ha
addi r5, r5, PowerStarNum@l
lwz r6, 0x20(r31)
bl getCsvDataS32__2MRFPlPC8JMapInfoPCcl

.GalaxyInfoArea_Movement_SkipStarNum:
#NEW to GLE-V3:
#Obj Arg 1 >= 0 -> Use Remaining
#If set, will count down the stars you need. People were misinformed on how this worked in GLE-V2, but I think it's good to have both options.

lwz r3, 0x24(r31)
cmpwi r3, 0
blt .GalaxyInfoArea_Movement_SkipArg1
bl getPowerStarNum__2MRFv
lwz r5, 0x08(r1) #Load the requested PowerStarNum
sub r5, r5, r3
stw r5, 0x08(r1) #Overwrite it. This makes the following code think there's only 1 star needed. Genius!

.GalaxyInfoArea_Movement_SkipArg1:
mr r3, r29
lis r4, GalaxyName@ha
addi r4, r4, GalaxyName@l
lwz r5, 0x08(r1) #Load the requested PowerStarNum
li r6, 0
bl setTextBoxArgNumberRecursive__2MRFP11LayoutActorPCcll


#If we need the 1 star, but a 1 star doesn't exist,
#we'll try for a non-1 star. If that doesn't exist,
#We'll just use the default.
lwz r4, 0x08(r1)
cmpwi r4, 1
bgt .GalaxyInfoArea_Movement_UseAMulti

.GalaxyInfoArea_Movement_UseASingle:
lwz r3, 0x48(r31)
bl .MR_getGalaxyNameOnCurrentLanguageOrNULL
cmpwi r3, 0
lwz r4, 0x48(r31)
bne .GalaxyInfoArea_Movement_UseACustomHidden

.GalaxyInfoArea_Movement_UseAMulti:
lwz r3, 0x48(r31)
addi r3, r3, 1
bl .MR_getGalaxyNameOnCurrentLanguageOrNULL
cmpwi r3, 0
lwz r4, 0x48(r31)
addi r4, r4, 1
beq .GalaxyInfoArea_Movement_DefaultHidden


.GalaxyInfoArea_Movement_UseACustomHidden:
mr r3, r29
#lwz r4, 0x48(r31) #r4 is now loaded above
li r5, 4
li r6, 1
bl .GalaxySelectInfo_show
b .GalaxyInfoArea_Movement_Return



.GalaxyInfoArea_Movement_DefaultHidden:
mr r3, r29
lwz r4, 0x08(r1)
cmpwi r4, 1
lis r4, GalaxyInfoArea_Unknown@ha
addi r4, r4, GalaxyInfoArea_Unknown@l
beq .GalaxyInfoArea_Movement_UseSingle
addi r4, r4, 1
.GalaxyInfoArea_Movement_UseSingle:
li r5, 4
li r6, 1
bl .GalaxySelectInfo_show

.GalaxyInfoArea_Movement_Return:
addi      r11, r1, 0x100
bl _restgpr_25
lwz       r0, 0x104(r1)
mtlr      r0
addi      r1, r1, 0x100
blr


.GalaxyInfoArea_GetManagerName:
lis r3, GalaxyInfoArea_ObjNameString@ha
addi r3, r3, GalaxyInfoArea_ObjNameString@l
blr

#========================================================

.CreateGalaxySelectInfo:
li r4, -1
b __ct__16GalaxySelectInfoFl

#Gotta change GalaxySelectInfo::show((char const *,ulong))
#so I'm just gonna re-write it
#r6 tells us if we need to skip the galaxy details
#Used if we only want to load the banner and message

#TODO: Add a binding SOMEWHERE so people can make changes to the layout if they want.
.GLE PRINTMESSAGE -- GalaxySelectInfo::show(const char* GalaxyName, long, bool SkipDetails) --
.GLE PRINTADDRESS
.GalaxySelectInfo_show:
stwu      r1, -0x80(r1)
mflr      r0
stw       r0, 0x84(r1)
addi      r11, r1, 0x80
bl        _savegpr_26
lis       r30, GalaxySelectInfo_WorldMapGalaxyInformation@ha
addi      r30, r30, GalaxySelectInfo_WorldMapGalaxyInformation@l
mr        r27, r3
mr        r28, r4
mr        r26, r6

lbz r3, 0x41(r27)
cmpwi r3, 0
bne loc_804A9680

lwz       r0, 0x3C(r27)
cmpwi     r0, 0
mr        r29, r5
beq       loc_804A959C
mr        r3, r0
bl        isEqualString__2MRFPCcPCc
cmpwi     r3, 0
beq       loc_804A959C
stw       r29, 0x38(r27)
b         loc_804A9680

loc_804A959C:
mr        r3, r27
bl        isDead__2MRFPC11LayoutActor
cmpwi     r3, 0
beq       loc_804A95C0
lwz       r12, 0(r27)
mr        r3, r27
lwz       r12, 0x2C(r12)
mtctr     r12
bctrl

loc_804A95C0:
stw       r28, 0x3C(r27)
mr        r3, r27
mr        r4, r28
stw       r29, 0x38(r27)
bl        changeTexture__16GalaxySelectInfoFPCc
lwz       r3, 0x3C(r27)
bl        getGalaxyNameOnCurrentLanguage__2MRFPCc
mr        r5, r3
mr        r3, r27
#Leaving this here so I don't have to find it again when I inevidable get asked for it
.GLE PRINTMESSAGE == GalaxyInfoBanner Temp hook Position ==
.GLE PRINTADDRESS
addi      r4, r30, GalaxySelectInfo_GalaxyName - GalaxySelectInfo_WorldMapGalaxyInformation
bl        setTextBoxMessageRecursive__2MRFP11LayoutActorPCcPCw

cmpwi r26, 0
beq .GalaxySelectInfo_ShowGalaxy

mr        r3, r27
lis r4, GalaxyInfoArea_Star@ha
addi r4, r4, GalaxyInfoArea_Star@l
bl hidePaneRecursive__2MRFP11LayoutActorPCc
mr        r3, r27
lis r4, GalaxyInfoArea_Medal@ha
addi r4, r4, GalaxyInfoArea_Medal@l
bl hidePaneRecursive__2MRFP11LayoutActorPCc
b loc_804A9678

.GalaxySelectInfo_ShowGalaxy:
mr        r3, r27
lis r4, GalaxyInfoArea_Star@ha
addi r4, r4, GalaxyInfoArea_Star@l
bl showPaneRecursive__2MRFP11LayoutActorPCc
mr        r3, r27
lis r4, GalaxyInfoArea_Medal@ha
addi r4, r4, GalaxyInfoArea_Medal@l
bl showPaneRecursive__2MRFP11LayoutActorPCc
lwz       r29, 0x3C(r27)
mr        r3, r29
bl        makeGalaxyStatusAccessor__2MRFPCc
mr        r5, r29
addi      r3, r1, 0x08
li        r4, 0x46
li        r6, 0
bl        createGalaxyCompleteString__2MRFPwiPCcbb
slwi      r0, r3, 1
addi      r3, r1, 0x08
add       r3, r3, r0
addi      r31, r1, 0x08
subf      r0, r31, r3
mr        r5, r29
srawi     r0, r0, 1
li        r6, 0
addze     r0, r0
li        r7, 0
subfic    r4, r0, 0x46
bl        createStarString__2MRFPwiPCcbb
mr        r3, r27
mr        r5, r31
addi      r4, r30, GalaxySelectInfo_StarIcon - GalaxySelectInfo_WorldMapGalaxyInformation
bl        setTextBoxMessageRecursive__2MRFP11LayoutActorPCcPCw
mr        r3, r28
bl        isOnGalaxyFlagTicoCoin__16GameDataFunctionFPCc
cmpwi     r3, 0
beq       loc_804A966C
mr        r3, r27
addi      r4, r30, GalaxySelectInfo_TxtMedal - GalaxySelectInfo_WorldMapGalaxyInformation
bl        showPaneRecursive__2MRFP11LayoutActorPCc
b         loc_804A9678

loc_804A966C:
mr        r3, r27
addi      r4, r30, GalaxySelectInfo_TxtMedal - GalaxySelectInfo_WorldMapGalaxyInformation
bl        hidePaneRecursive__2MRFP11LayoutActorPCc


loc_804A9678:
mr        r3, r27
bl        appearLayout__16GalaxySelectInfoFv

loc_804A9680:
addi      r11, r1, 0x80
bl        _restgpr_26
lwz       r0, 0x84(r1)
mtlr      r0
addi      r1, r1, 0x80
blr


GalaxyInfoArea_ObjNameString:
    .string "GalaxyInfoArea"
    
#Generic message
#add 1 to the pointer if not only needing 1 star
GalaxyInfoArea_Unknown:
    .string "1UnknownGalaxy"
    
#Galaxies can have a specific message and banner
GalaxyInfoArea_UnknownSpecific_Format:
    .string "1UnknownGalaxy_%s"

GalaxyInfoArea_Star:
    .string "Star"
    
GalaxyInfoArea_Medal:
    .string "Medal" 
    
GalaxyInfoArea_TxtMedal:
    .string "TxtMedal" AUTO

GalaxyInfoArea_VTable:
.int 0
.int 0
.int __dt__9DeathAreaFv #Gonna use the DeathArea's Dtor and you can't stop me >:)
.int .GalaxyInfoArea_Init
.int initAfterPlacement__7NameObjFv
.int .GalaxyInfoArea_Movement
.int draw__7NameObjCFv
.int calcAnim__7NameObjFv
.int calcViewAndEntry__7NameObjFv
.int startMovement__7NameObjFv
.int endMovement__7NameObjFv
.int isInVolume__7AreaObjCFRCQ29JGeometry8TVec3<f>
.int getAreaPriority__7AreaObjCFv
.int .GalaxyInfoArea_GetManagerName
.int 0  #Padding




.GLE ADDRESS __ct__16GalaxySelectInfoFl +0x6C
b .GalaxySelectInfo_InitTimer
.GalaxySelectInfo_InitTimer_Return:
.GLE ENDADDRESS

.GalaxySelectInfo_InitTimer:
stb       r0, 0x40(r27)
stb       r4, 0x41(r27)
b .GalaxySelectInfo_InitTimer_Return


.GLE ADDRESS __vt__16GalaxySelectInfo +0x14
.int .GalaxySelectInfo_DecTimer
.GLE ENDADDRESS

.GalaxySelectInfo_DecTimer:
lbz r5, 0x41(r3)
cmpwi r5, 0
beq .GalaxySelectInfo_DecTimer_Skip

subi r5, r5, 1
stb r5, 0x41(r3)

.GalaxySelectInfo_DecTimer_Skip:
b movement__11LayoutActorFv


.GLE PRINTADDRESS
#r3 = Time Delay. Max 255
#returns 0 if failed to set timer
.GLE_TimeoutGalaxySelectInfo:
stwu      r1, -0x20(r1)
mflr      r0
stw       r0, 0x24(r1)
addi      r11, r1, 0x20
bl        _savegpr_29

mr r30, r3
li r3, 52
bl .GLE_GetSceneObj
cmpwi r3, 0
beq .GLE_TimeoutGalaxySelectInfo_Return

stb r30, 0x41(r3)
lwz       r12, 0(r3)
lwz       r12, 0x30(r12)
mtctr     r12
bctrl
li r3, 1

.GLE_TimeoutGalaxySelectInfo_Return:
addi      r11, r1, 0x20
bl        _restgpr_29
lwz       r0, 0x24(r1)
mtlr      r0
addi      r1, r1, 0x20
blr

.GLE PRINTMESSAGE EndWorldmapCode
.GLE PRINTADDRESS
.GALAXYINFOAREA_CONNECTOR:
.GLE ENDADDRESS


.GLE ADDRESS newEachObj__14SceneObjHolderFi +0x588
li r3, 0x44
.GLE ENDADDRESS
.GLE ADDRESS newEachObj__14SceneObjHolderFi +0x598
bl .CreateGalaxySelectInfo
.GLE ENDADDRESS