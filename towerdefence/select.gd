extends Control
onready var tween = get_node("Tween")
onready var colorrect = get_node("ColorRect")
onready var quitter = get_node("ConfirmationDialog")
onready var tilemap = get_node("TileMap")
onready var popup_menu = get_node("PopupMenu")
onready var cible = get_node("Cible")
export var Rocher = preload("res://Rocher.tscn")
export var Ennemi = preload("res://Ennemi.tscn")
var pos_ennemi = 1
var x = 0
var y = 0
enum PopupIds {
	Catapulte = 21
}

func _ready():
	colorrect.visible = 0
	popup_menu.add_item("Catapulte", PopupIds.Catapulte)

func _process(_delta):
	var mos_pos = get_global_mouse_position()
	#mouvement curseur
	x = int(mos_pos[0]/96)*96
	y = int(mos_pos[1]/96)*96
	if x/96>9: x=9*96
	if x/96<0: x=0
	if y/96>5: y=5*96
	if y/96<0: y=0
	if Input.is_mouse_button_pressed(BUTTON_LEFT) or Input.is_mouse_button_pressed(BUTTON_RIGHT):
		colorrect.rect_position = Vector2(x,y)
		tween.interpolate_property(colorrect,"modulate",Color(1,1,1,0.75),Color(1,1,1,0.4),1,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		colorrect.visible = 1
	if Input.is_mouse_button_pressed(BUTTON_RIGHT):
		#menu popup
		popup_menu.popup(Rect2(mos_pos.x,mos_pos.y,popup_menu.rect_size.x,popup_menu.rect_size.y))
	#boite de dialogue enlever fullscreen
	if (Input.is_action_just_pressed("fullscreen")):
		OS.window_fullscreen = false
		quitter.popup()
	spawn_ennemi()

#quitter
func _on_ConfirmationDialog_confirmed():
	get_tree().change_scene("res://EcranTitre.tscn");

func _on_PopupMenu_id_pressed(id):
	print(id)
	var mos_pos = get_global_mouse_position()
	#colision curseur-tilemap
	var tile_pos = tilemap.world_to_map(Vector2(x/3,y/3))
	var cell = tilemap.get_cellv(tile_pos)
	print(tile_pos, cell, mos_pos, x, y)
	if id == 21:
		#catapulte
		if cell == 8:
			tilemap.set_cellv(tile_pos, 21)
			var r = Rocher.instance()
			add_child(r)
			cible.global_position = Vector2(tile_pos.x*96-192,tile_pos.y*96-96)
			r.position = cible.global_position
			print(r.position)

func spawn_ennemi():
	var random = RandomNumberGenerator.new()
	random.randomize()
	var spawn = random.randi_range(0,100)
	if spawn == 5:
		var ennemi = Ennemi.instance()
		add_child(ennemi)
		ennemi.global_position = Vector2(pos_ennemi*96-48,240)
		pos_ennemi += 1
