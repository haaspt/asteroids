extends RigidBody2D

export (int) var min_rotation = 180
export (int) var max_rotation = 200

var screen_size
var velocity = Vector2(100, 0)
var screen_buffer = 8

func _ready():
	screen_size = get_viewport_rect().size
	hide()
	
func start(pos, dir):
	position = pos
	rotation = rand_range(min_rotation, max_rotation)
	linear_velocity = Vector2(100, 0)
	linear_velocity = linear_velocity.rotated(rotation)
	show()
	
func _physics_process(delta):
	position.x = wrapf(position.x, -screen_buffer, screen_size.x + screen_buffer)
	position.y = wrapf(position.y, -screen_buffer, screen_size.y + screen_buffer)

func _on_Asteroid_body_entered(body):
	print(body.get_name())
