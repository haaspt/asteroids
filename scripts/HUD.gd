extends CanvasLayer

signal start_game

func _ready():
	$MessageLabel.hide()

func update_score(score):
	$ScoreLabel.text = str(score)
	
func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()
	
func display_game_over():
	show_message("GAME OVER!")
	yield($MessageTimer, "timeout")
	$StartButton.show()

func _on_StartButton_pressed():
	$StartButton.hide()
	emit_signal("start_game")


func _on_MessageTimer_timeout():
	$MessageLabel.hide()
