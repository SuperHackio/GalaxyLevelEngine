#Constants
.set MaxPerRow, 4
.set MaxTotalRows, 2
.set MaxStars, MaxPerRow * MaxTotalRows

.set BackFadeTime, 0x1A    #Normally 0x5A
#Idl if this is too much allocation but I'm not trusting this game for a second...
.set ParticleRamForStars, 0x08 * MaxStars


#Swapped the positions of these because they are in this order in the code.
.GLE ADDRESS init__19ScenarioSelectSceneFv +0x68
#More particles
li r6, ParticleRamForStars
.GLE ENDADDRESS


.GLE ADDRESS init__19ScenarioSelectSceneFv +0x27C
#increase memory of layout
li r3, 0xF0
.GLE ENDADDRESS




.GLE ADDRESS __ct__20ScenarioSelectLayoutFP12EffectSystemPC13CameraContext
#ScenarioSelectLayout::ScenarioSelectLayout((EffectSystem *,CameraContext const *)):
ScenarioSelectLayout_Ctor:
stwu r1, -0x20(r1)
mflr r0
stw r0,0x24(r1)
addi r11,r1,0x20
bl _savegpr_28

#this
mr r28,r3
#EffectSystem pointer
stw r4, 0x70(r3)
#CameraContext pointer
stw r5, 0x74(r3)

lis r4, ScenarioSelectLayout@ha
addi r4, r4, ScenarioSelectLayout@l
li r5, 1
bl __ct__11LayoutActorFPCcb

lis r3, ScenarioSelectLayout_VTable@ha
addi r3, r3, ScenarioSelectLayout_VTable@l
stw r3, 0(r28)

#SelectedScenarioID
#ScenarioNameID
li r4,-1
stw r4,0x2C(r28)
stw r4,0xE8(r28)

#IsDecided
#Array Pointer
#MultiSceneActor pointer
li r31,0
stb r31,0x34(r28)
stw r31,0x68(r28)
stw r31,0x6C(r28)

#Initilize Bubble Position Arrays
#Vector2<f>, hence the 8
li r3, MaxStars *8
bl __nwa__FUl
stw r3, 0x78(r28)

li r3,  MaxStars *8
bl __nwa__FUl
stw r3, 0x7C(r28)

li r3,  MaxStars *8
bl __nwa__FUl
stw r3, 0x80(r28)

#Sets all the Vector2<f> values to default 0,0
li r30,0
Ctor_Loop:
add r3,r28,r31
addi r3,r3,0xC0
bl zero__Q29JGeometry8TVec2<f>Fv
addi r30,r30,1
addi r31,r31,8
cmpwi r30,3
blt Ctor_Loop

#Enable Back Button
li r0,1
stw r0,0xDC(r28)

li r31,0
stw r31,0xD8(r28)
stw r31,0xE0(r28)
stw r31,0xE4(r28)

addi r3,r28,0x38
bl identity__Q29JGeometry38TMatrix34<Q29JGeometry13SMatrix34C<f>>Fv


#NEW
li r3, 8 #Initilize 2 arrays: Star Pane Name, and Back Button
bl __nwa__FUl
stw r3, 0xEC(r28)

li r3, MaxStars *4
bl __nwa__FUl
lwz r4, 0xEC(r28)
stw r3, 0x00(r4)

li r3, MaxPerRow *4
bl __nwa__FUl
lwz r4, 0xEC(r28)
stw r3, 0x04(r4)


addi r11,r1,0x20
mr r3,r28
bl _restgpr_28
lwz r0,0x24(r1)
mtlr r0
addi r1,r1,0x20
blr

#ScenarioSelectLayout::init((JMapInfoIter const &))
ScenarioSelectLayout_Init:
stwu      r1, -0x60(r1)
mflr      r0
stw       r0, 0x64(r1)
addi      r11, r1, 0x50
stfd      f31, 0x50(r1)
psq_st    f31, 0x58(r1), 0, 0
bl _savegpr_24

mr r31, r3
lis r27, ScenarioSelectLayout@ha
addi r27, r27, ScenarioSelectLayout@l

#Hack to not load r3 because r3 already has our LayoutActor
addi r4, r27, ScenarioSelect - ScenarioSelectLayout
li r5, 1
bl initLayoutManager__11LayoutActorFPCcUl

mr r3, r31
addi r4, r27, ScenarioSelect - ScenarioSelectLayout
li r5, 1
bl createAndAddPaneCtrl__2MRFP11LayoutActorPCcUl
mr r3, r31
addi r4, r27, ScenarioFrame - ScenarioSelectLayout
li r5, 1
bl createAndAddPaneCtrl__2MRFP11LayoutActorPCcUl
mr r3, r31
addi r4, r27, Scenario - ScenarioSelectLayout
li r5, 1
bl createAndAddPaneCtrl__2MRFP11LayoutActorPCcUl
mr r3, r31
addi r4, r27, StarTop - ScenarioSelectLayout
li r5, 1
bl createAndAddPaneCtrl__2MRFP11LayoutActorPCcUl
mr r3, r31
addi r4, r27, StarDown - ScenarioSelectLayout
li r5, 1
bl createAndAddPaneCtrl__2MRFP11LayoutActorPCcUl
mr r3, r31
addi r4, r27, BestTime - ScenarioSelectLayout
li r5, 1
bl createAndAddPaneCtrl__2MRFP11LayoutActorPCcUl
mr r3, r31
addi r4, r27, RaceTime - ScenarioSelectLayout
li r5, 1
bl createAndAddPaneCtrl__2MRFP11LayoutActorPCcUl

#Loop for the bubble pane controls
li r28, 0 #int i = 0
li r30, 0 #array pointer
BubblePaneLoop:
addi r3, r1, 0x10
addi r4, r28, 1
bl makeNewBubblePaneName
mr r3, r31
addi r4, r1, 0x10
li r5, 1
bl createAndAddPaneCtrl__2MRFP11LayoutActorPCcUl
lwz r30, 0x78(r31)
mulli r5, r28, 8
add r3, r30, r5
mr r4, r31
addi r5, r1, 0x10
bl setFollowPos__2MRFPCQ29JGeometry8TVec2<f>PC11LayoutActorPCc

addi r3, r1, 0x10
addi r4, r28, 1
bl makeHiddenBubblePaneName
mr r3, r31
addi r4, r1, 0x10
li r5, 1
bl createAndAddPaneCtrl__2MRFP11LayoutActorPCcUl
lwz r30, 0x7C(r31)
mulli r5, r28, 8
add r3, r30, r5
mr r4, r31
addi r5, r1, 0x10
bl setFollowPos__2MRFPCQ29JGeometry8TVec2<f>PC11LayoutActorPCc

addi r3, r1, 0x10
addi r4, r28, 1
bl makeCometBubblePaneName
mr r3, r31
addi r4, r1, 0x10
li r5, 1
bl createAndAddPaneCtrl__2MRFP11LayoutActorPCcUl
lwz r30, 0x80(r31)
mulli r5, r28, 8
add r3, r30, r5
mr r4, r31
addi r5, r1, 0x10
bl setFollowPos__2MRFPCQ29JGeometry8TVec2<f>PC11LayoutActorPCc

addi r28, r28, 1
cmpwi r28, MaxStars
blt BubblePaneLoop

#Continue assigning pane controls
mr r3, r31
addi r4, r27, Mario - ScenarioSelectLayout
li r5, 1
bl createAndAddPaneCtrl__2MRFP11LayoutActorPCcUl
mr r3, r31
addi r4, r27, CometAppear - ScenarioSelectLayout
li r5, 2
bl createAndAddPaneCtrl__2MRFP11LayoutActorPCcUl
addi r3, r31, 0xC0
mr r4, 31
addi r5, r27, StarTop - ScenarioSelectLayout
bl setFollowPos__2MRFPCQ29JGeometry8TVec2<f>PC11LayoutActorPCc
mr r3, r31
addi r4, r27, StarTop - ScenarioSelectLayout
bl setFollowTypeAdd__2MRFPC11LayoutActorPCc

#Continue to set the follow positions
addi r3, r31, 0xC8
mr r4, r31
addi r5, r27, RaceTime - ScenarioSelectLayout
bl setFollowPos__2MRFPCQ29JGeometry8TVec2<f>PC11LayoutActorPCc
mr r3, r31
addi r4, r27, RaceTime - ScenarioSelectLayout
bl setFollowTypeAdd__2MRFPC11LayoutActorPCc
addi r3, r31, 0xD0
mr r4, r31
addi r5, r27, Mario - ScenarioSelectLayout
bl setFollowPos__2MRFPCQ29JGeometry8TVec2<f>PC11LayoutActorPCc


mr r3, r31
li r4, MaxStars
bl initPointingTarget__11LayoutActorFi
mr r3, r31
li r4, 0
addi r5, r27, ScenarioSelect - ScenarioSelectLayout
lwz r6, 0x70(r31)
bl initEffectKeeper__11LayoutActorFiPCcPC12EffectSystem
mr r3, r31
addi r4, r27, ScenarioSelectEffect - ScenarioSelectLayout
addi r5, r31, 0x38
bl setEffectHostMtx__2MRFP11LayoutActorPCcPA4_f

#Let's initilize the ScenarioSelectStar objects
li        r3, MaxStars *4
bl __nwa__FUl
stw       r3, 0x68(r31)
lfs       f31, ScenarioSelectZero - STATIC_R2(r2) #0.0f

li        r24, 0
li        r30, 0
b .ScenarioSelectStarLoopStart
.ScenarioSelectStarLoop:
li        r3, 0x84
bl        __nw__FUl
cmpwi     r3, 0
beq- ScenarioSelectStarInitFailure
lwz       r5, 0x74(r31)
lwz       r4, 0x70(r31)
addi      r5, r5, 0x74
bl        __ct__18ScenarioSelectStarFP12EffectSystemi

ScenarioSelectStarInitFailure:
lwz       r4, 0x68(r31)
stwx      r3, r4, r30
lwz       r3, 0x68(r31)
lwzx      r3, r3, r30
bl        initWithoutIter__7NameObjFv
stfs      f31, 8(r1)
stfs      f31, 0xC(r1)

#make space for a permanent pane name
#Star1 = 5 bytes, pad to the 4th so we init 8 bytes
#Since ScenarioSelectLayout::init is only ever run once we don't need to track these strings
li        r3, 0x08
bl        __nw__FUl
cmpwi     r3, 0
beq- ScenarioSelectStarInitFailure

lwz r4, 0xEC(r31) #Load the name array table
lwz r4, 0x00(r4) #Get the StarPane Name array
stwx r3, r4, r30

stw r3, 0x10(r1) #Store on the stack as well to save on code lines
addi r4, r24, 1
bl makeStarPaneName

mr        r3, r31
lwz r4, 0x10(r1)
addi      r5, r1, 8
li        r6, 0

lfs       f1, StarPointerTargetRadius - STATIC_R2(r2) #60.0f
bl        addStarPointerTargetCircle__2MRFP11LayoutActorPCcfRCQ29JGeometry8TVec2<f>PCc
addi      r24, r24, 1
addi      r30, r30, 4
.ScenarioSelectStarLoopStart:
cmpwi     r24, MaxStars
blt+ .ScenarioSelectStarLoop

#FINISH IT
li        r3, 0x4C
bl __nw__FUl
cmpwi r3, 0
beq .MultiSceneActorInitFailure
addi r4, r27, EmptyScenarioSelection - ScenarioSelectLayout
addi r5, r27, ScenarioSelectSky - ScenarioSelectLayout
lwz       r6, 0x74(r31)
addi      r6, r6, 0x74
li r7, 0
bl __ct__15MultiSceneActorFPCcPCcib
.MultiSceneActorInitFailure:
stw       r3, 0x6C(r31)
bl initWithoutIter__7NameObjFv
li        r3, 0x34
bl __nw__FUl
cmpwi     r3, 0
beq .BackButtonInitFailure
addi r4, r4, BackButton - ScenarioSelectLayout
li r5, 0
bl __ct__17BackButtonCancelBFPCcb
.BackButtonInitFailure:
stw       r3, 0xD8(r31)
bl initWithoutIter__7NameObjFv
mr        r3, r31
addi r4,r13,sInstance__Q223NrvScenarioSelectLayout33ScenarioSelectLayoutNrvAppearStar - STATIC_R13
bl initNerve__11LayoutActorFPC5Nerve


#new: init the back button strings
mr        r3, r31
bl .ScenarioSelect_InitBackButton


