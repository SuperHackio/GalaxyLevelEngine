#======== QuickWarpArea ========
#An area that will warp the player to another location inside the same galaxy without reloading it.
#Obj Arg 0 = General Position ID to warp to. If ObjArg7 is NOT -1, then this defines the searching starting point
#Obj Arg 1 = Warp Delay (in frames. Default 60)
#Obj Arg 2 = Closing Wipe Type (-1 = Fade to White, 0 = Fade to Black, 1 = Circle, 2 = Mario, 3 = Bowser, 4 = Game Over) If set to 0, no fade will happen
#Obj Arg 3 = Closing Wipe Time (in frames)
#Obj Arg 4 = Opening Wipe Type (-1 = Fade to White, 0 = Fade to Black, 1 = Circle, 2 = Mario. The other two can't Open...) If Arg 2 is set to 0, ignored.
#Obj Arg 5 = Opening Wipe Time (in frames)
#Obj Arg 6 = bool. Display LoadIcon / Remove Powerup? Default to Neither
#Obj Arg 7 = Max Position ID to look for. -1 to Disable.





# Old stuff that's not actually programmed in
#Obj Arg 6 = Spawn type. Same values as a normal mario spawn. Ignored if relative. SCRAPPED
#Obj Arg 7 = Relative? TODO: Not sure if I wanna include this, but the idea is that we can just teleport mario to the general pos offset based from the center of the area
#     For example, if mario jumps into the area placed on the ground, he'll spawn above the general position
#Note: I ended up ditching this as mario's momentum isn't preserved




#QuickWarpArea shares it's area manager with SceneChangeArea
#Actually this is going to share a lot with SceneChangeArea in general...

#Object Entry replaces SkyIslandStep. Just add it as a SimpleMapObj to the ProductMapObjDataTable
.GLE ADDRESS cCreateTable__14NameObjFactory +0x1588
.int .QuickWarpArea_ObjName
.int .QuickWarpArea_NEW
.GLE ENDADDRESS


.GLE ADDRESS .END_OF_MEISTER_CODE
.QuickWarpArea_NEW:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
mr        r31, r3
li        r3, 0x50
bl        __nw__FUl
cmpwi     r3, 0
beq       .QuickWarpArea_NEW_Return
mr        r4, r31
bl        .QuickWarpArea_Ctor

.QuickWarpArea_NEW_Return:
lwz       r0, 0x14(r1)
lwz       r31, 0x0C(r1)
mtlr      r0
addi      r1, r1, 0x10
blr

.QuickWarpArea_Ctor:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
mr        r31, r3

bl __ct__7AreaObjFPCc
lis       r4, .QuickWarpArea_VTable@ha
addi      r4, r4, .QuickWarpArea_VTable@l
stw       r4, 0x00(r31)
li r4, 0
stw       r4, 0x48(r31) #Flag for making sure we transition properly.
li r4, 60
stw       r4, 0x4C(r31) #Open Wipe Delay timer
mr        r3, r31

lwz       r31, 0x0C(r1)
lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr


.QuickWarpArea_Init:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
#stw       r30, 0x08(r1)
mr        r31, r3
#mr r30, r4

bl        init__7AreaObjFRC12JMapInfoIter
mr        r3, r31
bl        connectToSceneAreaObj__2MRFP7NameObj

lwz       r31, 0x0C(r1)
#lwz       r30, 0x08(r1)
lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr
#===========================
.QuickWarpArea_Movement:
stwu      r1, -0x80(r1)
mflr      r0
stw       r0, 0x84(r1)
addi      r11, r1, 0x80
bl _savegpr_25
mr        r31, r3

bl .GLE_IsNeedCancelActionDueToDeath
cmpwi r3, 0
beq .QuickWarpArea_Movement_Normal


#if we need to cancel the wipe, do so here
lwz r3, 0x48(r31)
cmpwi r3, 0
beq .QuickWarpArea_Movement_Return

bl forceOpenWipeCircle__2MRFv
bl forceOpenSystemWipeCircle__2MRFv

#blasted
bl .MR_SystemCircleWipeToCenter

li r3, 0
stw r3, 0x48(r31)

b .QuickWarpArea_Movement_Return

.QuickWarpArea_Movement_Normal:
lwz r3, 0x48(r31)
cmpwi r3, 1
beq .QuickWarpArea_WaitForWipe
cmpwi r3, 2
beq .QuickWarpArea_MovePlayer
cmpwi r3, 3
beq .QuickWarpArea_WaitDelay

li r3, 0
stw r3, 0x48(r31)

lbz r3, 0x1C(r31)
cmpwi r3, 0
beq .QuickWarpArea_Movement_Return

bl getPlayerPos__2MRFv
mr        r4, r3
mr        r3, r31
lwz       r12, 0(r31)
lwz       r12, 0x2C(r12)
mtctr     r12
bctrl     # AreaObj::isInVolume(const(JGeometry::TVec3_f_ const &))
cmpwi     r3, 0
#If mario is not in the area, do nothing and return
beq       .QuickWarpArea_Movement_Return

