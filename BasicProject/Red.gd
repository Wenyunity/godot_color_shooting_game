extends RigidBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# When Leaving Screen Die
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

# When colliding die
func _on_Red_body_entered(body):
	queue_free()

# Clean up on game restart
func _on_start_game():
	queue_free()


