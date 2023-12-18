#Below are functions not found in the symbol maps
#Some may be named incorrectly, but some may be named better than the maps.

.GLE REGION NTSC-U
.set Ctor_MiniMeister, 0x804E3880
.set Sinit_MiniMeister, 0x804E4390
.set Sinit_MiniPlayerRocket, 0x804E5300

.set isExistItemInfo__8JMapInfoFPCc, 0x8004CC60
.set isStarComet__20GalaxyStatusAccessorCFl, 0x804D1BE0

#Better name for this function
.set isCompleteAllScenario__20GalaxyStatusAccessorCFv, 0x804D1E70

.set getGameEventFlagFaceShipEvent__2MRFi, 0x804D40C0
.set permitTrigSE__2MRFv, 0x8005BB60

.set getBestScenarioTime__2MRFPCcl, 0x804D3D10
.set hasRecordedRaceTimeInScenario__2MRFi, 0x8048D070
.set hasRecordedScoreInScenario__2MRFi, 0x8048D0F0

.set getRaceId__19RaceManagerFunctionFPCc, 0x802653F0
.set goNext2__16ScenarioDataIterFv, 0x804CBC70
#The symbol in the actual symbol map is wrong @aurum
.set makeBeginScenarioDataIter__2MRFP16ScenarioDataIter, 0x804CBF70

.set getGreenStarMainScenario__2MRFPCcl, 0x804D80E0

.set changeColour__11CinemaFrameFv, 0x80463D10 
.set setColor__12WipeGameOverFP11LayoutActor, 0x804A6A90
.set setColor__9WipeKoopaFP11LayoutActor, 0x804A7480

.set init__24FeaturedConversationDemoFRC12JMapInfoIter, 0x802C7E20
.set startCurrentStageBGM__2MRFi, 0x8001B020
#Better name than what's in the actual symbol map, as Comets aren't included in this function, but are not normal stars.
.set isStarHiddenOrGreen__20GalaxyStatusAccessorCFv, 0x804D1CF0


.set __ct__19GalaxyArchiveHolderFPCc, 0x8045B070
.set setStateInStage__16InGameActorStateFPCc, 0x804B3F00
.set setStateNoStage__16InGameActorStateFv, 0x804B3F50
.set setStateMarioFaceShip__16InGameActorStateFv, 0x804B3EE0

.set isStateMarioFaceShip__16InGameActorStateFv, 0x804B3F60

.set setPlayerStatusMario__2MRFv, 0x804D3010

.set getFunctionAsyncExecutor__24_unnamed_SystemUtil_cpp_Fv, 0x804B95C0

.set isScenarioSelecting__2MRFv, 0x80060320
.set initSceneMessage__2MRFv, 0x80060770
.set initInStageFlags__2MRFv, 0x804D82E0
.set callMethodAllSceneNameObj__2MRFM7NameObjFPCvPv_v, 0x80060330
.set initSyncSleepController__16SleepControlFuncFv, 0x80245290

.set initlizeInGameActorState__2MRFv, 0x804D7BA0
.set setStateTitle__20GameSequenceProgressFv, 0x804B30F0
.set setStateInStage__20GameSequenceProgressFv, 0x804B3100
.set requestChangeStageInGameAfterLoadingGameData__2MRFv, 0x804D62C0

.set setCurrentWorld__2MRFl, 0x804D3F10
.set getScenePlayingResultMarioFaceShip__16InGameActorStateFv, 0x804B3F70

.set onMarioFaceShipSwitches__2MRFv, 0x804BF440

.set isSystemWipeOpen__2MRFv, 0x80059120


.set getSceneMgr__7AudWrapFv, 0x8007C880
.set startScene__11AudSceneMgrFv, 0x800856B0
.set isValidScenarioOpeningCamera__9GameSceneCFv, 0x804525A0
.set startStageBgm__9GameSceneFv, 0x804525F0
.set exeScenarioOpeningCamera__9GameSceneFv, 0x80451D50
.set sub_80451CA0, 0x80451CA0

.set requestChangeStageAfterMiss__2MRFv, 0x804D6780
.set startScene__20GameSequenceFunctionFv, 0x804D85D0
.set exeStart__23InStageInGameActorStateFv, 0x804B4490
.set exeSaveAfterGameOver__9GameSceneFv, 0x80451DF0
.set enablePlayGameOverDemo__2MRFv, 0x804D79C0
.set requestChangeStageToWorldMap__2MRFv, 0x804D6460
.set initJmpInfo__15StageDataHolderFPQ22MR26AssignableArray_8JMapInfo_PCc, 0x8045B280
.set getScenePlayingResult__2MRFv, 0x804D6FE0
.set endStage__18ScenePlayingResultFv, 0x804C8ED0
.set setScenePlayingResultStarId__2MRFl, 0x804D6AA0
.set requestChangeStageAfterStageClear__2MRFv, 0x804D6670
.set getStageName__18ScenePlayingResultFv, 0x804C8EC0