addi      r11, r1, 0x50
psq_l     f31, 0x58(r1), 0, 0
lfd       f31, 0x50(r1)
bl       _restgpr_24
lwz       r0, 0x64(r1)
mtlr      r0
addi      r1, r1, 0x60
blr


#ScenarioSelectLayout::appear((void))
ScenarioSelectLayout_Appear:
stwu r1, -0x40(r1)
mflr r0
stw r0, 0x44(r1)
addi r11, r1, 0x40
bl _savegpr_24
mr r31, r3
bl showLayout__2MRFP11LayoutActor

mr r3, r31
addi      r4, r1, 0x0C
addi      r5, r1, 0x08
bl ScenarioSelectLayout_CalcDisplayScenarioNum

lis r28, ScenarioSelectLayout@ha
addi r28, r28, ScenarioSelectLayout@l

mr        r3, r31
addi r4, r28, ScenarioSelect - ScenarioSelectLayout
addi r5, r28, Appear - ScenarioSelectLayout
li        r6, 0
bl startPaneAnim__2MRFP11LayoutActorPCcPCcUl

lfs       f1, ScenarioSelectZero - STATIC_R2(r2) # 0.0f
mr        r3, r31
addi r4, r28, ScenarioSelect - ScenarioSelectLayout
li        r5, 0
bl setPaneAnimFrameAndStop__2MRFP11LayoutActorPCcfUl

mr        r3, r31
addi r4, r28, Appear - ScenarioSelectLayout
bl ScenarioSelectLayout_StartAnimAllNewPane

lfs       f1, ScenarioSelectZero - STATIC_R2(r2) # 0.0f
mr        r3, r31
bl ScenarioSelectLayout_SetAnimRateAllNewPane

mr        r3, r31
addi r4, r28, ScenarioFrame - ScenarioSelectLayout
addi r5, r28, Wait - ScenarioSelectLayout
li        r6, 0
bl startPaneAnim__2MRFP11LayoutActorPCcPCcUl




#=============================================




mr        r3, r31
addi r4, r28, StarTop - ScenarioSelectLayout
addi r5, r28, StarPositionTop - ScenarioSelectLayout
li        r6, 0
bl startPaneAnim__2MRFP11LayoutActorPCcPCcUl

lwz       r3, 0x0C(r1)
lis       r29, 0x4330
stw       r29, 0x10(r1)
addi      r0, r3, -1
lis       r30, FloatConversion@ha
lfd       f1, FloatConversion@l(r30)
xoris     r0, r0, 0x8000
stw       r0, 0x14(r1)
lfd       f0, 0x10(r1)
mr        r3, r31
fsubs     f1, f0, f1
addi r4, r28, StarTop - ScenarioSelectLayout
li        r5, 0
bl setPaneAnimFrameAndStop__2MRFP11LayoutActorPCcfUl

lwz       r0, 0x08(r1)
cmpwi     r0, 0
ble .ShiftStarTop

mr        r3, r31
addi      r4, r28, StarDown - ScenarioSelectLayout
addi      r5, r28, StarPositionDown - ScenarioSelectLayout
li        r6, 0
bl startPaneAnim__2MRFP11LayoutActorPCcPCcUl
lwz       r4, 0x08(r1)
stw       r29, 0x10(r1)
addi      r0, r4, -1
lfd       f1, FloatConversion@l(r30)
xoris     r0, r0, 0x8000
stw       r0, 0x14(r1)
lfd       f0, 0x10(r1)
mr        r3, r31
fsubs     f1, f0, f1
addi      r4, r28, StarDown - ScenarioSelectLayout
li        r5, 0
bl setPaneAnimFrameAndStop__2MRFP11LayoutActorPCcfUl

lfs       f0, ScenarioSelectZero - STATIC_R2(r2)
stfs      f0, 0xC4(r31)
b .ContinueSetup

.ShiftStarTop:
lfs       f0, StarTopShiftNum - STATIC_R2(r2)
stfs      f0, 0xC4(r31)




#=============================================




.ContinueSetup:
bl getCurrentGalaxyNameOnCurrentLanguage__2MRFv
cmpwi r3, 0
beq .SkipGalaxyNameSet
mr        r5, r3
mr        r3, r31
addi      r4, r28, Galaxy - ScenarioSelectLayout
bl setTextBoxMessageRecursive__2MRFP11LayoutActorPCcPCw

.SkipGalaxyNameSet:
mr r3, r31
addi r4, r28, Scenario - ScenarioSelectLayout
bl hidePaneRecursive__2MRFP11LayoutActorPCc
mr r3, r31
bl ScenarioSelectLayout_SetPlayerLeft
mr r3, r31
bl appear__11LayoutActorFv

li        r27, 1
li        r30, 0
b .BubblePaneLoopStart
#Loop for the bubble pane controls
.BubblePaneLoop:
addi r3, r1, 0x14
mr r4, r27
bl makeNewBubblePaneName
mr r3, r31
addi r4, r1, 0x14
bl hidePaneRecursive__2MRFP11LayoutActorPCc

addi r3, r1, 0x14
mr r4, r27
bl makeHiddenBubblePaneName
mr r3, r31
addi r4, r1, 0x14
bl hidePaneRecursive__2MRFP11LayoutActorPCc

addi r3, r1, 0x14
mr r4, r27
bl makeCometBubblePaneName
mr r3, r31
addi r4, r1, 0x14
bl hidePaneRecursive__2MRFP11LayoutActorPCc

addi r27, r27, 1
.BubblePaneLoopStart:
cmpwi r27, MaxStars+1
blt .BubblePaneLoop


mr        r3, r31
lwz       r4, 0x0C(r1)
lwz       r5, 0x08(r1)
bl ScenarioSelectLayout_AppearAllStar

mr        r3, r31
addi r4, r28, BestTime - ScenarioSelectLayout
addi r5, r28, SelectIn - ScenarioSelectLayout
li r6, 0
bl startPaneAnim__2MRFP11LayoutActorPCcPCcUl

mr        r3, r31
addi r4, r28, RaceTime - ScenarioSelectLayout
addi r5, r28, SelectIn - ScenarioSelectLayout
li r6, 0
bl startPaneAnim__2MRFP11LayoutActorPCcPCcUl

lfs       f1, ScenarioSelectZero - STATIC_R2(r2) #0.0f
mr        r3, r31
addi      r4, r28, BestTime - ScenarioSelectLayout
li        r5, 0
bl setPaneAnimFrameAndStop__2MRFP11LayoutActorPCcfUl

lfs       f1, ScenarioSelectZero - STATIC_R2(r2) #0.0f
mr        r3, r31
addi      r4, r28, RaceTime - ScenarioSelectLayout
li        r5, 0
bl setPaneAnimFrameAndStop__2MRFP11LayoutActorPCcfUl

#Don't ask me what this does I have no idea
lis       r3, FloatTable@ha
lfs       f0, FloatTable@l(r3)
lwz       r4, 0x6C(r31)
addi      r3, r3, FloatTable@l
stfs      f0, 0x14(r4)
lfs       f0, 0(r3)
stfs      f0, 0x18(r4)
lfs       f0, 0x04(r3)
stfs      f0, 0x1C(r4)
lfs       f0, SkyBgMatrixThing - STATIC_R2(r2) #10.0f
lwz       r3, 0x6C(r31)
stfs      f0, 0x2C(r3)
stfs      f0, 0x30(r3)
stfs      f0, 0x34(r3)
lwz       r3, 0x6C(r31)
lwz       r12, 0(r3)
lwz       r12, 0x2C(r12)
mtctr     r12
bctrl


lwz       r3, 0x6C(r31)
addi      r4, r28, ScenarioSelectSky - ScenarioSelectLayout
bl startBtk__10MultiSceneFP15MultiSceneActorPCc

mr        r3, r31
addi      r4, r28, CometAppear - ScenarioSelectLayout
bl hidePaneRecursive__2MRFP11LayoutActorPCc
li        r0, 0
li        r3, -1
stw       r3, 0x2C(r31)
stw       r0, 0x30(r31)
stb       r0, 0x34(r31)

#Restore this to remove the back button when you have 0 stars.
#bl getPowerStarNum__2MRFv
#neg       r0, r3
#andc      r0, r0, r3
#srwi      r0, r0, 31
li r0, 1
stb       r0, 0xDC(r31)

mr        r3, r31
addi      r4, r13, sInstance__Q223NrvScenarioSelectLayout33ScenarioSelectLayoutNrvAppearStar - STATIC_R13
bl setNerve__11LayoutActorCFPC5Nerve

#The End
addi      r11, r1, 0x40
bl        _restgpr_27
lwz       r0, 0x44(r1)
mtlr      r0
addi      r1, r1, 0x40
blr

#ScenarioSelectLayout::kill((void))
ScenarioSelectLayout_Kill:
stwu      r1, -0x20(r1)
mflr      r0
stw       r0, 0x24(r1)
addi      r11, r1, 0x20
bl        _savegpr_29
mr        r29, r3
lis r4, ScenarioSelectEffect@ha
addi r4, r4, ScenarioSelectEffect@l
bl        getEffect__2MRFPC11LayoutActorPCc
lwz       r4, 0x70(r29)
bl        forceDelete__12MultiEmitterFP12EffectSystem
li        r30, 0
li        r31, 0

.loc_8048D964:
lwz       r3, 0x68(r29)
lwzx      r3, r3, r31
lbz       r0, 0x38(r3)
cmpwi     r0, 0
bne       .loc_8048D988
lwz       r12, 0(r3)
lwz       r12, 0x30(r12)
mtctr     r12
bctrl

.loc_8048D988:
addi      r30, r30, 1
addi      r31, r31, 4
cmpwi     r30, MaxStars
blt       .loc_8048D964
lwz       r3, 0x6C(r29)
lwz       r12, 0(r3)
lwz       r12, 0x30(r12)
mtctr     r12
bctrl
lwz       r3, 0xD8(r29)
lwz       r12, 0(r3)
lwz       r12, 0x30(r12)
mtctr     r12
bctrl
mr        r3, r29
bl        kill__11LayoutActorFv
addi      r11, r1, 0x20
bl        _restgpr_29
lwz       r0, 0x24(r1)
mtlr      r0
addi      r1, r1, 0x20
blr

#ScenarioSelectLayout::movement((void))
ScenarioSelectLayout_Movement:
stwu      r1, -0x20(r1)
mflr      r0
stw       r0, 0x24(r1)
addi      r11, r1, 0x20
bl        _savegpr_29
mr        r29, r3
bl        movement__11LayoutActorFv
li        r30, 0
li        r31, 0

loc_8048DA04:
lwz       r3, 0x68(r29) # ScenarioSelectStar[] pointer
lwzx      r3, r3, r31
lwz       r12, 0(r3)
lwz       r12, 0x14(r12)
mtctr     r12
bctrl
addi      r30, r30, 1
addi      r31, r31, 4
cmpwi     r30, MaxStars
blt       loc_8048DA04
lwz       r3, 0x6C(r29) # MultiSceneActor pointer
lwz       r12, 0(r3)
lwz       r12, 0x14(r12)
mtctr     r12
bctrl
lwz       r3, 0xD8(r29) # BackButton Pointer
lwz       r12, 0(r3)
lwz       r12, 0x14(r12)
mtctr     r12
bctrl
addi      r11, r1, 0x20
bl        _restgpr_29
lwz       r0, 0x24(r1)
mtlr      r0
addi      r1, r1, 0x20
blr

#ScenarioSelectLayout::calcAnim((void))
ScenarioSelectLayout_CalcAnim:
stwu      r1, -0x20(r1)
mflr      r0
stw       r0, 0x24(r1)
addi      r11, r1, 0x20
bl        _savegpr_29
mr        r29, r3
bl        calcAnim__11LayoutActorFv
li        r30, 0
li        r31, 0

loc_8048DA94:
lwz       r3, 0x68(r29)
lwzx      r3, r3, r31
lwz       r12, 0(r3)
lwz       r12, 0x1C(r12)
mtctr     r12
bctrl
addi      r30, r30, 1
addi      r31, r31, 4
cmpwi     r30, MaxStars
blt       loc_8048DA94
lwz       r3, 0x6C(r29)
lwz       r12, 0(r3)
lwz       r12, 0x1C(r12)
mtctr     r12
bctrl
lwz       r3, 0xD8(r29)
lwz       r12, 0(r3)
lwz       r12, 0x1C(r12)
mtctr     r12
bctrl
addi      r11, r1, 0x20
bl        _restgpr_29
lwz       r0, 0x24(r1)
mtlr      r0
addi      r1, r1, 0x20
blr

