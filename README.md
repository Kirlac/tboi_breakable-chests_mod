#  The Breaking of Chests

This is a mod for The Binding of Isaac: Afterbirth+ to allow spiked/mimic chests to be broken by shooting them similar to how poop/fireplaces can be destroyed.

## Special thanks
* Reddit user [Fire8TheBlade](https://www.reddit.com/user/Fire8TheBlade) for inspiring the idea with [this thread](https://www.reddit.com/r/bindingofisaac/comments/8a3p98/possible_mimic_change_they_are_spiked_for_the/). Without your idea this mod probably wouldn't exist
* Reddit user [NAT0P0TAT0](https://www.reddit.com/user/NAT0P0TAT0) for giving me some suggestions on how to make this work - although your suggestions didn't help (as apparently the Lua API ignores all reasonable logic), you were the only one who took the time to answer my request for help so thank you!
* [Lytebringr](https://www.youtube.com/user/Lytebringr) on youtube. Thanks to skipping through your tutorial series I was able glean a lot of useful information without having to spend the time and effort digging through the poor documentation and debugging to figure out how everything works

## Debugging notes
This mod can be run directly from the repository (without needing to copy to the mods folder) by creating a symlink in the mods directory linking to the `BreakableChests` folder in the repo. It's similar to a shortcut, but it looks like a folder to the game (windows shows the type as `File Folder` instead of `Shortcut` so the game can read from it). Symlinks can be created in Windows 10 from the command line with the command `mklink /D Link Target` where `Link` is the isaac mods directory + mod folder name and `Target` is the folder it points to eg. `"mklink /D "C:\Users\Kirlac\Documents\My Games\Binding of Isaac Afterbirth+ Mods\BreakableChests" "C:\Users\Kirlac\Documents\repos\tboi_breakable-chests_mod\tboi_breakable-chests_mod\BreakableChests"`

## Changelog
### Update #4 - 2018-4-19
* Lasers now have knockback. They don't have a velocity so I had to calcualte the difference between two samples to determine this
* Added animations
    * Animates sad when a breakble chest spawns - will probably remove this as they aren't all sad if you configure non-damaging chests to break as well
    * Animates happy on chest break
        * Maybe change this depending on what the break action is, happy for open, sad for poop/nothing

### Update #3 - 2018-04-16
### Made lasers work
* Lasers now collide. That took far too long to figure out. The `EntityLaser` doesn't have any usable position data for determining collions, but it does have `GetSamples()` & `GetNonOptimizedSamples()` functions which return an undocumented `HomingLaser::SampleList` which when inspected is simply a `userdata` type (thanks lua). Thankfully after a little digging around online I was able to iterate over the metadata for this with `for x,y in pairs(metatable(samples))` which informed me what was available to me from the undocumented `SampleList`. After many crashes an debug attempts I was able to figure out that `GetNonOptimizedSamples()` gives me a (sort of) list of `Vector` with each sample point in the laser (I think. More testing is needed but I have debugging fatigue so I'm stopping here). `SampleList:__len()` gives me a count of samples, which allowed me to use a for loop to call `SamplesList:Get(i)` to get each `Vector` in the list. From there I was able to pass this into my `CheckCollision` function in the same way as I would a standard tear position and determine if it hits. If it does, `CheckCollision` will return `true` so I can drop out of the for loop to prevent multiple samples triggering a hit in the same frame.
* As I mentioned above, more testing is needed and I had to turn off knockback temporarily as I was basing this off velocity of the tear and I don't think that was available on the laser

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
    * Improve interactions with tears to allow bouncing/spectral etc to work as they should
        * Worst case we can check the flags and take special action for different ones
* Verify seeded randomness works
    * Also weight the randomness for balance? eg. have a high chance for nothing and low chance for chest to break open

