extends KinematicBody2D

export (int) var speed = 200
var velocity: Vector2
var screen_size: Vector2
var screen_buffer = 8

func _ready():
	screen_size = get_viewport_rect().size
	hide()

func start(pos: Vector2, rot: float):
	rotation = rot
	position = pos
	velocity = Vector2(speed, 0).rotated(rotation)
	
func _physics_process(delta: float):
	move_and_collide(velocity * delta)
	position.x = wrapf(position.x, -screen_buffer, screen_size.x + screen_buffer)
	position.y = wrapf(position.y, -screen_buffer, screen_size.y + screen_buffer)

func _on_LifetimeTimer_timeout():
	queue_free()
