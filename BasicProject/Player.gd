extends Area2D

# Bullets
export (PackedScene) var Blue
export (PackedScene) var Green
export (PackedScene) var Red

signal hit
signal offsetUp
signal offsetDown
signal offsetUpOff
signal offsetDownOff

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

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
		if Input.is_action_pressed("ui_right"):
			rotation_degrees += 5
		if Input.is_action_pressed("ui_left"):
			rotation_degrees -= 5
		if Input.is_action_just_pressed("ui_down"):
			emit_signal("offsetDown")
		if Input.is_action_just_pressed("ui_up"):
			emit_signal("offsetUp")
		if Input.is_action_just_released("ui_down"):
			emit_signal("offsetDownOff")
		if Input.is_action_just_released("ui_up"):
			emit_signal("offsetUpOff")
		if Input.is_action_just_pressed("ui_accept"):
			fire_bullet(Red)
		if Input.is_action_just_pressed("ui_cancel"):
			fire_bullet(Blue)
		if Input.is_action_just_pressed("ui_select"):
			fire_bullet(Green)

# Old Process
func _old_process(delta):
	# If visible, so not shooting when dead
	if visible:
		# Then do this stuff
		var velocity = Vector2()  # The player's movement vector.
		if Input.is_action_pressed("ui_right"):
			rotation_degrees += 5
		if Input.is_action_pressed("ui_left"):
			rotation_degrees -= 5
		if Input.is_action_pressed("ui_down"):
			velocity.y += 1
		if Input.is_action_pressed("ui_up"):
			velocity.y -= 1
		if Input.is_action_just_pressed("ui_accept"):
			fire_bullet(Red)
		if Input.is_action_just_pressed("ui_cancel"):
			fire_bullet(Blue)
		if Input.is_action_just_pressed("ui_select"):
			fire_bullet(Green)
		
		## Movement and clamping
		position += velocity * delta * speed
		position.x = clamp(position.x, 0, screen_size.x)
		position.y = clamp(position.y, 0, screen_size.y)
	
	## Sprite Rotation
#	if velocity.x != 0:
#		$AnimatedSprite.animation = "right"
#		$AnimatedSprite.flip_v = false
#		# See the note below about boolean assignment
#		$AnimatedSprite.flip_h = velocity.x < 0
#	elif velocity.y != 0:
#		$AnimatedSprite.animation = "up"
#		$AnimatedSprite.flip_v = velocity.y > 0

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
    $CollisionShape2D.disabled = false

## Function called when hit
func _on_Player_body_entered(body):
	hide()  # Player disappears after being hit.
	emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled", true)
