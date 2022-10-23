#This is a modification to MapObjActorUtil::setupInitInfoTypical((MapObjActorInitInfo *,char const *))
#That lets us use MapObjActorInitInfo::setupProjmapMtx((bool,bool)) on any object
#with "ProjMap" in the name.

.GLE ADDRESS .NPC_Utility_End
.CheckForProjMapObj:
li r5, 1
bl isExistString__2MRFPCcPCPCcUl
b .CheckForProjMapObj_Return
.GLE ENDADDRESS


.GLE ADDRESS setupInitInfoTypical__15MapObjActorUtilFP19MapObjActorInitInfoPCc +0x4C
mr        r3, r30
addi r4, r2, BombZoneGravityDisplayPanel_Ptr - STATIC_R2
b .CheckForProjMapObj
.CheckForProjMapObj_Return:
#Here is a cmpwi r3, 0
.GLE ENDADDRESS


.GLE ADDRESS BombZoneGravityDisplayPanel
#Replace the string
ProjMapString:
    .string "Projmap" AUTO
.GLE ENDADDRESS