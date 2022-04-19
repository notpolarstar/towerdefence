extends Area2D
var speed = 5
var once = 0
var disparait = 0
var vecteur = null
onready var Ennemi = get_node_or_null("/root/Control/Ennemi")
onready var Rocher = self
onready var Cible = get_node("../Cible")
onready var pos_depart = null
onready var Ennemis = get_tree().get_nodes_in_group("Ennemis")

func _physics_process(delta):
	if Ennemi==null:
		Ennemi = get_node_or_null("/root/Control/Ennemi")
	if is_instance_valid(Ennemi):
		if once == 0:
			pos_depart = Vector2(Rocher.global_position.x,Rocher.global_position.y)
			once = 1
		vecteur = Ennemi.global_position-Vector2(Rocher.global_position.x+192+48,Rocher.global_position.y+96+48)
		position += speed*vecteur.normalized()
	else:
		if vecteur != null:
			position += speed*vecteur.normalized()
	if global_position.x<0-192-48 or global_position.y<0-96-48:
		Rocher.position = pos_depart
		$Caillou.visible = true
		set_deferred("monitoring",true)
		set_deferred("monitorable",true)
		$Timer.start()

func _on_Rocher_area_entered(Ennemi):
	print(str('Body entered: ', Ennemi.get_name()))
	if Ennemi.is_in_group("Ennemis"):
		Ennemi.queue_free()
		$Caillou.visible = false
		set_deferred("monitoring",false)
		set_deferred("monitorable",false)
		disparait = 1
		Ennemi = get_node_or_null("/root/Control/Ennemi")
	else:
		Ennemi = get_node_or_null("/root/Control/Ennemi")
		pass

func _on_Timer_timeout():
	Ennemi = get_node_or_null("/root/Control/Ennemi")
	if disparait == 1:
		Rocher.position = pos_depart
		disparait = 0
	$Caillou.visible = true
	set_deferred("monitoring",true)
	set_deferred("monitorable",true)
	$Timer.start()

func _notification(what):
	if what == MainLoop.NOTIFICATION_CRASH:
		pass
