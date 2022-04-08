#======== SceneChangeArea ========
#An area that will warp the player to another galaxy
#Obj Arg 0 = Index into the ChangeSceneListInfo. (Int)
#Obj Arg 1 = Enable Screen Capture?
#Obj Arg 2 = Wipe Type (-1 = Fade to White, 0 = Fade to Black, 1 = Circle, 2 = Mario, 3 = Bowser, 4 = Game Over)
#Obj Arg 3 = Wipe Time (in frames)

#Obj Arg 6 = Music fade time (default 0x2E)
#Obj Arg 7 = Leave music playing (-1 = Stop music, "All other values" = Leave music) !! WARNING !! CAUSES LONG LOAD TIMES IF ANY NON-SEQUENCE SONG IS PLAYING!!

#Obj Arg 4 was removed (GLE-V2)
#Ovj Arg 5 was removed (GLE-V2)



#First thing's first, the original game only allocated proper memory for 8 of these areas only!
#That simply won't be enough...
.GLE ADDRESS cCreateTable__16AreaObjContainer +0x304
.int 0x00000030 #Create 48 slots. Should be more than enough
.GLE ENDADDRESS

#=================================================
.GLE ADDRESS createNameObj<15SceneChangeArea>__14NameObjFactoryFPCc_P7NameObj +0x14
li r3, 0x50
.GLE ENDADDRESS

.GLE ADDRESS createNameObj<15SceneChangeArea>__14NameObjFactoryFPCc_P7NameObj +0x28
bl SceneChangeArea_Ctor
.GLE ENDADDRESS

.GLE ADDRESS __ct__15SceneChangeAreaFPCc -0x08
SceneChangeArea_Ctor:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
mr        r31, r3

bl __ct__7AreaObjFPCc
lis       r4, __vt__15SceneChangeArea@ha
addi      r4, r4, __vt__15SceneChangeArea@l
stw       r4, 0x00(r31)
li r4, 0
stw       r4, 0x48(r31) #Flag for making sure we transition properly
stw       r4, 0x4C(r31) #The zone this object is placed in. (added in GLE-V2)
mr        r3, r31

lwz       r31, 0x0C(r1)
lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr

#Don't overwrite Init by mistake!
.GLE ASSERT init__15SceneChangeAreaFRC12JMapInfoIter
.GLE ENDADDRESS

#=================================================
.GLE ADDRESS __ct__19WorldMapAccessPanelFPCc
#Replacing WorldMapAccessPanel
SceneChangeArea_Init:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
stw       r30, 0x08(r1)
mr        r31, r3
mr r30, r4
bl        init__7AreaObjFRC12JMapInfoIter
mr        r3, r31
bl        connectToSceneAreaObj__2MRFP7NameObj

mr r3, r30
bl getPlacedZoneId__2MRFRC12JMapInfoIter
stw r3, 0x4C(r31)

li        r3, 0x2E
stw r3, 0x38(r31)

lwz       r31, 0x0C(r1)
lwz       r30, 0x08(r1)
lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr


SceneChangeArea_Movement:
stwu      r1, -0x40(r1)
mflr      r0
stw       r0, 0x44(r1)
addi      r11, r1, 0x40
bl _savegpr_25
mr        r31, r3
lbz r3, 0x1C(r31)
cmpwi r3, 0
beq .SceneChangeArea_Movement_Return
#Is the Area Invalid?
lbz r3, 0x48(r31)
cmpwi r3, 1
bne .SceneChangeArea_Movement_NormalRoute
bl isSystemWipeActive__2MRFv
cmpwi r3, 0
bne .SceneChangeArea_Movement_Return
bl isWipeActive__2MRFv
cmpwi r3, 0
bne .SceneChangeArea_Movement_Return
# lwz r3, 0x24(r31)
# cmpwi r3, -1
# bne .SceneChangeArea_Movement_LoadLevel
# b .SceneChangeArea_Movement_Return
b .SceneChangeArea_Movement_LoadLevel

.SceneChangeArea_Movement_NormalRoute:
bl getPlayerPos__2MRFv
mr        r4, r3
mr        r3, r31
lwz       r12, 0(r31)
lwz       r12, 0x2C(r12)
mtctr     r12
bctrl     # AreaObj::isInVolume(const(JGeometry::TVec3_f_ const &))
cmpwi     r3, 0
#If mario is not in the area, do nothing and return
beq       .SceneChangeArea_Movement_Return

#Lets decide which wipe to use
lwz r3, 0x2C(r31) #Load the Wipe Time
lwz r4, 0x28(r31) #Load the Wipe Type

cmpwi r4, 0
beq .SceneChangeArea_Movement_WipeFade
cmpwi r4, 1
beq .SceneChangeArea_Movement_WipeCircle
cmpwi r4, 2
beq .SceneChangeArea_Movement_WipeMario
cmpwi r4, 3
beq .SceneChangeArea_Movement_WipeKoopa
cmpwi r4, 4
beq .SceneChangeArea_Movement_WipeGameOver