.QuickWarpArea_DoWipe:
lwz r3, 0x2C(r31)
cmpwi r3, 0
bne .QuickWarpArea_ActuallyDoWarp

li r3, 2
stw r3, 0x48(r31) #Skip straight to moving the player
b .QuickWarpArea_Movement_Return

.QuickWarpArea_ActuallyDoWarp:
li r3, 1 #change state to Wait for Wipe
stw r3, 0x48(r31)

#Lets decide which wipe to use
lwz r3, 0x2C(r31) #Load the Wipe Time
lwz r4, 0x28(r31) #Load the Wipe Type

cmpwi r4, 0
beq .QuickWarpArea_Movement_WipeFade
cmpwi r4, 1
beq .QuickWarpArea_Movement_WipeCircle
cmpwi r4, 2
beq .QuickWarpArea_Movement_WipeMario
cmpwi r4, 3
beq .QuickWarpArea_Movement_WipeKoopa
cmpwi r4, 4
beq .QuickWarpArea_Movement_WipeGameOver

#Default option
bl closeWipeWhiteFade__2MRFl
b .QuickWarpArea_Movement_WipeDetermined

.QuickWarpArea_Movement_WipeFade:
bl closeWipeFade__2MRFl
b .QuickWarpArea_Movement_WipeDetermined

.QuickWarpArea_Movement_WipeCircle:
bl closeWipeCircle__2MRFl
b .QuickWarpArea_Movement_WipeDetermined

.QuickWarpArea_Movement_WipeMario:
bl closeSystemWipeMario__2MRFl
b .QuickWarpArea_Movement_WipeDetermined

.QuickWarpArea_Movement_WipeKoopa:
bl startDownWipe__2MRFv
b .QuickWarpArea_Movement_WipeDetermined

.QuickWarpArea_Movement_WipeGameOver:
bl startGameOverWipe__2MRFv

.QuickWarpArea_Movement_WipeDetermined:
#Check to see if we're capturing the screen or not
bl offPlayerControl__2MRFv
#bl pauseOnCameraDirector__2MRFv
b .QuickWarpArea_Movement_Return

.QuickWarpArea_WaitForWipe:
bl isSystemWipeActive__2MRFv
cmpwi r3, 0
bne .QuickWarpArea_Movement_Return
bl isWipeActive__2MRFv
cmpwi r3, 0
bne .QuickWarpArea_Movement_Return

li r3, 2 #change state to move player
stw r3, 0x48(r31)

b .QuickWarpArea_Movement_Return

.QuickWarpArea_MovePlayer:
lwz r3, 0x38(r31)
cmpwi r3, 0
ble .QuickWarpArea_NoLoadIcon
cmpwi r3, 2
beq .QuickWarpArea_NoLoadIcon
bl .MR_StartLoadingIcon

.GLE PRINTADDRESS
.QuickWarpArea_NoLoadIcon:
#ok finally
lwz r3, 0x38(r31)
cmpwi r3, 1
ble .QuickWarpArea_AbsoluteWarp
bl curePlayerElementMode__2MRFv

.QuickWarpArea_AbsoluteWarp:
#First lets make the name of our target
mr r3, r31
addi r4, r1, 0x08
bl .QuickWarpArea_GetPositionName
#Put mario at the position and open wipe
addi r3, r1, 0x08
bl setPlayerPos__2MRFPCc
li r3, 3 #change state to wait for the countdown
stw r3, 0x48(r31)
lwz r3, 0x24(r31)
stw r3, 0x4C(r31) #Set the countdown

b .QuickWarpArea_Movement_Return


.QuickWarpArea_WaitDelay:
lwz r3, 0x4C(r31)
cmpwi r3, 0
subi r3, r3, 1
stw r3, 0x4C(r31)
bgt .QuickWarpArea_Movement_Return


#Might need to jump over this?
bl .MR_IsLoadingIconOut
cmpwi r3, 0
beq .QuickWarpArea_OpenWipe
bl .MR_EndLoadingIcon

.QuickWarpArea_OpenWipe:
li r3, 0 #change state to none
stw r3, 0x48(r31)
#Lets decide which wipe to use
lwz r3, 0x34(r31) #Load the Wipe Time
lwz r4, 0x30(r31) #Load the Wipe Type

cmpwi r3, 0
beq .QuickWarpArea_OpenWipeDetermined #no wipe

cmpwi r4, 0
beq .QuickWarpArea_Movement_WipeFadeOpen
cmpwi r4, 1
beq .QuickWarpArea_Movement_WipeCircleOpen
cmpwi r4, 2
beq .QuickWarpArea_Movement_WipeMarioOpen

#Default option
bl openWipeWhiteFade__2MRFl
b .QuickWarpArea_OpenWipeDetermined

.QuickWarpArea_Movement_WipeFadeOpen:
bl openWipeFade__2MRFl
b .QuickWarpArea_OpenWipeDetermined

