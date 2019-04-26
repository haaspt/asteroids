extends KinematicBody2D

export (int) var max_speed = 400
var screen_size: Vector2

func _ready():
	screen_size = get_viewport_rect().size
	
func _process(delta):
	