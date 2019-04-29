extends CanvasLayer

signal resume
signal restart
signal exit

func _ready():
	$MainMenuPanel.hide()

func _on_MenuResume_pressed():
	emit_signal("resume")

func _on_MenuRestart_pressed():
	emit_signal("restart")

func _on_MenuQuit_pressed():
	emit_signal("exit")
