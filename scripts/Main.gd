extends Node2D

const Bullet = preload("res://scenes/Bullet.tscn")
const AsteroidBig = preload("res://scenes/AsteroidBig.tscn")
const AsteroidMedium = preload("res://scenes/AsteroidMedium.tscn")
const AsteroidSmall = preload("res://scenes/AsteroidSmall.tscn")
const Explosion = preload("res://scenes/Explosion.tscn")

var asteroid_type_lookup = {
	"big": {
		"entity": AsteroidBig,
		"score_value": 1,
		"number_spawned": 1,
		"child_type": "medium"},
	"medium": {
		"entity": AsteroidMedium,
		"score_value": 2,
		"number_spawned": 2,
		"child_type": "small"},
	"small": {
		"entity": AsteroidSmall,
		"score_value": 4,
		"number_spawned": 3,
		"child_type": null}
	}

var score: int
var game_started: bool
var game_is_paused: bool

func _ready():
	randomize()
	game_started = false
	game_is_paused = false

func new_game():
	get_tree().call_group("spawnable", "queue_free")
	$SpawnTimer.start()
	resume_game()
	score = 0
	$HUD.update_score(score)
	$Player.start($PlayerStartPosition.position)
	game_started = true
	
func game_over():
	$sfx/PlayerExplosionStream.play()
	_spawn_explosion($Player.global_position)
	$HUD.display_game_over()
	game_is_paused = true
	game_started = false
	get_tree().paused = true
	
func pause_game():
	game_is_paused = true
	get_tree().paused = game_is_paused
	$MainMenu/MainMenuPanel.visible = game_is_paused
	
func resume_game():
	game_is_paused = false
	get_tree().paused = game_is_paused
	$MainMenu/MainMenuPanel.visible = game_is_paused

func exit_game():
	get_tree().quit()
	
func _process(delta: float):
	if Input.is_action_pressed("ui_cancel") and game_started:
		pause_game()
		
func _spawn_explosion(location: Vector2) -> Particles2D:
	var explosion = Explosion.instance()
	add_child(explosion)
	explosion.spawn(location)
	return explosion
	
func _spawn_asteroids(type: String, location: Vector2, direction: float):
	if type == "big":
		var asteroid = AsteroidBig.instance()
		add_child(asteroid)
		asteroid.start(location, direction)
		asteroid.connect("destroyed", self, "_on_Asteroid_destroyed")
	else:
		var n_to_spawn = asteroid_type_lookup[type]["number_spawned"]
		var type_to_spawn = asteroid_type_lookup[type]["entity"]
		for i in range(n_to_spawn):
			var random_direction = rand_range(0, 2 * PI)
			var new_asteroid = type_to_spawn.instance()
			add_child(new_asteroid)
			new_asteroid.start(location, random_direction)
			new_asteroid.connect("destroyed", self, "_on_Asteroid_destroyed")

func _on_Player_did_shoot(pos: Vector2, rot: float):
	var bullet = Bullet.instance()
	add_child(bullet)
	bullet.start(pos, rot)
	bullet.show()

func _on_SpawnTimer_timeout():
	$AsteroidPath/AsteroidSpawnLocation.set_offset(randi())
	var asteroid_position = $AsteroidPath/AsteroidSpawnLocation.position
	var direction = $AsteroidPath/AsteroidSpawnLocation.rotation + PI / 2
	direction += rand_range(-PI / 4, PI / 4)
	
	# Spawn large asteroid
	call_deferred("_spawn_asteroids", "big", asteroid_position, direction)
	
func _on_Asteroid_destroyed(location: Vector2, direction: float, type: String):
	score += asteroid_type_lookup[type]["score_value"]
	_spawn_explosion(location)
	if asteroid_type_lookup[type]["child_type"]:
		call_deferred("_spawn_asteroids", asteroid_type_lookup[type]["child_type"], location, direction)
	$sfx/AsteroidExplosionStream.play()
	$HUD.update_score(score)
	

