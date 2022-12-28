#Re-writing GameScene::Init
#To make it better

.GLE ADDRESS init__9GameSceneFv
stwu      r1, -0x30(r1)
mflr      r0
stw       r0, 0x34(r1)
addi      r11, r1, 0x30
bl        _savegpr_29

mr r29, r3 #Scene*
#For some reason, Vanilla SMG2 calls MR::isStageFileSelect
#It does nothing with the result, so we will omit it here

#Calls to a blr. Omitting.
#bl createHioBasicNode__13SceneFunctionFP5Scene
bl startStageFileLoad__13SceneFunctionFv

#Reset the loading icon
bl .MR_ResetLoadingIcon

#Start the loading Icon.
#Won't do anything if the icon was disabled in GameSettings
bl .MR_StartLoadingIcon

.NoStartLoadIcon:
#Doing this doesn't feel right...
#But if I don't, the game locks up when you pick a file...
bl isStageFileSelect__2MRFv
cmpwi r3, 1
li r3, 0
beq .SkipLuigi

bl isPlayerLuigi__2MRFv
.SkipLuigi:
cntlzw  r0, r3
srwi      r3, r0, 5
bl requestChangeArchivePlayer__2MRFb
cmpwi r3, 0
mr r31, r3
li r30, 1
bne       loc_804514D8
bl        sub_80057410
cmpwi     r3, 0
beq       loc_804514D8
li        r30, 0


loc_804514D8:
mr        r3, r29
addi r4, r13, sInstance__Q212NrvGameScene30GameSceneScenarioOpeningCamera - STATIC_R13
li r5, 0
bl initNerve__13NerveExecutorFPC5Nervel
bl initForNameObj__13SceneFunctionFv
bl initForLiveActor__13SceneFunctionFv

mr r3, r29
#TODO: Edit InitEffect to allow users to change the particle storage amounts
bl initEffect__9GameSceneFv

li        r3, 0x18      # CameraContext
bl        createSceneObj__2MRFi
li        r3, 0x19      # IgnorePauseObjs
bl        createSceneObj__2MRFi
li        r3, 0x3B      # SupportPlayActorList?
bl        createSceneObj__2MRFi
li        r3, 0x15      # MarioHolder
bl        createSceneObj__2MRFi
li        r3, 0x11      # AudCameraWatcher
bl        createSceneObj__2MRFi
li        r3, 0x12      # AudEffectDirector
bl        createSceneObj__2MRFi
li        r3, 0x13      # AudBgmConductor
bl        createSceneObj__2MRFi
li        r3, 0x14      # ActionSoundSystem
bl        createSceneObj__2MRFi
li        r3, 0x2C      # ResourceShare
bl        createSceneObj__2MRFi
li        r3, 0x1B      # EventSequencer
bl        createSceneObj__2MRFi
li        r3, 0x28      # FurDrawManager
bl        createSceneObj__2MRFi
li        r3, 0x29      # PlacementStateChecker
bl        createSceneObj__2MRFi
lfs       f1, ScreenAlphaCapture_flt - STATIC_R2(r2) #1.0f
li        r3, 0         # ScreenAlphaCapture
bl        createScreenAlphaSceneObj__2MRFlf
li        r3, 0x72      # GroupCheckManager
bl        createSceneObj__2MRFi
li        r3, 0x7A      # CinemaFrame
bl        createSceneObj__2MRFi
li        r3, 0x7E      # PlanetMapCreator
bl        createSceneObj__2MRFi
li        r3, 0x7F      # ProductMapObjCreator
bl        createSceneObj__2MRFi
li        r3, 0x90      # PauseBlur
bl        createSceneObj__2MRFi

#Normally, we'd initilize the Postman system here.
#But the GLE does not have a postman system replacement.
#And, this would have to get initilized after the stage is loaded and the game state is set

#Note that the GLE never really checks to see if the stage is a specific stage for hubworlds.
#We rather prefer to check the game state... which won't be ready at this point... oof
#Will have to make the WC24 Message sender later...

#We need to wait until the stage files get loaded
#This appears to be running on a separate thread because the game will still run even thought it is stuck in a loop here
bl waitDoneStageFileLoad__13SceneFunctionFv

cmpwi r31, 0
beq       loc_804515D8
#If we need to change players, we'll need to wait for that to finish too!
bl waitEndChangeArchivePlayer__2MRFv
loc_804515D8:

#Something nice, is that we start loading the COMMON layer
bl startActorFileLoadCommon__13SceneFunctionFv

#Normally, SMG2 would load the Worldmap information here, but since the GLE doesn't have the worldmap, we can skip that

