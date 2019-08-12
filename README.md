# Harvest.lua-OpenComputers-
This is a crop harvesting program for the mod OpenComputers in the game Minecraft.

You can directly download the program to a robot in game if you have an internet card installed. Simply use the command ``pastebin get qBEFYGrq harvest.lua``.

The usage of the program is as follows:

``harvest [x] [y] [wait time in seconds between harvests]``

Example:
```harvest 5 5 500
                            y ^                          
[C] [C] [C] [C] [C]           |
[C] [C] [C] [C] [C]           |
[C] [C] [C] [C] [C]    ->     |
[C] [C] [C] [C] [C]           |
[C] [C] [C] [C] [C]            ---------------->
[R]                                            x

C = Crop, R = Robot
```
This would harvest a 5 by 5 block area in front of the robot every 500 seconds. The robot needs to be 1 block off the ground (directly above the crops) and should be placed in the block right in front of the lower right corner of the crop field.

Note: the robot will attempt to find the first item that is in its inventory that is placeable on the ground and plant it, thus, it will not perform well on crop fields that have different types of crops. One robot should be used for each crop to achieve the desired effect.

Once the robot has collected all the materials it will drop them below its starting point. If there is a chest below it will empty its contents into that.
