#Editing GameSystem to make a new layout for loading

.GLE ADDRESS .FILE_SELECT_CONNECTOR
#Instead of nopping this out, we're gonna use it!
#Puts old addresses to good use hopefully
.LoadIcon_StaticInit:
stwu      r1, -0x10(r1)
mflr      r0
stw r0, 0x14(r1)   #We may not even need to do this!

addi      r3, r13, unk_807D5F18 - STATIC_R13
lis r4, .NrvNull@ha
addi r4, r4, .NrvNull@l
stw r4, 0x00(r3)

lis r4, .NrvAppear@ha
addi r4, r4, .NrvAppear@l
stw r4, 0x04(r3)  #Is this cheating?

lis r4, .NrvWait@ha
addi r4, r4, .NrvWait@l
stw r4, 0x08(r3)  #This is probably cheating

lis r4, .NrvDisappear@ha
addi r4, r4, .NrvDisappear@l
stw r4, 0x0C(r3)  #Less code tho

lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr

#=============== GameSystem Changes =================
#We're gonna add this to GameSystem
#It will be at 0x3C

.GLE ADDRESS main +0xC8
li r3, 0x40
.GLE ENDADDRESS

.GLE ADDRESS initAfterStationedResourceLoaded__10GameSystemFv +0x54
#Gotta do this here so we have access to GameSettings.bcsv
b .GameSystem_InitEx
.GameSystem_InitEx_Return:
.GLE ENDADDRESS

.GameSystem_InitEx:
lis r3, LoadIcon_ActorName@ha
addi r3, r3, LoadIcon_ActorName@l
li r4, 1
bl .MR_GetGameSetting
cmpwi r3, 0

li r3, 0
stw r3, 0x3C(r31)

beq .GameSystem_InitEx_Finish
li r3, 0x3C
bl __nw__FUl
#We're at the start of the game, there's no way NEW will fail right now......right?
bl .LoadingIcon_Ctor
stw r3, 0x3C(r31)

#We can move right to init now too!
bl initWithoutIter__7NameObjFv

.GameSystem_InitEx_Finish:
lwz       r0, 0x14(r1)
b .GameSystem_InitEx_Return


.GLE ADDRESS update__10GameSystemFv +0x58
b .GameSystem_UpdateEx
.GameSystem_UpdateEx_Return:
.GLE ENDADDRESS

.GameSystem_UpdateEx:
lwz       r3, 0x3C(r30)
cmpwi r3, 0
beq .GameSystem_SkipLoadIcon

bl movement__11LayoutActorFv
lwz       r3, 0x3C(r30)
bl calcAnim__11LayoutActorFv


.GameSystem_SkipLoadIcon:
lwz       r3, 0x14(r30)
b .GameSystem_UpdateEx_Return



.GLE ADDRESS draw__10GameSystemFv +0x74
b .GameSystem_DrawEx
.GameSystem_DrawEx_Return:
.GLE ENDADDRESS

.GameSystem_DrawEx:
lwz       r3, 0x3C(r31)
cmpwi r3, 0
beq .GameSystem_SkipdrawLoadIcon
bl draw__11LayoutActorCFv

.GameSystem_SkipdrawLoadIcon:
lwz       r3, 0x14(r31)
b .GameSystem_DrawEx_Return


.GLE ADDRESS exePrepareReset__30GameSystemResetAndPowerProcessFv +0xA8
b .GameSystemReset_Ex
.GameSystemReset_Ex_Return:
.GLE ENDADDRESS

.GameSystemReset_Ex:
bl .MR_ResetLoadingIcon
mr        r3, r31
b .GameSystemReset_Ex_Return
#====================================================


#LoadingIcon::LoadingIcon((void))
.LoadingIcon_Ctor:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)

mr        r31, r3
lis r4, LoadIcon_ActorName@ha
addi r4, r4, LoadIcon_ActorName@l
li r5, 1
bl __ct__11LayoutActorFPCcb
lis r3, LoadIcon_VTable@ha
addi r3, r3, LoadIcon_VTable@l
stw r3, 0x00(r31)
li r3, 0
stb r3, 0x38(r31)
mr r3, r31

lwz       r31, 0x0C(r1)
lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr

#LoadingIcon::init((JMapInfoIter const &))
.LoadingIcon_Init:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
stw       r30, 0x08(r1)

mr        r31, r3
lis r30, LoadIcon_ActorName@ha
addi r30, r30, LoadIcon_ActorName@l
mr r4, r30
li r5, 1
bl initLayoutManager__11LayoutActorFPCcUl

mr r3, r31
mr r4, r30
li r5, 1
bl createAndAddPaneCtrl__2MRFP11LayoutActorPCcUl