#Lets check to see if we are in the ScenarioSelect
bl isScenarioSelecting__2MRFv
cmpwi r3, 0
beq loc_80451618

bl receiveAllRequestedFile__2MRFv
bl getFunctionAsyncExecutor__24_unnamed_SystemUtil_cpp_Fv
lwz       r3, 0x20(r3)
mr        r4, r30
bl        sub_804AE470

.WaitForData_1:
bl sub_80452CD0
cmpwi r3, 0
beq .WaitForData_1

loc_80451618:
lis r3, SceneInitilization@Ha
addi r3, r3, SceneInitilization@l
bl suspendAsyncExecuteThread__2MRFPCc

bl isScenarioDecided__2MRFv
cmpwi r3, 0
bne loc_80451644

bl receiveAllRequestedFile__2MRFv
bl getFunctionAsyncExecutor__24_unnamed_SystemUtil_cpp_Fv
lwz       r3, 0x20(r3)
bl sub_804AE5F0
b GameScene_Init_Return

loc_80451644:
#Load some more stuff after a scenario has been selected
bl initAfterScenarioSelected__13SceneFunctionFv
bl sub_80458B80
bl startActorFileLoadScenario__13SceneFunctionFv

bl .MR_StartLoadingIcon

#We can make the WC24 thing now
#But only if it's enabled!

bl .MR_IsGameStateHubworld
cmpwi r3, 0
beq .NoWC24

lis r3, AllCompleteMessage@ha
addi r3, r3, AllCompleteMessage@l
li r4, 1
bl .MR_GetGameSetting
cmpwi r3, 0
beq .NoWC24

li r3, 0x98 # WiiMessageBoardEmailSender
bl createSceneObj__2MRFi

.NoWC24:

li r3, 0x04 #EventDirector
bl createSceneObj__2MRFi
li r3, 3         # DemoDirector
bl createSceneObj__2MRFi

bl initSceneMessage__2MRFv #Loads the message data for this galaxy

li r3, 0x3A      # CameraDirector
bl createSceneObj__2MRFi
li r3, 0x3D      # GameSceneLayoutHolder
bl createSceneObj__2MRFi
li r3, 0x44      # StarPieceDirector
bl createSceneObj__2MRFi
li r3, 0x25      # SceneWipeHolder
bl createSceneObj__2MRFi
li r3, 0x2A      # NamePosHolder
bl createSceneObj__2MRFi
li r3, 0x81      # InformationObserver
bl createSceneObj__2MRFi

.GLE PRINTMESSAGE == GameScene::init Binding position ==
.GLE PRINTADDRESS
#=== BINDING ===
nop
#If you need access to GameScene::init (with Syati related code), you can hook here.

#If the selected scenario needs the ScoreAttackAccessor, create it
#This function was overridden in ScoreAttackMan.s
bl isStageScoreAttack__2MRFv
cmpwi r3, 0
beq .SkipScoreAttackAccessor
li r3, 0x35      # ScoreAttackAccessor
bl createSceneObj__2MRFi

.SkipScoreAttackAccessor:
#Okay, if this stage is a hubworld, we'll need to create some scene objects
#Usually, there are 4, but 3 of them were obsoleted by the GLE. One of them will be replaced with a portable
#Stage results SceneObj in the future

bl .MR_IsGameStateHubworld
cmpwi r3, 0
beq .SkipHubworldSceneObjs
li r3, 0x97      # MarioFaceShipEventDataHolder
bl createSceneObj__2MRFi

#MarioFaceShipSwitch was replaced by ScenarioSwitch
#FeaturedConversationDemoSupporter is useless
#ConversationDemoSupporter is useless

.SkipHubworldSceneObjs:
#Init in stage flags
bl initInStageFlags__2MRFv

#Init lightdata
bl initLightData__13LightFunctionFv

#Init sequences
mr        r3, r29
bl initSequences__9GameSceneFv

#Normally, we'd initilize the worldmap result director here, but the GLE has no worldmaps

#Initilize the starbits that can be used in the scene freely
#70 are initilized
bl createStarPiece__2MRFv

#Now start placing actors
bl startActorPlacement__13SceneFunctionFv

#I mean, idk if anyone will use this layout, but since it should still work, I suppose I'll leave it in
#Enable it with ScenarioSettings.bcsv
bl isStageStoryBook__2MRFv
cmpwi     r3, 0
beq       loc_80451720
li        r3, 0x89      # StorybookLayoutManager
bl        createSceneObj__2MRFi

loc_80451720:

#Here's an interesting one
#The FileSelect is like, the only galaxy I am willing to keep hardcoded
#This will skip spawning the P2 Luma
#Usually there would be code to do it for worldmaps as well but... you know... No worldmaps
bl isStageFileSelect__2MRFv
cmpwi r3, 0
bne .SkipSupportTico
li        r3, 0x62      # SupportTico
bl        createSceneObj__2MRFi
.SkipSupportTico:


#More worldmap stuff was originally here, again, we do a little skipping

#Audio thing
mr        r3, r30
bl sub_80452CC0

bl completeCameraParameters__2MRFv
bl initStarPointerGameScene__2MRFv
bl initEventSystemAfterPlacement__2MRFv
bl endInitLiveActorSystemInfo__2MRFv
bl setInitializeStateAfterPlacement__2MRFv

#Okay now we need to call a method on all scene name objects....
#I don't know which function, but likely InitAfterPlacement

#UnknownGameScene_Init_NameObj_Thingy
lis       r6, UnknownGameScene_Init_NameObj_Thingy@ha
lwzu      r5, UnknownGameScene_Init_NameObj_Thingy@l(r6)
stw       r5, 0x08(r1)
addi      r3, r1, 0x08
lwz       r4, 0x04(r6)
lwz       r0, 0x08(r6)
stw       r4, 0x0C(r1)
stw       r0, 0x10(r1)
bl        callMethodAllSceneNameObj__2MRFM7NameObjFPCvPv_v

bl initSyncSleepController__16SleepControlFuncFv

#We'd deactivate the default game layout if we were in the worldmap here
#Like that's ever gonna happen...

#And that's it! We now need to wait for every file to finish coming in
.WaitForData_2:
bl sub_80452CD0
cmpwi r3, 0
beq .WaitForData_2

bl getFunctionAsyncExecutor__24_unnamed_SystemUtil_cpp_Fv
lwz       r3, 0x20(r3)
bl sub_804AE540

#Turn off the loading icon
#Won't do anything if the layout is disabled
bl .MR_EndLoadingIcon

GameScene_Init_Return:
addi      r11, r1, 0x30
bl        _restgpr_29
lwz       r0, 0x34(r1)
mtlr      r0
addi      r1, r1, 0x30
blr

#Make sure we never program over GameScene::Start by mistake
.GLE PRINTADDRESS
.GLE ASSERT start__9GameSceneFv
.GLE ENDADDRESS

.GLE ADDRESS start__9GameSceneFv
#GameScene::start((void))
stwu      r1, -0x20(r1)
mflr      r0
stw       r0, 0x24(r1)
stw       r31, 0x1C(r1)
mr        r31, r3
#bl        MR::isIslandFleetGalaxy1FirstTime((void))
#stb       r3, 0x2A(r31)
bl        getSceneMgr__7AudWrapFv
bl        startScene__11AudSceneMgrFv

bl        isAwaitPadMovement__20GameSequenceFunctionFv
cmpwi     r3, 0
beq       loc_8045183C
addi      r3, r1, 0x0C
addi      r4, r1, 0x08
bl        getDreamerPadData__2MRFPPvPl
lwz       r3, 0x0C(r1)
lwz       r4, 0x08(r1)
bl        initializePadRecorder__2MRFPvUl
bl        tryStartPadRecorder__2MRFv

loc_8045183C:




#needed some more space...
#Located inside HubworldState.s
b .GameScene_Extra
.GameScene_Extra_Return:
mr        r3, r31
bl        startStarPointerModeGame__2MRFPv
mr        r3, r31
bl        isValidScenarioOpeningCamera__9GameSceneCFv
cmpwi     r3, 0
bne       loc_8045186C
bl        isBeginScenarioStarter__2MRFv
cmpwi     r3, 0
bne       loc_8045186C

b .GameScene_Extra2
.GameScene_Extra2_Return:
mr        r3, r31
bl        startStageBgm__9GameSceneFv

loc_8045186C:
mr        r3, r31
addi      r4, r13, sInstance__Q212NrvGameScene15GameSceneAction - STATIC_R13
bl        setNerve__13NerveExecutorFPC5Nerve
lwz       r0, 0x24(r1)
lwz       r31, 0x1C(r1)
mtlr      r0
addi      r1, r1, 0x20
blr
.GLE ASSERT update__9GameSceneFv
.GLE ENDADDRESS

#Located inside HubworldState.s
.GLE ADDRESS startStageBgm__9GameSceneFv +0x70
b .GameScene_Extra3
.GameScene_Extra3_Return:
.GLE ENDADDRESS

.GLE ADDRESS startStageBgm__9GameSceneFv +0x94
loc_80452684:
.GLE ENDADDRESS