#ScenarioSelectLayout::draw(const(void))
ScenarioSelectLayout_Draw:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
mr        r31, r3
bl        draw__11LayoutActorCFv
lwz       r3, 0xD8(r31)
lwz       r12, 0(r3)
lwz       r12, 0x18(r12)
mtctr     r12
bctrl
lwz       r0, 0x14(r1)
lwz       r31, 0x0C(r1)
mtlr      r0
addi      r1, r1, 0x10
blr
.GLE ASSERT calcViewAndEntryStarModel__20ScenarioSelectLayoutFv

#TODO: Might be region locked? Likely not though...
.GLE ADDRESS control__20ScenarioSelectLayoutFv +0x34
lwz       r5, 0xE0(r31)
mr        r4, r31
addi      r3, r31, 0xD0


#ScenarioSelectLayout::calcDisplayScenarioNum(const(long *,long *))
.GLE ADDRESS calcDisplayScenarioNum__20ScenarioSelectLayoutCFPlPl -0x0C
ScenarioSelectLayout_CalcDisplayScenarioNum:
stwu      r1, -0x40(r1)
mflr      r0
stw       r0, 0x44(r1)
addi      r11, r1, 0x40
bl _savegpr_25
mr        r27, r4 #Top Row
mr        r28, r5 #Bottom Row
bl makeCurrentGalaxyStatusAccessor__2MRFv
stw       r3, 0x0C(r1)

#First thing's first, lets check if the user set an override
#Get the GalaxyInfo BCSV File
addi r3, r1, 0x0C
bl getWorldNo__20GalaxyStatusAccessorCFv
mr r25, r3

li r26, 0
b CalcDisplayScenarioNumLoop_Start

CalcDisplayScenarioNumLoop:
addi r3, r1, 0x08
mr r4, r25
lis r5, Type@ha
addi r5, r5, Type@l
mr r6, r26
bl getCsvDataStr__2MRFPPCcPC8JMapInfoPCcl

cmpwi r3, 0
#Error, Likely the field does not exist
beq- CalcDisplayScenarioNumLoop_DefaultResult

lwz r3, 0x08(r1)
lis r4, TopNo@ha
addi r4, r4, TopNo@l
bl isEqualString__2MRFPCcPCc
cmpwi r3, 1
#Skip entries that aren't marked as TopNo conditions
bne CalcDisplayScenarioNumLoop_Continue

mr r3, r25
mr r4, r26
#Do this to see if we should validate this number or not
bl isJMapEntryProgressComplete
cmpwi r3, 0
beq CalcDisplayScenarioNumLoop_Continue

addi r3, r1, 0x08
mr r4, r25
lis r5, Param00Int@ha
addi r5, r5, Param00Int@l
mr r6, r26
bl getCsvDataS32__2MRFPlPC8JMapInfoPCcl
lwz r25, 0x08(r1)
#Not gonna bother clamping since users could technically make custom anims to support any value here...
b CalcDisplayScenarioNumLoop_Break

CalcDisplayScenarioNumLoop_Continue:
addi r26, r26, 1

CalcDisplayScenarioNumLoop_Start:
mr r3, r25
bl getCsvDataElementNum__2MRFPC8JMapInfo
cmpw r26, r3
blt+ CalcDisplayScenarioNumLoop

#If an entry is not found, default to half the star count.
CalcDisplayScenarioNumLoop_DefaultResult:
li r25, MaxStars/MaxTotalRows
CalcDisplayScenarioNumLoop_Break:

li r30, 0
stw r30, 0(r27)
stw r30, 0(r28)
li r29, 1
li r26, 0
b .CalcDisplayScenarioNum_ValueLoopStart

.CalcDisplayScenarioNum_ValueLoop:
mr r3, r29
bl hasPowerStarInCurrentStage__2MRFl
cmpwi r3, 0
beq .CalcDisplayScenarioNum_ValueLoopDoesNotHavePowerStar

#Has Power Star
cmpw r26, r25
bge .CalcDisplayScenarioNum_ValueLoopAddStarBottomRow
b .CalcDisplayScenarioNum_ValueLoopAddStarTopRow

.CalcDisplayScenarioNum_ValueLoopDoesNotHavePowerStar:
cmpwi r30, 0
bne .CalcDisplayScenarioNum_ValueLoopContinue

addi r3, r1, 0x0C
mr r4, r29
bl isHiddenStar__20GalaxyStatusAccessorCFl
cmpwi r3, 0
bne .CalcDisplayScenarioNum_ValueLoopContinue

addi r3, r1, 0x0C
mr r4, r29
#Branch to the cutsom one directly because we can
bl GalaxyStatusAccessor__isStarOpen
cmpwi r3, 0
beq .CalcDisplayScenarioNum_ValueLoopContinue
li r30, 0
cmpw r26, r25
bge .CalcDisplayScenarioNum_ValueLoopAddStarBottomRow

.CalcDisplayScenarioNum_ValueLoopAddStarTopRow:
lwz       r3, 0(r27)
addi      r0, r3, 1
stw       r0, 0(r27)
b .CalcDisplayScenarioNum_ValueLoopStarIncrement

.CalcDisplayScenarioNum_ValueLoopAddStarBottomRow:
lwz       r3, 0(r28)
addi      r0, r3, 1
stw       r0, 0(r28)

.CalcDisplayScenarioNum_ValueLoopStarIncrement:
addi r26, r26, 1

.CalcDisplayScenarioNum_ValueLoopContinue:
addi r29, r29, 1

.CalcDisplayScenarioNum_ValueLoopStart:
addi r3, r1, 0x0C
bl .GetPowerStarNumOrMax
cmpw r29, r3
ble .CalcDisplayScenarioNum_ValueLoop

addi      r11, r1, 0x40
bl        _restgpr_25
lwz       r0, 0x44(r1)
mtlr      r0
addi      r1, r1, 0x40
blr

#========================================
ScenarioSelectLayout_AppearAllStar:
stwu      r1, -0x120(r1)
mflr      r0
stw       r0, 0x124(r1)
addi      r11, r1, 0x120
bl __save_gpr

mr r29, r3 #The Scenario Select Layout object
mr r30, r4 #The Upper Star Count
mr r31, r5 #The Lower Star Count
bl makeCurrentGalaxyStatusAccessor__2MRFv
stw       r3, 0x20(r1)

#Disable comets on this galaxy
addi r3, r1, 0x20
bl getName__20GalaxyStatusAccessorCFv
bl offGalaxyFlagComet__16GameDataFunctionFPCc

addi r3, r1, 0x20
bl isCompleteAllScenario__20GalaxyStatusAccessorCFv
cmpwi r3, 0
li r31, 1
beq .AllScenarioNotComplete
li r31, 2
.AllScenarioNotComplete:

li r25, 1 #Star Pane ID
li r22, 0
li r26, 1 #New Bubble ID
#
li r28, 1 #Hidden Bubble ID
li r23, 1 #Comet Bubble ID
li r21, 0
li r20, 1
b .ScenarioSelectLayout_AppearAllStar_LoopStart

.ScenarioSelectLayout_AppearAllStar_Loop:
addi r3, r1, 0x20
mr r4, r20
bl hasPowerStar__20GalaxyStatusAccessorCFl
cmpwi r3, 0
beq .ScenarioSelectLayout_AppearAllStar_DoesNotHavePowerStar

#The player has the Power Star
mr r3, r29
#mr r4, r25
subi r4, r25, 1
mr r5, r20
mr r6, r31
mr r7, r25
bl ScenarioSelectLayout_AppearStar
b .ScenarioSelectLayout_AppearAllStar_LoopAddStarPane

.ScenarioSelectLayout_AppearAllStar_DoesNotHavePowerStar:
addi r3, r1, 0x20
mr r4, r20
bl isHiddenStar__20GalaxyStatusAccessorCFl
cmpwi r3, 0
bne .ScenarioSelectLayout_AppearAllStar_StarIsHidden
cmpwi r21, 0
bne .ScenarioSelectLayout_AppearAllStar_LoopContinue
addi r3, r1, 0x20
mr r4, r20
bl GalaxyStatusAccessor__isStarOpen
cmpwi r3, 0
beq .ScenarioSelectLayout_AppearAllStar_LoopContinue

mr r3, r29
subi r4, r25, 1
mr r5, r20
li r6, 0
mr r7, r25
bl ScenarioSelectLayout_AppearStar
li r21, 0
addi r3, r1, 0x20
mr r4, r20
bl isStarComet__20GalaxyStatusAccessorCFl
cmpwi r3, 0
beq .ScenarioSelectLayout_AppearAllStar_StarIsNotComet

#This star has an unobtained comet! Set the flag!
addi r3, r1, 0x20
bl getName__20GalaxyStatusAccessorCFv
bl onGalaxyFlagComet__16GameDataFunctionFPCc

addi r3, r1, 0x60
mr r4, r23
bl makeCometBubblePaneName
mr r3, r29
addi r4, r1, 0x60
bl showPaneRecursive__2MRFP11LayoutActorPCc

addi r3, r1, 0x60
mr r4, r25
bl makeStarPaneName

lwz r3, 0x80(r29)
subi r5, r23, 1
bl LOCAL_CopyPaneTranslation
addi r23, r23, 1
b .ScenarioSelectLayout_AppearAllStar_LoopAddStarPane

.ScenarioSelectLayout_AppearAllStar_StarIsNotComet:
addi r3, r1, 0x60
mr r4, r26
bl makeNewBubblePaneName
mr r3, r29
addi r4, r1, 0x60
bl showPaneRecursive__2MRFP11LayoutActorPCc

addi r3, r1, 0x60
mr r4, r25
bl makeStarPaneName

lwz r3, 0x78(r29)
subi r5, r26, 1
bl LOCAL_CopyPaneTranslation
addi r26, r26, 1
b .ScenarioSelectLayout_AppearAllStar_LoopAddStarPane

.ScenarioSelectLayout_AppearAllStar_StarIsHidden:
bl getCurrentStageName__2MRFv
mr r24, r3
#Not needed. Simply requires all normal stars before displaying hiddens.
#bl* MR::isStarCompleteNormalScenario((charconst*))
#cmpwi r3, 0
#beq .LoopIncrement
addi r3, r1, 0x20
mr r4, r20
bl GalaxyStatusAccessor__isStarOpen
cmpwi r3, 0
beq .ScenarioSelectLayout_AppearAllStar_LoopContinue
mr r3, r24
mr r4, r20
bl getPlacedHiddenStarScenarioNo__2MRFPCcl
mr r24, r3

addi r3, r1, 0x60
mr r4, r28
bl makeHiddenBubblePaneName
mr r3, r29
addi r4, r1, 0x60
bl showPaneRecursive__2MRFP11LayoutActorPCc

addi r3, r1, 0x60
mr r4, r24
bl makeStarPaneName

lwz r3, 0x7C(r29)
subi r5, r28, 1
bl LOCAL_CopyPaneTranslation
addi r28, r28, 1
b .ScenarioSelectLayout_AppearAllStar_LoopContinue



.ScenarioSelectLayout_AppearAllStar_LoopAddStarPane:
addi r25, r25, 1
addi r22, r22, 1
cmpw r25, r30
ble .ScenarioSelectLayout_AppearAllStar_LoopContinue
li r0, MaxStars/MaxTotalRows
cmpw r25, r0
bgt .ScenarioSelectLayout_AppearAllStar_LoopContinue

#Small correction
#r25 = r25 + ((MaxStars/MaxTotalRows) - r25)
li r0, MaxStars/MaxTotalRows
sub r3, r0, r25
add r25, r25, r3
addi r25, r25, 1

.ScenarioSelectLayout_AppearAllStar_LoopContinue:
addi r20, r20, 1

.ScenarioSelectLayout_AppearAllStar_LoopStart:
addi r3, r1, 0x20
bl .GetPowerStarNumOrMax
cmpw r20, r3
ble .ScenarioSelectLayout_AppearAllStar_Loop


addi      r11, r1, 0x120
bl __restore_gpr
lwz r0, 0x124(r1)
mtlr      r0
addi      r1, r1, 0x120
blr

#Local. don't use in any other function
LOCAL_CopyPaneTranslation:
mulli r5, r5, 8
add r3, r3, r5
mr r4, r29
addi r5, r1, 0x60
b copyPaneTrans__2MRFPQ29JGeometry8TVec2<f>PC11LayoutActorPCc

