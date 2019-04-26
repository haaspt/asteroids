extends Node2D

var score

func new_game():
	score = 0
	$HUD.update_score(score)
	$Player.start($PlayerStartPosition.position)