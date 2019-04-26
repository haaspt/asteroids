extends Node2D

export (PackedScene) var Bullet

var score

func _ready():
	randomize()

func new_game():
	score = 0
	$HUD.update_score(score)
	$Player.start($PlayerStartPosition.position)
	
func game_over():
	$HUD.display_game_over()

func _on_Player_did_shoot(pos, rot):
	var bullet = Bullet.instance()
	add_child(bullet)
	bullet.start(pos, rot)
	bullet.show()

func _on_SpawnTimer_timeout():
	$AsteroidPath/AsteroidSpawnLocation.set_offset(randi())
	var asteroid_position = $AsteroidPath/AsteroidSpawnLocation.position
	var direction = $AsteroidPath/AsteroidSpawnLocation.rotation + PI / 2
	direction += rand_range(-PI / 4, PI / 4)
	
	var asteroid = preload("res://scenes/Asteroid.tscn").instance()
	add_child(asteroid)
	asteroid.start(asteroid_position, direction)
	asteroid.connect("destroyed", self, "_on_Asteroid_destroyed")
	
func _on_Asteroid_destroyed():
	score += 1
	$HUD.update_score(score)
	