#========================================
ScenarioSelectLayout_AppearStar:
stwu      r1, -0x70(r1)
mflr      r0
stw       r0, 0x74(r1)
addi      r11, r1, 0x70
bl _savegpr_27
lwz       r8, 0x68(r3)
slwi      r0, r4, 2
mr        r27, r3
mr        r28, r4
mr        r29, r5
mr        r30, r6
lwzx      r31, r8, r0

addi r3, r1, 0x14
mr r4, r7
bl makeStarPaneName

addi      r3, r1, 0x08
mr        r4, r27
addi r5, r1, 0x14
bl copyPaneTrans__2MRFPQ29JGeometry8TVec2<f>PC11LayoutActorPCc
lfs       f1, ScreenPosZ - STATIC_R2(r2) #1000.0f
mr        r3, r27
addi      r4, r1, 0x10
addi      r5, r1, 0x08
bl calcWorldPositionFromScreenPos__20ScenarioSelectLayoutCFPQ29JGeometry8TVec3<f>RCQ29JGeometry8TVec2<f>f
mr        r3, r31
mr        r4, r29
mr        r5, r30
mr        r7, r28
addi      r6, r1, 0x10
bl setup__18ScenarioSelectStarFliRCQ29JGeometry8TVec3<f>l
lwz       r12, 0(r31)
mr        r3, r31
lwz       r12, 0x2C(r12)
mtctr     r12
bctrl
addi      r11, r1, 0x70
bl _restgpr_27
lwz       r0, 0x74(r1)
mtlr      r0
addi      r1, r1, 0x70
blr
.GLE ASSERT isAppearStarEndAll__20ScenarioSelectLayoutCFv

.GLE ADDRESS isAppearStarEndAll__20ScenarioSelectLayoutCFv +0x50
cmpwi r30, MaxStars
.GLE ENDADDRESS

.GLE ADDRESS tryCancel__20ScenarioSelectLayoutFv +0x14
lbz r0, 0xDC(r3)
.GLE ENDADDRESS

.GLE ADDRESS tryCancel__20ScenarioSelectLayoutFv +0x28
lwz       r3, 0xD8(r3)
.GLE ENDADDRESS

.GLE ADDRESS calcViewAndEntryStarModel__20ScenarioSelectLayoutFv +0x40
cmpwi r30, MaxStars
.GLE ENDADDRESS

.GLE ADDRESS setPlayerLeft__20ScenarioSelectLayoutFv -0x0C
ScenarioSelectLayout_SetPlayerLeft:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
stw       r30, 0x08(r1)
lis r31, ScenarioSelectLayout@ha
addi r31, r31, ScenarioSelectLayout@l
mr        r30, r3

addi r4, r31, ShaMario - ScenarioSelectLayout
addi      r5, r31, PlayerLeft - ScenarioSelectLayout
bl setTextBoxGameMessageRecursive__2MRFP11LayoutActorPCcPCc

bl getPlayerLeft__2MRFv
mr        r5, r3
mr        r3, r30
addi      r4, r31, ShaMarioNum - ScenarioSelectLayout
bl setTextBoxNumberRecursive__2MRFP11LayoutActorPCcl

bl getPlayerLeft__2MRFv
cmpwi     r3, 0xA
bge       .loc_8048EB48
addi      r0, r31, MarioPosition01 - ScenarioSelectLayout
stw       r0, 0xE0(r30)
b         .loc_8048EB50

.loc_8048EB48:
addi      r0, r31, MarioPosition10 - ScenarioSelectLayout
stw       r0, 0xE0(r30)

.loc_8048EB50:
lwz       r0, 0x14(r1)
lwz       r31, 0x0C(r1)
lwz       r30, 0x08(r1)
mtlr      r0
addi      r1, r1, 0x10
blr

.GLE ASSERT startAnimAllNewPane__20ScenarioSelectLayoutFPCc
ScenarioSelectLayout_StartAnimAllNewPane:
stwu      r1, -0x60(r1)
mflr      r0
stw       r0, 0x64(r1)
addi      r11, r1, 0x60
bl _savegpr_27
mr        r30, r3
mr        r28, r4
li        r29, 1

ScenarioSelectLayout_StartAnimAllNewPane_BubblePaneLoop:
addi      r3, r1, 0x20
mr        r4, r29
bl makeNewBubblePaneName
bl LOCAL_StartAnimNewPane

addi      r3, r1, 0x20
mr        r4, r29
bl makeHiddenBubblePaneName
bl LOCAL_StartAnimNewPane

addi      r3, r1, 0x20
mr        r4, r29
bl makeCometBubblePaneName
bl LOCAL_StartAnimNewPane

addi r29, r29, 1
cmpwi r29, MaxStars
ble ScenarioSelectLayout_StartAnimAllNewPane_BubblePaneLoop

addi      r11, r1, 0x60
bl _restgpr_27
lwz       r0, 0x64(r1)
mtlr      r0
addi      r1, r1, 0x60
blr

LOCAL_StartAnimNewPane:
mr r3, r30
addi r4, r1, 0x20
mr r5, r28
li r6, 0
b startPaneAnim__2MRFP11LayoutActorPCcPCcUl

#========================================
ScenarioSelectLayout_SetAnimRateAllNewPane:
stwu      r1, -0x60(r1)
mflr      r0
stw       r0, 0x64(r1)
addi      r11, r1, 0x50
stfd      f31, 0x50(r1)
bl       _savegpr_28
fmr       f31, f1
mr        r28, r3
li        r29, 1

ScenarioSelectLayout_SetAnimRateAllNewPane_BubblePaneLoop:

addi      r3, r1, 0x20
mr        r4, r29
bl makeNewBubblePaneName
bl LOCAL_SetAnimRateNewPane

addi      r3, r1, 0x20
mr        r4, r29
bl makeHiddenBubblePaneName
bl LOCAL_SetAnimRateNewPane

addi      r3, r1, 0x20
mr        r4, r29
bl makeCometBubblePaneName
bl LOCAL_SetAnimRateNewPane

addi r29, r29, 1
cmpwi r29, MaxStars
ble ScenarioSelectLayout_SetAnimRateAllNewPane_BubblePaneLoop

addi      r11, r1, 0x50
lfd       f31, 0x50(r1)
bl _restgpr_28
lwz       r0, 0x64(r1)
mtlr      r0
addi      r1, r1, 0x60
blr

LOCAL_SetAnimRateNewPane:
mr        r3, r28
addi      r4, r1, 0x20
li        r5, 0
fmr       f1, f31
b setPaneAnimRate__2MRFP11LayoutActorPCcfUl

.GLE ASSERT exeAppearStar__20ScenarioSelectLayoutFv

#========================================
.GLE ADDRESS exeAppearStar__20ScenarioSelectLayoutFv
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
stw       r30, 0x08(r1)
lis r31, ScenarioSelectLayout@ha
addi r31, r31, ScenarioSelectLayout@l
mr r30, r3
bl isFirstStep__2MRFPC11LayoutActor

cmpwi     r3, 0
beq       .loc_8048ED50
bl permitTrigSE__2MRFv
mr        r3, r30
addi r4, r31, ScenarioSelectEffect - ScenarioSelectLayout
bl getEffect__2MRFPC11LayoutActorPCc
lwz       r4, 0x70(r30)
bl create__12MultiEmitterFP12EffectSystem
lfs       f1, EffectRate - STATIC_R2(r2) #2.0
mr        r3, r30
addi r4, r31, ScenarioSelectEffect - ScenarioSelectLayout
bl setEffectRate__2MRFP11LayoutActorPCcf
lfs       f1, EffectDirectionalSpeed - STATIC_R2(r2)
mr        r3, r30
addi r4, r31, ScenarioSelectEffect - ScenarioSelectLayout
bl setEffectDirectionalSpeed__2MRFP11LayoutActorPCcf

#Function located in ScenarioUtility
bl startScenarioSelectBgm

.loc_8048ED50:
addi r3, r31, SE_DM_LV_SENARIO_SEL_FLY - ScenarioSelectLayout
li        r4, -1
li        r5, -1
bl startSystemLevelSE__2MRFPCcll
mr        r3, r30
bl isAppearStarEndAll__20ScenarioSelectLayoutCFv
cmpwi     r3, 0
beq       .loc_8048EDB8

#Check if there's a Comet Active
li        r31, 0
bl        getCurrentStageName__2MRFv
bl        isOnGalaxyFlagComet__16GameDataFunctionFPCc
cmpwi     r3, 0
beq       .loc_8048ED90
li        r31, 1

.loc_8048ED90:
cmpwi     r31, 0
beq       .loc_8048EDAC
mr        r3, r30
addi      r4, r13, sInstance__Q223NrvScenarioSelectLayout41ScenarioSelectLayoutNrvAppearCometWarning - STATIC_R13
bl setNerve__11LayoutActorCFPC5Nerve
b         .loc_8048EDB8

.loc_8048EDAC:
mr        r3, r30
addi      r4, r13, sInstance__Q223NrvScenarioSelectLayout29ScenarioSelectLayoutNrvAppear - STATIC_R13
bl setNerve__11LayoutActorCFPC5Nerve

.loc_8048EDB8:
lwz       r0, 0x14(r1)
lwz       r31, 0x0C(r1)
lwz       r30, 0x08(r1)
mtlr      r0
addi      r1, r1, 0x10
blr

.GLE ASSERT exeAppear__20ScenarioSelectLayoutFv
.GLE ENDADDRESS

#========================================
.GLE ADDRESS exeAppear__20ScenarioSelectLayoutFv
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
mr        r31, r3
bl        isFirstStep__2MRFPC11LayoutActor
cmpwi     r3, 0
beq       .loc_8048EE14
lfs       f1, ScenarioSelectOne - STATIC_R2(r2) #1.0f
mr        r3, r31
lis r4, ScenarioSelect@ha
addi r4, r4, ScenarioSelect@l
li        r5, 0
bl setPaneAnimRate__2MRFP11LayoutActorPCcfUl

lfs       f1, ScenarioSelectOne - STATIC_R2(r2)
mr        r3, r31
bl ScenarioSelectLayout_SetAnimRateAllNewPane

.loc_8048EE14:
lis r3, SE_DM_LV_SENARIO_SEL_FLY@ha
addi r3, r3, SE_DM_LV_SENARIO_SEL_FLY@l
li        r4, -1
li        r5, -1
bl startSystemLevelSE__2MRFPCcll
mr        r3, r31
lis r4, ScenarioSelect@ha
addi r4, r4, ScenarioSelect@l
addi      r5, r13, sInstance__Q223NrvScenarioSelectLayout41ScenarioSelectLayoutNrvWaitScenarioSelect - STATIC_R13
li        r6, 0
bl setNerveAtPaneAnimStopped__2MRFP11LayoutActorPCcPC5NerveUl
lwz       r0, 0x14(r1)
lwz       r31, 0x0C(r1)
mtlr      r0
addi      r1, r1, 0x10
blr

.GLE ASSERT sub_8048EE60

.GLE ADDRESS exeWaitScenarioSelect__20ScenarioSelectLayoutFv
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0xC(r1)
lis r31, ScenarioSelectLayout@ha
addi r31, r31, ScenarioSelectLayout@l
stw       r30, 8(r1)
mr        r30, r3
bl        isFirstStep__2MRFPC11LayoutActor
cmpwi     r3, 0
beq       .loc_8048F238
mr        r3, r30
addi r4, r31, NewWait - ScenarioSelectLayout
bl ScenarioSelectLayout_StartAnimAllNewPane

lbz       r0, 0xDC(r30)
cmpwi     r0, 0
beq       .loc_8048F238
lwz       r3, 0xD8(r30)
lwz       r12, 0(r3)
lwz       r12, 0x2C(r12)
mtctr     r12
bctrl
.loc_8048F238:

mr r3, r30
bl .tryDpdSelection__20ScenarioSelectLayoutFv

mr        r3, r30
bl updateSelectedScenario__20ScenarioSelectLayoutFv
mr        r3, r30
bl updateScenarioText__20ScenarioSelectLayoutFv
addi r3, r31, SE_DM_LV_SENARIO_SEL_FLY - ScenarioSelectLayout
li        r4, -1
li        r5, -1
bl startSystemLevelSE__2MRFPCcll
mr        r3, r30
bl tryCancel__20ScenarioSelectLayoutFv
cmpwi     r3, 0
bne       .loc_8048F2D0
mr        r3, r30
bl trySelect__20ScenarioSelectLayoutFv
cmpwi     r3, 0
beq       .loc_8048F2D0
li        r0, 1
stb       r0, 0x34(r30)

