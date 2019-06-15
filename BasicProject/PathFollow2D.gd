extends PathFollow2D

# Speed at which the player moves (pixels/sec?)
var SPEED = 300

# Determines whether player moves forward or backward along path
var moveForward
var moveBackward

# Called when the node enters the scene tree for the first time.
func _ready():
	moveForward = false
	moveBackward = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if moveForward:
		offset += SPEED * delta
	if moveBackward:
		offset -= SPEED * delta
	# Make sure we don't go off
	unit_offset = clamp(unit_offset, 0, 1)

# Down pressed
func _on_Player_offsetDown():
	moveBackward = true

# Up pressed
func _on_Player_offsetUp():
	moveForward = true

# Reset values when game starts
func _on_HUD_start_game():
	offset = 0
	moveForward = false
	moveBackward = false

# Down released
func _on_Player_offsetDownOff():
	moveBackward = false

# Up released
func _on_Player_offsetUpOff():
	moveForward = false
