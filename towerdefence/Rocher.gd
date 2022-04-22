extends Area2D
var speed = 3
var once = 0
var disparait = 0
var vecteur = null
onready var Ennemi = get_node_or_null("/root/Control/Ennemi")
onready var Rocher = self
onready var Cible = get_node("../Cible")
onready var pos_depart = null
onready var Ennemis = get_tree().get_nodes_in_group("Ennemis")
onready var Score = get_node("/root/Control/Energie/Label")
onready var Variables = get_node("/root/Variables")
onready var Control = get_node("/root/Control")

func _ready():
	if is_instance_valid(Control):
		Control.connect("suppression_rocher", self, "suppresion_signal_recieved")

func suppresion_signal_recieved():
	if pos_depart == Variables.Position_of_the_caillou:
		queue_free()

func _physics_process(_delta):
	if Ennemi==null:
		Ennemi = get_node_or_null("/root/Control/Ennemi")
	if is_instance_valid(Ennemi) and disparait==0:
		if once == 0:
			pos_depart = Vector2(Rocher.global_position.x,Rocher.global_position.y)
			once = 1
		vecteur = Ennemi.global_position-Vector2(Rocher.global_position.x+192+48,Rocher.global_position.y+96+48)
#		if vecteur.x>-200 and vecteur.x<200 and vecteur.y>-100 and vecteur.y<100:
#			print(vecteur, self)
#			position += speed*vecteur.normalized()
		position += speed*vecteur.normalized()
	else:
		#Ennemi = get_node_or_null("/root/Control/Ennemi")
		if vecteur != null:
			position += speed*vecteur.normalized()
	if global_position.x<0-192-48 or global_position.y<0-96-48 or global_position.y>590:
		Rocher.position = pos_depart
		disparait = 1
		vecteur = null
		$Caillou.visible = true
		set_deferred("monitoring",true)
		set_deferred("monitorable",true)
		$Timer.start()

func _on_Rocher_area_entered(Ennemi):
	if Ennemi.is_in_group("Ennemis"):
		Ennemi.queue_free()
		$Caillou.visible = false
		set_deferred("monitoring",false)
		set_deferred("monitorable",false)
		disparait = 1
		Ennemi = get_node_or_null("/root/Control/Ennemi")
		Variables.Ressources += 10*Variables.Champs
		Score.text = str(Variables.Ressources)
		vecteur = null
	else:
		Ennemi = get_node_or_null("/root/Control/Ennemi")
		pass

func _on_Timer_timeout():
	Ennemi = get_node_or_null("/root/Control/Ennemi")
	if disparait == 1:
		Rocher.position = pos_depart
		vecteur = null
		$Caillou.visible = true
		set_deferred("monitoring",true)
		set_deferred("monitorable",true)
		disparait = 0
	$Timer.start()

#func _notification(what):
#	if what == MainLoop.NOTIFICATION_CRASH:
#		pass