.set __ct__14WorldMapHolderFv, 0x804E7BC0
.set findIndex__21GameEventValueCheckerCFPCc, 0x804DCD30
.set findIndexFromHashCode__21GameEventValueCheckerCFUs, 0x804DCDB0

#The symbol maps are incorrect, as there is no actual way to get the GalaxyDataTable.bcsv
#Aurum if you see this please fix the maps
.set MR_GetHubworldEventDataTable, 0x804B7230
.set MR_GetHubworldStarReturnDataTable, 0x804B7240
.set MR_GetGalaxyOrderList, 0x804B7250
.set MR_GetGameSettingsJMap, 0x804B7260
.set MR_GetGameEventValueTable, 0x804B7270

.set isBeatHighScore__18ScoreAttackCounterFv, 0x803769B0
.set updateHighScore__18ScoreAttackCounterFv, 0x80376760
.set initPositionList__16MameMuimuiScorerFP14ResourceHolder, 0x801C0BD0
.set initSequence__16MameMuimuiScorerFP14ResourceHolder, 0x801C0E30
.set appearNextSequence__16MameMuimuiScorerFv, 0x801C14C0
.set setRandomRemap__16MameMuimuiScorerFv, 0x801C1470
.set getPosition__24MameMuimuiPositionHolderFlRCQ29JGeometry8TVec3_f_, 0x801C0650
.set getDeadMameMuimui__15MameMuimuiGroupFv, 0x801C1610
.set setPosAndLifetime__10MameMuimuiFRCQ29JGeometry8TVec3_f_l, 0x801BF610
.set start__16MameMuimuiScorerFv, 0x801C11B0
.set updateHighScore__16MameMuimuiScorerFv, 0x801C1220
.set updateHighScore__13TogepinScorerFv, 0x80324A40

.set isStageForbidLeave__2MRFv, 0x80056610
.set getSettingInfo__14AudBgmSettingsFl, 0x80083890

.set setBgmStateYoshi, 0x80220B80
.set setBgmStateSlowdownTime, 0x80220C40

.set updateStarPane__9PauseMenuFv, 0x804872E0

.set createStarString__2MRFPwiPCcbb, 0x80041D60
.set hasPowerStarAsBronze__20GalaxyStatusAccessorCFl, 0x804D1DD0
.set getValue_l_PCc___2MRCFPlP8JMapInfoPCcPCcPCc_Cb, 0x8004D180
.set findElement_PCc_PCc___8JMapInfoCFPCcli_12JMapInfoIter, 0x8004CF70

.set appear__11AllStarListFv, 0x8045D700
.set appearArrows__11AllStarListFi, 0x8045DFF0
.set loadGalaxyNames__11AllStarListFi, 0x8045E170
.set isCompleteAllNormalScenario__20GalaxyStatusAccessorCFv, 0x804D1DE0
.set getPowerStarNumOwned__20GalaxyStatusAccessorCFv, 0x804D1F70
.set appearLayout__16GalaxySelectInfoFv, 0x804A9870
.set control__16GalaxySelectInfoFv, 0x804A97F0
.set __ct__16GalaxySelectInfoFl, 0x804A9440
.set __vt__16GalaxySelectInfo, 0x806F9D28
.set changeTexture__16GalaxySelectInfoFPCc, 0x804A9700
.set createGalaxyCompleteString__2MRFPwiPCcbb, 0x80042170
.set tryLoadCsvFromZoneInfo__2MRFPCc, 0x8004C580
.set setStartIdInfo__16SceneControlInfoFRC10JMapIdInfo, 0x804BA0F0
.set __as__10JMapIdInfoFRC10JMapIdInfo, 0x804BA100

.set endEvent__27CometEventExecutorTimeLimitFv, 0x803720B0
.set init__18ScenePlayingResultFv, 0x804C8D70
.set getRespawnPoint__2MRFv, 0x800251B0

