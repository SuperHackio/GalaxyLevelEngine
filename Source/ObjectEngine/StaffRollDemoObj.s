#Replaces the vanilla staff roll with a new one
#one that isn't hardcoded...


.GLE ADDRESS sub_801440F0





.GLE ASSERT __sinit_\StaffRollDemoObj_cpp
.GLE ENDADDRESS

.GLE ADDRESS .SCENARIO_SWITCH_CONNECTOR

.STAFFROLL_CONNECTOR:
.GLE ENDADDRESS