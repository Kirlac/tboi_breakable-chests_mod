#  The Binding of Isaac: Afterbirth+ - Breakable Chests mod

This is a mod for The Binding of Isaac: Afterbirth+ to allow spiked/mimic chests to be broken by shooting them similar to how poop/fireplaces can be destroyed.

## Special thanks
* Reddit user [Fire8TheBlade](https://www.reddit.com/user/Fire8TheBlade) for inspiring the idea with [this thread](https://www.reddit.com/r/bindingofisaac/comments/8a3p98/possible_mimic_change_they_are_spiked_for_the/). Without your idea this mod probably wouldn't exist
* Reddit user [NAT0P0TAT0](https://www.reddit.com/user/NAT0P0TAT0) for giving me some suggestions on how to make this work - although your suggestions didn't help (as apparently the Lua API ignores all reasonable logic), you were the only one who took the time to answer my request for help so thank you!

## Debugging notes
This mod can be run directly from the repository (without needing to copy to the mods folder) by creating a symlink in the mods directory linking to the `BreakableChests` folder in the repo. It's similar to a shortcut, but it looks like a folder to the game (windows shows the type as `File Folder` instead of `Shortcut` so the game can read from it). Symlinks can be created in Windows 10 from the command line with the command `mklink /D Link Target` where `Link` is the isaac mods directory + mod folder name and `Target` is the folder it points to eg. `"mklink /D "C:\Users\Kirlac\Documents\My Games\Binding of Isaac Afterbirth+ Mods\BreakableChests" "C:\Users\Kirlac\Documents\repos\tboi_breakable-chests_mod\tboi_breakable-chests_mod\BreakableChests"`

## Changelog
### Update #2 - 2018-04-11
#### Fleshed out the functionality a bit more and made this feel more complete
* Chests now show they are taking damage by flashing red (like enemies do) and get knockback
* Chest types are no longer hardcoded and are pulled from a list. List is configured for spiked and mimic chests, but any chest SHOULD work (untested)
* Chest breaking now has multiple configurable actions (do nothin, spawn poop, open, random) which all seem to function correctly.
    * Random SHOULD be seeded (still needs to be confirmed)
* Chest damage does not work with lasers, but does work with mom's knife, ipecac, compound fracture, chocolate milk, etc. 
    * Tech x works for the inner point, but not on the outer laser ring
    * Some of these interactions need to be tweaked a little as we are straight up killing the tear on contact but it should probably be handled better (research needed into how this normally works) so it can pass through if appropriate (eg for ouija board, polyphemus etc.) or bounce off (eg for rubber cement)
* Also now I should longer be making commits from my work account!

### Update #1 - 2018-04-10
#### Proof of concept works
* I had to implement my own rudimentary collision detection to get tears to collide with pickups as it looked like there was nothing in place for this within the Lua API
* On tear update we check the distance to any chests, if the distance is less than a certain amount the tear is killed, and the chest takes some damage. If the chest takes enough damage it is killed, and a poop spawns in its place

### Notes
* Chests can still be opened normally
* It's far from perfect, but is a good point to build on to make this the mod I can see it being

## Todos
* Collision detection improvements
    * Investigate better functions for finding the chests as we don't need all room entities and this could help keep things a bit lighter
    * Make this work with brimstone/lasers
    * Improve interactions with tears to allow bouncing/spectral etc to work as they should
* Better knockback based on stats rather than a hardcoded number
* Verify seeded randomness works
    * Also weight the randomness for balance? eg. have a high chance for nothing and low chance for chest to break open
* Sound effects?

