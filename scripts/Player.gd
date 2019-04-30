extends Area2D

signal hit
signal did_shoot(pos, rot)

export (int) var turn_speed = 180
export (int) var move_speed = 150

const ACC = 0.05
const DEC = 0.01

var motion = Vector2(0,0)

onready var screen_size = get_viewport_rect().size
const screen_buffer = 8

func _ready():
	$Sprite.hide()
	
func start(pos: Vector2):
	position = pos
	motion = Vector2(0, 0)
	$Sprite.show()
	$CollisionShape2D.disabled = false

func _process(delta: float):
	if Input.is_action_pressed("ui_left"):
		rotation_degrees -= turn_speed * delta
	if Input.is_action_pressed("ui_right"):
		rotation_degrees += turn_speed * delta
		
	var movedir := Vector2(1,0).rotated(rotation)
	
	if Input.is_action_pressed("ui_up"):
		motion = motion.linear_interpolate(movedir, ACC)
		$Sprite.frame = 1
	else:
		motion = motion.linear_interpolate(Vector2(0,0), DEC)
		$Sprite.frame = 0
		
	if Input.is_action_pressed("ui_accept"):
		if $GunCooldownTimer.time_left == 0:
			emit_signal("did_shoot", $GunbarrelLocation.global_position, rotation)
			$GunCooldownTimer.start()
		
	position += motion * move_speed * delta
	
	# Screen wrap
	position.x = wrapf(position.x, -screen_buffer, screen_size.x + screen_buffer)
	position.y = wrapf(position.y, -screen_buffer, screen_size.y + screen_buffer)
	

func _on_Player_area_entered(area: Node):
	$Sprite.hide()
	emit_signal("hit")