extends Node

export (PackedScene) var ColorMob

# Score player has
var score

# Lives player has
var lives

# Signal when game is over
signal gameOver

# Time between mob spawns is multiplied by this number
const MOB_TIME_FACTOR = 0.999

# Minimum time between mob spawns
const MIN_TIME_BETWEEN_SPAWN = 0.1

# Called when the node enters the scene tree for the first time.
func _ready():
	## Randomizes RNG seed
	randomize()

## Game Over
func game_over():
	emit_signal("gameOver")
	$MobTimer.stop()
	$HUD.show_game_over()

## New Game
func new_game():
	## Default score and lives
	score = 0
	lives = 3
	$HUD.update_score(score)
	$HUD.update_lives(lives)
	## Default HUD and player
	$HUD.show_message("Get Ready")
	$Path2D/PathFollow2D/Player.start()
	$StartTimer.start()

## Starts the game
func _on_StartTimer_timeout():
	$MobTimer.wait_time = 1
	$MobTimer.start()

## Adds 1 to score
func _on_addScore():
	score += 1
	$HUD.update_score(score)

## Creates a mob
func _on_MobTimer_timeout():
	# Choose a random location on Path2D.
	$MobSpawn/SpawnLocation.set_offset(randi())
	# Create a Mob instance and add it to the scene.
	var mob = ColorMob.instance()
	add_child(mob)
	# Set the mob's direction perpendicular to the path direction.
	var direction = $MobSpawn/SpawnLocation.rotation + PI / 2
	# Set the mob's position to a random location.
	mob.position = $MobSpawn/SpawnLocation.position
	# Add some randomness to the direction.
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
	# Set the velocity (speed & direction).
	mob.linear_velocity = Vector2(rand_range(mob.min_speed + score, mob.max_speed + score), 0)
	mob.linear_velocity = mob.linear_velocity.rotated(direction)
	# Gives mob signal to be gone upon new game
	self.connect("gameOver", mob, "_on_gameOver")
	# Lowers Mob Timer
	$MobTimer.wait_time = max(MIN_TIME_BETWEEN_SPAWN, $MobTimer.wait_time * MOB_TIME_FACTOR)
	# Adds score when the mob signals for it
	mob.connect("addScore", self, "_on_addScore")



## When a player is hit
func _on_Player_hit():
	## Decrease lives
	lives = lives - 1
	$HUD.update_lives(lives)
	## Check for game over
	if lives == 0:
		game_over()
