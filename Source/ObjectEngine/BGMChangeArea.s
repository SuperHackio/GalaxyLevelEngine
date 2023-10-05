#All this does is unhardcode the TwisterTowerGalaxy reference, allowing the use of SW_B to perma-disable the area
.GLE ADDRESS movement__13BgmChangeAreaFv +0xB8
li r3, 1
.GLE ENDADDRESS