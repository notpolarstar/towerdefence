extends Control
func _ready():
	print("test")
func _on_Nouvellepartie_pressed():
	get_tree().change_scene("res://partie.tscn");