.set initEventArray__23MarioFaceShipEventStateFv, 0x804B4B30
.set registerStarReturnEvents__23MarioFaceShipEventStateFPv, 0x804B4D60
.set isExistElement__8JMapInfoFPCcPCc, 0x8004CC90
.set appear__23MarioFaceShipEventStateFv, 0x804B4B70
.set isGameSaveEnabled__2MRFv, 0x804D7B10
.set tryStartDemoMarioPuppetableWithoutCinemaFrame__2MRFP7NameObjPCc, 0x8001F9C0
.set exeStartingEvents__23MarioFaceShipEventStateFv, 0x804B5AD0
.set exeStarReturnDemo__23MarioFaceShipEventStateFv, 0x804B5690
.set endStartEvents__23MarioFaceShipEventStateFv, 0x804B5460
.set isRunMarioFaceShipOpeningCamera__2MRFv, 0x804D7930
.set disableMarioFaceShipOpeningCamera__2MRFv, 0x804D7960
.set registerStartEvents__23MarioFaceShipEventStateFPv, 0x804B4F10
.set registerEvent__23MarioFaceShipEventStateFP5Event, 0x804B5C10
.set isPlayGameOverDemo__2MRFv, 0x804D7990
.set disablePlayGameOverDemo__2MRFv, 0x804D79F0
.set tryStartSaveDemo__23MarioFaceShipEventStateFv, 0x804B5150
.set startStarReturnEvents__23MarioFaceShipEventStateFv, 0x804B51B0
.set hasEventQueued__23MarioFaceShipEventStateFv, 0x804B4D10
.set startNextEvent__23MarioFaceShipEventStateFv, 0x804B5250
.set exeDoEvent__23MarioFaceShipEventStateFv, 0x804B57A0
.set startEvents__23MarioFaceShipEventStateFPCc, 0x804B5340
.set exeWaitDemoComplete__23MarioFaceShipEventStateFv, 0x804B58D0
.set exeWaitConversationComplete__23MarioFaceShipEventStateFv, 0x804B5980
.set getGameEventValueChecker__16GameDataFunctionFv, 0x804D2420
.set setDemoValue__21GameEventValueCheckerFPCciUl, 0x804DC940

.set requestScenePlayingResultEndStage__2MRFv, 0x804D6A50

.set tryStartTimeKeepDemoMarioPuppetableWithoutCinemaFrame__2MRFP7NameObjPCc, 0x8001FD30
.set exeStart__29MarioFaceShipInGameActorStateFv, 0x804B4810

.set loadStaticResource__11AudSceneMgrFv, 0x80085180
.set exeIntro__11RaceManagerFv, 0x80263E90
.set exeAction__9GameSceneFv, 0x80451E50
.set findStarID__2MRFPCc, 0x803730A0

.set isSystemWipeBlank__2MRFv, 0x80059100

.set reflectMissCounter__14FileSelectInfoFv, 0x8046DD70
.set reflectTrySetSpecialMessage__14FileSelectInfoFv, 0x8046DE90

.set execute__Q232NrvMarioFaceShipInGameActorState15HostTypeNrvWaitCFP5Spine, 0x804B4990
.set exeNoStage__16InGameActorStateFv, 0x804B4100
.set setWipeCircleCenterToPlayerHead__2MRFv, 0x804D5A40
.set registerDemoTalkMessageCtrl__12DemoFunctionFP9LiveActorP15TalkMessageCtrl, 0x80139250
.set resetPlayResultInStageHolder__2MRFv, 0x804D7270

.set isJustGetStar__20GameSequenceFunctionFPCcl, 0x804D5C80

.set updatePauseMenu__9AudSystemFv, 0x80079910
.set pause__9AudSystemFv, 0x800794E0


.set getPlayerLife__2MRFv, 0x8004FE10
.set branchFunc__7KinopioFUl, 0x8034DD50


.set branchFunc__15CaretakerHunterFUl, 0x80346940
.set eventFunc__15CaretakerHunterFUl, 0x803469C0

.set branchFunc__11KinopioBankFUl, 0x8034EBC0
.set eventFunc__11KinopioBankFUl, 0x8034ECF0

.set eventFunc__16LuigiIntrusivelyFUl, 0x80351710

.set branchFunc__6PichanFUl, 0x80359380
.set eventFunc__6PichanFUl, 0x803593F0

.set branchFunc__11PichanRacerFUl, 0x8035A270
.set eventFunc__11PichanRacerFUl, 0x8035A2E0

.set eventFunc__4TicoFUl, 0x80366740

.set isPowerStarColoured__2MRFv, 0x804D6B40

#Unknown symbols
.set sub_804E31A0, 0x804E31A0
.set sub_8048EE60, 0x8048EE60
.set sub_80030580, 0x80030580
.set sub_804D2200, 0x804D2200
.set sub_804A83A0, 0x804A83A0

.set sub_804E6820, 0x804E6820
.set sub_804D88F0, 0x804D88F0
.set sub_802C8910, 0x802C8910
.set sub_804D7EE0, 0x804D7EE0
.set sub_804D6B10, 0x804D6B10

.set sub_804E6190, 0x804E6190
.set sub_804E6680, 0x804E6680
.set sub_804E73B0, 0x804E73B0
.set sub_80057410, 0x80057410
.set sub_804AE470, 0x804AE470
.set sub_80452CD0, 0x80452CD0
.set sub_804AE5F0, 0x804AE5F0
.set sub_80458B80, 0x80458B80
.set sub_80452CC0, 0x80452CC0
.set sub_804AE540, 0x804AE540

.set sub_804F99E0, 0x804F99E0
.set sub_804D8210, 0x804D8210

.set sub_804D4730, 0x804D4730

