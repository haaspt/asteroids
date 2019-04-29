extends Particles2D

func spawn(spawn_location: Vector2):
	position = spawn_location
	
func _process(delta):
	if not emitting:
		queue_free()