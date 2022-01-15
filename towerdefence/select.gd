extends Control
onready var tween = get_node("Tween")
onready var colorrect = get_node("KinematicBody2D/ColorRect")
onready var quitter = get_node("ConfirmationDialog")
var x = 0
var y = 0

func _ready():
	colorrect.visible = 0

func _process(_delta):
	var mos_pos = get_global_mouse_position()
	x = int(mos_pos[0]/96)*96
	y = int(mos_pos[1]/96)*96
	if x/96>9: x=9*96
	if x/96<0: x=0
	if y/96>5: y=5*96
	if y/96<0: y=0
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		colorrect.rect_position = Vector2(x,y)
		tween.interpolate_property(colorrect,"modulate",Color(1,1,1,0.75),Color(1,1,1,0.4),1,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		colorrect.visible = 1
	if (Input.is_action_just_pressed("fullscreen")):
		OS.window_fullscreen = false
		quitter.popup()

func _on_ConfirmationDialog_confirmed():
	get_tree().change_scene("res://EcranTitre.tscn");
