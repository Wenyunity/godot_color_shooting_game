extends PathFollow2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var SPEED = 300

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


func _on_Player_offsetDown():
	moveBackward = true


func _on_Player_offsetUp():
	moveForward = true


func _on_HUD_start_game():
	offset = 0
	moveForward = false
	moveBackward = false


func _on_Player_offsetDownOff():
	moveBackward = false


func _on_Player_offsetUpOff():
	moveForward = false