addi r3, r31, SE_SY_DECIDE_1 - ScenarioSelectLayout
li        r4, -1
li        r5, -1
bl startSystemSE__2MRFPCcll

lfs       f1, ScenarioSelectOne - STATIC_R2(r2)
addi r3, r31, CS_CLICK_CLOSE - ScenarioSelectLayout
li        r4, 0
li        r5, 0
li        r6, 0
bl startCSSound__2MRFPCcPCcllf

lbz       r0, 0xDC(r30)
cmpwi     r0, 0
beq       .loc_8048F2C4
lwz       r3, 0xD8(r30)
bl       disappear__10BackButtonFv

.loc_8048F2C4:
mr        r3, r30
addi      r4, r13, sInstance__Q223NrvScenarioSelectLayout29ScenarioSelectLayoutNrvDecide - STATIC_R13
bl       setNerve__11LayoutActorCFPC5Nerve

.loc_8048F2D0:
lwz       r0, 0x14(r1)
lwz       r31, 0xC(r1)
lwz       r30, 8(r1)
mtlr      r0
addi      r1, r1, 0x10
blr
.GLE ENDADDRESS

.GLE ADDRESS exeDecide__20ScenarioSelectLayoutFv
#ScenarioSelectLayout::exeDecide((void))
stwu      r1, -0x20(r1)
mflr      r0
stw       r0, 0x24(r1)
addi      r11, r1, 0x20
bl        _savegpr_28
mr        r28, r3
bl        isFirstStep__2MRFPC11LayoutActor
cmpwi     r3, 0
beq       .loc_8048F370
li        r29, 0
li        r31, 0

.loc_8048F31C:
lwz       r3, 0x68(r28)
lwzx      r30, r3, r31
lbz       r0, 0x38(r30)
cmpwi     r0, 0
bne       .loc_8048F354
mr        r3, r28
bl        getSelectedStar__20ScenarioSelectLayoutCFv
cmplw     r30, r3
bne       .loc_8048F34C
mr        r3, r30
bl        select__18ScenarioSelectStarFv
b         .loc_8048F354

.loc_8048F34C:
mr        r3, r30
bl        notSelect__18ScenarioSelectStarFv

.loc_8048F354:
addi      r29, r29, 1
addi      r31, r31, 4
cmpwi     r29, MaxStars
blt       .loc_8048F31C
mr        r3, r28
lis r4, NewEnd@ha
addi r4, r4, NewEnd@l
bl        ScenarioSelectLayout_StartAnimAllNewPane

.loc_8048F370:
mr        r3, r28
bl        updateScenarioText__20ScenarioSelectLayoutFv
lis r3, SE_DM_LV_SENARIO_SEL_FLY@ha
addi r3, r3, SE_DM_LV_SENARIO_SEL_FLY@l
li        r4, -1
li        r5, -1
bl        startSystemLevelSE__2MRFPCcll
mr        r3, r28
addi      r4, r13, sInstance__Q223NrvScenarioSelectLayout44ScenarioSelectLayoutNrvAfterScenarioSelected - STATIC_R13
li        r5, 0x28
bl        setNerveAtStep__2MRFP11LayoutActorPC5Nervel

bl .GLE_SetEndScenarioSelectBgm

addi      r11, r1, 0x20
bl        _restgpr_28
lwz       r0, 0x24(r1)
mtlr      r0
addi      r1, r1, 0x20
blr

.GLE ASSERT exeAfterScenarioSelected__20ScenarioSelectLayoutFv
.GLE ENDADDRESS

.GLE ADDRESS exeAfterScenarioSelected__20ScenarioSelectLayoutFv
#ScenarioSelectLayout::exeDisappear((void))
stwu      r1, -0x30(r1)
mflr      r0
stw       r0, 0x34(r1)
stfd      f31, 0x20(r1)
psq_st    f31, 0x28(r1), 0, 0
stfd      f30, 0x10(r1)
psq_st    f30, 0x18(r1), 0, 0
stw       r31, 0xC(r1)
addi      r5, r13, EndString - STATIC_R13
li        r6, 0x3C
li        r7, 0
lis r31, ScenarioSelectLayout@ha
addi r31, r31, ScenarioSelectLayout@l
stw       r30, 8(r1)
mr        r30, r3
addi r4, r31, ScenarioFrame - ScenarioSelectLayout
bl startPaneAnimAtStep__2MRFP11LayoutActorPCcPCclUl
mr        r3, r30
bl updateScenarioText__20ScenarioSelectLayoutFv
addi r3, r31, SE_DM_LV_SENARIO_SEL_FLY - ScenarioSelectLayout
li        r4, -1
li        r5, -1
bl startSystemLevelSE__2MRFPCcll
lfs       f1, EffectRate - STATIC_R2(r2) #2.0f
mr        r3, r30
lfs       f2, Unknown_15 - STATIC_R2(r2) #15.0f
li        r4, 0x3C
li        r5, 0x96
bl sub_80030580
fmr       f31, f1
lfs       f1, Unknown_9 - STATIC_R2(r2) #9.0f
lfs       f2, Unknown_15 - STATIC_R2(r2)
mr        r3, r30
li        r4, 0x3C
li        r5, 0x96
bl sub_80030580
fmr       f30, f1
mr        r3, r30
fmr       f1, f31
addi r4, r31, ScenarioSelectEffect - ScenarioSelectLayout
bl setEffectRate__2MRFP11LayoutActorPCcf

fmr       f1, f30
mr        r3, r30
addi r4, r31, ScenarioSelectEffect - ScenarioSelectLayout
bl setEffectDirectionalSpeed__2MRFP11LayoutActorPCcf

mr        r3, r30
li        r4, 0xB4
bl isStep__2MRFPC11LayoutActorl
cmpwi     r3, 0
beq       .loc_8048F498
#Normally there's code to stop the music here, but because loading times
#can get a little long, we will stop the bgm after the load finishes
li        r3, 0x1F
bl closeSystemWipeWhiteFade__2MRFl
b .ScenarioSelect_LoadingIcon_Addition

.loc_8048F498:
lwz       r0, 0x34(r1)
psq_l     f31, 0x28(r1), 0, 0
lfd       f31, 0x20(r1)
psq_l     f30, 0x18(r1), 0, 0
lfd       f30, 0x10(r1)
lwz       r31, 0xC(r1)
lwz       r30, 8(r1)
mtlr      r0
addi      r1, r1, 0x30
blr
.GLE ASSERT exeCancel__20ScenarioSelectLayoutFv
.GLE ENDADDRESS


.GLE ADDRESS exeCancel__20ScenarioSelectLayoutFv +0x38
lwz       r3, 0xD8(r31)
.GLE ENDADDRESS

.GLE ADDRESS exeAppearCometWarning__20ScenarioSelectLayoutFv
#ScenarioSelectLayout::exeAppearCometWarning((void))
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0xC(r1)
lis r31, ScenarioSelectLayout@ha
addi r31, r31, ScenarioSelectLayout@l
stw       r30, 8(r1)
mr        r30, r3
li        r4, 0xF
bl        isStep__2MRFPC11LayoutActorl
cmpwi     r3, 0
beq       .loc_8048F5DC
mr        r3, r30
addi      r4, r31, CometAppear - ScenarioSelectLayout
bl        showPaneRecursive__2MRFP11LayoutActorPCc
addi      r4, r31, CometAppear - ScenarioSelectLayout
mr        r3, r30
mr        r5, r4
li        r6, 0
bl        startPaneAnim__2MRFP11LayoutActorPCcPCcUl
addi      r3, r31, 0x0360 #"SE_SY_COMET_WARNING_DISP"
li        r4, -1
li        r5, -1
bl        startSystemSE__2MRFPCcll

.loc_8048F5DC:
mr        r3, r30
li        r4, 0xF
bl        isGreaterStep__2MRFPC11LayoutActorl
cmpwi     r3, 0
beq       .loc_8048F604
mr        r3, r30
addi      r4, r31, CometAppear - ScenarioSelectLayout
addi      r5, r13, sInstance__Q223NrvScenarioSelectLayout39ScenarioSelectLayoutNrvWaitCometWarning - STATIC_R13
li        r6, 0
bl        setNerveAtPaneAnimStopped__2MRFP11LayoutActorPCcPC5NerveUl

.loc_8048F604:
lwz       r0, 0x14(r1)
lwz       r31, 0xC(r1)
lwz       r30, 8(r1)
mtlr      r0
addi      r1, r1, 0x10
blr
.GLE ASSERT exeWaitCometWarning__20ScenarioSelectLayoutFv
.GLE ENDADDRESS

.GLE ADDRESS exeWaitCometWarning__20ScenarioSelectLayoutFv
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
lis r31, ScenarioSelectLayout@ha
addi r31, r31, ScenarioSelectLayout@l
stw       r30, 0x08(r1)
mr        r30, r3
bl        getNerveStep__11LayoutActorCFv
li        r4, 0x50
divw      r0, r3, r4
mullw     r0, r0, r4
subf      r0, r0, r3
cmpwi     r0, 0x19
bne       .loc_8048F66C
addi      r3, r31, 0x037C #SE_SY_COMET_WARNING
li        r4, -1
li        r5, -1
bl        startSystemSE__2MRFPCcll

.loc_8048F66C:
mr        r3, r30
addi      r4, r31, CometAppear - ScenarioSelectLayout
addi      r5, r31, CometWait - ScenarioSelectLayout
li        r6, 0
bl        startPaneAnimAtFirstStep__2MRFP11LayoutActorPCcPCcUl
mr        r3, r30
addi      r4, r13, sInstance__Q223NrvScenarioSelectLayout44ScenarioSelectLayoutNrvDisappearCometWarning - STATIC_R13
li        r5, 0x78
bl        setNerveAtStep__2MRFP11LayoutActorPC5Nervel
lwz       r0, 0x14(r1)
lwz       r31, 0x0C(r1)
lwz       r30, 0x08(r1)
mtlr      r0
addi      r1, r1, 0x10
blr
.GLE ASSERT __sinit_\ScenarioSelectLayout_cpp
.GLE ENDADDRESS

.GLE ADDRESS execute__Q223NrvScenarioSelectLayout44ScenarioSelectLayoutNrvDisappearCometWarningCFP5Spine
#NrvScenarioSelectLayout::ScenarioSelectLayoutNrvDisappearCometWarning::execute(const(Spine *))
#Nintendo put this one as the nerve directly instead of
#giving it a function. I guess it's pretty small...
stwu      r1, -0x10(r1)
mflr      r0
li        r6, 0
stw       r0, 0x14(r1)
lis r5, CometEnd@ha
addi r5, r5, CometEnd@l
stw       r31, 0x0C(r1)
lis       r31, CometAppear@ha
stw       r30, 0x08(r1)
lwz       r30, 0(r4)
addi      r4, r31, CometAppear@l
mr        r3, r30
bl        startPaneAnimAtFirstStep__2MRFP11LayoutActorPCcPCcUl
mr        r3, r30
addi      r4, r31, CometAppear@l
addi      r5, r13,  sInstance__Q223NrvScenarioSelectLayout29ScenarioSelectLayoutNrvAppear - STATIC_R13
li        r6, 0
bl        setNerveAtPaneAnimStopped__2MRFP11LayoutActorPCcPC5NerveUl
lwz       r0, 0x14(r1)
lwz       r31, 0x0C(r1)
lwz       r30, 0x08(r1)
mtlr      r0
addi      r1, r1, 0x10
blr
.GLE ASSERT execute__Q223NrvScenarioSelectLayout39ScenarioSelectLayoutNrvWaitCometWarningCFP5Spine
.GLE ENDADDRESS

.GLE ADDRESS updateScenarioText__20ScenarioSelectLayoutFv
stwu      r1, -0x10(r1)
mflr      r0
addi      r4, r13, sInstance__Q223NrvScenarioSelectLayout44ScenarioSelectLayoutNrvAfterScenarioSelected - STATIC_R13
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
li        r31, 0
stw       r30, 0x08(r1)
mr        r30, r3
bl        isNerve__11LayoutActorCFPC5Nerve
cmpwi     r3, 0
beq       .loc_8048DEF4
mr        r3, r30
li        r4, 0x3C
bl        isGreaterEqualStep__2MRFPC11LayoutActorl
cmpwi     r3, 0
beq       .loc_8048DEF4
li        r31, 1

.loc_8048DEF4:
mr        r3, r30
lis r4, Scenario@ha
addi r4, r4, Scenario@l
bl        isHiddenPane__2MRFPC11LayoutActorPCc
cmpwi     r3, 0
bne       .loc_8048DF28
lwz       r0, 0x2C(r30)
cmpwi     r0, 0
ble       .loc_8048DF48
lwz       r3, 0xE8(r30)
lwz       r0, 0x2C(r30)
cmpw      r3, r0
beq       .loc_8048DF48