.set sub_804B4490, 0x804B4490
.set sub_804D7DD0, 0x804D7DD0
.set sub_800682B0, 0x8001B020
.set sub_80068300, 0x80068300
.set sub_804D8510, 0x804D8510

.set sub_804D8690, 0x804D8690
.set sub_804C9170, 0x804C9170

.set sub_804E8200, 0x804E8200
.set sub_804E8FD0, 0x804E8FD0

.set sub_80089480, 0x80089480

.set sub_800896B0, 0x800896B0
.set sub_80089720, 0x80089720
.set sub_800895F0, 0x800895F0

.set sub_80085720, 0x80085720
.set sub_80023B00, 0x80023B00
.set sub_80265470, 0x80265470

.set sub_80486AA0, 0x80486AA0

.set sub_804D3F80, 0x804D3F80
.set sub_804EA3E0, 0x804EA3E0
.set sub_804EE0E0, 0x804EE0E0

.set sub_804D8360, 0x804D8360
.set sub_804F46C0, 0x804F46C0
.set sub_804F5550, 0x804F5550
.set sub_804FA1D0, 0x804FA1D0
.set sub_8001BB90, 0x8001BB90
.set sub_804C24E0, 0x804C24E0
.set sub_804C2510, 0x804C2510
.set sub_804C1AB0, 0x804C1AB0

.set sub_804D5CF0, 0x804D5CF0
.set sub_804D6D70, 0x804D6D70
.set sub_80058C70, 0x80058C70
.set sub_804B5530, 0x804B5530
.set sub_804D4100, 0x804D4100
.set sub_804B5860, 0x804B5860
.set sub_804D4210, 0x804D4210

.set sub_804F0370, 0x804F0370
.set sub_804F0F40, 0x804F0F40
.set sub_804F1140, 0x804F1140
.set sub_804F13E0, 0x804F13E0

.set sub_8008A430, 0x8008A430
.set sub_80452050, 0x80452050
.set sub_804BA470, 0x804BA470
.set sub_804BC260, 0x804BC260
.set sub_8045AA60, 0x8045AA60

.set sub_804EF8B0, 0x804EF8B0


.set sub_804F18A0, 0x804F18A0
.set sub_804F1ED0, 0x804F1ED0
.set sub_804F5D00, 0x804F5D00

.set sub_804DE190, 0x804DE190

.set sub_802C9700, 0x802C9700

.set sub_8045DB80, 0x8045DB80
.set sub_804D5DF0, 0x804D5DF0
.set sub_80495E20, 0x80495E20

.set sub_8045E9D0, 0x8045E9D0

.set sub_802DF490, 0x802DF490
.set sub_802DF430, 0x802DF430
.set PowerStar_LightStr_Loc, 0x806A860C

#-------------------------------------------------------

#these ones are for the ScenarioSelect's new DPD features
.set sub_8005E720, 0x8005E720
.set getDefaultButtonOffsetVec2__15StarPointerUtilFv, 0x8005E820
.set addStarPointerMovePosition__15StarPointerUtilFPCcPQ29JGeometry8TVec3<f>RCQ29JGeometry8TVec3<f>, 0x8005E830
.set addStarPointerMovePositionFromPane__15StarPointerUtilFP11LayoutActorPCcPQ29JGeometry8TVec2_f_, 0x8005E880
.set setDefaultAllMovePosition__15StarPointerUtilFPCc, 0x8005E9F0
.set sub_8005E940, 0x8005E940
.set sub_8005E790, 0x8005E790
.set setConnectionMovePositionRight2Way__15StarPointerUtilFPCcPCc, 0x8005EB60
.set setConnectionMovePositionDown2Way__15StarPointerUtilFPCcPCc, 0x8005EBB0
.set getPositionByName__29StarPointerMovePositionHolderFPCc, 0x8049B9B0
.set setStarPointerMovePosition__15StarPointerUtilFPCcPQ29JGeometry8TVec2_f_, 0x8005E8F0

#-------------------------------------------------------

.set exeNextPage__11AllStarListFv, 0x8045DDF0
.set exePreviousPage__11AllStarListFv, 0x8045DCA0
.set sInstance__Q214NrvAllStarList22AllStarListNrvPageNext, 0x807D53AC
.set sInstance__Q214NrvAllStarList26AllStarListNrvPageNextOver, 0x807D53B0
.set sInstance__Q214NrvAllStarList26AllStarListNrvPagePrevious, 0x807D53A4
.set sInstance__Q214NrvAllStarList30AllStarListNrvPagePreviousOver, 0x807D53A8
.set unk_807D53B4, 0x807D53B4

#-------------------------------------------------------