.GLE ADDRESS requestChangeStageAfterMiss__2MRFv
#Check SceneUtility.s
b .RequestChangeStageAfterMiss







#Called from HubworldState.s
.EndScenarioSelectBgm:
b sub_8001BB90 #Needed to end the Scenario Select music





#Thanks I hate it
.EndScenarioSelectBgmWithForceToBlank:
bl sub_8001BB90
mr        r3, r31
b .EndScenarioSelectBgmWithForceToBlank_Return

.GLE ADDRESS exeScenarioOpeningCamera__9GameSceneFv +0x74
b .EndScenarioSelectBgmWithForceToBlank
.EndScenarioSelectBgmWithForceToBlank_Return:
.GLE ENDADDRESS


#Thanks I hate it 2: electric bugaloo
.EndScenarioSelectBgmWithForceToBlank2:
bl sub_8001BB90
mr        r3, r31
b .EndScenarioSelectBgmWithForceToBlank2_Return

.GLE ADDRESS sub_80451CA0 +0x44
b .EndScenarioSelectBgmWithForceToBlank2
.EndScenarioSelectBgmWithForceToBlank2_Return:
.GLE ENDADDRESS


#Fixes for making sure you respawn at the correct location
.GetSceneStartID:
lwz       r3, sInstance__29SingletonHolder_10GameSystem_ - STATIC_R13(r13)
lwz       r3, 0x24(r3)
addi      r3, r3, 0x8C
lwz       r3, 0x88(r3)
blr


.requestGalaxyMove_Ex:
bl .GetSceneStartID
bl setRestartMarioNo__2MRFRC10JMapIdInfo
addi      r11, r1, 0x20
b .requestGalaxyMove_Ex_Return


.exePowerStarGetDemo_Ex:
b requestChangeStageAfterStageClear__2MRFv
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
bl forceCloseSystemWipeCircle__2MRFv
bl .MR_SystemCircleWipeToCenter
bl requestChangeStageAfterStageClear__2MRFv
lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr



.GLE ADDRESS exeConfirm__9PauseMenuFv +0x88
b .StopSubBGM
.StopSubBGM_Return:
.GLE ENDADDRESS

.StopSubBGM:
li r3, 0x00
bl stopSubBGM__2MRFUl
li        r3, 0x5A
b .StopSubBGM_Return

.GLE ENDADDRESS

.GLE ADDRESS exeGrandStarGetDemo__22GameStageClearSequenceFv +0x98
bl closeSystemWipeFade__2MRFl
.GLE ENDADDRESS

.GLE ADDRESS sub_804D8360 +0x8C
#This code syncs mario's start id with the respawn id
b .requestGalaxyMove_Ex
.requestGalaxyMove_Ex_Return:
.GLE ENDADDRESS

.GLE ADDRESS init__18ScenePlayingResultFv +0x64
bl .GetSceneStartID
.GLE ENDADDRESS



.GLE ADDRESS exeSaveAfterGameOver__9GameSceneFv +0x38
bl .RequestChangeStageAfterGameOver
.GLE ENDADDRESS

.GLE ADDRESS calcAnim__9GameSceneFv +0x4C
#Removing the WorldMapResultCommander
li r3, 0
.GLE ENDADDRESS

.GLE ADDRESS exeAction__9GameSceneFv +0x44
li r3, 0
.GLE ENDADDRESS

.GLE ADDRESS sub_80452050 +0x44
li r3, 0
.GLE ENDADDRESS

.GLE ADDRESS draw3D__9GameSceneCFv +0xCC
li r3, 0
.GLE ENDADDRESS

.GLE ADDRESS draw3D__9GameSceneCFv +0x12C
li r3, 0
.GLE ENDADDRESS




#TODO?
#This likely doesn't belong here....
#But Idk what file it should go in
.GLE ADDRESS sub_8045AA60 +0x18C
nop
.GLE ENDADDRESS

.GLE ADDRESS sub_8045AA60 +0xDC
nop
nop
nop
nop
.GLE ENDADDRESS

.GLE ADDRESS exePowerStarGetDemo__22GameStageClearSequenceFv +0xB8
bl .exePowerStarGetDemo_Ex
.GLE ENDADDRESS

.GLE ADDRESS exeGrandStarGetDemo__22GameStageClearSequenceFv +0xC0
bl .exePowerStarGetDemo_Ex
.GLE ENDADDRESS

.GLE ADDRESS exeGrandStarGetDemo__22GameStageClearSequenceFv +0x11C
bl .exePowerStarGetDemo_Ex
.GLE ENDADDRESS