mr r3, r31
addi      r4, r13, unk_807D5F18 - STATIC_R13
bl initNerve__11LayoutActorFPC5Nerve

lwz       r31, 0x0C(r1)
lwz       r30, 0x08(r1)
lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr

#MR::getLoadingLayout((void))
.MR_GetLoadingLayout:
lwz r3, sInstance__29SingletonHolder_10GameSystem_ - STATIC_R13(r13)
lwz r3, 0x3C(r3)
blr

#MR::startLoadingIcon((void))
#Waits until the time is right, then
#Simply sets the nerve to Appear
.MR_StartLoadingIcon:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)

bl .MR_GetLoadingLayout
cmpwi r3, 0
#If 0, layout is disabled
beq .startLoadingLayoutReturn

#Check to see if it's already out or not. Don't need to Appear it again if so.
bl .MR_IsLoadingIconOut
cmpwi r3, 0
bne .startLoadingLayoutReturn

#Here we wait
.StartLoadIcon_WaitLoop:

#Break if we start to shut down or reset the game
#TODO: This doesn't actually do anything helpful...?
#bl isResetProcessing__18GameSystemFunctionFv
#cmpwi r3, 0
#bne .startLoadingLayoutReturn

#Break if we are selecting a Scenario - We don't want this layout getting in the way!
#bl isScenarioSelecting__2MRFv
bl isScenarioDecided__2MRFv
cmpwi r3, 1
bne .startLoadingLayoutReturn

#Cancel if no system wipe is active
#bl isSystemWipeActive__2MRFv
#cmpwi r3, 0
#beq .SkipWipeWait

#Wait until the System wipe is blank
#bl isSystemWipeBlank__2MRFv
#cmpwi r3, 0
#beq .StartLoadIcon_WaitLoop

.SkipWipeWait:

bl .MR_GetLoadingLayout
addi      r4, r13, unk_807D5F1C - STATIC_R13
bl setNerve__11LayoutActorCFPC5Nerve

#set the layout to be the first frame of the appear animation, and then wait
bl .MR_GetLoadingLayout
lis r4, FirstFrameFloat@ha
lfs f1, FirstFrameFloat@l(r4)
lis r4, LoadIcon_Appear@ha
addi r4, r4, LoadIcon_Appear@l
li r5, 0
bl startAnimAndSetFrameAndStop__2MRFP11LayoutActorPCcfUl

bl .MR_GetLoadingLayout
bl appear__11LayoutActorFv

.startLoadingLayoutReturn:
lwz       r31, 0x0C(r1)
lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr

FirstFrameFloat:
.int 0x00000000

#MR::resetLoadingIcon((void))
.MR_ResetLoadingIcon:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
bl .MR_GetLoadingLayout
cmpwi r3, 0
beq .ResetReturn

addi      r4, r13, unk_807D5F18 - STATIC_R13
bl setNerve__11LayoutActorCFPC5Nerve

.ResetReturn:
lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr

#MR::endLoadingIcon((void))
#Simply sets the nerve to Disappear
.MR_EndLoadingIcon:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)

bl .MR_GetLoadingLayout
cmpwi r3, 0
#If 0, layout is disabled
beq .endLoadingLayoutReturn

addi      r4, r13, unk_807D5F24 - STATIC_R13
bl setNerve__11LayoutActorCFPC5Nerve

.endLoadingLayoutReturn:
lwz       r31, 0x0C(r1)
lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr


#Checks to see if the loading icon is active or not
.MR_IsLoadingIconOut:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)

bl .MR_GetLoadingLayout
cmpwi r3, 0
beq .isLoadingLayoutReturn

addi      r4, r13, unk_807D5F18 - STATIC_R13
bl isNerve__11LayoutActorCFPC5Nerve
xori r3, r3, 1

.isLoadingLayoutReturn:
lwz       r31, 0x0C(r1)
lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr

#NrvLoadingIcon::LoadingIconWaitNull::execute(const(Spine *))
.LoadingIcon_WaitNull:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)

lwz r31, 0x00(r4)

mr r3, r31
lis r4, FirstFrameFloat@ha
lfs f1, FirstFrameFloat@l(r4)
lis r4, LoadIcon_Appear@ha
addi r4, r4, LoadIcon_Appear@l
li r5, 0
bl startAnimAndSetFrameAndStop__2MRFP11LayoutActorPCcfUl

mr r3, r31
bl kill__11LayoutActorFv

mr r3, r31
bl showLayout__2MRFP11LayoutActor

li r3, 0
stb r3, 0x38(r31)

lwz       r31, 0x0C(r1)
lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr

#NrvLoadingIcon::LoadingIconAppear::execute(const(Spine *))

.GLE PRINTADDRESS

.LoadingIcon_Appear:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)

lwz r31, 0x00(r4)

