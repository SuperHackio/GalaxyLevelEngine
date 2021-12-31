# Power Stars
Power Stars in the Galaxy Level Engine have some changes made to them. Namely, regarding colours.

In order to use Power Star Colours, you'll need to add a field to your ScenarioData.bcsv file. The field's name is `PowerStarColor`, and is of type `int32`, or `0x00`.

> *Note: The game will not crash if you do not add this field. The powerstars in the level will simply all be the default colour - Yellow*

If you have not made your scenario file yet, you can download [This file](LINK) that already has the field added for you.

The value that goes into this additional field, is simply a number which indicates a frame in `PowerStarColor.btp`. In the normal SMG2, the values are:
- 0 = Yellow
- 1 = Bronze
- 2 = Green
- 3 = Red

While it is possible to add new colours, you would have to edit the ASM patches. **This will be changed in GLE-V2**