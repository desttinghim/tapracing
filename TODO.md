#TODO
-----

* [ ] MVP
    - [x] Input
        + ~~[ ] Send event with each input, that way remapping will be trivial~~
        + [x] ~~Keyboard~~ Remappable keys for desktop
        + [x] Touch for mobile, does not need to change
        + ~~[ ] Buttons for menu on desktop/mobile~~
        + [x] Separate input/action, for easy input changing
    - [x] Character entities
    - [x] Separate main and racing specific code
    - [ ] Split Screen Camera
        + [x] Actual camera code      
        + [?] Input changes (I'm going to need to do actual android testing)
    - [x] Physics
        + [x] Nape, apply impulse when character tapped
	- [ ] Single Player Mode
	    + [x] Player sprite
	    + [x] Goal sprite
	        * [x] Sensor (non-nape) component
        + [x] High scores (mostly)
    - ~~[ ] Gameplay
		+ [x] Goal, ends level (But level ending produces crash.)
            * [x] Signal win (Only the right side can win?)
            * [x] Make goal not collide 
            * [x] Make goal sprite (got a sensor component made)
            * [x] Forget nape sensor, just use sprite
        + [ ] Interesting race tracks
            * [ ] Waypoint defined tracks
            * [ ] Walls to tracks
        ~~+ [ ] Items
            * [ ] Speed Boost: Each tap applies a greater impulse
            * [ ] Auto Tap: Impulse is applied every x milliseconds automatically
            * [ ] Distract: Blocks other players view of the screen~~
* [ ] Alpha
    - [ ] Levels
    - [ ] Menu
        + [ ] Level select
        + [ ] High score
        + [ ] Title
        + [ ] About
* Beta
* Completely Done