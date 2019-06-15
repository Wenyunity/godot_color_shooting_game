# godot_color_shooting_game

This game is a basic shooter. The player can only move up and down along the grey shape and can rotate.
Enemies are assigned one of three colors and can only be pushed by a bullet matching that color.

If an enemy goes offscreen, one point is awarded to the player.

Holding down multiple fire buttons increases the delay such that the total number of bullets fired is constant. (10 bullets per second.)

# Controls

Up/Down: Moves forward and backward along the path respectively.

Left/Right: Rotates CCW/CW respectively.

Z/X/C: Hold down to fire Red, Green, and Blue bullets respectively.

# To Be Added

- Enemies that have multiple colors.
- Multiple levels with different paths.
- Life system for the player.

# Updates

- Player now moves along a Path2D. (Unfortunately, this causes a dependency in that the player must be a child of a PathFollow2D.)
- Scoring has changed so that each enemy that leaves awards a point. (Enemies leaving the screen after the game is over still count)
- Controls are now on auto-fire. There is a delay system such that holding down all three buttons is not 100% optimal.
