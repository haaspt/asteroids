extends KinematicBody2D

export (int) var speed = 200
var velocity: Vector2
onready var screen_size = get_viewport_rect().size
const screen_buffer = 8

func _ready():
	$CollisionShape2D.disabled = true
	hide()
	

func start(pos: Vector2, rot: float):
	rotation = rot
	position = pos
	velocity = Vector2(speed, 0).rotated(rotation)
	$CollisionShape2D.disabled = false
	show()
	
func _physics_process(delta: float):
	move_and_collide(velocity * delta)
	position.x = wrapf(position.x, -screen_buffer, screen_size.x + screen_buffer)
	position.y = wrapf(position.y, -screen_buffer, screen_size.y + screen_buffer)

func _on_LifetimeTimer_timeout():
	queue_free()
