#  The Binding of Isaac: Afterbirth+ - Breakable Chests mod

This is a mod for The Binding of Isaac: Afterbirth+ to allow spiked/mimic chests to be broken by shooting them similar to how poop/fireplaces can be destroyed.

## Special thanks
* Reddit user [Fire8TheBlade](https://www.reddit.com/user/Fire8TheBlade) for inspiring the idea with [this thread](https://www.reddit.com/r/bindingofisaac/comments/8a3p98/possible_mimic_change_they_are_spiked_for_the/). Without your idea this mod probably wouldn't exist
* Reddit user [NAT0P0TAT0](https://www.reddit.com/user/NAT0P0TAT0) for giving me some suggestions on how to make this work - although your suggestions didn't help (as apparently the Lua API ignores all reasonable logic), you were the only one who took the time to answer my request for help so thank you!

## Debugging notes
This mod can be run directly from the repository (without needing to copy to the mods folder) by creating a symlink in the mods directory linking to the `BreakableChests` folder in the repo. It's similar to a shortcut, but it looks like a folder to the game (windows shows the type as `File Folder` instead of `Shortcut` so the game can read from it). Symlinks can be created in Windows 10 from the command line with the command `mklink /D Link Target` where `Link` is the isaac mods directory + mod folder name and `Target` is the folder it points to eg. `"mklink /D "C:\Users\Kirlac\Documents\My Games\Binding of Isaac Afterbirth+ Mods\BreakableChests" "C:\Users\Kirlac\Documents\repos\tboi_breakable-chests_mod\tboi_breakable-chests_mod\BreakableChests"`

## Changelog
### Update #1 - 2018-04-10
Proof of concept works. I had to implement my own rudimentary collision detection to get tears to collide with pickups as it looked like there was nothing in place for this within the Lua API. On tear update we check the distance to any chests, if the distance is less than a certain amount the tear is killed, and the chest takes some damage. If the chest takes enough damage it is killed, and a poop spawns in its place.

#### Notes
* This has only been implemented for spiked chests so far
* Chest can still be opened normally
* It's far from perfect, but is a good point to build on to make this the mod I can see it being

#### Todos
* Tweak and cleanup the code now that I know what I want is possible
    * Investigate `Isaag.FindInRadius` function as we don't need all room entities and this could help keep things a bit lighter - we can just check for chests close to the tear and reduce the amount of work the collision detection has to do
    * Make sure this works with brimstone/lasers/mom's knife/ipecac/etc
* Feedback on hit
    * Chest should look like it takes damage
        * Damage flash?
        * Sprite overlay showing damage taken
    * Chest should encounter some push back from being hit?
* Customizable config?
    * Specify which chest types can be broken
    * Specify what happens when a chest breaks
        * Nothing
        * Normal chest drops
        * Spawns a poop