.loc_8048DF28:
cmpwi     r31, 0
bne       .loc_8048DFB0
lwz       r0, 0x2C(r30)
cmpwi     r0, 0
ble       .loc_8048DFB0
mr        r3, r30
bl        fadeInText__20ScenarioSelectLayoutFv
b         .loc_8048DFB0

.loc_8048DF48:
lwz       r0, 0xE4(r30)
cmpwi     r0, 0
bne       .loc_8048DF88
mr        r3, r30
lis r4, Scenario@ha
addi r4, r4, Scenario@l
li        r5, 0
bl        isPaneAnimStopped__2MRFPC11LayoutActorPCcUl
cmpwi     r3, 0
beq       .loc_8048DFB0
lwz       r0, 0x2C(r30)
cmpwi     r0, 0
bgt       .loc_8048DFB0
mr        r3, r30
bl        fadeOutText__20ScenarioSelectLayoutFv
b         .loc_8048DFB0

.loc_8048DF88:
mr        r3, r30
lis r31, Scenario@ha
addi r4, r31, Scenario@l
li        r5, 0
bl        isPaneAnimStopped__2MRFPC11LayoutActorPCcUl
cmpwi     r3, 0
beq       .loc_8048DFB0
mr        r3, r30
addi r4, r31, Scenario@l
bl        hidePaneRecursive__2MRFP11LayoutActorPCc

.loc_8048DFB0:
lwz       r0, 0x14(r1)
lwz       r31, 0x0C(r1)
lwz       r30, 0x08(r1)
mtlr      r0
addi      r1, r1, 0x10
blr
.GLE ASSERT fadeInText__20ScenarioSelectLayoutFv
.GLE ENDADDRESS
#========================================
.GLE ADDRESS updateSelectedScenario__20ScenarioSelectLayoutFv
stwu      r1, -0x40(r1)
mflr      r0
stw       r0, 0x44(r1)
addi      r11, r1, 0x40
bl        _savegpr_27
mr        r27, r3
addi      r4, r13, sInstance__Q223NrvScenarioSelectLayout41ScenarioSelectLayoutNrvWaitScenarioSelect - STATIC_R13
bl        isNerve__11LayoutActorCFPC5Nerve
cmpwi     r3, 0
beq       .loc_8048DE70

li        r28, 0
li        r31, 0

.loc_8048DE18:
lwz       r3, 0x68(r27)
lwzx      r29, r3, r31
lbz       r0, 0x38(r29)
cmpwi     r0, 0
bne       .loc_8048DE60

addi r3, r1, 0x08
addi r4, r28, 0x01
bl makeStarPaneName
mr        r3, r27
addi r4, r1, 0x08
li        r5, 0
li        r6, 1
addi      r7, r13, Weak_JP_Str - STATIC_R13 #弱
bl        isStarPointerPointingTarget__2MRFPC11LayoutActorPCclbPCc
cmpwi     r3, 0
beq       .loc_8048DE60
lwz       r3, 0x50(r29)
li        r0, 0
stw       r3, 0x2C(r27) #Set Selected Scenario
stw       r0, 0x30(r27)
b         .loc_8048DE98

.loc_8048DE60:
addi      r28, r28, 1
addi      r31, r31, 4
cmpwi     r28, MaxStars
blt       .loc_8048DE18

.loc_8048DE70:
lwz       r3, 0x30(r27)
cmpwi     r3, 0
bge       .loc_8048DE84
addi      r0, r3, 1
stw       r0, 0x30(r27)

.loc_8048DE84:
lwz       r0, 0x30(r27)
cmpwi     r0, 0
blt       .loc_8048DE98
li        r0, -1
stw       r0, 0x2C(r27) #No scenario selected

.loc_8048DE98:
b Return_0x40_r27
.GLE ASSERT updateScenarioText__20ScenarioSelectLayoutFv
.GLE ENDADDRESS
#=============================================
.GLE ADDRESS fadeInText__20ScenarioSelectLayoutFv
stwu      r1, -0x60(r1)
mflr      r0
stw       r0, 0x64(r1)
addi      r11, r1, 0x60
bl _savegpr_28
mr        r28, r3
lis r30, ScenarioSelectLayout@ha
addi r30, r30, ScenarioSelectLayout@l
bl getCurrentStageName__2MRFv
lwz       r4, 0x2C(r28)
li        r0, 0
stw       r0, 0xE4(r28)
mr        r29, r3
stw       r4, 0xE8(r28)
bl getScenarioNameOnCurrentLanguage__2MRFPCcl
#Error Handling removed 2021-10-16
#Will add it to a lower down function to catch more failures in the future...
mr        r5, r3
mr        r3, r28
addi      r4, r30, Scenario - ScenarioSelectLayout
bl setTextBoxMessageRecursive__2MRFP11LayoutActorPCcPCw
mr        r3, r28
addi      r4, r30, Scenario - ScenarioSelectLayout
bl showPaneRecursive__2MRFP11LayoutActorPCc
mr        r3, r28
addi      r4, r30, Scenario - ScenarioSelectLayout
addi      r5, r30, SelectIn - ScenarioSelectLayout
li        r6, 0
bl startPaneAnim__2MRFP11LayoutActorPCcPCcUl
mr        r3, r28
addi      r4, r30, BestTime - ScenarioSelectLayout
addi      r5, r30, SelectIn - ScenarioSelectLayout
li        r6, 0
bl startPaneAnim__2MRFP11LayoutActorPCcPCcUl
lwz       r4, 0x2C(r28)
mr        r3, r29

bl getBestScenarioTime__2MRFPCcl
addic     r0, r3, -1
subfe.    r0, r0, r3
beq       .loc_8048E094
lwz       r4, 0x2C(r28)
mr        r3, r29
bl getBestScenarioTime__2MRFPCcl
mr        r4, r3
addi      r3, r1, 0x28
bl makeClearTimeString__2MRFPwUl
mr        r3, r28
addi      r4, r30, ShaBCounter - ScenarioSelectLayout
addi      r5, r1, 0x28
bl setTextBoxMessageRecursive__2MRFP11LayoutActorPCcPCw
b         .loc_8048E0B4

.loc_8048E094:
lfs       f1, ScenarioSelectZero - STATIC_R2(r2)
mr        r3, r28
addi      r4, r30, BestTime - ScenarioSelectLayout
li        r5, 0
bl setPaneAnimFrameAndStop__2MRFP11LayoutActorPCcfUl
mr        r3, r28
addi      r4, r30, ShaBCounter - ScenarioSelectLayout
bl clearTextBoxMessageRecursive__2MRFP11LayoutActorPCc

.loc_8048E0B4:
mr        r3, r28
addi      r4, r30, RaceTime - ScenarioSelectLayout
addi      r5, r30, SelectIn - ScenarioSelectLayout
li        r6, 0
bl startPaneAnim__2MRFP11LayoutActorPCcPCcUl

#Chimp & Fluzzard support
lwz       r3, 0x2C(r28)
bl hasRecordedRaceTimeInScenario__2MRFi
mr r31, r3

lwz       r3, 0x2C(r28)
bl hasRecordedScoreInScenario__2MRFi
cmpwi r31, 0
bne .loc_8048E0EC

cmpwi r3, 0
beq .loc_8048E190

.loc_8048E0EC:
cmpwi r31, 0
beq .loc_8048E12C

mr        r3, r29
lwz       r4, 0x2C(r28)
bl        .getRaceId
mr        r4, r3
addi      r3, r1, 0x08
bl        makeRaceBestTimeString__2MRFPwi
mr        r3, r28
addi      r4, r30, ShaRCounter - ScenarioSelectLayout
addi      r5, r1, 0x08
bl        setTextBoxMessageRecursive__2MRFP11LayoutActorPCcPCw
mr        r3, r28
addi      r4, r30, RTime - ScenarioSelectLayout
addi      r5, r30, ScenarioSelect_RaceTime - ScenarioSelectLayout
bl        setTextBoxGameMessageRecursive__2MRFP11LayoutActorPCcPCc
b         .loc_8048E154

.loc_8048E12C:
mr r3, r29
lwz       r4, 0x2C(r28)
bl getBestScoreAttackCurrentStage__16GameDataFunctionFv
mr r5, r3
mr r3, r28
addi r4, r30, ShaRCounter - ScenarioSelectLayout
bl setTextBoxNumberRecursive__2MRFP11LayoutActorPCcl

mr r3, r28
addi r4, r30, RTime - ScenarioSelectLayout
addi r5, r30, ScenarioSelect_HighScore - ScenarioSelectLayout
bl setTextBoxGameMessageRecursive__2MRFP11LayoutActorPCcPCc

.loc_8048E154:
lwz       r4, 0x2C(r28)
mr        r3, r29
bl getBestScenarioTime__2MRFPCcl
addic     r0, r3, -1
subfe.    r0, r0, r3
beq       .loc_8048E17C
lfs       f0, ScenarioSelectZero - STATIC_R2(r2)
stfs      f0, 0xC8(r28)
stfs      f0, 0xCC(r28)
b         .loc_8048E1B0

.loc_8048E17C:
lfs       f1, ScenarioSelectZero - STATIC_R2(r2)
lfs       f0, RaceTimeShift - STATIC_R2(r2) #27.0f
stfs      f1, 0xC8(r28)
stfs      f0, 0xCC(r28)
b .loc_8048E1B0

.loc_8048E190:
lfs       f1, ScenarioSelectZero - STATIC_R2(r2)
mr        r3, r28
addi      r4, r30, RaceTime - ScenarioSelectLayout
li        r5, 0
bl setPaneAnimFrameAndStop__2MRFP11LayoutActorPCcfUl

mr        r3, r28
addi      r4, r30, ShaRCounter - ScenarioSelectLayout
bl        clearTextBoxMessageRecursive__2MRFP11LayoutActorPCc

.loc_8048E1B0:
addi      r11, r1, 0x60
bl _restgpr_28
lwz       r0, 0x64(r1)
mtlr      r0
addi      r1, r1, 0x60
blr
.GLE ENDADDRESS

.GLE ADDRESS fadeOutText__20ScenarioSelectLayoutFv
stwu      r1, -0x20(r1)
mflr      r0
stw       r0, 0x24(r1)
addi      r11, r1, 0x20
bl _savegpr_29
mr        r29, r3
lis r31, ScenarioSelectLayout@ha
addi r31, r31, ScenarioSelectLayout@l
bl getCurrentStageName__2MRFv
li        r0, 1
stw       r0, 0xE4(r29)
mr        r30, r3
mr        r3, r29
addi r4, r31, Scenario - ScenarioSelectLayout
addi r5, r31, SelectOut - ScenarioSelectLayout
li        r6, 0
bl startPaneAnim__2MRFP11LayoutActorPCcPCcUl

lwz       r4, 0xE8(r29)
mr        r3, r30
bl getBestScenarioTime__2MRFPCcl
addic     r0, r3, -1
subfe.    r0, r0, r3
beq       .loc_8048E240
mr        r3, r29
addi r4, r31, BestTime - ScenarioSelectLayout
addi r5, r31, SelectOut - ScenarioSelectLayout
li        r6, 0
bl startPaneAnim__2MRFP11LayoutActorPCcPCcUl

.loc_8048E240:
lwz       r3, 0xE8(r29)
bl hasRecordedRaceTimeInScenario__2MRFi
cmpwi r3, 0
bne .loc_8048E260
lwz       r3, 0xE8(r29)
bl hasRecordedScoreInScenario__2MRFi
cmpwi r3, 0
beq .loc_8048E274

.loc_8048E260:
mr        r3, r29
addi      r4, r31, RaceTime - ScenarioSelectLayout
addi      r5, r31, SelectOut - ScenarioSelectLayout
li        r6, 0
bl startPaneAnim__2MRFP11LayoutActorPCcPCcUl

.loc_8048E274:
addi      r11, r1, 0x20
bl _restgpr_29
lwz       r0, 0x24(r1)
mtlr      r0
addi      r1, r1, 0x20
blr
.GLE ASSERT trySelect__20ScenarioSelectLayoutFv
.GLE ENDADDRESS

.GLE ADDRESS trySelect__20ScenarioSelectLayoutFv +0x44
li r0, MaxStars
.GLE ENDADDRESS

.GLE ADDRESS getSelectedStar__20ScenarioSelectLayoutCFv
li r0, MaxStars
.GLE ENDADDRESS

