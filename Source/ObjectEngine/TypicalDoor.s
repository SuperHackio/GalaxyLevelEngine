#A somewhat last minute addition
#This class is already in the game, and it would be better to have this in the
#ProductMapObjDataTable, but the GLE doesn't have one of it's own

#Thankfully, this class is actually still in SMG2, thanks to Nintendo reusing DarknessRoomDoorA
#I'm just adding the Ghostly Galaxy doors in here replacing some objects that can just be
#put onto the vanilla ProductMapObjDataTable.

#TypicalDoorOpen is a variation that was also left in SMG2.
#Both classes are missing NameObjFactory creators, so they have been copied into this file.

.GLE ADDRESS LavaRotateStepsRotatePartsA
TeresaMansionDoorA:
    .string "TeresaMansionDoorA"
    
TeresaMansionDoorB:
    .string "TeresaMansionDoorB"
    
TeresaMansionEntranceDoor:
    .string "TeresaMansionEntranceDoor" AUTO
    
.GLE ENDADDRESS

#Add them to the internal object table
.GLE ADDRESS cCreateTable__14NameObjFactory +0x12F8
.int TeresaMansionDoorA
.int .TypicalDoorCreate

.int TeresaMansionDoorB
.int .TypicalDoorCreate

.int TeresaMansionEntranceDoor
.int .TypicalDoorOpenCreate

.GLE ENDADDRESS



.GLE ADDRESS sub_802C8910
blr
#Pretty much just copy-paste from SMG1 lol

#TypicalDoor
.TypicalDoorCreate:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0xC(r1)
mr        r31, r3
li        r3, 0xDC
bl        __nw__FUl
cmpwi     r3, 0
beq       loc_80268E80
mr        r4, r31
bl        __ct__11TypicalDoorFPCc

loc_80268E80:
lwz       r0, 0x14(r1)
lwz       r31, 0xC(r1)
mtlr      r0
addi      r1, r1, 0x10
blr

.TypicalDoorOpenCreate:
stwu      r1, -0x10(r1)
mflr      r0
stw       r0, 0x14(r1)
stw       r31, 0x0C(r1)
stw       r30, 0x08(r1)
mr        r30, r3
li        r3, 0xDC
bl        __nw__FUl
cmpwi     r3, 0
mr        r31, r3
beq       loc_80268ED4
mr        r4, r30
bl        __ct__11TypicalDoorFPCc
lis       r3, __vt__15TypicalDoorOpen@ha
addi      r3, r3, __vt__15TypicalDoorOpen@l
stw       r3, 0(r31)

loc_80268ED4:
mr        r3, r31
lwz       r31, 0x0C(r1)
lwz       r30, 0x08(r1)
lwz       r0, 0x14(r1)
mtlr      r0
addi      r1, r1, 0x10
blr

.GLE ASSERT sub_802C9700
.GLE ENDADDRESS