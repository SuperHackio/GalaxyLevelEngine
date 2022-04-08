#.GLE IGNORE

#Uncomment the above line to exclude this code from the build.

#The crash debugger. You should already know what this is
.GLE ADDRESS handleException__19GameSystemExceptionFUsP9OSContextUlUl +0x40
nop
.GLE ENDADDRESS

.GLE ADDRESS handleException__19GameSystemExceptionFUsP9OSContextUlUl +0x104
nop
.GLE ENDADDRESS

.GLE ADDRESS __OSUnhandledException +0x54
nop
.GLE ENDADDRESS

#This last one is a GLE Exclusive and isn't part of any other debug code.
#It prevents OSPanic from getting stuck inside PPCHalt, causing the
#Crash Debug Screen to show up in more case scenarios.
#Most notably, when you run out of alloted memory.
.GLE ADDRESS OSPanic +0x108
nop
.GLE ENDADDRESS