#BootOut.s
.set sub_804E53B0, 0x804E53B0
.set sub_804E5870, 0x804E5870
.set PowerStar_DataStart, 0x806A83B8
.set sub_802E0AD0, 0x802E0AD0
.set YoshiPowerStarGet, 0x806A8474
.set YoshiGrandStarGet, 0x806A8460
.set startStarPointerModeGame__17GameSceneFunctionFv, 0x80452DA0
.set setNerveAtStageStart__9GameSceneFv, 0x80451B20
.set sInstance__Q212NrvPowerStar27PowerStarNrvWaitStartAppear, 0x807D40E0
.set startStage__17GameSceneFunctionFv, 0x80452D70
.set startLastStageBGM__2MRFv, 0x8001B080
#-------------------------------------------------------

.set sub_804E8E30, 0x804E8E30


.set sub_8005A350, 0x8005A350


.set sub_8004F640, 0x8004F640

.set startGameDataSaveSequence__20GameSequenceFunctionFbbb, 0x804D5DA0

.set sub_801440F0, 0x801440F0
.set sub_804D7C40, 0x804D7C40
.set requestChangeStageDreamer__2MRFP7UNKNOWNl, 0x804D5AA0

#============================

.set unk_807D57D8, 0x807D57D8
.set unk_807D2AB4, 0x807D2AB4

.set BgmChangeArea_AreaMgr_Str, 0x8066A0C0

.set WaitStringJapanese, 0x807D98CC

#GlobalAnimeFunc
.set animeFunc__19MameMuimuiAttackManFUl, 0x80351F60


.set getSceneMessageDirect__2MRFPCcl, 0x80041410
.set sDisplayFramesMin__33_unnamed_InformationObserver_cpp_, 0x807D0228
.set InfoObserverCamera_StrJp, 0x806F4B24
.set createZoneMsgId__2MRFPCclPCcl, 0x800416D0

#Symbols that point to strings already in the dol
.set AnimName, 0x8067EC78
.set CometLimitTimer, 0x806FF320
.set PowerStarColor, 0x80699EEC
.set GrandStar_StringLoc, 0x806FC348
.set PowerStarType, 0x806FC338
.set BGM_SMG2_COURSESELECT02, 0x806F6F30
.set StageDataHolder, 0x806F1208
.set Param00Int, 0x8065CDD0
.set ScenarioNo, 0x8066BF30
.set GalaxyName, 0x8065E530
.set ZoneName, 0x806FC350
.set Player, 0x8065CB18
.set Head_BoneName, 0x806FFC60
#シーン初期化
.set SceneInitilization, 0x806EF940
#GLE replaces this with RestartArea
.set WorldMapSyncSoundEmitterCube, 0x806B3AE4
.set WorldMapSyncSoundEmitterCube_ManagerName, 0x8066A6EC
.set FileSelect, 0x806FFCB0
.set BestScoreString, 0x806FF534
.set MameMuimuiScorerLv2_ObjectName, 0x806B9F90
.set SoundIdName, 0x8066BE9C
.set Volume, 0x8066BEA8
.set Type, 0x8065D0C4
#"" (00)
.set NULLSTRING, 0x807D0478
#"" (00 00)
.set NULLWSTRING, 0x807D0180

#ワールドマップギャラクシー情報
.set GalaxySelectInfo_WorldMapGalaxyInformation, 0x806F9CA0
.set GalaxySelectInfo_GalaxyInfo, 0x806F9CC0
.set GalaxySelectInfo_GalaxyInfoTexture_arc, 0x806F9CCC
.set GalaxySelectInfo_GalaxyName, 0x806F9CE4
.set GalaxySelectInfo_StarIcon, 0x806F9CF0
.set GalaxySelectInfo_TxtMedal, 0x806F9CFC

.set MarioFaceAfterGrandStarTakeOffDemoObj, 0x806B7730
.set MarioFacePlanetTakeOffDemoObj, 0x806B7758

#For Meister.s
.set MeisterDataLoc, 0x806BA0C0
.set MeisterObjEntry, 0x80649CE0
.set MeisterZero, 0x807DF244

#ファイルセレクトからの開始
.set StartFromFileSelect, 0x806FA958
#ゲームオーバー後のデモ
.set DemoAfterGameOver, 0x806FA940

#顔惑星イベント番号
.set FaceShipEventNo, 0x806FF588

.set EndGlow, 0x806B0090

#カメラターゲットダミー
.set CameraTargetDummy, 0x806AE730

.set BombZoneGravityDisplayPanel_Ptr, 0x807DDC94
.set BombZoneGravityDisplayPanel, 0x806A5E70

.set MiniComet, 0x80700F4C

.set FileSelectInfo_Message, 0x806F3490

.set Game, 0x806EFA04

#For TypicalDoor.s
.set LavaRotateStepsRotatePartsA, 0x806B5BD0

.set MiniComet_NerveLoc, 0x807D5E60
.set MiniComet_Data, 0x80700F30

.set TicoCoin, 0x806B6E5C


#Symbols used to reference where string tables are placed
.set ScenarioSelectStringTable, 0x806F6C68
.set ScenarioEngineStringTable, 0x80702320

