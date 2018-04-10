#  The Binding of Isaac: Afterbirth+ - Breakable Chests mod

This is a mod for The Binding of Isaac: Afterbirth+ to allow spiked/mimic chests to be broken by shooting them similar to how poop/fireplaces can be destroyed.

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