#Default option
bl closeSystemWipeWhiteFade__2MRFl
b .SceneChangeArea_Movement_WipeDetermined

.SceneChangeArea_Movement_WipeFade:
bl closeSystemWipeFade__2MRFl
b .SceneChangeArea_Movement_WipeDetermined

.SceneChangeArea_Movement_WipeCircle:
bl .MR_setWipeCircleCenterToPlayerHeadNoCapture
b .SceneChangeArea_Movement_WipeDetermined

.SceneChangeArea_Movement_WipeMario:
bl closeSystemWipeMario__2MRFl
b .SceneChangeArea_Movement_WipeDetermined

.SceneChangeArea_Movement_WipeKoopa:
.GLE PRINTADDRESS
bl startDownWipe__2MRFv
b .SceneChangeArea_Movement_WipeDetermined

.SceneChangeArea_Movement_WipeGameOver:
bl startGameOverWipe__2MRFv

.SceneChangeArea_Movement_WipeDetermined:
#Check to see if we're capturing the screen or not
lwz r3, 0x24(r31)
cmpwi r3, -1
bne .SceneChangeArea_Movement_Invalidate
lwz       r3, sInstance__29SingletonHolder_10GameSystem_ - STATIC_R13(r13)
lwz       r3, 0x30(r3)
bl startGameScreenCapture__16SystemWipeHolderFv
bl offPlayerControl__2MRFv
b .SceneChangeArea_Movement_Invalidate

#/////////////////////////////////////
.SceneChangeArea_Movement_LoadLevel:

#This is so much easier to do in GLE-V2 lol
#There used to be so much more code here
lwz r3, 0x4C(r31)
bl .StageDataHolder_GetSceneChangeList
lwz r4, 0x20(r31)
bl .MR_RequestMoveStageFromJMapInfo

#Convert the wipe to a System wipe.
lwz r4, 0x28(r31)
cmpwi r4, 2
beq .ForceCloseCircle
cmpwi r4, 4
bne .SkipForceCloseCircle

.ForceCloseCircle:
bl forceCloseSystemWipeCircle__2MRFv

.SkipForceCloseCircle:

lwz r4, 0x3C(r31)
cmpwi r4, -1
bne .SceneChangeArea_Movement_Invalidate
#Cut the music
lwz r3, 0x38(r31)
bl stopSubBGM__2MRFUl
lwz r3, 0x38(r31)
bl stopStageBGM__2MRFUl

#Set the used flag to true
.SceneChangeArea_Movement_Invalidate:
li        r0, 1
stb       r0, 0x48(r31) #So we don't continue to try warping...

.SceneChangeArea_Movement_Return:
addi      r11, r1, 0x40
bl _restgpr_25
lwz       r0, 0x44(r1)
mtlr      r0
addi      r1, r1, 0x40
blr




.MR_setWipeCircleCenterToPlayerHeadNoCapture:
stwu      r1, -0x50(r1)
mflr      r0
stw       r0, 0x54(r1)
addi      r3, r1, 0x20
lis       r4, Head_BoneName@ha
addi      r4, r4, Head_BoneName@l # "Head"
bl        calcPlayerJointMtx__2MRFPQ29JGeometry64TPosition3<Q29JGeometry38TMatrix34<Q29JGeometry13SMatrix34C<f>>>PCc
lfs       f1, WipeCircleCenter - STATIC_R2(r2) #0.0f
addi      r3, r1, 0x20
lfs       f0, WipeCircleNeg20 - STATIC_R2(r2) #-20.0f
addi      r4, r1, 0x08
stfs      f1, 0x08(r1)
addi      r5, r1, 0x14
stfs      f0, 0x0C(r1)
stfs      f1, 0x10(r1)
bl        mult__Q29JGeometry38TMatrix34<Q29JGeometry13SMatrix34C<f>>CFRCQ29JGeometry8TVec3<f>RQ29JGeometry8TVec3<f>
li        r3, -1
bl        closeSystemWipeCircle__2MRFl
addi      r3, r1, 0x14
bl        setWipeCircleCenterPos__2MRFRCQ29JGeometry8TVec3<f>
lwz       r0, 0x54(r1)
mtlr      r0
addi      r1, r1, 0x50
blr
.GLE ENDADDRESS

#=================================================
.GLE ADDRESS __vt__15SceneChangeArea
.int 0
.int 0
.int __dt__15SceneChangeAreaFv
.int SceneChangeArea_Init
.int initAfterPlacement__7NameObjFv
.int SceneChangeArea_Movement
#Technically don't need the full VTable...
.GLE ENDADDRESS