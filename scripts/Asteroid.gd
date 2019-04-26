extends Area2D

signal destroyed

export (int) var min_rotation = 180
export (int) var max_rotation = 200
export (float) var rotation_speed = 1.0
export (int) var speed = 100
var screen_size
var velocity = Vector2(100, 0)
var screen_buffer = 8

var motion = Vector2(1, 0)

func _ready():
	screen_size = get_viewport_rect().size
	hide()
	
func start(pos, dir):
	position = pos
	rotation = rand_range(min_rotation, max_rotation)
	motion = motion.rotated(dir)
	show()
	
func _process(delta):
	position += motion * speed * delta
	
	rotation_degrees += rotation_speed
	
	position.x = wrapf(position.x, -screen_buffer, screen_size.x + screen_buffer)
	position.y = wrapf(position.y, -screen_buffer, screen_size.y + screen_buffer)

func _on_Asteroid_body_entered(body):
	if body.get_name() == "Bullet":
		body.queue_free()
		queue_free()
		emit_signal("destroyed")
