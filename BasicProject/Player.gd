extends Area2D

# Bullets
export (PackedScene) var Blue
export (PackedScene) var Green
export (PackedScene) var Red

# Which bullets can be fired
var red_firable
var blue_firable
var green_firable

# Is the player invincible?
var invincible

# Cooldown for bullets
var num_cooldown

# Cooldown if firing one type of bullet
var COOLDOWN_PENALTY = 0.1

# Signal when getting hit
signal hit

# Signals to move along path
signal offsetUp
signal offsetDown
signal offsetUpOff
signal offsetDownOff

# Size of the screen
var screen_size
# How fast the player moves (pixels/sec)
var speed

# How fast bullets move (pixels/sec)
var BULLET_SPEED = 400

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	# Will be able to move at 1/20th the screen size
	speed = max(screen_size.y, screen_size.x) / 5
	hide()

# Acts every frame
func _process(delta):
	if visible:
		## Left and right for rotation
		if Input.is_action_pressed("ui_right"):
			rotation_degrees += 5
		if Input.is_action_pressed("ui_left"):
			rotation_degrees -= 5
		## Up and down for movement along path
		if Input.is_action_just_pressed("ui_down"):
			emit_signal("offsetDown")
		if Input.is_action_just_pressed("ui_up"):
			emit_signal("offsetUp")
		if Input.is_action_just_released("ui_down"):
			emit_signal("offsetDownOff")
		if Input.is_action_just_released("ui_up"):
			emit_signal("offsetUpOff")
		## Z/X/C (or other buttons) for firing red/green/blue bullets
		if Input.is_action_pressed("ui_accept"):
			if red_firable:
				fire_bullet(Red)
				num_cooldown += COOLDOWN_PENALTY
				$RedTime.start(num_cooldown)
				red_firable = false
		if Input.is_action_pressed("ui_cancel"):
			if blue_firable:
				fire_bullet(Blue)
				num_cooldown += COOLDOWN_PENALTY
				$BlueTime.start(num_cooldown)
				blue_firable = false
		if Input.is_action_pressed("ui_select"):
			if green_firable:
				fire_bullet(Green)
				num_cooldown += COOLDOWN_PENALTY
				$GreenTime.start(num_cooldown)
				green_firable = false



# Fires bullet
func fire_bullet(bullet):
	# Create a bullet instance and add it to the scene.
	var spawn = bullet.instance()
	get_tree().root.add_child(spawn)
	# Set the bullet's direction the same as the player's
	spawn.rotation = global_rotation
	# Set the mob's position to the player's.
	spawn.position = global_position
	# Set the velocity (speed & direction).
	spawn.linear_velocity = Vector2(BULLET_SPEED, 0)
	spawn.linear_velocity = spawn.linear_velocity.rotated(global_rotation)

## Function called on game start
func start():
	show()
	## Let weapons be firable
	red_firable = true
	green_firable = true
	blue_firable = true
	## Invincibility off
	invincible = false
	num_cooldown = 0
	$CollisionShape2D.disabled = false

## Function called when hit
func _on_Player_body_entered(body):
	## If not in invincibility frames then hit
	if !invincible:
		emit_signal("hit")
		## Gain invincibility for a second
		invincible = true
		$DamageTime.start()

## function called when game over
func _on_gameOver():
	hide()
	$CollisionShape2D.set_deferred("disabled", true)

## Delay for red bullet
func _on_RedTime_timeout():
	red_firable = true
	num_cooldown -= COOLDOWN_PENALTY

## Delay for blue bullet
func _on_BlueTime_timeout():
	blue_firable = true
	num_cooldown -= COOLDOWN_PENALTY

## Delay for green bullet
func _on_GreenTime_timeout():
	green_firable = true
	num_cooldown -= COOLDOWN_PENALTY

## Damage delay
func _on_DamageTime_timeout():
	invincible = false
