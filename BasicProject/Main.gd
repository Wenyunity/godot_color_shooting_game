extends Node

export (PackedScene) var ColorMob
var score

# Time between mob spawns is multiplied by this number
const MOB_TIME_FACTOR = 0.999

# Minimum time between mob spawns
const MIN_TIME_BETWEEN_SPAWN = 0.1

# Called when the node enters the scene tree for the first time.
func _ready():
	## Randomizes RNG seed
	randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func game_over():
	$MobTimer.stop()
	$HUD.show_game_over()

func new_game():
	score = 0
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	$Path2D/PathFollow2D/Player.start()
	$StartTimer.start()


func _on_StartTimer_timeout():
	$MobTimer.wait_time = 1
	$MobTimer.start()


func _on_addScore():
	score += 1
	$HUD.update_score(score)

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
	$HUD.connect("start_game", mob, "_on_start_game")
	# Lowers Mob Timer
	$MobTimer.wait_time = max(MIN_TIME_BETWEEN_SPAWN, $MobTimer.wait_time * MOB_TIME_FACTOR)
	mob.connect("addScore", self, "_on_addScore")