.GLE ADDRESS exeStartScenarioSelect__19ScenarioSelectSceneFv +0x24
bl .MR_OpenCurrentWipe
.GLE ENDADDRESS

.GLE ADDRESS exeCancel__20ScenarioSelectLayoutFv +0x48
li r3, BackFadeTime
.GLE ENDADDRESS




.GLE ADDRESS .PAUSE_MENU_CONNECTOR
#Refer to LoadIcon.s
.ScenarioSelect_LoadingIcon_Addition:
li r3, 0
stw r3, 0xE8(r30)

#Start the Loading icon, if applicable
b .loc_8048F498

#==================================================

#New addition to lock the ScenarioSelect to a max amount of stars

#r3 = GalaxyStatusAccessor
.GetPowerStarNumOrMax:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
#Swapping this out for the new GLE function so that scenarios that do not have a star assigned can still be attempted to show up
#There's some user logistics that will need to occur here most likely, but ultimately you get more stars for your buck:tm:
#Of course, we still need to clamp to the max of MaxStars
#bl getPowerStarNum__20GalaxyStatusAccessorCFv
bl .GLE_GetTotalScenarioNoFromGalaxyStatusAccessor

cmpwi r3, MaxStars
ble .GetPowerStarNumOrMax_Return

li r3, MaxStars

.GetPowerStarNumOrMax_Return:
lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr

#==================================================

#Finally re-adding selecting stars with the Nunchuk/DPad
#I think I overwrote the original so I'm gonna make a new one
.GLE PRINTADDRESS
.tryDpdSelection__20ScenarioSelectLayoutFv:
stwu      r1, -0x90(r1)
mflr      r0
stw       r0, 0x94(r1)
addi      r11, r1, 0x90
bl        _savegpr_21

mr        r31, r3
#this is for later :D
bl getDefaultButtonOffsetVec2__15StarPointerUtilFv
mr r29, r3

#First we can check to see if there are any Power Stars being shown on the scenario select. If not we can skip this function completely
#I hope this works for our purposes...lol
lwz       r4, 0x68(r31)
lwz       r4, 0(r4)
lbz       r0, 0x38(r4)
cmpwi r0, 0
bne .tryDpdSelection_Return


#In vanilla, the star pointer positions are layed out like this:

#Star1       Star2       Star3
#Star4       Star5       Star6
#BackButton0 BackButton1 BackButton2

#For our GLE intents and purposes,
#We need a new system that's more versitile.
#Nintendo created a full on quadruple linked list system for using the DPad/Stick with layouts, it's actually quite insane.
#we'll need to build our own "node map" which is NOT going to be easy...


#First we must check to see if the system is already initilized
li        r4, 1
bl sub_8005E720
cmpwi     r3, 0
beq .tryDpdSelection_UpdateBackButtonPos

#Lets get the upper and lower rows... again.
mr r3, r31
addi r4, r1, 0x10
addi r5, r1, 0x14
bl ScenarioSelectLayout_CalcDisplayScenarioNum

addi r3, r1, 0x10
bl .ScenarioSelect_CalcActiveRows
mr r27, r3

addi r3, r1, 0x10
bl .ScenarioSelect_CalcLastActiveRow
mr r26, r3

#Nintendo made the back button code incredibly stupidly. We'll be optimizing that here...
lbz       r0, 0xDC(r31)
cmpwi     r0, 0
beq .tryDpdSelection_SkipCreateBackButtons

#Default position is at (0,0)!
lfs       f0, ScenarioSelectZero - STATIC_R2(r2)
stfs      f0, 0x08(r1)
stfs      f0, 0x0C(r1)


#Reminder: r29 = DefaultButtonOffsetVec2*
li        r28, 0
b .tryDpdSelection_BackButtonCreateLoop_Start


.tryDpdSelection_BackButtonCreateLoop_Loop:
lwz r4, 0xEC(r31) #Load the name array table
lwz r4, 0x04(r4) #Get the BackButton Name array
slwi r5, r28, 2 #Index the array
lwzx r3, r4, r5

mr        r4, r29
addi r5, r1, 0x08

#Note: This SEEMS to work, but I don't remember fixing the use of <> in function names...
bl addStarPointerMovePosition__15StarPointerUtilFPCcPQ29JGeometry8TVec3<f>RCQ29JGeometry8TVec3<f>

addi r28, r28, 1

.tryDpdSelection_BackButtonCreateLoop_Start:

slwi r3, r26, 2
addi r4, r1, 0x10

lwzx r4, r4, r3
cmpwi r4, 0
cmpw r28, r4
blt .tryDpdSelection_BackButtonCreateLoop_Loop



.tryDpdSelection_SkipCreateBackButtons:

#Create the move positions for the stars themselves now
li        r28, 0
li        r30, 0

.tryDpdSelection_StarPaneCreateLoop_Loop:
lwz       r3, 0x68(r31)
lwzx      r3, r3, r30
lbz       r0, 0x38(r3)
cmpwi     r0, 0
bne .tryDpdSelection_StarPaneCreateLoop_Continue

mr        r3, r31
lwz r4, 0xEC(r31) #Load the name array table
lwz r4, 0x00(r4) #Get the BackButton Name array
lwzx r4, r4, r30
addi r5, r1, 0x08
bl addStarPointerMovePositionFromPane__15StarPointerUtilFP11LayoutActorPCcPQ29JGeometry8TVec2_f_

.tryDpdSelection_StarPaneCreateLoop_Continue:
addi      r28, r28, 1
addi      r30, r30, 4

.tryDpdSelection_StarPaneCreateLoop_Start:
cmpwi r28, MaxStars
blt .tryDpdSelection_StarPaneCreateLoop_Loop


#Here's the hard part!
#We need to connect everything in a web now.


li r30, 0   #Current Row
addi r29, r1, 0x10  #Row Count [] index pointer
b .tryDpdSelection_ConnectRowH_Start




.tryDpdSelection_ConnectRowH_Loop:
lwz r3, 0x00(r29)
cmpwi r3, 1  #Rows with 1 star do not need to be linked horizontally at all.
ble .tryDpdSelection_ConnectRowV

li r28, 0   #Current Star in Row
b .tryDpdSelection_ConnectStarH_Start

.tryDpdSelection_ConnectStarH_Loop:
lwz r3, 0x00(r29)
subi r4, r3, 1 #Current row count - 1
cmpw r28, r4

#these happen for both.
lwz r6, 0xEC(r31) #Load the name array table
lwz r6, 0x00(r6) #Get the StarPane Name array
mulli r7, r30, MaxPerRow  #Row Offset
#link the positions!
beq .tryDpdSelection_ConnectStarH_EdgeOfRow

#Current
add r5, r7, r28
slwi r5, r5, 2
lwzx r3, r6, r5
#Target
add r5, r7, r28
addi r5, r5, 1
slwi r5, r5, 2
lwzx r4, r6, r5
bl setConnectionMovePositionRight2Way__15StarPointerUtilFPCcPCc

b .tryDpdSelection_ConnectStarH_Continue
.tryDpdSelection_ConnectStarH_EdgeOfRow:
#Current
add r5, r7, r28
slwi r5, r5, 2
lwzx r3, r6, r5
#Target
slwi r5, r7, 2
lwzx r4, r6, r5
bl setConnectionMovePositionRight2Way__15StarPointerUtilFPCcPCc

.tryDpdSelection_ConnectStarH_Continue:
addi r28, r28, 1

.tryDpdSelection_ConnectStarH_Start:
lwz r3, 0x00(r29) #Get the row count
cmpw r28, r3  #If we've handleed each item in the row, continue
blt .tryDpdSelection_ConnectStarH_Loop

.GLE PRINTADDRESS
.tryDpdSelection_ConnectRowV:
#If this is the lowest active star row, we need to connect to the back buttons instead, so we'll need a separate handler for that.
cmpw r30, r26
beq .tryDpdSelection_ConnectToBackButtonV




#Handle a star row below this one
#The Nightmare in GLE's Dream Land

lwz r3, 0x00(r29) #Get the row count
lwz r4, 0x04(r29) #Get the next row count
cmpw r3, r4
beq .tryDpdSelection_ConnectRowEqualV
bgt .tryDpdSelection_ConnectRowUnequalV_Invert

#-----

.tryDpdSelection_ConnectRowUnequalV:
bl getStarPointerDirector__19StarPointerFunctionFv
lwz       r25, 0x18(r3)
#Top row has the least stars

lwz r28, 0x00(r29) #Get the row count
subi r28, r28, 1
b .tryDpdSelection_ConnectRowUnequalV_LoopStart

.tryDpdSelection_ConnectRowUnequalV_Loop:

#Store the current upper pane
lwz r6, 0xEC(r31) #Load the name array table
lwz r6, 0x00(r6) #Get the StarPane Name array
mulli r7, r30, MaxPerRow  #Row Offset
add r5, r7, r28
slwi r5, r5, 2
lwzx r4, r6, r5
mr r3, r25
bl getPositionByName__29StarPointerMovePositionHolderFPCc
mr r24, r3 #Store the position of the current upper pane for comparison

#Scan the positions from right to left -- as soon as the X position is less than or equal to the current star, connect them.

lwz r22, 0x04(r29) #Get the next row count
subi r22, r22, 1
li r23, 0
b .tryDpdSelection_ConnectRowUnequalV_LowerLoopStart

.tryDpdSelection_ConnectRowUnequalV_LowerLoop:
#Lets first get the Target lower position
lwz r6, 0xEC(r31) #Load the name array table
lwz r6, 0x00(r6) #Get the StarPane Name array
addi r7, r30, 1
mulli r7, r7, MaxPerRow  #Row Offset
add r5, r7, r22
slwi r5, r5, 2
lwzx r4, r6, r5
mr r3, r25
bl getPositionByName__29StarPointerMovePositionHolderFPCc
lfs f0, 0x00(r3)
lfs f1, 0x00(r24)

#Compare floats. if Current.x > Target.x
fcmpo    cr0, f0, f1
bgt .tryDpdSelection_ConnectRowUnequalV_LowerLoopContinue_IsToRight

#If we already set the down connector, we don't need to set it again!
cmpwi r23, 1
beq .tryDpdSelection_ConnectRowUnequalV_LowerLoopContinue_IsToLeft
stw r3, 0x20(r24) #Set the down connector on the upper row
stw r24, 0x1C(r3) #Set the up connector on the lower row
li r23, 1
b .tryDpdSelection_ConnectRowUnequalV_LowerLoopContinue

.tryDpdSelection_ConnectRowUnequalV_LowerLoopContinue_IsToLeft:
#For stars that are to the left of the last star on the shortest row, force assign them
cmpwi r28, 0
bne .tryDpdSelection_ConnectRowUnequalV_LowerLoopContinue
stw r24, 0x1C(r3) #Set the down connector on the upper row
b .tryDpdSelection_ConnectRowUnequalV_LowerLoopContinue

.tryDpdSelection_ConnectRowUnequalV_LowerLoopContinue_IsToRight:
lwz r4, 0x1C(r3)
cmpwi r4, 0
bne .tryDpdSelection_ConnectRowUnequalV_LowerLoop_SKIP
stw r24, 0x1C(r3) #Set the up connector on the lower row if it's not already set.
.tryDpdSelection_ConnectRowUnequalV_LowerLoop_SKIP:

.tryDpdSelection_ConnectRowUnequalV_LowerLoopContinue:
subi r22, r22, 1

.tryDpdSelection_ConnectRowUnequalV_LowerLoopStart:
cmpwi r22, 0
bge .tryDpdSelection_ConnectRowUnequalV_LowerLoop


.tryDpdSelection_ConnectRowUnequalV_LoopContinue:
subi r28, r28, 1

.tryDpdSelection_ConnectRowUnequalV_LoopStart:
cmpwi r28, 0
bge .tryDpdSelection_ConnectRowUnequalV_Loop

b .tryDpdSelection_ConnectRowH_Continue

#-----

.tryDpdSelection_ConnectRowUnequalV_Invert:
bl getStarPointerDirector__19StarPointerFunctionFv
lwz       r25, 0x18(r3)
#Bottom row has the least stars

lwz r28, 0x04(r29) #Get the next row count
subi r28, r28, 1
b .tryDpdSelection_ConnectRowUnequalV_Invert_LoopStart

.tryDpdSelection_ConnectRowUnequalV_Invert_Loop:

