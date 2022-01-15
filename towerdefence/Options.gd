extends Control
onready var options = get_node("ConfirmationDialog")

func _on_Options_pressed():
	options.popup()

func _on_ConfirmationDialog_confirmed():
	OS.window_fullscreen = !OS.window_fullscreen

func _process(_delta):
	if (Input.is_action_just_pressed("fullscreen")):
		OS.window_fullscreen = false
