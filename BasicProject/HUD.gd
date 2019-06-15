extends CanvasLayer

# When start game is pressed
signal start_game

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Shows message
func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()

# Shows game over message
func show_game_over():
	show_message("Game Over")
	yield($MessageTimer, "timeout")
	$MessageLabel.text = "Test Game!"
	$MessageLabel.show()
	yield(get_tree().create_timer(1), 'timeout')
	$StartButton.show()

# Updates score
func update_score(score):
	$ScoreLabel.text = str(score)

# Updates lives
func update_lives(lives):
	$LifeLabel.text = str(lives)

# When the start button is pressed
# Starts game
func _on_StartButton_pressed():
	emit_signal("start_game")
	$StartButton.hide()


# When the message timer runs out does something
func _on_MessageTimer_timeout():
	$MessageLabel.hide()