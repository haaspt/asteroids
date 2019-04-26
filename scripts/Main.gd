extends Node2D

export (PackedScene) var Bullet

var score

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