.set SceneChangeEngineStringTable, 0x807016C0

.set SystemDataTableHolder_Strings, 0x806FAD88

.set StationedFileInfo_Strings, 0x806FC4F0

.set HubworldState_Strings, 0x806FBA08


#We're movign this to a BCSV
.set MameMuimuiScorer_RemapList, 0x8068C040

#Other symbols...
.set STATIC_INIT_LIST, 0x80643D20
.set UnknownGameScene_Init_NameObj_Thingy, 0x806EF934
.set cBgmSettingInfo__13AudBgmSetting, 0x80645DA0

.set InGameActorState_NoStage, 0x807D5BD8
.set InGameActorState_PeachCastle, 0x807D5BC8

.set CircleWipe_StrJp, 0x806F90DC

#Keep these underscores and do not replace with <> 'cause it breaks the compiler
.set sInstance__29SingletonHolder_10GameSystem_, 0x807D0DA4
.set sInstance__Q212NrvGameScene15GameSceneAction, 0x807D5310
.set sInstance__Q226NrvInStageInGameActorState40InStageInGameActorStateNrvPlayerMissLeft, 0x807D5BE0
.set sInstance__43AudSingletonHolder_21AudSoundNameConverter_, 0x807D0D80
.set sInstance__Q214NrvAllStarList18AllStarListNrvInit, 0x807D5398
.set sInstance__Q226NrvMarioFaceShipEventState26HostTypeNrvWaitForOpenWipe, 0x807D5C18
.set sInstance__Q226NrvMarioFaceShipEventState25HostTypeNrvStartingEvents, 0x807D5C20
.set sInstance__Q226NrvMarioFaceShipEventState28HostTypeNrvStartGrandStarBgm, 0x807D5C00
.set sInstance__Q226NrvMarioFaceShipEventState25HostTypeNrvStarReturnDemo, 0x807D5C04
.set sInstance__Q226NrvMarioFaceShipEventState18HostTypeNrvDoEvent, 0x807D5C08
.set sInstance__Q226NrvMarioFaceShipEventState27HostTypeNrvSaveAndEndEvents, 0x807D5C1C
.set sInstance__Q226NrvMarioFaceShipEventState27HostTypeNrvWaitDemoComplete, 0x807D5C10
.set SaveDemoLoc, 0x807D03D0
.set BGMPrepareLoc, 0x807D03D4
.set EventStartWaitLoc, 0x807D03D8

.set AudioRes_Info_BgmParam_Arc_Ptr, 0x807CF4C8
.set BgmParam_bcsv_Ptr, 0x807CF4CC


.set sInstance__Q218NrvSuperSpinDriver32SuperSpinDriverNrvEmptyNonActive, 0x807D457C
.set sInstance__Q218NrvSuperSpinDriver22SuperSpinDriverNrvWait, 0x807D4590
.set sInstance__Q218NrvSuperSpinDriver24SuperSpinDriverNrvAppear, 0x807D458C

.set MiniCometWaitNerve, 0x807D5E60

.set sInstance__Q212NrvGameScene30GameSceneScenarioOpeningCamera, 0x807D5308


.set sInstance__Q223NrvScenarioSelectLayout33ScenarioSelectLayoutNrvAppearStar, 0x807D57B0
.set sInstance__Q223NrvScenarioSelectLayout29ScenarioSelectLayoutNrvAppear, 0x807D57B4
.set sInstance__Q223NrvScenarioSelectLayout41ScenarioSelectLayoutNrvWaitScenarioSelect, 0x807D57B8
.set sInstance__Q223NrvScenarioSelectLayout29ScenarioSelectLayoutNrvDecide, 0x807D57BC
.set sInstance__Q223NrvScenarioSelectLayout44ScenarioSelectLayoutNrvAfterScenarioSelected, 0x807D57C0


.set sInstance__Q223NrvScenarioSelectLayout41ScenarioSelectLayoutNrvAppearCometWarning, 0x807D57CC
.set sInstance__Q223NrvScenarioSelectLayout39ScenarioSelectLayoutNrvWaitCometWarning, 0x807D57D0
.set sInstance__Q223NrvScenarioSelectLayout44ScenarioSelectLayoutNrvDisappearCometWarning, 0x807D57D4

#Some old worldmap nerves
#being replaced with LoadIcon nerves
#Null
.set unk_807D5F18, 0x807D5F18
#Appear
.set unk_807D5F1C, 0x807D5F1C
#Wait
.set unk_807D5F20, 0x807D5F20
#Disappear
.set unk_807D5F24, 0x807D5F24


#BSS Addresses...Well ok it's mostly just flosts
#Scenario Select
.set FloatConversion, 0x8064CA28
.set FloatTable, 0x8064CB14

