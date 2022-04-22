extends Control
signal suppression_rocher
onready var tween = get_node("Tween")
onready var colorrect = get_node("ColorRect")
onready var quitter = get_node("ConfirmationDialog")
onready var tilemap = get_node("TileMap")
onready var popup_menu = get_node("PopupMenu")
onready var cible = get_node("Cible")
export var Rocher = preload("res://Rocher.tscn")
export var Ennemi = preload("res://Ennemi.tscn")
onready var Score = get_node("Energie/Label")
onready var Vie = get_node("Label")
onready var Game_over = get_node("ConfirmationDialog2")
var pos_ennemi = 1
var x = 0
var y = 0
var menu_ouvert = 0
var placement = null
var vitesse = 200
enum PopupIds {
	Catapulte = 21
	Champ = 22
	Maison = 19
	Suppression = 0
}
onready var Variables = get_node("/root/Variables")

func _ready():
	Variables.Ressources = 1000
	#Variables.Champs = 1
	colorrect.visible = false
	popup_menu.add_item("Catapulte", PopupIds.Catapulte)
	popup_menu.add_item("Champ", PopupIds.Champ)
	popup_menu.add_item("Maison", PopupIds.Maison)
	popup_menu.add_item("Suppression", PopupIds.Suppression)

func _process(_delta):
	var mos_pos = get_global_mouse_position()
	#mouvement curseur
	x = int(mos_pos[0]/96)*96
	y = int(mos_pos[1]/96)*96
	if x/96>9: x=9*96
	if x/96<0: x=0
	if y/96>5: y=5*96
	if y/96<0: y=0
	if Input.is_mouse_button_pressed(BUTTON_LEFT) and menu_ouvert == 0 or Input.is_mouse_button_pressed(BUTTON_RIGHT):
		colorrect.rect_position = Vector2(x,y)
		tween.interpolate_property(colorrect,"modulate",Color(1,1,1,0.75),Color(1,1,1,0.4),1,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		colorrect.visible = 1
	if Input.is_mouse_button_pressed(BUTTON_RIGHT):
		#menu popup
		popup_menu.popup(Rect2(mos_pos.x,mos_pos.y,popup_menu.rect_size.x,popup_menu.rect_size.y))
		placement = mos_pos
		menu_ouvert = 1
	#boite de dialogue enlever fullscreen
	if (Input.is_action_just_pressed("fullscreen")):
		OS.window_fullscreen = false
		quitter.popup()
	if (Input.is_action_just_pressed("cheat")):
		Variables.Ressources += 10000
		Score.text = str(Variables.Ressources)
	spawn_ennemi()
	if Variables.Vie_chateau <= 0:
		Game_over.popup()

#quitter
func _on_ConfirmationDialog_confirmed():
	get_tree().change_scene("res://EcranTitre.tscn")

func _on_PopupMenu_id_pressed(id):
	menu_ouvert = 0
#	var mos_pos = get_global_mouse_position()
	#colision curseur-tilemap
	var tile_pos = tilemap.world_to_map(Vector2(placement.x/3,placement.y/3))
	var cell = tilemap.get_cellv(tile_pos)
	if id == 21:
		#catapulte
		if cell == 8 and Variables.Ressources>=500:
			tilemap.set_cellv(tile_pos, 21)
			var r = Rocher.instance()
			add_child(r)
			cible.global_position = Vector2(tile_pos.x*96-192,tile_pos.y*96-96)
			r.position = cible.global_position
			Variables.Ressources -= 500
			Score.text = str(Variables.Ressources)
	if id == 22:
		if cell == 8 and Variables.Ressources>=250:
			tilemap.set_cellv(tile_pos, 22)
			Variables.Ressources -= 250
			Variables.Champs += 1
			Score.text = str(Variables.Ressources)
	if id == 19:
		if cell == 8:
			tilemap.set_cellv(tile_pos, 19)
			Variables.Ressources -= 250
			Variables.Vie_chateau += 100
			Score.text = str(Variables.Ressources)
			Vie.text = str(Variables.Vie_chateau)
	if id == 0:
		if cell == 21:
			tilemap.set_cellv(tile_pos, 8)
			Variables.Position_of_the_caillou = Vector2(tile_pos.x*96-192,tile_pos.y*96-96)
			emit_signal("suppression_rocher")
		if cell == 22:
			tilemap.set_cellv(tile_pos, 8)
			Variables.Champs -= 1
		if cell == 19:
			tilemap.set_cellv(tile_pos, 8)
			Variables.Vie_chateau -= 100
			Vie.text = str(Variables.Vie_chateau)

func spawn_ennemi():
	var random = RandomNumberGenerator.new()
	random.randomize()
	var spawn = random.randi_range(0,vitesse)
	if spawn == 1:
		var ennemi = Ennemi.instance()
		add_child(ennemi)
		ennemi.global_position = Vector2(48,240)

func _on_PopupMenu_popup_hide():
	menu_ouvert = 0

func _on_ConfirmationDialog2_confirmed():
	get_tree().change_scene("res://partie.tscn")
	Variables.Vie_chateau = 500

func _on_Timer_timeout():
	vitesse /= 2
	$Timer.start()
