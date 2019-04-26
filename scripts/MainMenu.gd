extends CanvasLayer

signal resume
signal restart

func _ready():
	$MainMenuPanel.hide()

func _on_MenuResume_pressed():
	emit_signal("resume")

func _on_MenuRestart_pressed():
	emit_signal("restart")