#Store the current upper pane
lwz r6, 0xEC(r31) #Load the name array table
lwz r6, 0x00(r6) #Get the StarPane Name array
addi r7, r30, 1
mulli r7, r7, MaxPerRow  #Row Offset
add r5, r7, r28
slwi r5, r5, 2
lwzx r4, r6, r5
mr r3, r25
bl getPositionByName__29StarPointerMovePositionHolderFPCc
mr r24, r3 #Store the position of the current upper pane for comparison

#Scan the positions from right to left -- as soon as the X position is less than or equal to the current star, connect them.

lwz r22, 0x00(r29) #Get the row count
subi r22, r22, 1
li r23, 0
b .tryDpdSelection_ConnectRowUnequalV_Invert_LowerLoopStart

.tryDpdSelection_ConnectRowUnequalV_Invert_LowerLoop:
#Lets first get the Target lower position
lwz r6, 0xEC(r31) #Load the name array table
lwz r6, 0x00(r6) #Get the StarPane Name array
mulli r7, r30, MaxPerRow  #Row Offset
add r5, r7, r22
slwi r5, r5, 2
lwzx r4, r6, r5
mr r3, r25
bl getPositionByName__29StarPointerMovePositionHolderFPCc
lfs f0, 0x00(r3)
lfs f1, 0x00(r24)

#Compare floats. if Current.x > Target.x
fcmpo    cr0, f0, f1
bgt .tryDpdSelection_ConnectRowUnequalV_Invert_LowerLoopContinue_IsToRight

#If we already set the down connector, we don't need to set it again!
cmpwi r23, 1
beq .tryDpdSelection_ConnectRowUnequalV_Invert_LowerLoopContinue_IsToLeft
stw r3, 0x1C(r24) #Set the up connector on the lower row
stw r24, 0x20(r3) #Set the down connector on the upper row
li r23, 1
b .tryDpdSelection_ConnectRowUnequalV_Invert_LowerLoopContinue

.tryDpdSelection_ConnectRowUnequalV_Invert_LowerLoopContinue_IsToLeft:
#For stars that are to the left of the last star on the shortest row, force assign them
cmpwi r28, 0
bne .tryDpdSelection_ConnectRowUnequalV_Invert_LowerLoopContinue
stw r24, 0x20(r3) #Set the down connector on the upper row
b .tryDpdSelection_ConnectRowUnequalV_Invert_LowerLoopContinue

.tryDpdSelection_ConnectRowUnequalV_Invert_LowerLoopContinue_IsToRight:
lwz r4, 0x20(r3)
cmpwi r4, 0
bne .tryDpdSelection_ConnectRowUnequalV_Invert_LowerLoop_SKIP
stw r24, 0x20(r3) #Set the down connector on the upper row if it's not already set.
.tryDpdSelection_ConnectRowUnequalV_Invert_LowerLoop_SKIP:

.tryDpdSelection_ConnectRowUnequalV_Invert_LowerLoopContinue:
subi r22, r22, 1

.tryDpdSelection_ConnectRowUnequalV_Invert_LowerLoopStart:
cmpwi r22, 0
bge .tryDpdSelection_ConnectRowUnequalV_Invert_LowerLoop


.tryDpdSelection_ConnectRowUnequalV_Invert_LoopContinue:
subi r28, r28, 1

.tryDpdSelection_ConnectRowUnequalV_Invert_LoopStart:
cmpwi r28, 0
bge .tryDpdSelection_ConnectRowUnequalV_Invert_Loop

b .tryDpdSelection_ConnectRowH_Continue

#-----

#If the two rows in question have an equal amount of stars, we can just iterate through them and match 1:1
.tryDpdSelection_ConnectRowEqualV:
li r28, 0   #Current Star in Row
b .tryDpdSelection_ConnectRowEqualV_LoopStart

.tryDpdSelection_ConnectRowEqualV_Loop:
lwz r6, 0xEC(r31) #Load the name array table
lwz r6, 0x00(r6) #Get the StarPane Name array
mulli r7, r30, MaxPerRow  #Row Offset

#Current
add r5, r7, r28
slwi r5, r5, 2
lwzx r3, r6, r5
#Target
addi r7, r30, 1
mulli r7, r7, MaxPerRow  #Row Offset
add r5, r7, r28
slwi r5, r5, 2
lwzx r4, r6, r5
bl setConnectionMovePositionDown2Way__15StarPointerUtilFPCcPCc

.tryDpdSelection_ConnectRowEqualV_LoopContinue:
addi r28, r28, 1
.tryDpdSelection_ConnectRowEqualV_LoopStart:
lwz r3, 0x00(r29) #Get the row count
cmpw r28, r3  #If we've handleed each item in the row, continue
blt .tryDpdSelection_ConnectRowEqualV_Loop

b .tryDpdSelection_ConnectRowH_Continue

#-----

.tryDpdSelection_ConnectToBackButtonV:
#First check to see if there's even a back button active or not. If not, we can skip this!
lbz       r0, 0xDC(r31)
cmpwi     r0, 0
beq .tryDpdSelection_ConnectRowH_Continue
#Hook up the back buttons to the lowest row
#r26 = Lowest Row ID (for now, only 0 and 1 -- 0 for Top row [or empty bottom row], 1 for Bottom Row)

li r28, 0   #Current Star in Row
b .tryDpdSelection_ConnectToBackButtonV_LoopStart

.tryDpdSelection_ConnectToBackButtonV_Loop:
lwz r6, 0xEC(r31) #Load the name array table
lwz r6, 0x00(r6) #Get the StarPane Name array
mulli r7, r30, MaxPerRow  #Row Offset
#Current
add r5, r7, r28
slwi r5, r5, 2
lwzx r3, r6, r5
#Target
lwz r6, 0xEC(r31) #Load the name array table
lwz r6, 0x04(r6) #Get the BackButton Name array
slwi r5, r28, 2
lwzx r4, r6, r5
bl setConnectionMovePositionDown2Way__15StarPointerUtilFPCcPCc

.tryDpdSelection_ConnectToBackButtonV_LoopContinue:
addi r28, r28, 1

.tryDpdSelection_ConnectToBackButtonV_LoopStart:
lwz r3, 0x00(r29)
cmpw r28, r3
blt .tryDpdSelection_ConnectToBackButtonV_Loop



.tryDpdSelection_ConnectRowH_Continue:
addi r30, r30, 0x01
addi r29, r29, 0x04
.tryDpdSelection_ConnectRowH_Start:
cmpwi r30, MaxTotalRows
blt .tryDpdSelection_ConnectRowH_Loop









#And then we need to set the default option (Star1 always).
lwz r4, 0xEC(r31) #Load the name array table
lwz r4, 0x00(r4) #Get the StarPane Name array
li r5, 0
lwzx r3, r4, r5
bl setDefaultAllMovePosition__15StarPointerUtilFPCc


.tryDpdSelection_UpdateBackButtonPos:
lbz       r0, 0xDC(r31)
cmpwi     r0, 0
beq .tryDpdSelection_EndInit

addi r3, r1, 0x08
lwz       r4, 0xD8(r31)
lis r5, BoxButton@ha
addi r5, r5, BoxButton@l
bl copyPaneTrans__2MRFPQ29JGeometry8TVec2<f>PC11LayoutActorPCc

#Reminder: r29 = DefaultButtonOffsetVec2*
li        r28, 0
b .tryDpdSelection_BackButtonUpdateLoop_Start


.tryDpdSelection_BackButtonUpdateLoop_Loop:
lwz r4, 0xEC(r31) #Load the name array table
lwz r4, 0x04(r4) #Get the BackButton Name array
slwi r5, r28, 2 #Index the array
lwzx r3, r4, r5

addi r4, r1, 0x08
bl setStarPointerMovePosition__15StarPointerUtilFPCcPQ29JGeometry8TVec2_f_

addi r28, r28, 1

.tryDpdSelection_BackButtonUpdateLoop_Start:

slwi r3, r26, 2
addi r4, r1, 0x10

lwzx r4, r4, r3
cmpwi r4, 0
cmpw r28, r4
blt .tryDpdSelection_BackButtonUpdateLoop_Loop


.tryDpdSelection_EndInit:
#No idea what these do
mr        r3, r31
bl        sub_8005E940
mr        r3, r31
bl        sub_8005E790


.tryDpdSelection_Return:
addi      r11, r1, 0x90
bl        _restgpr_21
lwz       r0, 0x94(r1)
mtlr      r0
addi      r1, r1, 0x90
blr


#returns the number of rows that have a star count greater than 0
#r3 = Row count array pointer (should be the address of the first element directly)
.ScenarioSelect_CalcActiveRows:
stwu      r1, -0x60(r1)
mflr      r0
stw       r0, 0x64(r1)
addi      r11, r1, 0x50
bl        _savegpr_28

mr r31, r3
li r30, 0 #index
li r29, 0 #Row Count
b .CalcActiveRows_LoopStart
.CalcActiveRows_Loop:

lwz r3, 0x00(r31)
cmpwi r3, 0
beq .CalcActiveRows_LoopContinue

addi r29, r29, 1

.CalcActiveRows_LoopContinue:
addi r30, r30, 1
addi r31, r31, 0x04

.CalcActiveRows_LoopStart:
cmpwi r30, MaxTotalRows
blt .CalcActiveRows_Loop

mr r3, r29

addi      r11, r1, 0x50
bl        _restgpr_28
lwz       r0, 0x64(r1)
mtlr      r0
addi      r1, r1, 0x60
blr


#returns the index of the last row with more than 0 stars in it
#r3 = Row count array pointer (should be the address of the first element directly)
.ScenarioSelect_CalcLastActiveRow:
stwu      r1, -0x60(r1)
mflr      r0
stw       r0, 0x64(r1)
addi      r11, r1, 0x50
bl        _savegpr_28

mr r31, r3
li r30, 0 #index
li r29, 0 #Row Count
b .CalcLastActiveRow_LoopStart
.CalcLastActiveRow_Loop:

lwz r3, 0x00(r31)
cmpwi r3, 0
beq .CalcLastActiveRow_LoopContinue

mr r29, r30

.CalcLastActiveRow_LoopContinue:
addi r30, r30, 1
addi r31, r31, 0x04

.CalcLastActiveRow_LoopStart:
cmpwi r30, MaxTotalRows
blt .CalcLastActiveRow_Loop

mr r3, r29

addi      r11, r1, 0x50
bl        _restgpr_28
lwz       r0, 0x64(r1)
mtlr      r0
addi      r1, r1, 0x60
blr

.ScenarioSelect_InitBackButton:
stwu      r1, -0x60(r1)
mflr      r0
stw       r0, 0x64(r1)
addi      r11, r1, 0x50
bl        _savegpr_28

mr r31, r3

li r30, 0
b .ScenarioSelect_InitBackButton_LoopStart

.ScenarioSelect_InitBackButton_Loop:
li r3, 0x10
bl __nw__FUl
#Do we *really* need to check to see if this failed?
lwz r4, 0xEC(r31) #Load the name array table
lwz r4, 0x04(r4) #Get the BackButton Name array
slwi r5, r30, 2 #Index the array
stwx r3, r4, r5
mr r6, r30

lis r5, BackButton_PointerPosFormat@ha
addi r5, r5, BackButton_PointerPosFormat@l
li        r4, 0x10
crclr     4*cr1+eq
bl        snprintf

#Normally I'd put a continue here, but there's no point where a continue would happen.
addi r30, r30, 1
.ScenarioSelect_InitBackButton_LoopStart:
cmpwi r30, MaxPerRow
blt .ScenarioSelect_InitBackButton_Loop

addi      r11, r1, 0x50
bl        _restgpr_28
lwz       r0, 0x64(r1)
mtlr      r0
addi      r1, r1, 0x60
blr

#==================================================

#So, this chunk is here for future purposes, if I have any...




#EndWorldmapCode
.SCENARIO_SELECT_CONNECTOR:
.GLE ENDADDRESS






#GLE Build Tool feature poggers
.GLE ADDRESS __vt__20ScenarioSelectLayout
ScenarioSelectLayout_VTable:
.int 0
.int 0
.int __dt__20ScenarioSelectLayoutFv
.int ScenarioSelectLayout_Init
.int initAfterPlacement__7NameObjFv
.int ScenarioSelectLayout_Movement
.int ScenarioSelectLayout_Draw
.int ScenarioSelectLayout_CalcAnim
.int calcViewAndEntry__7NameObjFv
.int startMovement__7NameObjFv
.int endMovement__7NameObjFv
.int ScenarioSelectLayout_Appear
.int ScenarioSelectLayout_Kill
.int control__20ScenarioSelectLayoutFv