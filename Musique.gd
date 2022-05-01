extends Control
onready var options = get_node("ConfirmationDialog")

func _on_Options_pressed():
	options.popup()

func _on_ConfirmationDialog_confirmed():
	Variables.Volume = !Variables.Volume