.set ScenarioSelectZero, 0x807E167C
.set StarPointerTargetRadius, 0x807E1694
.set StarTopShiftNum, 0x807E1698
.set SkyBgMatrixThing, 0x807E169C
.set ScreenPosZ, 0x807E16B0
.set EffectRate, 0x807E1684
.set EffectDirectionalSpeed, 0x807E16B4
.set ScenarioSelectOne, 0x807E1678
.set Unknown_15, 0x807E16B8
.set Unknown_9, 0x807E16B4
.set RaceTimeShift, 0x807E16A0

#===============


.set WipeCircleCenter, 0x807E19F0
.set WipeCircleNeg20, 0x807E19F4

.set VeryCloseToZero, 0x807D6F60

.set ScreenAlphaCapture_flt, 0x807E1228

#If you wanna change these floats, just patch these addresses
.set DashBgmTempo_flt, 0x807DC210
.set DashBgmTempoUp_flt, 0x807DC214
.set Boss04Tempo_flt, 0x807DC218


.set ScenarioStarter_0flt, 0x807D984C
.set ScenarioStarter_1flt, 0x807D9848

#End
.set EndString, 0x807D0280

#弱
.set Weak_JP_Str, 0x807D027C


#NPC global event function
.set branchFuncGameProgress__2MRFi, 0x8004A040
.set __vt__11TakeOutStar, 0x8065EBF8
.set takeOut__11TakeOutStarFv, 0x8004A220
.set getCurrentScore__2MRFv, 0x80376FD0
.set requestStageRestart__2MRFv, 0x804D6840

#Caretaker
.set CaretakerData, 0x806B7BD0

#Nerves
.set sInstance__Q212NrvCaretaker16CaretakerNrvWait, 0x807D482C
.set unk_807D4828, 0x807D4828
.set unk_807D4824, 0x807D4824
.set unk_807D4820, 0x807D4820

.set Caretaker_Str, 0x806B7C30
.set Caretaker_BodyColor_Str, 0x806B7C3C
.set Caretaker_Bspinhit_Str, 0x806B7C54
.set Caretaker_Bwaitstand_Str, 0x806B7C6C
.set Caretaker_Btrampled_Str, 0x806B7C48
.set Caretaker_Btalkhelp_Str, 0x806B7C60
.set Caretaker_Bruntalk_Str, 0x806B7C78
.set Caretaker_Bwaitrun_Str, 0x806B7C84
.set Caretaker_Dirt_Str, 0x806B7C90
.set Caretaker_Wait_Str, 0x806B7C98
.set Caretaker_TakeOutStarCaretakerFreeHand_Str, 0x806B7CA0
.set Caretaker_TakeOutStarCaretaker_Str, 0x806B7CC0
.set Caretaker_SpinHit_Str, 0x806B7CD8
.set Caretaker_TalkNormal_Str, 0x806B7CF8
.set Caretaker_WaitRun_Str, 0x806B7D08
.set Caretaker_Trampled_Str, 0x806B7CE0
.set Caretaker_TalkAngry_Str, 0x806B7CEC
.set Caretaker_GarbageManagement, 0x806B7D10

.set Caretaker_flt_0, 0x807DF044
.set Caretaker_flt_3, 0x807DF048
.set Caretaker_flt_2, 0x807DF04C
.set Caretaker_flt_0_1, 0x807DF050
.set Caretaker_flt_0_05, 0x807DF054
.set Caretaker_flt_350, 0x807DF058

.set CareTaker_BranchFuncComet, 0x806B7C00
.set CareTaker_EventFuncComet, 0x806B7C0C
.set CareTaker_BranchFuncStar, 0x806B7C18
.set CareTaker_AnimeFunc, 0x806B7C24

#StaffRollDemoObj stuff
.set unk_807D1E78, 0x807D1E78
.set sub_801452F0, 0x801452F0
.set sub_801452E0, 0x801452E0
.set sub_801452D0, 0x801452D0
.set sub_801452C0, 0x801452C0
.set sub_80145270, 0x80145270
.set isAtPageFlip__9StaffRollFv, 0x80492640
.set sub_80492C40, 0x80492C40
.set unk_807D585C, 0x807D585C
.set sub_80492CB0, 0x80492CB0
.set unk_807D5834, 0x807D5834
.set sub_80492BF0, 0x80492BF0
.set unk_807D5858, 0x807D5858

#TicoFat stuff
.set TicoFat_ObjName, 0x806B3D78
.set TicoFat_ObjEntry, 0x80649D80
.set sub_80368FA0, 0x80368FA0
.set sub_803691E0, 0x803691E0


.set sub_803D0B10, 0x803D0B10
.set sub_803CB130, 0x803CB130
.set sub_803DB350, 0x803DB350
.set convertPathToEntrynumConsideringLanguage__2MRFPCc, 0x80025460
.set sInstance__29SingletonHolder_10FileLoader_, 0x807D0D9C
.set mountAsyncArchive__2MRFPCcP7JKRHeap, 0x80025AF0

