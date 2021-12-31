# AllStarList
The AllStarList is a feature that lets players track how many stars they have. This has been overhauled in the GLE.

Inside `/ObjectData/SystemData.arc`, is a BCSV under the name `GalaxyOrderList.bcsv`. This is the BCSV that controls how this list works.

Each entry represents 1 galaxy.

#### PageNumber
The page this entry will be used on.

#### GalaxyName
The name of the galaxy this entry refers to

#### GalaxyPane
This is the layout pane that will display the name of the galaxy as read from the `GalaxyNameShort.msbt` file inside `SystemMessage.arc`. The GLE comes with a layout for you to use, and the panes are named as follows: (in order from top entry in the AllStarList to bottom entry)
- Galaxy1
- Galaxy2
- Galaxy3
- Galaxy4
- Galaxy5
- Galaxy6
- Galaxy7

This allows you to place galaxies in any of the 7 slots. If you were to make your own layout, you could refer to your own custom pane names here instead. (\*Creating a layout from scratch not recommended)

#### StarPane
Same situation as GalaxyPane, but instead of referring to the Galaxy Name, it refers to the list of stars that gets created. The GLE comes with a layout for you to use, and the panes are named as follows: (in order from top entry in the AllStarList to bottom entry)
- Star1
- Star2
- Star3
- Star4
- Star5
- Star6
- Star7

This allows you to place the stars in any of the 7 slots, though you should line it up with the correct GalaxyPane or else players will get confused. If you were to make your own layout, you could also refer to your own custom pane names here instead. (\*Creating a layout from scratch not recommended)

#### CompletePane
Same situation as GalaxyPane, but instead of referring to the Galaxy Name, it refers to the Crown icon that indicates the galaxy's completion status. The GLE comes with a layout for you to use, and the panes are named as follows: (in order from top entry in the AllStarList to bottom entry)
- Comp1
- Comp2
- Comp3
- Comp4
- Comp5
- Comp6
- Comp7

This allows you to place the crowns in any of the 7 slots, though you should line it up with the correct GalaxyPane or else players will get confused. If you were to make your own layout, you could also refer to your own custom pane names here instead. (\*Creating a layout from scratch not recommended)

#### MedalPane
Same situation as GalaxyPane, but instead of referring to the Galaxy Name, it refers to the Comet medal icon. The GLE comes with a layout for you to use, and the panes are named as follows: (in order from top entry in the AllStarList to bottom entry)
- Medal1
- Medal2
- Medal3
- Medal4
- Medal5
- Medal6
- Medal7

This allows you to place the Comet Medal in any of the 7 slots, though you should line it up with the correct GalaxyPane or else players will get confused. If you were to make your own layout, you could also refer to your own custom pane names here instead. (\*Creating a layout from scratch not recommended)
> *Note: This is the only field that you can leave blank. Leave this field blank if your level has no comet medal, and it also will not show the Empty Comet Medal icon.*

#### PowerStarNum
This field lets you hide galaxies on the AllStarList until you reach a certain amount of stars. This field is ignored if you have any star from the displayed galaxy.<br/>
There are two special cases built in:
- Always show this galaxy, set the field to **0**
- Never show this galaxy until you have a star from it, set the field to **-1**

>*Note: Slots that don't have a galaxy will have no text whatsoever in it. Slots that have a galaxy that has a PowerStarNum of -1, will display `----`. This lets players know that there is a hidden galaxy for them to find.*

## Changing the amount of pages
GLE-V1:<br/>
These are the memory patches that you'll want to change. Replace the `XX` with the number of pages you want (in hexadecimal)
```xml
<memory offset="0x8045DBBC" value="386000XX" />
<memory offset="0x8045DC1C" value="386000XX" />
```

> *Note: Be sure to remove/replace the original GLE memory patches of the same addresses!*


**This system will be changed in GLE-V2, so you won't have to edit a memory patch**