extends Area2D

signal hit

export (int) var turn_speed = 180
export (int) var move_speed = 150

const ACC = 0.05
const DEC = 0.01

var motion = Vector2(0,0)

var screen_size: Vector2
var screen_buffer = 8

func _ready():
	screen_size = get_viewport_rect().size
	hide()

func _process(delta):
	if Input.is_action_pressed("ui_left"):
		rotation_degrees -= turn_speed * delta
	if Input.is_action_pressed("ui_right"):
		rotation_degrees += turn_speed * delta
		
	var movedir = Vector2(1,0).rotated(rotation)
	
	if Input.is_action_pressed("ui_up"):
		motion = motion.linear_interpolate(movedir, ACC)
		$Sprite.frame = 1
	else:
		motion = motion.linear_interpolate(Vector2(0,0), DEC)
		$Sprite.frame = 0
		
	position += motion * move_speed * delta
	
	# Screen wrap
	position.x = wrapf(position.x, -screen_buffer, screen_size.x + screen_buffer)
	position.y = wrapf(position.y, -screen_buffer, screen_size.y + screen_buffer)
	

func _on_Player_body_entered(body):
	hide()
	emit_signal("hit")
	$CollisionShape2D.call_deferred("set_disabled", true)