#New Chunking stuff
.set WorldmapDataStart, 0x80700960
.set WorldmapCodeStart, 0x804DFA24

.set GalaxyName_TextFormat, 0x8065E5A4


#Used by StageResultObj
.set unk_807D5E10, 0x807D5E10


.set sub_800614B0, 0x800614B0

#======= TicoFatStarPiece stuff =======
.set TicoFatStarPiece_Reaction, 0x806BE618
.set TicoFatStarPiece_Pointing, 0x806BE624
.set TicoFatStarPiece_Trampled, 0x806BE630
.set TicoFatStarPiece_Spin, 0x806BE63C
.set TicoFatCamera_Jp, 0x806BE648
.set TicoFatStarPiece_EventFunc, 0x806BE658
.set TicoFatStarPiece_Str, 0x806BE664
.set TicoFatStarPieceIntroDemo_Jp, 0x806BE678
.set TicoFatStarPiece_Demo_Str, 0x806BE698
.set TicoFat_Request000, 0x806BE6A0
.set TicoFat_StarPiece000, 0x806BE6B4
.set TicoFatStarPiece_Wait, 0x806BE6CC
.set TicoFatStarPiece_Talk, 0x806BE6D4
.set TicoFatGoodsStarPiece, 0x806BE6DC
.set TicoFatStarPiece_Small0, 0x806BE6F4
.set TicoFatStarPiece_Normal, 0x806BE6FC
.set TicoFatStarPiece_TransformJp, 0x806BE9C8

.set TicoFatStarPiece_FunctorPtr, 0x806BE868

.set TicoFatStarPieceNrvReaction, 0x807D4C50
.set TicoFatStarPieceNrvPrep, 0x807D4C54
.set TicoFatStarPieceNrvWait, 0x807D4C58
.set TicoFatStarPieceNrvPoint, 0x807D4C5C
.set TicoFatStarPieceNrvEat, 0x807D4C60
.set TicoFatStarPieceNrvChem, 0x807D4C64
.set TicoFatStarPieceNrvTransform, 0x807D4C68

.set TicoFatStarPiece_0f, 0x807DF5D4
.set TicoFatStarPiece_220f, 0x807DF5E4
.set TicoFatStarPiece_280f, 0x807DF5E8
.set TicoFatStarPiece_012, 0x807DF618
.set TicoFatStarPiece_089999998, 0x807DF618
.set TicoFatStarPiece_1000, 0x807DF620
.set TicoFatStarPiece_100, 0x807DF624
.set TicoFatStarPiece__1, 0x807DF5DC

.set TicoFatCoin_500, 0x807DF5CC

.set TicoFatCamera_Ptr, 0x807CFF50
.set TicoFat_Fly_Str, 0x807CFF48

.set getActionName__16TicoFatStarPieceFPCc, 0x80369A10
.set sub_8036AA20, 0x8036AA20
.set sub_8036AA90, 0x8036AA90
.set depleteStarPiece__16TicoFatStarPieceFv, 0x8036A4B0
.set sub_8036B860, 0x8036B860
.set sub_8036AF90, 0x8036AF90
.set sub_8036A380, 0x8036A380

.set TicoFatCoin_DataStart, 0x806BE390
.set TicoFatCoin_FlightJp, 0x806BE410
.set TicoFatCoin_VolDownBgm, 0x806BE43C
.set DmTicofatMorphWipeOut, 0x806BE448
.set ScreenEffect, 0x806BE460
.set ScreenEffectLight, 0x806BE470
.set ScreenEffectFog, 0x806BE488
.set DmTicofatMorphWipeIn, 0x806BE498
.set PlanetaryAppearance_Jp, 0x806BE428

.set AlternateBlendQuatFrontUp, 0x8003CFD0
.set sub_80368F30, 0x80368F30
.set getDanceSeTranspose__16TicoFatStarPieceCFv, 0x8036AC40
.set isEventCameraActive__2MRFPCc, 0x8001D600
.set endGlobalEventCamera__2MRFPCclb, 0x8001D5B0


.set AddMailStarPiece, 0x806B99AC
.set getMarioStartHealth__2MRFv, 0x804D7130
.set sInstance__Q210NrvRosetta14RosettaNrvWait, 0x807D4AC0
.set GhostAttackGhostManager_JpName, 0x806B8BD8
.set MBGM_MINI_GAME, 0x8065D3CC
.set hasMissedInScene__2MRFv, 0x804D7060
.set DreamerDeadCountArea_ManagerName, 0x8065D738
.set sub_804D31E0, 0x804D31E0
.set sub_80492970, 0x80492970
.set sub_80492B20, 0x80492B20
.set sub_804B4C90, 0x804B4C90
.set sub_8013A180, 0x8013A180
.set hasFaceShipEvent__2MRFv, 0x804D8320





.GLE REGION END