#This is a half port of RestartCube from SMG1
#It serves as a way to change which spawn point gets used


#Replaces WorldMapSyncSoundEmitterCube
#Use the symbol to reference the string
.GLE ADDRESS WorldMapSyncSoundEmitterCube
.string "RestartArea" AUTO
.GLE ENDADDRESS

.GLE ADDRESS cCreateTable__16AreaObjContainer +0x444
.int WorldMapSyncSoundEmitterCube
.int 0x00000030
.GLE ENDADDRESS

#For completness sake, the entire function is here
.GLE ADDRESS createBaseOriginCube<28SoundEmitterCubeWorldMapSync>__14NameObjFactoryFPCc_P7NameObj
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
mr        r31, r3
li        r3, 0x50
bl        __nw__FUl
cmpwi     r3, 0
beq       .RestartArea_Create_Return
mr        r4, r31
bl        .RestartArea_Ctor

.RestartArea_Create_Return:
lwz       r0, 0x14(r1)
lwz       r31, 0x0C(r1)
mtlr      r0
addi      r1, r1, 0x10
blr

.GLE ENDADDRESS

.GLE ADDRESS __ct__28SoundEmitterCubeWorldMapSyncFiPCc
.RestartArea_Ctor:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
mr        r31, r3

bl        __ct__7AreaObjFPCc
lis       r4, __vt__28SoundEmitterCubeWorldMapSync@ha
addi      r4, r4, __vt__28SoundEmitterCubeWorldMapSync@l
stw       r4, 0(r31)
mr r3, r31

lwz       r31, 0x0C(r1)
lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr
.GLE ASSERT __dt__16SoundEmitterCubeFv
.GLE ENDADDRESS

.GLE ADDRESS init__28SoundEmitterCubeWorldMapSyncFRC12JMapInfoIter
.RestartArea_Init:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
stw       r30, 0x08(r1)

mr        r31, r3
mr        r30, r4
bl init__7AreaObjFRC12JMapInfoIter

mr        r3, r31
bl connectToSceneAreaObj__2MRFP7NameObj

li        r3, 0x08
bl        __nw__FUl
cmpwi     r3, 0
beq       .RestartArea_Init_Return
lwz       r4, 0x20(r31)
mr        r5, r30
bl        __ct__10JMapIdInfoFlRC12JMapInfoIter

.RestartArea_Init_Return:
stw r3, 0x48(r31)

lwz       r31, 0x0C(r1)
lwz       r30, 0x08(r1)
lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr

.GLE ASSERT __ct__18SoundEmitterSphereFiPCc
.GLE ENDADDRESS

.GLE ADDRESS .POWER_STAR_RETURN_DEMO_STARTER_CONNECTOR
#replaces something regarding the worldmap idk lol
.RestartArea_Movement:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)

mr r31, r3
lbz r3, 0x1C(r31)
cmpwi r3, 0
beq .RestartArea_Movement_Return

#WHY DOES THIS NEED TO BE HERE????
bl isScenarioSelecting__2MRFv
cmpwi r3, 0
bne .RestartArea_Movement_Return

bl getPlayerPos__2MRFv
mr        r4, r3
mr        r3, r31
lwz       r12, 0(r31)
lwz       r12, 0x2C(r12)
mtctr     r12
bctrl     # AreaObj::isInVolume(const(JGeometry::TVec3_f_ const &))
cmpwi     r3, 0
#If mario is not in the area, do nothing and return
beq       .RestartArea_Movement_Return

#if the player is inside, update the respawn point
#As long as the area is active, and mario is in it, this will happen
lwz       r3, 0x48(r31)
bl setRestartMarioNo__2MRFRC10JMapIdInfo
bl sub_804D8210

.RestartArea_Movement_Return:
lwz       r31, 0x0C(r1)
lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr

.RESTART_AREA_CONNECTOR:
.GLE ENDADDRESS


.GLE ADDRESS __vt__28SoundEmitterCubeWorldMapSync
.int 0
.int 0
.int __dt__9DeathAreaFv #Gonna use the DeathArea's Dtor and you can't stop me >:)
.int .RestartArea_Init
.int initAfterPlacement__7NameObjFv
.int .RestartArea_Movement
.int draw__7NameObjCFv
.int calcAnim__7NameObjFv
.int calcViewAndEntry__7NameObjFv
.int startMovement__7NameObjFv
.int endMovement__7NameObjFv
.int isInVolume__7AreaObjCFRCQ29JGeometry8TVec3<f>
.int getAreaPriority__7AreaObjCFv
.int getManagerName__7AreaObjCFv
.GLE ENDADDRESS