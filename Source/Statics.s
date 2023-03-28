#This is a replacement static. effectively nopping out existing statics

#sub_804E0420
.GLE ADDRESS WorldmapCodeStart
.__DEAD_STATIC:  #Comment! This is likely what breaks the old GLE Build Tool versions lol
blr
.GLE ENDADDRESS

.GLE ADDRESS STATIC_INIT_LIST +0x9C4
#Take out Lubbas original static init
.int .__DEAD_STATIC
.GLE ENDADDRESS

#I have no idea what I just replaced but it's related to the world map so I don't care!
#The following lines redirect useless statics to the above function.

.GLE ADDRESS STATIC_INIT_LIST +0xD24
.int .LoadIcon_StaticInit
.int .StageResultObj_STATIC_INIT
.int .MiniComet_sInit
.int .InfoDisplayObj_STATIC_INIT
.int .__DEAD_STATIC
.int .__DEAD_STATIC
.int .__DEAD_STATIC
.int .__DEAD_STATIC
.int .__DEAD_STATIC
.int .__DEAD_STATIC
.int .__DEAD_STATIC
.int .__DEAD_STATIC
.int .__DEAD_STATIC
.int .__DEAD_STATIC
.int .__DEAD_STATIC
.int .__DEAD_STATIC
.int .__DEAD_STATIC
.int .__DEAD_STATIC
.int .__DEAD_STATIC
.int .__DEAD_STATIC
.int .__DEAD_STATIC
.int .__DEAD_STATIC
.int .__DEAD_STATIC
.int .__DEAD_STATIC
.int .__DEAD_STATIC
.int .__DEAD_STATIC
.int .__DEAD_STATIC
.int .__DEAD_STATIC
.int .__DEAD_STATIC
.int .__DEAD_STATIC
.int .__DEAD_STATIC
.int .__DEAD_STATIC
.int .__DEAD_STATIC
.int .__DEAD_STATIC
.int .__DEAD_STATIC
.int .__DEAD_STATIC
.int .__DEAD_STATIC
.int .__DEAD_STATIC
.int .__DEAD_STATIC
.int .__DEAD_STATIC
.int .__DEAD_STATIC
.int .__DEAD_STATIC
.int .__DEAD_STATIC
.GLE PRINTADDRESS
.GLE ENDADDRESS