.QuickWarpArea_Movement_WipeCircleOpen:
bl openWipeCircle__2MRFl
b .QuickWarpArea_OpenWipeDetermined

.QuickWarpArea_Movement_WipeMarioOpen:
bl openSystemWipeMario__2MRFl

.QuickWarpArea_OpenWipeDetermined:
li r3, 1
bl onPlayerControl__2MRFb
#bl pauseOffCameraDirector__2MRFv

.QuickWarpArea_Movement_Return:
addi      r11, r1, 0x80
bl _restgpr_25
lwz       r0, 0x84(r1)
mtlr      r0
addi      r1, r1, 0x80
blr


.QuickWarpArea_GetManagerName:
lis r3, .QuickWarpArea_ManagerName@ha
addi r3, r3, .QuickWarpArea_ManagerName@l
blr


.FLOAT32_MAX_VALUE:
.int 0x7F7FFFFF
.QuickWarpArea_GetPositionName:
stwu      r1, -0x80(r1)
mflr      r0
stw       r0, 0x84(r1)
addi      r11, r1, 0x80
bl _savegpr_25
mr        r31, r3
mr r30, r4

lwz r3, 0x3C(r31)
cmpwi r3, -1
lwz r6, 0x20(r31)
beq .QuickWarpArea_GetPositionName_MakeName
#Just completely ignore the searching if ObjArg7 is set to -1

mr r29, r3  #Length
mr r28, r6, #i
lwz r27, 0x20(r31) #Id of Closest
lis r3, .FLOAT32_MAX_VALUE@ha
addi r3, r3, .FLOAT32_MAX_VALUE@l
lwz r3, 0x00(r3)
stw r3, 0x08(r1) #Last calculated distance
b .QuickWarpArea_GetPositionName_LoopStart

.QuickWarpArea_GetPositionName_Loop:
mr r3, r30
li        r4, 0x40
lis r5, .QuickWarpArea_PositionNameFormat@ha
addi r5, r5, .QuickWarpArea_PositionNameFormat@l
mr r6, r28
crclr     4*cr1+eq
bl        snprintf

mr r3, r30
addi r4, r1, 0x0C
li r5, 0
bl tryFindNamePos__2MRFPCcPQ29JGeometry8TVec3<f>PQ29JGeometry8TVec3<f>
cmpwi r3, 0
beq .QuickWarpArea_GetPositionName_LoopContinue

#Position exists!
#Take Mario's position 
bl getPlayerPos__2MRFv
mr r4, r3
addi r3, r1, 0x0C
bl PSVECDistance
#result in f1
lfs f2, 0x08(r1)
fcmpo cr0, f1, f2
cror      eq, lt, eq
bne .QuickWarpArea_GetPositionName_LoopContinue

#We found a closer one!
stfs f1, 0x08(r1)
mr r27, r28


.QuickWarpArea_GetPositionName_LoopContinue:
addi r28, r28, 1
.QuickWarpArea_GetPositionName_LoopStart:
cmpw r28, r29
ble .QuickWarpArea_GetPositionName_Loop

#Take the ID of the closest
mr r6, r27

.QuickWarpArea_GetPositionName_MakeName:
mr r3, r30
li        r4, 0x40
lis r5, .QuickWarpArea_PositionNameFormat@ha
addi r5, r5, .QuickWarpArea_PositionNameFormat@l
crclr     4*cr1+eq
bl        snprintf

.QuickWarpArea_GetPositionName_Return:
addi      r11, r1, 0x80
bl _restgpr_25
lwz       r0, 0x84(r1)
mtlr      r0
addi      r1, r1, 0x80
blr

.END_OF_QUICKWARPAREA_CODE:
.GLE ASSERT __sinit_\Meister_cpp
.GLE PRINTADDRESS
.GLE ENDADDRESS




.GLE ADDRESS .END_OF_MEISTER_DATA
.QuickWarpArea_ObjName:
    .string "QuickWarpArea"

.QuickWarpArea_PositionNameFormat:
    .string "QuickWarpPos%d"
    
.QuickWarpArea_ManagerName:
    .string "SceneChangeArea" AUTO
    
    
.QuickWarpArea_VTable:
.int 0
.int 0
.int __dt__15SceneChangeAreaFv #Sharing DTors again... Somebody stop this man!
.int .QuickWarpArea_Init
.int initAfterPlacement__7NameObjFv
.int .QuickWarpArea_Movement
.int draw__7NameObjCFv
.int calcAnim__7NameObjFv
.int calcViewAndEntry__7NameObjFv
.int startMovement__7NameObjFv
.int endMovement__7NameObjFv
.int isInVolume__7AreaObjCFRCQ29JGeometry8TVec3<f>
.int getAreaPriority__7AreaObjCFv
.int .QuickWarpArea_GetManagerName
    

.END_OF_QUICKWARPAREA_DATA:
.GLE ENDADDRESS