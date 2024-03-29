extends RigidBody2D

# Three different colors
var color_mob_types = ["Red", "Green", "Blue"]
# Color of current mob
var color_of_mob

signal addScore

export var min_speed = 150  # Minimum speed range.
export var max_speed = 250  # Maximum speed range.

# Called when the node enters the scene tree for the first time.
# Identifies color of mob
func _ready():
	color_of_mob = color_mob_types[randi() % color_mob_types.size()]
	$AnimatedSprite.animation = color_of_mob
	# Enable the collision of the appropriate mob
	if color_of_mob == "Red":
		$CollisionRed.disabled = false
		set_collision_layer_bit(2, true)
	elif color_of_mob == "Green":
		$CollisionGreen.disabled = false
		set_collision_layer_bit(3, true)
	elif color_of_mob == "Blue":
		$CollisionBlue.disabled = false
		set_collision_layer_bit(4, true)

# When the mob goes offscreen
func _on_Visibility_screen_exited():
	emit_signal("addScore")
	queue_free()

# When game is over
func _on_gameOver():
	queue_free()