#I gave up trying to fix this without doing this hardcoded stuff
#Should hopefully fix the loading icon during a game reset
bl isStageFileSelect__2MRFv
cmpwi r3, 1
beq .LoadIcon_SkipWipe

li r3, 37
bl isExistSceneObj__2MRFi
cmpwi r3, 0
beq .SkipSceneWipe

bl isWipeBlank__2MRFv
.SkipSceneWipe:
stw r3, 0x08(r1)

bl isSystemWipeBlank__2MRFv
#r3 already set
lwz r4, 0x08(r1)
cmpw r3, r4
beq .exeAppear_Return

.LoadIcon_SkipWipe:
mr r3, r31
li r4, 0
bl getAnimFrame__2MRFPC11LayoutActorUl
lis r4, FirstFrameFloat@ha
lfs f2, FirstFrameFloat@l(r4)
fcmpo     cr0, f1, f2
bne .TrySetNerveAfterAppearAnim

mr r3, r31
lis r4, LoadIcon_Appear@ha
addi r4, r4, LoadIcon_Appear@l
li r5, 0
bl startAnim__2MRFP11LayoutActorPCcUl

li r3, 1
stb r3, 0x38(r31)

.TrySetNerveAfterAppearAnim:
mr r3, r31
addi      r4, r13, unk_807D5F20 - STATIC_R13
li r5, 0
bl setNerveAtAnimStopped__2MRFP11LayoutActorPC5NerveUl

.exeAppear_Return:
lwz       r31, 0x0C(r1)
lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr

#NrvLoadingIcon::LoadingIconWait::execute(const(Spine *))
.LoadingIcon_Wait:
lwz r3, 0x00(r4)
lis r4, LoadIcon_Wait@ha
addi r4, r4, LoadIcon_Wait@l
li r5, 0
b startAnimAtFirstStep__2MRFP11LayoutActorPCcUl
#Quick and easy solution to play the wait animation
#This nerve doesn't need to end itself, rather, it will be ended when MR::endLoadingIcon((void)) is called


#NrvLoadingIcon::LoadingIconDisappear::execute(const(Spine *))
.GLE PRINTADDRESS
.LoadingIcon_Disappear:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)

#Critical difference from the Appear function, we only want to apply the disappear animation to the
#LoadIcon pane. This should let the wait animation continue and still play the disappear animation
lwz r31, 0x00(r4)

#If the layout has not yet been displayed, we need to skip the disappear animation
lbz r3, 0x38(r31)
cmpwi r3, 0
bne .DoDisappear
bl .MR_ResetLoadingIcon
b .DisappearReturn

.DoDisappear:
mr r3, r31
lis r4, LoadIcon@ha
addi r4, r4, LoadIcon@l
lis r5, LoadIcon_Disappear@ha
addi r5, r5, LoadIcon_Disappear@l
li r6, 0
bl startPaneAnimAtFirstStep__2MRFP11LayoutActorPCcPCcUl

mr r3, r31
lis r4, LoadIcon@ha
addi r4, r4, LoadIcon@l
addi      r5, r13, unk_807D5F18 - STATIC_R13
li r6, 0
bl setNerveAtPaneAnimStopped__2MRFP11LayoutActorPCcPC5NerveUl

.DisappearReturn:
lwz       r31, 0x0C(r1)
lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr

LoadIcon_ActorName:
    .string "LoadIcon"
    
LoadIcon_Appear:
    .string "Appear" 
    
LoadIcon_Wait:
    .string "Wait" 
    
LoadIcon_Disappear:
    .string "Disappear" AUTO
    
LoadIcon_VTable:
.int 0
.int 0
#Stealing another DTor
.int __dt__13BatteryLayoutFv
.int .LoadingIcon_Init
.int initAfterPlacement__7NameObjFv
.int movement__11LayoutActorFv
.int draw__11LayoutActorCFv
.int calcAnim__11LayoutActorFv
.int calcViewAndEntry__7NameObjFv
.int startMovement__7NameObjFv
.int endMovement__7NameObjFv
.int appear__11LayoutActorFv
.int kill__11LayoutActorFv
.int control__11LayoutActorFv

.NrvNull:
.int 0
.int 0
.int .LoadingIcon_WaitNull
.int executeOnEnd__5NerveCFP5Spine

.NrvAppear:
.int 0
.int 0
.int .LoadingIcon_Appear
.int executeOnEnd__5NerveCFP5Spine

.NrvWait:
.int 0
.int 0
.int .LoadingIcon_Wait
.int executeOnEnd__5NerveCFP5Spine

.NrvDisappear:
.int 0
.int 0
.int .LoadingIcon_Disappear
.int executeOnEnd__5NerveCFP5Spine


#End worldmap code
.LOAD_ICON_CONNECTOR:
.GLE ENDADDRESS