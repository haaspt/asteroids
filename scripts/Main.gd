extends Node2D

const Bullet = preload("res://scenes/Bullet.tscn")
const Asteroid = preload("res://scenes/Asteroid.tscn")

var score
var game_started
var game_is_paused

func _ready():
	randomize()
	game_started = false
	game_is_paused = false

func new_game():
	get_tree().call_group("spawnable", "queue_free")
	resume_game()
	score = 0
	$HUD.update_score(score)
	$Player.start($PlayerStartPosition.position)
	game_started = true
	
func game_over():
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
	
func _process(delta):
	if Input.is_action_pressed("ui_cancel") and game_started:
		pause_game()

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
	
	var asteroid = Asteroid.instance()
	add_child(asteroid)
	asteroid.start(asteroid_position, direction)
	asteroid.connect("destroyed", self, "_on_Asteroid_destroyed")
	
func _on_Asteroid_destroyed():
	score += 1
	$HUD.update_score(score)
	

